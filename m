Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A399CECAAA1
	for <dm-devel@archiver.kernel.org>; Tue, 30 Aug 2022 19:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661887705;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZhPQ0q6S20M2Ope6PUuidQYhIphsqohXXmzuHLxovYU=;
	b=C0EnREaM0cY8eJuUWqLrFcf/sbKm23VM8SysURmHzYeWb70qNOAcq6jSbNtN1skj2wY4AO
	yZhKuPorYZXBpGZFTDJVfrh0ZFCDGeHqBhMjg1RMHTxWAhHpplVUnRCpW9u3vHLJgMbB8o
	7qAd1qKGIDfpESgmxtJROkveQ4dNX1c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-apmihs5PNdi_8yHg3jh0_w-1; Tue, 30 Aug 2022 15:28:24 -0400
X-MC-Unique: apmihs5PNdi_8yHg3jh0_w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C260824065;
	Tue, 30 Aug 2022 19:28:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C3FA141512E;
	Tue, 30 Aug 2022 19:28:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2B8BC1946A6C;
	Tue, 30 Aug 2022 19:28:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F200F1946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 Aug 2022 19:28:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E2BC8492CA2; Tue, 30 Aug 2022 19:28:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DED9A492C3B
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 19:28:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5F4229AB3F7
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 19:28:16 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-269-ODJScXHEMS29An-cnGKPuA-1; Tue,
 30 Aug 2022 15:28:13 -0400
X-MC-Unique: ODJScXHEMS29An-cnGKPuA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id C0AA61FAF0;
 Tue, 30 Aug 2022 19:28:10 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8677D13B22;
 Tue, 30 Aug 2022 19:28:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id kK8KH8pkDmO5GgAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 30 Aug 2022 19:28:10 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 30 Aug 2022 21:27:04 +0200
Message-Id: <20220830192713.19778-4-mwilck@suse.com>
In-Reply-To: <20220830192713.19778-1-mwilck@suse.com>
References: <20220830192713.19778-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v4 03/12] libmultipath: move all reservation key
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Also make parse_prkey() static, and avoid including libmpathpersist
headers in libmultipath. The only exception is now prkey.c, where
we pull in some public declarations from mpath_persist.h.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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
index a70acab..01c7d26 100644
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

