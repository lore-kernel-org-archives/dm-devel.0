Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF6C17BCE;
	Thu,  3 Oct 2024 01:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727918180; cv=none; b=fCUUtiQt8WdciqBkcFO4O6mFxqjOrqA4BTxbzaNJfKUL+ORuptpI29b3AXPK6OaUhDQ4rw5OywHVmeKVzyjWOFa23xvlkq4N8UKT/+P65OWS0IHba/QLZnXDUJVTYQN/pWvb4DaC4ePKFryjus0gqHK+zpmSKHZwG9vLj32/t0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727918180; c=relaxed/simple;
	bh=qVfQLDLGMSl6jEtK1Mx9+oBBF1tpV7JAUVMDfbCCyFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQmTXez58N7uqBGXyUg7oo5SE1c1QnkD8x+DTI1ntvmOJCmYmp19UiLcMfPbZz0xgcdAlrH67RE9XYDcPP6JiY8S8eBVmyn40Qt1tj0c6BhAz5EiAqcSGh40ZQpC0sQEqavHyVxx6S7VqBA3Pr9Whyg9sPMN+LaoEKSpbY74X70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=SwRkD8cM; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="SwRkD8cM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=T38uohCYX7hSayOdEiQEq9Wgaxht+5HAYWTxt6lFNlI=; b=SwRkD8cMwuCCvj00
	L/GMI0swR8B885UDt3HlXBsKt4UvL0D6CVTvrKUns49xxqx4lul6Gcqk0c0fsFbCDguEw7ZsOJA6J
	lanQo3UUAaEUoSKtIPuCDv2Ra433M/cBXeT0cjn15Onyt0HLmzMPU0yEdA6sBg0N7vF17H8wkfCzS
	2smZN6n2Svbuf6zk/UmFSt8DAZQdrjfQQ000Xlf7BM8ityMfChnjMRdXK8B76yuKOs1wHehjWCJrs
	H9M1jdyl/ywecbaDPdfTSQmB82Eubra4NgYQPx3zIHmaH8iDYzhToTCb8AzcdP6zg1P6aq1/ZPFmb
	1DNftrq4ZvuiHZoMDg==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1swARy-008Zju-0K;
	Thu, 03 Oct 2024 01:16:14 +0000
From: linux@treblig.org
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 9/9] dm vdo: Remove unused uds_compute_index_size
Date: Thu,  3 Oct 2024 02:15:54 +0100
Message-ID: <20241003011554.266654-10-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241003011554.266654-1-linux@treblig.org>
References: <20241003011554.266654-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

uds_compute_index_size() has been unused since it was added in
commit b46d79bdb82a ("dm vdo: add deduplication index storage interface")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/md/dm-vdo/indexer/index-layout.c | 26 ------------------------
 drivers/md/dm-vdo/indexer/indexer.h      |  4 ----
 2 files changed, 30 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 627adc24af3b..af8fab83b0f3 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -248,32 +248,6 @@ static int __must_check compute_sizes(const struct uds_configuration *config,
 	return UDS_SUCCESS;
 }
 
-int uds_compute_index_size(const struct uds_parameters *parameters, u64 *index_size)
-{
-	int result;
-	struct uds_configuration *index_config;
-	struct save_layout_sizes sizes;
-
-	if (index_size == NULL) {
-		vdo_log_error("Missing output size pointer");
-		return -EINVAL;
-	}
-
-	result = uds_make_configuration(parameters, &index_config);
-	if (result != UDS_SUCCESS) {
-		vdo_log_error_strerror(result, "cannot compute index size");
-		return uds_status_to_errno(result);
-	}
-
-	result = compute_sizes(index_config, &sizes);
-	uds_free_configuration(index_config);
-	if (result != UDS_SUCCESS)
-		return uds_status_to_errno(result);
-
-	*index_size = sizes.total_size;
-	return UDS_SUCCESS;
-}
-
 /* Create unique data using the current time and a pseudorandom number. */
 static void create_unique_nonce_data(u8 *buffer)
 {
diff --git a/drivers/md/dm-vdo/indexer/indexer.h b/drivers/md/dm-vdo/indexer/indexer.h
index 3744aaf625b0..183a94eb7e92 100644
--- a/drivers/md/dm-vdo/indexer/indexer.h
+++ b/drivers/md/dm-vdo/indexer/indexer.h
@@ -283,10 +283,6 @@ struct uds_request {
 	enum uds_index_region location;
 };
 
-/* Compute the number of bytes needed to store an index. */
-int __must_check uds_compute_index_size(const struct uds_parameters *parameters,
-					u64 *index_size);
-
 /* A session is required for most index operations. */
 int __must_check uds_create_index_session(struct uds_index_session **session);
 
-- 
2.46.2

