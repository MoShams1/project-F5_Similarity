import matplotlib.pyplot as plt
from matplotlib import rc
import matplotlib_venn as venn

# Average over bins 9-20
# n_exe = 40
# n_obs = 22
# n_exeobs = 13

# change the default font type and size
rc('font', serif='Helvetica')
plt.rcParams.update({'font.size': 8})
# Note: in venn2, "subsets" get the the size of each ara
fig = plt.figure(figsize=(1.5, 1.5))
venn.venn2(subsets=(40 - 13, 22 - 13, 13), set_labels=('Exe', 'Obs'))
venn.venn2_circles(subsets=(40 - 13, 22 - 13, 13))
plt.savefig('venn_diagram.pdf')
