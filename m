Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD8E4E36EA
	for <dm-devel@lists.linux.dev>; Fri,  9 Oct 2026 16:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791562571; cv=none; b=PCqA6VOlbd4KD7hcauiji+9b7H33yudOFwypTqAunjW9ymiiQ9Eo68lMKtY7Sqhv25WdBkVEq9Gcpeyg1JGBOAc6VpT81TprPQSazgdtTodNc5+1PMhK9BtATgfU0TIO61I4Ipu9SWW37rFoflO1HS0832OYU0vWWBv9TTjoBDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791562571; c=relaxed/simple;
	bh=pOHa0AVvz5XH/Myp8APuV7ZGGNrrDPN6U55OpUIzq14=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=GDhp0ztMi2OxnNvw5xqgbNRhqDRKG+PdrJyBhRELSrtkUYjkO+4tMaiXnCpDAjeGoK+qgDnArIY9dSLTLTieTvu5bjhktt2rTZY3Uepwna8p7GCoXhm/ggDveuyJjBPR9fQcbCvMPKdmvUlHd/IJITQJU0YBH96dfh8RKVUasVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OZNzD7Kz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OZNzD7Kz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791562569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=uIB5Dkwkb5owpKwnTn6lmtsxv61ssjwxNJ5nGnwE918=;
	b=OZNzD7Kz7VhDOobNqXDFDs4zls5n11lF4HBwqCynwIrL5gAwJOqPQm9GxRPtlxLfoPVn9W
	h8qqqGXtm0aMS+9MzUqy/ZzwG1QD8fgUhiH+EQSmbovkoQh9yGWsUAOVBIOTG5t0Xm2fLQ
	gPk1XFIEP2Ml/wmR5AatJbAwhGNUlHI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-214-ZdsbkCFaPleh_T_YCBK3LA-1; Fri,
 9 Oct 2026 16:16:07 +0000
X-MC-Unique: ZdsbkCFaPleh_T_YCBK3LA-1
X-Mimecast-MFC-AGG-ID: ZdsbkCFaPleh_T_YCBK3LA_1791562566
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7AB111955F25;
	Fri,  9 Oct 2026 16:16:06 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 082B51800579;
	Fri,  9 Oct 2026 16:16:04 +0000 (UTC)
Date: Fri, 9 Oct 2026 18:16:02 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-snapshot: make the chunk list sorted by the chunk
 number
Message-ID: <950224c8-a8b5-a7f5-e8ae-d0ad900c2612@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zcGqav-hiqW6sr87U45_vNhuw6vlu5GhSoa9IhxFTBA_1791562566
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Commit 8581b19eb2c5 ("dm-snapshot: fix 'scheduling while atomic' on
real-time kernels") replaced hlist_bl_for_each_entry with
hlist_for_each_entry, but the two iteration macros differ after the loop
ends: hlist_bl_for_each_entry leaves "e" pointing at the last element,
while hlist_for_each_entry() sets it to NULL.

The result is that the list is no longer sorted by chunk number as it was
intended to be. This bug doesn't cause data corruption because
dm_lookup_exception walks the full list.

Restore the invariant by tracking the list tail in the "prev" variable
and appending after it with hlist_add_behind.
											
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 8581b19eb2c5 ("dm-snapshot: fix 'scheduling while atomic' on real-time kernels")
Assisted-by: Claude:claude-opus-5

---
 drivers/md/dm-snap.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -766,7 +766,7 @@ static void dm_insert_exception(struct d
 				struct dm_exception *new_e)
 {
 	struct hlist_head *l;
-	struct dm_exception *e = NULL;
+	struct dm_exception *e = NULL, *prev = NULL;
 
 	l = &eh->table[exception_hash(eh, new_e->old_chunk)].head;
 
@@ -798,21 +798,23 @@ static void dm_insert_exception(struct d
 
 		if (new_e->old_chunk < e->old_chunk)
 			break;
+
+		prev = e;
 	}
 
 out:
-	if (!e) {
+	if (e && new_e->old_chunk < e->old_chunk) {
+		/* Add before an existing exception */
+		hlist_add_before(&new_e->hash_list, &e->hash_list);
+	} else if (prev) {
+		/* Add to l's tail: prev is the last exception in this slot */
+		hlist_add_behind(&new_e->hash_list, &prev->hash_list);
+	} else {
 		/*
 		 * Either the table doesn't support consecutive chunks or slot
 		 * l is empty.
 		 */
 		hlist_add_head(&new_e->hash_list, l);
-	} else if (new_e->old_chunk < e->old_chunk) {
-		/* Add before an existing exception */
-		hlist_add_before(&new_e->hash_list, &e->hash_list);
-	} else {
-		/* Add to l's tail: e is the last exception in this slot */
-		hlist_add_behind(&new_e->hash_list, &e->hash_list);
 	}
 }
 

