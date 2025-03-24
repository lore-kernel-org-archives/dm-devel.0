Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C411DDC2E
	for <dm-devel@lists.linux.dev>; Mon, 24 Mar 2025 20:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742849717; cv=none; b=treGlH0dyGbjiSt4PpdKKNmU6OiuOaXulEdbKjQjwcg4lEvzPac3DOLzhnGhJcpJO4MENtgJArZZ+8+dI2FquRYYWAip1XIDMcoogSWQYrx0F3Px23Q4QjldAm9hcsVex5SAGUmY3G0q50h36j7gtUNMZ8xxH29JtQokMoFRs9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742849717; c=relaxed/simple;
	bh=cJn0KPltPwkBtJ31MAQ98mQ9ncZX+xllVCW5EKF72RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=V0wVjK5VEVaj0T8qA9NIHvJd8l24f4wGkbhroBySowkKM53LAfKMXGELpUXMpY9jYhppKH9S68zqdL1aop8e0VrEfqsKyZxBnIMLBeYeIPVjB6ShnWADh3HvXKXkT/pxDnecjyPpDPYHHbvizbzYUBbS+KCymM6oauKtm7i+Q78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wg1KL6+T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wg1KL6+T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742849714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bini51AyghS869Fo9ZVqtInURvx016+RKXKb6ducmRo=;
	b=Wg1KL6+TMdEl9gp1jPgMa9kKR3Ha+8RtcXH19q8zqRZzxCWjL/fVGjOw9OTuXROfEj83/x
	sq2WOVrPvS75eAjqKLi1IvcS+jFTU7j1y1NbpxPDmXE7lF/wFIKsFPzxw1SjrJFkJJ5QUw
	B7gIDj2S9k+pW1WczOEUoTFPEAUcMwk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-127-89JtDcflN2aPAcoD-y7aTg-1; Mon,
 24 Mar 2025 16:55:08 -0400
X-MC-Unique: 89JtDcflN2aPAcoD-y7aTg-1
X-Mimecast-MFC-AGG-ID: 89JtDcflN2aPAcoD-y7aTg_1742849708
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E515019373D7;
	Mon, 24 Mar 2025 20:55:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E3CF180B491;
	Mon, 24 Mar 2025 20:55:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52OKt62B2523513
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 16:55:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52OKt6Ce2523512;
	Mon, 24 Mar 2025 16:55:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/3] multipathd: re-add paths skipped because they were offline
Date: Mon, 24 Mar 2025 16:55:03 -0400
Message-ID: <20250324205504.2523493-3-bmarzins@redhat.com>
In-Reply-To: <20250324205504.2523493-1-bmarzins@redhat.com>
References: <20250324205504.2523493-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YO17QDpWz3vmx6jWdfJ2a-TNHrL3t42qkRWlGK_tfYw_1742849708
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When a new device is added by the multipath command, multipathd may know
of other paths that cannot be added to the device because they are
currently offline. Instead of ignoring these paths, multipathd will now
re-add them when they come back online. To do this, it multipathd needs
a new device initialized state, INIT_OFFLINE, to track devices that were
in INIT_OK, but could not be added to an existing multipath device
because they were offline. These paths are handled along with the other
uninitialized paths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c       |  1 +
 libmultipath/structs.h     |  5 ++++
 libmultipath/structs_vec.c |  5 ++++
 multipathd/main.c          | 58 ++++++++++++++++++++++++++++++++++++--
 4 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 00c03ace..ed8adebe 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -572,6 +572,7 @@ static int snprint_initialized(struct strbuf *buff, const struct path * pp)
 		[INIT_OK] = "ok",
 		[INIT_REMOVED] = "removed",
 		[INIT_PARTIAL] = "partial",
+		[INIT_OFFLINE] = "offline",
 	};
 	const char *str;
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 28de9a7f..8644407f 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -258,6 +258,11 @@ enum initialized_states {
 	 * change uevent is received.
 	 */
 	INIT_PARTIAL,
+	/*
+	 * INIT_OFFLINE: paths that should be part of an existing multipath
+	 * device, but cannot be added because they are offline,
+	 */
+	INIT_OFFLINE,
 	INIT_LAST__,
 };
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f6407e12..f122d056 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -389,6 +389,9 @@ static void orphan_paths(vector pathvec, struct multipath *mpp, const char *reas
 				free_path(pp);
 			} else
 				orphan_path(pp, reason);
+		} else if (pp->initialized == INIT_OFFLINE &&
+			   strncmp(mpp->wwid, pp->wwid, WWID_SIZE) == 0) {
+			pp->initialized = INIT_OK;
 		}
 	}
 }
@@ -595,6 +598,8 @@ void sync_paths(struct multipath *mpp, vector pathvec)
 		found = 0;
 		vector_foreach_slot(mpp->pg, pgp, j) {
 			if (find_slot(pgp->paths, (void *)pp) != -1) {
+				if (pp->initialized == INIT_OFFLINE)
+					pp->initialized = INIT_OK;
 				found = 1;
 				break;
 			}
diff --git a/multipathd/main.c b/multipathd/main.c
index 7aaae773..ecad5a4f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -644,11 +644,44 @@ pr_register_active_paths(struct multipath *mpp)
 	}
 }
 
+static void
+save_offline_paths(struct multipath *mpp, vector offline_paths)
+{
+	unsigned int i, j;
+	struct path *pp;
+	struct pathgroup *pgp;
+
+	vector_foreach_slot (mpp->pg, pgp, i)
+		vector_foreach_slot (pgp->paths, pp, j)
+			if (pp->initialized == INIT_OK &&
+			    pp->sysfs_state == PATH_DOWN)
+				store_path(offline_paths, pp);
+}
+
+static void
+handle_orphaned_offline_paths(vector offline_paths)
+{
+	unsigned int i;
+	struct path *pp;
+
+	vector_foreach_slot (offline_paths, pp, i)
+		if (pp->mpp == NULL)
+			pp->initialized = INIT_OFFLINE;
+}
+
+static void
+cleanup_reset_vec(struct vector_s **v)
+{
+	vector_reset(*v);
+}
+
 static int
 update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
 {
 	int retries = 3;
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
+	struct vector_s offline_paths_vec = { .allocated = 0 };
+	vector offline_paths __attribute__((cleanup(cleanup_reset_vec))) = &offline_paths_vec;
 
 retry:
 	condlog(4, "%s: updating new map", mpp->alias);
@@ -685,6 +718,9 @@ fail:
 		return 1;
 	}
 
+	if (new_map && retries < 0)
+		save_offline_paths(mpp, offline_paths);
+
 	if (setup_multipath(vecs, mpp))
 		return 1;
 
@@ -695,6 +731,9 @@ fail:
 	if (mpp->prflag == PRFLAG_SET)
 		pr_register_active_paths(mpp);
 
+	if (VECTOR_SIZE(offline_paths) != 0)
+		handle_orphaned_offline_paths(offline_paths);
+
 	if (retries < 0)
 		condlog(0, "%s: failed reload in new map update", mpp->alias);
 	return 0;
@@ -2793,7 +2832,8 @@ check_uninitialized_path(struct path * pp, unsigned int ticks)
 	struct config *conf;
 
 	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
-	    pp->initialized != INIT_MISSING_UDEV)
+	    pp->initialized != INIT_MISSING_UDEV &&
+	    pp->initialized != INIT_OFFLINE)
 		return CHECK_PATH_SKIPPED;
 
 	if (pp->tick)
@@ -2849,7 +2889,8 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 	struct config *conf;
 
 	if (pp->initialized != INIT_NEW && pp->initialized != INIT_FAILED &&
-	    pp->initialized != INIT_MISSING_UDEV)
+	    pp->initialized != INIT_MISSING_UDEV &&
+	    pp->initialized != INIT_OFFLINE)
 		return CHECK_PATH_SKIPPED;
 
 	newstate = get_new_state(pp);
@@ -2875,6 +2916,19 @@ update_uninitialized_path(struct vectors * vecs, struct path * pp)
 			free_path(pp);
 			return CHECK_PATH_REMOVED;
 		}
+	} else if (pp->initialized == INIT_OFFLINE &&
+		   (newstate == PATH_UP || newstate == PATH_GHOST)) {
+		pp->initialized = INIT_OK;
+		if (pp->recheck_wwid == RECHECK_WWID_ON &&
+		    check_path_wwid_change(pp)) {
+			condlog(0, "%s: path wwid change detected. Removing",
+				pp->dev);
+			return handle_path_wwid_change(pp, vecs)?
+					CHECK_PATH_REMOVED :
+					CHECK_PATH_SKIPPED;
+		}
+		ev_add_path(pp, vecs, 1);
+		pp->tick = 1;
 	}
 	return CHECK_PATH_CHECKED;
 }
-- 
2.48.1

