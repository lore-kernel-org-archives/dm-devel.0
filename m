Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45D347F54
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709266439; cv=none; b=ALjOjT5DwQyeP88ORZ6qrO8rLW41xyKA/L0QnF98e5ZiG/1PVfP1WFY2e/12OnzsihDSy6MgU3hR0TmhNnLNyUp2m2FwCCQGpBFBz+cnk8tu/IkqR4LbptaR5IgmGcIPnIxQMidLvQgNoC9u7IjWVk+iciI4+3kDy066Wr1+qT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709266439; c=relaxed/simple;
	bh=iMUm7E/VAD4lDyj4N5ceUsNf4IV49ax/Vwm3QEyvnC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h+Ps6ZrWQoNDMth+GGUhUFZo6mHtV/6Y5zvS22+oGZiUpZeIith6Ger6HmqF72jOI4nrEw3xIPL5nfxmKA08rc9jRVmFdhJHFru3s1OiDqgui2s/CmUC9m2f4t+iTvZeYHD0fXFvJuLvih93aMeNs5/8+Iy6yxjXNOZVmf9bvpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mk/BLNid; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mk/BLNid"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709266435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s3xcZyQiRgTawTSR+6yRK9Cfy5kPLB2ahIxpZF/G7nQ=;
	b=Mk/BLNidAdL77oQL4iz9JWlOMJhjWRNRgnNWbiMpVai3/bNNM7HHK+ft6JDd4go1RpC80W
	6TTUNceoYwgLvf4dL/TAJx7mZDng1ATecEv4/uLs27Y+/sYSMYojuPzv3kLQ1/guEx5sbp
	bEG/x9O/1/RyjAyMLqiL0qFAnjR8HCU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-HqrPXZUMMEiKhu8k2Lqbiw-1; Thu,
 29 Feb 2024 23:13:53 -0500
X-MC-Unique: HqrPXZUMMEiKhu8k2Lqbiw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BF583C100B1;
	Fri,  1 Mar 2024 04:13:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8750F40153A7;
	Fri,  1 Mar 2024 04:13:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 854CAA15B6; Thu, 29 Feb 2024 23:13:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 4/5] dm vdo: include <asm/current.h> to resolve current being undeclared
Date: Thu, 29 Feb 2024 23:13:52 -0500
Message-ID: <1c4d4f7abb1eddab683b9826525d2281cd236ccc.1709265967.git.msakai@redhat.com>
In-Reply-To: <cover.1709265967.git.msakai@redhat.com>
References: <cover.1709265967.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Reported when building on loongarch.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/logger.c          | 1 +
 drivers/md/dm-vdo/thread-registry.c | 1 +
 drivers/md/dm-vdo/thread-utils.c    | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
index 6ba7e99ee8f9..a50edb0331fc 100644
--- a/drivers/md/dm-vdo/logger.c
+++ b/drivers/md/dm-vdo/logger.c
@@ -5,6 +5,7 @@
 
 #include "logger.h"
 
+#include <asm/current.h>
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/module.h>
diff --git a/drivers/md/dm-vdo/thread-registry.c b/drivers/md/dm-vdo/thread-registry.c
index 1314d2b6a26f..03e2f45e8e78 100644
--- a/drivers/md/dm-vdo/thread-registry.c
+++ b/drivers/md/dm-vdo/thread-registry.c
@@ -5,6 +5,7 @@
 
 #include "thread-registry.h"
 
+#include <asm/current.h>
 #include <linux/rculist.h>
 
 #include "permassert.h"
diff --git a/drivers/md/dm-vdo/thread-utils.c b/drivers/md/dm-vdo/thread-utils.c
index 160679984d72..aeca14bba852 100644
--- a/drivers/md/dm-vdo/thread-utils.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -5,6 +5,7 @@
 
 #include "thread-utils.h"
 
+#include <asm/current.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
-- 
2.42.0

