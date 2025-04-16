# Development


---
## Package description

Package configuration : `pyproject.toml` file

Packaging and publication tools :

- Build frondent :`build`
- Build Backend : `SetupTool`
- Publication tool : `Twine`


File structure :

- model.py : 4Dvarnet Model
- plot.py : plot function


---
## Package creation 

- Create Python virtual Environment
``` bash
python3 -m venv --prompt ocean4dvarnet venv
source venv/bin/activate
```
- "Frontend Builder" installation : `build`
``` bash
pip install build
```
- Package creation 
``` bash
python -m build
# ...
# Successfully built ocean4dvarnet-0.0.1.tar.gz and ocean4dvarnet-0.0.1-py3-none-any.whl
```

---
## Using Package in development mode

- Check Package
``` bash
ls  dist
# ocean4dvarnet-0.0.1-py3-none-any.whl  ocean4dvarnet-0.0.1.tar.gz
```  
- Install package in deployment mode ("editable")
``` bash
pip install -e .
# Successfully installed  ... ocean4dvarnet-0.0.1 ...
# certifi-2025.1.31 cftime-1.6.4.post1 netcdf4-1.7.2 numpy-2.2.3 ocean4dvarnet-0.0.1 pandas-2.2.3 python-dateutil-2.9.0.post0 pytz-2025.1 six-1.17.0 tzdata-2025.1 xarray-2025.1.2
``` 
- Check Package
``` bash
pip show ocean4dvarnet
# Name: ocean4dvarnet
# Version: 0.0.1
# Summary: a computer program whose purpose is to apply deep learning schemes to dynamical systems and ocean remote sensing data.
# Home-page: 
# Author: 
# Author-email: Ronan Fablet <ronan.fablet@imt-atlantique.fr>, Quentin Febvre <quentin.febvre@ifremer.fr>, Pierre Haslee <author@example.com>, DanieL Zhu <daniel.zhu@imt-atlantique.fr>, Hugo Georgenthum <hugo.georgenthum@imt-atlantique.fr>, Braux Emmanuel <emmanuel.braux@imt-atlantique.fr>
# License: 
# Location: /home/ ... /ocean4dvarnet/venv/lib/python3.12/site-packages
# Editable project location: /home/ ... /ocean4dvarnet
# Requires: netcdf4, numpy, pandas, xarray
# Required-by: 
```
- Uninstall Package
``` bash
pip uninstall ocean4dvarnet
```


---
## Package Publication

The project has been created on [https://test.pypi.org/](https://test.pypi.org/), as `ocean4dvarnet`, with th module `twine`. 

To update the project, you need token with the correct rights, on test.pypi.org.

To create a new version of the package, you need to modifiy the `pyproject.tom` file.


- `twine` module installation
``` bash
pip install twine
```
- Check package before upload
``` bash
twine check dist/*
# Checking dist/ocean4dvarnet-0.0.1-py3-none-any.whl: PASSED
# Checking dist/ocean4dvarnet-0.0.1.tar.gz: PASSED
```
- Configure a token with the project modification rights
``` bash
export PYPI_TOKEN="pypi-AgENdGVz ....."
```
- Update the project
``` bash
twine upload --repository testpypi -p "$PYPI_TOKEN"   dist/*
# Uploading distributions to https://test.pypi.org/legacy/
# Uploading ocean4dvarnet-0.0.1-py3-none-any.whl
# 100% ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 27.2/27.2 kB • 00:00 • 43.2 MB/s
# Uploading ocean4dvarnet-0.0.1.tar.gz
# 100% ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 27.2/27.2 kB • 00:00 • 48.6 MB/s
# View at:
# https://test.pypi.org/project/ocean4dvarnet/0.0.1/
```



---
## Additional information

### Package creation on test.pypi.org

Before running these command, you need to have created an account on Test.pypi.org, and a token with "global rights"

- `twine`module installation
``` bash
pip install twine
```
- Check package before upload
``` bash
twine check dist/*
# Checking dist/ocean4dvarnet-0.0.1-py3-none-any.whl: PASSED
# Checking dist/ocean4dvarnet-0.0.1.tar.gz: PASSED
```
- Configure a twine with the PyPI global Token 
``` bash
export PYPI_TOKEN="pypi-AgENdGVz ....."
```
- Create the project
``` bash
twine upload \
  --verbose \
  --repository testpypi \
  -p "$PYPI_TOKEN" \
  dist/*

# Uploading distributions to https://test.pypi.org/legacy/
# Uploading ocean4dvarnet-0.0.1-py3-none-any.whl
# Uploading ocean4dvarnet-0.0.1.tar.gz
# View at:
# https://test.pypi.org/project/ocean4dvarnet/0.0.1/
```



