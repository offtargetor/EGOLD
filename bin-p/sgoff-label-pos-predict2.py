import pandas as pd
import numpy as np
import sys
from joblib import load
import xgboost as xgb

# 读取CSV文件
model_path = sys.argv[1]
input_file = sys.argv[2]  # 输入文件路径
output_file = sys.argv[3]  # 输出文件路径

# 加载数据
data = pd.read_csv(input_file, sep="\t")

# 选择特征（与训练时保持一致）
features = data[['p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8', 'p9',
                 'p10', 'p11', 'p12', 'p13', 'p14', 'p15', 'p16', 'p17', 'p18', 'p19', 'p20', 'p21', 'p22', 'p23', 'total',
                 'ma', 'mb', 'mc', 'md', 'me', 'mf', 'mpam', 'paa', 'pat', 'pac', 'pag', 'pba', 'pbt', 'pbc', 'pbg', 'pca', 'pct', 'pcc', 'pcg', 'gc', 'pbcaa', 'pbcat', 'pbcac', 'pbcag', 'pbcta', 'pbctt', 'pbctc', 'pbctg', 'pbcca',
                 'pbcct', 'pbccc', 'pbccg', 'pbcga', 'pbcgt', 'pbcgc', 'pbcgg', 'identity', 'score']].copy()
features.fillna(features.mean(), inplace=True)

# 将特征数据转换为 NumPy 数组
features_np = features.to_numpy()

# 加载训练好的模型
model = load(f'{model_path}')


# 使用模型进行预测
predictions = model.predict(features_np)
probabilities = model.predict_proba(features_np)[:, 1]

# 将预测结果转换为脱靶(1)和不脱靶(0)
predictions_binary = (predictions == 1).astype(int)

# 将预测结果保存到文件中
output_df = data.copy()
output_df['predictions'] = predictions_binary
output_df['probabilities'] = probabilities

# 保存预测结果
output_df.to_csv(output_file, sep="\t", index=False)

print(f"Predictions saved to {output_file}")
