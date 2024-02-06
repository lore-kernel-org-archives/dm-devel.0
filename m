Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFE85675F
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707185067; cv=none; b=FiFD2lTeY8q01iTxmJOO44ct54u+CUNYuDHWPMO1ROFORnDJe93OfF+7SHH0Q+auLSrBJaAj0PLAYell8XI71qk3OdYUU8shCY/OcZOhn/LEl70T+Ml7Os1iGHQyPidfA1qZSaA6l4fP+5xA26t3YAFwtspT7HzzhbfY7leYHW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707185067; c=relaxed/simple;
	bh=QMz9nCGnPyoYGriR7tLD/u/8j7df1eNbdyr4kg/5g2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSuJm80TWmMb2Ok5SqbMjLU+JAPSVgoB/xukJ4pW5u++oHY0uzUCROKkcp5s32Nq3hElKVBxTsJruI+LwCU9sw8tc+dIbrj0C4QaSAKQdMVnUxgw1vJvmXHIKnaU6HYFpWmqMZMFm5ubfaQrUtWt5khrLq5/lu2nvKm8kk52TME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S8XU+nej; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S8XU+nej"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707185064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FPXamWO6dyaLKK0XGPvP4+Jj0w019gpKIhXbvupHH+0=;
	b=S8XU+nejJQ0ftXUtTh9KWh66OEjn5keCWvXPNpFdIvOxOhUm8wgv6nanQjDi77kmJHaBg2
	MLUqx7BbbjsNtib+HKOe/6Y2Yaw0xYoQIJKy3APhl8LnODcb2iOMFzydSWXbSZRALdZ7lY
	zEOw0Xxyr5XzUo3bQIlejHbHtmHjmbg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-IE6NhQUwM1W9yxfnLpvd7Q-1; Mon, 05 Feb 2024 21:04:23 -0500
X-MC-Unique: IE6NhQUwM1W9yxfnLpvd7Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B466785A58C
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF973492BFA;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id AE4CC56A04; Mon,  5 Feb 2024 21:04:22 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Susan LeGendre-McGhee <slegendr@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 7/7] dm vdo: move encoding constants to encodings.h
Date: Mon,  5 Feb 2024 21:04:22 -0500
Message-ID: <6f22c72513105c9bb05c71dc34be57b9c37a5f16.1707184413.git.msakai@redhat.com>
In-Reply-To: <cover.1707184413.git.msakai@redhat.com>
References: <cover.1707184413.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Susan LeGendre-McGhee <slegendr@redhat.com>

Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/constants.h | 12 +++---------
 drivers/md/dm-vdo/encodings.h |  6 ++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-vdo/constants.h b/drivers/md/dm-vdo/constants.h
index 3a997dd7d0b1..24237bc29f87 100644
--- a/drivers/md/dm-vdo/constants.h
+++ b/drivers/md/dm-vdo/constants.h
@@ -44,6 +44,9 @@ enum {
 	/** The default size of each slab journal, in blocks */
 	DEFAULT_VDO_SLAB_JOURNAL_SIZE = 224,
 
+	/** Unit test minimum */
+	MINIMUM_VDO_SLAB_JOURNAL_BLOCKS = 2,
+
 	/*
 	 * The initial size of lbn_operations and pbn_operations, which is based upon the expected
 	 * maximum number of outstanding VIOs. This value was chosen to make it highly unlikely
@@ -90,13 +93,4 @@ enum {
 	VDO_ZERO_BLOCK = 0,
 };
 
-/** The maximum logical space is 4 petabytes, which is 1 terablock. */
-static const block_count_t MAXIMUM_VDO_LOGICAL_BLOCKS = 1024ULL * 1024 * 1024 * 1024;
-
-/** The maximum physical space is 256 terabytes, which is 64 gigablocks. */
-static const block_count_t MAXIMUM_VDO_PHYSICAL_BLOCKS = 1024ULL * 1024 * 1024 * 64;
-
-/** unit test minimum */
-static const block_count_t MINIMUM_VDO_SLAB_JOURNAL_BLOCKS = 2;
-
 #endif /* VDO_CONSTANTS_H */
diff --git a/drivers/md/dm-vdo/encodings.h b/drivers/md/dm-vdo/encodings.h
index 260822a3958a..bfc397a72f9f 100644
--- a/drivers/md/dm-vdo/encodings.h
+++ b/drivers/md/dm-vdo/encodings.h
@@ -609,6 +609,12 @@ struct vdo_config {
 	block_count_t slab_journal_blocks; /* number of slab journal blocks */
 };
 
+/** The maximum logical space is 4 petabytes, which is 1 terablock. */
+static const block_count_t MAXIMUM_VDO_LOGICAL_BLOCKS = 1024ULL * 1024 * 1024 * 1024;
+
+/** The maximum physical space is 256 terabytes, which is 64 gigablocks. */
+static const block_count_t MAXIMUM_VDO_PHYSICAL_BLOCKS = 1024ULL * 1024 * 1024 * 64;
+
 /* This is the structure that captures the vdo fields saved as a super block component. */
 struct vdo_component {
 	enum vdo_state state;
-- 
2.42.0

