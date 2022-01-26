Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F311C2BA4C
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 13:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643203125;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wczhiK4sypaHk/3GJdaMB//AFiuzFlr2+Lk5701x+9g=;
	b=Lqf2jwHvXAPxbcSIgRLSBNgSRKTxgyoSxWqVIeoXARy/Tcbm1Eqx1C0twMtaPmC7LUEH88
	nkEfVWuIdK9QmEfJjhLEH5ZFrVVjBAaktj/zWlU+QsdEf0P5oBX2KlOkmoK5iXX38P23vw
	Rh+Eea60rN87pYXJ07YPb985Z2XF7nk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-CR4pPTX1M0G4WkPP3Wldig-1; Wed, 26 Jan 2022 08:18:43 -0500
X-MC-Unique: CR4pPTX1M0G4WkPP3Wldig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B58C318C89D9;
	Wed, 26 Jan 2022 13:18:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2353110589C4;
	Wed, 26 Jan 2022 13:18:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5367C1832B5E;
	Wed, 26 Jan 2022 13:18:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20QDIWek009214 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 Jan 2022 08:18:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C131940F9D6D; Wed, 26 Jan 2022 13:18:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCABE40F9D68
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 13:18:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A30AE80A0AF
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 13:18:32 +0000 (UTC)
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
	[209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-634-UZZxvD-kOxS8BRMnl5ryQw-1; Wed, 26 Jan 2022 08:18:31 -0500
X-MC-Unique: UZZxvD-kOxS8BRMnl5ryQw-1
Received: by mail-ot1-f70.google.com with SMTP id
	v21-20020a05683018d500b00590a3479c4eso15373268ote.11
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 05:18:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=tCn89VNP4QPt8s8WQRVWyuC2AryW74LBEzVPDP/rwUc=;
	b=J7krbIeq9Ot/hGItv76JFFs5/eZhNiT/JH47kOR/H+tNg3oRe2iiXBBBR/4QwJ4OEQ
	6hZhdbL3Pl5Xv46q7odP36/OK8+OLSUXL/RcYiVPLoHgTAIO1HNRWaCJmyMt+64tSCMu
	lgAcDg8PcNFjxrmr3bB1mJoYfRXDjSfRcseufYj2ojESALmnuH4JhB6BpSwR3fHkuxUJ
	QDsuyF6dhRbMbiG03jxKUXpn6dMn0GlXGi/ylBFIUrKz02PdzIkoqd9rqQhLxBasLzAq
	MpRGViilGhKOicyjhGORbBNcBZ8to39LSWyaQeOHklQMkTOkeyGyhUJYsKmhyElGiguz
	aqCQ==
X-Gm-Message-State: AOAM531u+XYgy4AZjBYRTXLs2RDegZr6anA6s0Iiy7tI9PF3JQHaHsol
	M3q5MANT5xOcssoDn+7gzlKJgukhhdeaPhJAuDDOu72YAvCvX5vTCHc8G/PD0NSaqT3c6hXhdBY
	3EE3CuJTi7SrIedk=
X-Received: by 2002:a05:6808:bcc:: with SMTP id
	o12mr3557181oik.66.1643203110750; 
	Wed, 26 Jan 2022 05:18:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqzuvTIeKOL1AFkX6tuoLQmOhK8vCGo5KkDw6PARCkBSCzwu1jaDTH+ZCt1VS+OT/gClKTUw==
X-Received: by 2002:a05:6808:bcc:: with SMTP id
	o12mr3557169oik.66.1643203110577; 
	Wed, 26 Jan 2022 05:18:30 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com.
	[24.205.208.113]) by smtp.gmail.com with ESMTPSA id
	z186sm6603449oiz.20.2022.01.26.05.18.29
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 26 Jan 2022 05:18:30 -0800 (PST)
From: trix@redhat.com
To: agk@redhat.com, snitzer@redhat.com
Date: Wed, 26 Jan 2022 05:18:26 -0800
Message-Id: <20220126131826.1168355-1-trix@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Tom Rix <trix@redhat.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] dm: cleanup double word in comment
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Tom Rix <trix@redhat.com>

Remove the second 'a'.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 include/linux/device-mapper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index b26fecf6c8e87..4c621e35dd5c0 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -358,7 +358,7 @@ struct dm_target {
 	bool limit_swap_bios:1;
 
 	/*
-	 * Set if this target implements a a zoned device and needs emulation of
+	 * Set if this target implements a zoned device and needs emulation of
 	 * zone append operations using regular writes.
 	 */
 	bool emulate_zone_append:1;
-- 
2.26.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

