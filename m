Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F19C130E4A
	for <dm-devel@lists.linux.dev>; Sat, 10 Aug 2024 02:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723257821; cv=none; b=gCGRQhe3cgV41xg382AgtnXhJM3wyk295OcJBmzbjzURjMB3RAhfgUCxknOi6/NkF7MjmLqCKaG48Ug88GpHDRb/R/zeOY0O1LwkbafmidNoh8CyDdloNDLgmCkd+/g2j5wRqjDPcvV3XCcQ+++0zjlu/TRRNbxg0KY0PrRu9OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723257821; c=relaxed/simple;
	bh=7KmsW8njG9IJnWZ9bSkXFFAD8sgPduJsOeMelhM/Vgs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k83pMXEwa30FWQD+H9UnYntvSxU6LClTabMMP+hc83IqY2T+GYIQn0yXDtfGUW5HSaNJPDDsoTS3786cFYFv/25xeWOXPeCygSlF2ZrtsJDy+XdBLwITpOBvSD7cdzShVOpcrEd2elZ74g0jvq8kOX7AW/5xKyR1hWOcarcj+zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KGg7E7nS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KGg7E7nS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723257818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Rr+REJ6hV3/XCmySQgp5riN4yzGbaqjnCdPi9h3/M2w=;
	b=KGg7E7nSHMqzD6bbuL438aqVnVZqUYCj3ZnxaAppYmFuVqykL/DcziTS+1RCzvXb8fIfUB
	gzmk9MxboDLSXe7FwUYCF13HM7W5+/H2ZrQLbl/b+CL9s6fBZKUFa9CVUH6YTzxVNNpM1Z
	SeqCEMHYnny0zToRFyhbzlSFGH/sDpI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-132-XhBLFRPXPUmbtQ2tayxjFg-1; Fri,
 09 Aug 2024 22:43:36 -0400
X-MC-Unique: XhBLFRPXPUmbtQ2tayxjFg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D33711956095
	for <dm-devel@lists.linux.dev>; Sat, 10 Aug 2024 02:43:35 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 536071953BB7;
	Sat, 10 Aug 2024 02:43:35 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id A3B535475B; Fri,  9 Aug 2024 22:43:34 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: add dmsetup message for returning configuration info
Date: Fri,  9 Aug 2024 22:43:34 -0400
Message-ID: <c2284cb1dec109333a8df4aaee360f0d018aace2.1723249027.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Bruce Johnston <bjohnsto@redhat.com>

Add a new dmsetup message called config, which will return
useful configuration information for the vdo volume and
the uds index associated with it. The output is a YAML
string, and contains a version number to allow future
additions to the content.

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 .../admin-guide/device-mapper/vdo.rst         |  7 ++-
 drivers/md/dm-vdo/dm-vdo-target.c             |  5 +-
 drivers/md/dm-vdo/message-stats.c             | 48 +++++++++++++++++++
 drivers/md/dm-vdo/message-stats.h             |  1 +
 4 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/vdo.rst b/Documentation/admin-guide/device-mapper/vdo.rst
index c69ac186863a..a14e6d3e787c 100644
--- a/Documentation/admin-guide/device-mapper/vdo.rst
+++ b/Documentation/admin-guide/device-mapper/vdo.rst
@@ -251,7 +251,12 @@ The messages are:
 		by the vdostats userspace program to interpret the output
 		buffer.
 
-        dump:
+	config:
+		Outputs useful vdo configuration information. Mostly used
+		by users who want to recreate a similar VDO volume and
+		want to know the creation configuration used.
+
+	dump:
 		Dumps many internal structures to the system log. This is
 		not always safe to run, so it should only be used to debug
 		a hung vdo. Optional parameters to specify structures to
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index af77084969e0..ed1d775de0d3 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -1105,6 +1105,9 @@ static int vdo_message(struct dm_target *ti, unsigned int argc, char **argv,
 	if ((argc == 1) && (strcasecmp(argv[0], "stats") == 0)) {
 		vdo_write_stats(vdo, result_buffer, maxlen);
 		result = 1;
+	} else if ((argc == 1) && (strcasecmp(argv[0], "config") == 0)) {
+		vdo_write_config(vdo, &result_buffer, &maxlen);
+		result = 1;
 	} else {
 		result = vdo_status_to_errno(process_vdo_message(vdo, argc, argv));
 	}
@@ -2832,7 +2835,7 @@ static void vdo_resume(struct dm_target *ti)
 static struct target_type vdo_target_bio = {
 	.features = DM_TARGET_SINGLETON,
 	.name = "vdo",
-	.version = { 9, 0, 0 },
+	.version = { 9, 1, 0 },
 	.module = THIS_MODULE,
 	.ctr = vdo_ctr,
 	.dtr = vdo_dtr,
diff --git a/drivers/md/dm-vdo/message-stats.c b/drivers/md/dm-vdo/message-stats.c
index 2802cf92922b..75dfcd7c5f63 100644
--- a/drivers/md/dm-vdo/message-stats.c
+++ b/drivers/md/dm-vdo/message-stats.c
@@ -4,6 +4,7 @@
  */
 
 #include "dedupe.h"
+#include "indexer.h"
 #include "logger.h"
 #include "memory-alloc.h"
 #include "message-stats.h"
@@ -430,3 +431,50 @@ int vdo_write_stats(struct vdo *vdo, char *buf, unsigned int maxlen)
 	vdo_free(stats);
 	return VDO_SUCCESS;
 }
+
+static void write_index_memory(u32 mem, char **buf, unsigned int *maxlen)
+{
+	char *prefix = "memorySize : ";
+
+	/* Convert index memory to fractional value */
+	if (mem == (u32)UDS_MEMORY_CONFIG_256MB)
+		write_string(prefix, "0.25, ", NULL, buf, maxlen);
+	else if (mem == (u32)UDS_MEMORY_CONFIG_512MB)
+		write_string(prefix, "0.50, ", NULL, buf, maxlen);
+	else if (mem == (u32)UDS_MEMORY_CONFIG_768MB)
+		write_string(prefix, "0.75, ", NULL, buf, maxlen);
+	else
+		write_u32(prefix, mem, ", ", buf, maxlen);
+}
+
+static void write_index_config(struct index_config *config, char **buf,
+			       unsigned int *maxlen)
+{
+	write_string("index :  ", "{ ", NULL, buf, maxlen);
+	/* index mem size */
+	write_index_memory(config->mem, buf, maxlen);
+	/* whether the index is sparse or not */
+	write_bool("isSparse : ", config->sparse, ", ", buf, maxlen);
+	write_string(NULL, "}", ", ", buf, maxlen);
+}
+
+int vdo_write_config(struct vdo *vdo, char **buf, unsigned int *maxlen)
+{
+	struct vdo_config *config = &vdo->states.vdo.config;
+
+	write_string(NULL, "{ ", NULL, buf, maxlen);
+	/* version */
+	write_u32("version : ", 1, ", ", buf, maxlen);
+	/* physical size */
+	write_block_count_t("physicalSize : ", config->physical_blocks * VDO_BLOCK_SIZE, ", ",
+			    buf, maxlen);
+	/* logical size */
+	write_block_count_t("logicalSize : ", config->logical_blocks * VDO_BLOCK_SIZE, ", ",
+			    buf, maxlen);
+	/* slab size */
+	write_block_count_t("slabSize : ", config->slab_size, ", ", buf, maxlen);
+	/* index config */
+	write_index_config(&vdo->geometry.index_config, buf, maxlen);
+	write_string(NULL, "}", NULL, buf, maxlen);
+	return VDO_SUCCESS;
+}
diff --git a/drivers/md/dm-vdo/message-stats.h b/drivers/md/dm-vdo/message-stats.h
index f7fceca9acab..f9c95eff569d 100644
--- a/drivers/md/dm-vdo/message-stats.h
+++ b/drivers/md/dm-vdo/message-stats.h
@@ -8,6 +8,7 @@
 
 #include "types.h"
 
+int vdo_write_config(struct vdo *vdo, char **buf, unsigned int *maxlen);
 int vdo_write_stats(struct vdo *vdo, char *buf, unsigned int maxlen);
 
 #endif /* VDO_MESSAGE_STATS_H */
-- 
2.45.2

