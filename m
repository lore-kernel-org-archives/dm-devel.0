Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535FC84D04;
	Thu, 23 May 2024 21:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716498442; cv=none; b=plc+YNvI184TIrtFX7QscYJrhAj6d2ZJHYRwyFsx+G3uDjWKDjrWWUs0BWKAdVvih3j+pnaFTb7Hx23ZiRveoe941yRJDSWLNihQDs2JI+Q6hVqxoafkkd5e8AQ+lFFiQYLDt7q7rtKRpjsfKDRlXnUH2DuihBZH8Nwa48CzJdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716498442; c=relaxed/simple;
	bh=PbBYk8PiVv6brRSth0vNHsED/KW26oVljgJjisiPDLg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N76qbs16VBtRmfKG2DwuXMVKf+O4pZUYxFFSqaI+I2AFGcMBqAbM+7g3204jX09HD+ant0K9z1hJ8TeXXh3UowDFdh9VUTnX7dqdX86vimt87kTtKpC/+yCXDelZApiZ2i5GZ05+lrpwE7P7mTYybfdPMPZwuUFfvLymxq4O3/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=gEecZr3U; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="gEecZr3U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=7qG+uNQZnUaNUXVcfTHwCeuNSkeAidiwNplE21S15Ms=; b=gEecZr3UNv1lcai7
	RTf5JGx5IhuW6X1To82r/lcaKnSI5TW5jCjpqIS0tvSFHNtJsDwZvUPEmo88C1GlMorOOgsjlSJ7d
	GWNet6z6xr95yAqp7WCXQ63xJBow9WWZpsBSqmR3vM8+31oKLK+BM1zCwVN42NYpKvHGufKM+dZgE
	OPPP50yjNgSGmlBKNR1Tve/7lbbwWY4/tU2XVvEPsmw0nawe/7t5BQGjHR0cI1KBcpMdKKRRrub6j
	gZ/aL/2pn3+yE8YwYPnyN0YHK5BRlAqYVrxTRzwBifYebGZfkWgHheogTR+zWIf8XMEEFrrNNiYWk
	QSMj6l1QhqcSeFampQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sAFef-002ISz-2f;
	Thu, 23 May 2024 21:07:18 +0000
From: linux@treblig.org
To: msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] dm vdo: remove unused struct 'uds_attribute'
Date: Thu, 23 May 2024 22:07:16 +0100
Message-ID: <20240523210716.309324-1-linux@treblig.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

'uds_attribute' is unused since
commit a9da0fb6d8c6 ("dm vdo: remove all sysfs interfaces").

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/md/dm-vdo/dedupe.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 117266e1b3ae..39ac68614419 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -148,11 +148,6 @@
 #include "vdo.h"
 #include "wait-queue.h"
 
-struct uds_attribute {
-	struct attribute attr;
-	const char *(*show_string)(struct hash_zones *hash_zones);
-};
-
 #define DEDUPE_QUERY_TIMER_IDLE 0
 #define DEDUPE_QUERY_TIMER_RUNNING 1
 #define DEDUPE_QUERY_TIMER_FIRED 2
-- 
2.45.1

