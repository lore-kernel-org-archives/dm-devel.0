Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369721C2306
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177796; cv=none; b=RdObIbC0YL24qcP+Yh2wLYKtq/Met7WKJ/s0NyFlber/iPnjzP6yT2YGopw9SYrWj4FYCPEyamkj/sczEGwYnFJ1rNvnX+8XxLSnHTYP9JyMztY5vpszqdZp/wrRbi3VKZyQZpj93uyCoprd18F9AOX79EpqsBd7dAl/QroamPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177796; c=relaxed/simple;
	bh=lIHZa46l+fVmxWH1Q9g2bjtL3LGgJPU1EyzSPRCpukc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FMrRnDRSjvGHfRfO9rgYZdBs9Jd3XBKMhg212GBczWL6Iy0oRKQttDdIv0/eoK5uG56w5rYSkTgKQAoQyZrlGWcegGgMVYnyZ+KGucJIk3OjcTZR6LB96Jo+yBoGSSnMdAu25vrb/W9CqfHT6u70b+BPrydxvvjzjn+cGG2V7ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dgfmM8ji; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dgfmM8ji"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lNW+vKsnviMXzfCwBVqMLMtLSeJ6VBSHg6WHCreLcOg=;
	b=dgfmM8jisv5xjJjKQ63Ub12gaU20fPTbPNzZAbGHy7cbOcJ5mzlLJZ0PcrbzmyAYkn6Viz
	BvAqd4G47S5JsEFBMAtlozE1fp7bUCLwvIFX2FTs77ToVbGDCkFuugkVb/JqDasq08AtUc
	BOeoFCkQVGxQ9cki94KlEYBYSe0p/LA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-pbCR2WnaPKOqcr1XXOYJrg-1; Thu,
 12 Sep 2024 17:49:52 -0400
X-MC-Unique: pbCR2WnaPKOqcr1XXOYJrg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F37141955F2C;
	Thu, 12 Sep 2024 21:49:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6417E19560AA;
	Thu, 12 Sep 2024 21:49:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnohV783890
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:50 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnoYF783889;
	Thu, 12 Sep 2024 17:49:50 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 10/22] multipathd: split check_path into two functions
Date: Thu, 12 Sep 2024 17:49:35 -0400
Message-ID: <20240912214947.783819-11-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Split out the code that updates a path's state and sets up the next
check time into its own function, update_path().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 9319751e..8bfb166d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2390,6 +2390,7 @@ sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
 }
 
 enum check_path_return {
+	CHECK_PATH_STARTED,
 	CHECK_PATH_CHECKED,
 	CHECK_PATH_SKIPPED,
 	CHECK_PATH_REMOVED,
@@ -2629,13 +2630,10 @@ update_path_state (struct vectors * vecs, struct path * pp)
 }
 
 static int
-check_path (struct vectors * vecs, struct path * pp, unsigned int ticks,
-	    time_t start_secs)
+check_path (struct path * pp, unsigned int ticks)
 {
-	int r;
-	unsigned int adjust_int, checkint, max_checkint;
+	unsigned int checkint;
 	struct config *conf;
-	time_t next_idx, goal_idx;
 
 	if (pp->initialized == INIT_REMOVED)
 		return CHECK_PATH_SKIPPED;
@@ -2647,8 +2645,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks,
 
 	conf = get_multipath_config();
 	checkint = conf->checkint;
-	max_checkint = conf->max_checkint;
-	adjust_int = conf->adjust_int;
 	put_multipath_config(conf);
 
 	if (pp->checkint == CHECKINT_UNDEF) {
@@ -2657,6 +2653,17 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks,
 	}
 
 	start_path_check(pp);
+	return CHECK_PATH_STARTED;
+}
+
+static int
+update_path(struct vectors * vecs, struct path * pp, time_t start_secs)
+{
+	int r;
+	unsigned int adjust_int, max_checkint;
+	struct config *conf;
+	time_t next_idx, goal_idx;
+
 	r = update_path_state(vecs, pp);
 
 	/*
@@ -2685,6 +2692,10 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks,
 	if (pp->tick == 1)
 		return r;
 
+	conf = get_multipath_config();
+	max_checkint = conf->max_checkint;
+	adjust_int = conf->adjust_int;
+	put_multipath_config(conf);
 	/*
 	 * every mpp has a goal_idx in the range of
 	 * 0 <= goal_idx < conf->max_checkint
@@ -2818,8 +2829,10 @@ check_paths(struct vectors *vecs, unsigned int ticks, int *num_paths_p)
 				if (!pp->mpp || pp->is_checked)
 					continue;
 				pp->is_checked = true;
-				rc = check_path(vecs, pp, ticks,
-						start_time.tv_sec);
+				rc = check_path(pp, ticks);
+				if (rc == CHECK_PATH_STARTED)
+					rc = update_path(vecs, pp,
+							 start_time.tv_sec);
 				if (rc == CHECK_PATH_CHECKED)
 					(*num_paths_p)++;
 				if (++paths_checked % 128 == 0)
-- 
2.45.0

