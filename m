Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855A4C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 19:47:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0873261285
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 19:47:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0873261285
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-GT4xd1JBPFSmCCD2BGGsFg-1; Mon, 17 May 2021 15:47:41 -0400
X-MC-Unique: GT4xd1JBPFSmCCD2BGGsFg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 317061009446;
	Mon, 17 May 2021 19:47:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D15491007625;
	Mon, 17 May 2021 19:47:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EA63C180B463;
	Mon, 17 May 2021 19:47:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14HJlXAV022684 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 May 2021 15:47:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C24BD1112C31; Mon, 17 May 2021 19:47:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BDF991112C30
	for <dm-devel@redhat.com>; Mon, 17 May 2021 19:47:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A311B80D0E1
	for <dm-devel@redhat.com>; Mon, 17 May 2021 19:47:30 +0000 (UTC)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
	[209.85.221.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-317-5e36uRSYNm6GjPSbN_5LiA-1; Mon, 17 May 2021 15:47:26 -0400
X-MC-Unique: 5e36uRSYNm6GjPSbN_5LiA-1
Received: by mail-wr1-f46.google.com with SMTP id a4so7687828wrr.2;
	Mon, 17 May 2021 12:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=9uHAipE64cDHThcdslLtBJa++pvwT3It88XLZb5/rPY=;
	b=RhhH3GrZlnZac9/veWCCuadPYP73ukIAGGVw7yUfmCDO7dkEBAzeGYeTX63TTLrvD0
	PZEZsza42Cu4mMkvz1kg0XnM5His0EekpOZylQo2y/n2M5cmlrXM8k7VULpER2Goh4Mc
	n0dx0C3JlCPxj1GN6Ct6+pgIdOnACNv+lM048Es+MHWumjZXEc7XaFlPue+it+z8d13Z
	2e37EL3WMf6R8ICU7da60x0Tq/rnoE7/fwqt+1Gd9+MNO8LYj6cRVk4iRRxMAnrdrEZn
	XpXPLFo0K9eea898OZG2Uv4iZEIaB/Guhk0mvOnC08MFKThYDmkQ+S8/GyIcwoOFNCsG
	psFg==
X-Gm-Message-State: AOAM531P3js4rH+AhhC0v6Zm2SIFgRsHLCGM6QVg/ldgTOgwTROX5Fa4
	W/bjalEH+SDncVt4gmDqpVwH+b1nwg==
X-Google-Smtp-Source: ABdhPJzCqQJ4wzIZRRK5LQbN5lqDFg/jYFjzAlHjB7TlYwU5tmIVtdWpEy3jzM2l7rKiWlobLtg/QQ==
X-Received: by 2002:a05:6000:1368:: with SMTP id
	q8mr1620511wrz.342.1621280845081; 
	Mon, 17 May 2021 12:47:25 -0700 (PDT)
Received: from localhost ([90.160.137.52]) by smtp.gmail.com with ESMTPSA id
	f7sm20478722wrg.34.2021.05.17.12.47.24
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 17 May 2021 12:47:24 -0700 (PDT)
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
References: <20210326212944.3136-1-mwilck@suse.com>
	<20210326212944.3136-5-mwilck@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <cb7300e3-9b91-df75-9343-06ae2c88d6ce@gmail.com>
Date: Mon, 17 May 2021 21:47:22 +0200
MIME-Version: 1.0
In-Reply-To: <20210326212944.3136-5-mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 4/7] libdmmp: allow building without perl
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/26/21 10:29 PM, mwilck@suse.com wrote:

> Add the kernel-doc generated manpages of libdmmp to git, and
> change the libdmmp Makefile to regenerate them (only) when
> necessary.

Every month, nice try :-)


$ git diff
diff --git a/libdmmp/docs/man/dmmp_context_free.3 b/libdmmp/docs/man/dmmp_context_free.3
index 0d26f42c..9a46950e 100644
--- a/libdmmp/docs/man/dmmp_context_free.3
+++ b/libdmmp/docs/man/dmmp_context_free.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_free" 3 "dmmp_context_free" "March 2021" "Device Mapper Multipath API - libdmmp Manual"
+.TH "dmmp_context_free" 3 "dmmp_context_free" "May 2021" "Device Mapper Multipath API - libdmmp Manual"
  .SH NAME
  dmmp_context_free \- Release the memory of struct dmmp_context.
  .SH SYNOPSIS
[...]


$ git status
On branch queue
Your branch is up to date with 'origin/queue'.

Changes not staged for commit:
   (use "git add <file>..." to update what will be committed)
   (use "git restore <file>..." to discard changes in working directory)
         modified:   libdmmp/docs/man/dmmp_context_free.3
[...]

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

