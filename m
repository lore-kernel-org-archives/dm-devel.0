Return-Path: <SRS0=EI4u=IE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49960C433DB
	for <dm-devel@archiver.kernel.org>; Sat,  6 Mar 2021 15:30:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9FF7264FE4
	for <dm-devel@archiver.kernel.org>; Sat,  6 Mar 2021 15:30:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FF7264FE4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-CwN5-qq0N12udTUHld58yQ-1; Sat, 06 Mar 2021 10:30:50 -0500
X-MC-Unique: CwN5-qq0N12udTUHld58yQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 823372E9C;
	Sat,  6 Mar 2021 15:30:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7765760C17;
	Sat,  6 Mar 2021 15:30:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5498E4EA32;
	Sat,  6 Mar 2021 15:30:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 126FUUHw019403 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 6 Mar 2021 10:30:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5DE081000DB5; Sat,  6 Mar 2021 15:30:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5845B112D437
	for <dm-devel@redhat.com>; Sat,  6 Mar 2021 15:30:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E91CC101A52C
	for <dm-devel@redhat.com>; Sat,  6 Mar 2021 15:30:27 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
	[209.85.221.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-17-eftXIbe8Mh-7VFAmTjWpLw-1; Sat, 06 Mar 2021 10:30:25 -0500
X-MC-Unique: eftXIbe8Mh-7VFAmTjWpLw-1
Received: by mail-wr1-f51.google.com with SMTP id a18so5827861wrc.13;
	Sat, 06 Mar 2021 07:30:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=b7uHaDismyivy6NMAQ3LV/diLhWwiiC3yiITbuNZj4I=;
	b=KrfZdQWu6/6KRgnEQjilWtVcZr3vTfsZ4oruRhVWe7ttLSjgwx4NID/fZ2fs7ab9Fr
	89QqivspSKbSaMO4VzL9hFmi6TnuYp8oIjkEFIQtMGfdkOKxHLYvedKgwwW08NMp/y+7
	/jVeqKw7we3WWof+3hnNtXRk3Y6+NoATY1WzZEre3U3+hyDhPx0PWj8IBDkt4eeKE1fC
	kls8vzsUawzSIuxGlW06eQozx2efF+VO+Gtevb9yErONZ3pUbFiiJZDB/XYiJLPNVhGE
	Iy7p3aHJ7DWTOsHgfDhNCVkj8KihkkzHwWTiYYUI6Uy2Vqbgs88mCzjh/15Bu2RLcAvM
	22Tg==
X-Gm-Message-State: AOAM5319nNecpryS0bCI+uwJEJwHwJ9XAXgN08EPIf1ZjpgWbc1JDRTr
	D7KbHGB75XAcIyEJ4SelzA==
X-Google-Smtp-Source: ABdhPJwKv+yIkj01EWhwjUmMVqnsRRvQK5Qp6U0i0l3jT7AnfKfdeZ4vkFXrchY/MGa5JpfSmcCusw==
X-Received: by 2002:a5d:4286:: with SMTP id k6mr14337476wrq.278.1615044624299; 
	Sat, 06 Mar 2021 07:30:24 -0800 (PST)
Received: from localhost (215.red-81-43-178.staticip.rima-tde.net.
	[81.43.178.215]) by smtp.gmail.com with ESMTPSA id
	p10sm9428765wrw.33.2021.03.06.07.30.23
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sat, 06 Mar 2021 07:30:23 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat,  6 Mar 2021 16:30:22 +0100
Message-Id: <20210306153022.38449-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: add more info about
	max_sectors_kb in multipath.conf.5
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Change of the default value in the kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d2be537c3ba35

To query the device:
sg_inq -p 0xb0 /dev/sdX | grep "[ml] transfer length:"


Note: some arrays does not report any value.
      3PAR: 65534 blocks
      RDAC: not reported
      Hitachi VSP: query error

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 8ef3a747..21963813 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1240,9 +1240,11 @@ The default is: \fB0\fR
 .B max_sectors_kb
 Sets the max_sectors_kb device parameter on all path devices and the multipath
 device to the specified value.
+If the storage device(array, hard disk, ...) does not export the value to the
+system, the kernel sets it to 512(kernel < 4.3) or 1024(kernel >= 4.3).
 .RS
 .TP
-The default is: \fB<device dependent>\fR
+The default is: \fB<device dependent>\fR, or kernel provided if there is no value.
 .RE
 .
 .
-- 
2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

