Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85078283C93
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 04:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768969411; cv=none; b=Q20lpkLJWj3H1y/yuSvXmxYBLdtO4wnfcYfS5mBzz8RN0Bfleoq0Sg7/UAVQiaTk/DoFITKqsPIQsgxALjw0XlRlE2rWvzvdMYygCFAfNG4ORE6uJApy5UFda5mukXvt1qmylTvM3hbbT/K2crCmlmqyS8fmoiujkhoYM0/UrIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768969411; c=relaxed/simple;
	bh=f20tX1/laHkvWq5EsPdh+Wcz4kTIhlcRKYD4qBPb0yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=O5FMWP9riEgpyauU0AvoWEqbHidJB8kTCsYAVnSaR7W3b3WQJQMuf352k8FRDUID7vUu2v0WXFl0OuvnAZdByX34c53ODwC0USkV1qwDjZFhn8HoSGM/HSEssytTHtFAeB8BWbrL2u/DMCwFMHZbYOg0zL4J6MW49y4RjzXXBoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b6zX+ktQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b6zX+ktQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768969401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MruHGhgG4gn8YweNrrHAUQU2RyRDbxPEbtt8AAcTUrE=;
	b=b6zX+ktQr32a5X8ysYtcHi8mZ8zrUzGio1HDIVd3A5SaLh3C6fkyq3Ar8XMxQWFkgf3b1H
	XNlMZfBwjWEDsOZWk56x6MowPgAIr8VkOGw1Z8sZkD62ukSBl+tUsA8eMc7yuU/VmiXTZZ
	tLaBtTZJA6sX9+fv0lfgWhR3T+NvbEg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-N0xwaA3VOkGzfh8vzwoGnA-1; Tue,
 20 Jan 2026 23:23:18 -0500
X-MC-Unique: N0xwaA3VOkGzfh8vzwoGnA-1
X-Mimecast-MFC-AGG-ID: N0xwaA3VOkGzfh8vzwoGnA_1768969397
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E52F1956052;
	Wed, 21 Jan 2026 04:23:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A7EA18001D5;
	Wed, 21 Jan 2026 04:23:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60L4NGpd3914736
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 20 Jan 2026 23:23:16 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60L4NGAm3914735;
	Tue, 20 Jan 2026 23:23:16 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 4/4] multipathd: print path offline message even without a checker
Date: Tue, 20 Jan 2026 23:23:15 -0500
Message-ID: <20260121042315.3914707-5-bmarzins@redhat.com>
In-Reply-To: <20260121042315.3914707-1-bmarzins@redhat.com>
References: <20260121042315.3914707-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eGHMH2v8TbMSQURB3udt4XUvgwfJ1RegWYNQGTf4JZE_1768969397
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If a path has a checker selected and is offline, multipathd will print a
"path offline" message. However if the checker isn't selected, for
instance because multipathd was started or reconfigured while the path
was offline, multipathd was not printing the "path offline" message.
Fix that.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2140e432..69e4808f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -96,12 +96,11 @@ mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed,
 
 #define LOG_MSG(lvl, pp)					\
 do {								\
-	if (pp->mpp && checker_selected(&pp->checker) &&	\
-	    lvl <= libmp_verbosity) {					\
+	if (pp->mpp && lvl <= libmp_verbosity) {		\
 		if (pp->sysfs_state == PATH_DOWN)		\
 			condlog(lvl, "%s: %s - path offline",	\
 				pp->mpp->alias, pp->dev);	\
-		else  {						\
+		else if (checker_selected(&pp->checker)) {	\
 			const char *__m =			\
 				checker_message(&pp->checker);	\
 								\
-- 
2.50.1

