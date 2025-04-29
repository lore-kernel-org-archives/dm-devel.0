Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E909621772B
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945533; cv=none; b=iTS9qyROtSdXc9UIzb13aqYzv4UBCwq25V1hm3DLQsppwCFixveXMUV9muhwFmcVehsrkyNVkjcjT1DP0n+7nPvC51gJIOJAG7g9xOxxVNnw1ehiTSDWGeVp6iZoBXmMAMOIlxg3JH38/3le7rbXiIDwvRIka/SU+VMzrqTTLAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945533; c=relaxed/simple;
	bh=qrEOMHmtTp7OFHh8ZgfaWUBX6cj24khtRPb/lao4Adk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wku6Rli/1UuML3D3DMfT7gxaCQsvaGyGmjiF/SJwQIjOEukZSgoSSgqANLAYvWcqOIJ1qgxeLAkkP/sJrfxNYl9ssMWBHtrXWOaerwPaUV82oo3eYnyp0uxypzZU0ZgGGZwUVlcG6AzKa4YZ4kdF6G0OzucbZiYPzwKtLopHEzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CaqE8g9g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CaqE8g9g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745945530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pCP+Jn5db3OWqLaQDlXS5vWrXACMSWyu8xwgwx1Ls7M=;
	b=CaqE8g9gJp8DxcTgLIcNKJFghMvlLpAykevHFAY4EJ22f6G962zXYm77wB69KiBxKaAttP
	kU238yXSDP5CVxEYtq06/k4saP4IBI1S2tNM3wkimVhe0Rlb1XkrD+KBrF8j2eoFZa4Xsm
	NrqJ0jpIzdYNAiaghGgQCttuIW5Kq3g=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-320-FfRgJyh9OQemIzvpxLE6MQ-1; Tue,
 29 Apr 2025 12:52:08 -0400
X-MC-Unique: FfRgJyh9OQemIzvpxLE6MQ-1
X-Mimecast-MFC-AGG-ID: FfRgJyh9OQemIzvpxLE6MQ_1745945527
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9274F1800EC8;
	Tue, 29 Apr 2025 16:52:07 +0000 (UTC)
Received: from merkur.redhat.com (unknown [10.44.34.64])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1CE381956094;
	Tue, 29 Apr 2025 16:52:04 +0000 (UTC)
From: Kevin Wolf <kwolf@redhat.com>
To: dm-devel@lists.linux.dev
Cc: kwolf@redhat.com,
	hreitz@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	bmarzins@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] dm mpath: Interface for explicit probing of active paths
Date: Tue, 29 Apr 2025 18:50:16 +0200
Message-ID: <20250429165018.112999-1-kwolf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Multipath cannot directly provide failover for ioctls in the kernel
because it doesn't know what each ioctl means and which result could
indicate a path error. Userspace generally knows what the ioctl it
issued means and if it might be a path error, but neither does it know
which path the ioctl took nor does it necessarily have the privileges to
fail a path using the control device.

This series adds an interface that userspace can use to probe paths and
fail the bad ones after seeing a potential path error in an ioctl
result. Once the bad paths are eliminated, the ioctl can be retried.

While the fundamental problem is relatively broad and can affect any
sort of ioctl, the immediate motivation for this is the use of SG_IO in
QEMU for SCSI passthrough. A preliminary QEMU side patch that makes use
of the new interface to support multipath failover with SCSI passthrough
can be found at:

https://repo.or.cz/qemu/kevin.git/commitdiff/78a474da3b39469b11fbb1d4e0ddf4797b637d35

Kevin Wolf (2):
  dm: Allow .prepare_ioctl to handle ioctls directly
  dm mpath: Interface for explicit probing of active paths

 include/linux/device-mapper.h |  9 +++-
 include/uapi/linux/dm-ioctl.h |  9 +++-
 drivers/md/dm-dust.c          |  4 +-
 drivers/md/dm-ebs-target.c    |  3 +-
 drivers/md/dm-flakey.c        |  4 +-
 drivers/md/dm-ioctl.c         |  1 +
 drivers/md/dm-linear.c        |  4 +-
 drivers/md/dm-log-writes.c    |  4 +-
 drivers/md/dm-mpath.c         | 95 ++++++++++++++++++++++++++++++++++-
 drivers/md/dm-switch.c        |  4 +-
 drivers/md/dm-verity-target.c |  4 +-
 drivers/md/dm-zoned-target.c  |  3 +-
 drivers/md/dm.c               | 17 ++++---
 13 files changed, 142 insertions(+), 19 deletions(-)

-- 
2.49.0

