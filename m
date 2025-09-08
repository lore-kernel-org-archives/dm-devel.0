Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A658B30FF13
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376014; cv=none; b=d9pPp9jieOuY8OG1fE4vJMyUGifsX/v6yRlmtoFeClXiyDPb9Vk8mASu/x0bUWlYSMgjF2qHbKpopEN8pO5h4NE4Ds4jgaNH2p+3Q5zy0vT4ADmQaNOFV3xgEbWT3LCFn5/c4aZwgO/xta/jQ8W/yuEFH5PAfsAUhHMPP8zRVcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376014; c=relaxed/simple;
	bh=uclxYugMbnjzXV9001/nmHQpLweu8+Ic/RfqT75Ewpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=nmRJ3CBNjSi8kbRaV80GNrXV8s3JgiBUrsN8kuNEmpOG9C7DHVspzODzXyvQSCAC9W3yNX+mjDqDYgAJ8FeOUioyRbpwtEXPilJjTaZKslVM/XrA2sE3k57E2GsGfbt7atYIt4Ol4j5NxxUHsq0I1igWGdOLYwACG12fdlnESCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WyxS7MbR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WyxS7MbR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VywfB75pko3mv8y97+4jLTs72D/0+Xa8h0x72FgaOYY=;
	b=WyxS7MbRLVXARCP3izOobbJTVxyzZZlXUAhyjvptom9AQXU0IVtmQsZO2Un/M6M8121G5c
	5EhkXO/dITHez76rr41pnpdW4weXFRU0BKPcV4sV/5B3m32xzAlFaJbWqZsRQTxP4dO4my
	ojyvUOlLpezJmtlCGKjWHNoWAQXKh0A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-JECs6lEmMG2HcuFWT2lT8Q-1; Mon,
 08 Sep 2025 20:00:08 -0400
X-MC-Unique: JECs6lEmMG2HcuFWT2lT8Q-1
X-Mimecast-MFC-AGG-ID: JECs6lEmMG2HcuFWT2lT8Q_1757376007
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DDEC19560A1;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F44419560A2;
	Tue,  9 Sep 2025 00:00:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5890055J751124
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5890054Y751123;
	Mon, 8 Sep 2025 20:00:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 11/32] libmpathpersist: Handle changing key corner case
Date: Mon,  8 Sep 2025 19:59:41 -0400
Message-ID: <20250909000002.751039-12-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P03HJGftJo180jn4NExBDTqkIDR3IbmRo0csx42hspY_1757376007
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When you change the reservation key of a registered multipath device,
some of paths might be down or even deleted since you originally
registered the key. libmpathpersist won't be able to change these
registrations. This can be a problem if the path that is down is holding
the reservation. Other nodes will assume that the reservation is now
under your new key, when it is still under the old one. If they try to
preempt the reservation, they will succeed. But they will just
unregister all the paths with the new key. They won't take over the
reservation, and if the path holding it comes back up, it will still be
able to write to the device.

To avoid this, after libmpathpersist changes the key of a registered
device, it now checks to see if its old key is still holding the
reservation. If it is, limpathpersist preempts the reservation.
Currently this only works on REGISTER commands, not REGISTER AND IGNORE
ones. A future patch will add that capability. This patch also moves
mpath_prout_common() up, without changing it at all.

I should note that this relies on the fact that libmpathpersist has
never worked correctly if two nodes use the same reservation key for the
same device. If another node used the same key, it could be the one
holding the reservation, and preempting the reservation would deregister
it. However, multipathd has always relied on the fact that two nodes
will not use the same registration key to know if it is safe to register
a key on a path that was just added or just came back up. If there is
already a registered key matching the configured key, multipathd assumes
that the device has not been preempted, and registers the key on the
path. If there are no keys matching the configured key, multipathd
assumes that the device has been preempted, and won't register a key.
Again, if another node shared the same key, multipathd could registered
paths on a node that had been preempted.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.c | 127 ++++++++++++++++++++--------
 1 file changed, 93 insertions(+), 34 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index d78d4fd8..f3dbd976 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -220,6 +220,97 @@ static void *mpath_prout_pthread_fn(void *p)
 	pthread_exit(NULL);
 }
 
+static int
+mpath_prout_common(struct multipath *mpp, int rq_servact, int rq_scope,
+		   unsigned int rq_type, struct prout_param_descriptor *paramp,
+		   int noisy, struct path **pptr)
+{
+	int i, j, ret;
+	struct pathgroup *pgp = NULL;
+	struct path *pp = NULL;
+	bool found = false;
+
+	vector_foreach_slot (mpp->pg, pgp, j) {
+		vector_foreach_slot (pgp->paths, pp, i) {
+			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))) {
+				condlog(1, "%s: %s path not up. Skip",
+					mpp->wwid, pp->dev);
+				continue;
+			}
+
+			condlog(3, "%s: sending pr out command to %s",
+				mpp->wwid, pp->dev);
+			found = true;
+			ret = prout_do_scsi_ioctl(pp->dev, rq_servact, rq_scope,
+						  rq_type, paramp, noisy);
+			if (ret == MPATH_PR_SUCCESS && pptr)
+				*pptr = pp;
+			if (ret != MPATH_PR_RETRYABLE_ERROR)
+				return ret;
+		}
+	}
+	if (found)
+		return MPATH_PR_OTHER;
+	condlog(0, "%s: no path available", mpp->wwid);
+	return MPATH_PR_DMMP_ERROR;
+}
+
+/*
+ * If you are changing the key registered to a device, and that device is
+ * holding the reservation on a path that couldn't get its key updated,
+ * either because it is down or no longer part of the multipath device,
+ * you need to preempt the reservation to a usable path with the new key
+ */
+void preempt_missing_path(struct multipath *mpp, uint8_t *key, uint8_t *sa_key,
+			  int noisy)
+{
+	uint8_t zero[8] = {0};
+	struct prin_resp resp = {{{.prgeneration = 0}}};
+	int rq_scope;
+	unsigned int rq_type;
+	struct prout_param_descriptor paramp = {.sa_flags = 0};
+	int status;
+
+	/*
+	 * If you previously didn't have a key registered or you didn't
+	 * switch to a different key, there's no need to preempt. Also, you
+	 * can't preempt if you no longer have a registered key
+	 */
+	if (memcmp(key, zero, 8) == 0 || memcmp(sa_key, zero, 8) == 0 ||
+	    memcmp(key, sa_key, 8) == 0)
+		return;
+
+	status = mpath_prin_activepath(mpp, MPATH_PRIN_RRES_SA, &resp, noisy);
+	if (status != MPATH_PR_SUCCESS) {
+		condlog(0, "%s: register: pr in read reservation command failed.",
+			mpp->wwid);
+		return;
+	}
+	/* If there is no reservation, there's nothing to preempt */
+	if (!resp.prin_descriptor.prin_readresv.additional_length)
+		return;
+	/*
+	 * If there reservation is not held by the old key, you don't
+	 * want to preempt it
+	 */
+	if (memcmp(key, resp.prin_descriptor.prin_readresv.key, 8) != 0)
+		return;
+	/* Assume this key is being held by an inaccessable path on this
+	 * node. libmpathpersist has never worked if multiple nodes share
+	 * the same reservation key for a device
+	 */
+	rq_type = resp.prin_descriptor.prin_readresv.scope_type & MPATH_PR_TYPE_MASK;
+	rq_scope = (resp.prin_descriptor.prin_readresv.scope_type &
+		    MPATH_PR_SCOPE_MASK) >>
+		   4;
+	memcpy(paramp.key, sa_key, 8);
+	memcpy(paramp.sa_key, key, 8);
+	status = mpath_prout_common(mpp, MPATH_PROUT_PREE_SA, rq_scope,
+				    rq_type, &paramp, noisy, NULL);
+	if (status != MPATH_PR_SUCCESS)
+		condlog(0, "%s: register: pr preempt command failed.", mpp->wwid);
+}
+
 static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 			   unsigned int rq_type,
 			   struct prout_param_descriptor * paramp, int noisy)
@@ -360,43 +451,11 @@ static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	}
 
 	pthread_attr_destroy(&attr);
+	if (status == MPATH_PR_SUCCESS)
+		preempt_missing_path(mpp, paramp->key, paramp->sa_key, noisy);
 	return (status == MPATH_PR_RETRYABLE_ERROR) ? MPATH_PR_OTHER : status;
 }
 
-static int
-mpath_prout_common(struct multipath *mpp, int rq_servact, int rq_scope,
-		   unsigned int rq_type, struct prout_param_descriptor *paramp,
-		   int noisy, struct path **pptr)
-{
-	int i,j, ret;
-	struct pathgroup *pgp = NULL;
-	struct path *pp = NULL;
-	bool found = false;
-
-	vector_foreach_slot (mpp->pg, pgp, j){
-		vector_foreach_slot (pgp->paths, pp, i){
-			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
-				condlog (1, "%s: %s path not up. Skip",
-					 mpp->wwid, pp->dev);
-				continue;
-			}
-
-			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
-			found = true;
-			ret = prout_do_scsi_ioctl(pp->dev, rq_servact, rq_scope,
-						  rq_type, paramp, noisy);
-			if (ret == MPATH_PR_SUCCESS && pptr)
-				*pptr = pp;
-			if (ret != MPATH_PR_RETRYABLE_ERROR)
-				return ret;
-		}
-	}
-	if (found)
-		return MPATH_PR_OTHER;
-	condlog (0, "%s: no path available", mpp->wwid);
-	return MPATH_PR_DMMP_ERROR;
-}
-
 static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
 			   unsigned int rq_type,
 			   struct prout_param_descriptor * paramp, int noisy)
-- 
2.50.1

