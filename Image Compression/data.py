import pandas as pd
import seaborn as sns
import io

import matplotlib.pyplot as plt

def plot_compression_results():
   """
   Parses image compression performance data and plots PSNR vs. Non-Zero Coefficients.
   """
   # Data provided by the user
   csv_data = """Image,Quality,PSNR_dB,NonZeros
   monarch,60,33.17,13325
   monarch,25,29.89,8444
   monarch,5,23.76,3003
   cameraman,60,32.56,11058
   cameraman,25,29.16,6145
   cameraman,5,24.11,1993
   parrots,60,35.52,8697
   parrots,25,32.28,5148
   parrots,5,25.97,1933
   forest,60,30.54,17627
   forest,25,27.97,10139
   forest,5,23.35,2244
   """

   # Read the data into a pandas DataFrame
   df = pd.read_csv(io.StringIO(csv_data))

   # Set the plot style
   sns.set_theme(style="whitegrid")

   # Create the plot
   plt.figure(figsize=(10, 6))
   
   # Use seaborn to create a line plot with markers
   # This shows the trade-off between quality (PSNR) and sparsity (NonZeros)
   ax = sns.lineplot(
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
   ax.set_title("Image Compression Performance: PSNR vs. Sparsity", fontsize=16)
   ax.set_xlabel("Number of Non-Zero Coefficients", fontsize=12)
   ax.set_ylabel("Peak Signal-to-Noise Ratio (PSNR) in dB", fontsize=12)

   # Improve legend
   plt.legend(title="Image", fontsize=10)
   
   # Ensure tight layout and display the plot
   plt.tight_layout()
   plt.show()

if __name__ == '__main__':
   plot_compression_results()