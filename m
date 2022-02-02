Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 011B5C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Feb 2022 07:03:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-9bT-TPv4NF6ERgyOCDE8zg-1; Thu, 03 Feb 2022 02:03:50 -0500
X-MC-Unique: 9bT-TPv4NF6ERgyOCDE8zg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D8B58143EA;
	Thu,  3 Feb 2022 07:03:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DF8D7A243;
	Thu,  3 Feb 2022 07:03:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6403C1809CBA;
	Thu,  3 Feb 2022 07:03:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212CjvbC024159 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 07:45:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E7B95492D45; Wed,  2 Feb 2022 12:45:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E3887492D40
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 12:45:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94E5F1C0336D
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 12:45:56 +0000 (UTC)
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com
	[66.111.4.230]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-575-T4CIGGKoMUWLKrseTfev6w-1; Wed, 02 Feb 2022 07:45:55 -0500
X-MC-Unique: T4CIGGKoMUWLKrseTfev6w-1
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailnew.nyi.internal (Postfix) with ESMTP id AD506580255;
	Wed,  2 Feb 2022 07:38:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
	by compute2.internal (MEProxy); Wed, 02 Feb 2022 07:38:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=irrelevant.dk;
	h=cc:cc:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm2; bh=TI6TXWscOT8zoXJHYAzpfg+zf/n6iD
	eklYvo47/89uQ=; b=NSuTjVrtEuFkF9P1RQXHIoM9kjTSQZdfZgSzzltnEhfykL
	3hDgc/CvT9TAFZwEAcTMo19o8xUhTrvEp7fyq5/dai4pkgheXKl5wtSTiTuSrlu0
	Oc+X0+9Nid+CLCWGqgpu0BEu2bVyGckvyRZg5403BS1NzFSfvfxDNTtC62CbazEB
	XdBG7SWzYN934CO2/RtevYk79zKwsCII80O/ip5RrpFkORJJs4XVtlG2cckSZQGB
	SjaYds5WYCLoX5lZ8AIeUYd5a/+YyrDZzBF1GbUNwQy1mZd+XGNZ4GZQBqJhDIpX
	Cuum6RHdHBxgL5OX4rhURLhw41E7RJ1OWIhtBApQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TI6TXWscOT8zoXJHY
	Azpfg+zf/n6iDeklYvo47/89uQ=; b=kkgR0M9m6xohXUUZX4sHhzZo1LDKxfehY
	4oyiLTc2ypl7uNrBi/lk0DGr9+Sk8//KkVMyRTXtRV+lMyY872xAzGHFFmkYWtL8
	Ms5/EoNbK2z7XZanj9djjoPF4JK3V7tKglyM/N6uEzFGbgpD/3GZbCCpGhAKTMzW
	ggnHq9W1U5rNZpd7PA3mdvkNJJ06mepNGKyuFhW88XeyetFaSLJ140jiCfFb+F4U
	Ge70aP5G+T1uLKiMVgL4+SFvBFlZKWDCacm3JDkeMIsqmoaULn0+wd3ZoJyTdW7q
	mWdV3ftBE6p6GhFiz5vb0jaKLsTXhflbYXOq80jNcvR3CyRy/ei5A==
X-ME-Sender: <xms:Qnv6YThkxq6g0NSoo7yRdSioGALXe38JJ7Q9ZqduRkYmx6uRvx-KiQ>
	<xme:Qnv6YQAYGeSvA8tNDLsfyNoT75PGKyoKFpIi9xh5RVdeWg49OveDxTrjtkIk6Lknz
	uX6BvwBtQ-KYJ0QDMI>
X-ME-Received: <xmr:Qnv6YTGQn8H-sR-GlYK51ChR39WV9vx2shDM2XR4bM3nMceoa9jDw-cI-G69H3mdTXrQQ5buPqeKTVydPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrgeehgdegvdcutefuodetggdotefrodftvf
	curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
	uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
	fjughrpeffhffvuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepmfhlrghushcu
	lfgvnhhsvghnuceoihhtshesihhrrhgvlhgvvhgrnhhtrdgukheqnecuggftrfgrthhtvg
	hrnhepjeegudffueeiteekieelkedvueelteevjeduieeludfffeejgeffhfduvdduffek
	necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihhtsh
	esihhrrhgvlhgvvhgrnhhtrdgukh
X-ME-Proxy: <xmx:Qnv6YQTXi3yZ2hTKcURW_XPzTDaok_tT-TkL58MjdJj6LGgqJEguqg>
	<xmx:Qnv6YQzpq5YXl85avgPHhMt_rY23Ulf7N6T0is6pHr_A-BdwVLQg7g>
	<xmx:Qnv6YW6eiVpTE7mkTcW7zW4upxNAAxwCirxV3oICVUC6FAuPOYX2bQ>
	<xmx:RHv6YcHCYCRhDZYsCHv0PYUEMnutoRthAMP4L8jgDyTRkUxjlnTSXg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
	2 Feb 2022 07:38:23 -0500 (EST)
Date: Wed, 2 Feb 2022 13:38:21 +0100
From: Klaus Jensen <its@irrelevant.dk>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <Yfp7Pfzh/ZFViiX+@apples>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 03 Feb 2022 02:03:19 -0500
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"kbus @imap.gmail.com>> Keith Busch" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 3/3] nvme: add the "debug" host driver
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
Content-Type: multipart/mixed; boundary="===============3214566259747338426=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16


--===============3214566259747338426==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="biJ/6P2G5BMLSrxz"
Content-Disposition: inline


--biJ/6P2G5BMLSrxz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Feb  2 08:00, Chaitanya Kulkarni wrote:
> Mikulas,
>=20
> On 2/1/22 10:33 AM, Mikulas Patocka wrote:
> > External email: Use caution opening links or attachments
> >=20
> >=20
> > This patch adds a new driver "nvme-debug". It uses memory as a backing
> > store and it is used to test the copy offload functionality.
> >=20
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >=20
>=20
>=20
> NVMe Controller specific memory backed features needs to go into
> QEMU which are targeted for testing and debugging, just like what
> we have done for NVMe ZNS QEMU support and not in kernel.
>=20
> I don't see any special reason to make copy offload an exception.
>=20

FWIW the emulated nvme device in QEMU already supports the Copy command.

--biJ/6P2G5BMLSrxz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEUigzqnXi3OaiR2bATeGvMW1PDekFAmH6ezYACgkQTeGvMW1P
DelzXwgAgnSeMxSCsGMKZO6Usm9hGbg0gntCPBhyXiv5no4XiYSDSdW+BuiEHxSB
rwMYnKqzBYrREbT0L3q5lXXNZZJpS0PDk8VJVLXdb4CWG2MZXMRTviWtuN3aKJJi
xlqvrgA4PUXAqJwA6X/CzCmO2cuD/uGTIz08Y/Z8Tp4+kBEqpAUD0awnSRhRaGZd
OtcAXe6BKjzB3iZXqAYXL4XKAn+apQIWh9dKPsc20hbg0TGcDvLISWTAqBm6CkSt
KzaOTnnYmPXEFds7v/4OD3sHhO7yd+zmIvv8l3zitGCveRgZVu2D/nFVszms0s2r
lmvaVEUbaIVS7rRqcTlG0ROMYT80wQ==
=T0BG
-----END PGP SIGNATURE-----

--biJ/6P2G5BMLSrxz--


--===============3214566259747338426==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============3214566259747338426==--

