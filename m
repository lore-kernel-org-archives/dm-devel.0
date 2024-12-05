Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE92619066E
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 03:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733371008; cv=none; b=j+EV8qGzWvJhqxfC3/8YsRjhymSLuFmTiJCQBqQrWmycKU2NwlMuZTiOMOXhDRviYEqzaiZaoQfIC9ftQu5o7i0F0a/0AlSC5E0bKr/4+wVEQD5dGabRx9vCJ8j4h0tbTc0fGn4LgUYw4PW9+NInIYevVo5z7xA+UIubPDJTBAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733371008; c=relaxed/simple;
	bh=UgePODdI2JgeB2hoyJr1lHHQSDCJDmfiNA4uyrKFkdM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=WttNSe1KJ42kFPh4HVnOiwfT7AZl6NR6mm1IfB4c0BaH5H2CMTeOq2geWWsqyCd3PRo0s53l3vZ8ZDr27pfv0FByGydluwOyzTK+DO6jG1wOtlZ7vS29EGKtsZrFKVmpcVlgRlU2zjVL4byF0/0mbLXSoPTmWdBIOJAfLWAK78M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SsOCDWW8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SsOCDWW8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733371004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XRE5UdCwkrdO/6NQHkVIPfKkQCPdzHFvn93lz2WGv1k=;
	b=SsOCDWW8m41Z7h+G9I2tEmj8+aQb1x6XvH/zODmASrvKHyiyJWGCjef3R/s26F7Her8ZOe
	vgHj/LsQIUF21lk1jQhE6ZS8GSVGm9JmAHiVWQm1w6VyC/zPZLxIojjiCNO7Cqvmkl69eN
	MYt3lhnyytYqlFdJjwBSumGGL9+2G3o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-573-ntGConSuO0KcZeaXGLW8uw-1; Wed,
 04 Dec 2024 22:56:41 -0500
X-MC-Unique: ntGConSuO0KcZeaXGLW8uw-1
X-Mimecast-MFC-AGG-ID: ntGConSuO0KcZeaXGLW8uw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D7C7195608C;
	Thu,  5 Dec 2024 03:56:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E00231954201;
	Thu,  5 Dec 2024 03:56:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4B53ucsj1218965
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Dec 2024 22:56:38 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4B53ucWb1218964;
	Wed, 4 Dec 2024 22:56:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/3] handle maps that need reloading
Date: Wed,  4 Dec 2024 22:56:35 -0500
Message-ID: <20241205035638.1218953-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ap9HJiOOvwAz6mDmgdgTsRMK33VjjUsISrcBkJe87iw_1733371000
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patchset comes out of my review of Martin's 01ec4fa ("multipathd:
reload maps in do_sync_mpp() if necessary") patch to deal with 

https://github.com/opensvc/multipath-tools/issues/105

I noticed some unrelated issues while reviewing it. Also, Patch 0002 is
a slightly different version of Martin's 01ec4fa patch.

Benjamin Marzinski (3):
  libmultipath: Don't skip set_path_max_sectors_kb()
  multipathd: reload maps in checkerloop() if necessary.
  multipathd: Don't call select_action in reload_map

 libmultipath/structs_vec.c | 3 +--
 multipathd/cli_handlers.c  | 1 +
 multipathd/main.c          | 7 +++++--
 3 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.46.2

