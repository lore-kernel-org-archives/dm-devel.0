From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm: reduce the number of processes per dm device
Date: Thu, 8 Oct 2015 15:59:31 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1510081553440.17984@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1510081214130.14961@file01.intranet.prod.int.rdu2.redhat.com>
	<20151008190817.GA12788@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151008190817.GA12788@redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Thu, 8 Oct 2015, Mike Snitzer wrote:

> On Thu, Oct 08 2015 at 12:15pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > The patch 54efd50bfd873e2dbf784e0b21a8027ba4299a3e ("block: make
> > generic_make_request handle arbitrarily sized bios") makes it possible for
> > block devices to process large bios. The patch allocates a new bio set
> > queue->bio_split for each device, this bio set is used for allocating bios
> > when the driver needs to split large bios.
> > 
> > Each bio_set allocates a workqueue process, thus the above patch increases
> > the number of processes allocated per block device.
> > 
> > Device mapper doesn't need the queue->bio_split bio_set, thus we can
> > deallocate it. This reduces the number of allocated processes per
> > dm-device from 3 to 2.
> 
> This header needs more context added, specifically we need to tell the
> reader the answer to: why doesn't DM need queue->bio_split?

Dm doesn't need queue->bio_split because it has its own bioset md->bs. We 
can't use queue->bio_split instead of md->bs because md->bs has non-zero 
front pad depending on targets loaded in the table.

> Is this a resource that only the lowest layer's request_queue would 
> need? And given DM's stacking nature it doesn't need it simply because 
> it'll never be the lowest layer?

All request-based drivers need queue->bio_split, but some non-dm bio-based 
drivers need it too.

I thought about removing bio_split for for all bio-based devices, but 
declined that because it could generate regressions in drivers that we are 
not able to test.

Mikulas
