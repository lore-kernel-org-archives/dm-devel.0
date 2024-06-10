Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6904614BF8D
	for <dm-devel@lists.linux.dev>; Mon, 10 Jun 2024 15:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718032797; cv=none; b=lmMJf0dIQfz+wK7r4mQbl/WByZENc/gRWpTs8B7lhtrbOIu2HG4vvHSkLWf/UQoRRb4c3JNdKuraeDDTaj7pOTDMa93jOc/K1buMttcKjCxzqaa98bylCdXF51V34xngCzqW5oIayXcuW/LV6gG5HtkH/1iyoBpKOWU31IkvUfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718032797; c=relaxed/simple;
	bh=wAF34Zi1LFHX6Ik8FsgA8LCHId0PKJGE9/wnLp55dqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u/fa5KvLB4AdztrX4/Oi4TagUhDjCJPw6QhBYhhYJn3oJ8Q0Hitrts5HABaAm/cER1HCFX8mLrMXeodHtHlf1uJkCqvANPv/odRP+iufXDi7MqXn2PZHfH7D4evfhGfKH0r+0GM962iKF/fvbl4slpLwuETG2NtQ0n6FI4Pw0Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QazNPOjA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QazNPOjA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718032794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=u+t1RGzLHXD/FS2BlkuWtb9S3qfW43882K8qBsnwWgc=;
	b=QazNPOjAFViHKnKuNb7rxN3aY5Qh8KLsW/BfEPTpO7nxoxl0lawNYp1SPZFw2TLScNj4pH
	rypAe1hjoSacMaxOAxU4ChvKFFnKCSetUw20NTJXQxOAk2/AOPfgcNw/iUWgkDwea+nhfA
	07efEmPMZuAxOyNfTqPLFd3nskfU35Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-637-9ncncSahNH6dn5xEbxF3XQ-1; Mon,
 10 Jun 2024 11:19:52 -0400
X-MC-Unique: 9ncncSahNH6dn5xEbxF3XQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CAA3119560B2
	for <dm-devel@lists.linux.dev>; Mon, 10 Jun 2024 15:19:51 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 50DD519560B0;
	Mon, 10 Jun 2024 15:19:49 +0000 (UTC)
From: heinzm@redhat.com
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	bmarzins@redhat.com
Subject: [PATCH 0/2] dm raid: fix stripe adding reshape size issues
Date: Mon, 10 Jun 2024 17:19:46 +0200
Message-ID: <cover.1718031649.git.heinzm@redhat.com>
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

From: Heinz Mauelshagen <heinzm@redhat.com>

Adding stripes to an existing RAID mapped device fails to set
the grown capacity properly.  The 2 patches move a needed function
and add fix the sizing logic.  See patch 2 header for issue details.


Heinz Mauelshagen (2):
  dm raid: move _get_reshape_sectors() as prerequisite to fixing reshape size issues
  dm raid: fix stripes adding reshape size issues

 drivers/md/dm-raid.c | 54 ++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 20 deletions(-)

-- 
2.45.2

