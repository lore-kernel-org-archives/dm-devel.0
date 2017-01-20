From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] dm bio prison: use rb_entry()
Date: Fri, 20 Jan 2017 23:12:59 +0800
Message-ID: <478774bc-7af1-58a6-7c3e-36745249d61b@suse.de>
References: <c6a809ea5820242a4ae126b03cdcd910a36e5cae.1484817152.git.geliangtang@gmail.com>
 <edf46b9e198bf2b0c0a31a9b99da6e59e880cdb9.1484816756.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <edf46b9e198bf2b0c0a31a9b99da6e59e880cdb9.1484816756.git.geliangtang@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 2017/1/20 下午10:36, Geliang Tang wrote:
> To make the code clearer, use rb_entry() instead of container_of() to
> deal with rbtree.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
>  drivers/md/dm-bio-prison.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-bio-prison.c b/drivers/md/dm-bio-prison.c
> index 03af174..a2c8a9e 100644
> --- a/drivers/md/dm-bio-prison.c
> +++ b/drivers/md/dm-bio-prison.c
> @@ -115,7 +115,7 @@ static int __bio_detain(struct dm_bio_prison *prison,
>  
>  	while (*new) {
>  		struct dm_bio_prison_cell *cell =
> -			container_of(*new, struct dm_bio_prison_cell, node);
> +			rb_entry(*new, struct dm_bio_prison_cell, node);
>  
>  		r = cmp_keys(key, &cell->key);
>  
> 
Acked-by: Coly Li <colyli@suse.de>


