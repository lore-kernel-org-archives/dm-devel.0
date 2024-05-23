Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E112C47F5D;
	Thu, 23 May 2024 21:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716498365; cv=none; b=kQZEX7P6W0wEmyljoDgn3sHev1lk871prJVkuByxOGxGcD1ohnCPw7DO6gKQbli1geq/FvONouBOD0hcLv60gQoFo4Im1Sj4rGF2EPbH2YahDL64Cd/1BHYewCqkzKnWgGjrdVcjFnJM734NVGUGVGAZjDxAr4PZnvzoI+XnBJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716498365; c=relaxed/simple;
	bh=tLmdHCjnuUDljef5WOT226x1/maTdvREQJpMX8NZ6a0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NG7q2QiISaJZXIM3NmPb2IK4chI7O33VILSpUBLdAqCIM+dbDNjGjL9dDNdnGZukZ1Pd7kzflwalyENQnyu13sBoq7AEduwG868qf63Ap6Syedja4MmDKZVxmV2JMbn8r/ud/CE1GlgH6zYeyUs7QGfMjiy9l2j2B7Z2TD3mlII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Z2nBb5Pl; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Z2nBb5Pl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=GSO2GJxf5LIFsopVNpRkthQze4Dv+1RzRCMhXnyvo0I=; b=Z2nBb5PliQaycAxn
	W1y6YgjA2KNUcu3q2pQITu8VrdVBEDs9AINJP6Wu/UW+kCMjAMFyBUaxkiJLfr1GH0us4J697h6g8
	eKhiVcZDcGstsr+i+KQWSwufWyoca4lqw3kHV6Dde8XGI2NCsyhzgVRt+Hj4pLZeidLI2Ebh4+oxm
	1tlV7MDThmOLz3vgLUYRWuRYe53ZgHiNgmOvSBdyMVODgYcaH2Y0ran0UK9GvjwKNxJi3OQJObhnH
	WdQt1pAKizXGqYhflV1CCrTEZerJ+6Ioe63FN3htfO5ywTlXTCEyZdX/3FeYznE/nEEzpUDN72UI/
	bXoGY20h4AbSCqhKMA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sAFdK-002IRW-0c;
	Thu, 23 May 2024 21:05:54 +0000
From: linux@treblig.org
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] dm cache metadata: remove unused struct 'thunk'
Date: Thu, 23 May 2024 22:05:50 +0100
Message-ID: <20240523210550.309116-1-linux@treblig.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

'thunk' has been unused since
commit f177940a8091 ("dm cache metadata: switch to using the new
cursor api for loading metadata").

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/md/dm-cache-metadata.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 96751cd3d181..0ad9dc1824fa 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1282,15 +1282,6 @@ int dm_cache_insert_mapping(struct dm_cache_metadata *cmd,
 	return r;
 }
 
-struct thunk {
-	load_mapping_fn fn;
-	void *context;
-
-	struct dm_cache_metadata *cmd;
-	bool respect_dirty_flags;
-	bool hints_valid;
-};
-
 static bool policy_unchanged(struct dm_cache_metadata *cmd,
 			     struct dm_cache_policy *policy)
 {
-- 
2.45.1

