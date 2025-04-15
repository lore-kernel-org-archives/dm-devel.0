Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0111FAD21
	for <dm-devel@lists.linux.dev>; Tue, 15 Apr 2025 04:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744690644; cv=none; b=loPpe2KUEbptj/lpoH/KcrZRlzLlGNz9emr5cSR1SnXw+VQ4ZhoLx7+yJd+zxlgxDN6u7hW6ZEi4bUXORk1X4l0HkblpJXIrpMsAylrWcDx3DRe39eQ7N6CR/x4Q5og9tqAEN5MxlxD3V4n+AufiswmTarl7aP/L+Hbjh+En7Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744690644; c=relaxed/simple;
	bh=olc72hZZSkvxm6AOPZGPdQtTugoBJvKpR1J1nYjTeEc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=ec4hUzhJQtM4pJ0Rq/U6tHxh+loOyDXNviNFoQ3zDcP+dt/FUTvW+QFgTltR69ipQZ2TvRR/C+gZqVZp9dO6nYPtuAwQELa3u5I2WIK+RiPyFe7AsUs7DcNqii/OTTDgPT593ECVXUMmLMrdFmYQoSVlUCoxdX7GKV7OckV9Zfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UvmSMxbd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UvmSMxbd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744690641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Wq2eqZD8aP7uI1NHhsufBYQWs+xQDEFXX7N0mwB4W60=;
	b=UvmSMxbdAxbCF0pBIfiAemG0VvA9ZSApZ7Z/15WvFc6Wj9M6pQAVl0sjOkfQ3D5ojGa5J6
	+KBZAQrmHJUdJwIDDA+0MIB6BTzhG3uQIeTpryAvxCrYaoOaXOCPjM49Jl8YJ6gNTwZJ3a
	FlqmTLiKRsK7sDlvdK/3JzjAoIrPAeE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-301-wCz6ckCaPBGBe09pgn5pbw-1; Tue,
 15 Apr 2025 00:17:20 -0400
X-MC-Unique: wCz6ckCaPBGBe09pgn5pbw-1
X-Mimecast-MFC-AGG-ID: wCz6ckCaPBGBe09pgn5pbw_1744690639
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DF2119560BB
	for <dm-devel@lists.linux.dev>; Tue, 15 Apr 2025 04:17:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A80B819560AD;
	Tue, 15 Apr 2025 04:17:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53F4HH2X657019
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Apr 2025 00:17:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53F4HGfc657018;
	Tue, 15 Apr 2025 00:17:16 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 0/2] Minor DM fixes
Date: Tue, 15 Apr 2025 00:17:14 -0400
Message-ID: <20250415041716.657008-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1vZz8VnrvC5rjnO66VPExFryCwRwi8vFDtfDMfhH_yI_1744690639
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The first patch is a repost of a patch I posted almost a year ago. I
think it must have fallen through the cracks somehow.

https://lore.kernel.org/all/20240515184832.121949-1-bmarzins@redhat.com/

The second in an unrelated fix for realloc_argv()

Benjamin Marzinski (2):
  dm: remove unneeded kvfree from alloc_targets
  dm: always update the array size in realloc_argv on success

 drivers/md/dm-table.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.48.1

