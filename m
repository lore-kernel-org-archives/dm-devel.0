From: Frank Mayhar <fmayhar@google.com>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Thu, 17 Oct 2013 12:03:10 -0700
Message-ID: <1382036590.1980.32.camel@bobble.lax.corp.google.com>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
	<20130926172422.GA31328@agk-dp.fab.redhat.com>
	<1380216716.25252.39.camel@bobble.lax.corp.google.com>
	<20130926173814.GB31328@agk-dp.fab.redhat.com>
	<1380217633.25252.46.camel@bobble.lax.corp.google.com>
	<20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130926234957.GA3658@redhat.com>
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

Dragging this back up into the light...

On Thu, 2013-09-26 at 19:49 -0400, Mike Snitzer wrote:
> Frank, I had a look at your patch.  It leaves a lot to be desired, I was
> starting to clean it up but ultimately found myself agreeing with
> Alasdair's original point: that this policy should be implemented in the
> userspace daemon.

I've found and fixed a couple of bugs but I would still like to know
what issues you had with the patch.  As I said before, I would be more
than happy to clean it up.

In the time since we had this discussion, by the way, we ran into a
problem that a userspace daemon can't solve:  That of shutdown.  We ran
into a number of failures in which systems were hung for hours.  It
turned out that they were caused by a regular system shutdown.  Our
backing store is network-based and networking was getting killed before
applications (as is usually the case), leaving I/O outstanding on the
device.  Since queue_if_no_path was set, the I/O wasn't dumped and our
daemon was killed by shutdown very shortly thereafter so it couldn't
recover (otherwise it would have cleaned things up).

With those I/Os sitting queued in multipath, with no network and no
daemon to turn off queue_if_no_path, the systems just sat.  When we
finally diagnosed this, we realized that the timeout would work
perfectly to solve the problem, automatically turning queue_if_no_path
off shortly after the network went away without depending on the
intervention of the no-longer-running daemon.

So how do you guys deal with this failure scenario?
-- 
Frank Mayhar
310-460-4042
