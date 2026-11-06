Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990890;
	b=EBSHngXNSRzHW4wQYiSYE5NTWvc/ZQw+H+bEcSfZfZbOpWjwATmbFL+JOTIXQfXI3w6d
	 IUJ2jefQllGPcXnpqJBrl/t5rSAWNSUU1rsBqOHHhgGstvSVcbvCYsf3vvfYINYmqfovK
	 KxMZFhzW/BgJV64z6z6MHE2YzL2S9MfbqBi2c6EQlCvKV3TB7ZV0hDa6uQimeonUNiSi3
	 OkPP/vtTaOgd3gyH96+olnSTnQein6gndpCTQPdXLSR2K53jVnq1lcOnWabfVma3ORbwZ
	 owYijfOgxvJzc8ztDSFGWZ2KDZpIQUDGeIM7n196Y1DTvfyq4sHHHaBcSYEtn6NHexQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990890;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=kVvLarwstRwDpgCsf7T+jERD5uwv4AD0CYg3aapd6hc=;
	b=1IC727f2LVhn/H+JBVYZLjT6qjpt8Y7jd+SzqDT+40GhzsD+iqkMAYg4bhCko/l0Il5S
	 BXgu2F0ZZaAohK7N/COR/iKTfLlubALrzsg5JkLiekSLTHOENncJbyRMHE2/UL0SG/yDG
	 A2dmbNfea6xucRY5NoIznXOwkdM08sLTMYtHKiHQdS7WTsFWBdyKGs9TYZshPbj0t9hmJ
	 bvQMoCatOiEsM+6aktMYxOgbGitwrUo1kxV9FUuLAiJy3Y4QkiqAvozfFma6VctDTrtMi
	 qgUZ6UWZTpszriqA0dueZYPGvDHHu7N7QjaCWp2J4SCD1p3hPErHMPDms23tv/g7kmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=N4K8lJh1;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D8A606A326
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:48:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99D8A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=N4K8lJh1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793990888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=kVvLarwstRwDpgCsf7T+jERD5uwv4AD0CYg3aapd6hc=;
	b=N4K8lJh1LRBSaFtGZ6WD7iqo67ObHfW+gE6GQEg6QbYg1XZ8mY5ejF4P4ki2kVc4RX7s0w
	X7yDK+HrItv7ow+F5kjHX+4QlN4GlAlfP7B7PceiKgUoB15HWURwNYRFvSO821BbjqHAU7
	KFaun75qy1Pt28maCLibfzp13lLf9t4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-270-lI8hjqIhO-mGu7D9r-_DBA-1; Fri,
 06 Nov 2026 13:48:07 -0500
X-MC-Unique: lI8hjqIhO-mGu7D9r-_DBA-1
X-Mimecast-MFC-AGG-ID: lI8hjqIhO-mGu7D9r-_DBA_1793990886
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E60B1954B0B;
	Fri,  6 Nov 2026 18:48:06 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFE46187C368;
	Fri,  6 Nov 2026 18:48:04 +0000 (UTC)
Date: Fri, 6 Nov 2026 19:48:02 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm persistent data: don't ignore writeback errors
Message-ID: <464be18e-32a8-3667-6758-86253ad2f058@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Haj2Up9IhzXn5pX19ibpNB8yCMAC7_ddYaTYrGgpPMQ_1793990886
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

An error returned by ie_cache_writeback could be silently overwritten by
another successful ie_cache_writeback. This commit fixes disk_ll_commit,
so that it doesn't ignore the error and returns it immediatelly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 6b06dd5a9722 ("dm space map disk: cache a small number of index entries")

---
 drivers/md/persistent-data/dm-space-map-common.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/persistent-data/dm-space-map-common.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-space-map-common.c
+++ linux-2.6/drivers/md/persistent-data/dm-space-map-common.c
@@ -1190,17 +1190,20 @@ static dm_block_t disk_ll_max_entries(st
 
 static int disk_ll_commit(struct ll_disk *ll)
 {
-	int r = 0;
+	int r;
 	unsigned int i;
 
 	for (i = 0; i < IE_CACHE_SIZE; i++) {
 		struct ie_cache *iec = ll->ie_cache + i;
 
-		if (iec->valid && iec->dirty)
+		if (iec->valid && iec->dirty) {
 			r = ie_cache_writeback(ll, iec);
+			if (unlikely(r))
+				return r;
+		}
 	}
 
-	return r;
+	return 0;
 }
 
 int sm_ll_new_disk(struct ll_disk *ll, struct dm_transaction_manager *tm)

