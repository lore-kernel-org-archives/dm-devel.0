Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA28B296BD5
	for <dm-devel@lists.linux.dev>; Wed, 11 Feb 2026 15:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770822362; cv=none; b=EzvtGmO0//crgYzkkK1Ydf9TkQXM/ldHgtuDoGyZXoR+QA2TmiZZheYflqerupbwj4aKTyWQEjBhSH/9bGw/bkBZSybsBfyEBiw9YZ81HcytbH68LJf7iTLkli3bq4ub4d6nW4cKTfKtRqaGjxeFT5UOSBcU6qGhsM6q/ZIvArQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770822362; c=relaxed/simple;
	bh=Qk3vrGj8HhD+gfGtG/IYotsQHLJkLQxGW60laBpEZpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=BK/ncQBDhNOvWsMphqa+s4XpbiLoGZyCCbTfV0mwxjmi5OMrsXmOo9CWzUptUqbp+3iV7cl64RzTIicwF2so/Z0MsSuWlUK7MIHJ4RaCZDrI5YFd6XJNS1y1BMey4/B5xR85xXVWM+Wgdot7C3uH3jr/zhwlNfrhEcEImIf3Zt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ELGHJrap; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ELGHJrap"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770822359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Wzu4S1NeXWlbgOzeKakhc0xtq4cu5Jz8dBlhCsf3Qp0=;
	b=ELGHJrapS1YjoZmTsYiDYroSzqVu8BuVXSmCP4ZcrmZiETkjuQ/bryC7+8RWovIeyJJM8v
	PefywG5fP5Zr6sVYGmccK2Q05qKjofrvVgg3CK9F5OFdHB1UcvevCN47y6gT4eGnzuk1/Q
	ZK071s6ib8ujSKEO4GFyom1puqZmxxk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-5Rylbx38OiOveyMFAAqiuw-1; Wed,
 11 Feb 2026 10:05:57 -0500
X-MC-Unique: 5Rylbx38OiOveyMFAAqiuw-1
X-Mimecast-MFC-AGG-ID: 5Rylbx38OiOveyMFAAqiuw_1770822356
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1F491955E7A
	for <dm-devel@lists.linux.dev>; Wed, 11 Feb 2026 15:05:56 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A617030001A8;
	Wed, 11 Feb 2026 15:05:56 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 062A91279DB; Wed, 11 Feb 2026 10:05:56 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/2] dm vdo: additional metadata validation
Date: Wed, 11 Feb 2026 10:05:53 -0500
Message-ID: <cover.1770818146.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xSVnVmdHGVQSt2DpcWWnIYGaIowY_y5qg0GgVJwIlNg_1770822356
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

We identified a few places where dm-vdo uses a value from
storage without sanity-checking that its value makes sense.
Adding additional checks can prevent additional metadata
corruption in the unusual cases where these values get
corrupted.

Matthew Sakai (2):
  dm vdo indexer: validate saved zone count
  dm vdo slab-depot: validate old zone count on load

 drivers/md/dm-vdo/indexer/index-layout.c | 3 +++
 drivers/md/dm-vdo/slab-depot.c           | 4 ++++
 2 files changed, 7 insertions(+)

-- 
2.48.1

