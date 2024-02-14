Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243BB10965
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 04:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707886636; cv=none; b=hYUScl0lQnYx0AnRf/bwmj/A1sWWMaYGEbvGo3l5YIMN6ilDKyRfF7NnoYqNgEgdptz+soWWzuxPTLaMtd+ucy9GJIqvvgZSP2jprNSMJyow26gihPVM90AALcEVzdH36ijJk1/Tjt59yPkbKx9v9WeJEmGYSU/GnbS/+2m6fmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707886636; c=relaxed/simple;
	bh=VEvKNPoGPasrjTU1ViRn36ORXxt0D63rk2dP8KYlPw8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kw/xhG6wevbAZV+W0iqprV8erpPB9GTbpEPY2EC9gOoSzjW0kZova/Z45Gxfbk+rC1X7j3D7YIl3CD/pL3racD/4ZolkJ8fMJ4v85NEzVJZsJzMBcp+OP5RzsjOQX3iNnDgZOaC69fbOvdQAK2KC/AqFeTTrDYMXgNVYYk3pDdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fBh/GmT4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fBh/GmT4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707886633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Xvw+qT4aTwEo1XvKUHLTed+qdDr3Cja67U8Qz05jSPk=;
	b=fBh/GmT4+V/TqgKuNrEp9qBUYAm70kM++9PB0pLSEeTh+vwr3oZ1K9qLmni2s7gyreKrKU
	Eu6gAUU8rjXLlGyMUxhaZtTEYnarj/k3BvRZFi+sd6CFk7tv6Kth+Jhqu2lO2HtMjsV60v
	eQE42GmuZQS/888/gWKP9DLLH+mwn8I=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-Hx86cMtUOFeMf-0U36tB8Q-1; Tue,
 13 Feb 2024 23:57:12 -0500
X-MC-Unique: Hx86cMtUOFeMf-0U36tB8Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EDC83806735
	for <dm-devel@lists.linux.dev>; Wed, 14 Feb 2024 04:57:12 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47B7D400D5CC;
	Wed, 14 Feb 2024 04:57:12 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 3F000576B8; Tue, 13 Feb 2024 23:57:12 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/5] dm vdo: fix various small nits
Date: Tue, 13 Feb 2024 23:57:07 -0500
Message-ID: <cover.1707886374.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Mike Snitzer (5):
  dm vdo string-utils: remove unnecessary includes
  dm vdo dedupe: fix various small nits
  dm vdo: cleanup style for comments in structs
  dm vdo chapter_index: fix a few small nits
  dm vdo delta-index: fix various small nits

 drivers/md/dm-vdo/block-map.h        |  12 +-
 drivers/md/dm-vdo/chapter-index.c    |   9 +-
 drivers/md/dm-vdo/constants.h        |  38 +++---
 drivers/md/dm-vdo/dedupe.c           |  11 +-
 drivers/md/dm-vdo/delta-index.c      |  23 ++--
 drivers/md/dm-vdo/delta-index.h      |   2 +-
 drivers/md/dm-vdo/encodings.h        |   8 +-
 drivers/md/dm-vdo/flush.c            |  28 ++--
 drivers/md/dm-vdo/recovery-journal.h |  22 +--
 drivers/md/dm-vdo/statistics.h       | 194 +++++++++++++--------------
 drivers/md/dm-vdo/string-utils.c     |   6 -
 drivers/md/dm-vdo/vdo.h              |   8 +-
 drivers/md/dm-vdo/vio.c              |  16 +--
 13 files changed, 186 insertions(+), 191 deletions(-)

-- 
2.42.0

