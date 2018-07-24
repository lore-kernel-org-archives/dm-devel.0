From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: data corruption with 'splt' workload to XFS on DM
 cache with its 3 underlying devices being on same NVMe device
Date: Tue, 24 Jul 2018 11:18:45 -0400
Message-ID: <20180724151845.GB3235@redhat.com>
References: <20180723163357.GA29658@redhat.com>
	<e761830f-e3f7-3e88-1697-b4b150e84e5f@suse.de>
	<20180724130703.GA30804@redhat.com>
	<27cadfb3-2442-3931-6d58-58aa6adb2e2b@suse.de>
	<1532440623.9819.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1532440623.9819.4.camel@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Laurence Oberman <loberman@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

On Tue, Jul 24 2018 at  9:57am -0400,
Laurence Oberman <loberman@redhat.com> wrote:

> On Tue, 2018-07-24 at 15:51 +0200, Hannes Reinecke wrote:
> > 
> > _Actually_, I would've done it the other way around; after all,
> > where't the point in running dm-multipath on a partition?
> > Anything running on the other partitions would suffer from the
> > issues dm-multipath is designed to handle (temporary path loss etc), so I'm
> > not quite sure what you are trying to achieve with your testcase.
> > Can you enlighten me?
> > 
> > Cheers,
> > 
> > Hannes

I wasn't looking to deply this (multipath on partition) in production or
suggest it to others.  It was a means to experiment.  More below.

> This came about because a customer is using nvme for a dm-cache device
> and created multiple partitions so as to use the same nvme to cache
> multiple different "slower" devices. The corruption was noticed in XFS
> and I engaged Mike to assist in figuring out what was going on.

Yes, so topology for the customer's setup is:

1) MD raid1 on 2 NVMe partitions (from separate NVMe devices).
2) Then DM cache's "fast" and "metadata" devices layered on dm-linear
   mapping ontop of the MD raid1.
3) Then Ceph's rbd for DM-cache's slow device.

I was just looking to simplify the stack to try to assess why XFS
corruption was being seen without all the insanity.

One issue was corruption due to incorrect shutdown order (network was
getting shutdown out from underneath rbd, and in turn DM-cache couldn't
complete its IO migrations during cache_postsuspend()).

So I elected to try using DM multipath with queue_if_no_path to try to
replicate rbd losing network _without_ needing a full Ceph/rbd setup.

The rest is history... a rat-hole of corruption that likely is very
different than the customer's setup.

Mike
