Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DE0155321
	for <dm-devel@lists.linux.dev>; Wed,  7 Aug 2024 22:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723071560; cv=none; b=JrI6AUpJZPQEwaZytu/rGtT8EPMeWZIaUvNw7mq7uCjW/bOT5PoCEvDOZu8xBkg69hf+f8wlyn/EYRcIOo0E7o9MCMW/VuzwHsBIPzdAjK7gpxS8Tp1dsHI1uGtMjDn6Y+5C+V/M623yBjHLiLRpNFy4NOCyOlMwj0WJvuCaE44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723071560; c=relaxed/simple;
	bh=P5UpV1SGjAN85RjlpAsYMPpn5eiNSfP7HVZnPZgucwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BRUtlfnwEHci1CdWT5W3T1Ad9uDj7GGxswvU+ztWjltMx5+wmTI+QBbPyyNPZ87WJbhSOzsUs2kYw8tHRT6/BBvmpP5gOylGWd02AhNN7v1coh6RCE47zOYmLuJ2xLc9s1JCcunLHwxvztsXAP0iiDoUPhWjvhacNSdGdWfLzHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X+jFSwJy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X+jFSwJy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723071557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zzoUT5HGI9HthS6RDWn+s0AHowt0c4pXpGuBziBsiKY=;
	b=X+jFSwJyLwNNCEb3nhqXhy4rxK/LYQ+9oBqZ2C/9eOD+YQK3pfGXC1eHCN5DV0jtpqjfSt
	ZM9HHimis3udVkrRnFGmCMd/wRgdkIk/n9CTVd3FCsMKeeMlievDAGwJ/8XoV/UEUIjXfJ
	esv5TAJ1j3rBoL1RTtNx2L2vsidYCo8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-223-E07WlsFINGye0e4v8jo1-g-1; Wed,
 07 Aug 2024 18:59:14 -0400
X-MC-Unique: E07WlsFINGye0e4v8jo1-g-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDAB41944D39;
	Wed,  7 Aug 2024 22:59:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3AD4F19560AA;
	Wed,  7 Aug 2024 22:59:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 477MxA443266013
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Aug 2024 18:59:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 477MxApB3266012;
	Wed, 7 Aug 2024 18:59:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2] libmultipath: fix ontap prioritizer snprintf limits
Date: Wed,  7 Aug 2024 18:59:10 -0400
Message-ID: <20240807225910.3266004-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The ontap prioritizer functions dump_cdb() and process_sg_error() both
incorrectly set the snprintf() limits larger than the available space.
Instead of multiplying the number of elements to print by the size of an
element to calculate the limit, they multiplied the number of elements
to print by the maximum number of elements that the buffer could hold.

Fix this by making these functions use strbufs instead.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

changes in v2:
Use strbufs as suggested by Martin Wilck.

 libmultipath/prioritizers/ontap.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 117886ea..b508371d 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -23,6 +23,7 @@
 #include "prio.h"
 #include "structs.h"
 #include "unaligned.h"
+#include "strbuf.h"
 
 #define INQUIRY_CMD	0x12
 #define INQUIRY_CMDLEN	6
@@ -35,32 +36,33 @@
 static void dump_cdb(unsigned char *cdb, int size)
 {
 	int i;
-	char buf[10*5+1];
-	char * p = &buf[0];
+	STRBUF_ON_STACK(buf);
 
-	condlog(0, "- SCSI CDB: ");
-	for (i=0; i<size; i++) {
-		p += snprintf(p, 10*(size-i), "0x%02x ", cdb[i]);
+	for (i = 0; i < size; i++) {
+		if (print_strbuf(&buf, "0x%02x ", cdb[i]) < 0) {
+			condlog(0, "ontap prio: failed to dump SCSI CDB");
+			return;
+		}
 	}
-	condlog(0, "%s", buf);
+	condlog(0, "- SCSI CDB: %s", get_strbuf_str(&buf));
 }
 
 static void process_sg_error(struct sg_io_hdr *io_hdr)
 {
 	int i;
-	char buf[128*5+1];
-	char * p = &buf[0];
+	STRBUF_ON_STACK(buf);
 
 	condlog(0, "- masked_status=0x%02x, host_status=0x%02x, "
 		"driver_status=0x%02x", io_hdr->masked_status,
 		io_hdr->host_status, io_hdr->driver_status);
 	if (io_hdr->sb_len_wr > 0) {
-		condlog(0, "- SCSI sense data: ");
-		for (i=0; i<io_hdr->sb_len_wr; i++) {
-			p += snprintf(p, 128*(io_hdr->sb_len_wr-i), "0x%02x ",
-				      io_hdr->sbp[i]);
+		for (i = 0; i < io_hdr->sb_len_wr; i++) {
+			if (print_strbuf(&buf, "0x%02x ", io_hdr->sbp[i]) < 0) {
+				condlog(0, "ontap prio: failed to dump SCSI sense data");
+				return;
+			}
 		}
-		condlog(0, "%s", buf);
+		condlog(0, "- SCSI sense data: %s", get_strbuf_str(&buf));
 	}
 }
 
-- 
2.45.0

