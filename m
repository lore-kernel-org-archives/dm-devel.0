From: Wuchongyun <wu.chongyun@h3c.com>
Subject: Re: [PATCH V3] multipathd: release uxsocket and resource
 when cancel thread
Date: Wed, 17 Jan 2018 02:04:19 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A342957FEF@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Changlimin <changlimin@h3c.com>, Changwei Ge <ge.changwei@h3c.com>, Guozhonghua <guozhonghua@h3c.com>
List-Id: dm-devel.ids

On Tue, Jan 17, 2018 at 06:39:20PM +0100, Benjamin Marzinski wrote:
> On Tue, Jan 16, 2018 at 02:19:20PM +0100, Martin Wilck wrote:
> > On Tue, 2018-01-16 at 11:48 +0000, Wuchongyun wrote:
> > > Hi Martin,
> > > Sorry to forget that, actually I found that dead_client() will not 
> > > be interrupt by thread cancle, because after all dead_client() 
> > > calling point be done then handle_signals() have chance to be called 
> > > by
> > > uxsock_listen() which will call exit_daemon() and send cancel 
> > > threads signal to all child process include uxlsnr.
> > 
> > Fair enough.
> > 
> > > But your comments is good can make code more safer. Below is the new 
> > > patch, please have a look, thanks.
> > 
> > I think it's really safer whis way, should anyone see the need to 
>>  cancel the listener thread from another point in the code.

> I'm confused why this is safe. After uxsock_listen() calls exit_daemon() from handle_signals(), it doesn't exit. It loops around and polls again, and could in theory find a client that has died.  In fact if the client is killing multipathd via
> # multipathd shutdown
> instead of a signal, won't it be very likely that it will find a dead client when it loops right after calling exit_daemon() in cli_shutdown()? This could hit the deadlock that you noticed, where
> uxsock_cleanup() can't run because dead_client() already holding the mutex.
> Or am I missing something here?

Hi Benjiamin,
Thanks for your comments below are my rely, thanks.

You really found the scenario which need to add pthread_cleanup_push(cleanup_lock, &client_lock) before get lock in dead_client to avoid the dead lock:
If the client is killing multipathd via multipathd shutdown and it find a dead client when it loops right after calling exit_daemon() in cli_shutdown(), This will not hit deadlock because in dead_client before get lock we call pthread_cleanup_push(cleanup_lock, &client_lock) first, then thread cancelation happened, thread cleanup functions been pop up by reverse order: cleanup_lock() first, then uxsock_cleanup(), which make sure client_lock been release before calling uxsock_cleanup(). So it's safer in this way.

And your next comment is right I will make another patch for this.
>Since you are now closing ux_sock in uxsock_cleanup(), you should remove the close(ux_sock) at the end of uxsock_listen(). pthread_cleanup_pop() will already take care of that.

Regards
Chongyun
