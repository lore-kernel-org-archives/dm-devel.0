Return-Path: <SRS0=AZSO=II=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CAEC433E6
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 21:15:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 16C3964FCA
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 21:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16C3964FCA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615410937;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6CQhKN/NlCdfMw0J+8Rg6qFeVv9zRn4MULJGL3BlE7Y=;
	b=XzZKv/MOPVV/n5RNrtgnQYLx+BgMVsedEBPH4bNUAX4yfLe4liuTiXGmxE0l7OTeesYpXX
	ExuS7d8t6GWt2LKppUn7qqU3UC1hnhivzPxsFcXCNK4PqIz4/uCURU68Fep1iyMOw6BN6P
	YOxJ/NqmsQtVHR4N0RDFOc+rJS8oRMY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-xX1u8jvrPUqVFIP2vIEkLA-1; Wed, 10 Mar 2021 16:15:34 -0500
X-MC-Unique: xX1u8jvrPUqVFIP2vIEkLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41B8880433A;
	Wed, 10 Mar 2021 21:15:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D64165D9DB;
	Wed, 10 Mar 2021 21:15:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7AA811809C8B;
	Wed, 10 Mar 2021 21:15:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12ALFRPh016639 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Mar 2021 16:15:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3CA9210023AB; Wed, 10 Mar 2021 21:15:27 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 024D61002F12;
	Wed, 10 Mar 2021 21:15:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12ALFGCK012597; 
	Wed, 10 Mar 2021 15:15:16 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12ALFGop012596;
	Wed, 10 Mar 2021 15:15:16 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 10 Mar 2021 15:15:14 -0600
Message-Id: <1615410915-12555-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1615410915-12555-1-git-send-email-bmarzins@redhat.com>
References: <1615410915-12555-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 1/2] libmultipath: check if user_friendly_name is
	in use
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If there are multipath devices that have user_friendly_names but do not
have their bindings in the bindings_file, get_user_friendly_alias() can
currently give out those names again. This can result in an incorrect
entry in the bindings file, and a device that gets created with a WWID
alias instead of a user_friendly_name. This situation can happen after
the pivot root, if a multipath device is created in the initramfs.  If
this device doesn't have a binding in the regular filesystem
bindings_file and a new multipath device is created before it can add
its binding, the new device can steal that user_friendly_name during
multipathd's initial configure.

To solve this, get_user_friendly_alias() now calls lookup_binding() with
a new paramter, telling it to check if the id it found is already in use
by a diffent device. If so, lookup_binding() will continue to check open
ids, until it finds one that it not currently in use by a dm device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c | 48 +++++++++++++++++++++++++++++++++++++++++---
 tests/alias.c        | 22 ++++++++++----------
 2 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index a7ba485a..02bc9d65 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -21,6 +21,7 @@
 #include "config.h"
 #include "util.h"
 #include "errno.h"
+#include "devmapper.h"
 
 
 /*
@@ -119,6 +120,28 @@ scan_devname(const char *alias, const char *prefix)
 	return n;
 }
 
+static int
+id_already_taken(int id, const char *prefix, const char *map_wwid)
+{
+	char alias[LINE_MAX];
+
+	if (format_devname(alias, id, LINE_MAX, prefix) < 0)
+		return 0;
+
+	if (dm_map_present(alias)) {
+		char wwid[WWID_SIZE];
+
+		/* If both the name and the wwid match, then it's fine.*/
+		if (dm_get_uuid(alias, wwid, sizeof(wwid)) == 0 &&
+		    strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
+			return 0;
+		condlog(3, "%s: alias '%s' already taken, but not in bindings file. reselecting alias", map_wwid, alias);
+		return 1;
+	}
+	return 0;
+}
+
+
 /*
  * Returns: 0   if matching entry in WWIDs file found
  *         -1   if an error occurs
@@ -128,7 +151,7 @@ scan_devname(const char *alias, const char *prefix)
  */
 static int
 lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
-	       const char *prefix)
+	       const char *prefix, int check_if_taken)
 {
 	char buf[LINE_MAX];
 	unsigned int line_nr = 0;
@@ -183,12 +206,31 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
 			return 0;
 		}
 	}
+	if (!prefix && check_if_taken)
+		id = -1;
 	if (id >= smallest_bigger_id) {
 		if (biggest_id < INT_MAX)
 			id = biggest_id + 1;
 		else
 			id = -1;
 	}
+	if (id > 0 && check_if_taken) {
+		while(id_already_taken(id, prefix, map_wwid)) {
+			if (id == INT_MAX) {
+				id = -1;
+				break;
+			}
+			id++;
+			if (id == smallest_bigger_id) {
+				if (biggest_id == INT_MAX) {
+					id = -1;
+					break;
+				}
+				if (biggest_id >= smallest_bigger_id)
+					id = biggest_id + 1;
+			}
+		}
+	}
 	if (id < 0) {
 		condlog(0, "no more available user_friendly_names");
 		return -1;
@@ -331,7 +373,7 @@ use_existing_alias (const char *wwid, const char *file, const char *alias_old,
 		goto out;
 	}
 
-	id = lookup_binding(f, wwid, &alias, NULL);
+	id = lookup_binding(f, wwid, &alias, NULL, 0);
 	if (alias) {
 		condlog(3, "Use existing binding [%s] for WWID [%s]",
 			alias, wwid);
@@ -388,7 +430,7 @@ get_user_friendly_alias(const char *wwid, const char *file, const char *prefix,
 		return NULL;
 	}
 
-	id = lookup_binding(f, wwid, &alias, prefix);
+	id = lookup_binding(f, wwid, &alias, prefix, 1);
 	if (id < 0) {
 		fclose(f);
 		return NULL;
diff --git a/tests/alias.c b/tests/alias.c
index 5e0bfea3..344aba73 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -357,7 +357,7 @@ static void lb_empty(void **state)
 
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(3, "No matching wwid [WWID0] in bindings file.\n");
-	rc = lookup_binding(NULL, "WWID0", &alias, NULL);
+	rc = lookup_binding(NULL, "WWID0", &alias, NULL, 0);
 	assert_int_equal(rc, 1);
 	assert_ptr_equal(alias, NULL);
 }
@@ -370,7 +370,7 @@ static void lb_match_a(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	expect_condlog(3, "Found matching wwid [WWID0] in bindings file."
 		       " Setting alias to MPATHa\n");
-	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH");
+	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 0);
 	assert_int_equal(rc, 0);
 	assert_ptr_not_equal(alias, NULL);
 	assert_string_equal(alias, "MPATHa");
@@ -385,7 +385,7 @@ static void lb_nomatch_a(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(3, "No matching wwid [WWID1] in bindings file.\n");
-	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH");
+	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 0);
 	assert_int_equal(rc, 2);
 	assert_ptr_equal(alias, NULL);
 }
@@ -399,7 +399,7 @@ static void lb_match_c(void **state)
 	will_return(__wrap_fgets, "MPATHc WWID1\n");
 	expect_condlog(3, "Found matching wwid [WWID1] in bindings file."
 		       " Setting alias to MPATHc\n");
-	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH");
+	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 0);
 	assert_int_equal(rc, 0);
 	assert_ptr_not_equal(alias, NULL);
 	assert_string_equal(alias, "MPATHc");
@@ -415,7 +415,7 @@ static void lb_nomatch_a_c(void **state)
 	will_return(__wrap_fgets, "MPATHc WWID1\n");
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
-	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, 2);
 	assert_ptr_equal(alias, NULL);
 }
@@ -429,7 +429,7 @@ static void lb_nomatch_c_a(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
-	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, 2);
 	assert_ptr_equal(alias, NULL);
 }
@@ -444,7 +444,7 @@ static void lb_nomatch_a_b(void **state)
 	will_return(__wrap_fgets, "MPATHb WWID1\n");
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
-	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, 3);
 	assert_ptr_equal(alias, NULL);
 }
@@ -460,7 +460,7 @@ static void lb_nomatch_a_b_bad(void **state)
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(3, "Ignoring malformed line 3 in bindings file\n");
 	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
-	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, 3);
 	assert_ptr_equal(alias, NULL);
 }
@@ -475,7 +475,7 @@ static void lb_nomatch_b_a(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
-	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, 27);
 	assert_ptr_equal(alias, NULL);
 }
@@ -491,7 +491,7 @@ static void lb_nomatch_int_max(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(0, "no more available user_friendly_names\n");
-	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, -1);
 	assert_ptr_equal(alias, NULL);
 }
@@ -506,7 +506,7 @@ static void lb_nomatch_int_max_m1(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, NULL);
 	expect_condlog(3, "No matching wwid [WWID2] in bindings file.\n");
-	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH");
+	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
 	assert_int_equal(rc, INT_MAX);
 	assert_ptr_equal(alias, NULL);
 }
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

