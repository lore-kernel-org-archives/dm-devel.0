From: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH] dm zoned: Potential NULL dereference in
	dmz_do_reclaim()
Date: Mon, 19 Aug 2019 16:11:18 +0000
Message-ID: <d53fb01681501c2a777f74a3acc145df37b97458.camel@wdc.com>
References: <20190819095814.GA19905@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190819095814.GA19905@mwanda>
Content-Language: en-US
Content-ID: <7183DCDF3A8793459F8D2975F778DB12@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "agk@redhat.com" <agk@redhat.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

Dan,

On Mon, 2019-08-19 at 12:58 +0300, Dan Carpenter wrote:
> This function is supposed to return error pointers so it matches the
> dmz_get_rnd_zone_for_reclaim() function.  The current code could lead to
> a NULL dereference in dmz_do_reclaim()
> 
> Fixes: b234c6d7a703 ("dm zoned: improve error handling in reclaim")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/md/dm-zoned-metadata.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 2a5bc51fd6d5..595a73110e17 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1588,7 +1588,7 @@ static struct dm_zone *dmz_get_seq_zone_for_reclaim(struct dmz_metadata *zmd)
>  	struct dm_zone *zone;
>  
>  	if (list_empty(&zmd->map_seq_list))
> -		return NULL;
> +		return ERR_PTR(-EBUSY);
>  
>  	list_for_each_entry(zone, &zmd->map_seq_list, link) {
>  		if (!zone->bzone)
> @@ -1597,7 +1597,7 @@ static struct dm_zone *dmz_get_seq_zone_for_reclaim(struct dmz_metadata *zmd)
>  			return zone;
>  	}
>  
> -	return NULL;
> +	return ERR_PTR(-EBUSY);
>  }
>  
>  /*

thanks for noticing this -

Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
