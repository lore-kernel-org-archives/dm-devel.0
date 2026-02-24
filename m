Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC90E1E9906
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 02:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771898934; cv=none; b=kbUpVxs2o5KueUdtYMnh0asDLa1cwr3n0/87ATaDBADuJg8slj3VCy5iC0giyICduQEAD+zYWRyjUGRnbymQcRYHi+wBb7Fr4g+AMRw2FKWVajo1U6Fu49B2oQpDnlxqSHn8uxB4GIdXzaqtDNIOOQaOfoJYEO45SJkQvgBmbFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771898934; c=relaxed/simple;
	bh=rcOVMyLTXaBfMWnAYbfKBLtiSxQbejrwQHjlcu/K+08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Y/bS3NQ8waqJvJ3RYpybGJtr9ddDkauJDdhO2Roa1i73/7y7lXvOoYjicPu6nDFsIXgAHPBr8VOzw1CiDyeY3S9P3HBDelF5UZL8sHvLbvrKSoqbJ602YjNxB5bAuzAhLhJwaQaglaHA6C36m0Fwm0dOzL90LgFtKlEYZTkI5uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e53F4mrx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e53F4mrx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771898932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T8sl7jSSF2UFD0sSqUZdA8PPq1EJ/ykzvWC8k5iPgvM=;
	b=e53F4mrx2a7d6wJUprQcroJ5mxcPCGJ7S0SUG4UXwyIXWoMEG8/TQiYwZV6be8wIp/o3k/
	hBakpgNuuXJrzb74baf4UyQw0h+tIVpXzYCsgOUC9v3J492+r91qlbacYsWY19pub08U7H
	VM6cQ+qvUvd5ZT0dHO54Q7G7AWeoNFE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-uOHyQdVMPKaMUWxYFKK-4w-1; Mon,
 23 Feb 2026 21:08:50 -0500
X-MC-Unique: uOHyQdVMPKaMUWxYFKK-4w-1
X-Mimecast-MFC-AGG-ID: uOHyQdVMPKaMUWxYFKK-4w_1771898929
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79DB11956050
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 02:08:49 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3145D30001BB;
	Tue, 24 Feb 2026 02:08:49 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 8E33D129C87; Mon, 23 Feb 2026 21:08:48 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH v2 2/2] dm vdo slab-depot: validate old zone count on load
Date: Mon, 23 Feb 2026 21:08:48 -0500
Message-ID: <d67d5738f69fdb5fb782cf1cd6b601bdc5a5c14b.1771898188.git.msakai@redhat.com>
In-Reply-To: <cover.1771898188.git.msakai@redhat.com>
References: <cover.1771898188.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ytO2H-WriscidyteSkrnCGlOfTmm5IFFMiXFW5nkhyA_1771898929
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

