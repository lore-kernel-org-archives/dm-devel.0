Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D68DC38147
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 20:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661200923;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=v+1peY76Sylmu4WV8v4ecqprU/qpmwDVtnHf2u7zNQo=;
	b=UwF37uS8RZXrP7wQu2CaUA32ZSXoZ0o6Q4rmUtje9hLwn7tziaN/GL2tNEfUT0fATAmZNl
	l4RIR9egYXxdMAEaQLEeSM72hIcECWj/wyBAmRI8oGgiT+JZCf62faKyjVG+2vzR2Qpn/e
	q3uF4CTMmUutDN6EK57p9Cr86ogi4sQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-PO3reWM3P3CBNZzU-CEosA-1; Mon, 22 Aug 2022 16:41:59 -0400
X-MC-Unique: PO3reWM3P3CBNZzU-CEosA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 984A41011602;
	Mon, 22 Aug 2022 20:41:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 861BE2166B26;
	Mon, 22 Aug 2022 20:41:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 741731946A5B;
	Mon, 22 Aug 2022 20:41:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 21E0C1946A40
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 20:41:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 13B3C492CA5; Mon, 22 Aug 2022 20:41:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 10128492C3B
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE87985A59A
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:55 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-134-340sBAufOOW8OLL-0shyXQ-1; Mon,
 22 Aug 2022 16:41:51 -0400
X-MC-Unique: 340sBAufOOW8OLL-0shyXQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 5B7D7202C6;
 Mon, 22 Aug 2022 20:41:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0DE7313523;
 Mon, 22 Aug 2022 20:41:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id oHzNAQ3qA2MOAwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 22 Aug 2022 20:41:49 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 22 Aug 2022 22:41:11 +0200
Message-Id: <20220822204119.20719-4-mwilck@suse.com>
In-Reply-To: <20220822204119.20719-1-mwilck@suse.com>
References: <20220822204119.20719-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 03/11] libmultipath: move all reservation key
 functions to prkey.c
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Also make parse_prkey() static, and avoid including libmpathpersist
headers in libmultipath. The only exception is now prkey.c, where
we pull in some public declarations from mpath_persist.h.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile |  2 +-
 libmultipath/dict.c   | 16 +-------------
 libmultipath/dict.h   |  2 --
 libmultipath/prkey.c  | 49 ++++++++++++++++++++++++++++++++++++++++++-
 libmultipath/prkey.h  |  3 +++
 libmultipath/util.c   | 32 ----------------------------
 libmultipath/util.h   |  2 --
 7 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index fb03200..033fc83 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -8,7 +8,7 @@ DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
 VERSION_SCRIPT := libmultipath.version
 
-CPPFLAGS += -I$(mpathcmddir) -I$(mpathpersistdir) -I$(nvmedir)
+CPPFLAGS += -I$(mpathcmddir) -I$(nvmedir)
 CFLAGS += $(LIB_CFLAGS)
 
 LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd -lurcu -laio
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index ad049cc..aa93fe4 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -24,10 +24,10 @@
 #include <errno.h>
 #include <inttypes.h>
 #include <libudev.h>
-#include <mpath_persist.h>
 #include "mpath_cmd.h"
 #include "dict.h"
 #include "strbuf.h"
+#include "prkey.h"
 
 static void
 do_set_int(vector strvec, void *ptr, int min, int max, const char *file,
@@ -1404,20 +1404,6 @@ set_reservation_key(vector strvec, struct be64 *be64_ptr, uint8_t *flags_ptr,
 	return 0;
 }
 
-int
-print_reservation_key(struct strbuf *buff,
-		      struct be64 key, uint8_t flags, int source)
-{
-	char *flagstr = "";
-	if (source == PRKEY_SOURCE_NONE)
-		return 0;
-	if (source == PRKEY_SOURCE_FILE)
-		return append_strbuf_quoted(buff, "file");
-	if (flags & MPATH_F_APTPL_MASK)
-		flagstr = ":aptpl";
-	return print_strbuf(buff, "0x%" PRIx64 "%s", get_be64(key), flagstr);
-}
-
 static int
 def_reservation_key_handler(struct config *conf, vector strvec,
 			    const char *file, int line_nr)
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index d80f990..15d9cba 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -16,7 +16,5 @@ int print_pgpolicy(struct strbuf *buff, long v);
 int print_no_path_retry(struct strbuf *buff, long v);
 int print_undef_off_zero(struct strbuf *buff, long v);
 int print_dev_loss(struct strbuf *buff, unsigned long v);
-int print_reservation_key(struct strbuf *buff,
-			  struct be64 key, uint8_t flags, int source);
 int print_off_int_undef(struct strbuf *buff, long v);
 #endif /* _DICT_H */
diff --git a/libmultipath/prkey.c b/libmultipath/prkey.c
index d645f81..a215499 100644
--- a/libmultipath/prkey.c
+++ b/libmultipath/prkey.c
@@ -4,6 +4,7 @@
 #include "config.h"
 #include "util.h"
 #include "propsel.h"
+#include "strbuf.h"
 #include "prkey.h"
 #include <sys/types.h>
 #include <unistd.h>
@@ -12,11 +13,57 @@
 #include <inttypes.h>
 #include <errno.h>
 #include <libudev.h>
-#include <mpath_persist.h>
+/* MPATH_F_APTPL_MASK is publicly defined in mpath_persist.h */
+#include <../libmpathpersist/mpath_persist.h>
 
 #define PRKEY_READ 0
 #define PRKEY_WRITE 1
 
+int
+print_reservation_key(struct strbuf *buff,
+		      struct be64 key, uint8_t flags, int source)
+{
+	char *flagstr = "";
+	if (source == PRKEY_SOURCE_NONE)
+		return 0;
+	if (source == PRKEY_SOURCE_FILE)
+		return append_strbuf_quoted(buff, "file");
+	if (flags & MPATH_F_APTPL_MASK)
+		flagstr = ":aptpl";
+	return print_strbuf(buff, "0x%" PRIx64 "%s", get_be64(key), flagstr);
+}
+
+static int parse_prkey(const char *ptr, uint64_t *prkey)
+{
+	if (!ptr)
+		return 1;
+	if (*ptr == '0')
+		ptr++;
+	if (*ptr == 'x' || *ptr == 'X')
+		ptr++;
+	if (*ptr == '\0' || strlen(ptr) > 16)
+		return 1;
+	if (strlen(ptr) != strspn(ptr, "0123456789aAbBcCdDeEfF"))
+		return 1;
+	if (sscanf(ptr, "%" SCNx64 "", prkey) != 1)
+		return 1;
+	return 0;
+}
+
+int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags)
+{
+	char *flagstr;
+
+	flagstr = strchr(ptr, ':');
+	*flags = 0;
+	if (flagstr) {
+		*flagstr++ = '\0';
+		if (strlen(flagstr) == 5 && strcmp(flagstr, "aptpl") == 0)
+			*flags = MPATH_F_APTPL_MASK;
+	}
+	return parse_prkey(ptr, prkey);
+}
+
 static int do_prkey(int fd, char *wwid, char *keystr, int cmd)
 {
 	char buf[4097];
diff --git a/libmultipath/prkey.h b/libmultipath/prkey.h
index 6739191..a16de10 100644
--- a/libmultipath/prkey.h
+++ b/libmultipath/prkey.h
@@ -13,6 +13,9 @@
 "# prkey wwid\n" \
 "#\n"
 
+int print_reservation_key(struct strbuf *buff,
+			  struct be64 key, uint8_t flags, int source);
+int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags);
 int set_prkey(struct config *conf, struct multipath *mpp, uint64_t prkey,
 	      uint8_t sa_flags);
 int get_prkey(struct config *conf, struct multipath *mpp, uint64_t *prkey,
diff --git a/libmultipath/util.c b/libmultipath/util.c
index e7e7d4c..6979e74 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -13,7 +13,6 @@
 #include <unistd.h>
 #include <errno.h>
 #include <libudev.h>
-#include <mpath_persist.h>
 
 #include "util.h"
 #include "debug.h"
@@ -333,37 +332,6 @@ int get_linux_version_code(void)
 	return _linux_version_code;
 }
 
-int parse_prkey(const char *ptr, uint64_t *prkey)
-{
-	if (!ptr)
-		return 1;
-	if (*ptr == '0')
-		ptr++;
-	if (*ptr == 'x' || *ptr == 'X')
-		ptr++;
-	if (*ptr == '\0' || strlen(ptr) > 16)
-		return 1;
-	if (strlen(ptr) != strspn(ptr, "0123456789aAbBcCdDeEfF"))
-		return 1;
-	if (sscanf(ptr, "%" SCNx64 "", prkey) != 1)
-		return 1;
-	return 0;
-}
-
-int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags)
-{
-	char *flagstr;
-
-	flagstr = strchr(ptr, ':');
-	*flags = 0;
-	if (flagstr) {
-		*flagstr++ = '\0';
-		if (strlen(flagstr) == 5 && strcmp(flagstr, "aptpl") == 0)
-			*flags = MPATH_F_APTPL_MASK;
-	}
-	return parse_prkey(ptr, prkey);
-}
-
 int safe_write(int fd, const void *buf, size_t count)
 {
 	while (count > 0) {
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 5a44018..bede49d 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -24,8 +24,6 @@ char *convert_dev(char *dev, int is_path_device);
 void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
 int systemd_service_enabled(const char *dev);
 int get_linux_version_code(void);
-int parse_prkey(const char *ptr, uint64_t *prkey);
-int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags);
 int safe_write(int fd, const void *buf, size_t count);
 void set_max_fds(rlim_t max_fds);
 int should_exit(void);
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

