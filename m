From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC][PATCH] dm: improve read performance
Date: Mon, 27 Dec 2010 22:54:59 +1100
Message-ID: <20101227225459.5a5150ab@notabene.brown>
References: <201012271219.56476.mume@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201012271219.56476.mume@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com, akpm@linux-foundation.org, snitzer@redhat.com, linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com, cotte@de.ibm.com, ehrhardt@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Mon, 27 Dec 2010 12:19:55 +0100 Mustafa Mesanovic
<mume@linux.vnet.ibm.com> wrote:

> From: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
> 
> A short explanation in prior: in this case we have "stacked" dm devices. 
> Two multipathed luns combined together to one striped logical volume.
> 
> I/O throughput degradation happens at __bio_add_page when bio's get checked 
> upon max_sectors. In this setup max_sectors is always set to 8 -> what is 
> 4KiB.
> A standalone striped logical volume on luns which are not multipathed do not 
> have the problem: the logical volume will take over the max_sectors from luns 
> below. 
> 
> Same happens with luns which are multipathed -> the multipathed targets have 
> the same max_sectors as the luns below.
> 
> So "magic" happens only when target has no own merge_fn and below lying 
> devices
> have a merge function -> we got then max_sectors=PAGE_SIZE >> 9.
> This patch prevents that max_sectors will be set to PAGE_SIZE >> 9.
> Instead it will use the minimum max_sectors value from below devices.
> 
> Using the patch improves read I/O up to 3x. In this specific case from 600MiB/s
> up to 1800MiB/s.

and using this patch will cause IO to fail sometimes.
If an IO request which is larger than a page crosses a device boundary in the
underlying e.g. RAID0, the RAID0 will return an error as such things should
not happen - they are prevented by merge_bvec_fn.

If merge_bvec_fn is not being honoured, then you MUST limit requests to a
single entry iovec of at most one page.

NeilBrown


> 
> Signed-off-by: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
> ---
> 
>  dm-table.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/dm-table.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-table.c	2010-12-23 13:49:18.000000000 +0100
> +++ linux-2.6/drivers/md/dm-table.c	2010-12-23 13:50:22.000000000 +0100
> @@ -518,7 +518,7 @@
>  
>  	if (q->merge_bvec_fn && !ti->type->merge)
>  		blk_limits_max_hw_sectors(limits,
> -					  (unsigned int) (PAGE_SIZE >> 9));
> +					  q->limits.max_sectors);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(dm_set_device_limits);
