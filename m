Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678B21AD9D2
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 22:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724883488; cv=none; b=XX82bPH+scGkZJFtP1VBHmjGi4cg3IT40Aa8CrR1G2Pq2OzqD5bZXt8nqYegXzzqfxIlXuF9Sj0Mmni7dLSuPfhRuoaxhHt1syxVIGhEf3tg3e2jUB7xjk89gkTdXjDrKVpGA+c2730nsPpChgkknAKqZKHYtjCT+bqsH5E6+kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724883488; c=relaxed/simple;
	bh=Ys8tUCld72QqlkriXl2PG0zcBkiTZD/3PpCYhc1CMnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K6XQn9GKDIwrLfct8OpeQBb3Bg81+CeaZ7N+su1fiUZZeAmUb+haBOH6yfMu2/5ILxC04bc15lYqFA4GnfCco6vcpMogAGNjW9/bWLPh7/zNabDdGOQ+WXw3U6O7OAXxRcvEOKTiq+745XcE6XC2LaJ/s5rdp13saakcEvCzj1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EeHBx8Q+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EeHBx8Q+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724883485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8OzOd1582aKOLdmrP0PfjJ49Pp5omI4837d7W2fQf8M=;
	b=EeHBx8Q+gJq/Da4JfQUC3ankfMmkr1GQXCKyyKmW0y9cYDDjVZqESZ3FR/zH0f2qcK/qXv
	zG+7BtXbN3+prCrSvBRnj4UnVdbaFgqlbihKq3CZn0eC8Hmn8BMHYF0n0+Wfc6qJrk06j/
	uMZ8SRE5KSm8k4E6BSfqlx+5HcAfK5g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-AxdIKiaVOraaM2n_XzJyYw-1; Wed,
 28 Aug 2024 18:18:01 -0400
X-MC-Unique: AxdIKiaVOraaM2n_XzJyYw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D47FB1955BF8;
	Wed, 28 Aug 2024 22:18:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C32419560A3;
	Wed, 28 Aug 2024 22:18:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47SMHxnj4060612
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:17:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47SMHxvF4060611;
	Wed, 28 Aug 2024 18:17:59 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 10/15] multipathd: split check_path into two functions
Date: Wed, 28 Aug 2024 18:17:52 -0400
Message-ID: <20240828221757.4060548-11-bmarzins@redhat.com>
In-Reply-To: <20240828221757.4060548-1-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
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
index 94d4e421..300f8247 100644
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

