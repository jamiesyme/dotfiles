#pragma once

typedef struct Hub Hub;


Hub* newHub();

void freeHub(Hub* hub);

int runHub(Hub* hub);


// Functions below are thread-safe
void stopHub(Hub* hub);

void showHubModules(Hub* hub);

void hideHubModules(Hub* hub);
