---
jupytext:
  cell_metadata_filter: -all
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.11.5
kernelspec:
  display_name: Python 3
  language: python
  name: python3
substitutions:
  Nibabel: "[Nibabel](https://nipy.org/nibabel/)"
  Nilearn: "[Nilearn](https://nilearn.github.io/)"
---

# Neuroimaging data

```{code-cell}
:tags: [hide-input]
import warnings
warnings.filterwarnings("ignore")
```

## Introduction

Neuroimaging is the use of quantitative (computational) techniques to scientifically study the brain in a non-invasive manner. There are two broad categories neuroimaging:

-  Structural imaging to quantify brain structure (e.g {term}`MRI`)

```{figure} ../images/slices.png
---
height: 150px
---
Example {term}`MRI` image
```

- Functional imaging, which is used to study brain function (e.g {term}`PET`, {term}`fMRI`, {term}`MEG`)

```{figure} ../images/slices_pet.png
---
height: 150px
---
Example {term}`PET` image
```

## Data formats

DICOM (`.dcm`) and NIfTi (`.nii`or `.nii.gz` if gzipped)  are data formats for storing medical images (raw data) along with meta-data in the form of a header. 

### DICOM

DICOM is the sandard file type used for most medical imaging devices ({term}`MRI`? CT, {term}`PET`, etc..) The acronym stands for Digital Imaging and COmmunication in Medicine. DICOM is designed to be transferred and stored with PACS. More information can be found on their [webpage](https://www.dicomstandard.org/about).

### NIfTI

The Neuroimaging Informatics Technology Initiative (NIfTI) is an open file format commonly used to store brain imaging data obtained using Magnetic Resonance Imaging methods.

### What is in the header of a NIFTI file?

We can use `fslinfo` to look at the header of a `nifti` files. 

```
data_type      FLOAT32 # The decimal precision of the data
dim1           166 # Number of voxels in the x-dimension (i.e left-to-right)
dim2           256 # Number of voxels in the y-dimension (i.e front-to-back)
dim3           256 # Number of voxels in the z-dimension (i.e bottom-to-top)
dim4           1 # Number of time-points (volumes concatenated in times series)
datatype       16 
pixdim1        1.206401 # Size of each voxel in the x-dimension, in mm
pixdim2        0.936387 # Size of each voxel in the y-dimension, in mm
pixdim3        0.940964 # Size of each voxel in the z-dimension, in mm
pixdim4        1.000000 # Size of the time-step (time to acquire each volume)
cal_max        0.0000 #  used for mapping dataset values to display colors
cal_min        0.0000 # ""
file_type      NIFTI-1+
```

### Differences

The raw image data in a NIfTI file is saved as a single 3d image, whereas in DICOM, we have several 2d image slices. NifTi only contains a small subset of the metadata information contained in DICOMs. It is easier for machine learning applications and analyzis to use NIfTi over DICOM

## Visualization

For the visualization of {term}`MRI` data, you can use the tools embedded in neuroimaging software:

- FreeSurfer (freeview)
- MRtrix (mrview)
- FSL (fsleyes).

For visualization of {term}`PET` images:

- Vinci (also works with {term}`MRI`) 

Commong alternatives found on App Store: BrainView (visualization of segmented T1 images) or MRICro (viewer for nifti data).

### Visualization in Python

In addition, some Python packages like {{ Nilearn }} provide plotting modules to quickly look at your images without exiting Python.

Example of code for plotting an anatomical image in {{ Nilearn }}:

```{code-cell}
from nilearn import datasets, plotting

# Download some data using the datasets module
haxby_dataset = datasets.fetch_haxby(data_dir=".")

# Plot the anatomical image
plotting.plot_anat(haxby_dataset.anat[0], title="plot_anat")
```

You can also plot statistical maps:

```{code-cell}
# Download some statistical map from neurovault
motor_images = datasets.fetch_neurovault_motor_task()
stat_img = motor_images.images[0]

# Plot it with a threshold
plotting.plot_stat_map(
    stat_img, threshold=3,
    title="plot_stat_map",
    cut_coords=[36, -27, 66],
)
```

And visualize them in an interactive way using the ``view_*`` familly of functions:

```{code-cell}
view = plotting.view_img(stat_img, threshold=3)
view
```


## Image Processing

### Resampling

@TODO
 Resampling and images is changing the resolution and/or dimensions of an image. Images are composed of voxels (three dimensional equivalent of a pixel). Voxels are caled isotropic if all dimensions are of equal lengths, otherwise, they are said to be anisotropic.
 
 When resampling we can make the dimensions of the voxels either shorter (to achieve higher resolution) or longer (for lower-resolution images). Resampling is then a numeric approach to reduce or enhace the resolution through approximation algorithms.

 For {term}`MRI` data, each voxel is associated with a number which represents the intensity of the signal measured at that voxel.

Example of image resampling in Python:

```{code-cell}
from nilearn import image

# Download the MNI152 template
template = datasets.load_mni152_template()
print(f"Template shape = {template.shape}\nTemplate affine = {template.affine}")

# The image has a different shape and affine
tmap_img = image.load_img(stat_img)
print(f"original shape = {tmap_img.shape}\noriginal_affine = {tmap_img.affine}")

# Resample the image to the MNI152 template
resampled_stat_img = image.resample_to_img(stat_img, template)
print(f"resampled shape = {resampled_stat_img.shape}\nresampled affine = {resampled_stat_img.affine}")
```

For a full example of how to resample an image to a template, please refer to this [Nilearn tutorial](https://nilearn.github.io/stable/auto_examples/06_manipulating_images/plot_resample_to_template.html#sphx-glr-auto-examples-06-manipulating-images-plot-resample-to-template-py).

### Normalizing

@TODO

Each person's brain is different. When performing neuroimaging studies, it is important to normalize across subjects to adjust the overall size and orientation of images

### Tools 

#### Nibabel

A very powerful python-based tool to access neuro-imaging data (`.nii`, `.dcm` etc.) stored on our file system is {{ Nibabel }}.

You can easilly install the latest release of {{ Nibabel }} using `pip`:

```
pip install nibabel 
```

Example of reading a nifti image using {{ Nibabel }}:

```{code-cell}
import nibabel as nib

data = nib.load("./haxby2001/subj2/anat.nii.gz")

# We have access to the image data 
print(data.shape)
print(data.affine)
```

#### Nilearn

{{ Nilearn }} is a Python package providing statistical and machine-learning tools to enable analyses of brain volumes. It also provides plotting capabilities and limited support to surface-based analysis.

In the ``0.7.0``release of {{ Nilearn }}, the [Nistats](https://nistats.github.io) package was merged within {{ Nilearn }} such that it now supports general linear model (GLM) based analysis and leverages the scikit-learn Python toolbox for multivariate statistics with applications such as predictive modelling, classification, decoding, or connectivity analysis.

You can easilly install the latest release of {{ Nilearn }} using `pip`:

```
pip install nilearn
```

### Neuro-imaging softwares

A list of neuro-imaging software commonly used in the lab can be found [here](https://aramislab.paris.inria.fr/clinica/docs/public/latest/Third-party/#pipeline-specific-interfaces)
