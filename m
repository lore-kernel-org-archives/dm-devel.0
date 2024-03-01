Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4138E69E18
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 15:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709306501; cv=none; b=ueQDmKOGkRfYcwayzwxuliR5ILbjmQ1uLHlWp8xb9CKdkF7pdis2cCVz8DTIdQS41UkxWRfdluOIhAsIu3WfRc48h3OfBmwZmYUHbTG59tLqFqD/9mgXZkIOTsHIm0K+oBjUu9j/BZkit+c/nDwZfZLsBzOratEpOyhh2KJKr6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709306501; c=relaxed/simple;
	bh=xkqXRIKO1Ah68D1vo/V3KJZHVg+/5YhMOP+p4NXVta8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MI6uVVjjhkDooNpj23XLMXfVAu+fsBe4P46l7CCOJqJftXUVMMKqQXoZgDW7LcVZBd8iIR3HaPkGYYcPGCRLuipmK3ENDalujC6TbFjBX/FYGFxBccJ1kyaTAlZVue7qAgf2sQeKigcKLJ0eoKYMWeFn4EZR+7GEbtteNNOVvRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YaRgotBH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YaRgotBH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709306498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=It4KpMBO8RKD2qu9V9Jn/iyXf0RO2wRJAeStTLcykfk=;
	b=YaRgotBHuq02zbseQujHJh3RjiVI17wVstI7EaoLPaxTqpnXmi8COIsisu59+Bkjpmapxi
	lUBArz3IxJBq9tCBHj1miAnDfBKqusFmvmjmG+KbP49BRIuO0+RCVIqvkOFoLO8eLYLAMt
	KkIHDZKtDYUkczHfFEFXi/97QY9fTs4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-552-Ejvc4LqKMIiXRWUtny8ymg-1; Fri,
 01 Mar 2024 10:21:34 -0500
X-MC-Unique: Ejvc4LqKMIiXRWUtny8ymg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFCAE3C14955;
	Fri,  1 Mar 2024 15:21:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.8])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C59E1121312;
	Fri,  1 Mar 2024 15:21:29 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH V2 0/4] Fix dmraid regression bugs
Date: Fri,  1 Mar 2024 23:21:24 +0800
Message-Id: <20240301152128.13465-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Hi all

This patch set tries to fix dmraid regression problems we face
recently. This patch is based on song's md-6.8 branch. 

This patch set has four patches. The first two patches revert two patches.
The third one and the fourth one resolve deadlock problems.

I have run lvm2 regression test 5 times. There are 4 failed cases:
shell/dmsetup-integrity-keys.sh
shell/lvresize-fs-crypt.sh
shell/pvck-dump.sh
shell/select-report.sh

And lvconvert-raid-reshape.sh can fail sometimes. But it fails in 6.6
kernel too. So it can return back to the same state with 6.6 kernel.

V2:
It doesn't revert commit 82ec0ae59d02
("md: Make sure md_do_sync() will set MD_RECOVERY_DONE")
It doesn't clear MD_RECOVERY_WAIT before stopping dmraid
Re-write patch01 comment

Xiao Ni (4):
  md: Revert "md: Don't register sync_thread for reshape directly"
  md: Revert "md: Don't ignore suspended array in md_check_recovery()"
  md: Set MD_RECOVERY_FROZEN before stop sync thread
  md/raid5: Don't check crossing reshape when reshape hasn't started

 drivers/md/md.c     |  9 ++++----
 drivers/md/raid10.c | 16 ++++++++++++--
 drivers/md/raid5.c  | 51 ++++++++++++++++++++++++++++++++-------------
 3 files changed, 56 insertions(+), 20 deletions(-)

-- 
2.32.0 (Apple Git-132)

