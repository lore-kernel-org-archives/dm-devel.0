Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C0D6C4321E
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 08:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667810415;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ltklqOYjD/Z/Ig/BxaI2E4BJWg3wy84U+rIipbyt4C8=;
	b=RNuJRBrpAAWZuQL26U7itC8uCofuc1fLVLCLLdZNiQXc2ijIt6+1YPhpQhx1YxHzpBHZ70
	fkygskzJfCNBHMfnrtB7b1Qmgr3+HiuBUEWv2BVAW9isvfn+ws0/unJ60EHjMUoeYvAuSL
	KAD1O43jjOY6/9Q6OAGy7Lfb2X2i05w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-XpOoPlteNyShgY4X4h6t0Q-1; Mon, 07 Nov 2022 03:40:11 -0500
X-MC-Unique: XpOoPlteNyShgY4X4h6t0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C36E218ABF82;
	Mon,  7 Nov 2022 08:40:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E31A639DB3;
	Mon,  7 Nov 2022 08:40:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D8D6D1946589;
	Mon,  7 Nov 2022 08:40:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7DCB31946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 11:30:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D6ED040C6F73; Fri,  4 Nov 2022 11:30:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CFA0340C6EE9
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 11:30:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B46AD811E7A
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 11:30:21 +0000 (UTC)
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-627-sW-QlLbxN7S2MWuKb8se_A-1; Fri, 04 Nov 2022 07:30:20 -0400
X-MC-Unique: sW-QlLbxN7S2MWuKb8se_A-1
Received: by mail-pl1-f200.google.com with SMTP id
 n1-20020a170902f60100b00179c0a5c51fso3388433plg.7
 for <dm-devel@redhat.com>; Fri, 04 Nov 2022 04:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=uJy9Oiy5cpKmClijTkDe6KXjFE6VRuxm2Fp2gVJ4PwQ=;
 b=KQOf1bCx09qWTT8nVKSqGUm1eQqEwLiqGKjvqhUEXobELz1fRnEuTa8PGOoluq1k6S
 0FK/u3uLQNpfY1C1H3Pu/UKTocgdcGukBu7v1Kwmn0FUQ9Yr2XxweXKUtX0ld63vVP8h
 AET2T57Cr7HdUvC/ZeEE2nHn3LjK2adjJx0/gEB92t0H4PWgdHejdK+OjPyFsZz3gPXZ
 PzctT5z9U9hw2v5PGDI10r4Hv4PUg78uEzB3FJ1GemaqObWaV1J8YAAMkXZNmf9KfWpn
 S/TylET+UmBZ2xwcFy64TeU7YsMiDmt1AsaIqSIcCb/U4G/Uxr60ZnyIq+GShElndLix
 SJSQ==
X-Gm-Message-State: ACrzQf3tVseVbowLLeXbtgSgY+XthNEv+tq5f1K47OmWjK0qkyKyiURI
 EJzGLJLUGYfC0JQYw12+t/NMqGDU65AH2YwOyJzTYVO0dkfuJ4aYT9B3QUBrktrJ5/4bAj/jcwh
 cllt4BaQyQhFaMNw=
X-Received: by 2002:a17:902:aa46:b0:186:e220:11d4 with SMTP id
 c6-20020a170902aa4600b00186e22011d4mr35254827plr.163.1667561419297; 
 Fri, 04 Nov 2022 04:30:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5pcZ6tNaPqq0YoJX850E6WOJZ5lbYOLfvzVTVy1cDIH4ecstbrpazqOrRO+fSBQKpe6bAfZw==
X-Received: by 2002:a17:902:aa46:b0:186:e220:11d4 with SMTP id
 c6-20020a170902aa4600b00186e22011d4mr35254808plr.163.1667561419017; 
 Fri, 04 Nov 2022 04:30:19 -0700 (PDT)
Received: from localhost ([209.132.188.80]) by smtp.gmail.com with ESMTPSA id
 f11-20020a170902684b00b0018855a22ccfsm2430982pln.91.2022.11.04.04.30.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Nov 2022 04:30:18 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Fri,  4 Nov 2022 19:29:56 +0800
Message-Id: <20221104113000.487098-2-coxu@redhat.com>
In-Reply-To: <20221104113000.487098-1-coxu@redhat.com>
References: <20221104113000.487098-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Mon, 07 Nov 2022 08:40:06 +0000
Subject: [dm-devel] [RFC v2 1/5] kexec_file: allow to place kexec_buf
 randomly
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
Cc: Baoquan He <bhe@redhat.com>, dm-devel@redhat.com,
 Pingfan Liu <kernelfans@gmail.com>, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>, Eric Biederman <ebiederm@xmission.com>,
 Jan Pazdziora <jpazdziora@redhat.com>, Thomas Staudt <tstaudt@de.ibm.com>,
 Dave Young <dyoung@redhat.com>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently, kexec_buf is placed in order which means for the same
machine, the info in the kexec_buf is always located at the same
position each time the machine is booted. This may cause a risk for
sensitive information like LUKS volume key. Now struct kexec_buf has a
new field random which indicates it's supposed to be placed in a random
position.

Suggested-by: Jan Pazdziora <jpazdziora@redhat.com>
Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 include/linux/kexec.h |  2 ++
 kernel/kexec_file.c   | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 13e6c4b58f07..c0edb64bf6c4 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -171,6 +171,7 @@ int kexec_image_post_load_cleanup_default(struct kimage *image);
  * @buf_min:	The buffer can't be placed below this address.
  * @buf_max:	The buffer can't be placed above this address.
  * @top_down:	Allocate from top of memory.
+ * @random:	Place the buffer at a random position.
  */
 struct kexec_buf {
 	struct kimage *image;
@@ -182,6 +183,7 @@ struct kexec_buf {
 	unsigned long buf_min;
 	unsigned long buf_max;
 	bool top_down;
+	bool random;
 };
 
 int kexec_load_purgatory(struct kimage *image, struct kexec_buf *kbuf);
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index a7b411c22f19..ed9fcc369312 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -25,6 +25,7 @@
 #include <linux/elfcore.h>
 #include <linux/kernel.h>
 #include <linux/kernel_read_file.h>
+#include <linux/prandom.h>
 #include <linux/syscalls.h>
 #include <linux/vmalloc.h>
 #include "kexec_internal.h"
@@ -412,6 +413,16 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 	return ret;
 }
 
+static unsigned long kexec_random_start(unsigned long start, unsigned long end)
+{
+	unsigned long temp_start;
+	unsigned short i;
+
+	get_random_bytes(&i, sizeof(unsigned short));
+	temp_start = start + (end - start) / USHRT_MAX * i;
+	return temp_start;
+}
+
 static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 				    struct kexec_buf *kbuf)
 {
@@ -420,6 +431,8 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 
 	temp_end = min(end, kbuf->buf_max);
 	temp_start = temp_end - kbuf->memsz;
+	if (kbuf->random)
+		temp_start = kexec_random_start(temp_start, temp_end);
 
 	do {
 		/* align down start */
@@ -457,6 +470,8 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
 	unsigned long temp_start, temp_end;
 
 	temp_start = max(start, kbuf->buf_min);
+	if (kbuf->random)
+		temp_start = kexec_random_start(temp_start, end);
 
 	do {
 		temp_start = ALIGN(temp_start, kbuf->buf_align);
-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

