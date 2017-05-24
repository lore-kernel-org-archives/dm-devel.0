From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 02/15] scsi/osd: don't save block errors into req_results
Date: Wed, 24 May 2017 16:04:40 +0000
Message-ID: <1495641879.2823.7.camel@sandisk.com>
References: <20170518131812.22956-1-hch@lst.de>
         <20170518131812.22956-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170518131812.22956-3-hch@lst.de>
Content-Language: en-US
Content-ID: <A65B3190B0A27E4FAF10FA6E7EC0FE4E@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, 2017-05-18 at 15:17 +0200, Christoph Hellwig wrote:
> We will only have sense data if the command exectured and got a SCSI
> result, so this is pointless.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/osd/osd_initiator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_init=
iator.c
> index 8a1b94816419..14785177ce7b 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -477,7 +477,7 @@ static void _set_error_resid(struct osd_request *or, =
struct request *req,
>  			     int error)
>  {
>  	or->async_error =3D error;
> -	or->req_errors =3D scsi_req(req)->result ? : error;
> +	or->req_errors =3D scsi_req(req)->result;
>  	or->sense_len =3D scsi_req(req)->sense_len;
>  	if (or->sense_len)
>  		memcpy(or->sense, scsi_req(req)->sense, or->sense_len);

Hello Christoph,

Are you sure that that code is not necessary? From osd_initiator.c:

static void _put_request(struct request *rq)
{
	/*
	 * If osd_finalize_request() was called but the request was not
	 * executed through the block layer, then we must release BIOs.
	 * TODO: Keep error code in or->async_error. Need to audit all
	 *=A0=A0=A0=A0=A0=A0=A0code paths.
	 */
	if (unlikely(rq->bio))
		blk_end_request(rq, -ENOMEM, blk_rq_bytes(rq));
	else
		blk_put_request(rq);
}

Bart.=
