import pandas as pd
import seaborn as sns
import io

import matplotlib.pyplot as plt

def plot_compression_results():
   """
   Parses image compression performance data and plots:
   1. PSNR vs. Non-Zero Coefficients
   2. PSNR vs. Quality
   """
   # Data provided by the user
   csv_data = """Image,Quality,PSNR_dB,NonZeros
monarch,90,40.03,25320
monarch,80,36.17,18413
monarch,70,34.33,15284
monarch,60,33.17,13325
monarch,50,32.33,12028
monarch,40,31.50,10722
monarch,30,30.50,9327
monarch,20,29.13,7513
monarch,10,26.64,4954
monarch,5,23.76,3003
monarch,1,15.42,505
cameraman,90,39.97,23673
cameraman,80,35.79,16394
cameraman,70,33.82,13083
cameraman,60,32.56,11058
cameraman,50,31.64,9665
cameraman,40,30.77,8359
cameraman,30,29.76,6955
cameraman,20,28.44,5303
cameraman,10,26.24,3274
cameraman,5,24.11,1993
cameraman,1,16.72,427
parrots,90,41.42,18811
parrots,80,38.23,12738
parrots,70,36.58,10256
parrots,60,35.52,8697
parrots,50,34.71,7672
parrots,40,33.92,6733
parrots,30,32.91,5755
parrots,20,31.48,4513
parrots,10,28.82,2993
parrots,5,25.97,1933
parrots,1,17.18,421
forest,90,42.56,39491
forest,80,33.01,23375
forest,70,31.44,22734
forest,60,30.54,17627
forest,50,29.80,15715
forest,40,29.20,13897
forest,30,28.44,11551
forest,20,27.35,8583
forest,10,25.41,4586
forest,5,23.35,2244
forest,1,16.77,569
"""

   # Read the data into a pandas DataFrame
   df = pd.read_csv(io.StringIO(csv_data))

   # Set the plot style
   sns.set_theme(style="whitegrid")

   # --- Plot 1: PSNR vs. Sparsity ---
   plt.figure(figsize=(10, 6))
   
   # Use seaborn to create a line plot with markers
   ax1 = sns.lineplot(
      data=df,
      x="NonZeros",
      y="PSNR_dB",
      hue="Image",
      style="Image",
      markers=True,
      dashes=False,
      markersize=8,
      linewidth=2
   )

   # Set plot title and labels
   ax1.set_title("Image Compression Performance: PSNR vs. Sparsity", fontsize=16)
   ax1.set_xlabel("Number of Non-Zero Coefficients", fontsize=12)
   ax1.set_ylabel("Peak Signal-to-Noise Ratio (PSNR) in dB", fontsize=12)
   plt.legend(title="Image", fontsize=10)
   plt.tight_layout()

   # --- Plot 2: PSNR vs. Quality ---
   plt.figure(figsize=(10, 6))

   # Use seaborn to create a line plot with markers
   ax2 = sns.lineplot(
      data=df,
      x="Quality",
      y="PSNR_dB",
      hue="Image",
      style="Image",
      markers=True,
      dashes=False,
      markersize=8,
      linewidth=2
   )

   # Set plot title and labels
   ax2.set_title("Image Compression Performance: PSNR vs. Quality", fontsize=16)
   ax2.set_xlabel("Quality", fontsize=12)
   ax2.set_ylabel("Peak Signal-to-Noise Ratio (PSNR) in dB", fontsize=12)
   plt.legend(title="Image", fontsize=10)
   plt.tight_layout()
   
   # Display both plots
   plt.show()

if __name__ == '__main__':
   plot_compression_results()