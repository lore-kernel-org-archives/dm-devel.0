Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2451CA9E
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cvx+1nVZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xBhYSdcldw5FB+Ye9MZgYqTbal81qJbUvbq75C2zRJQ=;
	b=cvx+1nVZ/Z8FDssgmhmBAGCyUqHzeF5gI2BWR8sPFEVjzdwjwioM18gaBDS2KzclDtsa9M
	KYoLG/ngXvGcmFLBJgKHVFzx1Ha05Lx6SeWApQmHwsVsDS70ShG/sUftzUYo3DZ8/5oaNr
	A41olT+jl+anhLwEnbFPEw+jqtY2aWA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-rR4SapXfNhCShRLl0QF0ag-1; Wed, 03 Jan 2024 12:56:45 -0500
X-MC-Unique: rR4SapXfNhCShRLl0QF0ag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04B1D882081;
	Wed,  3 Jan 2024 17:56:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F33E851D5;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HuiNV018495
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403Hui3Q018494;
	Wed, 3 Jan 2024 12:56:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/18] multipathd: always start failure replies with "fail\n"
Date: Wed,  3 Jan 2024 12:56:32 -0500
Message-ID: <20240103175643.18438-8-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

When multipathd interactive commands fail for certain reasons, like
timing out or incorrect permissions, they do not reply with "fail\n".
Currently, multipath and multipathc expect that a reply other than
"fail\n" means success. Instead, prefix all failure replies with
"fail\n", and adapt multipath and multipathc to return failure for any
reply starting with "fail\n".

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libdmmp/libdmmp.c   |  6 +++---
 multipath/main.c    | 13 ++++++++++---
 multipathd/uxclnt.c |  9 +++++++--
 multipathd/uxlsnr.c | 12 +++++-------
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index 0025e66d..77f8a6a0 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -321,7 +321,7 @@ invoke:
 		}
 	}
 	if ((*output != NULL) &&
-	    (strncmp(*output, "timeout", strlen("timeout")) == 0))
+	    (strncmp(*output, "fail\ntimeout", strlen("fail\ntimeout")) == 0))
 		flag_check_tmo = true;
 
 	if (flag_check_tmo == true) {
@@ -364,8 +364,8 @@ invoke:
 	}
 
 	if ((*output != NULL) &&
-	    strncmp(*output, "permission deny",
-		    strlen("permission deny")) == 0) {
+	    strncmp(*output, "fail\npermission deny",
+		    strlen("fail\npermission deny")) == 0) {
 		_error(ctx, "Permission deny, need to be root");
 		rc = DMMP_ERR_PERMISSION_DENY;
 		goto out;
diff --git a/multipath/main.c b/multipath/main.c
index 00302087..48d684e3 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -804,10 +804,17 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
 	}
 
 	if (reply != NULL && *reply != '\0') {
-		if (strcmp(reply, "fail\n"))
+		if (strncmp(reply, "fail\n", 5))
 			r = DELEGATE_OK;
-		if (r != NOT_DELEGATED && strcmp(reply, "ok\n"))
-			printf("%s", reply);
+		if (r != NOT_DELEGATED && strcmp(reply, "ok\n")) {
+			/* If there is additional failure information, skip the
+			 * initial 'fail' */
+			if (strncmp(reply, "fail\n", 5) == 0 &&
+			    strlen(reply) > 5)
+				printf("%s", reply + 5);
+			else
+				printf("%s", reply);
+		}
 	}
 
 out:
diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index c3ae5db6..16133a88 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -30,8 +30,13 @@ static int process_req(int fd, char * inbuf, unsigned int timeout)
 			printf("error %d receiving packet\n", ret);
 		return 1;
 	} else {
-		printf("%s", reply);
-		ret = (strcmp(reply, "fail\n") == 0);
+		ret = (strncmp(reply, "fail\n", 5) == 0);
+		/* If there is additional failure information, skip the
+		 * initial 'fail' */
+		if (ret && strlen(reply) > 5)
+			printf("%s", reply + 5);
+		else
+			printf("%s", reply);
 		free(reply);
 		return ret;
 	}
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 4d6f258c..4df01666 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -392,6 +392,11 @@ static void drain_idle_fd(int fd)
 
 void default_reply(struct client *c, int r)
 {
+	if (r == 0) {
+		append_strbuf_str(&c->reply, "ok\n");
+		return;
+	}
+	append_strbuf_str(&c->reply, "fail\n");
 	switch(r) {
 	case -EINVAL:
 	case -ESRCH:
@@ -406,13 +411,6 @@ void default_reply(struct client *c, int r)
 	case -ETIMEDOUT:
 		append_strbuf_str(&c->reply, "timeout\n");
 		break;
-	case 0:
-		append_strbuf_str(&c->reply, "ok\n");
-		break;
-	default:
-		/* cli_handler functions return 1 on unspecified error */
-		append_strbuf_str(&c->reply, "fail\n");
-		break;
 	}
 }
 
-- 
2.43.0

