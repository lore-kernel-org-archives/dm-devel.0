Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5C03A9BF3
	for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 20:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762894383; cv=none; b=cG4L66rwz9/guMP2TlSwV0BKlH/5aVOzDMdJbjkKdMyDmprj6rvCN7GCWt41s5vAy4sJYQOvf3JfiXQAeZjfJj/kX6FOFV3SWdG0HqK325CqxrbPVyBC2Dv/rePwy+NRUMnRVZOETEhiZyWCT4MGJ4Kevvhx51IqTarpa0/Pcps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762894383; c=relaxed/simple;
	bh=5/jdzGCgYCKJEowZSC5fNyKsS2POyg8CI0/820MCKiU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=eU+ZDeahNkru/5Cn3NTN5i1MPFL8UyNvQ4OViPxmYopJJfPYGsUt3XYE9PMyZiQ6N9gwTSl4xcdOM02+2LhvbVrko29Du2XBI6YFbOV0yvFDhHCKLzCyA/p/paa1x5NqH+oV7lS+omyesgw3+CrGrWOp2D6euihhYweiIAABI9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NIJNGtpz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NIJNGtpz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762894380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Gg7nsRwmiwImNvLudRgE7XDUOAYB/QgpY56MTPIhAXc=;
	b=NIJNGtpz3hqRmpKkep8zKlLVjkeK6R81bBvNG0abkWenLPGQFDWvP2sbc1FpfG82nrC2Zj
	NfWFyrTZu3el8S3Pv5m7K4ADvDeo1ZGBwg8CbliQtMm1UvDFXTnwhy4Gnjh2hIcu+ZlfRG
	BFCnJqeWQzyQhVJZTv+NOe5sKT+AbFQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-HOtKbfAOP9276uqBMUrLQQ-1; Tue,
 11 Nov 2025 15:52:57 -0500
X-MC-Unique: HOtKbfAOP9276uqBMUrLQQ-1
X-Mimecast-MFC-AGG-ID: HOtKbfAOP9276uqBMUrLQQ_1762894376
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2081C1956096;
	Tue, 11 Nov 2025 20:52:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90D1F180049F;
	Tue, 11 Nov 2025 20:52:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5ABKqs4k629053
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 15:52:54 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5ABKqreF629052;
	Tue, 11 Nov 2025 15:52:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2] mpathpersist: Fix REPORT CAPABILITIES output
Date: Tue, 11 Nov 2025 15:52:53 -0500
Message-ID: <20251111205253.629044-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ti7WJ7TdmDVVwXAIH6OKnTvTx53oldTgWXFf3Iiejdo_1762894376
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

mpathpersist was incorrectly parsing the REPORT CAPABILITES service
action output. In reality, the type mask is two bytes where the type
information is stored in bits 7, 6, 5, 3, & 1 (0xea) of the first byte
and bit 0 (0x01) of the second byte. libmpathpersist was treating these
two bytes as a big endian 16 bit number, but mpathpersist was looking
for bits in that number as if it was little endian number.

Ideally, libmpathpersist would treat prin_capdescr.pr_type_mask as
two bytes, like it does for the flags. But we already expose this
as a 16 bit number, where we treated the input bytes as a big endian
number. There's no great reason to mess with the libmpathpersist API,
when we can just make mpathpersist treat this data like libmpathpersist
provides it. So, fix mpathpersist to print the data out correctly.

Additionally, instead of printing a 1 or a 0 to indicate if a type was
supported or not, it was printing the value of the type flag. Also,
Persist Through Power Loss Capable (PTPL_C) was being reported if any
bit in flags[0] was set. Fix these as well. Reformat all of the
capability printing lines, since it is less confusing than only
reformatting some of them.

Fixes: ae4e8a6 ("mpathpersist: Add new utility for managing persistent reservation on dm multipath device")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Changes from v1 (based on suggetions from Martin Wilck):
- Added a comment to mpath_persist.h explaining how the bits in pr_type_mask
  work.
- Fixed the output for PTPL_C

 libmpathpersist/mpath_persist.h |  4 ++-
 mpathpersist/main.c             | 43 +++++++++++++++++++++++----------
 2 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 449e2825..a4edb83b 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -113,7 +113,9 @@ struct prin_capdescr
 {
 	uint16_t length;
 	uint8_t  flags[2];
-	uint16_t pr_type_mask;
+	uint16_t pr_type_mask; /* The two bytes of the type mask are treated
+				  as a single big-endian number. So the valid
+				  type bits are 0xea01 */
 	uint16_t _reserved;
 };
 
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 97fd5a43..fea5a9cb 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -748,25 +748,42 @@ void mpath_print_buf_readcap( struct prin_resp *pr_buff)
 
 	printf("Report capabilities response:\n");
 
-	printf("  Compatible Reservation Handling(CRH): %d\n", !!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x10));
-	printf("  Specify Initiator Ports Capable(SIP_C): %d\n",!!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x8));
-	printf("  All Target Ports Capable(ATP_C): %d\n",!!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x4 ));
-	printf("  Persist Through Power Loss Capable(PTPL_C): %d\n",!!(pr_buff->prin_descriptor.prin_readcap.flags[0]));
-	printf("  Type Mask Valid(TMV): %d\n", !!(pr_buff->prin_descriptor.prin_readcap.flags[1] & 0x80));
-	printf("  Allow Commands: %d\n", !!(( pr_buff->prin_descriptor.prin_readcap.flags[1] >> 4) & 0x7));
+	printf("  Compatible Reservation Handling(CRH): %d\n",
+	       !!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x10));
+	printf("  Specify Initiator Ports Capable(SIP_C): %d\n",
+	       !!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x8));
+	printf("  All Target Ports Capable(ATP_C): %d\n",
+	       !!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x4));
+	printf("  Persist Through Power Loss Capable(PTPL_C): %d\n",
+	       !!(pr_buff->prin_descriptor.prin_readcap.flags[0] & 0x1));
+	printf("  Type Mask Valid(TMV): %d\n",
+	       !!(pr_buff->prin_descriptor.prin_readcap.flags[1] & 0x80));
+	printf("  Allow Commands: %d\n",
+	       !!((pr_buff->prin_descriptor.prin_readcap.flags[1] >> 4) & 0x7));
 	printf("  Persist Through Power Loss Active(PTPL_A): %d\n",
-			!!(pr_buff->prin_descriptor.prin_readcap.flags[1] & 0x1));
+	       !!(pr_buff->prin_descriptor.prin_readcap.flags[1] & 0x1));
 
 	if(pr_buff->prin_descriptor.prin_readcap.flags[1] & 0x80)
 	{
 		printf("    Support indicated in Type mask:\n");
 
-		printf("      %s: %d\n", pr_type_strs[7], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x80);
-		printf("      %s: %d\n", pr_type_strs[6], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x40);
-		printf("      %s: %d\n", pr_type_strs[5], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x20);
-		printf("      %s: %d\n", pr_type_strs[3], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x8);
-		printf("      %s: %d\n", pr_type_strs[1], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x2);
-		printf("      %s: %d\n", pr_type_strs[8], pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x100);
+		printf("      %s: %d\n", pr_type_strs[7],
+		       !!(pr_buff->prin_descriptor.prin_readcap.pr_type_mask &
+			  0x8000));
+		printf("      %s: %d\n", pr_type_strs[6],
+		       !!(pr_buff->prin_descriptor.prin_readcap.pr_type_mask &
+			  0x4000));
+		printf("      %s: %d\n", pr_type_strs[5],
+		       !!(pr_buff->prin_descriptor.prin_readcap.pr_type_mask &
+			  0x2000));
+		printf("      %s: %d\n", pr_type_strs[3],
+		       !!(pr_buff->prin_descriptor.prin_readcap.pr_type_mask &
+			  0x800));
+		printf("      %s: %d\n", pr_type_strs[1],
+		       !!(pr_buff->prin_descriptor.prin_readcap.pr_type_mask &
+			  0x200));
+		printf("      %s: %d\n", pr_type_strs[8],
+		       !!(pr_buff->prin_descriptor.prin_readcap.pr_type_mask & 0x1));
 	}
 }
 
-- 
2.50.1

