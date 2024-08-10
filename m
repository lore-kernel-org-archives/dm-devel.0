Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30081EEB3
	for <dm-devel@lists.linux.dev>; Sat, 10 Aug 2024 02:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723258071; cv=none; b=RfZULDg+Tjs3XztcovrYBxfXTMKcxBUJkhkkOJLjyy+S528GjEE3sTCojKyyoV89TyUSj9X/TqHPkFOSZ5CHB4fEJ2WAxr8aARv3m9yDLiw04RLMxrnaXhkqTACViy/i29kVhS23vap+uPobz96S7Mrn6cPF8ZBzE9yFB4bGAhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723258071; c=relaxed/simple;
	bh=LA0Gs1SUEUZBJ/EPk7GNBz00iKYCRAB1ZnDwTw7o4o4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uYAz+iMqFAlBsaSMotYqj7zAlyun5/R9DLUbIfWHlOpSvvGAR2koTLtM2S8KJsloCLVgQgLuDha8bsGSvteR/uECR2g9gkt6ohB4XFMdS76hRzi1MdxSQy8gURfcpOcydHSo47LjjR50qW7P+SFTbQEOG6HJTK1P7WtkfZyElTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RUWtRp6Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RUWtRp6Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723258068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kRjeOLaxHa2eIyhVPLM1ifmHBxFk56RePntDN+smUwY=;
	b=RUWtRp6ZGwRME1ve06nIQ5o16yT0mnIEJ1BeasEwId85R53gl+YpfTcAwsK2APhp7+K9d7
	sY6HmQXkizEbkhIG5LzFKzdEz+XyKgpj6LvEk/j+jBVFhwm4bx4OvmX/LMDvQ4VvZ8UMiD
	P9ZhBLS004jIhVWRGaVmsZPYWJBi58M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-43-m40hp7XuMomLyEqkZWjcqA-1; Fri,
 09 Aug 2024 22:47:44 -0400
X-MC-Unique: m40hp7XuMomLyEqkZWjcqA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33DA019560AB
	for <dm-devel@lists.linux.dev>; Sat, 10 Aug 2024 02:47:44 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E62F31955E89;
	Sat, 10 Aug 2024 02:47:43 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 416865475E; Fri,  9 Aug 2024 22:47:43 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/2] dm vdo recovery: improve old journal format handling
Date: Fri,  9 Aug 2024 22:47:41 -0400
Message-ID: <cover.1723249375.git.msakai@redhat.com>
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

Some older out-of-tree versions of vdo use a format for recovery
journal entries that cannot be processed by the current recovery
code. For vdo volumes created with these older versions, reduce
the likelihood of entering read-only mode.

This will ease the transition of older volumes to the in-kernel
dm-vdo target.

Susan LeGendre-McGhee (2):
  dm vdo: abort loading dirty VDO with the old recovery journal format
  dm vdo: force read-only mode for a corrupt recovery journal

 drivers/md/dm-vdo/dm-vdo-target.c | 24 +++++++++++++++++-
 drivers/md/dm-vdo/repair.c        | 41 +++++++++++++++++--------------
 drivers/md/dm-vdo/status-codes.c  |  2 +-
 drivers/md/dm-vdo/status-codes.h  |  2 +-
 4 files changed, 47 insertions(+), 22 deletions(-)

-- 
2.45.2

