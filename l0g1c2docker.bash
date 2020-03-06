#!/bin/bash
# l0g1c2docker.bash


tar -czf ../../L0G1C101.tar.gz ../../L0G1C101/
docker cp ../../L0G1C101.tar.gz core101:/opt/L0G1C101.tar.gz
rm ../../L0G1C101.tar.gz

# Compiles and executes in docker container
echo "Iniciando el contenedor"
docker start core101
echo "Compilando Core101"
docker exec core101 bash -c "cd /opt/L0G1C101/Core101; make; cd /"
echo "Simulando"
docker exec core101 bash -c "./opt/L0G1C101/Core101/obj_dir/VCore101_top"
echo "Deteniendo contenedor"
docker stop core101
