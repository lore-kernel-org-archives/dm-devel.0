From: Frank Mayhar <fmayhar@google.com>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Thu, 17 Oct 2013 13:45:59 -0700
Message-ID: <1382042759.1980.40.camel@bobble.lax.corp.google.com>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
	<20130926172422.GA31328@agk-dp.fab.redhat.com>
	<1380216716.25252.39.camel@bobble.lax.corp.google.com>
	<20130926173814.GB31328@agk-dp.fab.redhat.com>
	<1380217633.25252.46.camel@bobble.lax.corp.google.com>
	<20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com>
	<1382036590.1980.32.camel@bobble.lax.corp.google.com>
	<20131017191511.GA30452@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131017191511.GA30452@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2013-10-17 at 15:15 -0400, Mike Snitzer wrote:
> Shouldn't you wait for the application to shutdown before ripping the
> network out?  Seems odd to just throw away queued IO.

In general, yes, and we do that, but there's still the occasional
shutdown that doesn't go through those extra steps.

> A proper shutdown sequence really should avoid this problem in general,
> the multipath daemon would only be shutdown once all mpath devices are
> deactivated.
> 
> Then, if you still want to gracefully handle the case where there is no
> network (and hence no paths) on shutdown the multipathd would still be
> around to transition to a table that doesn't have queue_if_no_path.

Of course, this still depends on the daemon surviving everything else
circumstances can throw at it.

In our particular case, changing the shutdown sequence is far more
difficult than using the kernel mechanism I've already provided.  This
would also simplify things for other folks who use queue_if_no_path.
-- 
Frank Mayhar
310-460-4042
