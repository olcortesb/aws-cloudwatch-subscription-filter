#!/bin/bash

# Script para crear los archivos ZIP de las lambdas

echo "Building Lambda packages..."

# Crear directorio temporal
mkdir -p build

# Empaquetar Controller Lambda
echo "Packaging Controller Lambda..."
cp src/controller_lambda.py build/index.py
cd build
zip -r ../controller_lambda.zip index.py
rm index.py
cd ..

# Empaquetar Processor Lambda
echo "Packaging Processor Lambda..."
cp src/processor_lambda.py build/index.py
cd build
zip -r ../processor_lambda.zip index.py
rm index.py
cd ..

# Limpiar directorio temporal
rmdir build

echo "Lambda packages created successfully!"
echo "- controller_lambda.zip"
echo "- processor_lambda.zip"