Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D62278747;
	Mon,  5 May 2025 22:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485739; cv=none; b=uCIOh68gDmwRAKoLFA0ZbCau4kFxIb8HyylWhkB9taCU051tvtJPgMy2dmUoODjtPyvv0lkduKHcVdrAPURHm04BkRglCEMrsibvePhE5Fly5OM7/FJR++H7701pfftcMwVEUCiBMKPIYZh0obEUyXBHvgmYE8zg6OhthRelFAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485739; c=relaxed/simple;
	bh=auIwF0BsRvnVi0C+zFWokWEcplIdWkcrNlydNQ+w1hI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+FEzs56/maVOC5zdYWHIiKkC/339d7DIXKWqWlm2dFOA24MzzXOx0t7vl+D5FPGHIMFq5V3HfCo5seENq+/JCkAzT+yYwwY6N/riHFJLe2lS6DWBHOQYC7GmI1YsVifNWbBCfDpvJsODfpHj3giq32M0BIfLh5zkTjnvDmfocI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OqCES1vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OqCES1vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0191EC4CEEE;
	Mon,  5 May 2025 22:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485738;
	bh=auIwF0BsRvnVi0C+zFWokWEcplIdWkcrNlydNQ+w1hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqCES1vfYjdCVcVKg+9N1ifYL3IRrMMzjSm/D181Ml00LeY+ij5Hxq6fncFfr862E
	 FQNEFP6mC26HVkbmwdfvcYRTUGOtXfIngG/icHrbomOMzHhL0AnXZMMFJonBwfG3Xz
	 vbJ75/2sn3JU0CPbdMElA3+P/KgyGsm6V68T77aB/ROHsXsapkZaVCYyKNlp95q+VA
	 xNMymKm1Ph1R6zgzeuRvqQlI3YiSL/W1EZNp/AuW+MaHaAQjE/Cqdg/cOHTSjumdou
	 nIbm0s5nuT9OBqcjSguytbSsyvZTk0CXggU3+Wq/Igy78eZ+js0oqnIknpeYtkIps0
	 0/mzbyWf/nlqw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Matthew Sakai <msakai@redhat.com>,
	John Garry <john.g.garry@oracle.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.12 454/486] dm vdo: use a short static string for thread name prefix
Date: Mon,  5 May 2025 18:38:50 -0400
Message-Id: <20250505223922.2682012-454-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
Content-Transfer-Encoding: 8bit

From: Matthew Sakai <msakai@redhat.com>

[ Upstream commit 3280c9313c9adce01550cc9f00edfb1dc7c744da ]

Also remove MODULE_NAME and a BUG_ON check, both unneeded.

This fixes a warning about string truncation in snprintf that
will never happen in practice:

drivers/md/dm-vdo/vdo.c: In function ‘vdo_make’:
drivers/md/dm-vdo/vdo.c:564:5: error: ‘%s’ directive output may be truncated writing up to 55 bytes into a region of size 16 [-Werror=format-truncation=]
    "%s%u", MODULE_NAME, instance);
     ^~
drivers/md/dm-vdo/vdo.c:563:2: note: ‘snprintf’ output between 2 and 66 bytes into a destination of size 16
  snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "%s%u", MODULE_NAME, instance);
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-vdo/vdo.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index fff847767755a..b897f88250d2a 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -31,9 +31,7 @@
 
 #include <linux/completion.h>
 #include <linux/device-mapper.h>
-#include <linux/kernel.h>
 #include <linux/lz4.h>
-#include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
@@ -142,12 +140,6 @@ static void finish_vdo_request_queue(void *ptr)
 	vdo_unregister_allocating_thread();
 }
 
-#ifdef MODULE
-#define MODULE_NAME THIS_MODULE->name
-#else
-#define MODULE_NAME "dm-vdo"
-#endif  /* MODULE */
-
 static const struct vdo_work_queue_type default_queue_type = {
 	.start = start_vdo_request_queue,
 	.finish = finish_vdo_request_queue,
@@ -559,8 +551,7 @@ int vdo_make(unsigned int instance, struct device_config *config, char **reason,
 	*vdo_ptr = vdo;
 
 	snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
-		 "%s%u", MODULE_NAME, instance);
-	BUG_ON(vdo->thread_name_prefix[0] == '\0');
+		 "vdo%u", instance);
 	result = vdo_allocate(vdo->thread_config.thread_count,
 			      struct vdo_thread, __func__, &vdo->threads);
 	if (result != VDO_SUCCESS) {
-- 
2.39.5

