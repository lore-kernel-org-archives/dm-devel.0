From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 8/17] bottom-layer barrier support
Date: Mon, 27 Apr 2009 19:21:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904271914440.9362@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<20090427190222.GE23302@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090427190222.GE23302@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 27 Apr 2009, Alasdair G Kergon wrote:

> On Mon, Apr 20, 2009 at 03:58:20AM -0400, Mikulas Patocka wrote:
> > dm-flush-make-empty-barrier.patch
> > Modify dm_flush so that is passes empty barrier flushes to the targets.
>  
> > +	md->barrier_bio.bi_bdev = md->bdev;
> 
> There is no md->bdev in my tree - have I missed a dependency here?
> 
> Alasdair

That is from two patches:
http://people.redhat.com/mpatocka/patches/kernel/misc/2.6.29-rc8/dm-bdev-rename-suspended_bdev-to-bdev.patch
and
http://people.redhat.com/mpatocka/patches/kernel/misc/2.6.29-rc8/dm-bdev-keep-bdev-always-referenced.patch

They are old and fix memory-allocation-while-suspended violation.

Do you want to accept them?

There should be bdev value of the md device in bi_bdev, most targets don't 
care about it, but for correctness, we should supply a correct value.

If you don't want to accept the correct patches, we must make up some 
dummy value for bi_bdev and review targets that they don't care about the 
value (I consider it somehow hacky to place dummy values to bio fields for 
targets, and I'd rather put the "keep-bdev-always-referenced" patch in).

Another possibility would be to get bdev from submitted barrier request.

Which of these ways do you want to go?

Mikulas
