Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E88C4361A
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 09:27:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E4122225AB
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 09:27:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4122225AB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-L9zgnGHdOf2gLOssAvOauQ-1; Fri, 04 Dec 2020 04:27:44 -0500
X-MC-Unique: L9zgnGHdOf2gLOssAvOauQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7A0B800D55;
	Fri,  4 Dec 2020 09:27:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C608F6086F;
	Fri,  4 Dec 2020 09:27:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 97DBF5002D;
	Fri,  4 Dec 2020 09:27:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3MWZbF011146 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 17:32:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B4B442026D12; Thu,  3 Dec 2020 22:32:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AFED82026D49
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 22:32:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7470A10580C1
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 22:32:33 +0000 (UTC)
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com
	[209.85.210.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-288-BBLNt6aON4KOBGJZsrq7lw-1; Thu, 03 Dec 2020 17:32:29 -0500
X-MC-Unique: BBLNt6aON4KOBGJZsrq7lw-1
Received: by mail-pf1-f195.google.com with SMTP id b26so2313241pfi.3
	for <dm-devel@redhat.com>; Thu, 03 Dec 2020 14:32:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:cc:from:to;
	bh=Fuz2jWCqrF9IAKxP8k6Nya5ZGJecRF+RgzAZtQ1aguQ=;
	b=Qa2VVP+beu7/XjT1oWkqCUdgddVbcqBzgcHXzaA41FC7tCVMm5j7dfHEfdTuAhurek
	bMLuRPEtMHf9HgULMqZiQYZL1amnejMWbaoe8QL6q1yA8Bwm0PsY1U+x/T185or4IVGs
	oCUDq0CJl6OgI4fn86cqBikBf9redbmp6yPvI/JlayQt5wwUHj5Qa/vrbCbCLL6KNuDb
	megU7SpagwkVEvDqkVhO5NlQlQ+kstZkuCni4Kp+QHRTfACsClHsNNi3ts//7Np7aT2G
	2nVxmTh3vPT3Dz3IMeqZil25CZtY+L+UgwRhUAh3hnpRmy4xwUTmwYcfgQBaE9zOo03z
	UEbw==
X-Gm-Message-State: AOAM533oX9B74Vucl+vgct5edfYDqbwa/tQ/TnHf057CLA2u/spEeTQP
	hwLz3iotJKs+BrpK7zbJ3bvUkQ==
X-Google-Smtp-Source: ABdhPJx2WNV5k33+iBsSIbI9umTnQLWqfWRaWsln1Jxc6zjGtr+fhirdSbDdprGD/O3QhEedC5oQ8Q==
X-Received: by 2002:a62:8f4e:0:b029:18b:bd18:75b7 with SMTP id
	n75-20020a628f4e0000b029018bbd1875b7mr970569pfd.48.1607034748209;
	Thu, 03 Dec 2020 14:32:28 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net.
	[76.210.143.223]) by smtp.gmail.com with ESMTPSA id
	cq15sm332045pjb.27.2020.12.03.14.32.27
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Dec 2020 14:32:27 -0800 (PST)
Date: Thu,  3 Dec 2020 13:58:56 -0800
Message-Id: <20201203215859.2719888-3-palmer@dabbelt.com>
In-Reply-To: <20201203215859.2719888-1-palmer@dabbelt.com>
References: <20201203215859.2719888-1-palmer@dabbelt.com>
MIME-Version: 1.0
From: Palmer Dabbelt <palmer@dabbelt.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Dec 2020 04:27:21 -0500
Cc: corbet@lwn.net, linux-doc@vger.kernel.org, kernel-team@android.com,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	song@kernel.org, linux-kselftest@vger.kernel.org, shuah@kernel.org
Subject: [dm-devel] [PATCH v1 2/5] uapi: Add dm-user structure definition
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Palmer Dabbelt <palmerdabbelt@google.com>

dm-user is a device mapper target that allows a userspace process to
handle each incoming BIO.  Communication with userspace consists of a
stream of messages proxied over a misc device, the structure of each
message is defined in this header.

Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

---

As it currently stands this isn't really sufficient to be a stable user
ABI.  These are probably best discussed in the context of the dm-user
implementation, though, where they're largely called out as FIXMEs.
---
 include/uapi/linux/dm-user.h | 67 ++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 include/uapi/linux/dm-user.h

diff --git a/include/uapi/linux/dm-user.h b/include/uapi/linux/dm-user.h
new file mode 100644
index 000000000000..1806109518f4
--- /dev/null
+++ b/include/uapi/linux/dm-user.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: LGPL-2.0+ WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2020 Palmer Dabbelt <palmerdabbelt@google.com>
+ */
+
+#ifndef _LINUX_DM_USER_H
+#define _LINUX_DM_USER_H
+
+#include <linux/types.h>
+
+/*
+ * dm-user proxies device mapper ops between the kernel and userspace.  It's
+ * essentially just an RPC mechanism: all kernel calls create a request,
+ * userspace handles that with a response.  Userspace obtains requests via
+ * read() and provides responses via write().
+ *
+ * See Documentation/block/dm-user.rst for more information.
+ */
+
+#define DM_USER_REQ_MAP_READ 0
+#define DM_USER_REQ_MAP_WRITE 1
+#define DM_USER_REQ_MAP_FLUSH 2
+#define DM_USER_REQ_MAP_DISCARD 3
+#define DM_USER_REQ_MAP_SECURE_ERASE 4
+#define DM_USER_REQ_MAP_WRITE_SAME 5
+#define DM_USER_REQ_MAP_WRITE_ZEROES 6
+#define DM_USER_REQ_MAP_ZONE_OPEN 7
+#define DM_USER_REQ_MAP_ZONE_CLOSE 8
+#define DM_USER_REQ_MAP_ZONE_FINISH 9
+#define DM_USER_REQ_MAP_ZONE_APPEND 10
+#define DM_USER_REQ_MAP_ZONE_RESET 11
+#define DM_USER_REQ_MAP_ZONE_RESET_ALL 12
+
+#define DM_USER_REQ_MAP_FLAG_FAILFAST_DEV 0x00001
+#define DM_USER_REQ_MAP_FLAG_FAILFAST_TRANSPORT 0x00002
+#define DM_USER_REQ_MAP_FLAG_FAILFAST_DRIVER 0x00004
+#define DM_USER_REQ_MAP_FLAG_SYNC 0x00008
+#define DM_USER_REQ_MAP_FLAG_META 0x00010
+#define DM_USER_REQ_MAP_FLAG_PRIO 0x00020
+#define DM_USER_REQ_MAP_FLAG_NOMERGE 0x00040
+#define DM_USER_REQ_MAP_FLAG_IDLE 0x00080
+#define DM_USER_REQ_MAP_FLAG_INTEGRITY 0x00100
+#define DM_USER_REQ_MAP_FLAG_FUA 0x00200
+#define DM_USER_REQ_MAP_FLAG_PREFLUSH 0x00400
+#define DM_USER_REQ_MAP_FLAG_RAHEAD 0x00800
+#define DM_USER_REQ_MAP_FLAG_BACKGROUND 0x01000
+#define DM_USER_REQ_MAP_FLAG_NOWAIT 0x02000
+#define DM_USER_REQ_MAP_FLAG_CGROUP_PUNT 0x04000
+#define DM_USER_REQ_MAP_FLAG_NOUNMAP 0x08000
+#define DM_USER_REQ_MAP_FLAG_HIPRI 0x10000
+#define DM_USER_REQ_MAP_FLAG_DRV 0x20000
+#define DM_USER_REQ_MAP_FLAG_SWAP 0x40000
+
+#define DM_USER_RESP_SUCCESS 0
+#define DM_USER_RESP_ERROR 1
+#define DM_USER_RESP_UNSUPPORTED 2
+
+struct dm_user_message {
+	__u64 seq;
+	__u64 type;
+	__u64 flags;
+	__u64 sector;
+	__u64 len;
+	__u8 buf[];
+};
+
+#endif
-- 
2.29.2.454.gaff20da3a2-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

