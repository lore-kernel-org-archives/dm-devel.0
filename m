Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F7F1EB64D7
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jun 2023 12:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687782931;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wUCqiGi24mmPPsRHzWzZ5LhIuxLEXfYS34PwhpLp+Gw=;
	b=Zj5rgSFf1Rb5mAM7qqIrXG4L/HH2s4FcONY+XjOqOlF7Fz4lseiiSttTOxe1X5oslfAbkA
	9+gzYyQASz8dKmFtzJCZEbyLzlzJSqMsi4L8Hc19YSsx+wqK/NAWkMqRLuS7Qg15shbchv
	odJUvSNDcvMDHzIe8S1W56nxGkTqFJc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-GaDhmOiRO52SDaE6bbn7Uw-1; Mon, 26 Jun 2023 08:35:30 -0400
X-MC-Unique: GaDhmOiRO52SDaE6bbn7Uw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 466698E44E9;
	Mon, 26 Jun 2023 12:35:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF842400F54;
	Mon, 26 Jun 2023 12:35:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B38081946588;
	Mon, 26 Jun 2023 12:35:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 393C81946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 12:35:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D60EA40C2071; Mon, 26 Jun 2023 12:35:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE39540C2063
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 12:35:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADF5F1C29AEA
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 12:35:22 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-508-rN5b85PiO4qN364Mr3ZKRw-1; Mon,
 26 Jun 2023 08:35:20 -0400
X-MC-Unique: rN5b85PiO4qN364Mr3ZKRw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id C87761F8AA;
 Mon, 26 Jun 2023 12:35:19 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9667013905;
 Mon, 26 Jun 2023 12:35:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id s4nEIgeGmWSpTQAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 26 Jun 2023 12:35:19 +0000
Message-ID: <f3a301cc93949552b5f943f66b6b19259275c616.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Chris Hofstaedtler <zeha@debian.org>, dm-devel@redhat.com
Date: Mon, 26 Jun 2023 14:35:19 +0200
In-Reply-To: <20230606171221.1472-1-zeha@debian.org>
References: <20230606171221.1472-1-zeha@debian.org>
User-Agent: Evolution 3.48.3
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] multipath-tools build: accept
 KBUILD_BUILD_TIMESTAMP from env
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
Cc: Chris Lamb <lamby@debian.org>, Xose Vazquez Perez <xose.vazquez@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-06-06 at 19:12 +0200, Chris Hofstaedtler wrote:
> From: Chris Lamb <lamby@debian.org>
>=20
> It would appear KBUILD_BUILD_TIMESTAMP is meant to be used the same
> way as in
> the linux kernel build. For linux, builders are supposed to set
> KBUILD_BUILD_TIMESTAMP in the environment if they want a stable
> timestamp.
>=20
> The libddmmp makefile however tries to directly call git to get a
> timestamp,
> which fails in a typical Debian build environment, which is not a
> full git
> source tree.
>=20
> Have libdmmp/Makefile use KBUILD_BUILD_TIMESTAMP from the environment
> if
> available, otherwise use git as before.
>=20
> Signed-off-by: Chris Hofstaedtler <zeha@debian.org>
> ---
> =A0libdmmp/Makefile | 2 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index 9ece9528..601933aa 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -75,7 +75,7 @@ docs/man/dmmp_strerror.3:=A0=A0=A0=A0=A0$(HEADERS)
> =A0=A0=A0=A0=A0=A0=A0=A0$(Q)TEMPFILE=3D$(shell mktemp); \
> =A0=A0=A0=A0=A0=A0=A0=A0cat $^ | perl docs/doc-preclean.pl >$$TEMPFILE; \
> =A0=A0=A0=A0=A0=A0=A0=A0LC_ALL=3DC \
> -=A0=A0=A0=A0=A0=A0=A0KBUILD_BUILD_TIMESTAMP=3D`git log -n1 --pretty=3D%c=
d --date=3Diso -
> - $^` \
> +=A0=A0=A0=A0=A0=A0=A0KBUILD_BUILD_TIMESTAMP=3D`echo $$KBUILD_BUILD_TIMES=
TAMP | grep
> . || git log -n1 --pretty=3D%cd --date=3Diso -- $^` \
> =A0=A0=A0=A0=A0=A0=A0=A0perl docs/kernel-doc -man $$TEMPFILE | \
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 perl docs/split-man.pl docs/man; \
> =A0=A0=A0=A0=A0=A0=A0=A0$(RM) -f $$TEMPFILE

Thanks.

Can we do this instead? It looks slightly more readable to me.

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 6d28caf..3912031 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -74,8 +74,10 @@ doc: docs/man/dmmp_strerror.3
 docs/man/dmmp_strerror.3:      $(HEADERS)
        $(Q)TEMPFILE=3D$(shell mktemp); \
        cat $^ | perl docs/doc-preclean.pl >$$TEMPFILE; \
+       [ "$KBUILD_BUILD_TIMESTAMP" ] || \
+           KBUILD_BUILD_TIMESTAMP=3D`git log -n1 --pretty=3D%cd --date=3Di=
so -- $^`; \
+       export KBUILD_BUILD_TIMESTAMP; \
        LC_ALL=3DC \
-       KBUILD_BUILD_TIMESTAMP=3D`git log -n1 --pretty=3D%cd --date=3Diso -=
- $^` \
        perl docs/kernel-doc -man $$TEMPFILE | \
            perl docs/split-man.pl docs/man; \
        $(RM) -f $$TEMPFILE

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

