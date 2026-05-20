#include "AudioEngine.h"

#include <unordered_map>

// FMOD support disabled for MinGW compatibility
// #include <FMOD/fmod.hpp>
// #include <FMOD/fmod_errors.h>

#include "../Util/Util.h"

std::unordered_map<std::string, void*> LoadedSounds;
std::unordered_map<std::string, void*> ChannelGroups;

void* System = NULL;

void AudioEngine::Init() {
    // FMOD initialization disabled - FMOD libraries not available for MinGW
}

void AudioEngine::RunCallbacks() {
    // FMOD callbacks disabled
}

void AudioEngine::LoadSoundByName(const std::string& name, unsigned int mode, void* exInfo) {
    // FMOD disabled
}

void* AudioEngine::PlaySoundByName(const std::string& name, void* group, bool paused) {
    return nullptr;
}

bool AudioEngine::IsSoundPlaying(void* channel) {
    return false;
}

void AudioEngine::StopSound(void* channel) {
    // FMOD disabled
}

void AudioEngine::CreateChannelGroup(const std::string& name) {
    // FMOD disabled
}

void* AudioEngine::GetChannelGroup(const std::string& name) {
    return nullptr;
}

void AudioEngine::SetChannelGroupVolume(const std::string& name, float volume) {
    // FMOD disabled
}

float AudioEngine::GetChannelGroupVolume(const std::string& name) {
    return 1.0f;
}

void AudioEngine::Free() {
    // FMOD disabled
}
