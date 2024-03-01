Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998E647A52
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265191; cv=none; b=ZBl2cGKfaTN1ksY+kP3RUUBk8UOsyC3HxUTkDfp+TSFAJCAPhVUr35p1qDOrTDNq7W6w3iTsX8uGiyGr5pSfrqQQylZABnIPJhdIin03mQDdPexp3QhHcjua+8u4M3XkRtYZfXaSF11VvgV36vgtm83UBlk56BgCp0Pfe5xpaso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265191; c=relaxed/simple;
	bh=aLtgvQSemkKnuKWja3UeHz1IA/ZA41rkYPmja54oM7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MlwwJVl855jPmXDAwzTu/nn5D5h4YDcCz5ZXOI879gwJrVevMcQ4dFJdBpt0yoOXPfTKJPx+6HQjYsCtUglp+id3YNR5taFSCJlCZsG1Ejj9UfM6u0jWAEhb3x9z0KxcxubqimV3OBaQWnnwuuLbD6ZBSFbQzh93u5lD2OdFqbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NOmivneD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NOmivneD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=azqrKor045ByykXasBsYFw/BiYekmpc7YKFdVbKEgVU=;
	b=NOmivneDsQKXsfGe3h/118cxX1gJkMbJJfdFCn4RqFQla3OeJK5UangiUCshB7DixVbd6V
	OY0RlbLkyEL++tlNwVRAI9TKcUxzAlS1hhIqbaVgnHMz9eqgDL4fkEWVpCUQ0sZkj4+myj
	RKI4Ic8cjRBNlKsBJfWzXL3gYZh59IE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-8urARKMfMvm9v6f2qIExAQ-1; Thu, 29 Feb 2024 22:53:05 -0500
X-MC-Unique: 8urARKMfMvm9v6f2qIExAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8475C859702;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7EEA22166B5D;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 7C7939EB37; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 11/13] dm vdo thread-utils: cleanup included headers
Date: Thu, 29 Feb 2024 22:53:03 -0500
Message-ID: <fa2a502d60b6e8f0770702e30710617e55156b5b.1709264539.git.msakai@redhat.com>
In-Reply-To: <cover.1709264538.git.msakai@redhat.com>
References: <cover.1709264538.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/logger.c       | 1 +
 drivers/md/dm-vdo/thread-utils.c | 4 ++--
 drivers/md/dm-vdo/thread-utils.h | 6 ------
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
index ff1c570f81bf..969f10771ada 100644
--- a/drivers/md/dm-vdo/logger.c
+++ b/drivers/md/dm-vdo/logger.c
@@ -11,6 +11,7 @@
 #include <linux/printk.h>
 #include <linux/sched.h>
 
+#include "errors.h"
 #include "thread-device.h"
 #include "thread-utils.h"
 
diff --git a/drivers/md/dm-vdo/thread-utils.c b/drivers/md/dm-vdo/thread-utils.c
index 0b80247c7f1b..160679984d72 100644
--- a/drivers/md/dm-vdo/thread-utils.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -5,10 +5,10 @@
 
 #include "thread-utils.h"
 
-#include <linux/completion.h>
 #include <linux/delay.h>
-#include <linux/err.h>
 #include <linux/kthread.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
 
 #include "errors.h"
 #include "logger.h"
diff --git a/drivers/md/dm-vdo/thread-utils.h b/drivers/md/dm-vdo/thread-utils.h
index ebe032e066ff..f3619a581c5e 100644
--- a/drivers/md/dm-vdo/thread-utils.h
+++ b/drivers/md/dm-vdo/thread-utils.h
@@ -7,12 +7,6 @@
 #define THREAD_UTILS_H
 
 #include <linux/atomic.h>
-#include <linux/delay.h>
-#include <linux/jiffies.h>
-#include <linux/mutex.h>
-#include <linux/semaphore.h>
-
-#include "errors.h"
 
 /* Thread and synchronization utilities */
 
-- 
2.42.0

