Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F7B4CB4A
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709266676; cv=none; b=mrb9jcEIGthIMO/K6zybl25CSVRksYUY3RwR/j3GweR307Qcls4CJLqcj6L1NUIye7lmMuc6pKrm51ZY7SbWCw7IxBdcCbROcMI6rFdsj/Jw4diWi2FtO52GQJrsDa4MV3OlLV1X1YrO8LKYYaHyDF6ceHdAgIaPFKWjLxbtiBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709266676; c=relaxed/simple;
	bh=HXFNVEet74q6VN41B0Tc49Qaa+vqf1nqhQEJWLpTyss=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nVoUTnmcuOWX6zA4LbfRk9prDkIdD50aX9E25LA1qEEOR4PN3GuBrla5L6HoQVGbYUg8cX4le4V4pIqIMgEAcBkx5DLv07Zp9xiLyWwMItCyrdLgzFxk/Y7hRLxZft8boXy2a2wSSPdm0d8UwWpTiUsvYVtEr9hLlF6Rxmbv66g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iBzxpC0Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iBzxpC0Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709266664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wwQM/8vjuAoy2MAB+UCjY4ZzCSSP73N08s5mRIVghVU=;
	b=iBzxpC0YF9deNQPR5ugM6Qg4YBa9yg+PYsjC1N/hdBMVmjCwEPp5amSfFwjeccF//r+6Ow
	s9KErKEwKcjbwUICugcS0v/gMLRlc41Nh2Fzzo2VPdJltozGdTN+t1tkGEhDeztvf6TPp2
	OXplOdtSJgOTAMdkHiSnNP5IVynRnzw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-YOC4qidqNc-whFI0P4iHHA-1; Thu,
 29 Feb 2024 23:17:43 -0500
X-MC-Unique: YOC4qidqNc-whFI0P4iHHA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA1F53806107
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:17:42 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C4265492C25;
	Fri,  1 Mar 2024 04:17:42 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id BBBAAA15BF; Thu, 29 Feb 2024 23:17:42 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/2] dm vdo: move indexer to sub-directory
Date: Thu, 29 Feb 2024 23:17:40 -0500
Message-ID: <cover.1709266547.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Matthew Sakai (1):
  dm vdo: remove unnecessary indexer.h includes

Mike Snitzer (1):
  dm vdo: move indexer files into sub-directory

 drivers/md/dm-vdo/Makefile                    | 34 ++++++++++---------
 drivers/md/dm-vdo/data-vio.h                  |  3 +-
 drivers/md/dm-vdo/dedupe.c                    |  3 +-
 drivers/md/dm-vdo/encodings.h                 |  1 -
 .../md/dm-vdo/{ => indexer}/chapter-index.c   |  5 +--
 .../md/dm-vdo/{ => indexer}/chapter-index.h   |  0
 drivers/md/dm-vdo/{ => indexer}/config.c      |  0
 drivers/md/dm-vdo/{ => indexer}/config.h      |  0
 drivers/md/dm-vdo/{ => indexer}/delta-index.c |  5 +--
 drivers/md/dm-vdo/{ => indexer}/delta-index.h |  5 +--
 .../{ => indexer}/funnel-requestqueue.c       |  0
 .../{ => indexer}/funnel-requestqueue.h       |  0
 drivers/md/dm-vdo/{ => indexer}/geometry.c    |  5 +--
 drivers/md/dm-vdo/{ => indexer}/geometry.h    |  0
 drivers/md/dm-vdo/{ => indexer}/hash-utils.h  |  3 +-
 .../md/dm-vdo/{ => indexer}/index-layout.c    |  5 +--
 .../md/dm-vdo/{ => indexer}/index-layout.h    |  0
 .../md/dm-vdo/{ => indexer}/index-page-map.c  |  5 +--
 .../md/dm-vdo/{ => indexer}/index-page-map.h  |  0
 .../md/dm-vdo/{ => indexer}/index-session.c   |  7 ++--
 .../md/dm-vdo/{ => indexer}/index-session.h   |  3 +-
 drivers/md/dm-vdo/{ => indexer}/index.c       |  5 +--
 drivers/md/dm-vdo/{ => indexer}/index.h       |  0
 drivers/md/dm-vdo/{ => indexer}/indexer.h     |  0
 drivers/md/dm-vdo/{ => indexer}/io-factory.c  |  0
 drivers/md/dm-vdo/{ => indexer}/io-factory.h  |  0
 .../md/dm-vdo/{ => indexer}/open-chapter.c    |  5 +--
 .../md/dm-vdo/{ => indexer}/open-chapter.h    |  0
 drivers/md/dm-vdo/{ => indexer}/radix-sort.c  |  0
 drivers/md/dm-vdo/{ => indexer}/radix-sort.h  |  0
 .../md/dm-vdo/{ => indexer}/sparse-cache.c    |  7 ++--
 .../md/dm-vdo/{ => indexer}/sparse-cache.h    |  0
 .../md/dm-vdo/{ => indexer}/volume-index.c    |  9 ++---
 .../md/dm-vdo/{ => indexer}/volume-index.h    |  3 +-
 drivers/md/dm-vdo/{ => indexer}/volume.c      | 13 +++----
 drivers/md/dm-vdo/{ => indexer}/volume.h      |  5 +--
 drivers/md/dm-vdo/uds-sysfs.c                 |  3 +-
 drivers/md/dm-vdo/vdo.h                       |  1 -
 38 files changed, 77 insertions(+), 58 deletions(-)
 rename drivers/md/dm-vdo/{ => indexer}/chapter-index.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/chapter-index.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/config.c (100%)
 rename drivers/md/dm-vdo/{ => indexer}/config.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/delta-index.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/delta-index.h (99%)
 rename drivers/md/dm-vdo/{ => indexer}/funnel-requestqueue.c (100%)
 rename drivers/md/dm-vdo/{ => indexer}/funnel-requestqueue.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/geometry.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/geometry.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/hash-utils.h (99%)
 rename drivers/md/dm-vdo/{ => indexer}/index-layout.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/index-layout.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/index-page-map.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/index-page-map.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/index-session.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/index-session.h (99%)
 rename drivers/md/dm-vdo/{ => indexer}/index.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/index.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/indexer.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/io-factory.c (100%)
 rename drivers/md/dm-vdo/{ => indexer}/io-factory.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/open-chapter.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/open-chapter.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/radix-sort.c (100%)
 rename drivers/md/dm-vdo/{ => indexer}/radix-sort.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/sparse-cache.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/sparse-cache.h (100%)
 rename drivers/md/dm-vdo/{ => indexer}/volume-index.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/volume-index.h (99%)
 rename drivers/md/dm-vdo/{ => indexer}/volume.c (99%)
 rename drivers/md/dm-vdo/{ => indexer}/volume.h (99%)

-- 
2.42.0

