From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 0/3] Historical Service Time Path Selector
Date: Thu, 30 Apr 2020 14:33:35 -0400
Message-ID: <20200430183335.GA29892@redhat.com>
References: <20200428005146.242231-1-krisman@collabora.com>
	<85lfmcrhif.fsf@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <85lfmcrhif.fsf@collabora.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: Bryn Reeves <breeves@redhat.com>, khazhy@google.com, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, kernel@collabora.com, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Apr 30 2020 at  1:49pm -0400,
Gabriel Krisman Bertazi <krisman@collabora.com> wrote:

> Gabriel Krisman Bertazi <krisman@collabora.com> writes:
> 
> > Hi Mike,
> >
> > Please find an updated version of HST integrating the change you
> > requested to also support BIO based multipath.  I hope you don't mind me
> > folding the function you implemented into patch 2.  If you prefer, I can
> > integrate a patch you provide into the series.
> 
> Hi Mike,
> 
> Sorry for the encapsulation patches, I'll pass the parameter directly on
> v3.

Great, thanks.

> > One interesting data point is that the selection performance on
> > BIO-based is worse when compared to request-based.  I tested a bit and I
> > believe the reason is that the paths are more sticky because the bucket
> > is too large, and it takes longer for HST to detect differences.  By
> > changing the bucket_size indirectly through the bucket_shift, the
> > bio-based multipath performance improved, but I'm not sure this is a
> > knob we want to expose to users.  For now, please consider the patches
> > below, for review.
> >
> 
> The reason for the BIO-based being worse than request-based was that we
> are comparing the jiffies_to_nsecs(jiffies) with ktime_get_ns(), which is not
> accurate, given the different precision of the clocks.  Problem is,
> request-based mpath uses ktime_get_ns in the block layer, while
> dm_io->start_time uses jiffies, and inside the path selector, we don't
> have a way to distinguish those paths.  I see a few ways forward, but in
> the best interest of getting it right early, I'd like to hear what you
> think it is best:
> 
> 1) My best suggestion would be converting dm_io->start_time to use
> ktime_get_ns.  This has the advantage of simplifying dm_stats_account_io
> and wouldn't affect the ABI of the accounting histogram.  The only
> downside, from what I can see is that ktime_get is slightly more
> expensive than reading jiffies, which might be a problem according to
> Documentation/admin-guide/device-mapper/statistics.rst.  Is that really
> a problem?

We should check with Mikulas (now cc'd) but given the speed improvements
of storage we'll likely need to use "precise_timestamps" going forward
anyway.

So I'm inclined to just take the hit of ktime_get_ns().  Mikulas would
you be OK with this?

> I see your FIXME note on the function you implemented, but
> are you suggesting exactly this or simply storing
> jiffies_to_nsecs(jiffies) in dm_io->start_time?

Yes, I am suggesting exactly this (1) in that FIXME.

> As you can see, I'm leaning towards option 1.  Would you be open to a
> patch like the following?  Completely untested, still need some work,
> just to show the idea.

Yes, follow-on work would be something like the patch you provided.
Only nit I see is we should rename io->start_time to io->start_time_ns

But please keep this patch (that does the work to address the "FIXME" I
added) separate from your HST patchset.  The need to improve bio-based
HST is a secondary concern given bio-based multipath isn't widely
deployed AFAICT.  So we can address the conversion to nanoseconds with
later followon work that builds on your initial HST patchset.

Thanks,
Mike
