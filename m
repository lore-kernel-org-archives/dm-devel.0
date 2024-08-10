Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78515130E4A
	for <dm-devel@lists.linux.dev>; Sat, 10 Aug 2024 02:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723257815; cv=none; b=aCG28hXa76RPaGQ8bPFNUpbAxmt6xSTAU8wcbj7kDis70yefqjM9t68IfHiFI5BtitRCTvpQ2duyUJ/Rssp0EtyIiAIcBD3l0ArPGlDp1D0mrHoMsboeaA1JWELTGE1nHQDBeYUNY4eVciWJfHbKdkoLj/sVbV7Lhz+XyQiyTJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723257815; c=relaxed/simple;
	bh=axlLSDS/OKXzRrVPUh9T8X8fsIA68yEUtQA8sYIhefw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=d3pjvxEGbtUtSu1McCKRVpVpZK4UrGgU+EwC2jeUA/2mV2ZEfOVzSh30f2YbHp1yleNV6Nx2hiLK23qYQPVEfbRTHD7olUK/GDK1WzHx3Q1fuiKDTgWE+gpyzDQPh68RV4NUlnj81Zh8EplWPR2XPf6xcgEG5gooT/EhqPfKH8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ga9Xf0tL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ga9Xf0tL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723257811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TPWn90uvaOK6GNgBH8FzvTsMCQwN2zsZ8Au1dgOPIwA=;
	b=ga9Xf0tLudf/71JN3++YdEnj2mInTdcg0TH1OkE2TiEeIDse5nnttCpv5a0mROatYo1cA4
	407nplkv4JjCxoAtPeohsrhlv5KQEtK9LgKOTaCzqM4kTekWE3Lk8/8RhpJIE0U+VGAa6x
	u36/BpmjGa/0NEKYoHoMMBFNcfqnvwk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-yp9JvfpeO_2E3SDbBcy1sA-1; Fri,
 09 Aug 2024 22:43:29 -0400
X-MC-Unique: yp9JvfpeO_2E3SDbBcy1sA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E27A61955BC1
	for <dm-devel@lists.linux.dev>; Sat, 10 Aug 2024 02:43:28 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 627A01955F2C;
	Sat, 10 Aug 2024 02:43:28 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 82ECE54759; Fri,  9 Aug 2024 22:43:27 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: remove bad check of bi_next field
Date: Fri,  9 Aug 2024 22:43:27 -0400
Message-ID: <fe3d5a890a62e34c576bb579d3ef5df3c34d4b0f.1723248995.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Ken Raeburn <raeburn@redhat.com>

Remove this check to prevent spurious warning messages due to
the behavior of other storage layers. This check was intended
to make sure dm-vdo does not chain metadata bios together.
However, vdo has no control over underlying storage layers,
so the assertion is not always true.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/io-submitter.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 9a3716bb3c05..ab62abe18827 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -346,7 +346,6 @@ void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 
 
 	VDO_ASSERT_LOG_ONLY(!code->quiescent, "I/O not allowed in state %s", code->name);
-	VDO_ASSERT_LOG_ONLY(vio->bio->bi_next == NULL, "metadata bio has no next bio");
 
 	vdo_reset_completion(completion);
 	completion->error_handler = error_handler;
-- 
2.45.2

