Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C3AF12BF2D
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 22:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654248; cv=none; b=so3UDNNflg0nReSypVpfeXutHfNo2ihmimCBWNkpqP7v9Zr7ROn/zMNjlocpQtkOHof+9kxXTZCXcbghwSsMNuyhbIxtFR5dabCUFpSwzv1nUfHHiMR6r9pDboKywaZrsSfZhx+312O9pEV/cGjrAXtxtzMAXvWlv9k3Csf2UzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654248; c=relaxed/simple;
	bh=e+4lAQRk+1sqWv+mWddB1VL2xD4FFXo+2TSqecsvggQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=mbJ2xp3R4tLTQ2yDW/IFvWNiKUxAySASaJE8htnKr1K7b8RokjAALt/dklEemX477vlXCQD12kaTuJ8YrHjR+ZhQn9eM0jr15LxrJq7W5e5mBzP1MEAS8qzYa9Bp9JzLFCXXWFcuh2P/yuUMn/B1ip+YKNYt6MWefi2AiLCnvOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Rh9EW82U; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Rh9EW82U"
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 9987720B2015; Tue, 30 Jan 2024 14:37:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9987720B2015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1706654242;
	bh=Bn8u6PAyziVes0s1hsHk4jpq4JCxu5y2joWk5Bg0G+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rh9EW82UHPEc63gzo6A71jZ0RXefXsNEOrBrjIzHQOH6O3ROai3DR6IzwuFsQS52P
	 d4VHrYnGT+n1wBbLsv7kWO69RcAyb6EztZUaAOv5rjr2HGBB6y4cCyX8SHskPEzgSY
	 jtE6s7yVHZGWgBIbuhej61FM7JlaTjOKe10n4Bw0=
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net,
	zohar@linux.ibm.com,
	jmorris@namei.org,
	serge@hallyn.com,
	tytso@mit.edu,
	ebiggers@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	eparis@redhat.com,
	paul@paul-moore.com
Cc: linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v12 12/20] dm verity: set DM_TARGET_SINGLETON feature flag
Date: Tue, 30 Jan 2024 14:37:00 -0800
Message-Id: <1706654228-17180-13-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
References: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The device-mapper has a flag to mark targets as singleton, which is a
required flag for immutable targets. Without this flag, multiple
dm-verity targets can be added to a mapped device, which has no
practical use cases and will let dm_table_get_immutable_target return
NULL. This patch adds the missing flag, restricting only one
dm-verity target per mapped device.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v1-v10:
  + Not present

v11:
  + Introduced

v12:
  + No changes
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 14e58ae70521..66a850c02be4 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1507,7 +1507,7 @@ int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned i
 
 static struct target_type verity_target = {
 	.name		= "verity",
-	.features	= DM_TARGET_IMMUTABLE,
+	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
 	.version	= {1, 9, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
-- 
2.43.0

