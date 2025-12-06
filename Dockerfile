FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=nonineteractive
RUN apt update && \
    echo "tzdata tzdata/Areas select America" | debconf-set-selections && \
    echo "tzdata tzdata/Zones/America select Chicago" | debconf-set-selections && \
    apt-get install -y tzdata
RUN apt install -y software-properties-common python3 python3-pip npm python3-requests python3-click
RUN apt install -y libgtk2.0-dev openctm-tools
RUN add-apt-repository --yes ppa:kicad/kicad-7.0-releases
RUN apt update
RUN apt-get install -y --install-recommends kicad
RUN npm install -g easyeda2kicad
RUN git clone https://github.com/yaqwsx/EasyEDAFootprintScraper.git
RUN sed -i 's/BOM_Supplier Part/Supplier Part/g' EasyEDAFootprintScraper/fetchComponent.py
RUN sed -i \
    's/footprint.Reference().SetPosition(refPos)/footprint.Reference().SetPosition(pcbnew.VECTOR2I(refPos[0], refPos[1]))/g' \
    EasyEDAFootprintScraper/fetchComponent.py
RUN sed -i \
    's/footprint.Value().SetPosition(valuePos)/footprint.Value().SetPosition(pcbnew.VECTOR2I(valuePos[0], valuePos[1]))/g' \
    EasyEDAFootprintScraper/fetchComponent.py

WORKDIR EasyEDAFootprintScraper
ENTRYPOINT ["/usr/bin/python3", "fetchComponent.py"]
