Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B05261593
	for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 18:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739297471; cv=none; b=l3y6p5Xky+70/23cs55M8iq8lQSm9CUtgam+5307fla3WnTpefGcg+rHRgL2RqmueFooPd/8IHIK8Qdga12CEqVDrBfqo92+iL5UOqHF/AJiFZcgKIHPoxUUAy5i0CrmFiFpy1xsuc3g+2VqQZBCDgQxJBFdfN6R8jUec66a5vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739297471; c=relaxed/simple;
	bh=xCvpTAXymX7Zy2b2yvDo2/Q5BJdTvON/iibTgSMeFj0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=IVf7klPlnzrj97JNaJTUAD+wgAMUma7OvUlxfgLoqgOptnDTPxowLAA6tO3hEwiYkPYG6w0FRG99yLa5ZluTG+lnGgWHxovJSBfVRKr+ye8Dhzet2Raa2icU47QfvwsOXTNgsKKosxK1eIgPLGJ8SQ3bRJG4GfwvXW1qAkpU2MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aadARwKx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aadARwKx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739297468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iwyvl2600KR1/M6nVYYbRG8FYRH6qto+LmEn366Vi/s=;
	b=aadARwKxIOZwJbuBgc6ZP+3UjJWbsNHYdsN40N8XZbAzq1/mNqSFzDqLrcwzq2Q377rBcT
	Sg1nOYV8zoWW8tpY6W/WII9u6DQt3yBiNoUVnVZWHAaaJLtfeAXNEiO4hIMGiNzpj62Q/o
	uyyvT7DamJUvLGJCH4LPpwKvrd/6rWs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-329-naK2nnhLObanSGzdUJihjA-1; Tue,
 11 Feb 2025 13:11:06 -0500
X-MC-Unique: naK2nnhLObanSGzdUJihjA-1
X-Mimecast-MFC-AGG-ID: naK2nnhLObanSGzdUJihjA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 69A9519560AE;
	Tue, 11 Feb 2025 18:11:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E932E1800570;
	Tue, 11 Feb 2025 18:11:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 51BIB3Mq1506777
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 11 Feb 2025 13:11:03 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 51BIB3Oq1506776;
	Tue, 11 Feb 2025 13:11:03 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] libmultipath: include urcu.h before urcu/atomic.h
Date: Tue, 11 Feb 2025 13:11:03 -0500
Message-ID: <20250211181103.1506768-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Kux_X0eI8TcjhMu3EbRXyfErYPMAvYI8I-M79JYyl-4_1739297465
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

urcu/atomic.h requires some header files included by urcu.h. Make sure
to include it first.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
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

