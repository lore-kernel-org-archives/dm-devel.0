Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E4C1A08BA
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 19:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721156775; cv=none; b=m5X423P+X+YWTWPv4ZezQ0ITIPZr0el7bBqjXOIm57yAsRg/cCBl2vxGg9zDzv/NPE8HbjrWti2SFo/dakYTMU/OhlVciaWa124s3xMhJw10NgY6BFQsU0801PpSWBeev+tmfD3RedyIxRT+Wj5Osxg4o+yL2hOM6RWY2cqOxuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721156775; c=relaxed/simple;
	bh=11fZQYk/Z6aZjRL4hzUQnHGMS6sYDv1nVgHvGWNoqEA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ciyMelc3DamM90CwGPJm3iLTWkuigEI3fJg8MHfX/j6wB5OK+gzvAQS1auIfF5zbvOV0Y85fZtgGemw4S+bXrQMwOZGoga0zGRUIRM6bzWU6XTsIwsRXzU3a/71vppdsQxdV9zIeFT+4l97T54aU/0iS1MQLOCy8U64YvXRLB40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XttId6qG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XttId6qG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721156772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bJgQhaW5+IycJFO5ovXm1nnSfl18aJL/FJgIpBoh1Ps=;
	b=XttId6qGTt+6nSi3QpU2a3eKMThhxE/FEpayS2PsgtCz9Grcb93wcKLOeOo9qT1/ecFSMU
	UjGTZBy5/j1+WCgyqHTbMcS6NhYbAmv5sGNjHs/USumckVIlqhGIKKJnHEOAm2mzCEBtL2
	H1Yl5a85Qm7K4HtfMVNcnidKo459cyI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-142-XrvQSwDfNYCjx0d0wdGyyw-1; Tue,
 16 Jul 2024 15:06:10 -0400
X-MC-Unique: XrvQSwDfNYCjx0d0wdGyyw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1AB2195608A
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 19:06:09 +0000 (UTC)
Received: from dev64.localdomain.com (unknown [10.64.240.88])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C76E19560B2;
	Tue, 16 Jul 2024 19:06:08 +0000 (UTC)
From: Masatake YAMATO <yamato@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH] dm vdo: fix a minor formatting issue in vdo.rst
Date: Wed, 17 Jul 2024 04:05:59 +0900
Message-ID: <20240716190559.2346663-1-yamato@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 Documentation/admin-guide/device-mapper/vdo.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/admin-guide/device-mapper/vdo.rst b/Documentation/admin-guide/device-mapper/vdo.rst
index 7e1ecafdf91e..c69ac186863a 100644
--- a/Documentation/admin-guide/device-mapper/vdo.rst
+++ b/Documentation/admin-guide/device-mapper/vdo.rst
@@ -241,6 +241,7 @@ Messages
 All vdo devices accept messages in the form:
 
 ::
+
         dmsetup message <target-name> 0 <message-name> <message-parameters>
 
 The messages are:
-- 
2.45.2

