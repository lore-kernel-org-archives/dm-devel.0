Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D9C3D9674
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 20:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791491299; cv=none; b=MWsK0lkfHzQCU8f7LT6aU6+uOYUq/xID+hXKuEulcvYQ8W/9A0lOMgvCWJ9ZzMSqHIAXNTHlJ6T/kMhsG49T9D5NKa5hzeNiY0HE2A6t7//lAKXlusLGoDFJmO1O5+/4IGyTU8xqIXHcL2lu4LYgp60oDq4b+aaFi/qdFhZ7/xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791491299; c=relaxed/simple;
	bh=GHuR9nTrbAPAoNjy1zchRr9SgK3/dr1VtMgVsLvKomg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=i+HGVZQTQeLaufsugHbk9zDldwouVW5TDMBq2lZwiPeotfC+ysrA6B8Z/LNgV3QWF6gQOIBM2SraqLL0lpDTKEpf+1szGOZB/cmp0znf20lbQpqSNF9n4cJbyO9de8gbSYxNgH9/JPSbCmKSaZMjzpw+a6ackFyhYkcelUP5AIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P1DVY/cJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P1DVY/cJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791491297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hurA8FhjJNR7GZ2xsYd7Ml1C2FXKdREFL0JhlHoZpOU=;
	b=P1DVY/cJojP4hQuaYIAHkDjPm1zbUjp624izq4PFk9i2XlZHtlRMe3hRY81VuheZLWdp9s
	990OR8CEFJZ1uWt5n7hul9jIFq8xr2SU5hheQwMIxDc4jNkgFQ0+7nYFzS5oZcNTyPYXo0
	LQquO0MwGGTE1Ph6USguouwDc/KXuUM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-Es_zwjpSMSWEMVvElOIQOw-1; Thu,
 08 Oct 2026 16:28:16 -0400
X-MC-Unique: Es_zwjpSMSWEMVvElOIQOw-1
X-Mimecast-MFC-AGG-ID: Es_zwjpSMSWEMVvElOIQOw_1791491295
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0685319540CA;
	Thu,  8 Oct 2026 20:28:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76F5B1956044;
	Thu,  8 Oct 2026 20:28:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 698KSDmH1976831
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Oct 2026 16:28:13 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 698KSDhB1976830;
	Thu, 8 Oct 2026 16:28:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 3/3] dm-mpath: check values in hst_status while holding spinlock
Date: Thu,  8 Oct 2026 16:28:09 -0400
Message-ID: <20261008202809.1976567-4-bmarzins@redhat.com>
In-Reply-To: <20261008202809.1976567-1-bmarzins@redhat.com>
References: <20261008202809.1976567-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9pXfumvvXAncK7OMh74bp7xanmD6rkhkmq1e3fOiX4w_1791491295
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

To keep the values of pi->historical_service_time,
pi->outstanding, and pi->stale_after consistent, get them while
holding a spin_lock in hst_status(), like all other accesses do.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-ps-historical-service-time.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
index e0103eefe28f..3ad40505ff46 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -202,6 +202,7 @@ static int hst_status(struct path_selector *ps, struct dm_path *path,
 {
 	unsigned int sz = 0;
 	struct path_info *pi;
+	unsigned long flags;
 
 	if (!path) {
 		struct selector *s = ps->context;
@@ -212,8 +213,10 @@ static int hst_status(struct path_selector *ps, struct dm_path *path,
 
 		switch (type) {
 		case STATUSTYPE_INFO:
+			spin_lock_irqsave(&pi->lock, flags);
 			DMEMIT("%llu %llu %llu ", pi->historical_service_time,
 			       pi->outstanding, pi->stale_after);
+			spin_unlock_irqrestore(&pi->lock, flags);
 			break;
 		case STATUSTYPE_TABLE:
 			DMEMIT("%u ", pi->repeat_count);
-- 
2.53.0

