Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEFF628
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 17:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710956604; cv=none; b=uNpvdggZ75vY8LRNq4w6+gI/BBmHpKpTLdVcOtjA1WrESWbpv/GB5/tOYe0433CUwkS/6pK3iHRnTxEozSq90J0VEJwn4uxh2iYNd1aZTnJxgpu1lb8PuNMLL+CrVtGJjBW37FzdoCsHbRy5RsdkZountG3VfjHkr2+sM8d/yqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710956604; c=relaxed/simple;
	bh=BtZOlmwYZwDsfSWoUZWTWgIFPlEQWU4eKSrg6AQqtZg=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=fd8bHD92E2ixtnXCS+xIh0g4P1O0zVKCAQAbmZ+F1F691cXQMBkFVVqh6B7d6WNNDi13XS3EhaAKsNSA1zBErYN8wCK3NRlMV6PPgtAugsb6Nsuvri+RiG8l002rQ9JUY1bwzsdL7jVYm2hdt5PLLgLXU6YK/S09aDWkyXv0qCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h9giK6HB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h9giK6HB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710956602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Y9xaiWTH03zLNxV2Kaw2TaGNs2+Tbk/Z8Ra1mEQR4oE=;
	b=h9giK6HBoJRLFU7ka1MTkbTE+p0RuctqXOXgIMJQyoGZ/Deyy1U+1A+S0WncgKsvAKw0/7
	GreBjU85KPdccfsFpnT1RosmK+7gRCbXU50WT88OSWQ8w4J84eMg0wbGFgjHZv1qNoe3JA
	0p5cfWwtddQ5WzaoMd75l50X2lPcI4k=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-k2Fr9_sxPVOo8GAfHhjzgg-1; Wed,
 20 Mar 2024 13:43:12 -0400
X-MC-Unique: k2Fr9_sxPVOo8GAfHhjzgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADEBC3802151
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 17:43:11 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A842A2166AE5;
	Wed, 20 Mar 2024 17:43:11 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 90F9C30BFECA; Wed, 20 Mar 2024 17:43:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 8D44E3FB4A;
	Wed, 20 Mar 2024 18:43:11 +0100 (CET)
Date: Wed, 20 Mar 2024 18:43:11 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm snapshot: add cond_resched to dm_exception_table_exit
Message-ID: <fab7e-7fb7-4d28-ac54-2141bbc6bfde@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There was reported lockup when we exit a snapshot with many exceptions.
Fix this by adding "cond_resched" to the loop that frees the exceptions.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-snap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c	2024-03-06 17:54:03.000000000 +0100
+++ linux-2.6/drivers/md/dm-snap.c	2024-03-20 18:38:20.000000000 +0100
@@ -684,8 +684,10 @@ static void dm_exception_table_exit(stru
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list)
+		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
 			kmem_cache_free(mem, ex);
+			cond_resched();
+		}
 	}
 
 	kvfree(et->table);

