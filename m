From: Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [PATCH v2] multipath-tools: handle exit signal
	immediately
Date: Wed, 31 Jan 2018 11:59:25 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A342959627@H3CMLB14-EX.srv.huawei-3com.com>
References: <CEB9978CF3252343BE3C67AC9F0086A342959378@H3CMLB14-EX.srv.huawei-3com.com>
	<20180130141624.27439-1-mwilck@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A342959540@H3CMLB14-EX.srv.huawei-3com.com>
	<1517391604.5981.34.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Guozhonghua <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>
List-Id: dm-devel.ids

On 2018/1/31 17:40, Martin Wilck wrote:
> On Wed, 2018-01-31 at 07:43 +0000, Chongyun Wu wrote:
>> Hi Martin,
>>
>> My patch have tested but your patch seems to be more gracefully. May
>> be
>> there are some small issues if I am not wrong.Thanks.
>>
>> On 2018/1/30 22:18, Martin Wilck wrote:
>>> multipathd shouldn't try to service any more client connections
>>> when it receives an exit signal. Moreover, ppoll() can return
>>> success even if signals occured. So check for reconfigure or
>>> log_reset signals after handling pending client requests.
>>>
>>> Based on an analysis by Chongyun Wu.
>>>
>>> Reported-by: Chongyun Wu <wu.chongyun@h3c.com>
>>> Signed-off-by: Martin Wilck <mwilck@suse.com>
>>> ---
>>>    multipathd/main.c   | 6 ++++--
>>>    multipathd/main.h   | 2 +-
>>>    multipathd/uxlsnr.c | 7 +++++--
>>>    3 files changed, 10 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/multipathd/main.c b/multipathd/main.c
>>> index 27cf234623d0..8e96f5dd2d7f 100644
>>> --- a/multipathd/main.c
>>> +++ b/multipathd/main.c
>>> @@ -2184,12 +2184,15 @@ signal_set(int signo, void (*func) (int))
>>>    }
>>>    
>>>    void
>>> -handle_signals(void)
>>> +handle_signals(bool nonfatal)
>>>    {
>>>    	if (exit_sig) {
>>>    		condlog(2, "exit (signal)");
>>> +		exit_sig = 0;
>>
>> If we received a exit signal should we just escape all below
>> commands
>> process to avoid the race condition between thread cancellation and
>> commands processing? so maybe flag exit_sig keep to 1 here?
> 
> What would that be good for? We call exit_daemon(), signalling the main
> process to shut down. If we don't reset exit_sig, we'll call
> exit_daemon() again if handle_signals is ever run again. That's not
> necessary and might actually confuse matters.
> 
> Or am I overlooking something?

You are right. I just want to escape below code process to make logic 
simple but as you see really have problem in this way.

> 
>>
>>>    		exit_daemon();
>>>    	}
>>> +	if (!nonfatal)
>>> +		return;
>>>    	if (reconfig_sig) {
>>>    		condlog(2, "reconfigure (signal)");
>>>    		set_config_state(DAEMON_CONFIGURE);
>>> @@ -2200,7 +2203,6 @@ handle_signals(void)
>>>    		log_reset("multipathd");
>>>    		pthread_mutex_unlock(&logq_lock);
>>>    	}
>>> -	exit_sig = 0;
>>>    	reconfig_sig = 0;
>>>    	log_reset_sig = 0;
>>>    }
>>> diff --git a/multipathd/main.h b/multipathd/main.h
>>> index ededdaba32fe..e8140feaf291 100644
>>> --- a/multipathd/main.h
>>> +++ b/multipathd/main.h
>>> @@ -38,6 +38,6 @@ int mpath_pr_event_handle(struct path *pp);
>>>    void * mpath_pr_event_handler_fn (void * );
>>>    int update_map_pr(struct multipath *mpp);
>>>    void * mpath_pr_event_handler_fn (void * pathp );
>>> -void handle_signals(void);
>>> +void handle_signals(bool);
>>>    
>>>    #endif /* MAIN_H */
>>> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
>>> index 98ac25a68c43..dc116cf2515b 100644
>>> --- a/multipathd/uxlsnr.c
>>> +++ b/multipathd/uxlsnr.c
>>> @@ -221,9 +221,10 @@ void * uxsock_listen(uxsock_trigger_fn
>>> uxsock_trigger, void * trigger_data)
>>>    		/* most of our life is spent in this call */
>>>    		poll_count = ppoll(polls, i, &sleep_time, &mask);
>>>    
>>> +		handle_signals(false);
>>
>> Is it better to add and check the return value from handle_signals()?
>> If
>> return true means this a exit signal should run continue to escape
>> all
>> below processing.
>> If not doing that, we may need to add
>> pthread_cleanup_push(cleanup_lock,
>> &client_lock) before pthread_mutex_lock(&client_lock) in below
>> command
>> processing to avid dead lock which happen when commands processing
>> code
>> just have the lock and cancellation works to call uxsock_cleanup hook
>> to
>> get the lock and the commands processing code have no chance to
>> release
>> the lock.
> 
> AFAICS it isn't necessary, because the two code parts where the lock is
> taken in the uxsock_listen() don't contain cancellation points. If I'm
> overlooking something here and pthread_cleanup_push(&client_lock) has
> to be used in the listener thread, that would be an independent fix.
>    
>>> @@ -292,6 +293,8 @@ void * uxsock_listen(uxsock_trigger_fn
>>> uxsock_trigger, void * trigger_data)
>>>    				FREE(inbuf);
>>>    			}
>>>    		}
>>> +		/* see if we got a non-fatal signal */
>>> +		handle_signals(true);
>>
>> above code maybe not needed. Because it's safe to make sure no
>> commands
>> be processed then to handle nonefatal signal, like code
>> "if(poll_count
>> ==0){...}" do. If here to call hanle_signals(true) again, may facing
>> race condition between signals processing and command processing.
> 
> Do you see an actual race condition or just the potential to confuse
> connected clients?
> 
>> That
>> maybe not so safe. And the handle_signals have been called above. Is
>> there a special reason for this which I missed?
> 
> Of the handle_signals() calls above, the first one handles only fatal
> signals, and the others are only called if ppoll() returns -1 or 0.
> 
> We have two non-fatal signals, "log_reset" and "reconfigure".
> "log_reset" can be safely ignored for this discussion. "reconfigure"
> may admittedly confuse connected clients if it's called while a session
> is active.
> 
> The loop over the clients makes sure that commands from clients that
> are seen before the signal are received and processed before the
> handle_signals() call.
> 
> The question is what to do with client sessions that remain open after
> the loop has finished (i.e. the current command has been handled). IMO
> that's not the common case, more often than not client connections just
> send a single command. But of course, it can't be excluded either.
> 
> If we don't call handle_signals() at this point, and clients continue
> sending commands, ppoll() won't return -1 or 0, and the "reconfigure"
> signal might not be processed in a long time, which seems wrong to me.
> After all, signals are meant to be processed asynchronously. Note that
> if one of the clients sends a "reconfigure" command, it will be handled
> immediately, possibly confusing other clients connected at the same
> time. Therefore I think it's correct to handle a possibly received
> "reconfigure" signal at this point in the code, too.
Your consideration sounds reasonable.

> 
> It might generallly make sense for the uxlsnr thread to pause servicing
> commands while the daemon is not in DAEMON_RUNNING or DAEMON_IDLE
> state. But that's independent of the current discussion.
> 
> Summarizing, unless you or someone else points out an actual race
> condition (in the sense that internal multipathd data structures might
> be corrupted), which is introduced by this particular handle_signals()
> call, I'd prefer adding it.
Yes, I haven't found any actual race condition just afraid of that. I 
think the patch might be safe after your explanation.

> 
> Martin
> 
> 

Thanks
Chongyun Wu
