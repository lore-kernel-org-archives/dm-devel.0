Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172831C2435
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177798; cv=none; b=qczvd2/0yRU+Iw6sU6KiZZOcRUE8Ff5E5R9DN+OEc0tYcfNdNsT+J+87tp9fwjOelrwzs6cMqxiOYcROP73w9nc+sW83+NpDO8DnV5wY3nB1E1PTDtpYM2TsS9w36cKqIWIBXU+GKaXvT5YZyJKCJxWLiSZvuzIniRDT5fNZIso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177798; c=relaxed/simple;
	bh=smN+wu34rAq4qoUCYwTNmbPA5KTag/DrsdSqQRnpuWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ypr+mCBe1Oi5LzCpTmf0dMeX0YfTBYY+LxKiNKvoa9ig8LJPHAnWcIgvh/EQxw0rtTkZXREZUBFOVCvjtJVBB1dtHK1tPwVNCCG6EIDd7VRv4Wg5bpTDGmlKbU0mQEYCtWkmYXKJK8U7irKiswb+aZ1gCIbfP2TRRblBaJRj0C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cFxzVeVV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cFxzVeVV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NFbDgk8oB3v3MPRY+piYm83FOIpNcrF6rflRXU47oJE=;
	b=cFxzVeVVwEyleaXeyf0CSXbMRNnGsrrSC7aNsAjyZI4iD7Af/Nvh2k3jWo/QWJ4bM8f4Y3
	gWSIab2wPE41BYdltMuag2ztYRjSiLY2m8JWbQagt+VQQ81eR901D1FCPA/XNvAwEL8GXp
	pEXRG2ORGl4fVYexhFd8UM3YyhaXRAA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-jSbDrFo5PeO0_-014P-EDg-1; Thu,
 12 Sep 2024 17:49:52 -0400
X-MC-Unique: jSbDrFo5PeO0_-014P-EDg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6ED11955F56;
	Thu, 12 Sep 2024 21:49:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3804719560B8;
	Thu, 12 Sep 2024 21:49:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnnx8783882
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:49 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnnxb783881;
	Thu, 12 Sep 2024 17:49:49 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 08/22] multipathd: split check_path_state into two functions
Date: Thu, 12 Sep 2024 17:49:33 -0400
Message-ID: <20240912214947.783819-9-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

check_path_state() is now split into start_path_check(), which calls
path_sysfs_state() and if the path is up also calls start_checker(), and
get_new_state() which gets the new state from either pp->sysfs_state
or get_state().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 33a57041..16c0531e 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2314,25 +2314,31 @@ should_skip_path(struct path *pp){
 	return 0;
 }
 
-static int
-check_path_state(struct path *pp)
+static void
+start_path_check(struct path *pp)
 {
-	int newstate;
 	struct config *conf;
 
-	newstate = path_sysfs_state(pp);
-	if (newstate == PATH_UP) {
+	if (path_sysfs_state(pp) ==  PATH_UP) {
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
-		newstate = PATH_UNCHECKED;
-		if (start_checker(pp, conf, 1, newstate) == 0)
-			newstate = get_state(pp);
+		start_checker(pp, conf, 1, PATH_UNCHECKED);
 		pthread_cleanup_pop(1);
 	} else {
 		checker_clear_message(&pp->checker);
 		condlog(3, "%s: state %s, checker not called",
-			pp->dev, checker_state_name(newstate));
+			pp->dev, checker_state_name(pp->sysfs_state));
 	}
+}
+
+static int
+get_new_state(struct path *pp)
+{
+	int newstate = pp->sysfs_state;
+	struct config *conf;
+
+	if (newstate == PATH_UP)
+		newstate = get_state(pp);
 	/*
 	 * Wait for uevent for removed paths;
 	 * some LLDDs like zfcp keep paths unavailable
@@ -2413,7 +2419,8 @@ do_check_path (struct vectors * vecs, struct path * pp)
 		pp->checkint = checkint;
 	};
 
-	newstate = check_path_state(pp);
+	start_path_check(pp);
+	newstate = get_new_state(pp);
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED)
 		return CHECK_PATH_SKIPPED;
 	/*
@@ -2752,7 +2759,8 @@ handle_uninitialized_path(struct vectors * vecs, struct path * pp,
 		}
 	}
 
-	newstate = check_path_state(pp);
+	start_path_check(pp);
+	newstate = get_new_state(pp);
 
 	if (!strlen(pp->wwid) &&
 	    (pp->initialized == INIT_FAILED || pp->initialized == INIT_NEW) &&
-- 
2.45.0

