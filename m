Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12C5151CE8
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 15:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709221803; cv=none; b=DqkOp/ZvORGB8HxU7fTz+xuu0i96FEKywhq17fMlp9Ba9StnbIKBBNjunIh9ZleuxE7W1cEAH25FPRAnagAEJXxEkOqhESaWeNwhcOxuQAJ/iINBgRn+hDON2kFcwQ5iBwBGv81O3OcDjgN9UodUP+kpufewJWuCKPVEv77CHN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709221803; c=relaxed/simple;
	bh=6KCzEtTF5WUnU+nH49pMCEZH3yxkZWWwXlBTM3MMiHw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kTLIaYQyrUGZJN3QafOl8Q/JsBwLvPZr0Zx5GMVeDFOADVoFE6VeBJGaCL1yRjH18XRT6KOubUp7tC6K4SdJrkPUFR8kYqX0Yi+E237Pi3nO8DYTUCTu+k/NVxPqQnEjKUp5R/xyTDXDBIhVQObDYkXFu7k2zLUtbl2nFYZqSp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bS662fnm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bS662fnm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709221800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=da+5u9B4hhHOxuNEUVTs2cHeQnZWLj/nJmX2jJGb57A=;
	b=bS662fnmZMHiPegxjNRHCd4T4Pb6r4d3FT+phcp7o1ycBCUxehPZ4qGIuu4nfA2HPew4vr
	y45ur9Q3L8Lz7jP8oBM8vY4n0EsAB3QhW8v/oCunId8BSN3K7Jmz93hmHuguflIC9n+JEs
	jYh7mf9+nysBwszT/Upr54y6wen54Os=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-pOhqcrI_NX25mUPXwc5HbQ-1; Thu, 29 Feb 2024 10:49:56 -0500
X-MC-Unique: pOhqcrI_NX25mUPXwc5HbQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8A3688D284;
	Thu, 29 Feb 2024 15:49:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.8])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 294B1C1D36C;
	Thu, 29 Feb 2024 15:49:51 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 2/6] md: Revert "md: Make sure md_do_sync() will set MD_RECOVERY_DONE"
Date: Thu, 29 Feb 2024 23:49:37 +0800
Message-Id: <20240229154941.99557-3-xni@redhat.com>
In-Reply-To: <20240229154941.99557-1-xni@redhat.com>
References: <20240229154941.99557-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

This reverts commit 82ec0ae59d02e89164b24c0cc8e4e50de78b5fd6.

The root cause is that MD_RECOVERY_WAIT isn't cleared when stopping raid.
The following patch 'Clear MD_RECOVERY_WAIT when stopping dmraid' fixes
this problem.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index db4743ba7f6c..6376b1aad4d9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8792,16 +8792,12 @@ void md_do_sync(struct md_thread *thread)
 	int ret;
 
 	/* just incase thread restarts... */
-	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
+	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_WAIT, &mddev->recovery))
 		return;
-
-	if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
-		goto skip;
-
-	if (test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
-	    !md_is_rdwr(mddev)) {/* never try to sync a read-only array */
+	if (!md_is_rdwr(mddev)) {/* never try to sync a read-only array */
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		goto skip;
+		return;
 	}
 
 	if (mddev_is_clustered(mddev)) {
-- 
2.32.0 (Apple Git-132)

