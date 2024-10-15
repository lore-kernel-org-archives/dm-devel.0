Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F6F1714BD
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962925; cv=none; b=re2HFmOH2BfoMZ29eSeXAgJMuRf9prCBrl0z1HVgjV5qg2N/T1vpiIplsYbUfXHGG+wdRN80AGa3mscJ23bl0VKninGp+/v+DLUf3VNQ3DyeTKgXVFRe0RnUDbPTvWqzTXhnowVbTL+miVw400i94XBx5jX6c8pGpRKzhEm0Wmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962925; c=relaxed/simple;
	bh=9T8Hn2v/DAA05EWxuLl/0vPGncBmmOjV0Qau/nh5324=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pJViEDa1+SVLmx8AYlYVSays+usR/TQ7TBXdl28vZ2aFbal5Cg81+sP/RoMkSHmbhwpeKR3FEjbpD6+cP4xZLzeaxH9czASrgSei+F9H8sym7F9sDjIV/u+yTJHJvvolfvyTl/e4RuNAry5/jbiv9rqT73etT8/HIX9RSiu8Uvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Iv688+PW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Iv688+PW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aSJMRVFe0C+Fen574tMyVMu/sjlFYHEciXXA4GnGkuw=;
	b=Iv688+PWrEXxYpdSwB04dm0NLut5rktsAUNy89NtLzsJ4FiXyV7C8ra3kAu+G6sWxp72lx
	dtz85gBZX6XCU7iJpkpFsuYUqdfyHyNcszhPGRlpk4bW0shXOCexY5ybISFtnwdKINmZUC
	Y+q7pBjF9cNaGfySKCRIs2UsmKxPqh4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-qGi7ZMJ8PuSjJERQYuPsBg-1; Mon,
 14 Oct 2024 23:28:39 -0400
X-MC-Unique: qGi7ZMJ8PuSjJERQYuPsBg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7EFC219560B1;
	Tue, 15 Oct 2024 03:28:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F56F1956089;
	Tue, 15 Oct 2024 03:28:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3SbfG2693315
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3Sbbg2693314;
	Mon, 14 Oct 2024 23:28:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v5 09/23] multipathd: rename do_check_path to update_path_state
Date: Mon, 14 Oct 2024 23:28:21 -0400
Message-ID: <20241015032835.2693247-10-bmarzins@redhat.com>
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Move the code that starts the path checker from do_check_path() into
check_path(), rename the remainder of do_check_path() to
update_path_state() and call that from check_path().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 16c0531e..488aa225 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2396,7 +2396,7 @@ enum check_path_return {
 };
 
 static int
-do_check_path (struct vectors * vecs, struct path * pp)
+update_path_state (struct vectors * vecs, struct path * pp)
 {
 	int newstate;
 	int new_path_up = 0;
@@ -2414,12 +2414,6 @@ do_check_path (struct vectors * vecs, struct path * pp)
 	marginal_pathgroups = conf->marginal_pathgroups;
 	put_multipath_config(conf);
 
-	if (pp->checkint == CHECKINT_UNDEF) {
-		condlog(0, "%s: BUG: checkint is not set", pp->dev);
-		pp->checkint = checkint;
-	};
-
-	start_path_check(pp);
 	newstate = get_new_state(pp);
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED)
 		return CHECK_PATH_SKIPPED;
@@ -2639,7 +2633,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks,
 	    time_t start_secs)
 {
 	int r;
-	unsigned int adjust_int, max_checkint;
+	unsigned int adjust_int, checkint, max_checkint;
 	struct config *conf;
 	time_t next_idx, goal_idx;
 
@@ -2652,14 +2646,21 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks,
 		return CHECK_PATH_SKIPPED;
 
 	conf = get_multipath_config();
+	checkint = conf->checkint;
 	max_checkint = conf->max_checkint;
 	adjust_int = conf->adjust_int;
 	put_multipath_config(conf);
 
-	r = do_check_path(vecs, pp);
+	if (pp->checkint == CHECKINT_UNDEF) {
+		condlog(0, "%s: BUG: checkint is not set", pp->dev);
+		pp->checkint = checkint;
+	}
+
+	start_path_check(pp);
+	r = update_path_state(vecs, pp);
 
 	/*
-	 * do_check_path() removed or orphaned the path.
+	 * update_path_state() removed or orphaned the path.
 	 */
 	if (r == CHECK_PATH_REMOVED || !pp->mpp)
 		return r;
-- 
2.45.0

