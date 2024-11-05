Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024A01FC3
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 00:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730765942; cv=none; b=XzjUmObbSyScLtr4W9XXFV47D9MWraJHebvG3EIpk9SAD02BNAcikaXj3rfbs++PhK0ap/rK9FyZ3CKBRAxhfS+yr9fqWXAhC/UlifWdRL1Tmgo4DOyXMElYw6B289Kvz7sbxjY6sApfUxs9uL3di9FginJS216TewhH8U3oiA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730765942; c=relaxed/simple;
	bh=hgP6/LdnAqik2c1PnTOV9R39vDIKKJmEbvwW+ww0jf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nuDOuaTGpsGCqvKXf02S7lWOHRX9hTjpkGpQ3KOOu121vae6/IMX0Eci08ry5tSNrde5/fUubOiFjRx1QbXuks+d9xdn4ePczxD0TWm1kTYnuGk6o1ujEn1LFXW0qrZH3hQoBUlN0t06rpN2KGyQPIs16tVMXPXWgG71GU9pqDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gP9+UsRY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gP9+UsRY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730765939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qz7Wx/v506K7+c7Xt4ADaW5De69dcrbj9iL0ItQiBAQ=;
	b=gP9+UsRYTtoN+wjh+wSXf7KH+jRiusPWCOeWEMFZKxmtzcUImb+OuTBqrp+HLB+h80wetT
	ZPmIM1GuyUJK63Lbpvj8LcSR6kDhvicMna+lccjLDE03ObLruUhAeofpE8Obo2Vp95DqV3
	j1tQt63hJJ1SrUMn0GTQqYMI//qnM+Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-492-FR1DHoQ2Mc2ua3kAYW_I-g-1; Mon,
 04 Nov 2024 19:18:58 -0500
X-MC-Unique: FR1DHoQ2Mc2ua3kAYW_I-g-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3109195608C
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 00:18:57 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7A6D319560AD;
	Tue,  5 Nov 2024 00:18:57 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id E73D559E5E; Mon,  4 Nov 2024 19:18:56 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Susan LeGendre-McGhee <slegendr@redhat.con>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm-vdo murmurhash: remove u64 alignment requirement
Date: Mon,  4 Nov 2024 19:18:56 -0500
Message-ID: <20241105001856.866095-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Susan LeGendre-McGhee <slegendr@redhat.con>

Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/murmurhash3.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-vdo/murmurhash3.c b/drivers/md/dm-vdo/murmurhash3.c
index 3a989efae142..ec9fc992441c 100644
--- a/drivers/md/dm-vdo/murmurhash3.c
+++ b/drivers/md/dm-vdo/murmurhash3.c
@@ -44,14 +44,11 @@ void murmurhash3_128(const void *key, const int len, const u32 seed, void *out)
 	u64 *hash_out = out;
 
 	/* body */
-
-	const u64 *blocks = (const u64 *)(data);
-
 	int i;
 
 	for (i = 0; i < nblocks; i++) {
-		u64 k1 = get_unaligned_le64(&blocks[i * 2]);
-		u64 k2 = get_unaligned_le64(&blocks[i * 2 + 1]);
+		u64 k1 = get_unaligned_le64(&data[i * 16]);
+		u64 k2 = get_unaligned_le64(&data[i * 16 + 8]);
 
 		k1 *= c1;
 		k1 = ROTL64(k1, 31);
-- 
2.45.2

