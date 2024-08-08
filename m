Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com [209.85.218.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0CF18F2EE
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130807; cv=none; b=oks4mUQ4KBcyUnHXQmnUCUVrheIyWbASJrIDnirTE8LZn3cxnyudL8S3Fs56Zrh9PvqKL1raEbcHWvNnpf51OBErD/xw5fwa+dU9ZbNeUaKsTql5jmXJZ0GokPbm7Dz/lUS0B5VDVXFVVtPFeW/NgFR1RkZsa7scHS8bbvAL1wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130807; c=relaxed/simple;
	bh=n0LYQ7u0etUlsM1Dtyc/SwnwcpNnqgOjwMkVJeRtCDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XH5HacY6fjvm7thCJfzvCRjnxOeeefkYLlp/kJ9Pkn6qAxHPky5iklOQ/SLF4g5EiQgwHITLIiaD41uV5lB32VDAwwBmhGJ0fd42cOMzYxELraxTGZf2fSGWBPmQTfLOcytPh8PxibhUaI4UGavKgx+YrHDyGyUm+v1lsrWY4f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K2F6zJUF; arc=none smtp.client-ip=209.85.218.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K2F6zJUF"
Received: by mail-ej1-f68.google.com with SMTP id a640c23a62f3a-a7ab5fc975dso101225066b.1
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130802; x=1723735602; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8o6y4HkT4DJe/Aq+gjyWqmi7cyiIAlKGOBDZP+JC1Q0=;
        b=K2F6zJUFm4h0dj0F05NFXzvMHbkTjcRdb+6d1461d0LhidTxbPjzQVLsuE54bmGULt
         Q7/YJkShDXkXd3WJaeJWTjXz5MpFbE1wMHGpp6QqJKPIWhqXG9TMs81vhu7cQfDVzbon
         PGta4JvUChi8QHg3pf39VeOVbPcLOojC8EGwKdPHPQ2HlIdPt5h7G3cp1VNms94kigK6
         v0Oe7IdbAQ+cbYR9dfvR/Rwjt8fwhm7YUIdxgNuEGwnU+9Jvw48ibahRaSeFKOWg4Occ
         8nXrSrY5GouwSQP7v2wskix22Pl3/18kMfmQtM2mi7D07DTgShvUXNJySTyNrou6DKj+
         qN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130802; x=1723735602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8o6y4HkT4DJe/Aq+gjyWqmi7cyiIAlKGOBDZP+JC1Q0=;
        b=i/4gD6A3GLWFX8vKdpdle7pD7639v96TAkC7SCQpFk53dSyEhX/ninYxQa8HQ5H6Kv
         I2m6zDD3Qipv1/ZqigSGhkM+ycz0qeaP0vzVaKGnsp273kgkDVC3ZOJWus/nTi0vUmN1
         Tsb7mx9BcZe1+nvYJWpWuQ7VoRnbGUPtmkKelC0nTOdiekuClYE+Lfm2PaQoaidCikNp
         zI5dlK8F18oh2bPGBm7ZRVwu4nE9wS8gQHY9k5wYCzCMgj0hC/TS2TfVSJlL4cixc8i2
         inJEfAcR7PtkgFw/O6GWEBy8pF4KfWhbQ/JAyo0EDHNhB/ZMI28FC38d6n+Y8vqWx8XN
         gHiQ==
X-Gm-Message-State: AOJu0Yxzmzm+UlptWXDvwnIJbSPgyCU9MQuuH1/huJfxSZ8de+to1RkG
	gdEB+KOSDfIK080EBR8FzA3Yrvr8VVRzBXOaC7ZDq007dMt5w37MX8FkECh5AmQ=
X-Google-Smtp-Source: AGHT+IEomAyHFy55S1f4MhRT8cqEKKSTIoyE3doEMmx3M4KBHpJEIkGEQitpSxVa1dvp6uxCqSnPjw==
X-Received: by 2002:a17:907:e61c:b0:a7a:9ece:ea5f with SMTP id a640c23a62f3a-a8090de7f18mr172363166b.41.1723130801863;
        Thu, 08 Aug 2024 08:26:41 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9ec648dsm747404966b.192.2024.08.08.08.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:41 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 08/41] multipath-tools: use common convention for "header file included" macros
Date: Thu,  8 Aug 2024 17:25:47 +0200
Message-ID: <20240808152620.93965-9-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User code shouldn't define any identifiers starting with 2 underscores, or
underscore + capital letter [1]. Adopt this convention for all macros
indicating that a certain header file is included. Moreover, use a common
convention for constructing these macros: the macro is the base name of the
header file, in capital letters, non-alphanumeric characters replaced by
underscore, with "_INCLUDED" appended. This convention is well readable and
was already used in a few files.

The only exceptions to this rule are:
- the header files under libmultipath/nvme and libmultipath/nvme/linux, where
"NVME_" or "LINUX_" is prepended to the base name, respectively;
- the files "byteorder.h" and "devmapper.h" under kpartx/, to avoid ambiguity
with the files by the same name under libmultipath;
- "main.h" for mpathpersist, to avoid ambiguity with multipathd's main.h.

This commit also adds "already included" macros where they'd been missing
so far.

[1] https://www.gnu.org/software/libc/manual/html_node/Reserved-Names.html

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 create-config.mk                         | 4 ++--
 kpartx/byteorder.h                       | 6 +++---
 kpartx/crc32.h                           | 6 +++---
 kpartx/dasd.h                            | 6 +++---
 kpartx/devmapper.h                       | 6 +++---
 kpartx/dos.h                             | 2 +-
 kpartx/efi.h                             | 6 +++---
 kpartx/gpt.h                             | 4 ++--
 kpartx/kpartx.h                          | 6 +++---
 kpartx/lopart.h                          | 3 +++
 kpartx/mac.h                             | 4 ++--
 kpartx/xstrncpy.h                        | 3 +++
 libdmmp/libdmmp/libdmmp.h                | 6 +++---
 libdmmp/libdmmp_private.h                | 6 +++---
 libmpathcmd/mpath_cmd.h                  | 6 +++---
 libmpathpersist/mpath_persist.h          | 6 +++---
 libmpathpersist/mpath_persist_int.h      | 6 +++---
 libmpathpersist/mpath_pr_ioctl.h         | 5 +++++
 libmpathpersist/mpathpr.h                | 4 ++--
 libmpathutil/debug.h                     | 6 +++---
 libmpathutil/globals.h                   | 4 ++--
 libmpathutil/log.h                       | 6 +++---
 libmpathutil/log_pthread.h               | 6 +++---
 libmpathutil/msort.h                     | 4 ++--
 libmpathutil/parser.h                    | 4 ++--
 libmpathutil/strbuf.h                    | 4 ++--
 libmpathutil/time-util.h                 | 6 +++---
 libmpathutil/util.h                      | 6 +++---
 libmpathutil/uxsock.h                    | 5 ++++-
 libmpathutil/vector.h                    | 4 ++--
 libmpathvalid/mpath_valid.h              | 6 +++---
 libmultipath/alias.h                     | 6 +++---
 libmultipath/blacklist.h                 | 6 +++---
 libmultipath/checkers.h                  | 6 +++---
 libmultipath/checkers/cciss.h            | 4 ++--
 libmultipath/checkers/directio.h         | 6 +++---
 libmultipath/checkers/emc_clariion.h     | 6 +++---
 libmultipath/checkers/hp_sw.h            | 6 +++---
 libmultipath/checkers/rdac.h             | 6 +++---
 libmultipath/checkers/readsector0.h      | 6 +++---
 libmultipath/checkers/tur.h              | 6 +++---
 libmultipath/config.h                    | 4 ++--
 libmultipath/configure.h                 | 4 ++++
 libmultipath/defaults.h                  | 7 ++++---
 libmultipath/devmapper.h                 | 7 ++++---
 libmultipath/dict.h                      | 9 +++------
 libmultipath/discovery.h                 | 6 +++---
 libmultipath/dm-generic.h                | 6 +++---
 libmultipath/dmparser.h                  | 5 +++++
 libmultipath/file.h                      | 6 +++---
 libmultipath/foreign.h                   | 7 ++++---
 libmultipath/generic.h                   | 6 +++---
 libmultipath/hwtable.h                   | 6 +++---
 libmultipath/io_err_stat.h               | 6 +++---
 libmultipath/libsg.h                     | 6 +++---
 libmultipath/list.h                      | 6 +++---
 libmultipath/lock.h                      | 6 +++---
 libmultipath/nvme-lib.h                  | 6 +++---
 libmultipath/nvme/argconfig.h            | 4 ++--
 libmultipath/nvme/json.h                 | 4 ++--
 libmultipath/nvme/linux/nvme.h           | 6 +++---
 libmultipath/nvme/linux/nvme_ioctl.h     | 6 +++---
 libmultipath/nvme/nvme-ioctl.h           | 6 +++---
 libmultipath/nvme/nvme.h                 | 6 +++---
 libmultipath/nvme/plugin.h               | 4 ++--
 libmultipath/pgpolicies.h                | 4 ++--
 libmultipath/print.h                     | 6 +++---
 libmultipath/prio.h                      | 6 +++---
 libmultipath/prioritizers/alua.h         | 4 ++--
 libmultipath/prioritizers/alua_rtpg.h    | 6 +++---
 libmultipath/prioritizers/alua_spc3.h    | 6 +++---
 libmultipath/prioritizers/weightedpath.h | 4 ++--
 libmultipath/prkey.h                     | 6 +++---
 libmultipath/propsel.h                   | 3 +++
 libmultipath/sg_include.h                | 3 +++
 libmultipath/structs.h                   | 6 +++---
 libmultipath/structs_vec.h               | 6 +++---
 libmultipath/switchgroup.h               | 5 +++++
 libmultipath/sysfs.h                     | 4 ++--
 libmultipath/uevent.h                    | 6 +++---
 libmultipath/unaligned.h                 | 6 +++---
 libmultipath/valid.h                     | 6 +++---
 libmultipath/version.h                   | 6 +++---
 libmultipath/wwids.h                     | 6 +++---
 mpathpersist/main.h                      | 4 ++++
 multipathd/cli.h                         | 6 +++---
 multipathd/cli_handlers.h                | 4 ++--
 multipathd/dmevents.h                    | 6 +++---
 multipathd/fpin.h                        | 4 ++--
 multipathd/init_unwinder.h               | 4 ++--
 multipathd/main.h                        | 6 +++---
 multipathd/pidfile.h                     | 4 ++++
 multipathd/uxclnt.h                      | 5 +++++
 multipathd/uxlsnr.h                      | 4 ++--
 multipathd/waiter.h                      | 6 +++---
 tests/test-lib.h                         | 4 ++--
 tests/test-log.h                         | 4 ++--
 tests/wrap64.h                           | 4 ++--
 98 files changed, 282 insertions(+), 235 deletions(-)

diff --git a/create-config.mk b/create-config.mk
index 0abbb3a..8bd2c20 100644
--- a/create-config.mk
+++ b/create-config.mk
@@ -163,8 +163,8 @@ all:	$(TOPDIR)/config.mk
 
 $(multipathdir)/autoconfig.h:
 	@echo creating $@
-	@echo '#ifndef _AUTOCONFIG_H' >$@
-	@echo '#define _AUTOCONFIG_H' >>$@
+	@echo '#ifndef AUTOCONFIG_H_INCLUDED' >$@
+	@echo '#define AUTOCONFIG_H_INCLUDED' >>$@
 	@for x in $(DEFINES); do echo "#define $$x" >>$@; done
 	@echo '#endif' >>$@
 
diff --git a/kpartx/byteorder.h b/kpartx/byteorder.h
index 199c66b..75990a8 100644
--- a/kpartx/byteorder.h
+++ b/kpartx/byteorder.h
@@ -1,5 +1,5 @@
-#ifndef BYTEORDER_H_INCLUDED
-#define BYTEORDER_H_INCLUDED
+#ifndef KPARTX_BYTEORDER_H_INCLUDED
+#define KPARTX_BYTEORDER_H_INCLUDED
 
 #ifdef __linux__
 #  include <endian.h>
@@ -26,4 +26,4 @@
 #  error unsupported
 #endif
 
-#endif				/* BYTEORDER_H_INCLUDED */
+#endif /* KPARTX_BYTEORDER_H_INCLUDED */
diff --git a/kpartx/crc32.h b/kpartx/crc32.h
index a4505b8..abbadbb 100644
--- a/kpartx/crc32.h
+++ b/kpartx/crc32.h
@@ -1,8 +1,8 @@
 /*
  * crc32.h
  */
-#ifndef _CRC32_H
-#define _CRC32_H
+#ifndef CRC32_H_INCLUDED
+#define CRC32_H_INCLUDED
 
 #include <inttypes.h>
 #include <stdlib.h>
@@ -16,4 +16,4 @@ extern uint32_t  crc32_be(uint32_t crc, unsigned char const *p, size_t len);
 #define ether_crc_le(length, data) crc32_le(~0, data, length)
 #define ether_crc(length, data)    crc32_be(~0, data, length)
 
-#endif /* _CRC32_H */
+#endif /* CRC32_H_INCLUDED */
diff --git a/kpartx/dasd.h b/kpartx/dasd.h
index 8ad5d62..481ad79 100644
--- a/kpartx/dasd.h
+++ b/kpartx/dasd.h
@@ -22,8 +22,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifndef _DASD_H
-#define _DASD_H
+#ifndef DASD_H_INCLUDED
+#define DASD_H_INCLUDED
 
 typedef struct ttr
 {
@@ -289,4 +289,4 @@ cchhb2blk (cchhb_t *ptr, struct hd_geometry *geo)
 		ptr->b;
 }
 
-#endif /* _DASD_H */
+#endif /* DASD_H_INCLUDED */
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index 701bdf6..e4db862 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -1,5 +1,5 @@
-#ifndef _KPARTX_DEVMAPPER_H
-#define _KPARTX_DEVMAPPER_H
+#ifndef KPARTX_DEVMAPPER_H_INCLUDED
+#define KPARTX_DEVMAPPER_H_INCLUDED
 
 #ifdef DM_SUBSYSTEM_UDEV_FLAG0
 #define MPATH_UDEV_RELOAD_FLAG DM_SUBSYSTEM_UDEV_FLAG0
@@ -36,4 +36,4 @@ int dm_find_part(const char *parent, const char *delim, int part,
 char *nondm_create_uuid(dev_t devt);
 int nondm_parse_uuid(const char *uuid,
 		     unsigned int *major, unsigned int *minor);
-#endif /* _KPARTX_DEVMAPPER_H */
+#endif /* KPARTX_DEVMAPPER_H_INCLUDED */
diff --git a/kpartx/dos.h b/kpartx/dos.h
index f45e7f6..678cddc 100644
--- a/kpartx/dos.h
+++ b/kpartx/dos.h
@@ -10,4 +10,4 @@ struct partition {
 	unsigned int nr_sects;
 } __attribute__((packed));
 
-#endif				/* DOS_H_INCLUDED */
+#endif /* DOS_H_INCLUDED */
diff --git a/kpartx/efi.h b/kpartx/efi.h
index af5660a..10af0e7 100644
--- a/kpartx/efi.h
+++ b/kpartx/efi.h
@@ -17,8 +17,8 @@
     along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifndef EFI_H
-#define EFI_H
+#ifndef EFI_H_INCLUDED
+#define EFI_H_INCLUDED
 
 /*
  * Extensible Firmware Interface
@@ -54,4 +54,4 @@ efi_guidcmp(efi_guid_t left, efi_guid_t right)
 
 typedef uint16_t efi_char16_t;		/* UNICODE character */
 
-#endif /* EFI_H */
+#endif /* EFI_H_INCLUDED */
diff --git a/kpartx/gpt.h b/kpartx/gpt.h
index 4e1b49a..b35320f 100644
--- a/kpartx/gpt.h
+++ b/kpartx/gpt.h
@@ -21,8 +21,8 @@
     along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
-#ifndef _GPT_H
-#define _GPT_H
+#ifndef GPT_H_INCLUDED
+#define GPT_H_INCLUDED
 
 
 #include <inttypes.h>
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
index 727632c..8a21030 100644
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -1,5 +1,5 @@
-#ifndef _KPARTX_H
-#define _KPARTX_H
+#ifndef KPARTX_H_INCLUDED
+#define KPARTX_H_INCLUDED
 
 #include <stddef.h>
 #include <stdint.h>
@@ -70,4 +70,4 @@ four2int(unsigned char *p) {
 	return p[0] + (p[1]<<8) + (p[2]<<16) + (p[3]<<24);
 }
 
-#endif /* _KPARTX_H */
+#endif /* KPARTX_H_INCLUDED */
diff --git a/kpartx/lopart.h b/kpartx/lopart.h
index c73ab23..7cdcfe7 100644
--- a/kpartx/lopart.h
+++ b/kpartx/lopart.h
@@ -1,4 +1,7 @@
+#ifndef LOPART_H_INCLUDED
+#define LOPART_H_INCLUDED
 extern int verbose;
 extern int set_loop (char **, const char *, int, int *);
 extern int del_loop (const char *);
 extern char * find_loop_by_file (const char *);
+#endif
diff --git a/kpartx/mac.h b/kpartx/mac.h
index 55c3ec9..253fd0d 100644
--- a/kpartx/mac.h
+++ b/kpartx/mac.h
@@ -1,5 +1,5 @@
-#ifndef MAC_H
-#define MAC_H
+#ifndef MAC_H_INCLUDED
+#define MAC_H_INCLUDED
 
 #include <stdint.h>
 
diff --git a/kpartx/xstrncpy.h b/kpartx/xstrncpy.h
index 05c8fa2..cb87aaa 100644
--- a/kpartx/xstrncpy.h
+++ b/kpartx/xstrncpy.h
@@ -1 +1,4 @@
+#ifndef XSTRNCPY_H_INCLUDED
+#define XSTRNCPY_H_INCLUDED
 extern void xstrncpy(char *dest, const char *src, size_t n);
+#endif
diff --git a/libdmmp/libdmmp/libdmmp.h b/libdmmp/libdmmp/libdmmp.h
index 6e6610d..25cd42e 100644
--- a/libdmmp/libdmmp/libdmmp.h
+++ b/libdmmp/libdmmp/libdmmp.h
@@ -19,8 +19,8 @@
  */
 
 
-#ifndef _LIB_DMMP_H_
-#define _LIB_DMMP_H_
+#ifndef LIBDMMP_H_INCLUDED
+#define LIBDMMP_H_INCLUDED
 
 #include <stdint.h>
 #include <stdarg.h>
@@ -732,4 +732,4 @@ DMMP_DLL_EXPORT const char *dmmp_last_error_msg(struct dmmp_context *ctx);
 } /* End of extern "C" */
 #endif
 
-#endif /* End of _LIB_DMMP_H_ */
+#endif /* End of LIBDMMP_H_INCLUDED */
diff --git a/libdmmp/libdmmp_private.h b/libdmmp/libdmmp_private.h
index b1a6dde..9606fb3 100644
--- a/libdmmp/libdmmp_private.h
+++ b/libdmmp/libdmmp_private.h
@@ -18,8 +18,8 @@
  *         Todd Gill <tgill@redhat.com>
  */
 
-#ifndef _LIB_DMMP_PRIVATE_H_
-#define _LIB_DMMP_PRIVATE_H_
+#ifndef LIBDMMP_PRIVATE_H_INCLUDED
+#define LIBDMMP_PRIVATE_H_INCLUDED
 
 /*
  * Notes:
@@ -209,4 +209,4 @@ DMMP_DLL_LOCAL void _dmmp_log_stderr(struct dmmp_context *ctx, int priority,
 } /* End of extern "C" */
 #endif
 
-#endif /* End of _LIB_DMMP_PRIVATE_H_ */
+#endif /* End of LIBDMMP_PRIVATE_H_INCLUDED */
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index 0c293c7..b58aaac 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -17,8 +17,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifndef LIB_MPATH_CMD_H
-#define LIB_MPATH_CMD_H
+#ifndef MPATH_CMD_H_INCLUDED
+#define MPATH_CMD_H_INCLUDED
 
 /*
  * This should be sufficient for json output for >10000 maps,
@@ -141,4 +141,4 @@ int mpath_recv_reply_data(int fd, char *reply, size_t len,
 #ifdef __cplusplus
 }
 #endif
-#endif /* LIB_MPATH_CMD_H */
+#endif /* MPATH_CMD_H_INCLUDED */
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 0046f12..9c88e15 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -1,7 +1,7 @@
 /* version - 1.0 */
 
-#ifndef MPATH_PERSIST_LIB_H
-#define MPATH_PERSIST_LIB_H
+#ifndef MPATH_PERSIST_H_INCLUDED
+#define MPATH_PERSIST_H_INCLUDED
 
 
 #ifdef __cplusplus
@@ -326,4 +326,4 @@ void mpath_persistent_reserve_free_vecs(void);
 }
 #endif
 
-#endif  /*MPATH_PERSIST_LIB_H*/
+#endif /* MPATH_PERSIST_H_INCLUDED */
diff --git a/libmpathpersist/mpath_persist_int.h b/libmpathpersist/mpath_persist_int.h
index 3145753..7819823 100644
--- a/libmpathpersist/mpath_persist_int.h
+++ b/libmpathpersist/mpath_persist_int.h
@@ -1,5 +1,5 @@
-#ifndef _MPATH_PERSIST_INT_H
-#define _MPATH_PERSIST_INT_H
+#ifndef MPATH_PERSIST_INT_H_INCLUDED
+#define MPATH_PERSIST_INT_H_INCLUDED
 
 /*
  * This header file contains symbols that are used by multipath-tools
@@ -22,4 +22,4 @@ int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
 void dumpHex(const char* , int len, int no_ascii);
 int update_map_pr(struct multipath *mpp);
 
-#endif /* _MPATH_PERSIST_INT_H */
+#endif /* MPATH_PERSIST_INT_H_INCLUDED */
diff --git a/libmpathpersist/mpath_pr_ioctl.h b/libmpathpersist/mpath_pr_ioctl.h
index 625490f..b1d9be1 100644
--- a/libmpathpersist/mpath_pr_ioctl.h
+++ b/libmpathpersist/mpath_pr_ioctl.h
@@ -1,3 +1,6 @@
+#ifndef MPATH_PR_IOCTL_H_INCLUDED
+#define MPATH_PR_IOCTL_H_INCLUDED
+
 #define MPATH_XFER_HOST_DEV              0   /*data transfer from initiator to target */
 #define MPATH_XFER_DEV_HOST              1   /*data transfer from target to initiator */
 #define MPATH_XFER_NONE                  2   /*no data transfer */
@@ -107,3 +110,5 @@ typedef struct SenseData
 
 /* Driver status */
 #define DRIVER_OK 0x00
+
+#endif
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index 39a7d8e..cc1a567 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -1,5 +1,5 @@
-#ifndef MPATHPR_H
-#define MPATHPR_H
+#ifndef MPATHPR_H_INCLUDED
+#define MPATHPR_H_INCLUDED
 
 /*
  * This header file contains symbols that are only used by
diff --git a/libmpathutil/debug.h b/libmpathutil/debug.h
index 705a5d7..c2a2f6e 100644
--- a/libmpathutil/debug.h
+++ b/libmpathutil/debug.h
@@ -1,5 +1,5 @@
-#ifndef _DEBUG_H
-#define _DEBUG_H
+#ifndef DEBUG_H_INCLUDED
+#define DEBUG_H_INCLUDED
 void dlog (int prio, const char *fmt, ...)
 	__attribute__((format(printf, 2, 3)));
 
@@ -29,4 +29,4 @@ enum {
 		if (__p <= MAX_VERBOSITY && __p <= libmp_verbosity)	\
 			dlog(__p, fmt "\n", ##args);			\
 	} while (0)
-#endif /* _DEBUG_H */
+#endif /* DEBUG_H_INCLUDED */
diff --git a/libmpathutil/globals.h b/libmpathutil/globals.h
index a4d4d4e..fbb1401 100644
--- a/libmpathutil/globals.h
+++ b/libmpathutil/globals.h
@@ -1,5 +1,5 @@
-#ifndef _GLOBALS_H
-#define _GLOBALS_H
+#ifndef GLOBALS_H_INCLUDED
+#define GLOBALS_H_INCLUDED
 
 struct config;
 
diff --git a/libmpathutil/log.h b/libmpathutil/log.h
index fa224e4..e3d269c 100644
--- a/libmpathutil/log.h
+++ b/libmpathutil/log.h
@@ -1,5 +1,5 @@
-#ifndef LOG_H
-#define LOG_H
+#ifndef LOG_H_INCLUDED
+#define LOG_H_INCLUDED
 
 #define DEFAULT_AREA_SIZE 16384
 #define MAX_MSG_SIZE 256
@@ -40,4 +40,4 @@ int log_dequeue (void *);
 void log_syslog (void *);
 void dump_logmsg (void *);
 
-#endif /* LOG_H */
+#endif /* LOG_H_INCLUDED */
diff --git a/libmpathutil/log_pthread.h b/libmpathutil/log_pthread.h
index 810ac92..dea57b8 100644
--- a/libmpathutil/log_pthread.h
+++ b/libmpathutil/log_pthread.h
@@ -1,5 +1,5 @@
-#ifndef _LOG_PTHREAD_H
-#define _LOG_PTHREAD_H
+#ifndef LOG_PTHREAD_H_INCLUDED
+#define LOG_PTHREAD_H_INCLUDED
 
 #include <pthread.h>
 
@@ -9,4 +9,4 @@ void log_thread_start(pthread_attr_t *attr);
 void log_thread_reset (void);
 void log_thread_stop(void);
 
-#endif /* _LOG_PTHREAD_H */
+#endif /* LOG_PTHREAD_H_INCLUDED */
diff --git a/libmpathutil/msort.h b/libmpathutil/msort.h
index caef9b6..edfa438 100644
--- a/libmpathutil/msort.h
+++ b/libmpathutil/msort.h
@@ -1,5 +1,5 @@
-#ifndef __MSORT_H
-#define __MSORT_H
+#ifndef MSORT_H_INCLUDED
+#define MSORT_H_INCLUDED
 typedef int(*__compar_fn_t)(const void *, const void *);
 void msort (void *b, size_t n, size_t s, __compar_fn_t cmp);
 
diff --git a/libmpathutil/parser.h b/libmpathutil/parser.h
index 9d9d948..baa9c55 100644
--- a/libmpathutil/parser.h
+++ b/libmpathutil/parser.h
@@ -20,8 +20,8 @@
  *              2 of the License, or (at your option) any later version.
  */
 
-#ifndef _PARSER_H
-#define _PARSER_H
+#ifndef PARSER_H_INCLUDED
+#define PARSER_H_INCLUDED
 
 /* system includes */
 #include <stdlib.h>
diff --git a/libmpathutil/strbuf.h b/libmpathutil/strbuf.h
index ae86341..68f21de 100644
--- a/libmpathutil/strbuf.h
+++ b/libmpathutil/strbuf.h
@@ -2,8 +2,8 @@
  * Copyright (c) 2021 SUSE LLC
  * SPDX-License-Identifier: GPL-2.0-or-later
  */
-#ifndef _STRBUF_H
-#define _STRBUF_H
+#ifndef STRBUF_H_INCLUDED
+#define STRBUF_H_INCLUDED
 #include <errno.h>
 #include <string.h>
 
diff --git a/libmpathutil/time-util.h b/libmpathutil/time-util.h
index 4a80ebd..dfffe4b 100644
--- a/libmpathutil/time-util.h
+++ b/libmpathutil/time-util.h
@@ -1,5 +1,5 @@
-#ifndef _TIME_UTIL_H_
-#define _TIME_UTIL_H_
+#ifndef TIME_UTIL_H_INCLUDED
+#define TIME_UTIL_H_INCLUDED
 
 #include <pthread.h>
 
@@ -12,4 +12,4 @@ void timespecsub(const struct timespec *a, const struct timespec *b,
 		 struct timespec *res);
 int timespeccmp(const struct timespec *a, const struct timespec *b);
 
-#endif /* _TIME_UTIL_H_ */
+#endif /* TIME_UTIL_H_INCLUDED */
diff --git a/libmpathutil/util.h b/libmpathutil/util.h
index 7bad855..110b2f6 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -1,5 +1,5 @@
-#ifndef _UTIL_H
-#define _UTIL_H
+#ifndef UTIL_H_INCLUDED
+#define UTIL_H_INCLUDED
 
 #include <stdlib.h>
 #include <string.h>
@@ -147,4 +147,4 @@ void cleanup_charp(char **p);
 void cleanup_ucharp(unsigned char **p);
 void cleanup_udev_device(struct udev_device **udd);
 
-#endif /* _UTIL_H */
+#endif /* UTIL_H_INCLUDED */
diff --git a/libmpathutil/uxsock.h b/libmpathutil/uxsock.h
index e3d28cf..8157060 100644
--- a/libmpathutil/uxsock.h
+++ b/libmpathutil/uxsock.h
@@ -1,7 +1,10 @@
 /* some prototypes */
+#ifndef UXSOCK_H_INCLUDED
+#define UXSOCK_H_INCLUDED
+
 int ux_socket_listen(const char *name);
 int send_packet(int fd, const char *buf);
 int recv_packet(int fd, char **buf, unsigned int timeout);
 
 #define _MAX_CMD_LEN		512
-
+#endif
diff --git a/libmpathutil/vector.h b/libmpathutil/vector.h
index a41f157..2df1505 100644
--- a/libmpathutil/vector.h
+++ b/libmpathutil/vector.h
@@ -20,8 +20,8 @@
  *              2 of the License, or (at your option) any later version.
  */
 
-#ifndef _VECTOR_H
-#define _VECTOR_H
+#ifndef VECTOR_H_INCLUDED
+#define VECTOR_H_INCLUDED
 
 #include <stdbool.h>
 
diff --git a/libmpathvalid/mpath_valid.h b/libmpathvalid/mpath_valid.h
index 636f163..de165a2 100644
--- a/libmpathvalid/mpath_valid.h
+++ b/libmpathvalid/mpath_valid.h
@@ -17,8 +17,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifndef LIB_MPATH_VALID_H
-#define LIB_MPATH_VALID_H
+#ifndef MPATH_VALID_H_INCLUDED
+#define MPATH_VALID_H_INCLUDED
 
 #ifdef __cplusplus
 extern "C" {
@@ -152,4 +152,4 @@ int mpathvalid_is_path(const char *name, unsigned int mode, char **wwid,
 #ifdef __cplusplus
 }
 #endif
-#endif /* LIB_PATH_VALID_H */
+#endif /* MPATH_VALID_H_INCLUDED */
diff --git a/libmultipath/alias.h b/libmultipath/alias.h
index 629e8d5..eb3c15b 100644
--- a/libmultipath/alias.h
+++ b/libmultipath/alias.h
@@ -1,5 +1,5 @@
-#ifndef _ALIAS_H
-#define _ALIAS_H
+#ifndef ALIAS_H_INCLUDED
+#define ALIAS_H_INCLUDED
 
 int valid_alias(const char *alias);
 int get_user_friendly_wwid(const char *alias, char *buff);
@@ -11,4 +11,4 @@ int check_alias_settings(const struct config *);
 void cleanup_bindings(void);
 struct inotify_event;
 void handle_bindings_file_inotify(const struct inotify_event *event);
-#endif /* _ALIAS_H */
+#endif /* ALIAS_H_INCLUDED */
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index dde5cea..244c59d 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -1,5 +1,5 @@
-#ifndef _BLACKLIST_H
-#define _BLACKLIST_H
+#ifndef BLACKLIST_H_INCLUDED
+#define BLACKLIST_H_INCLUDED
 
 #include <libudev.h>
 #include <regex.h>
@@ -54,4 +54,4 @@ void free_blacklist_device (vector);
 void merge_blacklist(vector);
 void merge_blacklist_device(vector);
 
-#endif /* _BLACKLIST_H */
+#endif /* BLACKLIST_H_INCLUDED */
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index ea1e8af..51ceea0 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -1,5 +1,5 @@
-#ifndef _CHECKERS_H
-#define _CHECKERS_H
+#ifndef CHECKERS_H_INCLUDED
+#define CHECKERS_H_INCLUDED
 
 #include <pthread.h>
 #include "list.h"
@@ -199,4 +199,4 @@ void *libcheck_thread(struct checker_context *ctx);
  */
 extern const char *libcheck_msgtable[];
 
-#endif /* _CHECKERS_H */
+#endif /* CHECKERS_H_INCLUDED */
diff --git a/libmultipath/checkers/cciss.h b/libmultipath/checkers/cciss.h
index cf20946..bdb1184 100644
--- a/libmultipath/checkers/cciss.h
+++ b/libmultipath/checkers/cciss.h
@@ -1,5 +1,5 @@
-#ifndef CCISS_H
-#define CCISS_H
+#ifndef CCISS_H_INCLUDED
+#define CCISS_H_INCLUDED
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
diff --git a/libmultipath/checkers/directio.h b/libmultipath/checkers/directio.h
index 1865b1f..15b3da4 100644
--- a/libmultipath/checkers/directio.h
+++ b/libmultipath/checkers/directio.h
@@ -1,8 +1,8 @@
-#ifndef _DIRECTIO_H
-#define _DIRECTIO_H
+#ifndef DIRECTIO_H_INCLUDED
+#define DIRECTIO_H_INCLUDED
 
 int directio (struct checker *);
 int directio_init (struct checker *);
 void directio_free (struct checker *);
 
-#endif /* _DIRECTIO_H */
+#endif /* DIRECTIO_H_INCLUDED */
diff --git a/libmultipath/checkers/emc_clariion.h b/libmultipath/checkers/emc_clariion.h
index a1018a6..ee85dd5 100644
--- a/libmultipath/checkers/emc_clariion.h
+++ b/libmultipath/checkers/emc_clariion.h
@@ -1,8 +1,8 @@
-#ifndef _EMC_CLARIION_H
-#define _EMC_CLARIION_H
+#ifndef EMC_CLARIION_H_INCLUDED
+#define EMC_CLARIION_H_INCLUDED
 
 int emc_clariion (struct checker *);
 int emc_clariion_init (struct checker *);
 void emc_clariion_free (struct checker *);
 
-#endif /* _EMC_CLARIION_H */
+#endif /* EMC_CLARIION_H_INCLUDED */
diff --git a/libmultipath/checkers/hp_sw.h b/libmultipath/checkers/hp_sw.h
index 3be0d8e..0589351 100644
--- a/libmultipath/checkers/hp_sw.h
+++ b/libmultipath/checkers/hp_sw.h
@@ -1,8 +1,8 @@
-#ifndef _HP_SW_H
-#define _HP_SW_H
+#ifndef HP_SW_H_INCLUDED
+#define HP_SW_H_INCLUDED
 
 int hp_sw (struct checker *);
 int hp_sw_init (struct checker *);
 void hp_sw_free (struct checker *);
 
-#endif /* _HP_SW_H */
+#endif /* HP_SW_H_INCLUDED */
diff --git a/libmultipath/checkers/rdac.h b/libmultipath/checkers/rdac.h
index d7bf812..5a92b28 100644
--- a/libmultipath/checkers/rdac.h
+++ b/libmultipath/checkers/rdac.h
@@ -1,8 +1,8 @@
-#ifndef _RDAC_H
-#define _RDAC_H
+#ifndef RDAC_H_INCLUDED
+#define RDAC_H_INCLUDED
 
 int rdac(struct checker *);
 int rdac_init(struct checker *);
 void rdac_free(struct checker *);
 
-#endif /* _RDAC_H */
+#endif /* RDAC_H_INCLUDED */
diff --git a/libmultipath/checkers/readsector0.h b/libmultipath/checkers/readsector0.h
index 0f5d654..486613d 100644
--- a/libmultipath/checkers/readsector0.h
+++ b/libmultipath/checkers/readsector0.h
@@ -1,8 +1,8 @@
-#ifndef _READSECTOR0_H
-#define _READSECTOR0_H
+#ifndef READSECTOR0_H_INCLUDED
+#define READSECTOR0_H_INCLUDED
 
 int readsector0 (struct checker *);
 int readsector0_init (struct checker *);
 void readsector0_free (struct checker *);
 
-#endif /* _READSECTOR0_H */
+#endif /* READSECTOR0_H_INCLUDED */
diff --git a/libmultipath/checkers/tur.h b/libmultipath/checkers/tur.h
index a2e8c88..62a47d1 100644
--- a/libmultipath/checkers/tur.h
+++ b/libmultipath/checkers/tur.h
@@ -1,8 +1,8 @@
-#ifndef _TUR_H
-#define _TUR_H
+#ifndef TUR_H_INCLUDED
+#define TUR_H_INCLUDED
 
 int tur (struct checker *);
 int tur_init (struct checker *);
 void tur_free (struct checker *);
 
-#endif /* _TUR_H */
+#endif /* TUR_H_INCLUDED */
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 800c0ca..181b78a 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -1,5 +1,5 @@
-#ifndef _CONFIG_H
-#define _CONFIG_H
+#ifndef CONFIG_H_INCLUDED
+#define CONFIG_H_INCLUDED
 
 #include <sys/types.h>
 #include <stdint.h>
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 9d935db..ca34442 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -1,3 +1,6 @@
+#ifndef CONFIGURE_H_INCLUDED
+#define CONFIGURE_H_INCLUDED
+
 /*
  * configurator actions
  */
@@ -63,3 +66,4 @@ void trigger_paths_udev_change(struct multipath *mpp, bool is_mpath);
 void trigger_partitions_udev_change(struct udev_device *dev, const char *action,
 				    int len);
 int check_daemon(void);
+#endif
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index ed08c25..02f7e57 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,5 +1,6 @@
-#ifndef _DEFAULTS_H
-#define _DEFAULTS_H
+#ifndef DEFAULTS_H_INCLUDED
+#define DEFAULTS_H_INCLUDED
+
 #include <limits.h>
 #include <string.h>
 
@@ -78,4 +79,4 @@ static inline char *set_default(char *str)
 	return strdup(str);
 }
 extern const char *const default_partition_delim;
-#endif /* _DEFAULTS_H */
+#endif /* DEFAULTS_H_INCLUDED */
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index a26dc1e..b5330ab 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -1,5 +1,6 @@
-#ifndef _DEVMAPPER_H
-#define _DEVMAPPER_H
+#ifndef DEVMAPPER_H_INCLUDED
+#define DEVMAPPER_H_INCLUDED
+
 #include <sys/sysmacros.h>
 #include <linux/dm-ioctl.h>
 #include "autoconfig.h"
@@ -210,4 +211,4 @@ int libmp_dm_task_run(struct dm_task *dmt);
 	condlog(lvl, "%s: libdm task=%d error: %s", __func__, \
 		cmd, strerror(dm_task_get_errno(dmt)))	      \
 
-#endif /* _DEVMAPPER_H */
+#endif /* DEVMAPPER_H_INCLUDED */
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index e179453..97c91c8 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -1,10 +1,7 @@
-#ifndef _DICT_H
-#define _DICT_H
+#ifndef DICT_H_INCLUDED
+#define DICT_H_INCLUDED
 
-#ifndef _VECTOR_H
 #include "vector.h"
-#endif
-
 #include "byteorder.h"
 struct strbuf;
 
@@ -19,4 +16,4 @@ int print_dev_loss(struct strbuf *buff, unsigned long v);
 int print_off_int_undef(struct strbuf *buff, long v);
 int print_auto_resize(struct strbuf *buff, long v);
 int print_flush_on_last_del(struct strbuf *buff, long v);
-#endif /* _DICT_H */
+#endif /* DICT_H_INCLUDED */
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index acd5179..5bd35ca 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -1,5 +1,5 @@
-#ifndef DISCOVERY_H
-#define DISCOVERY_H
+#ifndef DISCOVERY_H_INCLUDED
+#define DISCOVERY_H_INCLUDED
 
 #define SYSFS_PATH_SIZE 255
 #define INQUIRY_CMDLEN  6
@@ -84,4 +84,4 @@ enum discovery_mode {
 #define DI_ALL		(DI_SYSFS  | DI_SERIAL | DI_CHECKER | DI_PRIO | \
 			 DI_WWID)
 
-#endif /* DISCOVERY_H */
+#endif /* DISCOVERY_H_INCLUDED */
diff --git a/libmultipath/dm-generic.h b/libmultipath/dm-generic.h
index 986429f..9055ce1 100644
--- a/libmultipath/dm-generic.h
+++ b/libmultipath/dm-generic.h
@@ -14,8 +14,8 @@
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
-#ifndef _DM_GENERIC_H
-#define _DM_GENERIC_H
+#ifndef DM_GENERIC_H_INCLUDED
+#define DM_GENERIC_H_INCLUDED
 #include "generic.h"
 #include "list.h" /* for container_of */
 #include "structs.h"
@@ -36,4 +36,4 @@ extern const struct gen_multipath_ops dm_gen_multipath_ops;
 extern const struct gen_pathgroup_ops dm_gen_pathgroup_ops;
 extern const struct gen_path_ops dm_gen_path_ops;
 
-#endif /* _DM_GENERIC_H */
+#endif /* DM_GENERIC_H_INCLUDED */
diff --git a/libmultipath/dmparser.h b/libmultipath/dmparser.h
index 666ae74..43454c3 100644
--- a/libmultipath/dmparser.h
+++ b/libmultipath/dmparser.h
@@ -1,3 +1,8 @@
+#ifndef DMPARSER_H_INCLUDED
+#define DMPARSER_H_INCLUDED
+
 int assemble_map (struct multipath *, char **);
 int disassemble_map (const struct _vector *, const char *, struct multipath *);
 int disassemble_status (const char *, struct multipath *);
+
+#endif
diff --git a/libmultipath/file.h b/libmultipath/file.h
index 3c75c90..57b517f 100644
--- a/libmultipath/file.h
+++ b/libmultipath/file.h
@@ -2,8 +2,8 @@
  * Copyright (c) 2010 Benjamin Marzinski, Redhat
  */
 
-#ifndef _FILE_H
-#define _FILE_H
+#ifndef FILE_H_INCLUDED
+#define FILE_H_INCLUDED
 
 #include <sys/stat.h>
 
@@ -11,4 +11,4 @@
 int ensure_directories_exist(const char *str, mode_t dir_mode);
 int open_file(const char *file, int *can_write, const char *header);
 
-#endif /* _FILE_H */
+#endif /* FILE_H_INCLUDED */
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
index b9cdb36..db1592c 100644
--- a/libmultipath/foreign.h
+++ b/libmultipath/foreign.h
@@ -14,8 +14,9 @@
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
-#ifndef _FOREIGN_H
-#define _FOREIGN_H
+#ifndef FOREIGN_H_INCLUDED
+#define FOREIGN_H_INCLUDED
+
 #include <stdbool.h>
 #include <libudev.h>
 #define LIBMP_FOREIGN_API ((1 << 8) | 2)
@@ -320,4 +321,4 @@ is_claimed_by_foreign(struct udev_device *ud)
 	return (rc == FOREIGN_CLAIMED || rc == FOREIGN_OK);
 }
 
-#endif /*  _FOREIGN_H */
+#endif /*  FOREIGN_H_INCLUDED */
diff --git a/libmultipath/generic.h b/libmultipath/generic.h
index e89848f..c8fe31c 100644
--- a/libmultipath/generic.h
+++ b/libmultipath/generic.h
@@ -14,8 +14,8 @@
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
-#ifndef _GENERIC_H
-#define _GENERIC_H
+#ifndef GENERIC_H_INCLUDED
+#define GENERIC_H_INCLUDED
 #include "vector.h"
 
 /*
@@ -138,4 +138,4 @@ struct gen_path {
 int generic_style(const struct gen_multipath*,
 		  struct strbuf *buf, int verbosity);
 
-#endif /* _GENERIC_H */
+#endif /* GENERIC_H_INCLUDED */
diff --git a/libmultipath/hwtable.h b/libmultipath/hwtable.h
index 13c5701..737e821 100644
--- a/libmultipath/hwtable.h
+++ b/libmultipath/hwtable.h
@@ -1,6 +1,6 @@
-#ifndef _HWTABLE_H
-#define _HWTABLE_H
+#ifndef HWTABLE_H_INCLUDED
+#define HWTABLE_H_INCLUDED
 
 int setup_default_hwtable (vector hw);
 
-#endif /* _HWTABLE_H */
+#endif /* HWTABLE_H_INCLUDED */
diff --git a/libmultipath/io_err_stat.h b/libmultipath/io_err_stat.h
index 53d6d7d..8dc298b 100644
--- a/libmultipath/io_err_stat.h
+++ b/libmultipath/io_err_stat.h
@@ -1,5 +1,5 @@
-#ifndef _IO_ERR_STAT_H
-#define _IO_ERR_STAT_H
+#ifndef IO_ERR_STAT_H_INCLUDED
+#define IO_ERR_STAT_H_INCLUDED
 
 #include "vector.h"
 #include "lock.h"
@@ -12,4 +12,4 @@ void stop_io_err_stat_thread(void);
 int io_err_stat_handle_pathfail(struct path *path);
 int need_io_err_check(struct path *pp);
 
-#endif /* _IO_ERR_STAT_H */
+#endif /* IO_ERR_STAT_H_INCLUDED */
diff --git a/libmultipath/libsg.h b/libmultipath/libsg.h
index 3994f45..76eb30d 100644
--- a/libmultipath/libsg.h
+++ b/libmultipath/libsg.h
@@ -1,9 +1,9 @@
-#ifndef _LIBSG_H
-#define _LIBSG_H
+#ifndef LIBSG_H_INCLUDED
+#define LIBSG_H_INCLUDED
 
 #define SENSE_BUFF_LEN 32
 
 int sg_read (int sg_fd, unsigned char * buff, int buff_len,
 	     unsigned char * sense, int sense_len, unsigned int timeout);
 
-#endif /* _LIBSG_H */
+#endif /* LIBSG_H_INCLUDED */
diff --git a/libmultipath/list.h b/libmultipath/list.h
index 248f72b..8f48520 100644
--- a/libmultipath/list.h
+++ b/libmultipath/list.h
@@ -5,8 +5,8 @@
  *
  */
 
-#ifndef _LIST_H
-#define _LIST_H
+#ifndef LIST_H_INCLUDED
+#define LIST_H_INCLUDED
 
 #include <stddef.h>
 
@@ -415,4 +415,4 @@ static inline struct list_head *list_pop(struct list_head *head)
 	     &pos->member != (to);                                      \
 	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
 
-#endif /* _LIST_H */
+#endif /* LIST_H_INCLUDED */
diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index ac80d1d..1c05a77 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -1,5 +1,5 @@
-#ifndef _LOCK_H
-#define _LOCK_H
+#ifndef LOCK_H_INCLUDED
+#define LOCK_H_INCLUDED
 
 #include <pthread.h>
 #include <urcu/uatomic.h>
@@ -65,4 +65,4 @@ static inline bool lock_has_waiters(struct mutex_lock *a)
 void cleanup_lock (void * data);
 void set_wakeup_fn(struct mutex_lock *lock, wakeup_fn *fn);
 
-#endif /* _LOCK_H */
+#endif /* LOCK_H_INCLUDED */
diff --git a/libmultipath/nvme-lib.h b/libmultipath/nvme-lib.h
index 448dd99..059dca8 100644
--- a/libmultipath/nvme-lib.h
+++ b/libmultipath/nvme-lib.h
@@ -1,5 +1,5 @@
-#ifndef NVME_LIB_H
-#define NVME_LIB_H
+#ifndef NVME_LIB_H_INCLUDED
+#define NVME_LIB_H_INCLUDED
 
 #include "nvme.h"
 
@@ -36,4 +36,4 @@ int nvme_id_ctrl_ana(int fd, struct nvme_id_ctrl *ctrl);
 #undef le64_to_cpu
 #endif
 
-#endif /* NVME_LIB_H */
+#endif /* NVME_LIB_H_INCLUDED */
diff --git a/libmultipath/nvme/argconfig.h b/libmultipath/nvme/argconfig.h
index adb192b..e6c5445 100644
--- a/libmultipath/nvme/argconfig.h
+++ b/libmultipath/nvme/argconfig.h
@@ -30,8 +30,8 @@
 //
 ////////////////////////////////////////////////////////////////////////
 
-#ifndef argconfig_H
-#define argconfig_H
+#ifndef NVME_ARGCONFIG_H_INCLUDED
+#define NVME_ARGCONFIG_H_INCLUDED
 
 #include <string.h>
 #include <getopt.h>
diff --git a/libmultipath/nvme/json.h b/libmultipath/nvme/json.h
index c4ea531..70df528 100644
--- a/libmultipath/nvme/json.h
+++ b/libmultipath/nvme/json.h
@@ -1,5 +1,5 @@
-#ifndef __JSON__H
-#define __JSON__H
+#ifndef NVME_JSON_H_INCLUDED
+#define NVME_JSON_H_INCLUDED
 
 struct json_object;
 struct json_array;
diff --git a/libmultipath/nvme/linux/nvme.h b/libmultipath/nvme/linux/nvme.h
index 9fc2ae7..f0cb290 100644
--- a/libmultipath/nvme/linux/nvme.h
+++ b/libmultipath/nvme/linux/nvme.h
@@ -12,8 +12,8 @@
  * more details.
  */
 
-#ifndef _LINUX_NVME_H
-#define _LINUX_NVME_H
+#ifndef LINUX_NVME_H_INCLUDED
+#define LINUX_NVME_H_INCLUDED
 
 #include <linux/types.h>
 #include <linux/uuid.h>
@@ -1525,4 +1525,4 @@ struct nvme_completion {
 #define NVME_MINOR(ver)		(((ver) >> 8) & 0xff)
 #define NVME_TERTIARY(ver)	((ver) & 0xff)
 
-#endif /* _LINUX_NVME_H */
+#endif /* LINUX_NVME_H_INCLUDED */
diff --git a/libmultipath/nvme/linux/nvme_ioctl.h b/libmultipath/nvme/linux/nvme_ioctl.h
index d25a532..3f6623c 100644
--- a/libmultipath/nvme/linux/nvme_ioctl.h
+++ b/libmultipath/nvme/linux/nvme_ioctl.h
@@ -12,8 +12,8 @@
  * more details.
  */
 
-#ifndef _UAPI_LINUX_NVME_IOCTL_H
-#define _UAPI_LINUX_NVME_IOCTL_H
+#ifndef LINUX_NVME_IOCTL_H_INCLUDED
+#define LINUX_NVME_IOCTL_H_INCLUDED
 
 #include <linux/types.h>
 #include <sys/ioctl.h>
@@ -64,4 +64,4 @@ struct nvme_passthru_cmd {
 #define NVME_IOCTL_SUBSYS_RESET	_IO('N', 0x45)
 #define NVME_IOCTL_RESCAN	_IO('N', 0x46)
 
-#endif /* _UAPI_LINUX_NVME_IOCTL_H */
+#endif /* LINUX_NVME_IOCTL_H_INCLUDED */
diff --git a/libmultipath/nvme/nvme-ioctl.h b/libmultipath/nvme/nvme-ioctl.h
index 565f764..246f02e 100644
--- a/libmultipath/nvme/nvme-ioctl.h
+++ b/libmultipath/nvme/nvme-ioctl.h
@@ -1,5 +1,5 @@
-#ifndef _NVME_LIB_H
-#define _NVME_LIB_H
+#ifndef NVME_NVME_IOCTL_H_INCLUDED
+#define NVME_NVME_IOCTL_H_INCLUDED
 
 #include <linux/types.h>
 #include <stdbool.h>
@@ -155,4 +155,4 @@ int nvme_sanitize(int fd, __u8 sanact, __u8 ause, __u8 owpass, __u8 oipbp,
 int nvme_self_test_start(int fd, __u32 nsid, __u32 cdw10);
 int nvme_self_test_log(int fd, struct nvme_self_test_log *self_test_log);
 int nvme_virtual_mgmt(int fd, __u32 cdw10, __u32 cdw11, __u32 *result);
-#endif				/* _NVME_LIB_H */
+#endif /* NVME_NVME_IOCTL_H_INCLUDED */
diff --git a/libmultipath/nvme/nvme.h b/libmultipath/nvme/nvme.h
index 57f82a3..019bce1 100644
--- a/libmultipath/nvme/nvme.h
+++ b/libmultipath/nvme/nvme.h
@@ -12,8 +12,8 @@
  * more details.
  */
 
-#ifndef _NVME_H
-#define _NVME_H
+#ifndef NVME_NVME_H_INCLUDED
+#define NVME_NVME_H_INCLUDED
 
 #include <stdbool.h>
 #include <stdint.h>
@@ -237,4 +237,4 @@ static inline bool is_64bit_reg(__u32 offset)
 	return false;
 }
 
-#endif /* _NVME_H */
+#endif /* NVME_NVME_H_INCLUDED */
diff --git a/libmultipath/nvme/plugin.h b/libmultipath/nvme/plugin.h
index 91079fb..6f12946 100644
--- a/libmultipath/nvme/plugin.h
+++ b/libmultipath/nvme/plugin.h
@@ -1,5 +1,5 @@
-#ifndef PLUGIN_H
-#define PLUGIN_H
+#ifndef NVME_PLUGIN_H_INCLUDED
+#define NVME_PLUGIN_H_INCLUDED
 
 #include <stdbool.h>
 
diff --git a/libmultipath/pgpolicies.h b/libmultipath/pgpolicies.h
index 9e4ddda..4469f8b 100644
--- a/libmultipath/pgpolicies.h
+++ b/libmultipath/pgpolicies.h
@@ -1,5 +1,5 @@
-#ifndef _PGPOLICIES_H
-#define _PGPOLICIES_H
+#ifndef PGPOLICIES_H_INCLUDED
+#define PGPOLICIES_H_INCLUDED
 
 #if 0
 #ifndef _MAIN_H
diff --git a/libmultipath/print.h b/libmultipath/print.h
index 52f5b25..eb4cbc2 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -1,5 +1,5 @@
-#ifndef _PRINT_H
-#define _PRINT_H
+#ifndef PRINT_H_INCLUDED
+#define PRINT_H_INCLUDED
 #include "dm-generic.h"
 
 #define PRINT_PATH_CHECKER   "%i %d %D %p %t %T %o %C"
@@ -73,4 +73,4 @@ int snprint_multipath_attr(const struct gen_multipath* gm,
 			   struct strbuf *buf, char wildcard);
 int snprint_multipath_style(const struct gen_multipath *gmp,
 			    struct strbuf *style, int verbosity);
-#endif /* _PRINT_H */
+#endif /* PRINT_H_INCLUDED */
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 318d260..119b75f 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -1,5 +1,5 @@
-#ifndef _PRIO_H
-#define _PRIO_H
+#ifndef PRIO_H_INCLUDED
+#define PRIO_H_INCLUDED
 
 /*
  * knowing about path struct gives flexibility to prioritizers
@@ -67,4 +67,4 @@ int prio_set_args (struct prio *, const char *);
 /* The only function exported by prioritizer dynamic libraries (.so) */
 int getprio(struct path *, char *);
 
-#endif /* _PRIO_H */
+#endif /* PRIO_H_INCLUDED */
diff --git a/libmultipath/prioritizers/alua.h b/libmultipath/prioritizers/alua.h
index 78a3d15..88fd6af 100644
--- a/libmultipath/prioritizers/alua.h
+++ b/libmultipath/prioritizers/alua.h
@@ -1,5 +1,5 @@
-#ifndef _ALUA_H
-#define _ALUA_H
+#ifndef ALUA_H_INCLUDED
+#define ALUA_H_INCLUDED
 
 #include "alua_rtpg.h"
 
diff --git a/libmultipath/prioritizers/alua_rtpg.h b/libmultipath/prioritizers/alua_rtpg.h
index c5f9a8f..ff6ec0e 100644
--- a/libmultipath/prioritizers/alua_rtpg.h
+++ b/libmultipath/prioritizers/alua_rtpg.h
@@ -12,8 +12,8 @@
  *
  * This file is released under the GPL.
  */
-#ifndef __RTPG_H__
-#define __RTPG_H__
+#ifndef ALUA_RTPG_H_INCLUDED
+#define ALUA_RTPG_H_INCLUDED
 #include "alua_spc3.h"
 
 #define RTPG_SUCCESS				0
@@ -26,4 +26,4 @@ int get_target_port_group_support(const struct path *pp);
 int get_target_port_group(const struct path *pp);
 int get_asymmetric_access_state(const struct path *pp, unsigned int tpg);
 
-#endif /* __RTPG_H__ */
+#endif /* ALUA_RTPG_H_INCLUDED */
diff --git a/libmultipath/prioritizers/alua_spc3.h b/libmultipath/prioritizers/alua_spc3.h
index e1a6c07..6011c4d 100644
--- a/libmultipath/prioritizers/alua_spc3.h
+++ b/libmultipath/prioritizers/alua_spc3.h
@@ -12,8 +12,8 @@
  *
  * This file is released under the GPL.
  */
-#ifndef __SPC3_H__
-#define __SPC3_H__
+#ifndef ALUA_SPC3_H_INCLUDED
+#define ALUA_SPC3_H_INCLUDED
 #include "../unaligned.h"
 
 /*=============================================================================
@@ -323,4 +323,4 @@ struct rtpg_data {
 			) \
 		)
 
-#endif /* __SPC3_H__ */
+#endif /* ALUA_SPC3_H_INCLUDED */
diff --git a/libmultipath/prioritizers/weightedpath.h b/libmultipath/prioritizers/weightedpath.h
index a1b268f..a8030fd 100644
--- a/libmultipath/prioritizers/weightedpath.h
+++ b/libmultipath/prioritizers/weightedpath.h
@@ -1,5 +1,5 @@
-#ifndef _WEIGHTED_PATH_H
-#define _WEIGHTED_PATH_H
+#ifndef WEIGHTEDPATH_H_INCLUDED
+#define WEIGHTEDPATH_H_INCLUDED
 
 #define PRIO_WEIGHTED_PATH "weightedpath"
 #define HBTL "hbtl"
diff --git a/libmultipath/prkey.h b/libmultipath/prkey.h
index 43afd5e..a89a617 100644
--- a/libmultipath/prkey.h
+++ b/libmultipath/prkey.h
@@ -1,5 +1,5 @@
-#ifndef _PRKEY_H
-#define _PRKEY_H
+#ifndef PRKEY_H_INCLUDED
+#define PRKEY_H_INCLUDED
 
 #include "structs.h"
 #include <inttypes.h>
@@ -20,4 +20,4 @@ int set_prkey(struct config *conf, struct multipath *mpp,
 	      uint64_t prkey, uint8_t sa_flags);
 int get_prkey(struct multipath *mpp, uint64_t *prkey, uint8_t *sa_flags);
 
-#endif /* _PRKEY_H */
+#endif /* PRKEY_H_INCLUDED */
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 73615c2..5593005 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -1,3 +1,5 @@
+#ifndef PROPSEL_H_INCLUDED
+#define PROPSEL_H_INCLUDED
 int select_rr_weight (struct config *conf, struct multipath * mp);
 int select_pgfailback (struct config *conf, struct multipath * mp);
 int select_detect_pgpolicy (struct config *conf, struct multipath * mp);
@@ -42,3 +44,4 @@ void reconcile_features_with_options(const char *id, char **features,
 				     int *retain_hwhandler);
 int select_all_tg_pt (struct config *conf, struct multipath * mp);
 int select_vpd_vendor_id (struct path *pp);
+#endif
diff --git a/libmultipath/sg_include.h b/libmultipath/sg_include.h
index 750a13a..43bff2d 100644
--- a/libmultipath/sg_include.h
+++ b/libmultipath/sg_include.h
@@ -1,3 +1,5 @@
+#ifndef SG_INCLUDE_H_INCLUDED
+#define SG_INCLUDE_H_INCLUDED
 #define __user
 #include <scsi/sg.h>
 
@@ -23,3 +25,4 @@
 				      * retry or fail IO */
 #define DID_TRANSPORT_FAILFAST	0x0f /* Transport class fastfailed the io */
 #endif
+#endif
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 9150988..6b5de7a 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -1,5 +1,5 @@
-#ifndef _STRUCTS_H
-#define _STRUCTS_H
+#ifndef STRUCTS_H_INCLUDED
+#define STRUCTS_H_INCLUDED
 
 #include <sys/types.h>
 #include <inttypes.h>
@@ -584,4 +584,4 @@ int pathcmp (const struct pathgroup *, const struct pathgroup *);
 int add_feature (char **, const char *);
 int remove_feature (char **, const char *);
 
-#endif /* _STRUCTS_H */
+#endif /* STRUCTS_H_INCLUDED */
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 01f5dc4..541327d 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -1,5 +1,5 @@
-#ifndef _STRUCTS_VEC_H
-#define _STRUCTS_VEC_H
+#ifndef STRUCTS_VEC_H_INCLUDED
+#define STRUCTS_VEC_H_INCLUDED
 
 #include "vector.h"
 #include "config.h"
@@ -39,4 +39,4 @@ int update_multipath_table (struct multipath *mpp, vector pathvec, int flags);
 int update_multipath_status (struct multipath *mpp);
 vector get_used_hwes(const struct _vector *pathvec);
 
-#endif /* _STRUCTS_VEC_H */
+#endif /* STRUCTS_VEC_H_INCLUDED */
diff --git a/libmultipath/switchgroup.h b/libmultipath/switchgroup.h
index 9365e2e..e499b92 100644
--- a/libmultipath/switchgroup.h
+++ b/libmultipath/switchgroup.h
@@ -1,2 +1,7 @@
+#ifndef SWITCHGROUP_H_INCLUDED
+#define SWITCHGROUP_H_INCLUDED
+
 void path_group_prio_update (struct pathgroup * pgp);
 int select_path_group (struct multipath * mpp);
+
+#endif
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 3be3f66..45f24c3 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -2,8 +2,8 @@
  * sysfs.h
  */
 
-#ifndef _LIBMULTIPATH_SYSFS_H
-#define _LIBMULTIPATH_SYSFS_H
+#ifndef SYSFS_H_INCLUDED
+#define SYSFS_H_INCLUDED
 #include <stdbool.h>
 #include "strbuf.h"
 
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 53a7ca2..6929678 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -1,5 +1,5 @@
-#ifndef _UEVENT_H
-#define _UEVENT_H
+#ifndef UEVENT_H_INCLUDED
+#define UEVENT_H_INCLUDED
 
 /*
  * buffer for environment variables, the kernel's size in
@@ -69,4 +69,4 @@ static inline char *uevent_get_dm_action(const struct uevent *uev)
 	return uevent_get_dm_str(uev, "DM_ACTION");
 }
 
-#endif /* _UEVENT_H */
+#endif /* UEVENT_H_INCLUDED */
diff --git a/libmultipath/unaligned.h b/libmultipath/unaligned.h
index b9eaa7c..ea8b4a9 100644
--- a/libmultipath/unaligned.h
+++ b/libmultipath/unaligned.h
@@ -1,5 +1,5 @@
-#ifndef _UNALIGNED_H_
-#define _UNALIGNED_H_
+#ifndef UNALIGNED_H_INCLUDED
+#define UNALIGNED_H_INCLUDED
 
 #include <stdint.h>
 
@@ -51,4 +51,4 @@ static inline void put_unaligned_be64(uint64_t val, void *ptr)
 	put_unaligned_be32(val, p + 4);
 }
 
-#endif /* _UNALIGNED_H_ */
+#endif /* UNALIGNED_H_INCLUDED */
diff --git a/libmultipath/valid.h b/libmultipath/valid.h
index 731e6ef..96ba554 100644
--- a/libmultipath/valid.h
+++ b/libmultipath/valid.h
@@ -14,8 +14,8 @@
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
-#ifndef _VALID_H
-#define _VALID_H
+#ifndef VALID_H_INCLUDED
+#define VALID_H_INCLUDED
 
 /*
  * PATH_IS_VALID_NO_CHECK is returned when multipath should claim
@@ -39,4 +39,4 @@ enum is_path_valid_result {
 int is_path_valid(const char *name, struct config *conf, struct path *pp,
 		  bool check_multipathd);
 
-#endif /* _VALID_D */
+#endif /* VALID_H_INCLUDED */
diff --git a/libmultipath/version.h b/libmultipath/version.h
index 271d8e7..5dae233 100644
--- a/libmultipath/version.h
+++ b/libmultipath/version.h
@@ -17,8 +17,8 @@
  *
  * Copyright (c) 2006 Christophe Varoqui
  */
-#ifndef _VERSION_H
-#define _VERSION_H
+#ifndef VERSION_H_INCLUDED
+#define VERSION_H_INCLUDED
 
 #define VERSION_CODE 0x000909
 /* MMDDYY, in hex */
@@ -35,4 +35,4 @@
 		MULTIPATH_VERSION(VERSION_CODE),                \
 		MULTIPATH_VERSION(DATE_CODE)
 
-#endif /* _VERSION_H */
+#endif /* VERSION_H_INCLUDED */
diff --git a/libmultipath/wwids.h b/libmultipath/wwids.h
index 0c6ee54..ee47ad9 100644
--- a/libmultipath/wwids.h
+++ b/libmultipath/wwids.h
@@ -2,8 +2,8 @@
  * Copyright (c) 2010 Benjamin Marzinski, Redhat
  */
 
-#ifndef _WWIDS_H
-#define _WWIDS_H
+#ifndef WWIDS_H_INCLUDED
+#define WWIDS_H_INCLUDED
 
 #define WWIDS_FILE_HEADER \
 "# Multipath wwids, Version : 1.0\n" \
@@ -29,4 +29,4 @@ enum {
 int is_failed_wwid(const char *wwid);
 int mark_failed_wwid(const char *wwid);
 int unmark_failed_wwid(const char *wwid);
-#endif /* _WWIDS_H */
+#endif /* WWIDS_H_INCLUDED */
diff --git a/mpathpersist/main.h b/mpathpersist/main.h
index bfbb82e..fc0bb26 100644
--- a/mpathpersist/main.h
+++ b/mpathpersist/main.h
@@ -1,3 +1,6 @@
+#ifndef MPATHPERSIST_MAIN_H_INCLUDED
+#define MPATHPERSIST_MAIN_H_INCLUDED
+
 static struct option long_options[] = {
 	{"verbose", 1, NULL, 'v'},
 	{"clear", 0, NULL, 'C'},
@@ -28,3 +31,4 @@ static struct option long_options[] = {
 };
 
 static void usage(void);
+#endif
diff --git a/multipathd/cli.h b/multipathd/cli.h
index c6b79c9..2940832 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -1,5 +1,5 @@
-#ifndef _CLI_H_
-#define _CLI_H_
+#ifndef CLI_H_INCLUDED
+#define CLI_H_INCLUDED
 
 #include <stdint.h>
 
@@ -157,4 +157,4 @@ vector get_keys(void);
 vector get_handlers(void);
 struct key *find_key (const char * str);
 
-#endif /* _CLI_H_ */
+#endif /* CLI_H_INCLUDED */
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index 7eaf847..2303d8a 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -1,5 +1,5 @@
-#ifndef _CLI_HANDLERS_H
-#define _CLI_HANDLERS_H
+#ifndef CLI_HANDLERS_H_INCLUDED
+#define CLI_HANDLERS_H_INCLUDED
 
 void init_handler_callbacks(void);
 
diff --git a/multipathd/dmevents.h b/multipathd/dmevents.h
index 012fbad..debb3da 100644
--- a/multipathd/dmevents.h
+++ b/multipathd/dmevents.h
@@ -1,5 +1,5 @@
-#ifndef _DMEVENTS_H
-#define _DMEVENTS_H
+#ifndef DMEVENTS_H_INCLUDED
+#define DMEVENTS_H_INCLUDED
 
 #include "structs_vec.h"
 
@@ -10,4 +10,4 @@ int watch_dmevents(char *name);
 void unwatch_all_dmevents(void);
 void *wait_dmevents (void *unused);
 
-#endif /* _DMEVENTS_H */
+#endif /* DMEVENTS_H_INCLUDED */
diff --git a/multipathd/fpin.h b/multipathd/fpin.h
index 3c37444..981140a 100644
--- a/multipathd/fpin.h
+++ b/multipathd/fpin.h
@@ -1,5 +1,5 @@
-#ifndef __FPIN_H__
-#define __FPIN_H__
+#ifndef FPIN_H_INCLUDED
+#define FPIN_H_INCLUDED
 #include "autoconfig.h"
 
 #ifdef FPIN_EVENT_HANDLER
diff --git a/multipathd/init_unwinder.h b/multipathd/init_unwinder.h
index ada09f8..edaa8be 100644
--- a/multipathd/init_unwinder.h
+++ b/multipathd/init_unwinder.h
@@ -1,5 +1,5 @@
-#ifndef _INIT_UNWINDER_H
-#define _INIT_UNWINDER_H 1
+#ifndef INIT_UNWINDER_H_INCLUDED
+#define INIT_UNWINDER_H_INCLUDED
 
 /*
  * init_unwinder(): make sure unwinder symbols are loaded
diff --git a/multipathd/main.h b/multipathd/main.h
index ef838a0..c94362e 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -1,5 +1,5 @@
-#ifndef MAIN_H
-#define MAIN_H
+#ifndef MAIN_H_INCLUDED
+#define MAIN_H_INCLUDED
 
 #define MAPGCINT 5
 
@@ -52,4 +52,4 @@ bool check_path_wwid_change(struct path *pp);
 int finish_path_init(struct path *pp, struct vectors * vecs);
 int resize_map(struct multipath *mpp, unsigned long long size,
 	       struct vectors *vecs);
-#endif /* MAIN_H */
+#endif /* MAIN_H_INCLUDED */
diff --git a/multipathd/pidfile.h b/multipathd/pidfile.h
index d308892..fae5774 100644
--- a/multipathd/pidfile.h
+++ b/multipathd/pidfile.h
@@ -1 +1,5 @@
+#ifndef PIDFILE_H_INCLUDED
+#define PIDFILE_H_INCLUDED
 int pidfile_create(const char *pidFile, pid_t pid);
+#endif
+
diff --git a/multipathd/uxclnt.h b/multipathd/uxclnt.h
index 8e2cdce..dd66c52 100644
--- a/multipathd/uxclnt.h
+++ b/multipathd/uxclnt.h
@@ -1 +1,6 @@
+#ifndef UXCLNT_H_INCLUDED
+#define UXCLNT_H_INCLUDED
+
 int uxclnt(char * inbuf, unsigned int timeout);
+
+#endif
diff --git a/multipathd/uxlsnr.h b/multipathd/uxlsnr.h
index 3e45930..a14a667 100644
--- a/multipathd/uxlsnr.h
+++ b/multipathd/uxlsnr.h
@@ -1,5 +1,5 @@
-#ifndef _UXLSNR_H
-#define _UXLSNR_H
+#ifndef UXLSNR_H_INCLUDED
+#define UXLSNR_H_INCLUDED
 
 #include <stdbool.h>
 
diff --git a/multipathd/waiter.h b/multipathd/waiter.h
index 28e0f6d..7b02272 100644
--- a/multipathd/waiter.h
+++ b/multipathd/waiter.h
@@ -1,5 +1,5 @@
-#ifndef _WAITER_H
-#define _WAITER_H
+#ifndef WAITER_H_INCLUDED
+#define WAITER_H_INCLUDED
 
 extern pthread_attr_t waiter_attr;
 
@@ -14,4 +14,4 @@ struct event_thread {
 void stop_waiter_thread (struct multipath *mpp);
 int start_waiter_thread (struct multipath *mpp, struct vectors *vecs);
 
-#endif /* _WAITER_H */
+#endif /* WAITER_H_INCLUDED */
diff --git a/tests/test-lib.h b/tests/test-lib.h
index efd03a7..61e67b2 100644
--- a/tests/test-lib.h
+++ b/tests/test-lib.h
@@ -1,5 +1,5 @@
-#ifndef __LIB_H
-#define __LIB_H
+#ifndef TEST_LIB_H_INCLUDED
+#define TEST_LIB_H_INCLUDED
 
 extern const int default_mask;
 extern const char default_devnode[];
diff --git a/tests/test-log.h b/tests/test-log.h
index 6d22cd2..48c0c17 100644
--- a/tests/test-log.h
+++ b/tests/test-log.h
@@ -1,5 +1,5 @@
-#ifndef _TEST_LOG_H
-#define _TEST_LOG_H
+#ifndef TEST_LOG_H_INCLUDED
+#define TEST_LOG_H_INCLUDED
 
 __attribute__((format(printf, 2, 0)))
 void __wrap_dlog (int prio, const char * fmt, ...);
diff --git a/tests/wrap64.h b/tests/wrap64.h
index af6cc2b..fe985a7 100644
--- a/tests/wrap64.h
+++ b/tests/wrap64.h
@@ -1,5 +1,5 @@
-#ifndef _WRAP64_H
-#define _WRAP64_H 1
+#ifndef WRAP64_H_INCLUDED
+#define WRAP64_H_INCLUDED
 #include <syscall.h>
 #include <linux/types.h>
 /* The following include is required for LIBAIO_REDIRECT */
-- 
2.46.0

