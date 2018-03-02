From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 19/20] multipathd: use foreign API
Date: Fri, 2 Mar 2018 14:00:48 -0600
Message-ID: <20180302200048.GJ14513@octiron.msp.redhat.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-20-mwilck@suse.com>
	<20180301051306.GO14513@octiron.msp.redhat.com>
	<1520018379.4169.83.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1520018379.4169.83.camel@suse.com>
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
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 02, 2018 at 08:19:39PM +0100, Martin Wilck wrote:
> On Wed, 2018-02-28 at 23:13 -0600, Benjamin Marzinski wrote:
> > =

> > effects multipathd is its use of SIGALRM. Now assuming signal
> > processing
> > worked correctly in multipathd (it doesn't. commit 534ec4c broke it.
> > I'm
> > planning on fixing that shortly)
> =

> Details about this breakage, and your idea how to fix it, would be
> highly appreciated.

I plan on fixing the issue using exactly the method that commit 534ec4c
says it is using. :) I cleaned up the signal handling years ago with
commit 5ee9f71, which blocked all the then-used signals for all threads
except uxlsnr, which is who calls handle_signals. Other threads
unblocked signals only as necessary. I'm not sure what issue caused Bart
to write 534ec4c. Perhaps an earlier commit actually broke the signal
handling, and this was just the commit that git blame pointed to.  But
in any case, after commit 534ec4c, we are only blocking SIGUSR2 on all
threads, which is the only signal we don't need to block.  This means
that, for instance, we have no idea which thread a SIGALRM is going to,
because any of them could receive it.  It is safe to unblock SIGUSR2 on
multiple threads at once, since (I hope) the only things that send it
are stop_io_err_stat_thread() and stop_waiter_thread(), and both of
those send it via pthread_kill, which will make sure it goes to the
proper thread.

-Ben

> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
