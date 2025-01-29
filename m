Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E141B87C9
	for <dm-devel@lists.linux.dev>; Wed, 29 Jan 2025 23:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738193238; cv=none; b=hiWhYi/wDUrjewwFyin6oB/4SvdFEORawsxB2o+ZNbD16kiJhz2VMCHxX1PfCrU0kh0c4ylQ6ff7DX6/7vMh1wQo3OePJQyMaa33TNEJvc0ZN55floRIysUWnKwNvE2kiRQJK0+3v3TXaTilQ4Zx8hBgbci0S1RtFwvRsH/M0lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738193238; c=relaxed/simple;
	bh=yTgySz8oQcTvXEXXZVt2zLZ1VEB/wz4gK8R12Z31ic4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qVd1ztOWV6Y7AX2dujg0PsR0S6d+99bQ8c2hUX6/kuAOlE8gaqQmKrqvjpBI8j5rRY/J+4m5P1f89K3yHWspD93Npy6IU3bsfdlDUvbDDOoG3bJghgPBvz3KE0WsTdXgVasr3MbGlm2e0bQKI8v3/32vWPBNn7QRyNDeU7qRF+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Duu/dwJ4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Duu/dwJ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738193235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=s/MuxfcEfHYDrJP5hPew2dC9ZKjTbw1+8ciDe13n0gw=;
	b=Duu/dwJ4Xz0+4dQtPh/VuMT1jwyhIGl2nTWH3+vvKFbKF9BaVnj9tFPHSZPSeMYoz8YFKV
	Saq8v1Subzmy6UAt1LhvH+fe6zOLOP3SB0i5FxweMrTjpCssoMUEtsLy1hD+T0H4k6bA35
	uxi0WUiFv/ydsF1clT0rayEEYPn8Uz8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-611-Y0cSka9kOBS1vuQLkP59Lg-1; Wed,
 29 Jan 2025 18:27:14 -0500
X-MC-Unique: Y0cSka9kOBS1vuQLkP59Lg-1
X-Mimecast-MFC-AGG-ID: Y0cSka9kOBS1vuQLkP59Lg
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A21C91801F0F
	for <dm-devel@lists.linux.dev>; Wed, 29 Jan 2025 23:27:13 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 804BB1800352;
	Wed, 29 Jan 2025 23:27:13 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id D01B45F0CC; Wed, 29 Jan 2025 18:27:12 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Chung Chung <cchung@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo indexer: prevent unterminated string warning
Date: Wed, 29 Jan 2025 18:27:12 -0500
Message-ID: <8694ea5954b4f1018d69099bb7522228f3d46bef.1738192369.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jbDU9VUVT9z4_klFAu7uM5HhS_T6HzXNP2GXYFuBMvE_1738193233
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chung Chung <cchung@redhat.com>

Fix array initialization that triggers a warning:

error: initializer-string for array of ‘unsigned char’ is too long
 [-Werror=unterminated-string-initialization]

Signed-off-by: Chung Chung <cchung@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/index-layout.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 627adc24af3b..053b7845d1f3 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -54,7 +54,6 @@
  * Each save also has a unique nonce.
  */
 
-#define MAGIC_SIZE 32
 #define NONCE_INFO_SIZE 32
 #define MAX_SAVES 2
 
@@ -98,9 +97,11 @@ enum region_type {
 #define SUPER_VERSION_CURRENT 3
 #define SUPER_VERSION_MAXIMUM 7
 
-static const u8 LAYOUT_MAGIC[MAGIC_SIZE] = "*ALBIREO*SINGLE*FILE*LAYOUT*001*";
+static const u8 LAYOUT_MAGIC[] = "*ALBIREO*SINGLE*FILE*LAYOUT*001*";
 static const u64 REGION_MAGIC = 0x416c6252676e3031; /* 'AlbRgn01' */
 
+#define MAGIC_SIZE (sizeof(LAYOUT_MAGIC) - 1)
+
 struct region_header {
 	u64 magic;
 	u64 region_blocks;
-- 
2.45.2

