Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D61A25A2D7
	for <dm-devel@lists.linux.dev>; Fri, 28 Feb 2025 09:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740735733; cv=none; b=kU8OaymEoiYAi5SAcwmbAL1M1pupDJQZmX0MR/Z3EKd/643P40GEf70cfyQSlBHOKHull9yYUO9pXQYof1ftHlZy9PXpdYei7oXxF5ZI/wqhHFc5NOSaL/P+fntHAOzHeJj42rAPyYNoJBxNp9ej1EIiPqjc/NFcwmxF8PCznXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740735733; c=relaxed/simple;
	bh=pyL8yuiCzi9rSmCOOUNE1w2DhzPq+hZsUp6GNjrg2Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=GoxelN1XyHNKwQoLvFhobqjSq5QIU322DYhhCmAxnFqou4MwkH9A837OvWx86m8p4zf9Z8KrQzUb7vxP+PmzYDwnvP3HwTioEA8rYbeyTPUYj59JrGGg/KQNgjLJIWAiZDUN5bLieBO0gFbk/e9VUd3WHGlWjm2v4j/lklByAtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eaQhuX0j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eaQhuX0j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740735729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iYFZGseiiqJ5wRxjtTfcZlv3fcqAaDRnbwrWfXulTY0=;
	b=eaQhuX0jCFXIwx9zAOUJPfiDkjxe+NUqHEPn7sXRl2+2heIuwNeyhy/wTKdNuvk+eod0DI
	M21rKnRvXqN66itL74/QSmazGwLCKSrPD10lNfzqgShCQUWP2Jn+nqXAgYQlgqntoYitso
	X/Ek4+2xglsiE2R37gXm3+uy1g5P+wc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-KAHxYqYgMCKwsZbsf64B9A-1; Fri,
 28 Feb 2025 04:42:02 -0500
X-MC-Unique: KAHxYqYgMCKwsZbsf64B9A-1
X-Mimecast-MFC-AGG-ID: KAHxYqYgMCKwsZbsf64B9A_1740735722
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E28E01800373;
	Fri, 28 Feb 2025 09:42:01 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.97])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18E981800367;
	Fri, 28 Feb 2025 09:41:57 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 0/2] dm cache: support shrinking the origin device
Date: Fri, 28 Feb 2025 17:41:29 +0800
Message-ID: <20250228094131.132061-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4xU7xePoc5lovFXoSDj2mv4OAYj-jek3c9Kdi_SPVw0_1740735722
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patch series introduces formal support for shrinking the cache
origin and ensures that failed resume attempts, such as those caused
by shrinking failures, do not trigger BUG_ON.

Ming-Hung Tsai (2):
  dm cache: prevent BUG_ON by blocking retries on failed device resumes
  dm cache: support shrinking the origin device

 drivers/md/dm-cache-target.c | 94 +++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 2 deletions(-)

-- 
2.47.0

