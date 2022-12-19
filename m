Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475C2C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 19 Dec 2022 07:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671435497;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EuQX3p0127vIO4ANBmq86A9SjtRBODpXMdEIfopQaG8=;
	b=Kl/tchOwPonw/3Znc2laosTHBfoB5eGRaCEjEc/u/LzBLI+ICviFfdR/K+YAnw94Aldtbl
	D01aNaVy0TEUbV/qfyYXZbqYdCXXtA8Fda9UgUST4wgEauM9TdZkglg72OjpYk3QZo1hQG
	8bNK2wpH4JQIstKMdEWCXAACBF7nQck=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-7bRfCc5XN4CQTvLv3qdrWg-1; Mon, 19 Dec 2022 02:38:15 -0500
X-MC-Unique: 7bRfCc5XN4CQTvLv3qdrWg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88A5F3C0F423;
	Mon, 19 Dec 2022 07:38:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D4EF492B00;
	Mon, 19 Dec 2022 07:38:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8CBD2194658F;
	Mon, 19 Dec 2022 07:38:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C6A1E194658D
 for <dm-devel@listman.corp.redhat.com>; Mon, 19 Dec 2022 07:37:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5AA5839D7C; Mon, 19 Dec 2022 07:37:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 52BE9175A2
 for <dm-devel@redhat.com>; Mon, 19 Dec 2022 07:37:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DB7C29AA2D5
 for <dm-devel@redhat.com>; Mon, 19 Dec 2022 07:37:56 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-593-F3mMr7RVO4u5TGEsNe5VVw-1; Mon,
 19 Dec 2022 02:37:54 -0500
X-MC-Unique: F3mMr7RVO4u5TGEsNe5VVw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id C9D025F7B5;
 Mon, 19 Dec 2022 07:37:52 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ACD7813910;
 Mon, 19 Dec 2022 07:37:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 4oyyKNAUoGNpdgAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 19 Dec 2022 07:37:52 +0000
Message-ID: <12e6e3f5f780d54ff7e1c36bccd6f6dea1e53bfe.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Masanari Iida <standby24x7@gmail.com>, dm-devel@redhat.com
Date: Mon, 19 Dec 2022 08:37:53 +0100
In-Reply-To: <20221216134655.167761-1-standby24x7@gmail.com>
References: <20221216134655.167761-1-standby24x7@gmail.com>
User-Agent: Evolution 3.46.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH] kpartx_id: Add missing 3rd option in usage
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-12-16 at 22:46 +0900, Masanari Iida wrote:
> This patch adds missing 3rd option in kpatx_id usage.
>=20
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Reveiewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0kpartx/kpartx_id | 2 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
> index 18732e7cbbaa..4672927e93e1 100755
> --- a/kpartx/kpartx_id
> +++ b/kpartx/kpartx_id
> @@ -28,7 +28,7 @@ MINOR=3D$2
> =A0UUID=3D$3
> =A0
> =A0if [ -z "$MAJOR" -o -z "$MINOR" ]; then
> -=A0=A0=A0 echo "usage: $0 major minor"
> +=A0=A0=A0 echo "usage: $0 major minor UUID"
> =A0=A0=A0=A0 exit 1;
> =A0fi
> =A0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

