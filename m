From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] dm writecache: reject asynchronous pmem.
Date: Tue, 30 Jun 2020 11:02:19 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006301101210.24028@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200630133546.GA20439@redhat.com> <20200630145335.1185-1-msuchanek@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200630145335.1185-1-msuchanek@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Suchanek <msuchanek@suse.de>
Cc: linux-nvdimm@lists.01.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Jan Kara <jack@suse.cz>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Yuval Shaia <yuval.shaia@oracle.com>, Dan Williams <dan.j.williams@intel.com>, Cornelia Huck <cohuck@redhat.com>, Pankaj Gupta <pagupta@redhat.com>, Jakub Staron <jstaron@google.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Tue, 30 Jun 2020, Michal Suchanek wrote:

> The writecache driver does not handle asynchronous pmem. Reject it when
> supplied as cache.
> 
> Link: https://lore.kernel.org/linux-nvdimm/87lfk5hahc.fsf@linux.ibm.com/
> Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> 
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>

OK. I suggest to move this test before persistent_memory_claim (so that 
you don't try to map the whole device).

Mikulas

> ---
>  drivers/md/dm-writecache.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 30505d70f423..1e4f37249e28 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -2271,6 +2271,12 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  			ti->error = "Unable to map persistent memory for cache";
>  			goto bad;
>  		}
> +
> +		if (!dax_synchronous(wc->ssd_dev->dax_dev)) {
> +			r = -EOPNOTSUPP;
> +			ti->error = "Asynchronous persistent memory not supported as pmem cache";
> +			goto bad;
> +		}
>  	} else {
>  		size_t n_blocks, n_metadata_blocks;
>  		uint64_t n_bitmap_bits;
> -- 
> 2.26.2
> 
