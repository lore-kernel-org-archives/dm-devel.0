Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489F71AC8A9
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 22:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724883485; cv=none; b=gn4IlE1WzT7j9Bt3eFPLqLN2fqc0hCHSsUFOwVu/8Jy5GGsOGaI+Iamcz0+ariR0TDalP9MSl9G0UV7GtB1LjzHrw0tm+8Jg82Pwiy73A7WLYx/FsPqV9RCQlnf2KZj3xk12aaBkqvR/Qprspzef/9M0smX7w0Ge3a8fyBy7VFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724883485; c=relaxed/simple;
	bh=8/bJRJO6Q+K9yH1J5O5oVhb4Ac7DnvhT6HGSl/UX4O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lY54ZYKu14BtGyyIn2f+D50I8gTr9OOlMS/u/E2Sjpe2OROhNRJWc80TtwGbwts8ouccul4IAnz1adaIyO2wxeMb5p1ItzShREh5r3ja24O+nLr1J3tsOqCvUTtLCf+Pibs1ZgXkA4eVGq8EglJqEykBGX6UengJd/jIpWYuYq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gCx/Yvho; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gCx/Yvho"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724883483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+cxy8uW8VSb8OPhmWx3DTf8zHBuLrmqZjBspuMXCw20=;
	b=gCx/YvhoSlh+9IgqZYKFypdgxv+e9bF+zQYsHAEARkYk/AfgtR5BrcHcPJETz37EXriPT2
	qSnRcIudwoBODyk3YSfld+7giurmlsYzvzYiw2MjM9nEoOY/a9lN1+g8lUX90g/xoDWj+9
	aEQZFlgr6ysVagzHTal9u3jdt7+AoBs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-329-Wt8UrsHIOMK0Ol7cqIUGtQ-1; Wed,
 28 Aug 2024 18:18:01 -0400
X-MC-Unique: Wt8UrsHIOMK0Ol7cqIUGtQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E31E91955F43;
	Wed, 28 Aug 2024 22:18:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A61819560AA;
	Wed, 28 Aug 2024 22:18:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47SMHxPP4060608
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:17:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47SMHxF34060607;
	Wed, 28 Aug 2024 18:17:59 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 09/15] multipathd: split do_checker_path
Date: Wed, 28 Aug 2024 18:17:51 -0400
Message-ID: <20240828221757.4060548-10-bmarzins@redhat.com>
In-Reply-To: <20240828221757.4060548-1-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
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

Move the code that starts the path checker from do_check_path() into
check_path(), rename the remainder of do_check_path() to
update_path_state() and call that from check_path().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d157e3c2..94d4e421 100644
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
 	newstate = check_path_state(pp);
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
+	 * update_path() removed or orphaned the path.
 	 */
 	if (r == CHECK_PATH_REMOVED || !pp->mpp)
 		return r;
-- 
2.45.0

