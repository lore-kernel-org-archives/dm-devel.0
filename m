Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB25823D3
	for <dm-devel@lists.linux.dev>; Thu,  8 Feb 2024 18:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707415760; cv=none; b=HgBsMi6sQm675svil/+GUClSauHxGoPf4tmoApCnXEsJaEYKu16FdkNibjgYgyaMYViwffR7AVH+9k+xlWUhVt/5AquZTWITcf72jWkgvSFoLSVrzjQFHFQ8MRrcI70dmN8iOSFhHVqKk7c+iUz3UXoie5NeumCPbZMwM21d+yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707415760; c=relaxed/simple;
	bh=EdwdzC57itIDGKpPJ4w8zo8hAhWs99dMShpnMWuWRws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dCoagXBHpKvOrCRcY17NxoGr859/kWCxFFS/9JcGTvqjy0ARRFxRmAEaiviM7xHmqJarKD8FwHtpsqW9oRTDUdSMdZXfpthPZ6dN+w1IDz1DSKFJ+pf+zm+MM9XIe3SLte2mLd4rr2qswsNb3hEnok/mVBJkPh2iV7o3zPhIM1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OEFtZyWm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OEFtZyWm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707415757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=etMbpSzUFl2iSz5eCskUMzTd4hvQEPI/kjuRSIMTynI=;
	b=OEFtZyWmLn/b9qO+yVL2ND5TCJ6SEhxgQ6+9nScSsM+lMwG+NaYdQUfFuxDCo4H5+6AUb+
	Md0MYQZt0D83WR/ANUXbBhsAWGgAgTwi+TZhlfN7TEbWrCVdOkCqLDwKt8xteu5GZrlxpa
	U/V5ExkamYaPrMESTXLWlQIOhrf0Mbk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-OnrKzz8LM_qUmTD-PMxH0g-1; Thu, 08 Feb 2024 13:09:16 -0500
X-MC-Unique: OnrKzz8LM_qUmTD-PMxH0g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1847D859B85
	for <dm-devel@lists.linux.dev>; Thu,  8 Feb 2024 18:09:16 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D9B4C08EF7;
	Thu,  8 Feb 2024 18:09:16 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 0623156C60; Thu,  8 Feb 2024 13:09:16 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/3] dm vdo: add vdo documentation to device-mapper index
Date: Thu,  8 Feb 2024 13:09:13 -0500
Message-ID: <a53597d94f8bd0dcc8d6d99fbcc87d9af36dce76.1707415327.git.msakai@redhat.com>
In-Reply-To: <cover.1707415327.git.msakai@redhat.com>
References: <cover.1707415327.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 Documentation/admin-guide/device-mapper/index.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
index cde52cc09645..cc5aec861576 100644
--- a/Documentation/admin-guide/device-mapper/index.rst
+++ b/Documentation/admin-guide/device-mapper/index.rst
@@ -34,6 +34,8 @@ Device Mapper
     switch
     thin-provisioning
     unstriped
+    vdo-design
+    vdo
     verity
     writecache
     zero
-- 
2.42.0

