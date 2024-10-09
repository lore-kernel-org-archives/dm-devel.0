Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6BB1CD2B
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 01:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728436534; cv=none; b=NIGKD9lkvsCbD7Fyl0N8jGAPjirFYglXZBhRM2DGQWwOGS5AK25TMG88KbkolqRCeSUfEyS12BvI1DWl3P/yEhGCz5tMWOGSLmRehk2eFxVkiZNN32az2lffWVRxGj50J2nXCF4AdLC1/BZIL9lkxM3P6nSZBYBcr2eKA0x9zps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728436534; c=relaxed/simple;
	bh=K1uD84RpdQMm62QBvQQrkNvq4iYFIL7AhA9ICg0G2PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E45HoULXTCOOWUfqNTGG4iua9JVZCw7H1eqJVMaalT36k/cn/QLf/LnYn9qgwivzKMq4Lnp8as7bllGkbG+FG9Q0OOL12dNh+sC8in9XEl4FW4a4iXiIwfj0RI82hMHJhbHKcy9ZSOpUVxqvEa6hF5kVUdZJDYAChmmwRu8Ma+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JhCivla+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JhCivla+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728436530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fDbPEXd1L46Bz924xjYAv09ESeJm5szPAAZ96dLVYtA=;
	b=JhCivla+6vWhX9TIPXCM+c/TJxdw1whgO8+DCBsl81ZAeNqez4sRq4flLsvoTT3eyMsJSP
	KTKpGPVVSaicKgmm1o1a5mbodLYVn84t1pUmpHlES8L7RBlxT0noRwyhfZ0/3JQB67vHk8
	nRnn4xStPvjwJxtR9j6FHnQV4ruhtzE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-Wozb2FTnNt6O6yWqegYdLw-1; Tue,
 08 Oct 2024 21:15:27 -0400
X-MC-Unique: Wozb2FTnNt6O6yWqegYdLw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DEA41955D4D;
	Wed,  9 Oct 2024 01:15:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B205419560A3;
	Wed,  9 Oct 2024 01:15:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4991FOL92381610
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 21:15:24 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4991FOCF2381609;
	Tue, 8 Oct 2024 21:15:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 01/22] libmultipath: store checker_check() result in checker struct
Date: Tue,  8 Oct 2024 21:15:02 -0400
Message-ID: <20241009011523.2381575-2-bmarzins@redhat.com>
In-Reply-To: <20241009011523.2381575-1-bmarzins@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
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

checker_check() is now a void function that stores the path state in
the checker struct. It can be retrieved later using checker_get_state().
Right now, this is called immediately after checker_check(), but in
the future, it can be deferred to another time.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c  | 26 +++++++++++++-------------
 libmultipath/checkers.h  |  4 +++-
 libmultipath/discovery.c |  3 ++-
 libmultipath/propsel.c   |  1 +
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index fdb91e17..c4918d28 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -299,28 +299,28 @@ void checker_put (struct checker * dst)
 	free_checker_class(src);
 }
 
-int checker_check (struct checker * c, int path_state)
+int checker_get_state(struct checker *c)
 {
-	int r;
+	return c ? c->path_state : PATH_UNCHECKED;
+}
 
+void checker_check (struct checker * c, int path_state)
+{
 	if (!c)
-		return PATH_WILD;
+		return;
 
 	c->msgid = CHECKER_MSGID_NONE;
 	if (c->disable) {
 		c->msgid = CHECKER_MSGID_DISABLED;
-		return PATH_UNCHECKED;
-	}
-	if (!strncmp(c->cls->name, NONE, 4))
-		return path_state;
-
-	if (c->fd < 0) {
+		c->path_state = PATH_UNCHECKED;
+	} else if (!strncmp(c->cls->name, NONE, 4)) {
+		c->path_state = path_state;
+	} else if (c->fd < 0) {
 		c->msgid = CHECKER_MSGID_NO_FD;
-		return PATH_WILD;
+		c->path_state = PATH_WILD;
+	} else {
+		c->path_state = c->cls->check(c);
 	}
-	r = c->cls->check(c);
-
-	return r;
 }
 
 const char *checker_name(const struct checker *c)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 102351f6..6e54d8f0 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -123,6 +123,7 @@ struct checker {
 	int fd;
 	unsigned int timeout;
 	int disable;
+	int path_state;
 	short msgid;		             /* checker-internal extra status */
 	void * context;                      /* store for persistent data */
 	void ** mpcontext;                   /* store for persistent data shared
@@ -169,7 +170,8 @@ struct checker_context {
 };
 int start_checker_thread (pthread_t *thread, const pthread_attr_t *attr,
 			  struct checker_context *ctx);
-int checker_check (struct checker *, int);
+int checker_get_state(struct checker *c);
+void checker_check (struct checker *, int);
 int checker_is_sync(const struct checker *);
 const char *checker_name (const struct checker *);
 void reset_checker_classes(void);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e94705bf..5648be60 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2007,7 +2007,8 @@ get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
 		checker_set_async(c);
 	else
 		checker_set_sync(c);
-	state = checker_check(c, oldstate);
+	checker_check(c, oldstate);
+	state = checker_get_state(c);
 	condlog(3, "%s: %s state = %s", pp->dev,
 		checker_name(c), checker_state_name(state));
 	if (state != PATH_UP && state != PATH_GHOST &&
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index a3fce203..ad771d35 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -700,6 +700,7 @@ out:
 	condlog(3, "%s: path_checker = %s %s", pp->dev,
 		checker_name(c), origin);
 	c->timeout = pp->checker_timeout;
+	c->path_state = PATH_UNCHECKED;
 	return 0;
 }
 
-- 
2.45.0

