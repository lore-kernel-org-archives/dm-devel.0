Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2AA1CAAC
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EXpZBttg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Aff1zwaXEGFmrdc0zU3OfJTMHtYqr3RD135zu6+CG/E=;
	b=EXpZBttg6x+9Nu5Kptk1UQR9PbM/jFJc+wZYACpSsFOxHRii6OCcKplOqfRSKyERVjtoES
	ulDqD5wuR88IL5PDGBaaCr71jDuXvGOVhJoF5jZsAuUpUUn1z2cpq95iLn4jvfn8Ic53QO
	kLKOwp7AtXBwLN2oNeQDWFxECyXQrB0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-oqnkDXQdMY6eEJHHWPHbcQ-1; Wed,
 03 Jan 2024 12:56:46 -0500
X-MC-Unique: oqnkDXQdMY6eEJHHWPHbcQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DCFA3C02746;
	Wed,  3 Jan 2024 17:56:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 26DBF24ED;
	Wed,  3 Jan 2024 17:56:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HujLe018523
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:46 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403HujeG018522;
	Wed, 3 Jan 2024 12:56:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>, Gris Ge <fge@redhat.com>
Subject: [PATCH v2 14/18] libdmmp: handle failures in _process_cmd
Date: Wed,  3 Jan 2024 12:56:39 -0500
Message-ID: <20240103175643.18438-15-bmarzins@redhat.com>
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

currently, most of the callers of _process_cmd() do not gracefully
handle the case where multipathd returns "fail\n". dmmp_flush_mpath()
does, but it does extra work to try to figure out after the fact why the
flush command failed. Instead, handle fail replies in _process_cmd()
using the appropriate DMMP error codes.

Cc: Gris Ge <fge@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libdmmp/libdmmp.c | 69 +++++++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 41 deletions(-)

diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index 77f8a6a0..fcfba06e 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -354,22 +354,36 @@ invoke:
 		_debug(ctx, "IPC timeout, but user requested timeout has not "
 		       "reached yet, still have %u milliseconds", ipc_tmo);
 		goto invoke;
-	} else {
-		if ((*output == NULL) || (strlen(*output) == 0)) {
-			_error(ctx, "IPC return empty reply for command %s",
-			       cmd);
-			rc = DMMP_ERR_IPC_ERROR;
-			goto out;
-		}
 	}
-
-	if ((*output != NULL) &&
-	    strncmp(*output, "fail\npermission deny",
-		    strlen("fail\npermission deny")) == 0) {
-		_error(ctx, "Permission deny, need to be root");
-		rc = DMMP_ERR_PERMISSION_DENY;
+	if ((*output == NULL) || (strlen(*output) == 0)) {
+		_error(ctx, "IPC return empty reply for command %s",
+		       cmd);
+		rc = DMMP_ERR_IPC_ERROR;
 		goto out;
 	}
+	if (strncmp(*output, "fail\n", 5) == 0) {
+		if (strncmp(*output, "fail\npermission deny",
+			    strlen("fail\npermission deny")) == 0) {
+			_error(ctx, "Permission deny, need to be root");
+			rc = DMMP_ERR_PERMISSION_DENY;
+			goto out;
+		}
+		else if (strncmp(*output, "fail\nmap or partition in use",
+				strlen("fail\nmap or partition in use")) == 0) {
+			_error(ctx, "Specified mpath is in use");
+			rc = DMMP_ERR_MPATH_BUSY;
+			goto out;
+		}
+		else if (strncmp(*output, "fail\ndevice not found",
+				 strlen("fail\ndevice not found")) == 0) {
+			_error(ctx, "Specified mpath not found");
+			rc = DMMP_ERR_MPATH_NOT_FOUND;
+			goto out;
+		}
+		_error(ctx, "Got unexpected error for cmd '%s': '%s'",
+		       cmd, *output);
+		rc = DMMP_ERR_BUG;
+	}
 
 out:
 	if (rc != DMMP_OK) {
@@ -411,10 +425,6 @@ static int _ipc_connect(struct dmmp_context *ctx, int *fd)
 int dmmp_flush_mpath(struct dmmp_context *ctx, const char *mpath_name)
 {
 	int rc = DMMP_OK;
-	struct dmmp_mpath **dmmp_mps = NULL;
-	uint32_t dmmp_mp_count = 0;
-	uint32_t i = 0;
-	bool found = false;
 	int ipc_fd = -1;
 	char cmd[_IPC_MAX_CMD_LEN];
 	char *output = NULL;
@@ -433,29 +443,7 @@ int dmmp_flush_mpath(struct dmmp_context *ctx, const char *mpath_name)
 	_good(_process_cmd(ctx, ipc_fd, cmd, &output), rc, out);
 
 	/* _process_cmd() already make sure output is not NULL */
-
-	if (strncmp(output, "fail", strlen("fail")) == 0) {
-		/* Check whether specified mpath exits */
-		_good(dmmp_mpath_array_get(ctx, &dmmp_mps, &dmmp_mp_count),
-		      rc, out);
-
-		for (i = 0; i < dmmp_mp_count; ++i) {
-			if (strcmp(dmmp_mpath_name_get(dmmp_mps[i]),
-				   mpath_name) == 0) {
-				found = true;
-				break;
-			}
-		}
-
-		if (found == false) {
-			rc = DMMP_ERR_MPATH_NOT_FOUND;
-			_error(ctx, "Specified mpath %s not found", mpath_name);
-			goto out;
-		}
-
-		rc = DMMP_ERR_MPATH_BUSY;
-		_error(ctx, "Specified mpath is in use");
-	} else if (strncmp(output, "ok", strlen("ok")) != 0) {
+	if (strncmp(output, "ok", strlen("ok")) != 0) {
 		rc = DMMP_ERR_BUG;
 		_error(ctx, "Got unexpected output for cmd '%s': '%s'",
 		       cmd, output);
@@ -464,7 +452,6 @@ int dmmp_flush_mpath(struct dmmp_context *ctx, const char *mpath_name)
 out:
 	if (ipc_fd >= 0)
 		mpath_disconnect(ipc_fd);
-	dmmp_mpath_array_free(dmmp_mps, dmmp_mp_count);
 	free(output);
 	return rc;
 }
-- 
2.43.0

