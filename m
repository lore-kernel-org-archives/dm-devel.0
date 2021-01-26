Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B36C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 05:31:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7C3CD206F7
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 05:31:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C3CD206F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1611639085;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K1BskJXRIgflEsmJB3kg+9etmQuCaazj1Zpfk75nyfs=;
	b=AWIdlqVLMxsKmMRzVm3/Ln+3r5i8edHjKk+t4fG9cB5w3K4RG+XjnPwOUzRH0Oo2NY72q7
	uuz0ST6sswJ5x2e7/lKOypvGwZBHF/SYMF5tcKaCFfgf2MGJH0YdErsjAOeHC02+6+eb6N
	etOrhkecmP5CN9EtNFdkG4SGAlhlg7Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-060L7qk4P7iD3d8CmsDr6A-1; Tue, 26 Jan 2021 00:31:22 -0500
X-MC-Unique: 060L7qk4P7iD3d8CmsDr6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77DFB801817;
	Tue, 26 Jan 2021 05:31:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 799CB7047C;
	Tue, 26 Jan 2021 05:31:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 478B2180954D;
	Tue, 26 Jan 2021 05:31:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10Q5VAx1013331 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 00:31:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 07A5060C5F; Tue, 26 Jan 2021 05:31:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B03660C47;
	Tue, 26 Jan 2021 05:31:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 10Q5V5Mf008225; 
	Mon, 25 Jan 2021 23:31:05 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 10Q5V4FC008224;
	Mon, 25 Jan 2021 23:31:04 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 25 Jan 2021 23:31:04 -0600
Message-Id: <1611639064-8187-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH] libmpathpersist: fix thread safety of default
	functions
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

commit a839e39e ("libmpathpersist: factor out initialization and
teardown") made mpath_presistent_reserve_{in,out} use share variables
for curmp and pathvec.  There are users of this library that call these
functions in a multi-threaded process, and this change causes their
application to crash. config and udev are also shared variables, but
libmpathpersist doesn't write to the config in
mpath_presistent_reserve_{in,out}, and looking into the libudev code, I
don't see any place where libmpathpersist uses the udev object in a way
that isn't thread-safe.

This patch makes mpath_presistent_reserve_{in,out} go back to using
local variables for curmp and pathvec, so that multiple threads won't
be operating on these variables at the same time.

Fixes: a839e39e ("libmpathpersist: factor out initialization and teardown")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 116 +++++++++++++++++++++-----------
 libmpathpersist/mpath_persist.h |  24 +++++--
 2 files changed, 94 insertions(+), 46 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 08077936..e4c24b93 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -133,69 +133,57 @@ mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 	return ret;
 }
 
-int mpath_persistent_reserve_in (int fd, int rq_servact,
-	struct prin_resp *resp, int noisy, int verbose)
-{
-	int ret = mpath_persistent_reserve_init_vecs(verbose);
-
-	if (ret != MPATH_PR_SUCCESS)
-		return ret;
-	ret = __mpath_persistent_reserve_in(fd, rq_servact, resp, noisy);
-	mpath_persistent_reserve_free_vecs();
-	return ret;
-}
-
-int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
-	unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy, int verbose)
-{
-	int ret = mpath_persistent_reserve_init_vecs(verbose);
-
-	if (ret != MPATH_PR_SUCCESS)
-		return ret;
-	ret = __mpath_persistent_reserve_out(fd, rq_servact, rq_scope, rq_type,
-					     paramp, noisy);
-	mpath_persistent_reserve_free_vecs();
-	return ret;
-}
-
 static vector curmp;
 static vector pathvec;
 
-void mpath_persistent_reserve_free_vecs(void)
+static void __mpath_persistent_reserve_free_vecs(vector curmp, vector pathvec)
 {
 	free_multipathvec(curmp, KEEP_PATHS);
 	free_pathvec(pathvec, FREE_PATHS);
+}
+
+void mpath_persistent_reserve_free_vecs(void)
+{
+	__mpath_persistent_reserve_free_vecs(curmp, pathvec);
 	curmp = pathvec = NULL;
 }
 
-int mpath_persistent_reserve_init_vecs(int verbose)
+static int __mpath_persistent_reserve_init_vecs(vector *curmp_p,
+						vector *pathvec_p, int verbose)
 {
 	libmp_verbosity = verbose;
 
-	if (curmp)
+	if (*curmp_p)
 		return MPATH_PR_SUCCESS;
 	/*
 	 * allocate core vectors to store paths and multipaths
 	 */
-	curmp = vector_alloc ();
-	pathvec = vector_alloc ();
+	*curmp_p = vector_alloc ();
+	*pathvec_p = vector_alloc ();
 
-	if (!curmp || !pathvec){
+	if (!*curmp_p || !*pathvec_p){
 		condlog (0, "vector allocation failed.");
 		goto err;
 	}
 
-	if (dm_get_maps(curmp))
+	if (dm_get_maps(*curmp_p))
 		goto err;
 
 	return MPATH_PR_SUCCESS;
 
 err:
-	mpath_persistent_reserve_free_vecs();
+	__mpath_persistent_reserve_free_vecs(*curmp_p, *pathvec_p);
+	*curmp_p = *pathvec_p = NULL;
 	return MPATH_PR_DMMP_ERROR;
 }
 
-static int mpath_get_map(int fd, char **palias, struct multipath **pmpp)
+int mpath_persistent_reserve_init_vecs(int verbose)
+{
+	return __mpath_persistent_reserve_init_vecs(&curmp, &pathvec, verbose);
+}
+
+static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
+			 struct multipath **pmpp)
 {
 	int ret = MPATH_PR_DMMP_ERROR;
 	struct stat info;
@@ -255,13 +243,13 @@ out:
 	return ret;
 }
 
-int __mpath_persistent_reserve_in (int fd, int rq_servact,
-	struct prin_resp *resp, int noisy)
+static int do_mpath_persistent_reserve_in (vector curmp, vector pathvec,
+	int fd, int rq_servact, struct prin_resp *resp, int noisy)
 {
 	struct multipath *mpp;
 	int ret;
 
-	ret = mpath_get_map(fd, NULL, &mpp);
+	ret = mpath_get_map(curmp, pathvec, fd, NULL, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
 		return ret;
 
@@ -270,8 +258,17 @@ int __mpath_persistent_reserve_in (int fd, int rq_servact,
 	return ret;
 }
 
-int __mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
-	unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy)
+
+int __mpath_persistent_reserve_in (int fd, int rq_servact,
+	struct prin_resp *resp, int noisy)
+{
+	return do_mpath_persistent_reserve_in(curmp, pathvec, fd, rq_servact,
+					      resp, noisy);
+}
+
+static int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
+	int rq_servact, int rq_scope, unsigned int rq_type,
+	struct prout_param_descriptor *paramp, int noisy)
 {
 	struct multipath *mpp;
 	char *alias;
@@ -279,7 +276,7 @@ int __mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	uint64_t prkey;
 	struct config *conf;
 
-	ret = mpath_get_map(fd, &alias, &mpp);
+	ret = mpath_get_map(curmp, pathvec, fd, &alias, &mpp);
 	if (ret != MPATH_PR_SUCCESS)
 		return ret;
 
@@ -349,6 +346,45 @@ out1:
 	return ret;
 }
 
+
+int __mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
+	unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy)
+{
+	return do_mpath_persistent_reserve_out(curmp, pathvec, fd, rq_servact,
+					       rq_scope, rq_type, paramp,
+					       noisy);
+}
+
+int mpath_persistent_reserve_in (int fd, int rq_servact,
+	struct prin_resp *resp, int noisy, int verbose)
+{
+	vector curmp, pathvec;
+	int ret = __mpath_persistent_reserve_init_vecs(&curmp, &pathvec,
+						       verbose);
+
+	if (ret != MPATH_PR_SUCCESS)
+		return ret;
+	ret = do_mpath_persistent_reserve_in(curmp, pathvec, fd, rq_servact,
+					     resp, noisy);
+	__mpath_persistent_reserve_free_vecs(curmp, pathvec);
+	return ret;
+}
+
+int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
+	unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy, int verbose)
+{
+	vector curmp, pathvec;
+	int ret = __mpath_persistent_reserve_init_vecs(&curmp, &pathvec,
+						       verbose);
+
+	if (ret != MPATH_PR_SUCCESS)
+		return ret;
+	ret = do_mpath_persistent_reserve_out(curmp, pathvec, fd, rq_servact,
+					      rq_scope, rq_type, paramp, noisy);
+	__mpath_persistent_reserve_free_vecs(curmp, pathvec);
+	return ret;
+}
+
 int
 get_mpvec (vector curmp, vector pathvec, char * refwwid)
 {
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 5435eae4..9e9c0a82 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -246,9 +246,13 @@ extern int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp
 
 /*
  * DESCRIPTION :
- * This function is like mpath_persistent_reserve_in(), except that it doesn't call
- * mpath_persistent_reserve_init_vecs() and mpath_persistent_reserve_free_vecs()
- * before and after the actual PR call.
+ * This function is like mpath_persistent_reserve_in(), except that it
+ * requires mpath_persistent_reserve_init_vecs() to be called before the
+ * PR call to set up internal variables. These must later be cleanup up
+ * by calling mpath_persistent_reserve_free_vecs().
+ *
+ * RESTRICTIONS:
+ * This function uses static internal variables, and is not thread-safe.
  */
 extern int __mpath_persistent_reserve_in(int fd, int rq_servact,
 		struct prin_resp *resp, int noisy);
@@ -280,9 +284,13 @@ extern int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 		int verbose);
 /*
  * DESCRIPTION :
- * This function is like mpath_persistent_reserve_out(), except that it doesn't call
- * mpath_persistent_reserve_init_vecs() and mpath_persistent_reserve_free_vecs()
- * before and after the actual PR call.
+ * This function is like mpath_persistent_reserve_out(), except that it
+ * requires mpath_persistent_reserve_init_vecs() to be called before the
+ * PR call to set up internal variables. These must later be cleanup up
+ * by calling mpath_persistent_reserve_free_vecs().
+ *
+ * RESTRICTIONS:
+ * This function uses static internal variables, and is not thread-safe.
  */
 extern int __mpath_persistent_reserve_out( int fd, int rq_servact, int rq_scope,
 		unsigned int rq_type, struct prout_param_descriptor *paramp,
@@ -296,6 +304,7 @@ extern int __mpath_persistent_reserve_out( int fd, int rq_servact, int rq_scope,
  * @verbose: Set verbosity level. Input argument. value:0 to 3. 0->disabled, 3->Max verbose
  *
  * RESTRICTIONS:
+ * This function uses static internal variables, and is not thread-safe.
  *
  * RETURNS: MPATH_PR_SUCCESS if successful else returns any of the status specified
  *       above in RETURN_STATUS.
@@ -306,6 +315,9 @@ int mpath_persistent_reserve_init_vecs(int verbose);
  * DESCRIPTION :
  * This function frees data structures allocated by
  * mpath_persistent_reserve_init_vecs().
+ *
+ * RESTRICTIONS:
+ * This function uses static internal variables, and is not thread-safe.
  */
 void mpath_persistent_reserve_free_vecs(void);
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

