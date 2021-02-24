Return-Path: <SRS0=vUAV=H3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3A7C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 25 Feb 2021 09:27:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9837364EC3
	for <dm-devel@archiver.kernel.org>; Thu, 25 Feb 2021 09:27:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9837364EC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614245264;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=2Vm6jHz2AKtgBtPK9OpFvp2T9w7vubuipBoRx7AMOoE=;
	b=hAwJKtZ8w17X5AsRtx+QccLWBfWGhRwZ1ltn0dibs1VgUkyWumy1MxWMMvUXWaeG4+m+u7
	3yNet1vq7VzCGwnIB86T4ARu5XYE1wBhKXI2gdc7a37smwLR7QEtDaVOFZGtcptQkRQ5eJ
	5OFpFH08W98Kw7odka38Zfrwz9dMB6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-i8_gpYm2PGOEPeweGtxNGg-1; Thu, 25 Feb 2021 04:27:42 -0500
X-MC-Unique: i8_gpYm2PGOEPeweGtxNGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7774E80196C;
	Thu, 25 Feb 2021 09:27:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 557511001281;
	Thu, 25 Feb 2021 09:27:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2774718095CD;
	Thu, 25 Feb 2021 09:27:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11OBrgVN027789 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Feb 2021 06:53:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9D1F31001E73; Wed, 24 Feb 2021 11:53:42 +0000 (UTC)
Received: from localhost (ovpn-115-137.ams2.redhat.com [10.36.115.137])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A20EE10016F0;
	Wed, 24 Feb 2021 11:53:30 +0000 (UTC)
Date: Wed, 24 Feb 2021 11:53:29 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Message-ID: <YDY+ObNNiBMMuSEt@stefanha-x1.localdomain>
References: <20210222211115.30416-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
In-Reply-To: <20210222211115.30416-1-chaitanya.kulkarni@wdc.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 25 Feb 2021 04:27:13 -0500
Cc: ulf.hansson@linaro.org, snitzer@redhat.com, mst@redhat.com,
	jasowang@redhat.com, virtualization@lists.linux-foundation.org,
	bfields@fieldses.org, linux-ide@vger.kernel.org,
	dm-devel@redhat.com, target-devel@vger.kernel.org,
	alim.akhtar@samsung.com, agk@redhat.com, beanhuo@micron.com,
	stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
	cang@codeaurora.org, tim@cyberelk.net, dgilbert@interlog.com,
	vbadigan@codeaurora.org, richard.peng@oppo.com,
	jejb@linux.ibm.com, guoqing.jiang@cloud.ionos.com,
	linux-block@vger.kernel.org, avri.altman@wdc.com, bp@alien8.de,
	jaegeuk@kernel.org, Kai.Makisara@kolumbus.fi, axboe@kernel.dk,
	linux-nfs@vger.kernel.org, martin.petersen@oracle.com,
	baolin.wang@linaro.org, linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
	chuck.lever@oracle.com, zliua@micron.com, pbonzini@redhat.com,
	davem@davemloft.net, asutoshd@codeaurora.org
Subject: Re: [dm-devel] [RFC PATCH] blk-core: remove blk_put_request()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8740977490575551141=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22


--===============8740977490575551141==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nED3gpEEOc5iD8Dg"
Content-Disposition: inline


--nED3gpEEOc5iD8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 22, 2021 at 01:11:15PM -0800, Chaitanya Kulkarni wrote:
> The function blk_put_request() is just a wrapper to
> blk_mq_free_request(), remove the unnecessary wrapper.
>=20
> Any feedback is welcome on this RFC.
>=20
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>  block/blk-core.c                   |  6 ------
>  block/blk-merge.c                  |  2 +-
>  block/bsg-lib.c                    |  4 ++--
>  block/bsg.c                        |  4 ++--
>  block/scsi_ioctl.c                 |  6 +++---
>  drivers/block/paride/pd.c          |  2 +-
>  drivers/block/pktcdvd.c            |  2 +-
>  drivers/block/virtio_blk.c         |  2 +-
>  drivers/cdrom/cdrom.c              |  4 ++--
>  drivers/ide/ide-atapi.c            |  2 +-
>  drivers/ide/ide-cd.c               |  4 ++--
>  drivers/ide/ide-cd_ioctl.c         |  2 +-
>  drivers/ide/ide-devsets.c          |  2 +-
>  drivers/ide/ide-disk.c             |  2 +-
>  drivers/ide/ide-ioctls.c           |  4 ++--
>  drivers/ide/ide-park.c             |  2 +-
>  drivers/ide/ide-pm.c               |  4 ++--
>  drivers/ide/ide-tape.c             |  2 +-
>  drivers/ide/ide-taskfile.c         |  2 +-
>  drivers/md/dm-mpath.c              |  2 +-
>  drivers/mmc/core/block.c           | 10 +++++-----
>  drivers/scsi/scsi_error.c          |  2 +-
>  drivers/scsi/scsi_lib.c            |  2 +-
>  drivers/scsi/sg.c                  |  6 +++---
>  drivers/scsi/st.c                  |  4 ++--
>  drivers/scsi/ufs/ufshcd.c          |  6 +++---
>  drivers/target/target_core_pscsi.c |  4 ++--
>  fs/nfsd/blocklayout.c              |  4 ++--
>  include/linux/blkdev.h             |  1 -
>  29 files changed, 46 insertions(+), 53 deletions(-)
>=20
> diff --git a/block/blk-core.c b/block/blk-core.c
> index fc60ff208497..1754f5e7cc80 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -642,12 +642,6 @@ struct request *blk_get_request(struct request_queue=
 *q, unsigned int op,
>  }
>  EXPORT_SYMBOL(blk_get_request);
> =20
> -void blk_put_request(struct request *req)
> -{
> -	blk_mq_free_request(req);
> -}
> -EXPORT_SYMBOL(blk_put_request);

blk_get_request() still exists after this patch. A "get" API usually has
a corresponding "put" API. I'm not sure this patch helps the consistency
and clarity of the code.

If you do go ahead, please update the blk_get_request() doc comment
explicitly mentioning that blk_mq_free_request() needs to be called.

Stefan

--nED3gpEEOc5iD8Dg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmA2PjkACgkQnKSrs4Gr
c8hCowf/apCHcJenx6DM1jzpYo1NNnpfJb2nifukyVLP2UVasntjvQM1WD7v1t84
WZMQu4BXSLlqhke4oxGQpx0/dNYaC3vi0/XB4yedtojqiAeLYqUgZf17ZDRybfvo
o0JmcTVjGtEm48hmt4kulUe9VTeIBaMh8c+IkEjxAEjFN45LgERG9YKRDdTVDCIg
ozqQR2DJJDN7ND80Mu397WnT32WJAJnpU5fLYIKrp8Y3ZINRly5h9F6rn87RmbHq
KdfZiGjiKMHIOnF1hP1oXi+a9xckj9US9MbvSBiMovQhs5zxuI0hBnpmsO1J6Pnl
6OYJzeRg/xtmqSUt8yY53YS9Hur9zg==
=4OR2
-----END PGP SIGNATURE-----

--nED3gpEEOc5iD8Dg--


--===============8740977490575551141==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============8740977490575551141==--

