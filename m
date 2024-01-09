Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEF436AFB
	for <dm-devel@lists.linux.dev>; Tue,  9 Jan 2024 14:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TQpxdeFV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704812357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=sFROaWggJRTqxnH9pKODpUxaM6R0grbbpTq3bPr9C9g=;
	b=TQpxdeFVhqz5J6/r4qz9/xzUoEANP+DZN3IVay2Rq7YbqOwilVtCxpptakGRJcfM4/esx7
	LwpgpxqTXnHx8Chrlyz85gYf6uYlzVSqcnz/DtiC5EJetqt3v1DwehgKXy6SnhiKNstsLt
	kQg2DtbNPs9rKFbdJwsnWSfvMdFqFV4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-xZFH37g2N8iF9WSQwgsX2A-1; Tue, 09 Jan 2024 09:59:15 -0500
X-MC-Unique: xZFH37g2N8iF9WSQwgsX2A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6E01185A789
	for <dm-devel@lists.linux.dev>; Tue,  9 Jan 2024 14:59:15 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A16D82166B32;
	Tue,  9 Jan 2024 14:59:15 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 9921930C1C03; Tue,  9 Jan 2024 14:59:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 980563FB48;
	Tue,  9 Jan 2024 15:59:15 +0100 (CET)
Date: Tue, 9 Jan 2024 15:59:15 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: limit the number of entries
Message-ID: <f57e6e74-ad62-6eb8-76f7-57a220f7ebeb@redhat.com>
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

The kvmalloc function fails with a warning if the size is larger than
INT_MAX. Linus said that there should be limits that prevent this warning
from being hit. This commit adds the limits to the dm-stats subsystem.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stats.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/drivers/md/dm-stats.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stats.c	2024-01-09 11:50:31.000000000 +0100
+++ linux-2.6/drivers/md/dm-stats.c	2024-01-09 11:57:10.000000000 +0100
@@ -66,6 +66,9 @@ struct dm_stats_last_position {
 	unsigned int last_rw;
 };
 
+#define DM_STAT_MAX_ENTRIES		8388608
+#define DM_STAT_MAX_HISTOGRAM_ENTRIES	134217728
+
 /*
  * A typo on the command line could possibly make the kernel run out of memory
  * and crash. To prevent the crash we account all used memory. We fail if we
@@ -285,6 +288,9 @@ static int dm_stats_create(struct dm_sta
 	if (n_entries != (size_t)n_entries || !(size_t)(n_entries + 1))
 		return -EOVERFLOW;
 
+	if (n_entries > DM_STAT_MAX_ENTRIES)
+		return -EOVERFLOW;
+
 	shared_alloc_size = struct_size(s, stat_shared, n_entries);
 	if ((shared_alloc_size - sizeof(struct dm_stat)) / sizeof(struct dm_stat_shared) != n_entries)
 		return -EOVERFLOW;
@@ -297,6 +303,9 @@ static int dm_stats_create(struct dm_sta
 	if (histogram_alloc_size / (n_histogram_entries + 1) != (size_t)n_entries * sizeof(unsigned long long))
 		return -EOVERFLOW;
 
+	if ((n_histogram_entries + 1) * (size_t)n_entries > DM_STAT_MAX_HISTOGRAM_ENTRIES)
+		return -EOVERFLOW;
+
 	if (!check_shared_memory(shared_alloc_size + histogram_alloc_size +
 				 num_possible_cpus() * (percpu_alloc_size + histogram_alloc_size)))
 		return -ENOMEM;

