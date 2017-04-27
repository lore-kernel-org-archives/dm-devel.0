From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/13] dm-rq: Check blk_mq_register_dev()
 return value
Date: Thu, 27 Apr 2017 07:49:19 +0200
Message-ID: <9b7d93d6-5844-460c-db15-89b31f10821e@suse.de>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
	<20170426183728.10821-7-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170426183728.10821-7-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On 04/26/2017 08:37 PM, Bart Van Assche wrote:
> blk_mq_register_dev() can fail. Hence check the return value of
> that function.
> =

> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-rq.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> =

> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index ba5694be55a4..3ff7280f5dc5 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -813,10 +813,14 @@ int dm_mq_init_request_queue(struct mapped_device *=
md, struct dm_table *t)
>  	dm_init_md_queue(md);
>  =

>  	/* backfill 'mq' sysfs registration normally done in blk_register_queue=
 */
> -	blk_mq_register_dev(disk_to_dev(md->disk), q);
> +	err =3D blk_mq_register_dev(disk_to_dev(md->disk), q);
> +	if (err)
> +		goto free_queue;
>  =

>  	return 0;
>  =

> +free_queue:
> +	blk_cleanup_queue(q);
>  out_tag_set:
>  	blk_mq_free_tag_set(md->tag_set);
>  out_kfree_tag_set:
> =

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
