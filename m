Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686B1259C92
	for <dm-devel@lists.linux.dev>; Mon,  2 Feb 2026 21:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068413; cv=none; b=oEwEtNy2ZNjE5bcyJIPo+VzKxp2Rf0o7OAtcwXtJ/q3seeRg8SS/y5OSsN0UAgAtO+LpqpKOg9rN4hjvTzvkL6+KdNbF6sP8VZ6e73ETT3aVyEcrhZDG5f+LvKatlDBo7hAezW8iHwozFMOGzLOt2PXnMpu9DYaaKXfZKaKJdkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068413; c=relaxed/simple;
	bh=AUTqhUeKrkSw6xgBLGKfe8+rIFtAsftGVTPGhH0DOoo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=dlyIH/9Mha5z1laSt68n0JshAaVK1ugDCIViJ2/aVUwFS3T8C+d8nerzUhcR+zcZ7V8z8l7N89W/NPLoMWUQoVyEy+9mIgT1ZUEF4RKvohD26sHJ5kemulEtZcgWtM5AmNqdz57Rv/juq465uH80nxbzVGNYASBp4PcPrZkgwnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JUW2OcN6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JUW2OcN6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770068411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=h7RxOx/y5Z+GGwqLkByYEkbKAI3Oz0xNSQkfNiYDIYc=;
	b=JUW2OcN6rsnZ/Yv5QFLwRKXOtZU0oKTJ1ZBYMMVfrCIlWrQlB9h07B3AH6wuf5y1cApniM
	2TboCadYa8DJKDeta/7fBZe68VuMBEpN5mNjtPptJDUG0a+I4l3gOsP3fPwRWuU/EAM2JO
	q2+EAcEsDYWf8r+phCjKaOwkKFmb6Ok=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-9xCTLx3JNAiHosLxmE5MVA-1; Mon,
 02 Feb 2026 16:40:10 -0500
X-MC-Unique: 9xCTLx3JNAiHosLxmE5MVA-1
X-Mimecast-MFC-AGG-ID: 9xCTLx3JNAiHosLxmE5MVA_1770068409
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56CBC1954B1B;
	Mon,  2 Feb 2026 21:40:09 +0000 (UTC)
Received: from localhost (unknown [10.2.16.238])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7C0819560B2;
	Mon,  2 Feb 2026 21:40:08 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH multipath-tools] libmpathpersist: fix mpath_persistent_reserve_out(3) synopsis
Date: Mon,  2 Feb 2026 16:40:07 -0500
Message-ID: <20260202214007.429134-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1J0UmM02LUZOwhbUVQ2Qc58kxzbVcdtfycdqCSjgwEM_1770068409
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The argument list is copy-pasted from mpath_persistent_reserve_in(3)
instead of mpath_persistent_reserve_out(3). Use the correct argument
list from libmpathpersist/mpath_persist.h.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 libmpathpersist/mpath_persistent_reserve_out.3 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index 3dbeae1f..ab1f923e 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MPATH_PERSISTENT_RESERVE_OUT 3 2024-02-09 Linux
+.TH MPATH_PERSISTENT_RESERVE_OUT 3 2026-02-02 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -22,7 +22,7 @@ mpath_persistent_reserve_out \- send PROUT command to DM device
 .
 .B #include <mpath_persist.h>
 .P
-.BI "int mpath_persistent_reserve_out" "(int fd, int rq_servact, struct prin_resp *resp, int noisy, int verbose)"
+.BI "int mpath_persistent_reserve_out" "(int fd, int rq_servact, int rq_scope, unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy, int verbose)"
 .P
 .
 .
-- 
2.52.0

