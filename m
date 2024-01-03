Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DAD1CFB6
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UmqHVa/U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B+sya2l9P8r4JAApSXqmekbAz+o9L+g8LY/pYgUrhS0=;
	b=UmqHVa/Um2D6JHkCp/TxCG8YKeatHn2rNooNfqy85BuaKdfRvW+7zZE2kx9QKyfTgR3JmT
	0NQJVME2A3kBf9zZZy++bmgsOJDMahifRLbG2dYK0dLDBjHaEyvcUx1BgwkDmdF5BlZiP3
	tvFXi46/9/3XccnCCVFj/C7LzEN4Kt4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-lCrIVPMiP5iXLIJpkWeajA-1; Wed,
 03 Jan 2024 12:56:46 -0500
X-MC-Unique: lCrIVPMiP5iXLIJpkWeajA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 545973C02747;
	Wed,  3 Jan 2024 17:56:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EE7359A;
	Wed,  3 Jan 2024 17:56:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HukHu018527
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:46 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403Hukxr018526;
	Wed, 3 Jan 2024 12:56:46 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 15/18] multipath: get rid of unnecessary retries variable
Date: Wed,  3 Jan 2024 12:56:40 -0500
Message-ID: <20240103175643.18438-16-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

the -R option can just set conf->remove_retries directly. It has the
same effect.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 664f7b97..d3b46f3e 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -834,7 +834,6 @@ main (int argc, char *argv[])
 	enum devtypes dev_type = DEV_NONE;
 	char *dev = NULL;
 	struct config *conf;
-	int retries = -1;
 	bool enable_foreign = false;
 
 	libmultipath_init();
@@ -944,7 +943,7 @@ main (int argc, char *argv[])
 			cmd = CMD_ADD_WWID;
 			break;
 		case 'R':
-			retries = atoi(optarg);
+			conf->remove_retries = atoi(optarg);
 			break;
 		case 'e':
 			enable_foreign = true;
@@ -1069,20 +1068,18 @@ main (int argc, char *argv[])
 		vector_free(curmp);
 		goto out;
 	}
-	if (retries < 0)
-		retries = conf->remove_retries;
 	if (cmd == CMD_FLUSH_ONE) {
 		if (dm_is_mpath(dev) != 1) {
 			condlog(0, "%s is not a multipath device", dev);
 			r = RTVL_FAIL;
 			goto out;
 		}
-		r = (dm_suspend_and_flush_map(dev, retries) != DM_FLUSH_OK) ?
+		r = (dm_suspend_and_flush_map(dev, conf->remove_retries) != DM_FLUSH_OK) ?
 		    RTVL_FAIL : RTVL_OK;
 		goto out;
 	}
 	else if (cmd == CMD_FLUSH_ALL) {
-		r = (dm_flush_maps(retries) != DM_FLUSH_OK) ?
+		r = (dm_flush_maps(conf->remove_retries) != DM_FLUSH_OK) ?
 		    RTVL_FAIL : RTVL_OK;
 		goto out;
 	}
-- 
2.43.0

