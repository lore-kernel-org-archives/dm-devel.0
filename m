Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F7DC77B7A
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 20:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686083726;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=K0aUmxZGNklUjCVwD+LvE224qvldQ+MnX7yZ2E9Hza4=;
	b=CG5vbKAxcKFrPr5xGe+ewdyGONZ38hkb3u4DRO7eymOguvVT59/BScvkcsNo6gZLRjneEw
	gZxFcOZOeyesdVmcx2Z03q5rOwXgCWWRkryalhxmeqcNQouuQkikoBLUK0telX+VudmPez
	6F0i0yg8Iucj+gpyrl6lfw0czy1qux0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82--Z3H1jRHOuWBjf7imQ88YA-1; Tue, 06 Jun 2023 16:35:22 -0400
X-MC-Unique: -Z3H1jRHOuWBjf7imQ88YA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7621A3800E87;
	Tue,  6 Jun 2023 20:35:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1100E1121314;
	Tue,  6 Jun 2023 20:35:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BE42019465BD;
	Tue,  6 Jun 2023 20:35:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E75E519465BC
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 20:35:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B2447400E6C1; Tue,  6 Jun 2023 20:35:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A5E8F400E6C6
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 20:35:05 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C0832A59543
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 20:35:05 +0000 (UTC)
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-178-UUhQToPFPrmZ_-_-DvG9gg-1; Tue,
 06 Jun 2023 16:35:03 -0400
X-MC-Unique: UUhQToPFPrmZ_-_-DvG9gg-1
References: <20230606170532.1345-1-zeha@debian.org>
User-agent: mu4e 1.10.3; emacs 29.0.91
From: Sam James <sam@gentoo.org>
To: Chris Hofstaedtler <zeha@debian.org>
Date: Tue, 06 Jun 2023 21:28:17 +0100
In-reply-to: <20230606170532.1345-1-zeha@debian.org>
Message-ID: <87wn0gbaim.fsf@gentoo.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] multipath-tools build: rename PKGCONFIG to
 PKG_CONFIG
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
Cc: dm-devel@redhat.com
Content-Type: multipart/mixed; boundary="===============7943644737253594112=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3

--===============7943644737253594112==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain


Chris Hofstaedtler <zeha@debian.org> writes:

> Debian's build system helpers automatically set "PKG_CONFIG" correctly, so it
> would be convenient for Debian to use this name instead of "PKGCONFIG".
>
> The majority of projects also seem to call this makefile variable "PKG_CONFIG".
>
> Signed-off-by: Chris Hofstaedtler <zeha@debian.org>
> ---

This would simplify our packaging a bit in Gentoo as well.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iOUEARYKAI0WIQQlpruI3Zt2TGtVQcJzhAn1IN+RkAUCZH+XAV8UgAAAAAAuAChp
c3N1ZXItZnByQG5vdGF0aW9ucy5vcGVucGdwLmZpZnRoaG9yc2VtYW4ubmV0MjVB
NkJCODhERDlCNzY0QzZCNTU0MUMyNzM4NDA5RjUyMERGOTE5MA8cc2FtQGdlbnRv
by5vcmcACgkQc4QJ9SDfkZBYGQEA7xqWxD3lpdXi7ymmE9v7c9lzavqbMKA7yehO
TEeTa5IBAN0ImS+KcDi6N1EpsGhPel66SbeqHpi3jkKTVa43wkQJ
=iM6L
-----END PGP SIGNATURE-----
--=-=-=--


--===============7943644737253594112==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============7943644737253594112==--

