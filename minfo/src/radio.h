#pragma once

typedef struct Hub Hub;
typedef struct Radio Radio;


Radio* newRadio();

void freeRadio(Radio* radio);

void runRadio(Radio* radio, Hub* hub);
