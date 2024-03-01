Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED56F44379
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709264322; cv=none; b=dh/46dYTZZEbzQOSD7AMtSpjouQAcRTdAtH7r+M3Tq1hQ37wcLQjkOwoVgfDyGhJ2Bt/mPv3jrFeCPOi84zvB1h/aI8t6KYXXvyiGd3AyqeAxpi/W9V6Fl6uqTMsCjyXKe6jh1kPOpyfT62G95gbfpIpils2gQ6PUSk/9/GEeMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709264322; c=relaxed/simple;
	bh=sGi1Nid5j8NqlfwnelIptPGgaOFsYwnNnr33/R91IEo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GLI8jEMrw0Joxl3lz/XB1mcxO0XSmi+Ypr/ZzrNsEZEvJV1etHOyHTfqmPwwzH3rIY4AxhLd+AS+Vda2L/7TeJlGMdc73f9oDToKyshFiWQ88sMMhbJZoztbi7MSx5mXwnYGNe4VRvdHHkSsz/HQqO+kywT4/o7PJ5c7+vOh6kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i0pwrruy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i0pwrruy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709264319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zwimxuouAbhTQIPhjjMND6f83YNC7jKsdKx9MW3aoLA=;
	b=i0pwrruyKPPgktBs1/6LIXc9wBwKYW10u/wB/EM7czNRrrwa98dtgmT+eCDb0+cS8Gg53e
	1taj5KabL43aFqjX/Cvr9CQph0rz7HxiQlI9YcH6rJ+3letS79yaykl6uioUvk2uNyRsLq
	6CMXhXvm81oDh1gnuvhmVvw+mZS06RM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-Z5nZSZFDOty2pjFFgJ3e3Q-1; Thu, 29 Feb 2024 22:38:36 -0500
X-MC-Unique: Z5nZSZFDOty2pjFFgJ3e3Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0D6F185A785;
	Fri,  1 Mar 2024 03:38:35 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC46E492BE2;
	Fri,  1 Mar 2024 03:38:35 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id C87939CD3C; Thu, 29 Feb 2024 22:38:35 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo block-map: rename page state name from "UDS_FREE" to "FREE"
Date: Thu, 29 Feb 2024 22:38:35 -0500
Message-ID: <417ef622c5b4622fd970f9681d9b9f0cc2af70e2.1709264221.git.msakai@redhat.com>
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

From: Mike Snitzer <snitzer@kernel.org>

Only used for log message, but no need for "UDS_" prefix.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index cc87e1ac72b6..e3fadb5f2c2d 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -284,7 +284,7 @@ static const char * __must_check get_page_state_name(enum vdo_page_buffer_state
 {
 	int result;
 	static const char * const state_names[] = {
-		"UDS_FREE", "INCOMING", "FAILED", "RESIDENT", "DIRTY", "OUTGOING"
+		"FREE", "INCOMING", "FAILED", "RESIDENT", "DIRTY", "OUTGOING"
 	};
 
 	BUILD_BUG_ON(ARRAY_SIZE(state_names) != PAGE_STATE_COUNT);
-- 
2.42.0

