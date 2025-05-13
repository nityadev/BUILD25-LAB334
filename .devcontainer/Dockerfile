FROM mcr.microsoft.com/devcontainers/python:3.12-bookworm

COPY requirements.txt .
RUN pip install -r requirements.txt \    
    && pip install keyrings.alt ipython ipykernel mkdocs-material

RUN ipython kernel install --name "python3" --user
