#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <ctype.h> // Include ctype.h for toupper

#define INITIAL_BUFFER_SIZE 1000000
#define MAX_LINE_LENGTH 1000000

typedef struct {
    char *name;
    char *sequence;
} Chromosome;

typedef struct {
    char *name;
    char *sequence;
    char *target;
    int start;
    int end;
    int max_mismatch;
    FILE *output_file;
} ThreadData;

void reverse_complement(char *seq, int len) {
    for (int i = 0; i < len / 2; ++i) {
        char tmp = seq[i];
        seq[i] = seq[len - i - 1];
        seq[len - i - 1] = tmp;
    }
    for (int i = 0; i < len; ++i) {
        switch (seq[i]) {
            case 'A': seq[i] = 'T'; break;
            case 'T': seq[i] = 'A'; break;
            case 'C': seq[i] = 'G'; break;
            case 'G': seq[i] = 'C'; break;
        }
    }
}

Chromosome *read_fasta(const char *filename, int *num_chromosomes) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("Error opening file");
        return NULL;
    }

    size_t buffer_size = INITIAL_BUFFER_SIZE;
    char *genome_sequence = malloc(buffer_size);
    if (!genome_sequence) {
        perror("Error allocating memory");
        fclose(file);
        return NULL;
    }

    size_t total_read = 0;
    char line[MAX_LINE_LENGTH];
    Chromosome *chromosomes = NULL;
    int chromosome_count = 0;

    while (fgets(line, sizeof(line), file)) {
        if (line[0] == '>') {
            if (chromosome_count > 0) {
                chromosomes[chromosome_count - 1].sequence = strndup(genome_sequence, total_read);
                total_read = 0;
            }
            line[strcspn(line, "\r\n")] = '\0';
            Chromosome new_chromosome;
            new_chromosome.name = strdup(line + 1);
            chromosomes = realloc(chromosomes, (chromosome_count + 1) * sizeof(Chromosome));
            chromosomes[chromosome_count++] = new_chromosome;
        } else {
            size_t line_len = strlen(line);
            if (line[line_len - 1] == '\n') {
                line_len--;
                line[line_len] = '\0';
            }
            if (total_read + line_len + 1 > buffer_size) {
                buffer_size *= 2;
                genome_sequence = realloc(genome_sequence, buffer_size);
                if (!genome_sequence) {
                    perror("Error reallocating memory");
                    fclose(file);
                    return NULL;
                }
            }
            // Convert the sequence to uppercase
            for (size_t i = 0; i < line_len; ++i) {
                genome_sequence[total_read + i] = toupper(line[i]);
            }
            total_read += line_len;
            genome_sequence[total_read] = '\0'; // Null-terminate the string
        }
    }
    fclose(file);

    if (chromosome_count > 0) {
        chromosomes[chromosome_count - 1].sequence = strndup(genome_sequence, total_read);
    }

    free(genome_sequence);
    *num_chromosomes = chromosome_count;
    return chromosomes;
}

void *find_mismatches(void *arg) {
    ThreadData *data = (ThreadData *)arg;
    char *sequence = data->sequence;
    char *chromosome_name = data->name;
    char *target = data->target;
    int start = data->start;
    int end = data->end;
    int max_mismatch = data->max_mismatch;
    FILE *output_file = data->output_file;

    int target_len = strlen(target);

    for (int i = start; i <= end - target_len; ++i) {
        int mismatch = 0;
        for (int j = 0; j < target_len; ++j) {
            if (sequence[i + j] != target[j]) {
                mismatch++;
            }
        }
        if (mismatch <= max_mismatch) {
            fprintf(output_file, "Chromosome: %s, Position: %d, Mismatches: %d, Strand: +, Sequence: %.*s, Target: %s\n", chromosome_name, i + 1, mismatch, target_len, sequence + i, target);
        }

        char rev_comp[target_len + 1];
        strncpy(rev_comp, sequence + i, target_len);
        rev_comp[target_len] = '\0';
        reverse_complement(rev_comp, target_len);

        mismatch = 0;
        for (int j = 0; j < target_len; ++j) {
            if (rev_comp[j] != target[j]) {
                mismatch++;
            }
        }
        if (mismatch <= max_mismatch) {
            fprintf(output_file, "Chromosome: %s, Position: %d, Mismatches: %d, Strand: -, Sequence: %s, Target: %s\n", chromosome_name, i + 1, mismatch, rev_comp, target);
        }
    }

    pthread_exit(NULL);
}

int main(int argc, char *argv[]) {
    if (argc != 6) {
        fprintf(stderr, "Usage: %s <fasta_file> <target_sequence> <max_mismatch> <output_file> <num_threads>\n", argv[0]);
        return 1;
    }

    char *filename = argv[1];
    char *target_sequence = argv[2];
    int max_mismatch = atoi(argv[3]);
    char *output_filename = argv[4];
    int num_threads = atoi(argv[5]);

    int num_chromosomes;
    Chromosome *chromosomes = read_fasta(filename, &num_chromosomes);
    if (!chromosomes) {
        return 1;
    }

    FILE *output_file = fopen(output_filename, "w");
    if (!output_file) {
        perror("Error opening output file");
        return 1;
    }

    pthread_t *threads = malloc(num_threads * sizeof(pthread_t));
    ThreadData *thread_data = malloc(num_threads * sizeof(ThreadData));

    for (int i = 0; i < num_chromosomes; ++i) {
        printf("Processing Chromosome: %s\n", chromosomes[i].name);
        int sequence_len = strlen(chromosomes[i].sequence);
        int segment_length = sequence_len / num_threads;

        for (int t = 0; t < num_threads; ++t) {
            thread_data[t].name = chromosomes[i].name;
            thread_data[t].sequence = chromosomes[i].sequence;
            thread_data[t].target = target_sequence;
            thread_data[t].start = t * segment_length;
            thread_data[t].end = (t == num_threads - 1) ? sequence_len : (t + 1) * segment_length;
            thread_data[t].max_mismatch = max_mismatch;
            thread_data[t].output_file = output_file;
            pthread_create(&threads[t], NULL, find_mismatches, (void *)&thread_data[t]);
        }

        for (int t = 0; t < num_threads; ++t) {
            pthread_join(threads[t], NULL);
        }
    }

    fclose(output_file);

    for (int i = 0; i < num_chromosomes; ++i) {
        free(chromosomes[i].name);
        free(chromosomes[i].sequence);
    }
    free(chromosomes);
    free(threads);
    free(thread_data);

    return 0;
}
