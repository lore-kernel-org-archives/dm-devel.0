Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9691633D4E9
	for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 19:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783970823; cv=none; b=PZKo3TeGeCfiA7GsRadF649imCMc+RTprV5RmSLak6WGMJr5OiB8DoIqdUGUl4udyU76EwjyZ3y15LWe1WrPlncqBF6+E5s2RbdN1GP0Yb0hM9n5SLWYdtO13+ovy0vi/854fFr2eMAun+xiEjo1ooN39EZUXtrnoEiwMgOtM3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783970823; c=relaxed/simple;
	bh=o+K7uIGmIYzgE+085al8OVtRGffUSeCJXNZI3an3lgk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=rtvcMSvnLMH88AUr1AT98My5gn0iCWuXQC9Qy0FZnQqnwevAX8s99yBBJpiCsJFq7q3OWrVHxI91ECSAWAObwNqnLWEW+UAZfQqC3AQn23Lp9/n3h2fAdcK0r5/xAog48OIjDcABT/Kh5If3enJEJs8G18HDyo6HmSb9S0Ls0+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ThaGmC8V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ThaGmC8V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783970821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=ghrZ/NbULhM/NbifhoFcLo3eKEsvJ+uUQdIFryRe2X8=;
	b=ThaGmC8V44UoamfhM1dml1Hzs34rUPFJSWZ2JMT6xCadLdnvnA0ID5WBI/CRKO+qByFMOG
	J0mysBBFhpAgFj2JXhPp7fiqWCQUPbKJZqkGATscbqpHOTFFKnqJwMKbl2+GmIBd2PDGH3
	7M4OCTINQCanfSOaa7ModRtfOr/yIs4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-537-1F0EW7tiNAm6WkGC6TIKwg-1; Mon,
 13 Jul 2026 15:26:58 -0400
X-MC-Unique: 1F0EW7tiNAm6WkGC6TIKwg-1
X-Mimecast-MFC-AGG-ID: 1F0EW7tiNAm6WkGC6TIKwg_1783970817
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 791221955D7E;
	Mon, 13 Jul 2026 19:26:57 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3ABB430002DA;
	Mon, 13 Jul 2026 19:26:56 +0000 (UTC)
Date: Mon, 13 Jul 2026 21:26:54 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm-verity: remove pointless nested "bio" declaration
Message-ID: <0e0ddb97-13cd-2cec-3de8-a05e7a823330@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DT5Dk26oIaqheGcYLNgdY9AT4oiixJl-koP0YLulS1c_1783970817
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Remove pointless declaration of "bio" and initialization using
"dm_bio_from_per_bio_data". The variable "bio" is already declared and
initialized in the upper block.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6

---
 drivers/md/dm-verity-target.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2026-07-09 21:38:36.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-target.c	2026-07-09 21:38:36.000000000 +0200
@@ -316,9 +316,7 @@ static int verity_verify_level(struct dm
 		else if (verity_handle_err(v,
 					   DM_VERITY_BLOCK_TYPE_METADATA,
 					   hash_block)) {
-			struct bio *bio;
 			io->had_mismatch = true;
-			bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 			dm_audit_log_bio(DM_MSG_PREFIX, "verify-metadata", bio,
 					 block, 0);
 			r = -EIO;

