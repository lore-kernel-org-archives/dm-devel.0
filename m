Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5947B1D52A
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Do/N93hy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmSzjumFydib4cisLjjAa7aFI+P40nxKspcZwBTHxw4=;
	b=Do/N93hyPJTyHSxyQHMItr4jg5Zy/THms7OSlJyqb6EKw/feQ5HasY7bJjnMtzuXgdTOAC
	wFDxAH3rReRqJOd6aU6zLA2fTKmo0mAjFZz1EbU3RlgF0z8b7JYEVIXWbQkIOU80hvaTkA
	SPYkBO65PzzzAIvqO0CbWB3yaf/sVJ0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-hL000VXFPfGE06-xfTf-vg-1; Wed, 03 Jan 2024 12:56:47 -0500
X-MC-Unique: hL000VXFPfGE06-xfTf-vg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A78EE185A781;
	Wed,  3 Jan 2024 17:56:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A21EE2166B31;
	Wed,  3 Jan 2024 17:56:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HukN4018535
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:46 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403HukeQ018534;
	Wed, 3 Jan 2024 12:56:46 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 17/18] multipath: if delegation times out mark as not delegated
Date: Wed,  3 Jan 2024 12:56:42 -0500
Message-ID: <20240103175643.18438-18-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
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

If either mpath_process_cmd fails with ETIMEDOUT or the reply is
"fail\ntimeout\n", failback to multipath local commands.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/multipath/main.c b/multipath/main.c
index 83dca8c0..8cdc2f7d 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -799,6 +799,8 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
 
 	if (mpath_process_cmd(fd, command, &reply, conf->uxsock_timeout)
 	    == -1) {
+		if (errno == ETIMEDOUT)
+			r = NOT_DELEGATED;
 		condlog(1, "error in multipath command %s: %s",
 			command, strerror(errno));
 		goto out;
@@ -807,6 +809,10 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
 	if (reply != NULL && *reply != '\0') {
 		if (strncmp(reply, "fail\n", 5))
 			r = DELEGATE_OK;
+		else if (strcmp(reply, "fail\ntimeout\n") == 0) {
+			r = NOT_DELEGATED;
+			goto out;
+		}
 		if (r != DELEGATE_RETRY && strcmp(reply, "ok\n")) {
 			/* If there is additional failure information, skip the
 			 * initial 'fail' */
-- 
2.43.0

