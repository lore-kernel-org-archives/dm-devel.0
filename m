Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452F6145B11
	for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 19:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783970621; cv=none; b=c7YodqUhPTOQRoXWfTjy4rY89hQ8YvFgErotRFtUzbDcDdPsm4hUiqT6z2PrF2Jym7dm81yMn4uxeMcQriGGYgjCFYjWomihoLCGyHk5kzrgR/Zoke/CLdIkj1zKpMPelQSnE4mDOD39DI+fR/LAd3Ocd7/oU1PhN3LV7ZChrRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783970621; c=relaxed/simple;
	bh=Fybb8vX55wzr1j6GqMQ6RPr8uWTevtmIbi6BI6VFnb8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=DUf4VAe9A2Pfs3ZAadyxn89y0NcsyrUt5zlDn+IKN6Jq+ocL2/+wUX8pgTIylwFwqP+9Z0Rvd9OeV85XbNgCwUs8v1xd/hj4/XiSeFCFGZ6aC3S1AuLDKEmIU0gcqzwW1PxsaBrOznL6uPwmwRfGnmBFvxolvwiTkaPDa5Aumog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MmFQpJ+k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MmFQpJ+k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783970619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=HXwMvTKRsdl18E3/1YpDMR4A1ni3KpAWbmm0wkcab3I=;
	b=MmFQpJ+kxwWT/lD2dsv8/Hlt9M8q1vrxI0lXap2F6k83oOpW8AtWxqWRtvMseJXeauUJTB
	tEh/WMaLCB2xhxFPgSAuuagda3W9sc2qX75ioWi+JV+Uu/aJFBVqAo39Ah+rr575ZHzTLR
	FjZUpCyPo1rYyoT4NRHGbaurwNFgZ2Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-VZWB-ufGP-OD0bTv7O0CAA-1; Mon,
 13 Jul 2026 15:23:35 -0400
X-MC-Unique: VZWB-ufGP-OD0bTv7O0CAA-1
X-Mimecast-MFC-AGG-ID: VZWB-ufGP-OD0bTv7O0CAA_1783970614
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFC491955D5E;
	Mon, 13 Jul 2026 19:23:34 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FB1E1800661;
	Mon, 13 Jul 2026 19:23:32 +0000 (UTC)
Date: Mon, 13 Jul 2026 21:23:27 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: fix error message
Message-ID: <6d0feb4b-78f4-62ed-1ad4-114c38adcdcf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Lg76HpKFx9sMNqOjXO4_GMWYjfIp9O_fMStDLyOlUjM_1783970614
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Change "reading tags" to "writing tags" because the error is reported
when writing fails.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6

---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2026-07-13 20:59:40.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2026-07-13 20:59:40.000000000 +0200
@@ -3040,7 +3040,7 @@ static void do_journal_write(struct dm_i
 				r = dm_integrity_rw_tag(ic, journal_entry_tag(ic, je2), &metadata_block, &metadata_offset,
 							ic->tag_size, TAG_WRITE);
 				if (unlikely(r))
-					dm_integrity_io_error(ic, "reading tags", r);
+					dm_integrity_io_error(ic, "writing tags", r);
 			}
 
 			atomic_inc(&comp.in_flight);

