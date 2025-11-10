Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885C3242D60
	for <dm-devel@lists.linux.dev>; Mon, 10 Nov 2025 21:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762811527; cv=none; b=mQBbKHzfGHvW0aAsdZZKhz5nrLgbWWjc6PMJ4IQzAEZb5ZxrAL+yo7WrBrrV0FwlCSHqg3+4Az/j6FSPhqcfcTY96rBYA0tqDS/N2BUqSGK+xMLlRoiKNugOqP5eabRTJGKwXvSAnct7mwM7iDYEOOGMaMC99TA3VdhClzvyNEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762811527; c=relaxed/simple;
	bh=B43tbj495XoHi1DShb7fhgA/HL7u4vZoBSVUqAn7aeg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=lPRRWYjsgC1qtVHbXp926tyf/FsawNoYxqw/dFpw1i37l5i39NMaZXM3uHwuPMKQboK8hwgDbIEm7Ewi2F4voIbBZ1v40wXOcGkQqcFqzaikJGlcqhChlN7XBAuc7HWwy32wrBunKQ5TpUOTRgq+lv3Vymr6V3GUdEDmAyfSoGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QoByFWMl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QoByFWMl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762811523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=h+cLMHcZqRnVKPrnDSCvpxkwnDyTgXsU0RHOUr0DYWY=;
	b=QoByFWMlpWjhp6uWjO5uQdTCWu9S32DLFWFQz82OaChxKU2Ow975vA7j9oqs9baoxkhTz9
	sb9xHYSo0xc2D20Ny3W7wMqM3mc64AHPZJ4GYapJsQMrU0ue8ot5QAihAGwJ1p3BnplaFo
	0dB54y7zqcCN7nI+gwkGrVZrkDBHRz8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-RZ3zgKvTN7e_O8q8BJ_Peg-1; Mon,
 10 Nov 2025 16:52:00 -0500
X-MC-Unique: RZ3zgKvTN7e_O8q8BJ_Peg-1
X-Mimecast-MFC-AGG-ID: RZ3zgKvTN7e_O8q8BJ_Peg_1762811519
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0009C180047F;
	Mon, 10 Nov 2025 21:51:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F1A61800451;
	Mon, 10 Nov 2025 21:51:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5AALpuLK589446
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 16:51:57 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5AALpucc589445;
	Mon, 10 Nov 2025 16:51:56 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] mpathpersist: Fix REPORT CAPABILITIES type mask output
Date: Mon, 10 Nov 2025 16:51:56 -0500
Message-ID: <20251110215156.589437-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pU23aHWCdtPuEhUVtXlc1fzox-8_bfCpjHa7N4wlRwQ_1762811519
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

Also, instead of printing a 1 or a 0, it was printing the value of the
flag. Fix that too.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 mpathpersist/main.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 97fd5a43..5033ee8a 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -761,12 +761,23 @@ void mpath_print_buf_readcap( struct prin_resp *pr_buff)
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

