From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v3] dm writecache: reject asynchronous pmem.
Date: Tue, 30 Jun 2020 12:11:43 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006301210270.24082@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006301101210.24028@file01.intranet.prod.int.rdu2.redhat.com>
	<20200630154924.3283-1-msuchanek@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200630154924.3283-1-msuchanek@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michal Suchanek <msuchanek@suse.de>
Cc: Cornelia Huck <cohuck@redhat.com>, Jan Kara <jack@suse.cz>, Jakub Staron <jstaron@google.com>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, Yuval Shaia <yuval.shaia@oracle.com>, dm-devel@redhat.com, Dan Williams <dan.j.williams@intel.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Tue, 30 Jun 2020, Michal Suchanek wrote:

> The writecache driver does not handle asynchronous pmem. Reject it when
> supplied as cache.
> 
> Link: https://lore.kernel.org/linux-nvdimm/87lfk5hahc.fsf@linux.ibm.com/
> Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> 
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-writecache.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 30505d70f423..5358894bb9fd 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -2266,6 +2266,12 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	}
>  
>  	if (WC_MODE_PMEM(wc)) {
> +		if (!dax_synchronous(wc->ssd_dev->dax_dev)) {
> +			r = -EOPNOTSUPP;
> +			ti->error = "Asynchronous persistent memory not supported as pmem cache";
> +			goto bad;
> +		}
> +
>  		r = persistent_memory_claim(wc);
>  		if (r) {
>  			ti->error = "Unable to map persistent memory for cache";
> -- 
> 2.26.2
> 
