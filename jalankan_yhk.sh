#!/bin/bash
cd /Users/adhiitmuh/Documents/yhk-app
echo "Starting YHK Produksi..."
open http://localhost:5001
python3 -c "import sys; sys.path.insert(0,'/Users/adhiitmuh/Documents/yhk-app'); from app import app; app.run(port=5001,debug=False)"
