Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3B4425CF4
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468309; cv=none; b=XS/WuPgpGw2Cg8Uc76X0rofhrUUqcaXxQljljHhAjwoT3c6mFtdV4quN59AqnTIjQ0EKX54bCfTOHpxCnBdFR2Z/CGBGWjxwaQrUMLERGi6pUG4a3yhvZw48MiHzyYNmsp1qRRl1C7VS6DtuIy145WXMo/uNw5US+RXkAagufdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468309; c=relaxed/simple;
	bh=U8V+8RO5UbsoRfFhKBjxtLkKb1zrqiv95DSD1b1wRqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQnVMnNIoPuE/o3NQ4G+mXXzKCZllDhKch8LDMkfDiEEqeLHDRbz6d3s1C+N2nqat2WYMSaeR3Zf/8ia6GotcS8oSKA3t41ctezmd+HuV8IEJsH30zLgf5HvEkzcFUlHcSTv/Q67X9s+nToTDo+csHPky8Ygv4F6JivBQyiD+Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KlO1AlSa; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KlO1AlSa"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43d7645adbdso5117533f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468306; x=1780073106; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MdC0HWQ1+3rZYUyiKiJSz5oXIMjFSNs7b4WG8FUoY2M=;
        b=KlO1AlSaiwT/ZVaehqOxj708JLFYlgUt/tRNMQbk6wWBPv3oe394jQcyPH87kGcjkV
         8LuO9Bs46Nad/KIn0OUcGyK+QHcXdmrylg1U43BkXo4UWIamil3u7zp1StzU6XmcIvU9
         fpUnFAeppMsSZSfxOmx52hiwqttQA2Z9FAau8fRWgf8DRbuQFQens4xiH86qlKc46NBX
         Lx12IrXX3E6ZEu/cVGsFxVTs2nbbSDhGd188FEQCq2Qz/BWx6Y1Xr65r7gqZzU9M9K9b
         qMO4O6SSN4M4a0ezLOsI4DH6DOttgVoXvjF5XvcsKANixp/r2lVSuKNH8gRZ2lnK6stX
         RfrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468306; x=1780073106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MdC0HWQ1+3rZYUyiKiJSz5oXIMjFSNs7b4WG8FUoY2M=;
        b=P2vjnogfaFgXqWk2TMaU6TfT++87Wkg1ZTX7fMV1IiF5vBhCl8/FlBmmVNYjDhuq4u
         svc4zbnMa9eHAVAMhRtNpOYp2eZEcT0wmKB5HL1C503KIImxFDhAP1MuKWdAvEemeYTr
         d4+QyDT/AOGlZjQGq8e0bZHw9+/R/qWDIo1fpaHoi7N4GhZtw31N2coU4xzzKk1zjSmY
         zvUpl1sFYxSDmWmCeyG59QthrwVeAktZjn9rGc8AXyrXpWt+VQ8SILozkK0QZYT7pglO
         R3y5IFBHHnXi+BD/hHY0PN2T/IbPBhlRPp97Xpya2NN+jwIvL1hWhiX49d8gTNb8j0Eq
         R6PA==
X-Forwarded-Encrypted: i=1; AFNElJ9zHiKC+EPfiKJTy46jMcJeVljfn4R/ykvAT9FXhONZte6KSPYJEpW6hEtlPqHVub6J0MyUAHKNew==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyx2PT+9xahLi5n34iLWWIEfpC8AbTLLPSXfsXlilzQNgfVYhA5
	wWxcG+OjsGX8xsU9UtNJyPQhb8SrFKzTK00JGtirxTg1sJaX5APVf709tKCv9WU76DM=
X-Gm-Gg: Acq92OFGQiJPCePTeo9Cb9WMfiV0WYG4c66wUiMx2fcIJReHWJk/J/W2lw62pFVPZC9
	RLV6wyGeL8bkWy9+VJuIbG8LVcgcePD8KUkWe2sxR/YqYXABsmePl4CyNSGHn4FTONKoTpk3gx5
	gK9heaEAz9YGXVkTec5CpNKlUHzqUC/ChmlU3LVeAUE025QhQCd60isTtm1xrDqcuJy+ZSWtBsO
	ZDReXklVRg3PTc3SiYJf3rdBSoekDz2Ux9AW5foJQFY/6OZ4TLm8t9Vz4z2dZH+VX2lCw9hWBjf
	gedwgTARU5fbnVcadip3EmavNO6uHHtoEA6tULJ+C+Xm4e1omYwI84JawzPno7G/xXViHFfsZdd
	J3euIZZhOk6bTEmTefMx5lemr6vJ07vTfcBZsQ/tpJLFxdOFQvEu3soqSQ+EF4XHqOCecI8Za0u
	IVOfPJq1payANuJnQJVLpZ6CzeTHdjToeLuNxcV/6zSn1tHqXcWrn/m12itx/wAdu8kqh3JD0Gv
	D5qOG4d2U2Blw==
X-Received: by 2002:a05:6000:25e8:b0:452:75ca:3fab with SMTP id ffacd0b85a97d-45eb3af6236mr6802964f8f.38.1779468305928;
        Fri, 22 May 2026 09:45:05 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45eb6ccd211sm6445335f8f.10.2026.05.22.09.45.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:45:05 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 19/19] libmultipath: convert emc_clariion to async_checker
Date: Fri, 22 May 2026 18:44:15 +0200
Message-ID: <20260522164415.846589-20-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522164415.846589-1-mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert also the emc_clariion checker. This is the only
checker that uses a checker-specific context and mptcontext.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/emc_clariion.c | 79 ++++++++++++----------------
 1 file changed, 33 insertions(+), 46 deletions(-)

diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 24a386c..5b34d68 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -1,8 +1,6 @@
 /*
  * Copyright (c) 2004, 2005 Lars Marowsky-Bree
  */
-#include <stdio.h>
-#include <stdlib.h>
 #include <string.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -14,8 +12,8 @@
 #include "sg_include.h"
 #include "libsg.h"
 #include "checkers.h"
+#include "async_checker.h"
 #include "debug.h"
-#include "util.h"
 
 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
@@ -33,19 +31,17 @@
  * simple read test would return 02/04/03 instead
  * of 05/25/01 sensekey/ASC/ASCQ data.
  */
-#define IS_INACTIVE_SNAP(mpctx)				\
-	(!mpctx || IS_INVALID_MPCONTEXT(*mpctx) ? 0 : mpctx->long_val)
+#define IS_INACTIVE_SNAP(mpctx)					\
+	(IS_INVALID_MPCONTEXT(mpctx) ? 0 : mpctx.long_val)
 
 #define SET_INACTIVE_SNAP(mpctx)		\
 	do {					\
-		if (mpctx)			\
-			mpctx->long_val = 1;	\
+		mpctx.long_val = 1;		\
 	} while (0);
 
 #define CLR_INACTIVE_SNAP(mpctx)		\
 	do {					\
-		if (mpctx)			\
-			mpctx->long_val = 0;	\
+		mpctx.long_val = 0;		\
 	} while (0);
 
 enum {
@@ -86,7 +82,9 @@ struct emc_clariion_checker_LU_context {
 	int inactive_snap;
 };
 
-void hexadecimal_to_ascii(char * wwn, char *wwnstr)
+int libcheck_async_context_size = sizeof(struct emc_clariion_checker_path_context);
+
+static void hexadecimal_to_ascii(char *wwn, char *wwnstr)
 {
 	int i,j, nbl;
 
@@ -99,33 +97,22 @@ void hexadecimal_to_ascii(char * wwn, char *wwnstr)
 	wwnstr[32]=0;
 }
 
-int libcheck_init (struct checker * c)
+int libcheck_async_init(struct runner_data *rdata)
 {
-	/*
-	 * Allocate and initialize the path specific context.
-	 */
-	c->context = calloc(1, sizeof(struct emc_clariion_checker_path_context));
-	if (!c->context)
-		return 1;
-	((struct emc_clariion_checker_path_context *)c->context)->wwn_set = 0;
+	((struct emc_clariion_checker_path_context *)rdata->checker_ctx)->wwn_set = 0;
 
 	return 0;
 }
 
-void libcheck_free(struct checker *c)
-{
-	free(c->context);
-}
-
-int libcheck_check(struct checker *c, union checker_mpcontext *mpctx)
+int libcheck_async_func(struct runner_data *rdata)
 {
 	unsigned char sense_buffer[128] = { 0, };
 	unsigned char sb[SENSE_BUFF_LEN] = { 0, }, *sbb;
 	unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC0, 0,
 						sizeof(sense_buffer), 0};
 	struct sg_io_hdr io_hdr;
-	struct emc_clariion_checker_path_context * ct =
-		(struct emc_clariion_checker_path_context *)c->context;
+	struct emc_clariion_checker_path_context *ct =
+		(struct emc_clariion_checker_path_context *)rdata->checker_ctx;
 	char wwnstr[33];
 	int ret;
 	int retry_emc = 5;
@@ -142,14 +129,14 @@ retry:
 	io_hdr.dxferp = sense_buffer;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = c->timeout * 1000;
+	io_hdr.timeout = rdata->timeout * 1000;
 	io_hdr.pack_id = 0;
-	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
+	if (ioctl(rdata->fd, SG_IO, &io_hdr) < 0) {
 		if (errno == ENOTTY) {
-			c->msgid = CHECKER_MSGID_UNSUPPORTED;
+			rdata->msgid = CHECKER_MSGID_UNSUPPORTED;
 			return PATH_WILD;
 		}
-		c->msgid = MSG_CLARIION_QUERY_FAILED;
+		rdata->msgid = MSG_CLARIION_QUERY_FAILED;
 		return PATH_DOWN;
 	}
 
@@ -181,12 +168,12 @@ retry:
 				sense_key = sbp[2] & 0xf;
 
 			if (sense_key == ILLEGAL_REQUEST) {
-				c->msgid = CHECKER_MSGID_UNSUPPORTED;
+				rdata->msgid = CHECKER_MSGID_UNSUPPORTED;
 				return PATH_WILD;
 			} else if (sense_key != RECOVERED_ERROR) {
 				condlog(1, "emc_clariion_checker: INQUIRY failed with sense key %02x",
 					sense_key);
-				c->msgid = MSG_CLARIION_QUERY_ERROR;
+				rdata->msgid = MSG_CLARIION_QUERY_ERROR;
 				return PATH_DOWN;
 			}
 		}
@@ -195,13 +182,13 @@ retry:
 	if (io_hdr.info & SG_INFO_OK_MASK) {
 		condlog(1, "emc_clariion_checker: INQUIRY failed without sense, status %02x",
 			io_hdr.status);
-		c->msgid = MSG_CLARIION_QUERY_ERROR;
+		rdata->msgid = MSG_CLARIION_QUERY_ERROR;
 		return PATH_DOWN;
 	}
 
 	if (/* Verify the code page - right page & revision */
 	    sense_buffer[1] != 0xc0 || sense_buffer[9] != 0x00) {
-		c->msgid = MSG_CLARIION_UNIT_REPORT;
+		rdata->msgid = MSG_CLARIION_UNIT_REPORT;
 		return PATH_DOWN;
 	}
 
@@ -215,19 +202,19 @@ retry:
 		    ((sense_buffer[28] & 0x07) != 0x06))
 		/* Arraycommpath should be set to 1 */
 		|| (sense_buffer[30] & 0x04) != 0x04) {
-		c->msgid = MSG_CLARIION_PATH_CONFIG;
+		rdata->msgid = MSG_CLARIION_PATH_CONFIG;
 		return PATH_DOWN;
 	}
 
 	if ( /* LUN operations should indicate normal operations */
 		sense_buffer[48] != 0x00) {
-		c->msgid = MSG_CLARIION_PATH_NOT_AVAIL;
+		rdata->msgid = MSG_CLARIION_PATH_NOT_AVAIL;
 		return PATH_SHAKY;
 	}
 
 	if ( /* LUN should at least be bound somewhere and not be LUNZ */
 		sense_buffer[4] == 0x00) {
-		c->msgid = MSG_CLARIION_LUN_UNBOUND;
+		rdata->msgid = MSG_CLARIION_LUN_UNBOUND;
 		return PATH_DOWN;
 	}
 
@@ -238,7 +225,7 @@ retry:
 	 */
 	if (ct->wwn_set) {
 		if (memcmp(ct->wwn, &sense_buffer[10], 16) != 0) {
-			c->msgid = MSG_CLARIION_WWN_CHANGED;
+			rdata->msgid = MSG_CLARIION_WWN_CHANGED;
 			return PATH_DOWN;
 		}
 	} else {
@@ -253,8 +240,8 @@ retry:
 		unsigned char buf[4096];
 
 		memset(buf, 0, 4096);
-		ret = sg_read(c->fd, &buf[0], 4096,
-			      sbb = &sb[0], SENSE_BUFF_LEN, c->timeout);
+		ret = sg_read(rdata->fd, &buf[0], 4096, sbb = &sb[0],
+			      SENSE_BUFF_LEN, rdata->timeout);
 		if (ret == PATH_DOWN) {
 			hexadecimal_to_ascii(ct->wwn, wwnstr);
 
@@ -269,7 +256,7 @@ retry:
 				 * passive paths which will return
 				 * 02/04/03 not 05/25/01 on read.
 				 */
-				SET_INACTIVE_SNAP(mpctx);
+				SET_INACTIVE_SNAP(rdata->mpc);
 				condlog(3, "emc_clariion_checker: Active "
 					"path to inactive snapshot WWN %s.",
 					wwnstr);
@@ -278,26 +265,26 @@ retry:
 					"error for WWN %s.  Sense data are "
 					"0x%x/0x%x/0x%x.", wwnstr,
 					sbb[2]&0xf, sbb[12], sbb[13]);
-				c->msgid = MSG_CLARIION_READ_ERROR;
+				rdata->msgid = MSG_CLARIION_READ_ERROR;
 			}
 		} else {
-			c->msgid = MSG_CLARIION_PASSIVE_GOOD;
+			rdata->msgid = MSG_CLARIION_PASSIVE_GOOD;
 			/*
 			 * Remove the path from the set of paths to inactive
 			 * snapshot LUs if it was in this list since the
 			 * snapshot is no longer inactive.
 			 */
-			CLR_INACTIVE_SNAP(mpctx);
+			CLR_INACTIVE_SNAP(rdata->mpc);
 		}
 	} else {
-		if (IS_INACTIVE_SNAP(mpctx)) {
+		if (IS_INACTIVE_SNAP(rdata->mpc)) {
 			hexadecimal_to_ascii(ct->wwn, wwnstr);
 			condlog(3, "emc_clariion_checker: Passive "
 				"path to inactive snapshot WWN %s.",
 				wwnstr);
 			ret = PATH_DOWN;
 		} else {
-			c->msgid = MSG_CLARIION_PASSIVE_GOOD;
+			rdata->msgid = MSG_CLARIION_PASSIVE_GOOD;
 			ret = PATH_UP;	/* not ghost */
 		}
 	}
-- 
2.54.0

