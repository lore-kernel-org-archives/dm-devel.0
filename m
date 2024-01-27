Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9F665C
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706323354; cv=none; b=j9r2LBU0afCYsUdexGEBPYKMNkydjCOMfmNJt4DJtY4xicr8RWxNxEzAxW5VFYe+YhkJiclzQKW5Cbw/XdbT3XVMkMjAxKz7L8OElpVXEsCkV6arXRn9AQ8qBcQ7jwtfnW/B2ZwngItDDsExJqrthOMVZG+bMFVhz8rG8pGu6nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706323354; c=relaxed/simple;
	bh=C1NXq0wNEGZXTRLve3U9duWOCyq1HPyX2/PKutw2lmA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sv90TBBEl8UZ5HUhM91eaq7N1Xxky+SZsyS2QOIAYI4l9JGHjWpdPSx79XApoocHCTyxJiw61STUPx+NvJotK28NH7imjhjXUB+ehDGyMeDaeVw62atl9HZosmQ4PtmzXbKIzCJ0V9k8zSp+XaN0qAZXo9LBhgu5d34EX1f9LyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BvjCALW5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BvjCALW5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706323351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ejla0Vn6PfIb5stx8UX3ZRIbQPEd6956wqKwClTiOlk=;
	b=BvjCALW57h4LKGokfSbQjs32iiiKd6vEb0mOt+mMlDWJwx/2CTqgrhwmU02udmSRtNnXEf
	qGQvS+MhE4yKBHLBXEZAX5R80FIqMYNUUOZXU00xFaZ1jodhhS6oD0gK2KnHSEi2rXutfr
	9kAnpuKCAHl4Oh0Lcz1E230U83e9xb4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-dGoZQM4zOMOp8klIgkbbsg-1; Fri, 26 Jan 2024 21:42:29 -0500
X-MC-Unique: dGoZQM4zOMOp8klIgkbbsg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97E0D827D86
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:42:29 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 91C30900;
	Sat, 27 Jan 2024 02:42:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 88BD5560D0; Fri, 26 Jan 2024 21:42:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/3] dm vdo: various error code improvements
Date: Fri, 26 Jan 2024 21:42:26 -0500
Message-ID: <cover.1706323002.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Streamline error code handling.

Mike Snitzer (3):
  dm vdo: slight cleanup of UDS error codes
  dm vdo: rename uds_map_to_system_error to uds_status_to_errno
  dm vdo: rename vdo_map_to_system_error to vdo_status_to_errno

 drivers/md/dm-vdo/data-vio.c      |  2 +-
 drivers/md/dm-vdo/dm-vdo-target.c | 10 ++++-----
 drivers/md/dm-vdo/errors.c        |  2 +-
 drivers/md/dm-vdo/errors.h        | 37 +++++++++++++++----------------
 drivers/md/dm-vdo/index-layout.c  |  4 ++--
 drivers/md/dm-vdo/index-session.c | 20 ++++++++---------
 drivers/md/dm-vdo/status-codes.c  |  4 ++--
 drivers/md/dm-vdo/status-codes.h  |  6 ++---
 8 files changed, 41 insertions(+), 44 deletions(-)

-- 
2.42.0

