Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1749D363C50
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995851; cv=none; b=IstHfiGUvDW1g+dr9yH5UUmDh+IyspODvAfCUECGTXEy8r1PpzPgEmLRsTj8cF8DhrcM1JatYmPKfi/xCd1/mfHFqhJZSbxE4e35RqechCMbRzBlmOl/bwf/pJzaZH8GQ2nASfhLIjO744ltFIMtS5xJVz3RNYbR0wCvifKVkso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995851; c=relaxed/simple;
	bh=3VNeQ5mdo4oP5RilpO+zCKFKzvR4nyXeCbGlRiID698=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYeba453YmgJEa62DT8WaAEkJvtueDmI/keAu5N9exp/9fvnIQ3DlgfJ7WyrMFl3SFxzQm2gDiwTxGHpect5kNQazBUcVUzmzklaRNi+9h5mwzbVJzOmd7kt8H5wHOMGORzCPvIZojbDKDjh+GQrhKKnWLYVPLc/cKsRLdWpU4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XFHkOrWA; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XFHkOrWA"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48909558b3aso59248545e9.0
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995848; x=1778600648; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HECIAMjB9qhF3yXR90JP9SNCnCaJQ4VhRpjCETrSL7I=;
        b=XFHkOrWA0pdYWB4Y2LxYcsEKyF0b8+/gm1WE9nQVqmCl6OvAohGxvs0lMQCm+D00Ly
         6tANMe4IhM/1r83fmhWJvcSnh3wyUYqefvOkMLIW56VSzOn7kqLsSki0MnUmRHyWl/5y
         2RU6o4OCO9TYxeE1E86loBaCFXDhlmZ0CKmOP9FgGrdax9ZP1mA/jNyuUiCNOkkIfNpU
         0c/o4haYhNSriKZjLC2YvSVdcQeZ6Bj+HH/RrPLN2CDdWnWL1XDm5bCA2uFNtZ44FNbH
         ikIZ38RXdYzFIed+U/XHJmO0JParLXFI21rF+qSd6ci3bmibILrLC0utbUmQjFnFiqgl
         copQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995848; x=1778600648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HECIAMjB9qhF3yXR90JP9SNCnCaJQ4VhRpjCETrSL7I=;
        b=MD4SEL5fO3x6cagYqDrHggJn56qGFHrSmw9X2T7MSZHMBwnDnOm2r52wm1VQtylEWh
         9H5HuvcRLwdmshMqEi1UbdsqYcRxMm0V2tz3uxEemva898xYS90ANmkI/pl4xpj00Qzb
         4ZW17TbEawFR6KST6NP9VikLn+OAzBpdMiahmA+eFcFpDQCtkEol3y0k0AJnSkGABziw
         Oi+6CWAJjjsbUFBel1q0qL1ss9I06ED9rpr2zP9Kq4x/y16csh36xGAl/58Be1AsOm9s
         +WwINh814qpiRnJ/go8fFiZt8Pv0KbSuMji6K7Z+n1klRGwC2CHJ2hhw8/+4y4Pp02V1
         LVLQ==
X-Forwarded-Encrypted: i=1; AFNElJ/TocUYZrzxkm4Fm/wLBu1bD67ijL07/s0Q2VgR+3BihfguorZIfB9Ry3DJWP6Os4u8ds35Tp0TRg==@lists.linux.dev
X-Gm-Message-State: AOJu0YybQdT4kvceC/7Kve/lAGs2YHccUAq09JhDDmRXdFITdLr5+mA5
	kifpuI14eC25ZwtGGGMjHD0xez4WPXOoWcrrp3txz9oEOamb7olJmNtWQOhqq3V+eOg=
X-Gm-Gg: AeBDiet6OSDcwVEoRfXVhhEDhI4YloHviwkhygZutBckxlpRZbn3Z9RRCEt7FDYsuQh
	VUqMllhZfvjlBj9D0MTB/4fBxXdGaaDjCXkl+wh/Vv+3FCCovg7j1X4Abl2ssoOy/0iNy8EB6fw
	1trzoj1rNhtoMOuzbSldqyRQPczZYSmxylZYh0RlGdUDBhliyB57RxLGgt5EFwgJSRoQaEvF0Vr
	g6MVoaNbhFeiMxTjeB2Sbde2W7XCgRIfeTO58P2/sS+o3gQHNchhJC/E9eN7jOJDsdzcU2bv/wf
	G82ToSdj6INyUOkse4EeEMvJ6L209ococ2S3VkBHJK1BvW4RSIwaL4q9N4UM9bnclXmNbGYyHdr
	Z+jJbZsZRjNdji/xFxi/sOUGW533pCLrZIm+P8dNpMu2Lq2WMLEo5IY4NdjByVkL61ofXKw8nFz
	5r/bz2GOaxGkPFW/5k7itUo+r5uKml9ZMXKuMKq7I0/FCZ/C088GTMg9ESreIph458rRj17ncxY
	MW5uylYBdDBd92Y+h/bWooLUq3L0sHEfP4=
X-Received: by 2002:a05:600c:4e11:b0:48a:9562:7a30 with SMTP id 5b1f17b1804b1-48a98670ea9mr240977215e9.24.1777995848374;
        Tue, 05 May 2026 08:44:08 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48d14c1ef96sm21859895e9.11.2026.05.05.08.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:44:07 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 18/18] libmultipath: convert emc_clariion to async_checker
Date: Tue,  5 May 2026 17:43:32 +0200
Message-ID: <20260505154332.448054-19-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505154332.448054-1-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 libmultipath/checkers/emc_clariion.c | 79 ++++++++++++----------------
 1 file changed, 33 insertions(+), 46 deletions(-)

diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 24a386c..2c9d4fd 100644
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
+int async_context_size = sizeof(struct emc_clariion_checker_path_context);
+
+static void hexadecimal_to_ascii(char *wwn, char *wwnstr)
 {
 	int i,j, nbl;
 
@@ -99,33 +97,22 @@ void hexadecimal_to_ascii(char * wwn, char *wwnstr)
 	wwnstr[32]=0;
 }
 
-int libcheck_init (struct checker * c)
+int async_init(struct runner_data *rdata)
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

