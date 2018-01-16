From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH V3] multipathd: release uxsocket and resource
 when cancel thread
Date: Tue, 16 Jan 2018 16:39:09 -0600
Message-ID: <20180116223909.GP5638@octiron.msp.redhat.com>
References: <CEB9978CF3252343BE3C67AC9F0086A342957D1C@H3CMLB14-EX.srv.huawei-3com.com>
	<1516108760.23203.3.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516108760.23203.3.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Wuchongyun <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>
List-Id: dm-devel.ids

On Tue, Jan 16, 2018 at 02:19:20PM +0100, Martin Wilck wrote:
> On Tue, 2018-01-16 at 11:48 +0000, Wuchongyun wrote:
> > Hi Martin,
> > Sorry to forget that, actually I found that dead_client() will not be
> > interrupt by thread cancle, because after all dead_client() calling
> > point be done then handle_signals() have chance to be called by
> > uxsock_listen() which will call exit_daemon() and send =

> > cancel threads signal to all child process include uxlsnr.
> =

> Fair enough.
> =

> > But your comments is good can make code more safer. Below is the new
> > patch, please have a look, thanks.
> =

> I think it's really safer whis way, should anyone see the need to
> cancel the listener thread from another point in the code.

I'm confused why this is safe. After uxsock_listen() calls exit_daemon()
from handle_signals(), it doesn't exit. It loops around and polls again,
and could in theory find a client that has died.  In fact if the client
is killing multipathd via

# multipathd shutdown

instead of a signal, won't it be very likely that it will find a dead
client when it loops right after calling exit_daemon() in
cli_shutdown()? This could hit the deadlock that you noticed, where
uxsock_cleanup() can't run because dead_client() already holding the
mutex.

Or am I missing something here?
-Ben

> =

> The patch is looks good now.
> =

> Reviewed-by: Martin Wilck <mwilck@suse.com>
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
