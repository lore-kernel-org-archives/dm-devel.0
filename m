Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06178FBF4;
	Fri,  3 Nov 2023 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="r2rmGoKn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="r/MxdHIR"
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.west.internal (Postfix) with ESMTP id A2D313200935;
	Fri,  3 Nov 2023 12:15:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 03 Nov 2023 12:15:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1699028156; x=1699114556; bh=dHOdN0Q4arzDi1FH7Q2SMau1Y7NQ5Lx4NHg
	9xz7kfwE=; b=r2rmGoKn0sF3EVywj9Gn+J350GUEURJq4B1HpQA0HdI5GDSL5WH
	CbCvH8u/HzCP0rGfL1RaF7G/EpvTKYsvFEtQxSOkUvPJCv8VFgCm9ig8GkXuRY4g
	u2bN4/T1+U+CUlO7bfytE87EVXvJb9I9rucQB/hHIiT3Yirdi5YjKHSaWpaOEUqW
	x64hgecvajSI29oDfO5Yk4vpkWfML5rjVRV9vM2mllpBtLah/3ft/3Oqv5t8jubk
	Tp0cyvOh/bSo2Aj3oC/RXuTX5WHtvnbLPiq8W6leJfMxRZf7LPwjOph9Lc5s8suj
	5tG9AAQ+/vfleLv/0Opdq9t/rgryZPMDmoQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1699028156; x=1699114556; bh=dHOdN0Q4arzDi
	1FH7Q2SMau1Y7NQ5Lx4NHg9xz7kfwE=; b=r/MxdHIRgTd/0YVIADBIJWDu7kO+a
	EUuJsLTVGQDrUK+KK8TqVOkjI1Z7esYwfMGGVYFwhWkqZjgrAHqXLYCxwuO1qgw6
	KMFVlHlCKqCRSfIbJZ2ETnj7WP77O4Z/ZLhSrVCx/VvFpaLrQwC1WZA4WFNErQuJ
	mSQzWmD+ftgKgo5kKF3mTaSx8xcrty727PsoiayzNwxcwM5Frb0dlcYlqycuMZCL
	FJkpPipfvLYcGo+AQCXo/cDHDENJp3ruUq60aleG33UX9AueJQLQ6fIjpbQX+MLy
	sOprqEFtrWSyvlLYHgaDeSg+ALukbSOnDl7CnSb7Utge1vImgGL08piyA==
X-ME-Sender: <xms:uhxFZUrmhK51EFtUET7KK4LV_LvhQQ2xy26b_uc_i8OkQ_KuzodAxA>
    <xme:uhxFZaqlqnWg31Nkdzwa8G8I3OHu35O96gFCwav5yJlUMx7YDaJWFyiiCrECN98yb
    49dkYsgGVKALQ>
X-ME-Received: <xmr:uhxFZZOdl4ZN4lH7Uh3caymtOzEpef9yxYNxNEgEipYAZDRkS904tw5W3wiojgxSbauSQS4ltOIpnTTvoftnK8T53rA5qEUY2Cc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedruddtkedgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtroertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnheptdet
    vdfhkedutedvleffgeeutdektefhtefhfffhfeetgefhieegledvtddtkedtnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghk
    sehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:uhxFZb6Vh4iuXbJL0vWB7uJOxeJ3vhw62Qjx4SEy0kjebdu9zoeokQ>
    <xmx:uhxFZT46r_2oNLXVsA6qWtAk2srYSpwMLTCqOxfZzl8tFO9UJYVFpA>
    <xmx:uhxFZbgc_md_V4ka5vrYkBn_AFLKlhcIEXOK2gj_z-LGH5aqbBK7Fw>
    <xmx:vBxFZaLWP4LBgqd1GOXkat4N6-Ngrh4XN2c8jsu888icO4mFmDaUPg>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Nov 2023 12:15:51 -0400 (EDT)
Date: Fri, 3 Nov 2023 17:15:49 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZUUctamEFtAlSnSV@mail-itl>
References: <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>
 <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <8a35cdea-3a1a-e859-1f7c-55d1c864a48@redhat.com>
 <ebbc7ca7-5169-dbdc-9ea8-c6d8c3ae31e2@redhat.com>
 <ZULvkPhcpgAVyI8w@mail-itl>
 <ac5b5ac0-9e8-c1b0-a26-62f832f845f0@redhat.com>
 <ZUOL8kXVTF1OngeN@mail-itl>
 <3cb4133c-b6db-9187-a678-11ed8c9456e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FVS16JFHJ7btn9Q1"
Content-Disposition: inline
In-Reply-To: <3cb4133c-b6db-9187-a678-11ed8c9456e@redhat.com>


--FVS16JFHJ7btn9Q1
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Fri, 3 Nov 2023 17:15:49 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5

On Thu, Nov 02, 2023 at 06:06:33PM +0100, Mikulas Patocka wrote:
> Then, try this patch (without "iommu=3Dpanic"), reproduce the deadlock an=
d=20
> tell us which one of the "printk" statements is triggered during the=20
> deadlock.

The "821" one - see below.

> Mikulas
>=20
> ---
>  drivers/nvme/host/core.c |    8 ++++++--
>  drivers/nvme/host/pci.c  |   27 ++++++++++++++++++++++-----
>  2 files changed, 28 insertions(+), 7 deletions(-)
>=20
> Index: linux-stable/drivers/nvme/host/pci.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-stable.orig/drivers/nvme/host/pci.c	2023-10-31 15:35:38.0000000=
00 +0100
> +++ linux-stable/drivers/nvme/host/pci.c	2023-11-02 17:38:20.000000000 +0=
100
> @@ -622,6 +622,10 @@ static blk_status_t nvme_pci_setup_prps(
>  	prp_list =3D dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
>  	if (!prp_list) {
>  		iod->nr_allocations =3D -1;
> +		if (nprps <=3D (256 / 8))
> +			printk("allocation failure at %d\n", __LINE__);
> +		else
> +			printk("allocation failure at %d\n", __LINE__);
>  		return BLK_STS_RESOURCE;
>  	}
>  	iod->list[0].prp_list =3D prp_list;
> @@ -631,8 +635,10 @@ static blk_status_t nvme_pci_setup_prps(
>  		if (i =3D=3D NVME_CTRL_PAGE_SIZE >> 3) {
>  			__le64 *old_prp_list =3D prp_list;
>  			prp_list =3D dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
> -			if (!prp_list)
> +			if (!prp_list) {
> +				printk("allocation failure at %d\n", __LINE__);
>  				goto free_prps;
> +			}
>  			iod->list[iod->nr_allocations++].prp_list =3D prp_list;
>  			prp_list[0] =3D old_prp_list[i - 1];
>  			old_prp_list[i - 1] =3D cpu_to_le64(prp_dma);
> @@ -712,6 +718,7 @@ static blk_status_t nvme_pci_setup_sgls(
>  	sg_list =3D dma_pool_alloc(pool, GFP_ATOMIC, &sgl_dma);
>  	if (!sg_list) {
>  		iod->nr_allocations =3D -1;
> +		printk("allocation failure at %d\n", __LINE__);
>  		return BLK_STS_RESOURCE;
>  	}
> =20
> @@ -736,8 +743,10 @@ static blk_status_t nvme_setup_prp_simpl
>  	unsigned int first_prp_len =3D NVME_CTRL_PAGE_SIZE - offset;
> =20
>  	iod->first_dma =3D dma_map_bvec(dev->dev, bv, rq_dma_dir(req), 0);
> -	if (dma_mapping_error(dev->dev, iod->first_dma))
> +	if (dma_mapping_error(dev->dev, iod->first_dma)) {
> +		printk("allocation failure at %d\n", __LINE__);
>  		return BLK_STS_RESOURCE;
> +	}
>  	iod->dma_len =3D bv->bv_len;
> =20
>  	cmnd->dptr.prp1 =3D cpu_to_le64(iod->first_dma);
> @@ -755,8 +764,10 @@ static blk_status_t nvme_setup_sgl_simpl
>  	struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
> =20
>  	iod->first_dma =3D dma_map_bvec(dev->dev, bv, rq_dma_dir(req), 0);
> -	if (dma_mapping_error(dev->dev, iod->first_dma))
> +	if (dma_mapping_error(dev->dev, iod->first_dma)) {
> +		printk("allocation failure at %d\n", __LINE__);
>  		return BLK_STS_RESOURCE;
> +	}
>  	iod->dma_len =3D bv->bv_len;
> =20
>  	cmnd->flags =3D NVME_CMD_SGL_METABUF;
> @@ -791,8 +802,10 @@ static blk_status_t nvme_map_data(struct
> =20
>  	iod->dma_len =3D 0;
>  	iod->sgt.sgl =3D mempool_alloc(dev->iod_mempool, GFP_ATOMIC);
> -	if (!iod->sgt.sgl)
> +	if (!iod->sgt.sgl) {
> +		printk("allocation failure at %d\n", __LINE__);
>  		return BLK_STS_RESOURCE;
> +	}
>  	sg_init_table(iod->sgt.sgl, blk_rq_nr_phys_segments(req));
>  	iod->sgt.orig_nents =3D blk_rq_map_sg(req->q, req, iod->sgt.sgl);
>  	if (!iod->sgt.orig_nents)
> @@ -801,8 +814,12 @@ static blk_status_t nvme_map_data(struct
>  	rc =3D dma_map_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req),
>  			     DMA_ATTR_NO_WARN);
>  	if (rc) {
> -		if (rc =3D=3D -EREMOTEIO)
> +		if (rc =3D=3D -EREMOTEIO) {
> +			printk("allocation failure at %d\n", __LINE__);
>  			ret =3D BLK_STS_TARGET;
> +		} else {
> +			printk("allocation failure at %d\n", __LINE__);

I get a lot of this one.

> +		}
>  		goto out_free_sg;
>  	}
> =20
> Index: linux-stable/drivers/nvme/host/core.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-stable.orig/drivers/nvme/host/core.c	2023-10-31 15:35:38.000000=
000 +0100
> +++ linux-stable/drivers/nvme/host/core.c	2023-11-02 17:12:39.000000000 +=
0100
> @@ -708,8 +708,10 @@ blk_status_t nvme_fail_nonready_command(
>  	    ctrl->state !=3D NVME_CTRL_DELETING &&
>  	    ctrl->state !=3D NVME_CTRL_DEAD &&
>  	    !test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ctrl->flags) &&
> -	    !blk_noretry_request(rq) && !(rq->cmd_flags & REQ_NVME_MPATH))
> +	    !blk_noretry_request(rq) && !(rq->cmd_flags & REQ_NVME_MPATH)) {
> +		printk("allocation failure at %d\n", __LINE__);
>  		return BLK_STS_RESOURCE;
> +	}
>  	return nvme_host_path_error(rq);
>  }
>  EXPORT_SYMBOL_GPL(nvme_fail_nonready_command);
> @@ -784,8 +786,10 @@ static blk_status_t nvme_setup_discard(s
>  		 * discard page. If that's also busy, it's safe to return
>  		 * busy, as we know we can make progress once that's freed.
>  		 */
> -		if (test_and_set_bit_lock(0, &ns->ctrl->discard_page_busy))
> +		if (test_and_set_bit_lock(0, &ns->ctrl->discard_page_busy)) {
> +			printk("allocation failure at %d\n", __LINE__);
>  			return BLK_STS_RESOURCE;
> +		}
> =20
>  		range =3D page_address(ns->ctrl->discard_page);
>  	}


--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--FVS16JFHJ7btn9Q1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmVFHLUACgkQ24/THMrX
1yzUvAf8CIbTqn3u4kztOYavM8CP6Oyv22Wl/+svhHeItHvMBisOG0F6t0TvJgaW
8LVB8g/fZgqxW99/X5D8V8V9I2qJXZlD7N0LDv9b625ay8PR/VvESTiOJbVd+d6s
RQGCeF6fazD2efOeUb7HDzfiLW6vedQk9EkfhEyjf7Ey7TtlqvHpa9DiFIoBTPnq
xBIxq8q2gorWBwUDkXpgnQt78Res60TlpKa/epDVW9ZY+cHEL/gas3rUi/r2zgvy
w2AiTx4aTQr/769TvGdDPk+dK3V5+y3WbfWdB0nM6lj7Sb/LlN6n2Qn29CD2Drvh
kVo6d9JNXGcfvc/yQmBuKASUp0UThg==
=7MuL
-----END PGP SIGNATURE-----

--FVS16JFHJ7btn9Q1--
