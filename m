From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 30/45] block: copy bio op to request op
Date: Mon, 6 Jun 2016 08:48:24 +0200
Message-ID: <57551CB8.1070409@suse.de>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-31-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1465155145-10812-31-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 06/05/2016 09:32 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> =

> The bio users should now always be setting up the bio op. This patch
> has the block layer copy that to the request.
> =

> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  block/blk-core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> =

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 7e943dc..3c45254 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2976,8 +2976,7 @@ EXPORT_SYMBOL_GPL(__blk_end_request_err);
>  void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
>  		     struct bio *bio)
>  {
> -	/* Bit 0 (R/W) is identical in rq->cmd_flags and bio->bi_rw */
> -	rq->cmd_flags |=3D bio->bi_rw & REQ_WRITE;
> +	req_set_op(rq, bio_op(bio));
>  =

>  	if (bio_has_data(bio))
>  		rq->nr_phys_segments =3D bio_phys_segments(q, bio);
> @@ -3062,7 +3061,8 @@ EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
>  static void __blk_rq_prep_clone(struct request *dst, struct request *src)
>  {
>  	dst->cpu =3D src->cpu;
> -	dst->cmd_flags |=3D (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
> +	req_set_op_attrs(dst, req_op(src),
> +			 (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE);
>  	dst->cmd_type =3D src->cmd_type;
>  	dst->__sector =3D blk_rq_pos(src);
>  	dst->__data_len =3D blk_rq_bytes(src);
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
