Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E16079E4
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 01:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707873868; cv=none; b=ZC60fBIXm6HjM2RmT7fEK1Pof9zq6DVJBB/JHW6mE7TA+aBujdQLQZdpv7xLIC3TDsEEPC0ZIxOHRlx9jNpiOS+1CuGGfZw5Ke5GG82frcZ+oejrN15AHM2rUwh+cltiSQ3zYA+rQA1MBh9QlWb9fA0r6z0GERnC70uBXgq5iYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707873868; c=relaxed/simple;
	bh=OF8vVNzDTXYfxYfgkTScyIWN34EjpcxtuY9WDemVbVI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iwbQv2xfXNpKfnuA6TcgK+9JTuTeuYYElNK/viok5fRZtGxmtzPXB+g+7qxC6G34B/7f4RlYBZfagqHxVGCwRYEnYnX+IbubS1DVOsj+9Omv7cflN9HnFDk3OQftZf2HH6GQgyXHF1CpfU973lsGRhEGY7g8AqgiBIefBcB5dl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dkgq5wRI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dkgq5wRI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707873865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fsqo0GyZFuztPrpoCsAQU2h75rOo+Caj2MpKurdG7po=;
	b=Dkgq5wRIZG+aRHLMKGq/g43jYuF53QIBeTdTK+0T1kduXu+nXqxcVdbuJyD9K2BKUmw5Ix
	QE4blUdLQeJMdy+SRvQn350NTwarUL9vtGE5K1VtikZvstIttf2vddfHCzKLE2devMuR87
	AezGADLRNSEuRgPtnf8wyn9ao6zu6cQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-W7ZxHHLDNtOfabtV_p-GUA-1; Tue,
 13 Feb 2024 20:24:24 -0500
X-MC-Unique: W7ZxHHLDNtOfabtV_p-GUA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E80741C05AB1
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 01:24:23 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D88E31BDD1;
	Wed, 14 Feb 2024 01:24:23 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id D02A357134; Tue, 13 Feb 2024 20:24:23 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Susan LeGendre-McGhee <slegendr@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/2] dm vdo: move encoding constants to encodings.c
Date: Tue, 13 Feb 2024 20:24:22 -0500
Message-ID: <c3fc28d4bbf040549c0c6cf574d729fa5737b937.1707873765.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Susan LeGendre-McGhee <slegendr@redhat.com>

Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/constants.h | 12 +++---------
 drivers/md/dm-vdo/encodings.c |  6 ++++++
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
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index 6b3e9a5b3a91..9e45411fe816 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -15,6 +15,12 @@
 #include "status-codes.h"
 #include "types.h"
 
+/** The maximum logical space is 4 petabytes, which is 1 terablock. */
+static const block_count_t MAXIMUM_VDO_LOGICAL_BLOCKS = 1024ULL * 1024 * 1024 * 1024;
+
+/** The maximum physical space is 256 terabytes, which is 64 gigablocks. */
+static const block_count_t MAXIMUM_VDO_PHYSICAL_BLOCKS = 1024ULL * 1024 * 1024 * 64;
+
 struct geometry_block {
 	char magic_number[VDO_GEOMETRY_MAGIC_NUMBER_SIZE];
 	struct packed_header header;
-- 
2.42.0

