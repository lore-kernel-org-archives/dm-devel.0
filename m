Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51451C4321E
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 21:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669844901;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1Y6SIYFufOp7KFQZitSX+4ezl5LbjA12ywseYdQ0DOA=;
	b=Iwf74LrQh59P3CDtRn8G6xgZPmzFuXkIAZn2vqYW6ZIDLydWeJGntjP76DVe9Gho/kt39L
	Q75NPDS7oWBa+AREGac5davWwcSsO42q1NekPPGCuHD8lk9VVTQHsMZtAIIGMBitABXkML
	ZFuiFA5AYT7zHB0d8YOQ24rzHvepHF4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-X4h0eTjlOQy6mdmQG26hJQ-1; Wed, 30 Nov 2022 16:48:18 -0500
X-MC-Unique: X4h0eTjlOQy6mdmQG26hJQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EA4D102BCBD;
	Wed, 30 Nov 2022 21:48:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 991D92166B4F;
	Wed, 30 Nov 2022 21:48:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 51C5B19465A0;
	Wed, 30 Nov 2022 21:48:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2C5AC1946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 21:35:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1BECF49BB62; Wed, 30 Nov 2022 21:35:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 13EF0401D45
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 21:35:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECAEB858F17
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 21:35:31 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-621-O0ufQ-oqPvamxLjbA0HiQw-1; Wed,
 30 Nov 2022 16:35:30 -0500
X-MC-Unique: O0ufQ-oqPvamxLjbA0HiQw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 71E781F45B;
 Wed, 30 Nov 2022 21:35:28 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3E8871331F;
 Wed, 30 Nov 2022 21:35:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id cIekDaDMh2PPSQAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 30 Nov 2022 21:35:28 +0000
Message-ID: <360ccb35b57595208f5133b723c945e1a6d8a7f7.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Wed, 30 Nov 2022 22:35:27 +0100
In-Reply-To: <20221105213733.182458-1-xose.vazquez@gmail.com>
References: <20221105213733.182458-1-xose.vazquez@gmail.com>
User-Agent: Evolution 3.46.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH] multipath-tools: multipath.conf man page
 housekeeping
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>,
 Muneendra Kumar <muneendra.kumar@broadcom.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sat, 2022-11-05 at 22:37 +0100, Xose Vazquez Perez wrote:
> Mark deprecated options as (Deprecated), and standardize the
> description
> Document pg_timeout
> Default value of "features" is "0"
> directio is also an alternative to readsector0
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =A0multipath/multipath.conf.5 | 41 ++++++++++++++++++++----------------
> --
> =A01 file changed, 22 insertions(+), 19 deletions(-)
>=20
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 8e28ba12..063b05a7 100644
>=20
> =A0.
> =A0.TP
> =A0.B \(dqFPIN \(dq failure tracking
> +(Deprecated) This method is \fBdeprecated\fR in favor of the
> \(dqmarginal_path\(dq
> +failure tracking method, and only offered for backward
> compatibility.
> +.RS 8
> +.LP

This is wrong. FPIN is definitely *not* deprecated.
The mistake came in with cfff03e ("multipathd: handle fpin events").
The "deprecated" paragraph that you moved from below belongs to the
"san_path_err" paragraph instead.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

