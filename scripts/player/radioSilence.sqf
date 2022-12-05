if (!isMultiplayer) exitWith {};

waitUntil {
	!isNull (findDisplay 46)
};

player setSpeaker "NoVoice";
enableSentences false;
enableRadio false;
player disableConversation true;

