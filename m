Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174292E648
	for <dm-devel@lists.linux.dev>; Thu,  7 Mar 2024 22:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709851333; cv=none; b=YKxBa9Mlcv+31UXZbDD5awDRSwRJZ/Bj3kZg250+ULXB0j6UGZNx3yLe9WsfAx6Y9mtSkMt3diW5kXpt2fbtlq1b4qx3MdeAzQ83o4wStYVWdlmdkI3HlSKnoyTtbk0pGBt8033jybil5+ndM6c4cdtCgZ/v4YHAC9Ssc9vygnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709851333; c=relaxed/simple;
	bh=ywBGcs/Xzhrdf03COrm1Tb09gutJjkaanTrdA4vqvoE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=M41P/rX5LoB/FkkoT4o3Ahe9YiME+d9KaHtDdY+Ji1P8CYSBZOfHIizwYRb47AVLD8OEccwuDOz1OGQA1+NVhzT4EnfPnfsO4h5X5bjBfLzy7VER6/wZi0d/NfCPWN5jb3qob1BI3llJYQBegU69BGsdgKklpUPCwQTGmROBDV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dKaKKgFE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dKaKKgFE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709851331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8Ou4XxDmFGVaYaQXCv4OSiXBL9RouOY+0ozhwhyXMbk=;
	b=dKaKKgFEl6HVzrYIIfiYd8XxfVR68FnmRA/Eicher09E3Yzm6g84gTLK+8BEgFiwtaEEVY
	MFIWzWZSxka/wP8zHIhy9+MvvGlV2E4fSg7l3VdyOUS8UZEUTGpxePdqxI5sokcon84cyc
	k3MfkrXzwlxQ+ur8ndq6304X/GzagWc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-f6FdmzFzOqWZE_O5ALNQiw-1; Thu, 07 Mar 2024 17:42:09 -0500
X-MC-Unique: f6FdmzFzOqWZE_O5ALNQiw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C37A380F7E7
	for <dm-devel@lists.linux.dev>; Thu,  7 Mar 2024 22:42:08 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BDCF710E4F;
	Thu,  7 Mar 2024 22:42:08 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id AC152A2CEC; Thu,  7 Mar 2024 17:42:08 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo doc: document metadata size
Date: Thu,  7 Mar 2024 17:42:08 -0500
Message-ID: <9a8f119dfffac40f416dee63cbbb9778ed8e4a26.1709851277.git.msakai@redhat.com>
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

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 Documentation/admin-guide/device-mapper/vdo.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/vdo.rst b/Documentation/admin-guide/device-mapper/vdo.rst
index a3572582ead8..7e1ecafdf91e 100644
--- a/Documentation/admin-guide/device-mapper/vdo.rst
+++ b/Documentation/admin-guide/device-mapper/vdo.rst
@@ -34,6 +34,17 @@ The repo also contains additional userspace tools which can be used to
 inspect a vdo target's on-disk metadata. Fortunately, these tools are
 rarely needed except by dm-vdo developers.
 
+Metadata requirements
+=====================
+
+Each vdo volume reserves 3GB of space for metadata, or more depending on
+its configuration. It is helpful to check that the space saved by
+deduplication and compression is not cancelled out by the metadata
+requirements. An estimation of the space saved for a specific dataset can
+be computed with the vdo estimator tool, which is available at:
+
+https://github.com/dm-vdo/vdoestimator/
+
 Target interface
 ================
 
-- 
2.42.0

