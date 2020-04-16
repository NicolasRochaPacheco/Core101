#!/bin/bash
# l0g1c2docker.bash

# Compress files and copy them inside Docker container
tar -czf ../../L0G1C101.tar.gz ../../L0G1C101/
docker cp ../../L0G1C101.tar.gz core101:/opt/L0G1C101.tar.gz
rm ../../L0G1C101.tar.gz

# Compiles and executes in docker container
echo "Iniciando el contenedor"
docker start core101
echo "Extracting files inside container"
docker exec core101 bash -c "rm -r /opt/L0G1C101"
docker exec core101 bash -c "tar -xf /opt/L0G1C101.tar.gz -C /opt/"
echo "Compilando Core101"
docker exec core101 bash -c "cd /opt/L0G1C101/Core101; make; cd /"
echo "Simulando"
docker exec core101 bash -c "./opt/L0G1C101/Core101/obj_dir/VCore101_top"
echo "Deleting obj_dir for Core101"
docker exec core101 bash -c "rm -r /opt/L0G1C101/Core101/obj_dir"
echo "Copying output file"
docker cp core101:/output_data.txt ./out/output_data.txt
echo "Deteniendo contenedor"
docker stop core101
