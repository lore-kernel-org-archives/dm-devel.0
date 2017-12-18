From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] persistent-data: fix bug about btree of
 updating internal node's minima key in btree_split_beneath.
Date: Mon, 18 Dec 2017 17:13:08 +0000
Message-ID: <20171218171307.obyq62v3jt4lgqwg@reti>
References: <20171218212758.GA12360@yyp.>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171218212758.GA12360@yyp.>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: monty_pavel@sina.com
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

Hi Monty,

On Mon, Dec 18, 2017 at 04:27:58PM -0500, monty wrote:
> Subject: [PATCH] persistent-data: fix bug about btree of updating internal node's minima
>  key in btree_split_beneath.
> 
>  fix bug about btree_split_beneath func, this bug may cause a key had
>  been inserted to btree, but dm_btree_lookup can not find the key in
>  btree later.

I think you've spotted a real issue, but I don't like where you've
fixed up the btree_split_beneath() function.  I'll post a patch in a
bit.

How did you recreate this bug?

Thanks,

- Joe


> 
> Signed-off-by: monty <monty_pavel@sina.com>
> ---
>  drivers/md/persistent-data/dm-btree.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
> index f21ce6a..25ce5ec 100644
> --- a/drivers/md/persistent-data/dm-btree.c
> +++ b/drivers/md/persistent-data/dm-btree.c
> @@ -694,6 +694,8 @@ static int btree_split_beneath(struct shadow_spine *s, uint64_t key)
>  	if (key < le64_to_cpu(rn->keys[0])) {
>  		unlock_block(s->info, right);
>  		s->nodes[1] = left;
> +		if (key < le64_to_cpu(ln->keys[0]))
> +			ln->keys[0] = cpu_to_le64(key);
>  	} else {
>  		unlock_block(s->info, left);
>  		s->nodes[1] = right;
> -- 
> 1.7.1
> 

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
