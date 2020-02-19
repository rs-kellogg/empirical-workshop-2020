from setuptools import setup, find_packages

setup(
    name='python-template',
    version='0.1.1',
    author='Will Thompson',
    author_email='wkt@northwestern.edu',
    maintainer='Will Thompson',
    maintainer_email='wkt@northwestern.edu',
    description='Python template project',
    url='https://github.com/rs-kellogg/empirical-workshop-2020/tree/master/7-bulletproof',
    packages=find_packages(include=['kelloggrs', 'kelloggrs.*']),
    include_package_data=True
)
