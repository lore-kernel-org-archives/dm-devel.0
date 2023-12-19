Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE493D0B7
	for <dm-devel@lists.linux.dev>; Tue, 19 Dec 2023 22:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SHeC4FkN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703026316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wrNVNQPw7umTbdsAeNvPwy014pFzYQj7eLcjfH8mass=;
	b=SHeC4FkN6zFJ5L7wcp8O3o+Ypczx6I9WfBqb85peUeOXHn/ARUuZmvXyazELBdbnNRGgo/
	asXI3+oNeP8r5n+gV4i9iDWxx/o0tZycpGXMucRtd0euJB3Qi4W+DnSBCq8bsXTpuw1mVx
	8GlMD7eglzUtN8bom58yoSaEkfzHzGE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-LM3sukONNRqWI8ZR-mxC-g-1; Tue, 19 Dec 2023 17:51:52 -0500
X-MC-Unique: LM3sukONNRqWI8ZR-mxC-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17582101A551;
	Tue, 19 Dec 2023 22:51:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F82F2166B31;
	Tue, 19 Dec 2023 22:51:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BJMpptB787539
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 17:51:51 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BJMppFN787538;
	Tue, 19 Dec 2023 17:51:51 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 1/5] libmultipath: avoid temporarily enabling queueing on reload
Date: Tue, 19 Dec 2023 17:51:47 -0500
Message-ID: <20231219225151.787521-2-bmarzins@redhat.com>
In-Reply-To: <20231219225151.787521-1-bmarzins@redhat.com>
References: <20231219225151.787521-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Martin Wilck <mwilck@suse.com>

Instead of always enabling queueing when a map is reloaded with
no_path_retry set to a positive number, check if the map has timed out
in recovery mode, and only enable queueing if it has not. This saves
multipathd from having to disable queueing on the map immediately after
the reload.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dmparser.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 3b37a926..3d85e6ee 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -60,9 +60,19 @@ int assemble_map(struct multipath *mp, char **params)
 	nr_priority_groups = VECTOR_SIZE(mp->pg);
 	initial_pg_nr = (nr_priority_groups ? mp->bestpg : 0);
 
-	if (mp->no_path_retry != NO_PATH_RETRY_UNDEF  &&
-	    mp->no_path_retry != NO_PATH_RETRY_FAIL) {
+	switch (mp->no_path_retry) {
+	case NO_PATH_RETRY_UNDEF:
+	case NO_PATH_RETRY_FAIL:
+		break;
+	default:
+		/* don't enable queueing if no_path_retry has timed out */
+		if (mp->in_recovery && mp->retry_tick == 0 &&
+		    count_active_paths(mp) == 0)
+			break;
+		/* fallthrough */
+	case NO_PATH_RETRY_QUEUE:
 		add_feature(&mp->features, no_path_retry);
+		break;
 	}
 	if (mp->retain_hwhandler == RETAIN_HWHANDLER_ON &&
 	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0))
-- 
2.41.0

