Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347FE381CD
	for <dm-devel@lists.linux.dev>; Mon, 27 Nov 2023 21:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X7GB8s1W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701122063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RTbNAGCtbzca6uFPpaUf7DX5WX9JlulRrIedCGcqu3Q=;
	b=X7GB8s1WsfEMwp9gDKxmXQ+8v0r6YuG7ZiAZc5ZSJSmyoZsX+mn8okvNQ/CmH8NDKlZEC8
	u9vcpE5Nhgl6DnUP465aYQAjTGD9AG4LOoubyZIdL3+g8cZAVmj4ZaV71qYJJGRPTUrxgk
	casQdKBhxR19oaskxhrtUAvawLA7rzw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-32-7Az_7Bp9MA6Ha-FNhwesLw-1; Mon,
 27 Nov 2023 16:54:19 -0500
X-MC-Unique: 7Az_7Bp9MA6Ha-FNhwesLw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50731280666F;
	Mon, 27 Nov 2023 21:54:19 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46FABC15984;
	Mon, 27 Nov 2023 21:54:19 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3ARLsJpg271717
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 27 Nov 2023 16:54:19 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3ARLsI5W271716;
	Mon, 27 Nov 2023 16:54:18 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] multipathd: Make sure to disable queueing if recovery has failed.
Date: Mon, 27 Nov 2023 16:54:18 -0500
Message-ID: <20231127215418.271708-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

If a multipath device has no_path_retry set to a number and has lost all
paths, gone into recovery mode, and timed out, it will disable
queue_if_no_paths. After that, if one of those failed paths is removed,
when the device is reloaded, queue_if_no_paths will be re-enabled.  When
set_no_path_retry() is then called to update the queueing state, it will
not disable queue_if_no_paths, since the device is still in the recovery
state, so it believes no work needs to be done. The device will remain
in the recovery state, with retry_ticks at 0, and queueing enabled,
even though there are no usable paths.

To fix this, in set_no_path_retry(), if no_path_retry is set to a number
and the device is queueing but it is in recovery mode and out of
retries with no usable paths, manually disable queue_if_no_path.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 0e8a46e7..3cb23c73 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -627,8 +627,18 @@ void set_no_path_retry(struct multipath *mpp)
 			    !mpp->in_recovery)
 				dm_queue_if_no_path(mpp->alias, 1);
 			leave_recovery_mode(mpp);
-		} else if (pathcount(mpp, PATH_PENDING) == 0)
+		} else if (pathcount(mpp, PATH_PENDING) == 0) {
+			/*
+			 * If in_recovery is set, enter_recovery_mode does
+			 * nothing. If the device is already in recovery
+			 * mode and has already timed out, manually call
+			 * dm_queue_if_no_path to stop it from queueing.
+			 */
+			if ((!mpp->features || is_queueing) &&
+			    mpp->in_recovery && mpp->retry_tick == 0)
+				dm_queue_if_no_path(mpp->alias, 0);
 			enter_recovery_mode(mpp);
+		}
 		break;
 	}
 }
-- 
2.41.0

