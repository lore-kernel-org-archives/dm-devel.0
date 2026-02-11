Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F3929BD85
	for <dm-devel@lists.linux.dev>; Wed, 11 Feb 2026 15:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770822362; cv=none; b=nd6op0TM26tWSwjyY+GtYSi1qsrOFRAYFwvoy5tXtPge1I1fsFpq6CyGYxslyrqfQMkYYHpSOkBju9L0tdRbgY1G3Miu+y5OdeZJVP7XJE2M/jMjZ1S6zBqQzpMIfUjbnHIQlyPN6cVFMeKEn8SUz9S3eZ/vF85IiaWbTXAfmXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770822362; c=relaxed/simple;
	bh=rcOVMyLTXaBfMWnAYbfKBLtiSxQbejrwQHjlcu/K+08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=nPdnc56MmeAkE3oa+mDyDhRbI8J/15STxWarmSPZGfLrlwE9ekBJKDlBK1BehRZBXVrx81LgHUmYFvLYWa8YvLMIhKnOCWtbb41Tkte5P0MsF3ra/du9Xa040JfeHdyO3AEiBkciydXSFj+qxU/AMo9IZURTDw6HlF86i2jYOo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UuZ+yJDX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UuZ+yJDX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770822360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T8sl7jSSF2UFD0sSqUZdA8PPq1EJ/ykzvWC8k5iPgvM=;
	b=UuZ+yJDX2GYIAyW6LrOVK+w21MkLCIwC019Rhd1XSFhshY64JY49uxv6FzOzovKU6YT8re
	wmGLXoJP8ploHDKI4YA2h8fO8z3KHYg/0VcBt9QI/pDivSAkkw75Lmi4sWNFpoZPkfdsjD
	tZyQ6D7171QXPPjWekyhzjcHD+GhQyg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-uotCAKYXNmyZ4AmEao49lg-1; Wed,
 11 Feb 2026 10:05:58 -0500
X-MC-Unique: uotCAKYXNmyZ4AmEao49lg-1
X-Mimecast-MFC-AGG-ID: uotCAKYXNmyZ4AmEao49lg_1770822357
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D80541955E7C
	for <dm-devel@lists.linux.dev>; Wed, 11 Feb 2026 15:05:56 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BB05419560A3;
	Wed, 11 Feb 2026 15:05:56 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 16D381279DF; Wed, 11 Feb 2026 10:05:56 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/2] dm vdo slab-depot: validate old zone count on load
Date: Wed, 11 Feb 2026 10:05:55 -0500
Message-ID: <7d63ba8eb2f2c14ba61554a34ba963810003c79d.1770818146.git.msakai@redhat.com>
In-Reply-To: <cover.1770818146.git.msakai@redhat.com>
References: <cover.1770818146.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NjOgM845cL1sjC0EMZqA41fOCLP20FtfjSHQRoU3pzI_1770822357
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Verify the old zone count has a valid value before using
it to compute slab summary entry offsets.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/slab-depot.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 034ecaa51f48..ad00afc2c168 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -4262,6 +4262,10 @@ int vdo_decode_slab_depot(struct slab_depot_state_2_0 state, struct vdo *vdo,
 	}
 	slab_size_shift = ilog2(slab_size);
 
+	if (state.zone_count > MAX_VDO_PHYSICAL_ZONES)
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
+					      "invalid zone count");
+
 	result = vdo_allocate_extended(struct slab_depot,
 				       vdo->thread_config.physical_zone_count,
 				       struct block_allocator, __func__, &depot);
-- 
2.48.1

