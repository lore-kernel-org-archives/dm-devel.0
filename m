Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79DB4ECAAA3
	for <dm-devel@archiver.kernel.org>; Fri, 26 Aug 2022 16:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661530957;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=x9Dkw3VxmfkTyRk5W1GseLkQTw1EzBQuyVYYYcjVNuc=;
	b=Xv8ElpdW6Sn0HKaVZvQjKJmrA+61cEJr+PLYx7xB8IPguAEjRz3is/ix4Gis2YCX1Eynqu
	jnUcjfKVZ4ZQBbFTHqMqTKCj/OKcTIItd9/5wOjIIgSsEStMpMlAgYagWZi8VY4vGCRIE1
	Lpx1XF+xXa6Wgyx6rHWwZeRGn98m7A8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-s2wsiTaQOA2ML-BOPcyc6Q-1; Fri, 26 Aug 2022 12:22:35 -0400
X-MC-Unique: s2wsiTaQOA2ML-BOPcyc6Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EE2829AB44C;
	Fri, 26 Aug 2022 16:22:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 887D32166B32;
	Fri, 26 Aug 2022 16:22:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8AF411946A5E;
	Fri, 26 Aug 2022 16:22:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8B9691946A4C
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 Aug 2022 16:22:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60D02492CA2; Fri, 26 Aug 2022 16:22:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D24E492C3B
 for <dm-devel@redhat.com>; Fri, 26 Aug 2022 16:22:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCCB4280EA37
 for <dm-devel@redhat.com>; Fri, 26 Aug 2022 16:22:27 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-378-OO0wSfvJNaKW1Xu1e_VoJw-1; Fri,
 26 Aug 2022 12:22:26 -0400
X-MC-Unique: OO0wSfvJNaKW1Xu1e_VoJw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 08C201F917;
 Fri, 26 Aug 2022 16:22:25 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C7F6213421;
 Fri, 26 Aug 2022 16:22:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id MB4tL0DzCGPocAAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 26 Aug 2022 16:22:24 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 26 Aug 2022 18:22:00 +0200
Message-Id: <20220826162203.20317-3-mwilck@suse.com>
In-Reply-To: <20220826162203.20317-1-mwilck@suse.com>
References: <20220826162203.20317-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v3 2/5] libmultipath: modifications for msort.c
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

We don't want to fallback to qsort if memory is tight, as libc's
routine does. Other than that, compile error fixes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile |  2 +-
 libmultipath/msort.c  | 75 ++++++++++---------------------------------
 libmultipath/msort.h  |  6 ++++
 3 files changed, 24 insertions(+), 59 deletions(-)
 create mode 100644 libmultipath/msort.h

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index fb03200..a70acab 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -64,7 +64,7 @@ OBJS-O := parser.o vector.o devmapper.o \
 	log.o configure.o structs_vec.o sysfs.o \
 	lock.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
 	io_err_stat.o dm-generic.o generic.o nvme-lib.o \
-	libsg.o valid.o strbuf.o
+	libsg.o valid.o strbuf.o msort.o
 
 OBJS := $(OBJS-O) $(OBJS-U)
 
diff --git a/libmultipath/msort.c b/libmultipath/msort.c
index cbe9a4a..5ea05a7 100644
--- a/libmultipath/msort.c
+++ b/libmultipath/msort.c
@@ -21,9 +21,10 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
-#include <memcopy.h>
+#include <string.h>
 #include <errno.h>
-#include <atomic.h>
+
+typedef int(*__compar_d_fn_t)(const void *, const void *, void *);
 
 struct msort_param
 {
@@ -160,8 +161,8 @@ msort_with_tmp (const struct msort_param *p, void *b, size_t n)
 }
 
 
-void
-__qsort_r (void *b, size_t n, size_t s, __compar_d_fn_t cmp, void *arg)
+static void
+msort_r (void *b, size_t n, size_t s, __compar_d_fn_t cmp, void *arg)
 {
   size_t size = n * s;
   char *tmp = NULL;
@@ -173,60 +174,15 @@ __qsort_r (void *b, size_t n, size_t s, __compar_d_fn_t cmp, void *arg)
 
   if (size < 1024)
     /* The temporary array is small, so put it on the stack.  */
-    p.t = __alloca (size);
+    p.t = alloca (size);
   else
     {
-      /* We should avoid allocating too much memory since this might
-	 have to be backed up by swap space.  */
-      static long int phys_pages;
-      static int pagesize;
-
-      if (pagesize == 0)
-	{
-	  phys_pages = __sysconf (_SC_PHYS_PAGES);
-
-	  if (phys_pages == -1)
-	    /* Error while determining the memory size.  So let's
-	       assume there is enough memory.  Otherwise the
-	       implementer should provide a complete implementation of
-	       the `sysconf' function.  */
-	    phys_pages = (long int) (~0ul >> 1);
-
-	  /* The following determines that we will never use more than
-	     a quarter of the physical memory.  */
-	  phys_pages /= 4;
-
-	  /* Make sure phys_pages is written to memory.  */
-	  atomic_write_barrier ();
-
-	  pagesize = __sysconf (_SC_PAGESIZE);
-	}
-
-      /* Just a comment here.  We cannot compute
-	   phys_pages * pagesize
-	   and compare the needed amount of memory against this value.
-	   The problem is that some systems might have more physical
-	   memory then can be represented with a `size_t' value (when
-	   measured in bytes.  */
-
-      /* If the memory requirements are too high don't allocate memory.  */
-      if (size / pagesize > (size_t) phys_pages)
-	{
-	  _quicksort (b, n, s, cmp, arg);
-	  return;
-	}
-
       /* It's somewhat large, so malloc it.  */
       int save = errno;
       tmp = malloc (size);
-      __set_errno (save);
+      errno = save;
       if (tmp == NULL)
-	{
-	  /* Couldn't get space, so use the slower algorithm
-	     that doesn't need a temporary array.  */
-	  _quicksort (b, n, s, cmp, arg);
-	  return;
-	}
+	      return;
       p.t = tmp;
     }
 
@@ -297,13 +253,16 @@ __qsort_r (void *b, size_t n, size_t s, __compar_d_fn_t cmp, void *arg)
     }
   free (tmp);
 }
-libc_hidden_def (__qsort_r)
-weak_alias (__qsort_r, qsort_r)
-
 
+/*
+ * glibc apparently doesn't use -Wcast-function-type.
+ * If this is safe for them, it should be for us, too.
+ */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wcast-function-type"
 void
-qsort (void *b, size_t n, size_t s, __compar_fn_t cmp)
+msort (void *b, size_t n, size_t s, __compar_fn_t cmp)
 {
-  return __qsort_r (b, n, s, (__compar_d_fn_t) cmp, NULL);
+	return msort_r (b, n, s, (__compar_d_fn_t)cmp, NULL);
 }
-libc_hidden_def (qsort)
+#pragma GCC diagnostic pop
diff --git a/libmultipath/msort.h b/libmultipath/msort.h
new file mode 100644
index 0000000..caef9b6
--- /dev/null
+++ b/libmultipath/msort.h
@@ -0,0 +1,6 @@
+#ifndef __MSORT_H
+#define __MSORT_H
+typedef int(*__compar_fn_t)(const void *, const void *);
+void msort (void *b, size_t n, size_t s, __compar_fn_t cmp);
+
+#endif
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

