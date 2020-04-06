FROM python:3.8-slim
RUN pip install --no-cache-dir matplotlib pandas jupyter
RUN mkdir src
WORKDIR /src/notebooks
COPY . .

ONBUILD RUN virtualenv /env && /env/bin/pip install -r /src/requirements.txt

EXPOSE 8888
CMD ["nginx", "-g", "daemon off;"]

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["jupyter2", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]

