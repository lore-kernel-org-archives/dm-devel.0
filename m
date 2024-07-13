Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA651BC3F
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850718; cv=none; b=nzPd6YnbiJT9XS/6V4f9C8UXToksdJiX+UO+IcvS3VeUR4KCKnQ2cAWUajtJEVoJX4BpsrmHzSjigi834aMgQFz4tbXyUK4clJwZhsvo2Artri6+lkdNuLj/4itIvLiEBTGfgbxfM3hiEWFIQcUj+h3dfkPQCTc7/sU2E+Na1ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850718; c=relaxed/simple;
	bh=3OtWutwTjBngfK6RCZeX4Qj6ULzOX8wjywwIdxJxAOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I6L6fF1IGCkxP7R1WOYHK+h6DuwKS+y+j4Ef0zAd3uq58CpHPQr6h00g9U9YbGyqI5PB4xsNWgpKppDNUMM8XepyOOeSEGh3B/ZS8fijbmt9Eqs4Z7srooEmWFPyxGmpVqekaeDhnYkz9mxm1MjWc+nynjn8CFeykJYXkuj4vAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dn5Xouwt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dn5Xouwt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=StTQPxX63814NujkC6A5Pxe7Nfg2N7ZFXIfLU7x9v00=;
	b=Dn5XouwtdIRS9dmfNFttLcki1kmKvSgXPpPN0kiZ9qQtjxLk95LLutBN5Ol11L0Z7JyxlD
	710pwyrf4Df5IsngXMPt36Iciu7tVaeL0aCn6bbcFrpEYgWEF2L8Fns4OemgEfmcDOErBx
	lP35hQGjU7NdiZjT8unNqDi31lNRkzY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-lNPKoEE4P8qR_ZcXtk_VlQ-1; Sat,
 13 Jul 2024 02:05:11 -0400
X-MC-Unique: lNPKoEE4P8qR_ZcXtk_VlQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4488819560AE;
	Sat, 13 Jul 2024 06:05:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E54411956066;
	Sat, 13 Jul 2024 06:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D6588j2015522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:08 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D658VI2015521;
	Sat, 13 Jul 2024 02:05:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 07/22] multipathd: remove redundant checks in handle_uninitialized_path()
Date: Sat, 13 Jul 2024 02:04:51 -0400
Message-ID: <20240713060506.2015463-8-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
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

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 51 +++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 28 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 276329c4..d6f4704b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2629,9 +2629,8 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 	struct config *conf;
 	int ret;
 
-	if (((pp->initialized == INIT_OK || pp->initialized == INIT_PARTIAL ||
-	      pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp) ||
-	    pp->initialized == INIT_REMOVED)
+	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
+	    pp->initialized != INIT_MISSING_UDEV)
 		return 0;
 
 	if (pp->tick)
@@ -2645,7 +2644,7 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 	max_checkint = conf->max_checkint;
 	put_multipath_config(conf);
 
-	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV) {
+	if (pp->initialized == INIT_MISSING_UDEV) {
 		if (pp->retriggers < retrigger_tries) {
 			static const char change[] = "change";
 			ssize_t ret;
@@ -2685,31 +2684,27 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 
 	newstate = check_path_state(pp);
 
-	if (!pp->mpp) {
-		if (!strlen(pp->wwid) &&
-		    (pp->initialized == INIT_FAILED ||
-		     pp->initialized == INIT_NEW) &&
-		    (newstate == PATH_UP || newstate == PATH_GHOST)) {
-			condlog(2, "%s: add missing path", pp->dev);
-			conf = get_multipath_config();
-			pthread_cleanup_push(put_multipath_config, conf);
-			ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
-			pthread_cleanup_pop(1);
-			/* INIT_OK implies ret == PATHINFO_OK */
-			if (pp->initialized == INIT_OK) {
-				ev_add_path(pp, vecs, 1);
-				pp->tick = 1;
-			} else {
-				if (ret == PATHINFO_SKIPPED)
-					return -1;
-				/*
-				 * We failed multiple times to initialize this
-				 * path properly. Don't re-check too often.
-				 */
-				pp->checkint = max_checkint;
-			}
+	if (!strlen(pp->wwid) &&
+	    (pp->initialized == INIT_FAILED || pp->initialized == INIT_NEW) &&
+	    (newstate == PATH_UP || newstate == PATH_GHOST)) {
+		condlog(2, "%s: add missing path", pp->dev);
+		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
+		ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
+		pthread_cleanup_pop(1);
+		/* INIT_OK implies ret == PATHINFO_OK */
+		if (pp->initialized == INIT_OK) {
+			ev_add_path(pp, vecs, 1);
+			pp->tick = 1;
+		} else {
+			if (ret == PATHINFO_SKIPPED)
+				return -1;
+			/*
+			 * We failed multiple times to initialize this
+			 * path properly. Don't re-check too often.
+			 */
+			pp->checkint = max_checkint;
 		}
-		return 0;
 	}
 	return 0;
 }
-- 
2.45.0

