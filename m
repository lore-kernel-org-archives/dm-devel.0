From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Thu, 26 Sep 2013 14:41:11 -0400
Message-ID: <20130926184111.GA32706@redhat.com>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
	<20130926174135.GA31979@redhat.com>
	<1380218120.25252.54.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1380218120.25252.54.camel@bobble.lax.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 26 2013 at  1:55pm -0400,
Frank Mayhar <fmayhar@google.com> wrote:

> On Thu, 2013-09-26 at 13:41 -0400, Mike Snitzer wrote:
> > On Thu, Sep 26 2013 at  1:14pm -0400,
> > Frank Mayhar <fmayhar@google.com> wrote:
> > > Obviously, if queue_if_no_path is on and multipath runs out of good
> > > paths, the I/Os will sit there queued forever barring user intervention.
> > > I was doing a lot of failure testing and encountered a daemon bug in
> > > which it would abandon its recovery in the middle, leaving the list
> > > intact and the I/Os queued, forever.  We fixed the daemon
> > Did you share the fix upstream yet?  If not please do ;)
> 
> It's a daemon we wrote so the fix only really applies to us, sorry.

Ah, unfortunate to hear multipath-tools wasn't suitable for your needs.
We don't need to get in an elaborate tangent on why it wasn't used but
if there is something that would help improve multipath-tools in general
please share.

> > A timeout is always going to be racey.  But obviously with enough
> > testing you could arrive at a timeout that is reasonable for your
> > needs.. but in general I just don't think a timeout to release the
> > queuing is the right way to go.
> 
> Having it as an admin-settable option seems reasonable to me, though.  I
> agree you don't want one by default.  I expect that the timeout that's
> actually used to be on the order of single-digit minutes.
> 
> > And I understand Alasdair's point about hardening multipathd and using a
> > watchdog to restart it if it fails.  Ultimately that is ideal.  But if
> > multipathd does have a bug that makes it incapable of handling a case
> > (like the one you just fixed) it doesn't help to restart the daemon.
> 
> Believe me, we're hardening out daemon as much as possible, but the
> reality is that there's always going to be some situation that wasn't
> anticipated.  In our environment, that kind of stuff happens almost
> constantly.  No matter how hardened the daemon, _something_ can keep it
> from doing its job.
> 
> > Therefore I'm not opposed to some solution in kernel.  But I'd think it
> > would be the kernel equivalent to multipathd's "queue_without_daemon".
> > AFAIK we currently don't have a way for the kernel to _know_ multipathd
> > is running; but that doesn't mean such a mechanism couldn't be
> > implemented.
> 
> If you have a reasonable alternative I'm all ears.  However instantly
> failing the I/O if the daemon isn't present and we run out of paths
> isn't a good answer for us.

I see your point, and making a decision based on the availability of the
registered daemon (your custom thing or multipathd) is racey if the
daemon has a bug that causes it to crash and the watchdog restarts it
repeatedly; could result in false positive that makes the kernel think
the daemon is there (only for it to fail).

> Setting a timeout only if the daemon isn't
> present is functionally equivalent to setting a timeout regardless and
> having a running daemon nearly instantly reload the table (thereby
> turning off the timeout).

Not really following you here but the big point is you don't want
immediate release of the queued IO (even if you were armed with the
insight that there is no daemon to recover the paths)... you want that
release to be time delayed.

Pretty sure multipathd doesn't have the ability to dequeue multipath
devices after a timeout; so while Alasdair said it was a conscious
decision to have that feature be done in a userspace daemon I can easily
see that a bug in said daemon could prevent it from staying up long
enough to hit the configured timeout and then reload tables.

It is moot considering you aren't using multipath-tools, but your daemon
could also suffer from inability to reliably staying up to reload the
tables on timeout.

So all said, please post your dm-mpath patch that implements this
queue_if_no_path_timeout feature for further consideration.  I'd hope 0
disables it (the default) and that the unit of the timeout is in
seconds.  Also, I don't think it should be dm-mpath (kernel)
wide... best to just have it be per multipath table.

Thanks,
Mike
