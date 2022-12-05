Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD89BC4321E
	for <dm-devel@archiver.kernel.org>; Mon,  5 Dec 2022 10:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670237948;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=M0t98+IvefProUuaQvtVO1F0URqKJo+6i4FEL5QYUiE=;
	b=Qn94K/EXGwm3vlMDS5Y6/9jSJxRnry4x/T4z1DfSWi7pLp++izw6JEVSj2ng+Yfyy3D4Re
	G8vexIWziGxcnt5tQv1VbWjVzc11d1mrstRlDOv8CGA+BYh2urWRU++FOwWCPvG2NG0Qf2
	DAqMC51Pm23kUd0aGRQNUFE+izVEUxI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-KG-zr4zuOAG_WO-HteJIxg-1; Mon, 05 Dec 2022 05:59:05 -0500
X-MC-Unique: KG-zr4zuOAG_WO-HteJIxg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3328085A588;
	Mon,  5 Dec 2022 10:59:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 20B75C1908B;
	Mon,  5 Dec 2022 10:59:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C9D9C1946589;
	Mon,  5 Dec 2022 10:59:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3FD301946588
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Dec 2022 10:59:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D85F2166B2E; Mon,  5 Dec 2022 10:59:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 26B9D2166B29
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 10:59:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBA211C05153
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 10:58:59 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-479-FeCo5G8AP3eK6k3jkC3iqA-1; Mon,
 05 Dec 2022 05:58:56 -0500
X-MC-Unique: FeCo5G8AP3eK6k3jkC3iqA-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 9EAC522805;
 Mon,  5 Dec 2022 10:58:54 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 712C61348F;
 Mon,  5 Dec 2022 10:58:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap1.suse-dmz.suse.de with ESMTPSA id XrUFGu7OjWMdGAAAGKfGzw
 (envelope-from <mwilck@suse.com>); Mon, 05 Dec 2022 10:58:54 +0000
Message-ID: <95e173df742ef46a7165cbdf93695f88ed468773.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Mon, 05 Dec 2022 11:58:53 +0100
In-Reply-To: <20221203150035.50356-1-xose.vazquez@gmail.com>
References: <20221203150035.50356-1-xose.vazquez@gmail.com>
User-Agent: Evolution 3.46.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] multipath-tools: mailing list url was changed
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sat, 2022-12-03 at 16:00 +0100, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0README.md=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 2 +-
> =A0libmultipath/propsel.c | 2 +-
> =A02 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/README.md b/README.md
> index fb118822..5e04f5c3 100644
> --- a/README.md
> +++ b/README.md
> @@ -172,7 +172,7 @@ Mailing list
> =A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =A0
> =A0(subscribers-only)
> -To subscribe and archives:
> https://www.redhat.com/mailman/listinfo/dm-devel
> +To subscribe and archives:
> https://listman.redhat.com/mailman/listinfo/dm-devel
> =A0Searchable: https://marc.info/?l=3Ddm-devel
> =A0
> =A0
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index cd3d74e1..a25cc921 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -574,7 +574,7 @@ out:
> =A0 * Using the sysfs priority checker defeats this purpose.
> =A0 *
> =A0 * Moreover, NetApp would also prefer the RDAC checker over ALUA.
> - *
> (https://www.redhat.com/archives/dm-devel/2017-September/msg00326.htm
> l)
> + *
> (https://listman.redhat.com/archives/dm-devel/2017-September/msg00326
> .html)
> =A0 */
> =A0static int
> =A0check_rdac(struct path * pp)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

