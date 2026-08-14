Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F1A3502A5
	for <dm-devel@lists.linux.dev>; Fri, 14 Aug 2026 04:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786683498; cv=none; b=Lcav6o1UHmxv2WsX+v6ZGZ0gzDKzm0E9qp66nGfDdGkUwaRxEnGFkve7Is4wJRbv2ApMfUgXcJvby4t4y3rAoeXd5tmEpjZpXq0IfNUnNwZqCrRHP9wdYw+eCfzN88dJ5EnnE40tAUuMI2q3XBxTf8KQJ2vlBsdvQVt5hie1PLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786683498; c=relaxed/simple;
	bh=x+q7w8x3NtSBHD+4DmbJVmqcKywElwy548VILEv1nBw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RlfwT59PTIkntYyIxlIr+N/jh5iQF8T8hUs65VmJrokJlg46eGg9uP9o8/doYhsW1q2ePKRfQRjXGjzRhpomG1p4bRm3DJm4beoBlHS3rFabVn/evL4e1ANq1Hmyk5jMZtiE8yKH43aSJH0+TxcG6yZcb5w6KphvG7lSJZ5dZi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e9rgqvVF; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e9rgqvVF"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ce7d2adef4so11182005ad.3
        for <dm-devel@lists.linux.dev>; Thu, 13 Aug 2026 21:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786683497; x=1787288297; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u447nzojyw2ofbi46saTWniS13rz4btfnPI1tc93bqI=;
        b=e9rgqvVF+eYOCMD1ej2ldZRTDE/4ljVWmIlkQeGAi5+6P/wgz+b+vvJqdLnFkhwGhW
         6NXFQc/9GZafoEG6GKZcH52aC124HAVdA49Bz7laBUY55STRoLvR6BEV4Iw90EHmc0LY
         C2C69HQfSCwjDNlkXFduaDnKiRTnFXpaSpq5NsNCEN5uOxi/W/KNVjoPBHh7GVmGig+4
         UiPJpWSlpuYtGHvKl6Crs7wy1MzrvKonjPBxrnKYvd2YOlVEHHQJ0U/wtbHTAVTDU1ae
         sZKlChWgNO3vgsOg6++kc2DvMRkvacawk9GB1+H0wIerQI8+YkR9YlcYXlxf1+j1PpI+
         g9WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786683497; x=1787288297;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u447nzojyw2ofbi46saTWniS13rz4btfnPI1tc93bqI=;
        b=dEIw39+h6TNc6MYEes13v/cE/+vyoXN4IkGOtiKD10TPPsIlPHKbRhY0BqoT0dvcOF
         W8m5FdASY4ZM4VuFNvIkXtapA1OD7mnMI2EvY2nlaVCpcKgfuNbRdfyVGU5tpwvZX95C
         h/EhpMr4tm0+6iEXogeg3oAaJExq0Kt5aROvoghgRDZeP5vG4H5cDujYcWSRmLjIQR+K
         KsCOapuqGMQA8cevw7vfafVMx1k7hs9UQahqOclifFbLREkGvDHPGtIeEQzR2G0lfmO9
         q107M7/p1iAmUkihasXyj3EtjWWHBiAN6GmrOkVS+sgNPSUL6Z6Wy9tluqBE7SaXH7d7
         jwjw==
X-Gm-Message-State: AOJu0YxGwR4shELc3PJXNeFt6TrFvgO0btbwyuaNzZmHqnaXp7IMY1SZ
	wkMji4nAZ+yFFEMTdOeIP4/Iclihj9Xd0P1f36HjuTPxOwZH3/hlHOXFI3att57+
X-Gm-Gg: AR+sD13vvG/+GTFu7byasadjGwLZYI/TFJZPq2NxCWjJd2pORCr2IZg9vtqAFTFWB9a
	8JXFu3IC11jk4Kj5eCXKi0PMrP41w8NyAsfDIauC4UzyEavG8OvSEAaH/Hcsct2tnXmo9qs26Np
	iRnAie906wE0dKbY1z4f1h7PdlT3KzolE35qEuDKY20IIxorHasl68X3ExKrPcAGr3fqNtfaK/o
	KKCMBYr6tln8PlKBJrGmpLTVfAnl81lkMJbWWzTXplQvLLZWFUj/tqApoiOscMMsS6PXFPBkFfR
	OjnE+7f1QiO6kGGtXmu3JiwKAehENPEBZaN2jOctOLnNxxe2ZPXt5bYSAzKPOOCHsa3x0OfiajX
	nKNSPmMIhBjTQvhJwYjkmnd2s5imryiFqFqzndNB3VVTGjcAXsgMNbd4DkBCY8eAADG2bg9m9OG
	6mZL7XV5zzCWTGiQsK3GkSk+B9IuHD0wHR42Ol8g2kV4BUrYrYMFsPJ41WbSLbW6UFkh4BWKGD8
	Hlp0oTFCWHHJ3xAQTffycXu6uGEXM1A/bHuk6gH0exFpfTvrTenMfcqvFpkqJxM958eVtuX52ft
	2+rqeuwQgIvZUzwSB7In2NxoyrZD4bM4CVLkoxBC3RR8x/mdTill
X-Received: by 2002:a17:902:da83:b0:2ca:6d87:cda0 with SMTP id d9443c01a7336-2d3b08589ddmr26685545ad.6.1786683496611;
        Thu, 13 Aug 2026 21:58:16 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3ae7a4c27sm4494325ad.27.2026.08.13.21.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 21:58:16 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	linux-kernel@vger.kernel.org,
	Matthias Goergens <matthias.goergens@gmail.com>
Subject: [PATCH] dm-delay: advertise flush support
Date: Fri, 14 Aug 2026 12:58:12 +0800
Message-ID: <20260814045813.3148127-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-delay parses and reports a flush delay class (the 9-argument table
form's <flush_device> <flush_offset> <flush_delay>), delay_map() routes
REQ_PREFLUSH bios to it, the target sets num_flush_bios = 1, and
Documentation/admin-guide/device-mapper/delay.rst documents flush
delays. But the target never sets ti->flush_supported, so
dm_table_supports_flush() is false: the block layer strips REQ_PREFLUSH
as a no-op before the bio ever reaches the target (blk_insert_flush()),
REQ_FUA is stripped too, and the flush delay class is dead code. Anyone
who configures a flush delay on dm-delay (e.g. to model slow-flush
devices in tests) silently measures nothing.

Set ti->flush_supported = true so the flush delay class is actually
reachable. dm core clones empty flushes with
REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC (__send_empty_flush), which
delay_map() already routes to the flush class, and delayed completion
is already handled for every class by the delay worker.

Verified with dm-delay over a virtio-scsi disk: without this change
REQ_PREFLUSH completes immediately and REQ_FUA writes are stripped by
the block layer; with it, flushes take the configured delay and FUA
writes reach the wire (measured as device-time per MB at D_f = 200 ms
and 800 ms flush delays).

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 drivers/md/dm-delay.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -301,6 +301,7 @@
 	}

 	ti->num_flush_bios = 1;
+	ti->flush_supported = true;
 	ti->num_discard_bios = 1;
 	ti->accounts_remapped_io = true;
 	ti->per_io_data_size = sizeof(struct dm_delay_info);
@@ -451,7 +452,7 @@

 static struct target_type delay_target = {
 	.name	     = "delay",
-	.version     = {1, 5, 0},
+	.version     = {1, 5, 1},
 	.features    = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ZONED_HM,
 	.module      = THIS_MODULE,
 	.ctr	     = delay_ctr,
