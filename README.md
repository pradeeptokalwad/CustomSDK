Steps to create Framework

1. Create Project 

. Goto Target -> Click on + Icon -> Select Cocoa Touch Framework -> Select Language as Objective-C

3. Add your classes and functionality in framework 

4. Add all required header files in in Public folder of framework in Build Settings -> Header file section because by default access for files is within project scope only but we need out off project so we need to change scope to Public

5. Once you done with moving files to Public folder then all these classes will be accessible in your another project.

6. Now You need import all classes which we need to access in framework in Default Framework Header file “Framework-Name.h” file

7. Now Your framework is ready to use, you can share and use in another project 

8. But now you can not run on actual device because this framework is only compatible for Simulator so we need to make it universal.

9. Add Aggregated Target and Run script so we can make framework universal for all devices and Simulator.

10. Add Your framework in “Aggregated target” Dependency.


You may face these Errors :-

	1.	Reason:- Image not found 
	⁃	Goto Project -> General settings -> Embedded Framework -> Add your framework 
	⁃	Reason :- Because dynamic framework needs to embed in the the project.
	2.	Symbol not found for the architecture arm(XX)
	⁃	This error occur because framework is only developer for particular Architecture and we are running on different architecture so to solve this problem we need to make our Framework Universal Architecture 
	⁃	To make it universal we need to “aggregated target”
	⁃	Using “LIPO” we can create universal Framework so we need to write run script in LIPO. 
	⁃	


This is run script :- 

FRAMEWORK_NAME="CustomFramework"

SIMULATOR_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}.framework"

DEVICE_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework"

DEVICE_BCSYMBOLMAP_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos"

DEVICE_DSYM_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework.dSYM"
SIMULATOR_DSYM_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}.framework.dSYM"

UNIVERSAL_LIBRARY_DIR="${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal"

FRAMEWORK="${UNIVERSAL_LIBRARY_DIR}/${FRAMEWORK_NAME}.framework"

OUTPUT_DIR="./CustomFramework-Aggregated"
Xcodebuild -project ${PROJECT_NAME}.Xcodeproj -scheme ${FRAMEWORK_NAME} -sdk iphonesimulator -configuration ${CONFIGURATION} clean install CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator
Xcodebuild -project ${PROJECT_NAME}.Xcodeproj -scheme ${FRAMEWORK_NAME} -sdk iphoneos -configuration ${CONFIGURATION} clean install CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphoneos
rm -rf "${UNIVERSAL_LIBRARY_DIR}"

mkdir "${UNIVERSAL_LIBRARY_DIR}"

mkdir "${FRAMEWORK}"

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"
cp -r "${DEVICE_LIBRARY_PATH}/." "${FRAMEWORK}"
lipo "${SIMULATOR_LIBRARY_PATH}/${FRAMEWORK_NAME}" "${DEVICE_LIBRARY_PATH}/${FRAMEWORK_NAME}" -create -output "${FRAMEWORK}/${FRAMEWORK_NAME}" | echo
cp -r "${FRAMEWORK}" "$OUTPUT_DIR"
cp -r "${DEVICE_DSYM_PATH}" "$OUTPUT_DIR"
lipo -create -output "$OUTPUT_DIR/${FRAMEWORK_NAME}.framework.dSYM/Contents/Resources/DWARF/${FRAMEWORK_NAME}" \
"${DEVICE_DSYM_PATH}/Contents/Resources/DWARF/${FRAMEWORK_NAME}" \
"${SIMULATOR_DSYM_PATH}/Contents/Resources/DWARF/${FRAMEWORK_NAME}" || exit 1
UUIDs=$(dwarfdump --uuid "${DEVICE_DSYM_PATH}" | cut -d ' ' -f2)
for file in `find "${DEVICE_BCSYMBOLMAP_PATH}" -name "*.bcsymbolmap" -type f`; do
fileName=$(basename "$file" ".bcsymbolmap")
for UUID in $UUIDs; do
if [[ "$UUID" = "$fileName" ]]; then
cp -R "$file" "$OUTPUT_DIR"
dsymutil --symbol-map "$OUTPUT_DIR"/"$fileName".bcsymbolmap "$OUTPUT_DIR/${FRAMEWORK_NAME}.framework.dSYM"
fi
done
done

