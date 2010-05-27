From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH v3 1/2] dm: prevent table type changes after
 initial table load
Date: Thu, 27 May 2010 12:11:38 +0900
Message-ID: <4BFDE2EA.80009@ct.jp.nec.com>
References: <1274798593-19418-1-git-send-email-snitzer@redhat.com>
	<1274798593-19418-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1274798593-19418-2-git-send-email-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Mike,

Some small comments below.

For others,
Acked-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

On 05/25/2010 11:43 PM +0900, Mike Snitzer wrote:
> @@ -1176,6 +1176,21 @@ static int table_load(struct dm_ioctl *p
>  		goto out;
>  	}
>  
> +	/* Protect md->type against concurrent table loads. */
> +	dm_lock_md_type(md);
> +	if (dm_get_md_type(md) == DM_TYPE_NONE) {
> +		/* initial table load, set md's type based on table's type */
> +		dm_set_md_type(md, t);

                dm_set_md_type(md, dm_table_get_type(t));

Although I don't impose this interface, I feel it is straightforward
for this function.  Then, dm_set_md_type() just set the type in md->type;

	void dm_set_md_type(struct mapped_device *md, unsigned type)
	{
		md->type = type;
	}

If you take the current interface, I feel it's not normal coding style;

> +void dm_set_md_type(struct mapped_device *md, struct dm_table* t)

Should be "dm_table *t" instead of "dm_table* t".


> @@ -66,6 +66,11 @@ int dm_table_alloc_md_mempools(struct dm
>  void dm_table_free_md_mempools(struct dm_table *t);
>  struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
>  
> +void dm_lock_md_type(struct mapped_device *md);
> +void dm_unlock_md_type(struct mapped_device *md);
> +void dm_set_md_type(struct mapped_device *md, struct dm_table* t);

The same coding style here.

Thanks,
Kiyoshi Ueda
