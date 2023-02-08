Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DADB4C64EC5
	for <dm-devel@archiver.kernel.org>; Wed,  8 Feb 2023 07:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675842327;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=p7IvCtW/zgC+1+PSObhQxmpxkRJPVAlUzUl53iAkR9k=;
	b=N+1bY2JvrF4CNZBV+1euuxNs4HZgnXKqVKpnVYRN3CbQT+AQVREA5bvW35mxMHLHBb+4aG
	3LFEbRfVStSemAJX4wMc4340eZQZgFEvEp0/fv4jbwn0xpRaXM4CdQvaeZq58t+vHrHtUs
	UC2ID7pMii2s6kO8aSlC+hX7lG069hk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249--vxelEfiMF6nAC3nNZbnZg-1; Wed, 08 Feb 2023 02:45:24 -0500
X-MC-Unique: -vxelEfiMF6nAC3nNZbnZg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97DEC3811F3D;
	Wed,  8 Feb 2023 07:45:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 845A940CF8E7;
	Wed,  8 Feb 2023 07:45:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 84A851946588;
	Wed,  8 Feb 2023 07:45:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D423B1946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Feb 2023 04:33:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9F1E32166B2A; Wed,  8 Feb 2023 04:33:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9817D2166B29
 for <dm-devel@redhat.com>; Wed,  8 Feb 2023 04:33:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76FCD29DD981
 for <dm-devel@redhat.com>; Wed,  8 Feb 2023 04:33:30 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com
 [66.111.4.25]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-633-B4vdbys2Ml6nyHKkbZTHNA-1; Tue, 07 Feb 2023 23:33:29 -0500
X-MC-Unique: B4vdbys2Ml6nyHKkbZTHNA-1
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
 by mailout.nyi.internal (Postfix) with ESMTP id D14395C00A4;
 Tue,  7 Feb 2023 23:33:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
 by compute2.internal (MEProxy); Tue, 07 Feb 2023 23:33:28 -0500
X-ME-Sender: <xms:GCbjY2PxoeHrqxRCyAV3lNH2FtcrQnfOU7EP76S3xiq9wTu9zFxLBw>
 <xme:GCbjY0_VDDpCN7L-aoU-hwJB-Hk8hy3LKK1DOSZvoi183UCPXx6wa5v0qJQX4-dkK
 bubmoWELeD2cGQ>
X-ME-Received: <xmr:GCbjY9QkUF2W0NDl8JvpcHKis53a4K5rBj_n_a6P0p6TyTxPYNox5o8_wN4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegledgjedtucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhepfffhvffukfhfgggtjgesthdtredttddtvdenucfhrhhomhepffgvmhhiucfo
 rghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhnghhslh
 grsgdrtghomheqnecuggftrfgrthhtvghrnhepieefgedujeelvdfhgeefueeggeeggeej
 hefhveevleffueetgfevtddvheefvdffnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
 hrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgr
 sgdrtghomh
X-ME-Proxy: <xmx:GCbjY2uSicwxTpnNog9a4PYqmd0J9sBWGbuxemiSXmWc8soRA33XWA>
 <xmx:GCbjY-c9B7FfBBgRnprfw8F693bcSScgR3AKYTDoL409AYHEUQsHJg>
 <xmx:GCbjY62BjcVmyy2W-Uw8aruGXupH2R9uH2wcoGfu9PXjNo3pF7ax6w>
 <xmx:GCbjY2mIJfUCRetrfNwDl-xJURZXNvu7UyRi9gmFBmjRZ7eERplraw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Feb 2023 23:33:28 -0500 (EST)
Date: Tue, 7 Feb 2023 23:33:26 -0500
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com
Message-ID: <Y+MmFmzOqG7BEJZO@itl-email>
References: <1675830100-25726-1-git-send-email-bmarzins@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1675830100-25726-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Wed, 08 Feb 2023 07:45:20 +0000
Subject: Re: [dm-devel] [PATCH] dm-table: Check that a dm device doesn't
 reference itself
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On Tue, Feb 07, 2023 at 10:21:40PM -0600, Benjamin Marzinski wrote:
> If a dm device table references itself, it will crash the kernel with an
> infinite recursion.  Check for a self-reference in dm_get_device(). This
> is a quick check, but it won't catch more complicated circular
> references.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  drivers/md/dm-table.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 8541d5688f3a..24ad42b385c1 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -364,6 +364,8 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  		if (!dev)
>  			return -ENODEV;
>  	}
> +	if (dev == disk_devt(t->md->disk))
> +		return -EINVAL;
>  
>  	dd = find_device(&t->devices, dev);
>  	if (!dd) {
> -- 
> 2.30.2

I like this!  More generally, should the kernel fail with -ELOOP if
devices are stacked too deeply?
- -- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmPjJhYACgkQsoi1X/+c
IsHwnRAAsJgax1pLhHw0jvXgbwb+XGM+j2bHwg/9DsmTakxAlJgDYAUGhC4wIu3n
bWzs0TY0ON0h6BAVm4+xUFBCpQpSZTf2Z95YCHHvhj2ImEdSYrbk+ccnZaXhaP5f
mUFEG7PmBA6Zl/xJvAwZgG4V/Szp73UdlSe+Ph3qcjNf/+n2EznZBFjXpO45PGaL
xvd7D7QcqEbhiH5kDVvZibX4Np2xWecbIYNoGuiCf+tnUVM+QyFIMiLZhWS+nZ4y
QOzcn7gG5543dSlwnKJJXKmW/LBXqNAzyLvhqxWX/5ExwENQxEQ5fQ/w1EcuIgLq
EaNCm7yCabgG11d6En4er2etUB9Q2mowugSvdzryblF01x0GMz2aqFQ12Ogbag9t
8t1sHx+ohk03H4vjbT3NJZnqDsTmAYVV7v/nxCKYot3EcylB0R9b3BIeRoKYiFK0
f/1ap8MfvHE/Nc4hyVapD6DOQ3Gn9ZK5Y6eNrpzlG6C5JVjWJjB8tCoON8upgj3t
5P77sFVVczj2/Uu8T+1uhYQ9XSnFREsQGSEULZoA60MAwRktyhQVGTMwTLnX/BVg
kHpCeaFnEN1IZ1R5PFZXoPPztPcnZG1ZjMjrpqjKqd1Udokqti+i9vf3sAI7mfo3
mvB4XyxH6PdLz2UD1GvTvF2DKKyJeE2W4ezCxSBSNHhrMIwaPvE=
=Kzsf
-----END PGP SIGNATURE-----

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

