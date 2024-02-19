Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9AE200A8
	for <dm-devel@lists.linux.dev>; Mon, 19 Feb 2024 06:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708323994; cv=none; b=JNXaP5xtbvw8nQWCroEhbRV2/sGZ5pc1X6opHwOrw+fm2XILK1/ao0txZYD/0Vp/sy7X1Mv3nHrhtISquxnz2Jfe94mowzL3YBAVCuUCffN95yo/RLP8R7EYC8XNxrRZgFw/AaUpxz9q4h+7PPJDuyPywRX5v6JgUnVLf9DN8ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708323994; c=relaxed/simple;
	bh=YLhEMtoeiV/LirzX2fuQwIm9rfOZ1xB/cPj+FcFrQjI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jj+fS7EJxcCGeTBd3uChPUutGu1/kVxqZXgQo0dLzCpSCcSqz2wBihHG4a9cb7WrcLQs4LgScU4Rh8dkZpHh2/6JV7ScZesQZ+sFg4fYxnnTlgNehs/fGwu5e6OETYufzGHdXmUYn9S+1f/g3lgGDPINe5z6J0cENM1w2hzWFNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EVZZVBCO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EVZZVBCO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708323990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/rj+13vEWq/GDSNCN4fIT8jzOM//quFijZG/CjtnC/4=;
	b=EVZZVBCOnR5vrpej8WG6N6K0IhwFGEQZR/X58BtWadAbxglwE1mvnT05Y/eTzXt0Z6tY4b
	2Wje7rqcilea0JDI8z223TRqqlN51kdIaPJEB7k+LpL6UQ4u3sUTX5QVZkg4kJjcDAdmUb
	9QBHSTMIO1MT2zWFvREAOZcu1PqQqDs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-6-z1N8GxNxC4JtLq0DCgoQ-1; Mon, 19 Feb 2024 01:26:28 -0500
X-MC-Unique: 6-z1N8GxNxC4JtLq0DCgoQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E84E830D37;
	Mon, 19 Feb 2024 06:26:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.2])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 96AC348B;
	Mon, 19 Feb 2024 06:26:23 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	neilb@suse.de,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH RFC 0/3] Fix regression bugs
Date: Mon, 19 Feb 2024 14:26:18 +0800
Message-Id: <20240219062621.92960-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Hi all

Sorry, I know this patch set conflict with Yu Kuai's patch set. But
I have to send out this patch set. Now we're facing some deadlock
regression problems. So it's better to figure out the root cause and
fix them. But Kuai's patch set looks too complicate for me. And like
we're talking in the emails, Kuai's patch set breaks some rules. It's
not good to fix some problem by breaking the original logic. If we really
need to break some logic. It's better to use a distinct patch set to
describe why we need them.

This patch is based on linus's tree. The tag is 6.8-rc5. If this patch set
can be accepted. We need to revert Kuai's patches which have been merged
in Song's tree (md-6.8-20240216 tag). This patch set has three patches.
The first two resolves deadlock problems. With these two patches, it can
resolve most deadlock problem. The third one fixes active_io counter bug.

I have run lvm2 regression test. lvconvert-raid-reshape.sh is failed. This
patch set doesn't plan to fix it. Kuai's patch set has a patch which should
fix it. And there are other 4 failed cases:
shell/dmsetup-integrity-keys.sh
shell/lvresize-fs-crypt.sh
shell/pvck-dump.sh
shell/select-report.sh

Xiao Ni (3):
  Clear MD_RECOVERY_WAIT when stopping dmraid
  Set MD_RECOVERY_FROZEN before stop sync thread
  Missing decrease active_io for flush io

 drivers/md/dm-raid.c | 2 ++
 drivers/md/md.c      | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

-- 
2.32.0 (Apple Git-132)

