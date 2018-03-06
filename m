From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipathd: fix inverted signal blocking
	logic
Date: Mon, 5 Mar 2018 18:46:10 -0600
Message-ID: <20180306004610.GM14513@octiron.msp.redhat.com>
References: <20180302200048.GJ14513@octiron.msp.redhat.com>
	<20180302211807.11434-1-mwilck@suse.com>
	<1520026513.2855.30.camel@wdc.com>
	<1520028909.4169.87.camel@suse.com>
	<1520029421.2855.35.camel@wdc.com>
	<1520032608.4169.91.camel@suse.com>
	<1520033250.2855.47.camel@wdc.com>
	<1520037092.4169.103.camel@suse.com>
	<1520267239.2826.17.camel@wdc.com>
	<1520270885.7660.36.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1520270885.7660.36.camel@suse.com>
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
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 05, 2018 at 06:28:05PM +0100, Martin Wilck wrote:
> Hello Bart,
> =

> On Mon, 2018-03-05 at 16:27 +0000, Bart Van Assche wrote:
> > On Sat, 2018-03-03 at 01:31 +0100, Martin Wilck wrote:
> > > So, there's no reason not to block them, right? Is it expected
> > > behavior
> > > that a user running 'kill -USR2 $(pidof multipathd)' terminates the
> > > process? Why do you think these signals should interrupt ppoll()
> > > although the uxlsnr can't can't handle them? Isn't it sufficient
> > > that
> > > they're handled by the threads that are meant to do that?
> > =

> > Blocking all signals except the ones for which we installed a handler
> > sounds
> > weird to me. I think users expect daemons to process signals instead
> > of
> > blocking all but a specific set of signals. This is a rather
> > philosophical
> > argument and not an argument of which I think that it is strong
> > enough to
> > prevent this patch of being integrated in the upstream multipath-
> > tools
> > repository.
> =

> Thank you. Meanwhile, I found that this patch requires a change in the
> "marginal paths" code. I'll post an official patch as update.
> =

> Regarding the philosophical discussion, may I remind you of your own
> words from 534ec4c?
> =

>     The POSIX standard mentions that the only way to guarantee that
>     signals are delivered to a specific thread is:
>      * Block all signals before the first pthread_create() call.
>      * Unblock signals from the thread that should receive signals.
> =

> If we unblock signals with a default disposition of "Term" for which we
> have no handler, stray signals caught would terminate multipathd. I
> don't think that's what we want. Of course we must react on
> SIGINT/SIGTERM/SIGHUP in the way the user expects us to, but
> terminating on other signals would be wrong.
> =

> Let's see if others have to say anything about this.

This is prety close to what I had in mind. The only things missing, that
I noticed when I was looking at multipathd's signal handling, is dealing
with SIGUSR2 in io_err_stat.c, which it sounds like you have already
spotted, and changing the calls to setitimer and usleep outside of the
vecs lock to use nanosleep, so they don't interact with SIGALRM.

I'll send a patch based on yours, to fix these.

-Ben

> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
