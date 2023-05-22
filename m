Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEA31C77B75
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 10:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684750756;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hWhsfRI9rTqEnrQMECrI15XXc1mNPCcXZi0G5B9u+F0=;
	b=WM9VJeS8GMSB7+9IHNLXaQu04avXUwrr0VS7tRwJxZ5N6MTbIaDk7DsX2hbMDQ0T9BkHRd
	HXfFQF6wgyfHI9UmIPqWbt6tStFzUGdQEoiDJlSuE+uU5Vu5XoZwbhJ40Ln1ToHmHISDhT
	u4jtj8ovOlE109JhDO0GZkkpX3HeWrk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-FpygsgV0PC2pNpFhoVC5WQ-1; Mon, 22 May 2023 06:19:13 -0400
X-MC-Unique: FpygsgV0PC2pNpFhoVC5WQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F2FA85A5A8;
	Mon, 22 May 2023 10:19:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC3411121314;
	Mon, 22 May 2023 10:19:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6EDE11946595;
	Mon, 22 May 2023 10:19:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 205DD194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 10:19:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E6CBB145830A; Mon, 22 May 2023 10:19:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DEEE414582FE
 for <dm-devel@redhat.com>; Mon, 22 May 2023 10:19:07 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C399D800159
 for <dm-devel@redhat.com>; Mon, 22 May 2023 10:19:07 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84-BjEOGP1SMHq9sFkQLy34kQ-1; Mon,
 22 May 2023 06:19:06 -0400
X-MC-Unique: BjEOGP1SMHq9sFkQLy34kQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id E27931FDF5;
 Mon, 22 May 2023 10:19:04 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B8D5B13776;
 Mon, 22 May 2023 10:19:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id TvhQK5hBa2QdDwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 22 May 2023 10:19:04 +0000
Message-ID: <d5c31607bd92583c8a487e74bd43542b6d7f1a70.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: "Dmitry V. Levin" <ldv@strace.io>, dm-devel@redhat.com
Date: Mon, 22 May 2023 12:19:04 +0200
In-Reply-To: <20230519223356.GA32042@altlinux.org>
References: <20230519223356.GA32042@altlinux.org>
User-Agent: Evolution 3.48.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] 11-dm-mpath.rules: fix warnings reported by
 udevadm verify
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sat, 2023-05-20 at 01:33 +0300, Dmitry V. Levin wrote:
> Fix the following warnings reported by udevadm verify:
>=20
> multipath/11-dm-mpath.rules:18 Whitespace after comma is expected.
> multipath/11-dm-mpath.rules:73 Whitespace after comma is expected.
> multipath/11-dm-mpath.rules:73 Whitespace after comma is expected.
> multipath/11-dm-mpath.rules:78 Whitespace after comma is expected.
> multipath/11-dm-mpath.rules:78 Whitespace after comma is expected.
> multipath/11-dm-mpath.rules:78 Whitespace after comma is expected.
> multipath/11-dm-mpath.rules: udev rules check failed
>=20
> Signed-off-by: Dmitry V. Levin <ldv@strace.io>

Maybe you should have mentioned that you've just invented this syntax
rule yourself (https://github.com/systemd/systemd/pull/26980).
I see no requirement for adding whitespace after a comma in the udev
man page.=A0

Is this an attempt to change the udev rule syntax retroactively?

Furthermore, there is actually whitespace after the comma in the code
this patch changes, it just happens to be at the beginning of the
following line, which your syntax check ignores.

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

