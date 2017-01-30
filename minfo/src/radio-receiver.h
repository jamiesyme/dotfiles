#pragma once

typedef struct Hub Hub;
typedef struct RadioMsg RadioMsg;

void runRadio(Hub* hub);

void sendRadioMsg(RadioMsg msg);
