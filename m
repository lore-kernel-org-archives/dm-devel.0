Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B364ECAAD8
	for <dm-devel@archiver.kernel.org>; Fri, 16 Sep 2022 08:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663317907;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=6lajK5Z3ogtRikqiFuLQdmQZ+iMdH8ECDY/74OEsHiU=;
	b=ASREE6N1hDB+Ef6FELv6QYeLo8YH2eTkEbQR/SiZ3XAzMaz93gJ8ol9PRB8Um4Tr1lBJ5N
	9pCrohjpRvLZiYMhgl6qstrjB5aJS5hUBgBaaVG4cT6UctvGTNgOMr2d4q8KPviYW6BHWm
	fn4xWoeEfS1Zn3lAU53B6gCZZKuT66s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-26_51TyoMnK0Ent3UeyKdw-1; Fri, 16 Sep 2022 04:45:05 -0400
X-MC-Unique: 26_51TyoMnK0Ent3UeyKdw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38D8180A0A6;
	Fri, 16 Sep 2022 08:44:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 270E21121314;
	Fri, 16 Sep 2022 08:44:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8A9ED1947041;
	Fri, 16 Sep 2022 08:44:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 97E181946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Sep 2022 05:48:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7370D49BB60; Fri, 16 Sep 2022 05:48:07 +0000 (UTC)
Received: from localhost (unknown [10.39.192.86])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A3A32492CA4;
 Fri, 16 Sep 2022 05:48:06 +0000 (UTC)
Date: Fri, 16 Sep 2022 06:48:05 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <YyQOFTI4CWn041UM@fedora>
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-4-sarthakkukreti@google.com>
MIME-Version: 1.0
In-Reply-To: <20220915164826.1396245-4-sarthakkukreti@google.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Fri, 16 Sep 2022 08:44:55 +0000
Subject: Re: [dm-devel] [PATCH RFC 3/8] virtio_blk: Add support for
 provision requests
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-ext4@vger.kernel.org, Evan Green <evgreen@google.com>,
 Alasdair Kergon <agk@redhat.com>
Content-Type: multipart/mixed; boundary="===============5997706963509404659=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3


--===============5997706963509404659==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WxlpI8UNA4dyQSlO"
Content-Disposition: inline


--WxlpI8UNA4dyQSlO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 15, 2022 at 09:48:21AM -0700, Sarthak Kukreti wrote:
> From: Sarthak Kukreti <sarthakkukreti@chromium.org>
>=20
> Adds support for provision requests. Provision requests act like
> the inverse of discards.
>=20
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  drivers/block/virtio_blk.c      | 48 +++++++++++++++++++++++++++++++++
>  include/uapi/linux/virtio_blk.h |  9 +++++++
>  2 files changed, 57 insertions(+)

Please send a VIRTIO spec patch too:
https://github.com/oasis-tcs/virtio-spec#providing-feedback

Stefan

>=20
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 30255fcaf181..eacc2bffe1d1 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -178,6 +178,39 @@ static int virtblk_setup_discard_write_zeroes(struct=
 request *req, bool unmap)
>  	return 0;
>  }
> =20
> +static int virtblk_setup_provision(struct request *req)
> +{
> +	unsigned short segments =3D blk_rq_nr_discard_segments(req);
> +	unsigned short n =3D 0;
> +
> +	struct virtio_blk_discard_write_zeroes *range;
> +	struct bio *bio;
> +	u32 flags =3D 0;
> +
> +	range =3D kmalloc_array(segments, sizeof(*range), GFP_ATOMIC);
> +	if (!range)
> +		return -ENOMEM;
> +
> +	__rq_for_each_bio(bio, req) {
> +		u64 sector =3D bio->bi_iter.bi_sector;
> +		u32 num_sectors =3D bio->bi_iter.bi_size >> SECTOR_SHIFT;
> +
> +		range[n].flags =3D cpu_to_le32(flags);
> +		range[n].num_sectors =3D cpu_to_le32(num_sectors);
> +		range[n].sector =3D cpu_to_le64(sector);
> +		n++;
> +	}
> +
> +	WARN_ON_ONCE(n !=3D segments);
> +
> +	req->special_vec.bv_page =3D virt_to_page(range);
> +	req->special_vec.bv_offset =3D offset_in_page(range);
> +	req->special_vec.bv_len =3D sizeof(*range) * segments;
> +	req->rq_flags |=3D RQF_SPECIAL_PAYLOAD;
> +
> +	return 0;
> +}
> +
>  static void virtblk_unmap_data(struct request *req, struct virtblk_req *=
vbr)
>  {
>  	if (blk_rq_nr_phys_segments(req))
> @@ -243,6 +276,9 @@ static blk_status_t virtblk_setup_cmd(struct virtio_d=
evice *vdev,
>  	case REQ_OP_DRV_IN:
>  		type =3D VIRTIO_BLK_T_GET_ID;
>  		break;
> +	case REQ_OP_PROVISION:
> +		type =3D VIRTIO_BLK_T_PROVISION;
> +		break;
>  	default:
>  		WARN_ON_ONCE(1);
>  		return BLK_STS_IOERR;
> @@ -256,6 +292,11 @@ static blk_status_t virtblk_setup_cmd(struct virtio_=
device *vdev,
>  			return BLK_STS_RESOURCE;
>  	}
> =20
> +	if (type =3D=3D VIRTIO_BLK_T_PROVISION) {
> +		if (virtblk_setup_provision(req))
> +			return BLK_STS_RESOURCE;
> +	}
> +
>  	return 0;
>  }
> =20
> @@ -1075,6 +1116,12 @@ static int virtblk_probe(struct virtio_device *vde=
v)
>  		blk_queue_max_write_zeroes_sectors(q, v ? v : UINT_MAX);
>  	}
> =20
> +	if (virtio_has_feature(vdev, VIRTIO_BLK_F_PROVISION)) {
> +		virtio_cread(vdev, struct virtio_blk_config,
> +			     max_provision_sectors, &v);
> +		q->limits.max_provision_sectors =3D v ? v : UINT_MAX;
> +	}
> +
>  	virtblk_update_capacity(vblk, false);
>  	virtio_device_ready(vdev);
> =20
> @@ -1177,6 +1224,7 @@ static unsigned int features[] =3D {
>  	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
>  	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
>  	VIRTIO_BLK_F_MQ, VIRTIO_BLK_F_DISCARD, VIRTIO_BLK_F_WRITE_ZEROES,
> +	VIRTIO_BLK_F_PROVISION,
>  };
> =20
>  static struct virtio_driver virtio_blk =3D {
> diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_=
blk.h
> index d888f013d9ff..184f8cf6d185 100644
> --- a/include/uapi/linux/virtio_blk.h
> +++ b/include/uapi/linux/virtio_blk.h
> @@ -40,6 +40,7 @@
>  #define VIRTIO_BLK_F_MQ		12	/* support more than one vq */
>  #define VIRTIO_BLK_F_DISCARD	13	/* DISCARD is supported */
>  #define VIRTIO_BLK_F_WRITE_ZEROES	14	/* WRITE ZEROES is supported */
> +#define VIRTIO_BLK_F_PROVISION	15	/* provision is supported */
> =20
>  /* Legacy feature bits */
>  #ifndef VIRTIO_BLK_NO_LEGACY
> @@ -120,6 +121,11 @@ struct virtio_blk_config {
>  	 */
>  	__u8 write_zeroes_may_unmap;
> =20
> +	/*
> +	 * The maximum number of sectors in a provision request.
> +	 */
> +	__virtio32 max_provision_sectors;
> +
>  	__u8 unused1[3];
>  } __attribute__((packed));
> =20
> @@ -155,6 +161,9 @@ struct virtio_blk_config {
>  /* Write zeroes command */
>  #define VIRTIO_BLK_T_WRITE_ZEROES	13
> =20
> +/* Provision command */
> +#define VIRTIO_BLK_T_PROVISION	14
> +
>  #ifndef VIRTIO_BLK_NO_LEGACY
>  /* Barrier before this op. */
>  #define VIRTIO_BLK_T_BARRIER	0x80000000
> --=20
> 2.31.0
>=20

--WxlpI8UNA4dyQSlO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmMkDhUACgkQnKSrs4Gr
c8gBhQgAj+eIGn+EzZHnyfSo8pzDA7drzmOv94LW83kiyVOI6JYdh+aEYYM6sHMf
gTVFR82rkR3Jpj8bMomZZJIkz09CWWsK9XZkdcWQmzpxhYzm84OeHzXPsntLROaV
8G0rf2XUIw/g4LfPPklrIu0MVRVv5vQLEM5u081LPctLvVBcyfB4t71eAuHU8+Ie
sIK/jDO6DNq2mTF9WGQGI8woLPJfAYEdX+la5V0rbYnVlhgGOqDcYItfU4O7anIf
vLoxcSpIcERwLOpTkgI4OWFHUx1GAVNLKHSqlOQ2DA9E3nt6+N0GSdl8qkduMTbz
CuMD4dvXFaIBzJR3jQvZbvWblmORmg==
=oVLJ
-----END PGP SIGNATURE-----

--WxlpI8UNA4dyQSlO--

--===============5997706963509404659==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5997706963509404659==--

