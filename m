Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D027639FE6
	for <dm-devel@lists.linux.dev>; Tue,  9 Jan 2024 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iYtTXRXw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704812279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=nevjKpPPtQvHvudf62uG1XMskXDqqLQjiV7rsJMn2go=;
	b=iYtTXRXwI0XyGfKiQcHywcV7UZDaT3xway4TYwqTxcqMks/WZyGhaB608QI3uUdbbvvTi8
	M/mdCVgZ2rr/KrsHKddD0c5kqEi6YUWXWj/C+712eX/NSz81VRaB+b2PQE93OCruu/zPrK
	5CGm0f0glN5muL572D7D1iAGAxrsW6U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-jtLjmi2nMtuKq1Am3c3uMQ-1; Tue, 09 Jan 2024 09:57:58 -0500
X-MC-Unique: jtLjmi2nMtuKq1Am3c3uMQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2974A831523
	for <dm-devel@lists.linux.dev>; Tue,  9 Jan 2024 14:57:57 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 248B81C060B1;
	Tue,  9 Jan 2024 14:57:57 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 0A4DC30C1C03; Tue,  9 Jan 2024 14:57:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 05F0E3FB48;
	Tue,  9 Jan 2024 15:57:57 +0100 (CET)
Date: Tue, 9 Jan 2024 15:57:56 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: limit the number of targets and parameter size area
Message-ID: <1df262b4-e47e-2ff4-faa-14899f2b289f@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The kvmalloc function fails with a warning if the size is larger than
INT_MAX. The warning was triggered by a syscall testing robot.

In order to avoid the warning, this commit limits the number of targets to
1048576 and the size of the parameter area to 1073741824.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-core.h  |    2 ++
 drivers/md/dm-ioctl.c |    3 ++-
 drivers/md/dm-table.c |    9 +++++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h	2024-01-09 12:03:27.000000000 +0100
+++ linux-2.6/drivers/md/dm-core.h	2024-01-09 12:03:27.000000000 +0100
@@ -22,6 +22,8 @@
 #include "dm-ima.h"
 
 #define DM_RESERVED_MAX_IOS		1024
+#define DM_MAX_TARGETS			1048576
+#define DM_MAX_TARGET_PARAMS		1024
 
 struct dm_io;
 
Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2024-01-09 12:03:27.000000000 +0100
+++ linux-2.6/drivers/md/dm-ioctl.c	2024-01-09 12:03:27.000000000 +0100
@@ -1941,7 +1941,8 @@ static int copy_params(struct dm_ioctl _
 			   minimum_data_size - sizeof(param_kernel->version)))
 		return -EFAULT;
 
-	if (param_kernel->data_size < minimum_data_size) {
+	if (unlikely(param_kernel->data_size < minimum_data_size) ||
+	    unlikely(param_kernel->data_size > DM_MAX_TARGETS * DM_MAX_TARGET_PARAMS)) {
 		DMERR("Invalid data size in the ioctl structure: %u",
 		      param_kernel->data_size);
 		return -EINVAL;
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2024-01-09 12:03:27.000000000 +0100
+++ linux-2.6/drivers/md/dm-table.c	2024-01-09 12:03:27.000000000 +0100
@@ -129,7 +129,12 @@ static int alloc_targets(struct dm_table
 int dm_table_create(struct dm_table **result, blk_mode_t mode,
 		    unsigned int num_targets, struct mapped_device *md)
 {
-	struct dm_table *t = kzalloc(sizeof(*t), GFP_KERNEL);
+	struct dm_table *t;
+
+	if (num_targets > DM_MAX_TARGETS)
+		return -EOVERFLOW;
+
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
 
 	if (!t)
 		return -ENOMEM;
@@ -144,7 +149,7 @@ int dm_table_create(struct dm_table **re
 
 	if (!num_targets) {
 		kfree(t);
-		return -ENOMEM;
+		return -EOVERFLOW;
 	}
 
 	if (alloc_targets(t, num_targets)) {

