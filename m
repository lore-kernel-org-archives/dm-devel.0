Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6967580A
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 15:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709221793; cv=none; b=JPxr7xw899CTr54HgHef5PWVwkokToF9tBoWdK9ErmWqgev9bJwAqoIUML0xwRO4bmN1PaM7GsJCKtd3B94E5TCT96o4GFqK8d2mvezLWSU6X1F9h3GBnSGChX+Gm7dfejm9zCPHxoXVUuZqxE2I9HX9UAAC0BrzEmiMNqHDQ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709221793; c=relaxed/simple;
	bh=NeF1Wj4Z8RuiIMhD3ZuUvpWzo6wuLdeZq2a6YTe4VPY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BoAHps+EJM6x3hH9Qo+ZmPLIIc17iy3/34psSCcbon92xkA0KhDFDLD4RajQ1lgDMFX4OvNOCTyH9xJ5yc2zpOIyk2il5fkX1ZgEA/FcKYXg/tKH8jGg4TBb+072jraZdxptpXW48deZwzMQlpq1+5OK1+JDEJAC08Mo77rlm2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SziXS7X0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SziXS7X0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709221791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Wfu0sWlqCO6LDuKxM9Us8IsB5MFpZq4BxE/BhqUnMpE=;
	b=SziXS7X0q4LUz5gD3Cpn/RMLPjTvEkFzC+bump+PSxwGHWBT3Ox3eC8gAxIFf7WpKm76HC
	FpuNnlv3fXsV65nuWpwSjVFUoshMvNQnUsM/GVf/gKq21N4mLsb4U6HNforLbjz8rwWwWz
	n5PM2xIDPG2A8FVNWvK2laQwuK9gKiE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-3U-MKXusOH-zL4_-X4MgOg-1; Thu, 29 Feb 2024 10:49:47 -0500
X-MC-Unique: 3U-MKXusOH-zL4_-X4MgOg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FDA2845DC1;
	Thu, 29 Feb 2024 15:49:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.8])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6C278C0348C;
	Thu, 29 Feb 2024 15:49:43 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 0/6] Fix dmraid regression bugs
Date: Thu, 29 Feb 2024 23:49:35 +0800
Message-Id: <20240229154941.99557-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Hi all

This patch set tries to fix dmraid regression problems when we recently.
After talking with Kuai who also sent a patch set which is used to fix
dmraid regression problems, we decide to use a small patch set to fix
these regression problems. This patch is based on song's md-6.8 branch. 

This patch set has six patches. It reverts three patches. The fourth one
and the fifth one resolve deadlock problems. With these two patches, it
can resolve most deadlock problem. The last one fixes the raid5 reshape
deadlock problem.

I have run lvm2 regression test. There are 4 failed cases:
shell/dmsetup-integrity-keys.sh
shell/lvresize-fs-crypt.sh
shell/pvck-dump.sh
shell/select-report.sh

And lvconvert-raid-reshape.sh can fail sometimes. But it fails in 6.6
kernel too. So it can return back to the same state with 6.6 kernel.

Xiao Ni (6):
  Revert "md: Don't register sync_thread for reshape directly"
  Revert "md: Make sure md_do_sync() will set MD_RECOVERY_DONE"
  Revert "md: Don't ignore suspended array in md_check_recovery()"
  dm-raid/md: Clear MD_RECOVERY_WAIT when stopping dmraid
  md: Set MD_RECOVERY_FROZEN before stop sync thread
  md/raid5: Don't check crossing reshape when reshape hasn't started

 drivers/md/dm-raid.c |  2 ++
 drivers/md/md.c      | 22 +++++++++----------
 drivers/md/raid10.c  | 16 ++++++++++++--
 drivers/md/raid5.c   | 51 ++++++++++++++++++++++++++++++++------------
 4 files changed, 63 insertions(+), 28 deletions(-)

-- 
2.32.0 (Apple Git-132)

