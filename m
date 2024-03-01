Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C3155E44
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 20:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709326044; cv=none; b=jYyILQlpwLZay5BclBfVm3ZDL5B/t8sbZya7k/SnLKNxIX7J60OeLDsKhbjaEDlTKvWhiJEwvIp6DFilUzgr5BZEPLDKT/APCyDyqa05ZW4Biscb1EajtaaEbQnA1TZ8hBnTJji23U970cC3smarQSje86C0SpbXKNLRYsglMFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709326044; c=relaxed/simple;
	bh=MY8F7xKSpbebpecJ3KWJEoKKuQsfxWHCI5UIVKPnumA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A58YnqlJokg/V/YDodu0hPjTl6hswYKOtX7EUv7V3sEtiuqr/ZRlOEw+ez5jXK2f3a2G26it25XDAYhMgd7zpTIe9cfxakvq+Zzxv9Lyy9YloHhIkPCaeXvFrGJIQL3TN4twc4HPVYgfkQ5ZN5haWhAobmPTKiKjx//xfz5xr0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZZlcSuJK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZlcSuJK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709326041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VbM+YyTZtZF+TRdA8zU3BO77y40egS6wKOZim2Nh24g=;
	b=ZZlcSuJKsEsoFpLj7rhu1V1/a0RJD1Qbi9Uu97lCMyQaRcGfBEXTn1OPZGtOOeYUg5ZMOS
	wGQn0K4IlJLzqo57xcdldr8H+q6hmKkfSL1BQ+bGKAxx4OjEsfR8bF/08EouL1Pkn2ToK5
	lNgjp7ycNDW91DsmUg/AXtAzW7CKY5I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-faRQVtQdMr-bz0-azXwQeQ-1; Fri, 01 Mar 2024 15:47:20 -0500
X-MC-Unique: faRQVtQdMr-bz0-azXwQeQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0954D82DFE4
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 20:47:20 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 026391121312;
	Fri,  1 Mar 2024 20:47:20 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id EBBEEA1B7C; Fri,  1 Mar 2024 15:47:19 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/4] dm vdo: remove sysfs parameters
Date: Fri,  1 Mar 2024 15:47:15 -0500
Message-ID: <cover.1709325895.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Ken Raeburn (1):
  dm vdo: document log_level parameter

Mike Snitzer (3):
  dm vdo: remove all sysfs interfaces
  dm vdo: add 'log_level' module parameter
  dm vdo logger: remove log level to string conversion code

 .../admin-guide/device-mapper/vdo.rst         |    7 +
 drivers/md/dm-vdo/Makefile                    |    4 -
 drivers/md/dm-vdo/dedupe.c                    |   70 +-
 drivers/md/dm-vdo/dedupe.h                    |    2 +-
 drivers/md/dm-vdo/dm-vdo-target.c             |   47 +-
 drivers/md/dm-vdo/logger.c                    |   64 +-
 drivers/md/dm-vdo/logger.h                    |   30 +-
 drivers/md/dm-vdo/pool-sysfs-stats.c          | 2063 -----------------
 drivers/md/dm-vdo/pool-sysfs.c                |  198 --
 drivers/md/dm-vdo/pool-sysfs.h                |   19 -
 drivers/md/dm-vdo/status-codes.c              |    1 -
 drivers/md/dm-vdo/status-codes.h              |    2 -
 drivers/md/dm-vdo/sysfs.c                     |   82 -
 drivers/md/dm-vdo/uds-sysfs.c                 |  187 --
 drivers/md/dm-vdo/uds-sysfs.h                 |   12 -
 drivers/md/dm-vdo/vdo.c                       |   54 +-
 drivers/md/dm-vdo/vdo.h                       |   13 -
 17 files changed, 41 insertions(+), 2814 deletions(-)
 delete mode 100644 drivers/md/dm-vdo/pool-sysfs-stats.c
 delete mode 100644 drivers/md/dm-vdo/pool-sysfs.c
 delete mode 100644 drivers/md/dm-vdo/pool-sysfs.h
 delete mode 100644 drivers/md/dm-vdo/sysfs.c
 delete mode 100644 drivers/md/dm-vdo/uds-sysfs.c
 delete mode 100644 drivers/md/dm-vdo/uds-sysfs.h

-- 
2.42.0

