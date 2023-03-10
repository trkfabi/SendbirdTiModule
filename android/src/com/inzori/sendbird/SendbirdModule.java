/**
 * This file was auto-generated by the Titanium Module SDK helper for Android
 * TiDev Titanium Mobile
 * Copyright TiDev, Inc. 04/07/2022-Present
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */
package com.inzori.sendbird;


import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.titanium.TiApplication;
import org.appcelerator.kroll.common.Log;

import android.content.Intent;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.sendbird.uikit.SendbirdUIKit;
import com.sendbird.uikit.activities.adapter.MessageListAdapter;
import com.sendbird.uikit.activities.viewholder.MessageType;
import com.sendbird.uikit.activities.viewholder.MessageViewHolder;
import com.sendbird.uikit.activities.viewholder.MessageViewHolderFactory;
import com.sendbird.uikit.adapter.SendbirdUIKitAdapter;
import com.sendbird.uikit.databinding.SbViewAdminMessageBinding;
import com.sendbird.uikit.activities.ChannelActivity;
import com.sendbird.uikit.fragments.ChannelFragment;
import com.sendbird.uikit.fragments.UIKitFragmentFactory;
import com.sendbird.uikit.interfaces.UserInfo;
import com.sendbird.android.SendbirdChat;
import com.sendbird.android.handler.InitResultHandler;
import com.sendbird.android.handler.DisconnectHandler;
import com.sendbird.android.exception.SendbirdException;
import com.sendbird.android.channel.GroupChannel;
import com.sendbird.uikit.model.MessageListUIParams;
import com.sendbird.android.channel.BaseChannel;
import com.sendbird.android.message.BaseMessage;

import java.util.Map;

	// Removes right settings icon
class CustomFragmentFactory extends UIKitFragmentFactory {

	// TODO : Override the methods that create the fragment you wish to customize.
	private static final String LCAT = "SendbirdModule";
	@Override
	public ChannelFragment newChannelFragment(@NonNull String channelUrl, @NonNull Bundle args) {
		// TODO : Return the customized `ChannelFragment` here.
		// You can send data from activity to the custom fragment through `Bundle`.

		final CustomChannelFragment fragment = new CustomChannelFragment();
		return new ChannelFragment.Builder(channelUrl)
				.setCustomFragment(fragment)
				.setUseHeaderRightButton(false)
//				.setOnHeaderLeftButtonClickListener(new View.OnClickListener() {
//					@Override
//					public void onClick(View v) {
//						// Execute your function here
//						Log.w(LCAT, "Sendbird chat closed()");
//					}
//				})
				.withArguments(args)
				.build();
	}
}


@Kroll.module(name="Sendbird", id="com.inzori.sendbird")
public class SendbirdModule extends KrollModule
{
	// Standard Debugging variables
	private static final String LCAT = "SendbirdModule";
	private String appId = "";
	private String userId = "";
	private String accessToken = "";

	public SendbirdModule()
	{
		super();
	}

	@Kroll.onAppCreate
	public static void onAppCreate(TiApplication app)
	{
		Log.d(LCAT, "Sendbird onAppCreate()");
		// put module init code that needs to run when the application is created
		SendbirdUIKit.setUIKitFragmentFactory(new CustomFragmentFactory());
	}

	// Methods
	@Kroll.method
	public void initSendbird(KrollDict options)
	{
		Log.w(LCAT, "Sendbird initSendbird()");

		appId = options.containsKey("appId") ? (String) options.get("appId") : "";
		userId = options.containsKey("userId") ? (String) options.get("userId") : "";
		KrollFunction onComplete = (KrollFunction) options.get("onComplete");

		SendbirdUIKit.init(new SendbirdUIKitAdapter() {
			@NonNull
			@Override
			public String getAppId() {
				return appId;
			}

			@Nullable
			@Override
			public String getAccessToken() {
				return accessToken;
			}

			@NonNull
			@Override
			public UserInfo getUserInfo() {
				return new UserInfo() {
					@Override
					public String getUserId() {
						return userId;
					}

					@Nullable
					@Override
					public String getNickname() {
						return "";
					}

					@Nullable
					@Override
					public String getProfileUrl() {
						return "";
					}
				};
			}

            @NonNull
            @Override
            public InitResultHandler getInitResultHandler() {
				Log.w(LCAT, "Sendbird getInitResultHandler()");
                return new InitResultHandler() {
                    @Override
                    public void onMigrationStarted() {
                    }

                    @Override
                    public void onInitFailed(SendbirdException e) {
                        // If DB migration fails, this method is called.
						Log.e(LCAT, "Sendbird onInitFailed()");
						KrollDict eventData = new KrollDict();
						eventData.put("success",false);

						onComplete.callAsync(getKrollObject(), eventData);
                    }

                    @Override
                    public void onInitSucceed() {
                        // If DB migration is successful, this method is called and you can proceed to the next step.
                        // In the sample app, the `LiveData` class notifies you on the initialization progress
                        // And observes the `MutableLiveData<InitState> initState` value in `SplashActivity()`.
                        // If successful, the `LoginActivity` screen
                        // Or the `HomeActivity` screen will show.
						Log.w(LCAT, "Sendbird onInitSucceed()");

						KrollDict eventData = new KrollDict();
						eventData.put("success",true);

						onComplete.callAsync(getKrollObject(), eventData);
                    }
                };
            }
        }, TiApplication.getInstance().getApplicationContext());		
	}

	@Kroll.method
	public void connectUser(KrollDict options)
	{
		Log.w(LCAT, "Sendbird connectUser()");
		KrollFunction onComplete = (KrollFunction) options.get("onComplete");
		//String userId = options.containsKey("userId") ? (String) options.get("userId") : "";
		accessToken = options.containsKey("authToken") ? (String) options.get("authToken") : "";

		SendbirdChat.connect(userId, accessToken, (user, e) -> {
			KrollDict eventData = new KrollDict();
			if (e != null) {
				eventData.put("success",false);
				eventData.put("message", e.getLocalizedMessage());
				Log.e(LCAT, e.getLocalizedMessage());
			} else {
				eventData.put("success",true);
				eventData.put("message","The user is online and connected to the server");
				Log.w(LCAT, "The user is online and connected to the server");

			}
			onComplete.callAsync(getKrollObject(), eventData);
		});
	}
	
	@Kroll.method
	public void disconnectUser(KrollDict options)
	{
		Log.w(LCAT, "Sendbird disconnectUser()");
		KrollFunction onComplete = (KrollFunction) options.get("onComplete");

		SendbirdUIKit.disconnect(new DisconnectHandler() {
			@Override
			public void onDisconnected() {
				// The current user is disconnected from Sendbird server.
				KrollDict eventData = new KrollDict();
				eventData.put("success",true);
				eventData.put("message","The current user is disconnected from Sendbird server");
				onComplete.callAsync(getKrollObject(), eventData);
			}
		});
	}

	@Kroll.method
	public void chatClosed() {
		KrollDict eventData = new KrollDict();
		eventData.put("success",true);
		eventData.put("message","The chat was closed");
		fireEvent("app:sendbird_chat_dismissed", eventData);
	}

	@Kroll.method
	public void launchChat(KrollDict options)
	{
		String groupChannelUrl = options.containsKey("groupChannelUrl") ? (String) options.get("groupChannelUrl") : "";
		KrollFunction onComplete = (KrollFunction) options.get("onComplete");

		Log.w(LCAT, "Sendbird launchChat() url: " + groupChannelUrl);

		KrollDict eventData = new KrollDict();
		try {
			Intent intent = ChannelActivity.newIntent(TiApplication.getInstance().getApplicationContext(), groupChannelUrl);
			intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			TiApplication.getInstance().getApplicationContext().startActivity(intent);

			eventData.put("success",true);
			eventData.put("message","Chat opened");
			eventData.put("channelURL", groupChannelUrl);
			fireEvent("app:sendbird_chat_opened", eventData);
			onComplete.callAsync(getKrollObject(), eventData);
		} catch (Exception exception) {
			eventData.put("success",false);
			eventData.put("message",exception.getLocalizedMessage());
			onComplete.callAsync(getKrollObject(), eventData);
		}
	}
}

