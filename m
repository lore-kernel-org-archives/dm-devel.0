Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417A250A65
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709266675; cv=none; b=gOmNdvgawg6evzki6l/4nRb8Q8CtqvsW05smfRVHm5zckdklICVsI11vYDQ0tj6wf/Y/sg+EYmN+7bnAEFjFgWjEQ4q7Iv9k/NSMbHOKKBtbrn0U92BjzHViKf8+10BQcsEDt8Fcc4XdeL7FV7prC6NU+5Dn6h5GV9K4gPu0ZDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709266675; c=relaxed/simple;
	bh=ouHt5jusMQJOw+YxKASJkjoIHLByRfG6eOhHZm13bcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jPmKqBG5rK01h4SQOHDlVte9D9XN318Gg4/ZI0O6bD+qfqnN3wg2TJmuZo0SIVL7OPKuVMR8GqIGpsbSfOshNpyh47XUcUKGYEbC/zKf8x8cF1I1liEpPgDTJEpbxsx/yuDdjTj21qzWLUBRvhI45V7I/SXYxAuFvrTjy5AqqXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OVG5DzYg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OVG5DzYg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709266665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6XTpQ8TELOyfJtPjkrs96xvE6+UkimxTo5bVzVNqTU0=;
	b=OVG5DzYgjZEdDvRCZGVkBC8sP7lWcusj8bwOjih9de3nlVtmlrTW/mtkg83RpWdrB65nAE
	zY4SZTocn6iKOxdY2vTG/BxJ76YULRwikzYl2bq4sOJnetrtYV7cyOIKcKJvkxlFxHoc8b
	jIhOUZTYVCslBv0/fKdzxXHO5lQOI3w=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-BozabHR0MjaW6QC3QY5viQ-1; Thu,
 29 Feb 2024 23:17:43 -0500
X-MC-Unique: BozabHR0MjaW6QC3QY5viQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9CC429AC011
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:17:42 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C4B9540C6EBA;
	Fri,  1 Mar 2024 04:17:42 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id BF192A15C1; Thu, 29 Feb 2024 23:17:42 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/2] dm vdo: remove unnecessary indexer.h includes
Date: Thu, 29 Feb 2024 23:17:41 -0500
Message-ID: <b8d042b133b6aa9953fd170abef46876a4aaafd9.1709266548.git.msakai@redhat.com>
In-Reply-To: <cover.1709266547.git.msakai@redhat.com>
References: <cover.1709266547.git.msakai@redhat.com>
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

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/encodings.h | 1 -
 drivers/md/dm-vdo/vdo.h       | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/md/dm-vdo/encodings.h b/drivers/md/dm-vdo/encodings.h
index 18794fd59b0b..e5ff2b0aaa79 100644
--- a/drivers/md/dm-vdo/encodings.h
+++ b/drivers/md/dm-vdo/encodings.h
@@ -11,7 +11,6 @@
 #include <linux/limits.h>
 #include <linux/uuid.h>
 
-#include "indexer.h"
 #include "numeric.h"
 
 #include "constants.h"
diff --git a/drivers/md/dm-vdo/vdo.h b/drivers/md/dm-vdo/vdo.h
index 3938e519ae6a..01558fc67f24 100644
--- a/drivers/md/dm-vdo/vdo.h
+++ b/drivers/md/dm-vdo/vdo.h
@@ -17,7 +17,6 @@
 #include "admin-state.h"
 #include "encodings.h"
 #include "funnel-workqueue.h"
-#include "indexer.h"
 #include "packer.h"
 #include "physical-zone.h"
 #include "statistics.h"
-- 
2.42.0

