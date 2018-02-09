From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 1/7] libmultipath: fix tur checker locking
Date: Fri, 9 Feb 2018 17:04:49 -0600
Message-ID: <20180209230449.GW14513@octiron.msp.redhat.com>
References: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
	<1518134167-15938-2-git-send-email-bmarzins@redhat.com>
	<1518208256.2937.16.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1518208256.2937.16.camel@suse.com>
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
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 09, 2018 at 09:30:56PM +0100, Martin Wilck wrote:
> On Thu, 2018-02-08 at 17:56 -0600, Benjamin Marzinski wrote:
> > ct->running is now an atomic variable.  When the thread is started
> > it is set to 1. When the checker wants to kill a thread, it
> > atomically
> > sets the value to 0 and reads the previous value.  If it was 1,
> > the checker cancels the thread. If it was 0, the nothing needs to be
> > done.  After the checker has dealt with the thread, it sets ct-
> > >thread
> > to NULL.
> > =

> > When the thread is done, it atomicalllys sets the value of ct-
> > >running
> > to 0 and reads the previous value. If it was 1, the thread just
> > exits.
> > If it was 0, then the checker is trying to cancel the thread, and so
> > the thread calls pause(), which is a cancellation point.
> > =

> =

> I'm missing one thing here. My poor brain is aching.
> =

> cleanup_func() can be entered in two ways: a) if the thread has been
> cancelled and passed a cancellation point already, or b) if it exits
> normally and calls pthread_cleanup_pop(). =

> In case b), waiting for the cancellation request by calling pause()
> makes sense to me. But in case a), the thread has already seen the
> cancellation request - wouldn't calling pause() cause it to sleep
> forever?

Urgh. You're right. If it is in the cleanup helper because it already
has been cancelled, then the pause isn't going get cancelled. So much
for my quick rewrite.

That leaves three options.

1. have either the thread or the checker detach the thread (depending
   on which one exits first)
2. make the checker always cancel and detach the thread. This simplifies
   the code, but there will zombie threads hanging around between calls
   to the checker.
3. just move the condlog

I really don't care which one we pick anymore.

-Ben

> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
