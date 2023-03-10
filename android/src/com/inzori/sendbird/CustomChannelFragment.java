package com.inzori.sendbird;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.ViewModelProvider;

import com.sendbird.android.channel.GroupChannel;
import com.sendbird.uikit.fragments.ChannelFragment;
import com.sendbird.uikit.modules.ChannelModule;
import com.sendbird.uikit.modules.components.ChannelHeaderComponent;
import com.sendbird.uikit.vm.ChannelViewModel;
import com.sendbird.uikit.widgets.MessageInputView;

/**
 * Implements the customized <code>ChannelFragment</code>.
 */
public class CustomChannelFragment extends ChannelFragment {
    @NonNull
    @Override
    protected ChannelModule onCreateModule(@NonNull Bundle args) {
        ChannelModule module = super.onCreateModule(args);
        return module;
    }



    @Override
    protected void onBindChannelHeaderComponent(@NonNull ChannelHeaderComponent headerComponent, @NonNull ChannelViewModel viewModel, @Nullable GroupChannel channel) {
        super.onBindChannelHeaderComponent(headerComponent, viewModel, channel);

    }
}
