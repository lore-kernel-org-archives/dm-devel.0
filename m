Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F466ECAAD4
	for <dm-devel@archiver.kernel.org>; Fri, 26 Aug 2022 16:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661530955;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qhbs2rShylzDT18KWz9u3IkNygyhs2yIE8sjrUSU8mI=;
	b=GKw05GAoHzlrQHyMSXjyHz8toZqthplJaajCIYO1ReO5cqBnGo6ZLxCQSQxHKhKBtgCNPF
	oW0Gaee4YSkagRah+zA24MGoN9JPSPaq7PgLV0DUm2hSsHlfrfe+BlUclB/GCKNRpb8T+b
	hML3v/X8D9duU/3Qz9q0UIQeejOPFsA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-ZsbB9YGINbKCnjZRnUme7Q-1; Fri, 26 Aug 2022 12:22:34 -0400
X-MC-Unique: ZsbB9YGINbKCnjZRnUme7Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55777907339;
	Fri, 26 Aug 2022 16:22:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 42D5E40315A;
	Fri, 26 Aug 2022 16:22:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 374291946A58;
	Fri, 26 Aug 2022 16:22:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B948F1946A70
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 Aug 2022 16:22:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A88E6C15BBD; Fri, 26 Aug 2022 16:22:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A4C85C15BBA
 for <dm-devel@redhat.com>; Fri, 26 Aug 2022 16:22:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B51D3801F4D
 for <dm-devel@redhat.com>; Fri, 26 Aug 2022 16:22:29 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-54-GhvTXYiiOIipXCds6SV41w-1; Fri,
 26 Aug 2022 12:22:25 -0400
X-MC-Unique: GhvTXYiiOIipXCds6SV41w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id C065B1F889;
 Fri, 26 Aug 2022 16:22:24 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8AD3213421;
 Fri, 26 Aug 2022 16:22:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id oDBzIEDzCGPocAAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 26 Aug 2022 16:22:24 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 26 Aug 2022 18:21:59 +0200
Message-Id: <20220826162203.20317-2-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v3 1/5] libmultipath: add msort.c from glibc
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

glibc's msort.c contains a stable sort algorithm based on mergesort.
This will be useful for us, as qsort(3) is not necessarily stable.

The added code is under LGPL-2.1.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/msort.c | 309 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 309 insertions(+)
 create mode 100644 libmultipath/msort.c

diff --git a/libmultipath/msort.c b/libmultipath/msort.c
new file mode 100644
index 0000000..cbe9a4a
--- /dev/null
+++ b/libmultipath/msort.c
@@ -0,0 +1,309 @@
+/* An alternative to qsort, with an identical interface.
+   This file is part of the GNU C Library.
+   Copyright (C) 1992-2022 Free Software Foundation, Inc.
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library; if not, see
+   <https://www.gnu.org/licenses/>.  */
+
+#include <alloca.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <memcopy.h>
+#include <errno.h>
+#include <atomic.h>
+
+struct msort_param
+{
+  size_t s;
+  size_t var;
+  __compar_d_fn_t cmp;
+  void *arg;
+  char *t;
+};
+static void msort_with_tmp (const struct msort_param *p, void *b, size_t n);
+
+static void
+msort_with_tmp (const struct msort_param *p, void *b, size_t n)
+{
+  char *b1, *b2;
+  size_t n1, n2;
+
+  if (n <= 1)
+    return;
+
+  n1 = n / 2;
+  n2 = n - n1;
+  b1 = b;
+  b2 = (char *) b + (n1 * p->s);
+
+  msort_with_tmp (p, b1, n1);
+  msort_with_tmp (p, b2, n2);
+
+  char *tmp = p->t;
+  const size_t s = p->s;
+  __compar_d_fn_t cmp = p->cmp;
+  void *arg = p->arg;
+  switch (p->var)
+    {
+    case 0:
+      while (n1 > 0 && n2 > 0)
+	{
+	  if ((*cmp) (b1, b2, arg) <= 0)
+	    {
+	      *(uint32_t *) tmp = *(uint32_t *) b1;
+	      b1 += sizeof (uint32_t);
+	      --n1;
+	    }
+	  else
+	    {
+	      *(uint32_t *) tmp = *(uint32_t *) b2;
+	      b2 += sizeof (uint32_t);
+	      --n2;
+	    }
+	  tmp += sizeof (uint32_t);
+	}
+      break;
+    case 1:
+      while (n1 > 0 && n2 > 0)
+	{
+	  if ((*cmp) (b1, b2, arg) <= 0)
+	    {
+	      *(uint64_t *) tmp = *(uint64_t *) b1;
+	      b1 += sizeof (uint64_t);
+	      --n1;
+	    }
+	  else
+	    {
+	      *(uint64_t *) tmp = *(uint64_t *) b2;
+	      b2 += sizeof (uint64_t);
+	      --n2;
+	    }
+	  tmp += sizeof (uint64_t);
+	}
+      break;
+    case 2:
+      while (n1 > 0 && n2 > 0)
+	{
+	  unsigned long *tmpl = (unsigned long *) tmp;
+	  unsigned long *bl;
+
+	  tmp += s;
+	  if ((*cmp) (b1, b2, arg) <= 0)
+	    {
+	      bl = (unsigned long *) b1;
+	      b1 += s;
+	      --n1;
+	    }
+	  else
+	    {
+	      bl = (unsigned long *) b2;
+	      b2 += s;
+	      --n2;
+	    }
+	  while (tmpl < (unsigned long *) tmp)
+	    *tmpl++ = *bl++;
+	}
+      break;
+    case 3:
+      while (n1 > 0 && n2 > 0)
+	{
+	  if ((*cmp) (*(const void **) b1, *(const void **) b2, arg) <= 0)
+	    {
+	      *(void **) tmp = *(void **) b1;
+	      b1 += sizeof (void *);
+	      --n1;
+	    }
+	  else
+	    {
+	      *(void **) tmp = *(void **) b2;
+	      b2 += sizeof (void *);
+	      --n2;
+	    }
+	  tmp += sizeof (void *);
+	}
+      break;
+    default:
+      while (n1 > 0 && n2 > 0)
+	{
+	  if ((*cmp) (b1, b2, arg) <= 0)
+	    {
+	      tmp = (char *) __mempcpy (tmp, b1, s);
+	      b1 += s;
+	      --n1;
+	    }
+	  else
+	    {
+	      tmp = (char *) __mempcpy (tmp, b2, s);
+	      b2 += s;
+	      --n2;
+	    }
+	}
+      break;
+    }
+
+  if (n1 > 0)
+    memcpy (tmp, b1, n1 * s);
+  memcpy (b, p->t, (n - n2) * s);
+}
+
+
+void
+__qsort_r (void *b, size_t n, size_t s, __compar_d_fn_t cmp, void *arg)
+{
+  size_t size = n * s;
+  char *tmp = NULL;
+  struct msort_param p;
+
+  /* For large object sizes use indirect sorting.  */
+  if (s > 32)
+    size = 2 * n * sizeof (void *) + s;
+
+  if (size < 1024)
+    /* The temporary array is small, so put it on the stack.  */
+    p.t = __alloca (size);
+  else
+    {
+      /* We should avoid allocating too much memory since this might
+	 have to be backed up by swap space.  */
+      static long int phys_pages;
+      static int pagesize;
+
+      if (pagesize == 0)
+	{
+	  phys_pages = __sysconf (_SC_PHYS_PAGES);
+
+	  if (phys_pages == -1)
+	    /* Error while determining the memory size.  So let's
+	       assume there is enough memory.  Otherwise the
+	       implementer should provide a complete implementation of
+	       the `sysconf' function.  */
+	    phys_pages = (long int) (~0ul >> 1);
+
+	  /* The following determines that we will never use more than
+	     a quarter of the physical memory.  */
+	  phys_pages /= 4;
+
+	  /* Make sure phys_pages is written to memory.  */
+	  atomic_write_barrier ();
+
+	  pagesize = __sysconf (_SC_PAGESIZE);
+	}
+
+      /* Just a comment here.  We cannot compute
+	   phys_pages * pagesize
+	   and compare the needed amount of memory against this value.
+	   The problem is that some systems might have more physical
+	   memory then can be represented with a `size_t' value (when
+	   measured in bytes.  */
+
+      /* If the memory requirements are too high don't allocate memory.  */
+      if (size / pagesize > (size_t) phys_pages)
+	{
+	  _quicksort (b, n, s, cmp, arg);
+	  return;
+	}
+
+      /* It's somewhat large, so malloc it.  */
+      int save = errno;
+      tmp = malloc (size);
+      __set_errno (save);
+      if (tmp == NULL)
+	{
+	  /* Couldn't get space, so use the slower algorithm
+	     that doesn't need a temporary array.  */
+	  _quicksort (b, n, s, cmp, arg);
+	  return;
+	}
+      p.t = tmp;
+    }
+
+  p.s = s;
+  p.var = 4;
+  p.cmp = cmp;
+  p.arg = arg;
+
+  if (s > 32)
+    {
+      /* Indirect sorting.  */
+      char *ip = (char *) b;
+      void **tp = (void **) (p.t + n * sizeof (void *));
+      void **t = tp;
+      void *tmp_storage = (void *) (tp + n);
+
+      while ((void *) t < tmp_storage)
+	{
+	  *t++ = ip;
+	  ip += s;
+	}
+      p.s = sizeof (void *);
+      p.var = 3;
+      msort_with_tmp (&p, p.t + n * sizeof (void *), n);
+
+      /* tp[0] .. tp[n - 1] is now sorted, copy around entries of
+	 the original array.  Knuth vol. 3 (2nd ed.) exercise 5.2-10.  */
+      char *kp;
+      size_t i;
+      for (i = 0, ip = (char *) b; i < n; i++, ip += s)
+	if ((kp = tp[i]) != ip)
+	  {
+	    size_t j = i;
+	    char *jp = ip;
+	    memcpy (tmp_storage, ip, s);
+
+	    do
+	      {
+		size_t k = (kp - (char *) b) / s;
+		tp[j] = jp;
+		memcpy (jp, kp, s);
+		j = k;
+		jp = kp;
+		kp = tp[k];
+	      }
+	    while (kp != ip);
+
+	    tp[j] = jp;
+	    memcpy (jp, tmp_storage, s);
+	  }
+    }
+  else
+    {
+      if ((s & (sizeof (uint32_t) - 1)) == 0
+	  && ((char *) b - (char *) 0) % __alignof__ (uint32_t) == 0)
+	{
+	  if (s == sizeof (uint32_t))
+	    p.var = 0;
+	  else if (s == sizeof (uint64_t)
+		   && ((char *) b - (char *) 0) % __alignof__ (uint64_t) == 0)
+	    p.var = 1;
+	  else if ((s & (sizeof (unsigned long) - 1)) == 0
+		   && ((char *) b - (char *) 0)
+		      % __alignof__ (unsigned long) == 0)
+	    p.var = 2;
+	}
+      msort_with_tmp (&p, b, n);
+    }
+  free (tmp);
+}
+libc_hidden_def (__qsort_r)
+weak_alias (__qsort_r, qsort_r)
+
+
+void
+qsort (void *b, size_t n, size_t s, __compar_fn_t cmp)
+{
+  return __qsort_r (b, n, s, (__compar_d_fn_t) cmp, NULL);
+}
+libc_hidden_def (qsort)
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

