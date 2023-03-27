Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3065C77B61
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948043;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5W6XgTush3zH1bJRdFcTgXdEm3aJJqjQUMrAbQwYXcU=;
	b=HQCqruStaOkN76lHgoNEOXQvCHYJjKfjgFhIdC23sGHacNVLwgFz5PfgudFckvXMaeV+RP
	BsQjw+5690BU3H2MK4X8tsXgNwVQqfNzobYqPlFFE4K86RmjBrSwlPQjnef3/OWCHBSi3n
	2KpMrgC5RnwZB4l7K5QKXRhioBJnnz8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-vXNVD7p9Pi2yM_ad0l8WGQ-1; Mon, 27 Mar 2023 16:14:02 -0400
X-MC-Unique: vXNVD7p9Pi2yM_ad0l8WGQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C96B1C068CF;
	Mon, 27 Mar 2023 20:13:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A2DC40B3ED9;
	Mon, 27 Mar 2023 20:13:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 89DE01946A7E;
	Mon, 27 Mar 2023 20:13:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 192711946A61
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0D0C03542A; Mon, 27 Mar 2023 20:13:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 03DB943FBE
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D69803C0ED4F
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:35 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-bgXo-6lAOp2nqTaboMKKMQ-4; Mon, 27 Mar 2023 16:13:34 -0400
X-MC-Unique: bgXo-6lAOp2nqTaboMKKMQ-4
Received: by mail-qt1-f175.google.com with SMTP id h16so3007921qtn.7
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948013;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=P0nH8y5nrVQVdjQ+7MWEvssVfY/cEbcGbEWp6ylrqyQ=;
 b=QLS2gGn1qL2IHgMM3IFnwFhSTm7EGtExBqL081b8BsVlwcGXTq+HGZGf2NNQO8ZoDG
 thk2j8vJkXDT82xd9QJYaMD06TX6RDZjbom6Q3kM5J1RMYAuFGOu2ceFzwxovoIm/lQC
 Do6ysB6NP5E/pk5IGiEo3X3cXPktjXHCiYSyrkqj7LPSELW/Vc1JiDLA52iK9pbsipAl
 +nag+sTIbTvwltrbHfxq9ax+DPNthxB6uErsmzhqW5B5J1trmg4FnM4TGx3JvL+4Mv9d
 D+Df4Aipc8SrXlP0t4M+5nbIuwGCrcC6KHFe2YlT9gxQ7EVSOSJPRifEHVMClSN168hx
 BjJQ==
X-Gm-Message-State: AAQBX9fFKtghJFrWBFzPenl0/oaWkF/n/FAD4UxnlAXdyXZVThIz+3/a
 biElC1gjgfcuH5vefYqVUn5nYMoStxu9V7PVBPxNv+CXd76Gy+VZyCy89x/zyrDUtUEhNKoZHRU
 LvqWSx4a80zrY3OsF+EkFqJoCRgKnZAvnoZzW4AXu6IMtnwiFgBFRo3uCz0nBdZwXhBEKi3zcbX
 0=
X-Google-Smtp-Source: AKy350Y96gqJ8gm1eUDkWBdhHVPSIF25C9Z/7pTPicBHvic+yBssV8gx7JTYQ5NQ4P/SYw+5vk3tRA==
X-Received: by 2002:ac8:5c46:0:b0:3e4:e8a8:f235 with SMTP id
 j6-20020ac85c46000000b003e4e8a8f235mr8388241qtj.36.1679948013682; 
 Mon, 27 Mar 2023 13:13:33 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 6-20020ac85646000000b003e3897d8505sm6400099qtt.54.2023.03.27.13.13.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:33 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:39 -0400
Message-Id: <20230327201143.51026-17-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [dm-6.4 PATCH v3 16/20] dm: add dm_num_sharded_locks()
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, keescook@chromium.org,
 heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Simple helper to use when DM core code needs to appropriately size,
based on num_online_cpus(), its data structures that split locks.

dm_num_sharded_locks() rounds up num_online_cpus() to next power of 2
but caps return at DM_MAX_SHARDED_LOCKS (64).

This heuristic may evolve as warranted, but as-is it will serve as a
more informed basis for sizing the sharded lock structs in dm-bufio's
dm_buffer_cache (buffer_trees) and dm-bio-prison-v1's dm_bio_prison
(prison_regions).

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 22eaed188907..18450282d0d9 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -20,6 +20,7 @@
 #include <linux/completion.h>
 #include <linux/kobject.h>
 #include <linux/refcount.h>
+#include <linux/log2.h>
 
 #include "dm-stats.h"
 
@@ -228,4 +229,13 @@ void dm_free_md_mempools(struct dm_md_mempools *pools);
  */
 unsigned int dm_get_reserved_bio_based_ios(void);
 
+#define DM_MAX_SHARDED_LOCKS 64
+
+static inline unsigned int dm_num_sharded_locks(void)
+{
+	unsigned int num_locks = roundup_pow_of_two(num_online_cpus());
+
+	return min_t(unsigned int, num_locks, DM_MAX_SHARDED_LOCKS);
+}
+
 #endif
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

