Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A18933A377;
	Mon,  5 May 2025 22:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484641; cv=none; b=VnJGsyMPEo5qSQoPcNXO49RmZtCmE2MfwLVNKFP6dISjLGQEcieouVNdFnNPwJRoRp7beY4olQ5bDcOmsT1+FdDGSPLbKFP0o//xqHFFH/JctnAgJDad5QuToiBO2Q+rtAwaYwXCeeNv/0vgz8gHk0mqjiysuowrZtyxVByIKoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484641; c=relaxed/simple;
	bh=YJzrnvR1WxIwI8yE3Lj3wWz8qSxn1MtPU+G9uWtYFnA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f0tR4zTETz8bPmnYsS6e13RCvkirT11StshFGzA4hkHUpPotnS7h+rCAgqrNM1uAKSzX3smHyTxut5tBVTsiYLNU0TybyxAq8qa0LB+ZfxsuZvGGJpm1coWu38vzlH4+SuYBQivy3QfzUiLAybQdOmrH/7QoxH+DCsV6G8sidbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ElSxeJYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ElSxeJYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB395C4CEE4;
	Mon,  5 May 2025 22:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484641;
	bh=YJzrnvR1WxIwI8yE3Lj3wWz8qSxn1MtPU+G9uWtYFnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElSxeJYQceaXls2kbuXc3qsIY+4G7v6CAjW6sXIPyxslYbeKpZsuwOSWQ6ThWsbDx
	 ggDTBdQq2iBQ2WGX/YGbcWmUe/5s88Mw2w4X4IBKVnwH4BdA1BeLkXHTzDMYnSInIm
	 XjAGaXPBd1JBbGzhO84ASWc8i9AXG//Kn7UL5v3djczadVNmwVQOwHaY8TmFR6anph
	 nLmNCfBztawH/rI5GCf+9W1pU98rNWEryX/XSm4lNqKdYED/vYhiKz0MLTGN2lOshC
	 eA0vpi+xou8Yol/LxIzKYORWaI4OREOLp1wF3PdGdoEcgnABbv2VfR/zuqB7hfAmUO
	 ioZTwHHOv8wBQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Matthew Sakai <msakai@redhat.com>,
	John Garry <john.g.garry@oracle.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.14 578/642] dm vdo: use a short static string for thread name prefix
Date: Mon,  5 May 2025 18:13:14 -0400
Message-Id: <20250505221419.2672473-578-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index a7e32baab4afd..80b6086740225 100644
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

