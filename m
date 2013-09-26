From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Thu, 26 Sep 2013 13:41:36 -0400
Message-ID: <20130926174135.GA31979@redhat.com>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
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

On Thu, Sep 26 2013 at  1:14pm -0400,
Frank Mayhar <fmayhar@google.com> wrote:

> Hey, folks.  We're using multipath as an in-kernel failover mechanism,
> so that if an underlying device dies, multipath will switch to another
> in its list.  Further, we use queue_if_no_path so that a daemon can get
> involved and replace the list if the kernel runs out of alternatives.
> In testing, however, we ran into a problem.
> 
> Obviously, if queue_if_no_path is on and multipath runs out of good
> paths, the I/Os will sit there queued forever barring user intervention.
> I was doing a lot of failure testing and encountered a daemon bug in
> which it would abandon its recovery in the middle, leaving the list
> intact and the I/Os queued, forever.  We fixed the daemon

Did you share the fix upstream yet?  If not please do ;)

> but the
> problem is potentially still there if for some reason the daemon dies
> and is not restarted.  This is a problem not solely (or even primarily)
> for the queued I/O, but also because things like slab shrink can get
> stuck behind that I/O and then other stuff becomes stuck behind _that_
> (since tries to get locks held by shrink and may itself hold
> semaphores), bringing the whole system to its knees in fairly short
> order, to the point that it's impossible to even get in via the network
> and reboot it.  I have an existence proof that this is the case. :-)
> 
> My idea to deal with this in the kernel was to introduce a timeout on
> queue_if_no_path and make it settable either kernel-wide or per-table.
> By default it's disabled and is only armed when multipath runs out of
> valid paths and queue_if_no_path is on.  It's disabled again on table
> load.  If the timeout ever fires, all that happens is that the handler
> turns off queue_if_no_path; this causes all the outstanding I/O to get
> EIO and unsticks things all the way up the chain.  Losing those I/Os is
> far better than losing the entire system.
> 
> I've actually implemented this and it works.  I've debated about talking
> with you folks about it but figured it was worth a shot.  I can post the
> patch if you're interested.

A timeout is always going to be racey.  But obviously with enough
testing you could arrive at a timeout that is reasonable for your
needs.. but in general I just don't think a timeout to release the
queuing is the right way to go.

And I understand Alasdair's point about hardening multipathd and using a
watchdog to restart it if it fails.  Ultimately that is ideal.  But if
multipathd does have a bug that makes it incapable of handling a case
(like the one you just fixed) it doesn't help to restart the daemon.

Therefore I'm not opposed to some solution in kernel.  But I'd think it
would be the kernel equivalent to multipathd's "queue_without_daemon".
AFAIK we currently don't have a way for the kernel to _know_ multipathd
is running; but that doesn't mean such a mechanism couldn't be
implemented.
