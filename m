Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B283ECAAD5
	for <dm-devel@archiver.kernel.org>; Fri, 26 Aug 2022 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661530956;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WsQ1CbRrBOqdsOUO6qKL7FXbcY+Q8PzALndp7rTbT7I=;
	b=PhCvxaI92XK0909qVCJUrCVHTOXA8q202hMFKXnbzDeK6PKouw90ylwHnbXP5cJ/dpJm5y
	onA7z49GcHQsdWAd93hFsSrUjJVyEvdgj7xHGXVs5otC5W4kBliJei8KsIdQjzfMScVhpm
	as0POngMDCInrWzitpiJgdoLzIw/7x4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462--ONB9NyZNdeo8uuF5Boi5g-1; Fri, 26 Aug 2022 12:22:35 -0400
X-MC-Unique: -ONB9NyZNdeo8uuF5Boi5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EEA08039C5;
	Fri, 26 Aug 2022 16:22:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 178C040E7F29;
	Fri, 26 Aug 2022 16:22:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B7B461946A6F;
	Fri, 26 Aug 2022 16:22:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 70E4A1946A43
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 Aug 2022 16:22:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60670C15BBD; Fri, 26 Aug 2022 16:22:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CB69C15BBA
 for <dm-devel@redhat.com>; Fri, 26 Aug 2022 16:22:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC9538037AF
 for <dm-devel@redhat.com>; Fri, 26 Aug 2022 16:22:27 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-168-MGuphPG3MFWUpOI4vIHlhQ-1; Fri,
 26 Aug 2022 12:22:26 -0400
X-MC-Unique: MGuphPG3MFWUpOI4vIHlhQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 3B2291F91D;
 Fri, 26 Aug 2022 16:22:25 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0DE5E13A82;
 Fri, 26 Aug 2022 16:22:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id CL7iAUHzCGPocAAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 26 Aug 2022 16:22:25 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 26 Aug 2022 18:22:01 +0200
Message-Id: <20220826162203.20317-4-mwilck@suse.com>
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
Subject: [dm-devel] [PATCH v3 3/5] libmultipath: merge_mptable(): sort table
 by wwid
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

If the mptable is very large (for example, in a configuration with
lots of maps assigned individual aliases), merge_mptable may get
very slow because it needs to make O(n^2) string comparisons (with
n being the number of mptable entries). WWID strings often differ
only in the last few bytes, causing a lot of CPU time spent in
strcmp().

merge_mptable is executed whenever multipath or multipathd is started, that
is, also for "multipath -u" and "multipath -U" invocations from udev rules.
Optimize it by sorting the mptable before merging. This way we don't need
to iterate towards the end of the vector searching for duplicates.

Because of the way merge_mpe() works, we must make sure not to change
the order of entries with the same WWID. In other words, a stable sort
algorithm is required, which isn't the case for qsort(3) in general.
Therefore we explicitly use the msort() routine from glibc, which is a
stable merge sort algorithm, without fallback to quicksort.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 15 +++++++++++++--
 libmultipath/vector.c |  9 +++++++++
 libmultipath/vector.h |  1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index ab8b26e..a2c79a4 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -520,6 +520,14 @@ merge_mpe(struct mpentry *dst, struct mpentry *src)
 	merge_num(mode);
 }
 
+static int wwid_compar(const void *p1, const void *p2)
+{
+	const char *wwid1 = (*(struct mpentry * const *)p1)->wwid;
+	const char *wwid2 = (*(struct mpentry * const *)p2)->wwid;
+
+	return strcmp(wwid1, wwid2);
+}
+
 void merge_mptable(vector mptable)
 {
 	struct mpentry *mp1, *mp2;
@@ -533,10 +541,13 @@ void merge_mptable(vector mptable)
 			free_mpe(mp1);
 			continue;
 		}
+	}
+	vector_sort(mptable, wwid_compar);
+	vector_foreach_slot(mptable, mp1, i) {
 		j = i + 1;
 		vector_foreach_slot_after(mptable, mp2, j) {
-			if (!mp2->wwid || strcmp(mp1->wwid, mp2->wwid))
-				continue;
+			if (strcmp(mp1->wwid, mp2->wwid))
+				break;
 			condlog(1, "%s: duplicate multipath config section for %s",
 				__func__, mp1->wwid);
 			merge_mpe(mp2, mp1);
diff --git a/libmultipath/vector.c b/libmultipath/vector.c
index e2d1ec9..df59db5 100644
--- a/libmultipath/vector.c
+++ b/libmultipath/vector.c
@@ -21,6 +21,7 @@
 
 #include <stdlib.h>
 #include "vector.h"
+#include "msort.h"
 
 /*
  * Initialize vector struct.
@@ -208,3 +209,11 @@ int vector_find_or_add_slot(vector v, void *value)
 	vector_set_slot(v, value);
 	return VECTOR_SIZE(v) - 1;
 }
+
+void vector_sort(vector v, int (*compar)(const void *, const void *))
+{
+	if (!v || !v->slot || !v->allocated)
+		return;
+	return msort((void *)v->slot, v->allocated, sizeof(void *), compar);
+
+}
diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index 2862dc2..c0b09cb 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -89,4 +89,5 @@ extern void vector_repack(vector v);
 extern void vector_dump(vector v);
 extern void dump_strvec(vector strvec);
 extern int vector_move_up(vector v, int src, int dest);
+void vector_sort(vector v, int (*compar)(const void *, const void *));
 #endif
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

