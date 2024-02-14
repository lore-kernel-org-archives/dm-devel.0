Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB238F47
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 01:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707873869; cv=none; b=eQl0PZQu91vIiYGG8SvmFH0p8zhWKp7OmmWEot9prM3l6U+dAEOX51/8I/7ZllWeQ9Tt4gAr+0Lu1Ysxn7kxcMjF0uu3YP7q+U+RQdQmeKzMgLRumisMoizoDyQPmC5yFayp7QPrv9/i4VyIKdq9XZ35Ef+GJ4MB9rN6+jXC0Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707873869; c=relaxed/simple;
	bh=A1ZMLtkc4CZYBkzDCry0TPPaN1G6dAJsZzudUawd0M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RfP+QVzoZCNRbUlr2bhNLfoBrRdWWBDX3vBOk0CIbWDGImVfxdl2AOQrTIVM39MSLE5fp+xCryPICBB20R0otW/E4kOGXLjrt+3Jj0+qBzT20z/6NXL2KtnyY0eeY9yNJeSzUMse0LjwkCe71A16FmdZ5xyhaXoV14mgiwbysAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UWy0gTT4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UWy0gTT4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707873866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O++COqTvcBluhw4nTuDxosb7zfrdc3oS4K0H99Mrasc=;
	b=UWy0gTT4cVTAC/PpXSaYEzEoTHeUUtGR0GIG7rhLIDRgvsjqxZ82ATXJDVhkzuGEI0S5Rd
	idWDZnsTPKnVlkHGTeW4SQz9WRdCvCcI9NWwhtus1yLqyaQgJ6ryFbo2QczHIz55gXmff6
	fwvuPw2oXCIVtgP/IrXTaIw8sPhJdJ8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-OIBwiY08POq-TG3fMX_BVA-1; Tue, 13 Feb 2024 20:24:24 -0500
X-MC-Unique: OIBwiY08POq-TG3fMX_BVA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E34031025625;
	Wed, 14 Feb 2024 01:24:23 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DE09D492BC9;
	Wed, 14 Feb 2024 01:24:23 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id D39F057136; Tue, 13 Feb 2024 20:24:23 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/2] dm vdo: use #define for NO_CHAPTER and NO_CHAPTER_INDEX_ENTRY
Date: Tue, 13 Feb 2024 20:24:23 -0500
Message-ID: <c87c66f1d8d056b5049ec8d0d15661be0b6d27c6.1707873765.git.msakai@redhat.com>
In-Reply-To: <c3fc28d4bbf040549c0c6cf574d729fa5737b937.1707873765.git.msakai@redhat.com>
References: <c3fc28d4bbf040549c0c6cf574d729fa5737b937.1707873765.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Avoids unconventional use of 'static const' and enum in headers.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/chapter-index.h | 6 ++----
 drivers/md/dm-vdo/volume-index.h  | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-vdo/chapter-index.h b/drivers/md/dm-vdo/chapter-index.h
index e1bc7e31a2a5..be8bf2b675b1 100644
--- a/drivers/md/dm-vdo/chapter-index.h
+++ b/drivers/md/dm-vdo/chapter-index.h
@@ -18,10 +18,8 @@
  * is more efficient. Both types of chapter index are implemented with a delta index.
  */
 
-enum {
-	/* The value returned when no entry is found in the chapter index. */
-	NO_CHAPTER_INDEX_ENTRY = U16_MAX,
-};
+/* The value returned when no entry is found in the chapter index. */
+#define NO_CHAPTER_INDEX_ENTRY U16_MAX
 
 struct open_chapter_index {
 	const struct index_geometry *geometry;
diff --git a/drivers/md/dm-vdo/volume-index.h b/drivers/md/dm-vdo/volume-index.h
index 0f08acf29435..537e9947cf4a 100644
--- a/drivers/md/dm-vdo/volume-index.h
+++ b/drivers/md/dm-vdo/volume-index.h
@@ -26,7 +26,7 @@
  * managed with volume_index_record structures.
  */
 
-static const u64 NO_CHAPTER = U64_MAX;
+#define NO_CHAPTER U64_MAX
 
 struct volume_index_stats {
 	/* Nanoseconds spent rebalancing */
-- 
2.42.0

