From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] multipathd: fix daemon not really shutdown
Date: Fri, 04 Jan 2019 12:54:25 +0100
Message-ID: <33bcff5ff3f75446176fea992cb34c5d14166d34.camel@suse.de>
References: <CEB9978CF3252343BE3C67AC9F0086A3651A76AD@H3CMLB14-EX.srv.huawei-3com.com>
	<3ef4c4debc9b0e56134f45d4a18693e4e8e18c0c.camel@suse.de>
	<CEB9978CF3252343BE3C67AC9F0086A3651A99A5@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A3651A99A5@H3CMLB14-EX.srv.huawei-3com.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chongyun Wu <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>
List-Id: dm-devel.ids

On Fri, 2019-01-04 at 02:25 +0000, Chongyun Wu wrote:
> Hi Martin,
> 
> Yes, I have your patch f1c73962's fix.
> Your patch f1c73962 "multipathd: make DAEMON_SHUTDOWN a terminal
> state" 
> is good and needed because I also meet that situation need your patch
> to 
> fix, but we also meet another issue: in set_config_state() when sleep
> by 
> calling pthread_cond_timedwait() it will unlock config_lock and
> other 
> thread will have chance to get config_lock and change the
> running_state 
> then we also need to check if the running_state already are 
> DAEMON_SHUTDOWN, if so we might not change the running_state back to 
> other status to make sure shutdown not been interrupted. Our test
> meet 
> this problem and I add debug log to find this situation really exist.

Ok, I can see now what might happen: If the *other* thread sets
DAEMON_SHUTDOWN while set_config_state() is in
pthread_cond_timedwait(), and set_config_state() had been called e.g.
with state = DAEMON_RUNNING, it will indeed reset the state. So that 
part of your patch is correct. Thanks.

Going one step further, I think we should cancel the other threads
(in particular, the checker thread) immediately in the shutdown
sequence. That way the child thread won't have to wait or the checker
loop to finish before the shutdown sequence starts.

> 
> Next change: move exit_sig out of handle_signals is to save the
> ppoll() 
> waiting time in uxlsnr thread to make sure exit signal process
> faster.
> Restart multipath-tools service there are only 5s or 6s to wait
> service 
> to stop and ppoll() will wait 5s if no connection or data transfer 
> happen. This situation we also meet in testing.

I'm quite positive that this is wrong. First, we can't call
post_config_state() from a signal handler. It would cause deadlock if
the config_lock is already held. Second, the signal masks are set such 
that ppoll() returns immediately on all signals we're handling.
multipathd can be terminated in two ways - by an exit signal, or by the
"shutdown" cli command. Both events should cause ppoll() to return
immediately. The only situation I can imagine where these events aren't
handled immediately is when the uxlsnr thread is busy *outside* the
ppoll() call, e.g. handling an expensive cli command. The most
expensive cli command, "reconfigure", is already delegated to the
"child" thread, but there are other cli commands that need to take the
vecs lock, which may mean that they need to wait e.g. for the checker
loop.

The only possibility I see for handling this is to avoid waiting for
the vecs lock in the uxlsnr thread. We could either delegate locking
cli calls to a separate thread, or do a better job of catching signals
while the cli thread is busy, e.g. by calling sigpending() and reacting
appropriately.

Let's summarize how multipathd exit works today:

 1. signal arrives
    (signal may be blocked while uxlsnr is busy, see above)
 2. signal is unblocked in uxlsnr thread (in ppoll())
 3. signal handler sets exit_sig()
 4. uxlsnr calls handle_signals()
 5. handle_signals()->exit_daemon() sets DAEMON_SHUTDOWN() and posts
config_cond (child may busy in reconfigure())
 6. child detects DAEMON_SHUTDOWN and quits main loop
 7. child locks vecs->lock (may cause wait)
 8. sets dm_queue_if_no_path, cancels threads, and exits.

I can imagine delays in step 1, 5, and 7, but not in ppoll().

It would be helpful if you could provide an strace of multipathd
failing to quit timely, with the first part of your patch applied, so
that we could see how the delay is actually caused.

Regards,
Martin

> Chongyun Wu
> 
> On 2019/1/3 18:23, Martin Wilck wrote:
> > Chongyun,
> > 
> > On Wed, 2018-12-26 at 06:34 +0000, Chongyun Wu wrote:
> > > Hi Martin and Ben,
> > > 
> > > Cloud you help to review this patch, thanks.
> > > 
> > > Test environment: 25 hosts, each host have more than 100 luns,
> > > each lun have two paths.
> > > Some times when we try to ceate new multipath will encounter
> > > "could
> > > not create uxsock:98" but the multipathd still running not
> > > shutdown
> > > and can't response any multipathd commands also.
> > > 
> > > After reproduce this issue and debug, found below fixes might
> > > work:
> > > (1) set_config_state() after pthread_cond_timedwait() other
> > > threads
> > > might changed the running_state from DAEMON_SHUTDOWN to other
> > > status
> > > like DAEMON_IDLE, which will make the shutdown process stopped.
> > > I found logs to prove this really happened, so we need add
> > > judgement
> > > here too.
> > > 
> > > (2) process exit signal as possible as we can.
> > > If we just set a flag and wait handle_signals to handle exit
> > > signal,
> > > there might have more 5s to wait because of ppoll maximal wait
> > > time.
> > > And there might haven't enouth time left for all threads to clean
> > > up
> > > and exit.
> > > 
> > > With this patch our tester not report this issue again.
> > 
> > please verify that you were using the latest upstream code,
> > in particular that f1c73962 "multipathd: make DAEMON_SHUTDOWN a
> > terminal state" and the predecessors 9de272eb, 234cab29 are
> > included in your code base. I made these patches
> > for the problem you are describing, and it worked for me.
> > 
> > Martin
> > 
> > 
> > 
> > > Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
> > > ---
> > >    multipathd/main.c | 11 +++--------
> > >    1 file changed, 3 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > index 991452930433..620b8264c82f 100644
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -141,7 +141,6 @@ struct udev * udev;
> > >    struct config *multipath_conf;
> > > 
> > >    /* Local variables */
> > > -static volatile sig_atomic_t exit_sig;
> > >    static volatile sig_atomic_t reconfig_sig;
> > >    static volatile sig_atomic_t log_reset_sig;
> > > 
> > > @@ -247,7 +246,7 @@ int set_config_state(enum daemon_status
> > > state)
> > >    			rc =
> > > pthread_cond_timedwait(&config_cond,
> > >    						    &config_loc
> > > k, &ts);
> > >    		}
> > > -		if (!rc) {
> > > +		if (!rc && (running_state != DAEMON_SHUTDOWN)) {
> > >    			running_state = state;
> > >    			pthread_cond_broadcast(&config_cond);
> > >    #ifdef USE_SYSTEMD
> > > @@ -2517,11 +2516,6 @@ signal_set(int signo, void (*func) (int))
> > >    void
> > >    handle_signals(bool nonfatal)
> > >    {
> > > -	if (exit_sig) {
> > > -		condlog(2, "exit (signal)");
> > > -		exit_sig = 0;
> > > -		exit_daemon();
> > > -	}
> > >    	if (!nonfatal)
> > >    		return;
> > >    	if (reconfig_sig) {
> > > @@ -2546,7 +2540,8 @@ sighup (int sig)
> > >    static void
> > >    sigend (int sig)
> > >    {
> > > -	exit_sig = 1;
> > > +	condlog(2, "exit (signal)");
> > > +	exit_daemon();
> > >    }
> > > 
> > >    static void
> > 
> > 
