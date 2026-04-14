Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF941DDA18
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 00:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126172; cv=none; b=XjXDp47xotRU2NukQwlcmDuNv2VIQu/F6jMgW4njxw7+qQjakkr12yy0uhSAX/AnYEYciqCHtBAQsIE4dySDFQc1jzf7Dip5zTn/n5c//Pt2i/Y10bWXEIsG6GE1bJG1rKEIdHcPGlcSdZOU5TIBugbEaPq5CzbUOtAjTWfb92I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126172; c=relaxed/simple;
	bh=8fXDxeTmMxhwow1M5hchJUf1OMkBFumWlMe6KZ5+umo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=NyV7+mx16SuSOSkanTWdmoQc5srOoZHdsQLyry67yJW8e9QL5aiuBzKyL+VSaUz0RD1uRbtOaUZIOT7lx9w7i47qUPEz+vcw8nOCFkY55VTSVzo2DQjWyrKiit1eZ/u3YQRuleEO5SF8MuXmeMz4qNWYo2yWKdfGl6HdwSGd4nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PPTPqGHw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PPTPqGHw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776126170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dujh8cnhmj46JPJbIpzxfAM/9ZMdECRNyBwQKHXMAlc=;
	b=PPTPqGHw0Lb1YZqq486l75L7Ix0/xST/Pm6ngiAM4LPmr9lEe9Sk2oUOjkMu9o8inKJ0m1
	KuH+X3Dme8o3Xh/MQ1olTD1dHtJ4Wlpmqd3+l6ao2PE52YRd7sIUHWWPPWLE/GZ+xPyWPm
	9AOcazvUrSUtN8siwT6D2qNsx06mmtw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-CmSllnDbO2CsvyNOp34p9A-1; Mon,
 13 Apr 2026 20:22:48 -0400
X-MC-Unique: CmSllnDbO2CsvyNOp34p9A-1
X-Mimecast-MFC-AGG-ID: CmSllnDbO2CsvyNOp34p9A_1776126167
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 10027180044D;
	Tue, 14 Apr 2026 00:22:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E2BF1955D88;
	Tue, 14 Apr 2026 00:22:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63E0MjMf1917482
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 20:22:45 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63E0Mj2w1917481;
	Mon, 13 Apr 2026 20:22:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH 04/10] dm-ima: don't copy the active table to the inactive table
Date: Mon, 13 Apr 2026 20:22:38 -0400
Message-ID: <20260414002244.1917447-5-bmarzins@redhat.com>
In-Reply-To: <20260414002244.1917447-1-bmarzins@redhat.com>
References: <20260414002244.1917447-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: K3tArMngFjd0j_ZiELvug5iBiaaGxvb8EqNoap2GSKE_1776126167
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If an inactive table was cleared, dm_ima_measure_on_table_clear() was
copying the ima.active_table to ima.inactive_table. This is not what
device-mapper does, and it makes the IMA measurements show an inactive
table when there isn't one. Also, once this is removed, the code no
longer needs to keep checking if the active and the inactive table point
to the same memory.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-ima.c | 64 +++++++--------------------------------------
 1 file changed, 10 insertions(+), 54 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 8b84b676cad4..c141068bc6b4 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -281,17 +281,13 @@ void dm_ima_measure_on_table_load(struct dm_table *table)
 	if (!digest_buf)
 		goto error;
 
-	if (table->md->ima.active_table.hash != table->md->ima.inactive_table.hash)
-		kfree(table->md->ima.inactive_table.hash);
-
+	kfree(table->md->ima.inactive_table.hash);
 	table->md->ima.inactive_table.hash = digest_buf;
 	table->md->ima.inactive_table.hash_len = strlen(digest_buf);
 	table->md->ima.inactive_table.num_targets = num_targets;
 
-	if (table->md->ima.active_table.device_metadata !=
-	    table->md->ima.inactive_table.device_metadata)
-		kfree(table->md->ima.inactive_table.device_metadata);
 
+	kfree(table->md->ima.inactive_table.device_metadata);
 	table->md->ima.inactive_table.device_metadata = device_data_buf;
 	table->md->ima.inactive_table.device_metadata_len = device_data_buf_len;
 
@@ -330,19 +326,9 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 	l += strlen(DM_IMA_VERSION_STR);
 
 	if (swap) {
-		if (md->ima.active_table.hash != md->ima.inactive_table.hash)
-			kfree(md->ima.active_table.hash);
-
-		md->ima.active_table.hash = NULL;
-		md->ima.active_table.hash_len = 0;
-
-		if (md->ima.active_table.device_metadata !=
-		    md->ima.inactive_table.device_metadata)
-			kfree(md->ima.active_table.device_metadata);
-
-		md->ima.active_table.device_metadata = NULL;
-		md->ima.active_table.device_metadata_len = 0;
-		md->ima.active_table.num_targets = 0;
+		kfree(md->ima.active_table.hash);
+		kfree(md->ima.active_table.device_metadata);
+		memset(&md->ima.active_table, 0, sizeof(md->ima.active_table));
 
 		if (md->ima.inactive_table.hash) {
 			md->ima.active_table.hash = md->ima.inactive_table.hash;
@@ -518,15 +504,10 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 	kfree(capacity_str);
 exit:
 	kfree(md->ima.active_table.device_metadata);
-
-	if (md->ima.active_table.device_metadata !=
-	    md->ima.inactive_table.device_metadata)
-		kfree(md->ima.inactive_table.device_metadata);
+	kfree(md->ima.inactive_table.device_metadata);
 
 	kfree(md->ima.active_table.hash);
-
-	if (md->ima.active_table.hash != md->ima.inactive_table.hash)
-		kfree(md->ima.inactive_table.hash);
+	kfree(md->ima.inactive_table.hash);
 
 	memset(&md->ima.active_table, 0, sizeof(md->ima.active_table));
 	memset(&md->ima.inactive_table, 0, sizeof(md->ima.inactive_table));
@@ -594,34 +575,9 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 	dm_ima_measure_data("dm_table_clear", device_table_data, l, noio);
 
 	if (new_map) {
-		if (md->ima.inactive_table.hash &&
-		    md->ima.inactive_table.hash != md->ima.active_table.hash)
-			kfree(md->ima.inactive_table.hash);
-
-		md->ima.inactive_table.hash = NULL;
-		md->ima.inactive_table.hash_len = 0;
-
-		if (md->ima.inactive_table.device_metadata &&
-		    md->ima.inactive_table.device_metadata != md->ima.active_table.device_metadata)
-			kfree(md->ima.inactive_table.device_metadata);
-
-		md->ima.inactive_table.device_metadata = NULL;
-		md->ima.inactive_table.device_metadata_len = 0;
-		md->ima.inactive_table.num_targets = 0;
-
-		if (md->ima.active_table.hash) {
-			md->ima.inactive_table.hash = md->ima.active_table.hash;
-			md->ima.inactive_table.hash_len = md->ima.active_table.hash_len;
-		}
-
-		if (md->ima.active_table.device_metadata) {
-			md->ima.inactive_table.device_metadata =
-				md->ima.active_table.device_metadata;
-			md->ima.inactive_table.device_metadata_len =
-				md->ima.active_table.device_metadata_len;
-			md->ima.inactive_table.num_targets =
-				md->ima.active_table.num_targets;
-		}
+		kfree(md->ima.inactive_table.hash);
+		kfree(md->ima.inactive_table.device_metadata);
+		memset(&md->ima.inactive_table, 0, sizeof(md->ima.inactive_table));
 	}
 
 	kfree(dev_name);
-- 
2.53.0

