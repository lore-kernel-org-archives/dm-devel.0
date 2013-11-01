From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 21/24] dm cache: add trc policy shim
Date: Fri, 1 Nov 2013 19:38:17 -0400
Message-ID: <20131101233817.GA26314@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-22-git-send-email-snitzer@redhat.com>
	<20131025201356.GM17070@agk-dp.fab.redhat.com>
	<20131025210820.GA7589@redhat.com>
	<20131025224453.GG4804@redhat.com>
	<1383341958.9311.19.camel@fedora>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1383341958.9311.19.camel@fedora>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steven Rostedt <srostedt@redhat.com>
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Thornber <ejt@redhat.com>, device-mapper development <dm-devel@redhat.com>, Joe@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 01 2013 at  5:39pm -0400,
Steven Rostedt <srostedt@redhat.com> wrote:

> > > 
> > > Think this would take care of it (not full-blown tracepoints like
> > > blktrace but certainly more performant than standard printk):
> 
> What's wrong with full blown tracepoints?

Nothing.  Just wasn't as quick to switch to while keeping the intent of
the original implementation.

> > I folded this trace_printk change in and renamed from trc to trace, see:
> > https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=f6f5db50495b16ff23a0febf38f9ee9d964b12dd
> > 
> 
> Please please please DO NOT USE TRACE_PRINTK!

Sure, I'll have a look at using proper tracepoints.  Worst case, in the
near-term, we drop this type of patch for v3.13 considering how close we
are to merge.

> It's a debugging tool, and should never be used in the kernel proper. It
> was meant for users to use it for debugging and then strip it out.
> 
> Now what you could do is to set up tracepoints to record the information
> you want, either in the function itself, or add the wrapper function too
> as a separate policy. Not sure if that would be any help or not.
> 
> But unless this is something that is considered "debug use only" and
> never put into a production kernel, do not use trace_printk().

It really is debug only, but I cannot promise nobody will ever add a
trace layer in production -- especially if it is as easy as using
"trace+mq" vs "mq" when specifying the policy name.

> Note, tracepoints will also give you the ability to pick and choose the
> traces instead of doing it by trace_level.

Yeap, I'm aware.

Thanks for your feedback Steve.
