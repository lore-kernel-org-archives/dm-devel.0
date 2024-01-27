Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD852A50
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706322954; cv=none; b=UZRQcM03zy3q2UHdgJHw6y7eVImn8reDoLpty+QU8QpqKBZwVvreSDM5aazyf3bqQUuwEIRqL9gYgau2Fs0tuLDkt7tN2SvJZVTjHWCxLN8Oom944w8DIYd88qhZQ8VvmqfRONDnt277hWhT2KokOTcBGK49PmmJHR4Y+rUQsJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706322954; c=relaxed/simple;
	bh=F3Kt3a3pcwKt6anptmh2ECG1dmjQhDt/e+A+dXxMmO0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hmJxgyldTc7x1uaoaAfbG0ou6yRRQUidvYWmkaUwHEnP1qSw4wcnxKcBuf3cTuMIDk5H/GMCoAObCDF56khUmf6zrT0V8WVN6BS74ygtmcw/jGbF8IA1JpNyf+vi2Ug7xUcPebAAlALd+tC/w0K2t41vxUJ2zyjCcfy3ZCwopx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bpsB7N5u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bpsB7N5u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706322951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kZoaZRE5zh/hKy9JA5QdQlhiVK4BUfkiN4U5X3GpSYk=;
	b=bpsB7N5u8uzzJk61z/xWx2nMJkAJri84siaWWTteInql9CvZD+hyGQ2OMT72sKRLj21acO
	EvrzOJqyP/rhqkQLmyolaTtypEE3DsbEfH7oQDxIr/5dKAVl/rM8DplFrCjRLQWmO9eI4Y
	Z6DIv9USX5iW3lMaznl9NIROlFZMgdo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-8CVxBZ8VPzGy67cNoXI2GQ-1; Fri, 26 Jan 2024 21:35:49 -0500
X-MC-Unique: 8CVxBZ8VPzGy67cNoXI2GQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EE98185A781
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:35:49 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5293D1C060AF;
	Sat, 27 Jan 2024 02:35:49 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 4900B560BF; Fri, 26 Jan 2024 21:35:49 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/5] dm vdo block-map: various small improvements
Date: Fri, 26 Jan 2024 21:35:44 -0500
Message-ID: <cover.1706322049.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Streamline block map code.

Mike Snitzer (5):
  dm vdo block-map: fix a few small nits
  dm vdo block-map: use uds_log_ratelimit() rather than open code it
  dm vdo block-map: remove extra vdo arg from initialize_block_map_zone
  dm vdo block-map: avoid extra dereferences to access vdo object
  dm vdo block-map: rename struct cursors member to 'completion'

 drivers/md/dm-vdo/block-map.c | 56 ++++++++++++++++-------------------
 drivers/md/dm-vdo/block-map.h |  2 +-
 2 files changed, 26 insertions(+), 32 deletions(-)

-- 
2.42.0

