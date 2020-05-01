From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 0/3] Historical Service Time Path Selector
Date: Fri, 1 May 2020 14:03:39 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2005011355270.29501@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200428005146.242231-1-krisman@collabora.com>
	<85lfmcrhif.fsf@collabora.com> <20200430183335.GA29892@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200430183335.GA29892@redhat.com>
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
Cc: Bryn Reeves <breeves@redhat.com>, khazhy@google.com, dm-devel@redhat.com, kernel@collabora.com, Gabriel Krisman Bertazi <krisman@collabora.com>, agk@redhat.com
List-Id: dm-devel.ids



On Thu, 30 Apr 2020, Mike Snitzer wrote:

> On Thu, Apr 30 2020 at  1:49pm -0400,
> Gabriel Krisman Bertazi <krisman@collabora.com> wrote:
> 
> > Gabriel Krisman Bertazi <krisman@collabora.com> writes:
> > 
> > > Hi Mike,
> > >
> > > Please find an updated version of HST integrating the change you
> > > requested to also support BIO based multipath.  I hope you don't mind me
> > > folding the function you implemented into patch 2.  If you prefer, I can
> > > integrate a patch you provide into the series.
> > 
> > Hi Mike,
> > 
> > Sorry for the encapsulation patches, I'll pass the parameter directly on
> > v3.
> 
> Great, thanks.
> 
> > > One interesting data point is that the selection performance on
> > > BIO-based is worse when compared to request-based.  I tested a bit and I
> > > believe the reason is that the paths are more sticky because the bucket
> > > is too large, and it takes longer for HST to detect differences.  By
> > > changing the bucket_size indirectly through the bucket_shift, the
> > > bio-based multipath performance improved, but I'm not sure this is a
> > > knob we want to expose to users.  For now, please consider the patches
> > > below, for review.
> > >
> > 
> > The reason for the BIO-based being worse than request-based was that we
> > are comparing the jiffies_to_nsecs(jiffies) with ktime_get_ns(), which is not
> > accurate, given the different precision of the clocks.  Problem is,
> > request-based mpath uses ktime_get_ns in the block layer, while
> > dm_io->start_time uses jiffies, and inside the path selector, we don't
> > have a way to distinguish those paths.  I see a few ways forward, but in
> > the best interest of getting it right early, I'd like to hear what you
> > think it is best:
> > 
> > 1) My best suggestion would be converting dm_io->start_time to use
> > ktime_get_ns.  This has the advantage of simplifying dm_stats_account_io
> > and wouldn't affect the ABI of the accounting histogram.  The only
> > downside, from what I can see is that ktime_get is slightly more
> > expensive than reading jiffies, which might be a problem according to
> > Documentation/admin-guide/device-mapper/statistics.rst.  Is that really
> > a problem?
> 
> We should check with Mikulas (now cc'd) but given the speed improvements
> of storage we'll likely need to use "precise_timestamps" going forward
> anyway.
> 
> So I'm inclined to just take the hit of ktime_get_ns().  Mikulas would
> you be OK with this?

You can use ktime_get_ns() inside the multipath target. But I wouldn't use 
it in the general device mapper code because it would slow down 
everything.

I suggest to use ktime_get_ns() in the multipath map routine and in the 
the end_io routine and subract these two values to get precise time. I 
think that we don't need to hack generic dm code with that.

Mikulas
