Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1CE14A4D4
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 22:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724883486; cv=none; b=RNkMFogBgJ5Y4RTj2VRbLK/6Ck6zwA700pNvDuKDqwUofW5m2tyz8uOEt1wEaFRtjCyZxPOMVgFzR1L73FlMSqTOzVG1l1+eKkUykm3YKEz2N6/zfPviP9jbamwHBwN58flIIpZ1t4nJ4bWIfxWdiweBWKzCd3SNDa73+8dRoJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724883486; c=relaxed/simple;
	bh=uNLyUy2Udlgq4WKcO7L3ZFPEp33Ck2Mnm6eHy6qdM+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dOktSo2M1S2EQqIT0KyhhM72QZQcK3PPR+X1BcLGlhVk8tYhW9ajnK59M0qNUWM4I0ok+qHLVt2ngqfPCQY3EcoyQD4SAWDQnoVTYIlU53gburlP4n8pOZYhAaeGR4FzG0GDps8eV0WzyaHRXdCEyT/Et/uHVLN1cXUit3Ya9nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VkhgEFDt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VkhgEFDt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724883484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r2pdM0M9LQEXhYJK7gHrdXHPXL3SchsGwfNTuJ6RmS4=;
	b=VkhgEFDtG8qNgxp+AD6+LA8+Nn3OMyDKYBonUnPb2pts0vktFheivvefWXxAFSYpl6ElaX
	ZCITg1AfKngjBOMaZLZ9M7PCWU+vyRdx92sYt+8bsubca2aHDWwscd9JViyiq9APSqzyXh
	no5WLKl+qYXC1g8Xr0vyS+Wu3gi2v/s=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-b_p_a9FUOQyQMHWupSgyRQ-1; Wed,
 28 Aug 2024 18:18:00 -0400
X-MC-Unique: b_p_a9FUOQyQMHWupSgyRQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE8D519560BF;
	Wed, 28 Aug 2024 22:17:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07A9D30001A1;
	Wed, 28 Aug 2024 22:17:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47SMHvWw4060576
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:17:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47SMHv0L4060575;
	Wed, 28 Aug 2024 18:17:57 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 01/15] libmultipath: store checker_check() result in checker struct
Date: Wed, 28 Aug 2024 18:17:43 -0400
Message-ID: <20240828221757.4060548-2-bmarzins@redhat.com>
In-Reply-To: <20240828221757.4060548-1-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

checker_check() is now a void function that stores the path state in
the checker struct. It can be retrieved later using checker_get_state().
Right now, this is called immediately after checker_check(), but in
the future, it can be deferred to another time.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c  | 26 +++++++++++++-------------
 libmultipath/checkers.h  |  4 +++-
 libmultipath/discovery.c |  3 ++-
 3 files changed, 18 insertions(+), 15 deletions(-)

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
-- 
2.45.0

