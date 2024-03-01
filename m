Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D6F405DC
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265535; cv=none; b=tZwefwt10tutnuo3LutaycCr2Bp1Y1IwRSkjmArF4zEPbkeHYHs3Ufw7y6WaROtWiOdjhzFBDZZtxKjYpqIeLxXSTb3+8AZcjc2zGBSF4+JlmKQMKWjV7fIMXGLZ1NfN8UU/U7lz+hBexOlnDJ3w8HSn5ZIg4iMCdysR/xrMoB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265535; c=relaxed/simple;
	bh=YJYbfA8QEwr3pCa7s5UYl2KPWadpPSWLNFVOPKk8dwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ILg1aJ8H6hR04jk/FMxsTOk28PoiMF40LNXijpCjiF3FpGU5/sHk4CQpM2WrsJDs1MGQWQORdSuTtwoATMi3YFTro3fiD13l76U2ozNtNx8c17Jw80ryBbQqM26pPpZiTnso1E9sYiHslXt35VBZCWmQ7luhLhIzQxPEyunV3Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YyNdqvli; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YyNdqvli"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qmr5BpHoHDkQ+04ZGWLbouo7y39YwIj9YDi0nL8HMb8=;
	b=YyNdqvli9bnAbmxpvFXLOFJUJG1slE4c1rde1dDnsVP6nF19PqAudSvVAsyvtYa7/laLyG
	fgra4MYyY0eEswfcrc6Mek1s8Bm1ktkmqWztRjBsUUsT4aUYNCx2Avdo2lzX5WwMPDmvGB
	LlixyXUTBJIRSRFg4z3a5gDNrVgOwgY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-moVC1OEZOemIVAwJjShWaw-1; Thu, 29 Feb 2024 22:58:51 -0500
X-MC-Unique: moVC1OEZOemIVAwJjShWaw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 555D689F9E0
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:58:51 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 50981492BE2;
	Fri,  1 Mar 2024 03:58:51 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 482B39F80A; Thu, 29 Feb 2024 22:58:51 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/2] dm vdo: remove internal ticket references
Date: Thu, 29 Feb 2024 22:58:49 -0500
Message-ID: <cover.1709265262.git.msakai@redhat.com>
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

Susan LeGendre-McGhee (2):
  dm vdo: remove internal ticket references from indexer
  dm vdo: remove internal ticket references from vdo

 drivers/md/dm-vdo/block-map.c     |  8 ++++----
 drivers/md/dm-vdo/data-vio.c      |  9 +++++----
 drivers/md/dm-vdo/dm-vdo-target.c | 12 +++++-------
 drivers/md/dm-vdo/memory-alloc.c  |  8 ++++----
 drivers/md/dm-vdo/packer.c        | 16 +++++++---------
 drivers/md/dm-vdo/packer.h        |  2 +-
 drivers/md/dm-vdo/repair.c        |  4 ++--
 drivers/md/dm-vdo/slab-depot.c    | 16 +++++++++++-----
 drivers/md/dm-vdo/sparse-cache.c  |  2 +-
 drivers/md/dm-vdo/vdo.c           |  2 +-
 drivers/md/dm-vdo/vio.c           |  1 -
 11 files changed, 41 insertions(+), 39 deletions(-)

-- 
2.42.0

