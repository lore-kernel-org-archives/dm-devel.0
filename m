From: "Xiao, Jin" <jin.xiao@intel.com>
Subject: Re: [PATCH] dm verity: don't crash on vmallocated buffer
Date: Mon, 10 Sep 2018 10:51:24 +0800
Message-ID: <5ce5ff94-893e-d3b6-f70c-a07fdb9aba9c@intel.com>
References: <alpine.LRH.2.02.1808221238350.30929@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1808221238350.30929@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
Cc: Eric Biggers <ebiggers3@gmail.com>, yanmin.zhang@intel.com, Gilad Ben-Yossef <gilad@benyossef.com>, =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek+linux-crypto@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

I have tested the patch. It works. Thanks.

Jin

On 8/23/2018 12:45 AM, Mikulas Patocka wrote:
> Since the commit d1ac3ff008fb ("dm verity: switch to using asynchronous"+
> hash crypto API"), dm-verity uses asynchronous crypto calls for
> verification, so that it can use hardware with asynchronous processing of
> crypto operations.
>
> These asynchronous calls don't support vmalloc memory, but the buffer data
> can be vmallocated if dm-bufio is short of memory and uses a reserved
> buffer that was preallocated in dm_bufio_client_create.
>
> This patch fixes verity_hash_update, so that it deals with vmallocated
> memory correctly.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: "Xiao, Jin" <jin.xiao@intel.com>
> Fixes: d1ac3ff008fb ("dm verity: switch to using asynchronous hash crypto API")
> Cc: stable@vger.kernel.org	# 4.11+
>
> ---
>   drivers/md/dm-verity-target.c |   24 ++++++++++++++++++++----
>   1 file changed, 20 insertions(+), 4 deletions(-)
>
> Index: linux-2.6/drivers/md/dm-verity-target.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-verity-target.c	2018-08-22 17:18:30.800000000 +0200
> +++ linux-2.6/drivers/md/dm-verity-target.c	2018-08-22 17:22:14.810000000 +0200
> @@ -99,10 +99,26 @@ static int verity_hash_update(struct dm_
>   {
>   	struct scatterlist sg;
>   
> -	sg_init_one(&sg, data, len);
> -	ahash_request_set_crypt(req, &sg, NULL, len);
> -
> -	return crypto_wait_req(crypto_ahash_update(req), wait);
> +	if (likely(!is_vmalloc_addr(data))) {
> +		sg_init_one(&sg, data, len);
> +		ahash_request_set_crypt(req, &sg, NULL, len);
> +		return crypto_wait_req(crypto_ahash_update(req), wait);
> +	} else {
> +		do {
> +			int r;
> +			size_t this_step = min(len, PAGE_SIZE - offset_in_page(data));
> +			flush_kernel_vmap_range((void *)data, this_step);
> +			sg_init_table(&sg, 1);
> +			sg_set_page(&sg, vmalloc_to_page(data), this_step, offset_in_page(data));
> +			ahash_request_set_crypt(req, &sg, NULL, this_step);
> +			r = crypto_wait_req(crypto_ahash_update(req), wait);
> +			if (unlikely(r))
> +				return r;
> +			data += this_step;
> +			len -= this_step;
> +		} while (len);
> +		return 0;
> +	}
>   }
>   
>   /*
