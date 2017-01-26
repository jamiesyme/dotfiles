#pragma once

typedef struct Hub Hub;


Hub* newHub();

void freeHub(Hub* hub);

int runHub(Hub* hub);


// Functions below are thread-safe
void showModules(Hub* hub);

void hideModules(Hub* hub);
