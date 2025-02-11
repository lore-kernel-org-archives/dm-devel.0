Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BA6263C97
	for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 21:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739308376; cv=none; b=NKkwkhEKUngZs+EFkkwkLafc/rWKMqxX9BFopyzwMQcn1CC7AHKEOOysJXGqSH9ekDseociPFdwdfLVflws3K3c0TipWuOebSGuLfPpiJNvShQyW61C0r4yf41+oAsGcx9TK/69BKycFSRZI24ABoDoibk98xZz+8dwRbSsQk1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739308376; c=relaxed/simple;
	bh=ETajzHwys4K2y4d0vGHwt+JCZaQXqVODT+LCC+VqiPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=CEsXsx71P4XwwwvOdk3ptRTbVxjSNiETi7793xZXcS5t2RhCNvNCRPsf8csNkXs9zYzHdop5k5DSlGED3+D8V1VW3NgREA3YDHaJtcBcbbsxhGBaf0EaDNCLWUYfCBWLYlAlfSxAkyNMdJz/tN6+gLHhZFKam7Ro9G9cdpAYKyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g8wqklrH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g8wqklrH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739308373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DmNQh91kRSxS11hDHkiPtXbJ8c1QH4ChicwasoVZWPg=;
	b=g8wqklrH9MrxeaKohMJTcAD0puzBlNbNIHU6Z1cUekTbXjo21S5k3X4GYKqPpRAO6a3Wfq
	qShAakmFemP1LW0Q9UMQAkcHYOphwJjSRx8awDlqJ3ZSPZNzW6NSc++6J6Qevxy2m85QYT
	ewEdgidLBtVDWDlE4P4jqnjMDJFpTPY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-30-bQIkgdYlNjSU-DRHg5iY5A-1; Tue,
 11 Feb 2025 16:12:50 -0500
X-MC-Unique: bQIkgdYlNjSU-DRHg5iY5A-1
X-Mimecast-MFC-AGG-ID: bQIkgdYlNjSU-DRHg5iY5A_1739308369
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90A541801216;
	Tue, 11 Feb 2025 21:12:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC53B1955F21;
	Tue, 11 Feb 2025 21:12:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 51BLCcON1671018
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 11 Feb 2025 16:12:38 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 51BLCcj01671017;
	Tue, 11 Feb 2025 16:12:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2] libmultipath: include urcu.h before urcu/atomic.h
Date: Tue, 11 Feb 2025 16:12:37 -0500
Message-ID: <20250211211237.1671009-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k6BeEdVsjhCLZKub_kB7UzU5EW6noHRMa8OryDSRD6I_1739308369
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

urcu/atomic.h requires some header files included by urcu.h. Make sure
to include it first.

Fixes: https://github.com/opensvc/multipath-tools/issues/112
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Differences from v1:
  Added a Fixes trailer.

 libmultipath/checkers/tur.c | 1 +
 libmultipath/lock.h         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index e70a2e11..0010acf8 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -15,6 +15,7 @@
 #include <errno.h>
 #include <sys/time.h>
 #include <pthread.h>
+#include <urcu.h>
 #include <urcu/uatomic.h>
 
 #include "checkers.h"
diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index 38473a8c..5f323055 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -2,6 +2,7 @@
 #define LOCK_H_INCLUDED
 
 #include <pthread.h>
+#include <urcu.h>
 #include <urcu/uatomic.h>
 #include <stdbool.h>
 
-- 
2.48.1

