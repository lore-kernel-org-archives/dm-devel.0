Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 002DCC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 896902068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 896902068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1609787003;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1dmAxVYJlRfJAB8SsHQz2HDDlLGmxevJr5m9JtE8/eo=;
	b=KcWpA8jabkm4Lj3kWbdj9FaxixMytiJ+WbOV1sdCp8w7h1CS0pn4vlCowKypV+vIzX3KnL
	pyQQ4rmjLwjPCZD56F+A08zyG2GmuRcr7Hb2QL+GNF70c4DiCVBumef9PTKu0jOT4dlGvU
	nFis7dllGLU+uju31pMgvPlZ/cCOYwA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-Fo0FaywPOdqVnNXL4e3l9g-1; Mon, 04 Jan 2021 14:03:21 -0500
X-MC-Unique: Fo0FaywPOdqVnNXL4e3l9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B727F1005504;
	Mon,  4 Jan 2021 19:03:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10BDD5D9C6;
	Mon,  4 Jan 2021 19:03:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 526F04E58E;
	Mon,  4 Jan 2021 19:03:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BFLVaTS003113 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Dec 2020 16:31:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6950AAB5B2; Tue, 15 Dec 2020 21:31:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63C23AB5B1
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 21:31:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CED01875042
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 21:31:34 +0000 (UTC)
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
	[209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-344-g1jIAyXLPjmixfOWW3RybA-1; Tue, 15 Dec 2020 16:31:31 -0500
X-MC-Unique: g1jIAyXLPjmixfOWW3RybA-1
Received: by mail-oo1-f70.google.com with SMTP id m1so5256509ooj.23
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 13:31:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=O3IlA/EtAmqXa16y6q/aKRAMxC9/cCCbF/diJvoK8Qk=;
	b=RgwgZWBOKpkKajBk4n78A47tr9oLValoAZE17Ixt/4Yg+P/jGKAhaQoe+lfV/fBX0C
	JhRE+nXR3Ss+10pqgg0cGcS2rlMRNyPhx6DLi5mfAS8cD4qQ6C3I+I3TL/Q3hdI4/Drs
	rfBz751BLNeuNkDnyq95mGmhWIStsRR6SY6f90nEDbhAXCEuZhDFPbHzQ09MXLTTbl0n
	vvpeLUCtb31e5Q7PqgDarWOpaBs9WTVE03Vhj5KBgnJ4ntMaq/Q5u0hCUhyWsY+NuIV4
	HsYEA5eMyaPxjCxwgL5Ud9BnFpMiZde22WVb6j6E3Lxu8WqtdjnokFbPY2AxJQ+wrQR9
	7TsQ==
X-Gm-Message-State: AOAM533JAFp8Wa7jZY2VDrrtB16UGgvy4t4poO30TOpdWgcIcp0udp/Z
	ztiT0SIVvOLE8Ku3P7QpapNBF9MLmTdAR3sJSPZkj3eE/HTULRTbOeT74yPfq71tyAAv4cIs3DE
	U2yOJlYhrlb5K9gI=
X-Received: by 2002:aca:4ec9:: with SMTP id c192mr521528oib.115.1608067890592; 
	Tue, 15 Dec 2020 13:31:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTT2aSnaexWFHSJF1Kr3v1WMGB3hbglFJ56ittyEcYbw0OmkvxZUnHYk32RyC9b3ZpJV17pw==
X-Received: by 2002:aca:4ec9:: with SMTP id c192mr521525oib.115.1608067890449; 
	Tue, 15 Dec 2020 13:31:30 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com.
	[75.142.250.213])
	by smtp.gmail.com with ESMTPSA id h2sm23776otn.15.2020.12.15.13.31.29
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 15 Dec 2020 13:31:29 -0800 (PST)
From: trix@redhat.com
To: agk@redhat.com, snitzer@redhat.com
Date: Tue, 15 Dec 2020 13:31:25 -0800
Message-Id: <20201215213125.2091089-1-trix@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: Tom Rix <trix@redhat.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] dm dust: remove h from printk format specifier
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Tom Rix <trix@redhat.com>

See Documentation/core-api/printk-formats.rst.

commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")

Standard integer promotion is already done and %hx and %hhx is useless
so do not encourage the use of %hh[xudi] or %h[xudi].

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/md/dm-dust.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 072ea913cebc..cbe1058ee589 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -130,7 +130,7 @@ static int dust_add_block(struct dust_device *dd, unsigned long long block,
 
 	dd->badblock_count++;
 	if (!dd->quiet_mode) {
-		DMINFO("%s: badblock added at block %llu with write fail count %hhu",
+		DMINFO("%s: badblock added at block %llu with write fail count %u",
 		       __func__, block, wr_fail_cnt);
 	}
 	spin_unlock_irqrestore(&dd->dust_lock, flags);
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

