From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH V3] multipathd: release uxsocket and resource
 when cancel thread
Date: Wed, 17 Jan 2018 12:59:41 -0600
Message-ID: <20180117185941.GT5638@octiron.msp.redhat.com>
References: <CEB9978CF3252343BE3C67AC9F0086A342957FEF@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A342957FEF@H3CMLB14-EX.srv.huawei-3com.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Wuchongyun <wu.chongyun@h3c.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Wed, Jan 17, 2018 at 02:04:19AM +0000, Wuchongyun wrote:
> On Tue, Jan 17, 2018 at 06:39:20PM +0100, Benjamin Marzinski wrote:
> > On Tue, Jan 16, 2018 at 02:19:20PM +0100, Martin Wilck wrote:
> > > On Tue, 2018-01-16 at 11:48 +0000, Wuchongyun wrote:
> > > > Hi Martin,
> > > > Sorry to forget that, actually I found that dead_client() will not 
> > > > be interrupt by thread cancle, because after all dead_client() 
> > > > calling point be done then handle_signals() have chance to be called 
> > > > by
> > > > uxsock_listen() which will call exit_daemon() and send cancel 
> > > > threads signal to all child process include uxlsnr.
> > > 
> > > Fair enough.
> > > 
> > > > But your comments is good can make code more safer. Below is the new 
> > > > patch, please have a look, thanks.
> > > 
> > > I think it's really safer whis way, should anyone see the need to 
> >>  cancel the listener thread from another point in the code.
> 
> > I'm confused why this is safe. After uxsock_listen() calls exit_daemon() from handle_signals(), it doesn't exit. It loops around and polls again, and could in theory find a client that has died.  In fact if the client is killing multipathd via
> > # multipathd shutdown
> > instead of a signal, won't it be very likely that it will find a dead client when it loops right after calling exit_daemon() in cli_shutdown()? This could hit the deadlock that you noticed, where
> > uxsock_cleanup() can't run because dead_client() already holding the mutex.
> > Or am I missing something here?
> 
> Hi Benjiamin,
> Thanks for your comments below are my rely, thanks.
> 
> You really found the scenario which need to add pthread_cleanup_push(cleanup_lock, &client_lock) before get lock in dead_client to avoid the dead lock:
> If the client is killing multipathd via multipathd shutdown and it find a dead client when it loops right after calling exit_daemon() in cli_shutdown(), This will not hit deadlock because in dead_client before get lock we call pthread_cleanup_push(cleanup_lock, &client_lock) first, then thread cancelation happened, thread cleanup functions been pop up by reverse order: cleanup_lock() first, then uxsock_cleanup(), which make sure client_lock been release before calling uxsock_cleanup(). So it's safer in this way.

I thought Martin was asking you to not add the pthread_cleanup_push/pop
in dead_client, and I was trying to argue that they were necessary. But
I think I just made the conversation more muddled.

So yes, please add the pthread_cleanup_push/pop in dead_client. It does
make the program safer. Sorry if I'm just restating what everyone had
already agreed to.

Thanks.
-Ben

> 
> And your next comment is right I will make another patch for this.
> >Since you are now closing ux_sock in uxsock_cleanup(), you should remove the close(ux_sock) at the end of uxsock_listen(). pthread_cleanup_pop() will already take care of that.
> 
> Regards
> Chongyun
