From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v3 0/5] Optimize writecache when using pmem as cache
Date: Mon, 4 Feb 2019 06:27:34 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1902040606380.28217@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190131022955.9920-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190131022955.9920-1-yehs2007@zoho.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: snitzer@redhat.com, agk@redhat.com, dan.j.williams@intel.com, hch@lst.de, jack@suse.cz, corbet@lwn.net, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-doc@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids



On Thu, 31 Jan 2019, Huaisheng Ye wrote:

> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> This patch set could be used for dm-writecache when use persistent
> memory as cache data device.
> 
> Patch 1 and 2 go towards removing unused parameter and codes which
> actually doesn't really work.

I agree that there is some unused variables and code, but I would let it 
be as it is. The processors can write data to persistent memory either by 
using non-temporal stores (the movnti instruction) or by normal stores 
followed by the clwb instruction.

Currently, the movnti instruction is faster - however, it may be possible 
that with some newer processors, the clwb instruction could be faster - 
and in that case, we need the code that you have removed.

I would like to keep both flush strategies around (movnti and clwb), so 
that we can test how do they perform on various processors. 
Unfortunatelly, some upstream developers hate code with #ifdefs :-(

Note that compiler optimizations already remove the unused parameter and 
the impossible code behind "if (WC_MODE_PMEM(wc)) if (!WC_MODE_PMEM(wc))".

> Patch 3 and 4 are targeted at solving problem fn ctr failed to work
> due to invalid magic or version, which is caused by the super block
> of pmem has messy data stored.

LVM zeros the beginning of new logical volumes, so there should be no 
problem with it. If the user wants to use the writecache target without 
LVM, he should zero the superblock with dd if=/dev/zero of=/dev/pmem0 
bs=4k count=1

Note that other device mapper targets also follow this policy - for 
example see drivers/md/dm-snap-persistent.c:
        if (le32_to_cpu(dh->magic) == 0) {
                *new_snapshot = 1;
                return 0;
        }

        if (le32_to_cpu(dh->magic) != SNAP_MAGIC) {
                DMWARN("Invalid or corrupt snapshot");
                r = -ENXIO;
                goto bad;
        }

So, I think there is no need for these patches - dm-writecache just does 
what others targets do.

> Patch 5 is used for getting the status of seq_count.

It may be accepted if other LVM team members find some use for this value.

Mikulas

> Changes Since v2: 
>         - seq_count is important for flush operations, output it within status
>           for debugging and analyzing code behavior.
> 	[1]: https://lkml.org/lkml/2019/1/3/43
>         [2]: https://lkml.org/lkml/2019/1/9/6
> 
> Huaisheng Ye (5):
>   dm-writecache: remove unused size to writecache_flush_region
>   dm-writecache: get rid of memory_data flush to writecache_flush_entry
>   dm-writecache: expand pmem_reinit for struct dm_writecache
>   Documentation/device-mapper: add optional parameter reinit
>   dm-writecache: output seq_count within status
> 
>  Documentation/device-mapper/writecache.txt |  4 ++++
>  drivers/md/dm-writecache.c                 | 23 +++++++++++++----------
>  2 files changed, 17 insertions(+), 10 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> 
