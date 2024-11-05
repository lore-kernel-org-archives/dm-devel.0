Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E61618028
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 00:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730766316; cv=none; b=MgJ8StylVWpG6ngBscqQ6hVwauDnkKp7o1lEzySXv23+Y9tySeDOT3CWJh+tT3JQYxTajFCaSaUZcArub2RWgOuwKWZfWpA8fPpK2j5XW+PNbk+bfblWjEpS53FBNaKw7Q+AZ//BkLOgHs7yX6YLDVdUCvsVk986Te/fSOLP5S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730766316; c=relaxed/simple;
	bh=IMa8F6O6ZbUp2BYA/pMnW+5zZDoliTtEiQJLbakCCwk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sc0P+wiXxGd06KeMqx96KQB2SZpqPhGHvUpC+IRSlHCVkPffhK2enxZK8eQyQi00Nxud+i70Bf5KPAB4gw4saEF6xFcroSOVpgnJayHT/DKkxiMpTICsnWxqPWNqRAed6HWVsJzog8kxfKH24phkYDhC2foNToeXXN6kYVH18NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FAghzDVM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FAghzDVM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730766313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YYFW18AD+ojrod69xk0iB9RZP45mk2MOlF3Aqvc6A/0=;
	b=FAghzDVMVu+aR8oEN/DjMaMSMhacE3aTzZ62ra35EJhGRgUSLe/AlVXYbfAYIJ8Jl/qUM4
	JEjBW9tkUicSd5/zXJr53WVd9m4Dk1x0baTLGo8an+NwG+813LqFXkUJxC4mcBQsdDe2sp
	vYD/SRbFU8datmxNLIiULi74lKF53oo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-272-CprtAX9hPjywo5K62TO9JA-1; Mon,
 04 Nov 2024 19:25:12 -0500
X-MC-Unique: CprtAX9hPjywo5K62TO9JA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2EA4619560B7
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 00:25:11 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E058C300018D;
	Tue,  5 Nov 2024 00:25:10 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 47A1359E68; Mon,  4 Nov 2024 19:25:10 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/2] dm vdo: fix various syntax warnings
Date: Mon,  4 Nov 2024 19:25:08 -0500
Message-ID: <cover.1730766085.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Matthew Sakai (2):
  dm vdo int-map: remove unused parameters
  dm vdo: fix function doc comment formatting

 drivers/md/dm-vdo/block-map.c        |  2 --
 drivers/md/dm-vdo/data-vio.c         |  7 ++++---
 drivers/md/dm-vdo/dedupe.c           |  9 +++++----
 drivers/md/dm-vdo/encodings.c        |  2 +-
 drivers/md/dm-vdo/int-map.c          | 28 +++++++++++-----------------
 drivers/md/dm-vdo/io-submitter.c     |  2 +-
 drivers/md/dm-vdo/packer.c           |  3 +--
 drivers/md/dm-vdo/physical-zone.c    |  2 +-
 drivers/md/dm-vdo/recovery-journal.c |  2 +-
 drivers/md/dm-vdo/slab-depot.c       |  9 +++------
 drivers/md/dm-vdo/vdo.c              |  4 ++--
 11 files changed, 30 insertions(+), 40 deletions(-)

-- 
2.45.2

