Return-Path: <SRS0=QKrD=P5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE975C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 10 Nov 2021 17:59:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6E5916117A
	for <dm-devel@archiver.kernel.org>; Wed, 10 Nov 2021 17:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E5916117A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-eq0qBTe1P72FFQbSMN9AQA-1; Wed, 10 Nov 2021 12:59:54 -0500
X-MC-Unique: eq0qBTe1P72FFQbSMN9AQA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19E67102CB2E;
	Wed, 10 Nov 2021 17:59:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DF1660CC4;
	Wed, 10 Nov 2021 17:59:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 644E74E58F;
	Wed, 10 Nov 2021 17:59:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AAHhcA2031285 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Nov 2021 12:43:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 742C9404727C; Wed, 10 Nov 2021 17:43:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 708F04047279
	for <dm-devel@redhat.com>; Wed, 10 Nov 2021 17:43:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56998185A794
	for <dm-devel@redhat.com>; Wed, 10 Nov 2021 17:43:38 +0000 (UTC)
Received: from mail-lf1-f68.google.com (mail-lf1-f68.google.com
	[209.85.167.68]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-507-Abvq_tVtMMedspbnlMfZlw-1; Wed, 10 Nov 2021 12:43:36 -0500
X-MC-Unique: Abvq_tVtMMedspbnlMfZlw-1
Received: by mail-lf1-f68.google.com with SMTP id f18so7860913lfv.6;
	Wed, 10 Nov 2021 09:43:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
	bh=X1VoGxZyPXMV+0wXt4vWD9oiKtnw6QY827IpDoDshzM=;
	b=GZq6nY/jZMNQxb6LY4S45d2OLjXfyoTNPYNandNUwGoU5N7+k02HESj5N1+Uv9C+8H
	KuYhCi8iId8v0HkkHuGahXSQPvHXsG6imicn/URA/qpLCVEtNpTK+hKb5Q5p2gnMou6U
	onL59zNJhYSwH4nCvk8W0a5jxevMB1vancBpyyRnkMk+j2D8RMfslVlcT9vmMubyanw3
	EXgedJTmbeAsRBbxQ7b2XQzXaHEwtSXDvIj7ocaH7xZcUDM5ZnXn/d0T9OZoTzMRhmz5
	5qXa/M3MlcLYF5lDjWdhYC5vlQN24VhCpjl0V6ktVcqCPpmoODvJTMIf/w3B39+4H7Pz
	ubww==
X-Gm-Message-State: AOAM532wSX1VQhH681zbfX/HVYKT0zMdY4i34XPN3niDUvjEJG3brx77
	4I6P4VFHa4Gy62TVT8M3Z+0a1P/WbqQ9Yl31D1qqVZwZgOsH4uc2GVqfIg==
X-Google-Smtp-Source: ABdhPJzIJsJO1dEdnWk9fcNWKbD6tF7mzN0dpCVFuLL8oQ2mj1RorxvVQRmoghJl+gXAlGLaNSt3VBsOBUApBHzf7gk=
X-Received: by 2002:ac2:5cb6:: with SMTP id e22mr728901lfq.337.1636566214114; 
	Wed, 10 Nov 2021 09:43:34 -0800 (PST)
MIME-Version: 1.0
From: Itai Handler <itai.handler@gmail.com>
Date: Wed, 10 Nov 2021 19:43:23 +0200
Message-ID: <CAFpOueRBb9y_Fgb3-c6_eFTKZR9DoAXZmxqqx0UH1Yb2rbV0RQ@mail.gmail.com>
To: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, agk@redhat.com
Subject: [dm-devel] [RFC PATCH 1/1] dm crypt: change maximum sector size to
	PAGE_SIZE
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

Maximum sector size of dm-crypt is currently limited to 4096 bytes.

On systems where PAGE_SIZE is larger than 4096 bytes, using larger
sectors can be beneficial for performance reasons.

This patch changes maximum sector size from 4096 bytes to PAGE_SIZE,
and in addition it changes the type of sector_size in
struct crypt_config from 'unsigned short int' to 'unsigned int', in
order to be able to represent larger values.

On a prototype system which has PAGE_SIZE of 65536 bytes, I saw about
x2 performance improvement in sequential read throughput benchmark
while using only about half of the CPU usage, after simply increasing
sector size from 4096 to 65536 bytes.
I used ext4 filesystem for that benchmark, which supports 64KiB
sectors.

Note: A small change should be made in cryptsetup in order to add
support for sectors larger than 4096 bytes.

Signed-off-by: Itai Handler <itai.handler@gmail.com>
---
 drivers/md/dm-crypt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 916b7da16de2..78c239443bd5 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -168,7 +168,7 @@ struct crypt_config {
        } iv_gen_private;
        u64 iv_offset;
        unsigned int iv_size;
-       unsigned short int sector_size;
+       unsigned int sector_size;
        unsigned char sector_shift;

        union {
@@ -3115,9 +3115,9 @@ static int crypt_ctr_optional(struct dm_target
*ti, unsigned int argc, char **ar
                        cc->cipher_auth = kstrdup(sval, GFP_KERNEL);
                        if (!cc->cipher_auth)
                                return -ENOMEM;
-               } else if (sscanf(opt_string, "sector_size:%hu%c",
&cc->sector_size, &dummy) == 1) {
+               } else if (sscanf(opt_string, "sector_size:%u%c",
&cc->sector_size, &dummy) == 1) {
                        if (cc->sector_size < (1 << SECTOR_SHIFT) ||
-                           cc->sector_size > 4096 ||
+                           cc->sector_size > PAGE_SIZE ||
                            (cc->sector_size & (cc->sector_size - 1))) {
                                ti->error = "Invalid feature value for
sector_size";
                                return -EINVAL;
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

