Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191113D0A4
	for <dm-devel@lists.linux.dev>; Tue, 19 Dec 2023 22:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hp0KP5n5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703026313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+uYS/L+wPY36hVh76KdbXQOZ3/F2VYJ7TfZtgPKNUQ=;
	b=hp0KP5n5YU/Z8qMsnwKtT9BzvqolBH5kDMxBUyGKnORms/G+7Jlhi/WB+MtFKWMdggNyYx
	2a9cPocWmiKeg9TO/86BmY6SH52IkUawRhq2StyFBzOCGIbff91LR7ZPMrVuUlV+SmNsvQ
	dCgykTYqEU6+Sz/usWVzdF2Qn+kTFjQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-UzM2Pen1POeBeeAg_JiI6g-1; Tue, 19 Dec 2023 17:51:52 -0500
X-MC-Unique: UzM2Pen1POeBeeAg_JiI6g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E60C83B9CA;
	Tue, 19 Dec 2023 22:51:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 389FA492BE6;
	Tue, 19 Dec 2023 22:51:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BJMpq2F787543
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 17:51:52 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BJMpqqS787542;
	Tue, 19 Dec 2023 17:51:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 2/5] multipathd: Make sure to disable queueing if recovery has failed.
Date: Tue, 19 Dec 2023 17:51:48 -0500
Message-ID: <20231219225151.787521-3-bmarzins@redhat.com>
In-Reply-To: <20231219225151.787521-1-bmarzins@redhat.com>
References: <20231219225151.787521-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If a multipath device has no_path_retry set to a number and has lost all
paths, gone into recovery mode, and timed out, it will disable
queue_if_no_paths. After that, if the device is reloaded by multipath
outside of multipathd, it will re-enable queuieng on the device. When
multipathd later calls set_no_path_retry() to update the queueing state,
it will not disable queue_if_no_paths, since the device is still in the
recovery state, so it believes no work needs to be done. The device will
remain in the recovery state, with retry_ticks at 0, and queueing
enabled, even though there are no usable paths.

To fix this, in set_no_path_retry(), if no_path_retry is set to a number
and the device is queueing but it is in recovery mode and out of
retries with no usable paths, manually disable queue_if_no_path.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 0e8a46e7..66bc264c 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -627,8 +627,19 @@ void set_no_path_retry(struct multipath *mpp)
 			    !mpp->in_recovery)
 				dm_queue_if_no_path(mpp->alias, 1);
 			leave_recovery_mode(mpp);
-		} else if (pathcount(mpp, PATH_PENDING) == 0)
-			enter_recovery_mode(mpp);
+		} else {
+			/*
+			 * If in_recovery is set, enter_recovery_mode does
+			 * nothing. If the device is already in recovery
+			 * mode and has already timed out, manually call
+			 * dm_queue_if_no_path to stop it from queueing.
+			 */
+			if ((!mpp->features || is_queueing) &&
+			    mpp->in_recovery && mpp->retry_tick == 0)
+				dm_queue_if_no_path(mpp->alias, 0);
+			if (pathcount(mpp, PATH_PENDING) == 0)
+				enter_recovery_mode(mpp);
+		}
 		break;
 	}
 }
@@ -774,6 +785,11 @@ int verify_paths(struct multipath *mpp)
  *   -1 (FAIL)  : fail_if_no_path
  *    0 (UNDEF) : nothing
  *   >0         : queue_if_no_path enabled, turned off after polling n times
+ *
+ * Since this will only be called when fail_path(), update_multipath(), or
+ * io_err_stat_handle_pathfail() are failing a previously active path, the
+ * device cannot already be in recovery mode, so there will never be a need
+ * to disable queueing here.
  */
 void update_queue_mode_del_path(struct multipath *mpp)
 {
@@ -787,6 +803,12 @@ void update_queue_mode_del_path(struct multipath *mpp)
 	condlog(2, "%s: remaining active paths: %d", mpp->alias, active);
 }
 
+/*
+ * Since this will only be called from check_path() -> reinstate_path() after
+ * the queueing state has been updated in set_no_path_retry, this does not
+ * need to worry about modifying the queueing state except when actually
+ * leaving recovery mode.
+ */
 void update_queue_mode_add_path(struct multipath *mpp)
 {
 	int active = count_active_paths(mpp);
-- 
2.41.0

