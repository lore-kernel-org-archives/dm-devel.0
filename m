Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67545C7EE2F
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 05:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685684384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=x+dNCfD7Qs4EvAtF60xUWLz73uKOf5hqRsXMt+H3JWA=;
	b=bhhaMx8cgp+lYrQmEw1dc6dCIlnoG6VewYf4Kf1e9vXUs5hryLTFQ0oBqyU6nR8WYvOLgh
	kR6tB9M0IybOxH9m6zvumR0nu7Djxm+ZCo3zjMxk5JA/GjH5G3RkHbw4jdxfMhv0iFouBs
	ejhe5T2TZ5p1eHWQ4L0R83N1dWC8QGU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-IyVsUqsuNv2CGgOhAtmG6w-1; Fri, 02 Jun 2023 01:39:40 -0400
X-MC-Unique: IyVsUqsuNv2CGgOhAtmG6w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECA64858F1B;
	Fri,  2 Jun 2023 05:39:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C36E40CFD45;
	Fri,  2 Jun 2023 05:39:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18EBB19465B6;
	Fri,  2 Jun 2023 05:39:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C3A2A19451E5
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 07:24:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A746F200AE6F; Thu,  1 Jun 2023 07:24:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FE40202696C
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:24:56 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83E7E80120A
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 07:24:56 +0000 (UTC)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-Pqb3sPHJO3Gd69r0zcBL-A-1; Thu, 01 Jun 2023 03:24:53 -0400
X-MC-Unique: Pqb3sPHJO3Gd69r0zcBL-A-1
Received: by mail-pl1-f197.google.com with SMTP id
 d9443c01a7336-1b03cfa7602so1742195ad.3
 for <dm-devel@redhat.com>; Thu, 01 Jun 2023 00:24:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685604292; x=1688196292;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=AV8aUvr4ixGLZyIesmYQLsbGSBUr0/xlhliel/t7Lh8=;
 b=Qi0M+lfvYnOKLfFXh8l1jZYyzYhn2UjeEh9GkOfVs1cOWzGT65dqPs9LRNjbFU+4yY
 3TFus3mOfTy8AplKtqWp5Ngq+h7GXJFjeFIRGYPJTRPghmMdWEZJRNBgeRGguPYbDP81
 AbajywCFqurQJ4XLXx0Kr9lb0MYZqWS2Kd/Byt/gdZ7s3rh8SCcuZdmdWb6J23kDAfEM
 KTpMXHpXPzwedNbPQCDGOYKaL2Zs3ypFNAO1vjGihrTc81Xd19Z0NwRLGeEKDFcuFd08
 LjrlNRhvdXhURBHjHvwdrMiFYB/boFqvDTh3ceQCg5zg9bfFD9It8O1abwDQ+rIxEIOY
 vbag==
X-Gm-Message-State: AC+VfDz3nsI82C2Eqp56I+f9ltvQLLhNC2sDp5bGWxcfMw61Zmq1WzXB
 dakKN5ytfm5IQFWfpzvwEd3BmV+JQ5vQakIqacYatTBArg5zrPOzB7XOpkzHy0SzRF3TVrgX0nB
 8JNIvTjDDvuMKQWg=
X-Received: by 2002:a17:902:e811:b0:1b0:5e97:ee2e with SMTP id
 u17-20020a170902e81100b001b05e97ee2emr6960534plg.19.1685604291999; 
 Thu, 01 Jun 2023 00:24:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ662P0lLrFIg86H16E966109yZnfDIKygWQtWOgjwFAIugqodl1XMDNcj6+cm1VNgP+uGfilg==
X-Received: by 2002:a17:902:e811:b0:1b0:5e97:ee2e with SMTP id
 u17-20020a170902e81100b001b05e97ee2emr6960516plg.19.1685604291629; 
 Thu, 01 Jun 2023 00:24:51 -0700 (PDT)
Received: from localhost ([43.228.180.230]) by smtp.gmail.com with ESMTPSA id
 z15-20020a170903018f00b00199203a4fa3sm2666890plg.203.2023.06.01.00.24.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Jun 2023 00:24:51 -0700 (PDT)
From: Coiby Xu <coxu@redhat.com>
To: kexec@lists.infradead.org
Date: Thu,  1 Jun 2023 15:24:40 +0800
Message-Id: <20230601072444.2033855-2-coxu@redhat.com>
In-Reply-To: <20230601072444.2033855-1-coxu@redhat.com>
References: <20230601072444.2033855-1-coxu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Fri, 02 Jun 2023 05:39:36 +0000
Subject: [dm-devel] [PATCH 1/5] kexec_file: allow to place kexec_buf randomly
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
Cc: Baoquan He <bhe@redhat.com>, x86@kernel.org, dm-devel@redhat.com,
 Pingfan Liu <kernelfans@gmail.com>, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@intel.com>, Kairui Song <ryncsn@gmail.com>,
 Eric Biederman <ebiederm@xmission.com>, Jan Pazdziora <jpazdziora@redhat.com>,
 Thomas Staudt <tstaudt@de.ibm.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Dave Young <dyoung@redhat.com>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
index 22b5cd24f581..5b2440444112 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -172,6 +172,7 @@ int kexec_image_post_load_cleanup_default(struct kimage *image);
  * @buf_min:	The buffer can't be placed below this address.
  * @buf_max:	The buffer can't be placed above this address.
  * @top_down:	Allocate from top of memory.
+ * @random:	Place the buffer at a random position.
  */
 struct kexec_buf {
 	struct kimage *image;
@@ -183,6 +184,7 @@ struct kexec_buf {
 	unsigned long buf_min;
 	unsigned long buf_max;
 	bool top_down;
+	bool random;
 };
 
 int kexec_load_purgatory(struct kimage *image, struct kexec_buf *kbuf);
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index f989f5f1933b..5dbfc119eb6a 100644
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
@@ -419,6 +420,16 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
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
@@ -427,6 +438,8 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 
 	temp_end = min(end, kbuf->buf_max);
 	temp_start = temp_end - kbuf->memsz;
+	if (kbuf->random)
+		temp_start = kexec_random_start(temp_start, temp_end);
 
 	do {
 		/* align down start */
@@ -464,6 +477,8 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
 	unsigned long temp_start, temp_end;
 
 	temp_start = max(start, kbuf->buf_min);
+	if (kbuf->random)
+		temp_start = kexec_random_start(temp_start, end);
 
 	do {
 		temp_start = ALIGN(temp_start, kbuf->buf_align);
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

