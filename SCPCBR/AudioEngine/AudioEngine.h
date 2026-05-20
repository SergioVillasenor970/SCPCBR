#ifndef AUDIOENGINE_H
#define AUDIOENGINE_H

#include <string>

// #include <FMOD/fmod.hpp>

namespace AudioEngine {
    void Init();
    
    void RunCallbacks();

    void LoadSoundByName(const std::string& name, unsigned int mode, void* exInfo = nullptr);
    void* PlaySoundByName(const std::string& name, void* group = nullptr, bool paused = false);

    bool IsSoundPlaying(void* channel);
    void StopSound(void* channel);

    void CreateChannelGroup(const std::string& name);
    void* GetChannelGroup(const std::string& name);

    void SetChannelGroupVolume(const std::string& name, float volume);
    float GetChannelGroupVolume(const std::string& name);

    void Free();
};

#endif // AUDIOENGINE_H