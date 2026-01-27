Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC98E35CB9A
	for <dm-devel@lists.linux.dev>; Tue, 27 Jan 2026 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769529049; cv=none; b=BTmx0VqswiSVW+FDgn8S1dVetwzllFsGdo6v8xG/874c6HieIaiHOnS1yM0SUiYYnFxFPC2odixJXwKmO1WNC0QZOFPAMLcZubyLj8AbT/tl0HGEIVcymUKIINBYFGK9wYLcfhXJ46A2ZCN8sW4KpSR/qITgEHIYcizlBWnyFiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769529049; c=relaxed/simple;
	bh=2hYDT+B/4yxohWjlbxyzTTFWub5BB7K/CDfmxqEI4ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=sMSCj8ZpZML8vmeNgJl5mLhGTxlBc3pji8J7/wZAEvAbep96nl1kIZSeEC6uCM5SeW0QC10sDMYf573l0eEQKuLjib9iiQAHZGPmX4BCHwsWTcEYt2C7IYQxqH5bA+XEUMc9zfdocn+ou5Cg9Myz2ik+v2iNfKMbGVcvdxpWOM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AeCOJ1Ce; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AeCOJ1Ce"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769529046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yMP7m/R5nwjJz0j/n5osl14sRnt6hf98jJbrx5kViG0=;
	b=AeCOJ1CewrpvYCWxZb6zOVqRMCtC4fmpt9sK9elRxIaXycrG+VGMTjJ94U1MNpcFRHD0+/
	ywR3AZiEQ0UzG1w66jGrqfyYZ2OAEqyumdz15/Vw8gIpRj0O0uO7S0bPZ655VqBQXsseGS
	ADxCh2ULp3dmHJlpEWg1r3p9GNYhWws=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-442-ycb0ZOAYNCyQ0MueB4P74w-1; Tue,
 27 Jan 2026 10:50:45 -0500
X-MC-Unique: ycb0ZOAYNCyQ0MueB4P74w-1
X-Mimecast-MFC-AGG-ID: ycb0ZOAYNCyQ0MueB4P74w_1769529044
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70A7A19775A5
	for <dm-devel@lists.linux.dev>; Tue, 27 Jan 2026 15:50:44 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 53E55180086E;
	Tue, 27 Jan 2026 15:50:44 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id AB503124FAD; Tue, 27 Jan 2026 10:50:43 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo encodings: clean up header and version functions
Date: Tue, 27 Jan 2026 10:50:43 -0500
Message-ID: <9b0f316824a5fab184b2d215c85a363cd5fb77b3.1769499846.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 32WMOHIdCH-9R-qOsVqaPK6dizld4sti1Q4fJilXEFE_1769529044
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Make several header functions static. Also remove
vdo_is_upgradable_version, which is unused.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/encodings.c | 11 ++++++-----
 drivers/md/dm-vdo/encodings.h | 25 -------------------------
 2 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index dd59691be840..bd60f4b3a0d0 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -172,9 +172,9 @@ static int __must_check validate_version(struct version_number expected_version,
  *         VDO_INCORRECT_COMPONENT if the component ids don't match,
  *         VDO_UNSUPPORTED_VERSION if the versions or sizes don't match.
  */
-int vdo_validate_header(const struct header *expected_header,
-			const struct header *actual_header, bool exact_size,
-			const char *name)
+static int vdo_validate_header(const struct header *expected_header,
+			       const struct header *actual_header,
+			       bool exact_size, const char *name)
 {
 	int result;
 
@@ -210,7 +210,8 @@ static void encode_version_number(u8 *buffer, size_t *offset,
 	*offset += sizeof(packed);
 }
 
-void vdo_encode_header(u8 *buffer, size_t *offset, const struct header *header)
+static void vdo_encode_header(u8 *buffer, size_t *offset,
+			      const struct header *header)
 {
 	struct packed_header packed = vdo_pack_header(header);
 
@@ -228,7 +229,7 @@ static void decode_version_number(u8 *buffer, size_t *offset,
 	*version = vdo_unpack_version_number(packed);
 }
 
-void vdo_decode_header(u8 *buffer, size_t *offset, struct header *header)
+static void vdo_decode_header(u8 *buffer, size_t *offset, struct header *header)
 {
 	struct packed_header packed;
 
diff --git a/drivers/md/dm-vdo/encodings.h b/drivers/md/dm-vdo/encodings.h
index e5ff2b0aaa79..87b7d2f3b545 100644
--- a/drivers/md/dm-vdo/encodings.h
+++ b/drivers/md/dm-vdo/encodings.h
@@ -707,31 +707,6 @@ static inline bool vdo_are_same_version(struct version_number version_a,
 		(version_a.minor_version == version_b.minor_version));
 }
 
-/**
- * vdo_is_upgradable_version() - Check whether an actual version is upgradable to an expected
- *                               version.
- * @expected_version: The expected version.
- * @actual_version: The version being validated.
- *
- * An actual version is upgradable if its major number is expected but its minor number differs,
- * and the expected version's minor number is greater than the actual version's minor number.
- *
- * Return: true if the actual version is upgradable.
- */
-static inline bool vdo_is_upgradable_version(struct version_number expected_version,
-					     struct version_number actual_version)
-{
-	return ((expected_version.major_version == actual_version.major_version) &&
-		(expected_version.minor_version > actual_version.minor_version));
-}
-
-int __must_check vdo_validate_header(const struct header *expected_header,
-				     const struct header *actual_header, bool exact_size,
-				     const char *component_name);
-
-void vdo_encode_header(u8 *buffer, size_t *offset, const struct header *header);
-void vdo_decode_header(u8 *buffer, size_t *offset, struct header *header);
-
 /**
  * vdo_pack_version_number() - Convert a version_number to its packed on-disk representation.
  * @version: The version number to convert.
-- 
2.48.1

