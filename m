Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C7A168C16
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 23:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629780; cv=none; b=gryTBM5u6Oc3Q/RcmV8RquVsTR+UaQVChjnVwrKcGb5ZZeQMuLtwVb9Wm7faHQxAZslbARx5z6XLRRynlHmHUVF8/FX5s67vp7/bAhB0yKgElDlXvXilBDTuTlgZNDvjCr8/ZxTyaC411r5Fp92VGwzgicrP1bAkeVV82hMsfHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629780; c=relaxed/simple;
	bh=7duWNX32fCWSJNM596hM0nR+xpqOlDGGDnLIa6t7Bpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oSaY5EbTYIhXlST8IefNRUC+ZrTvDXzyxataxdl383zP8byY/Z73sD97eyPaq+0OUXWTW4Z7e9tZ8mjmwoesCate7VONzml4y0HHTv/YBQcpob5zL4IeUtxOksQ5WZETxMo6uoTcs6lL6N7KJJ3jLeVhN7M2MAZQy7CzlbbsOBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WIMn4bsT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WIMn4bsT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717629777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cdAMQwEx7VyxIlr07ST4CWOSnVfZpqxZm8xxrdMCK5U=;
	b=WIMn4bsTCm8s8ybh8MPVBW5nC2jRYnuU/iiOzVPZ4znUgI19jYRmWU5AJ9ECBy8aLs/kyO
	g9WapKrGuxRUMLumHgfclXbzEA4fbuwT6rAGYiAY0Pc9E+P36fXJHeo+ipzupoKzZ11BIM
	mSy1+UNGQ92J1B7lZw9xOcN8wfEvBN4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-QzAYft9DN6q-z_3CwlQEHQ-1; Wed,
 05 Jun 2024 19:22:56 -0400
X-MC-Unique: QzAYft9DN6q-z_3CwlQEHQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5F1E1C05122;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF9001C06710;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 455NMtRH623330
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Jun 2024 19:22:55 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 455NMtYL623329;
	Wed, 5 Jun 2024 19:22:55 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 6/7] multipathd: free alias if cli_add_map() is cancelled
Date: Wed,  5 Jun 2024 19:22:53 -0400
Message-ID: <20240605232254.623290-7-bmarzins@redhat.com>
In-Reply-To: <20240605232254.623290-1-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Use the cleanup attribute to make sure that alias is freed if
cli_add_map() is cancelled.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 3dc5e690..34e0147e 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -699,7 +699,8 @@ cli_add_map (void * v, struct strbuf *reply, void * data)
 	char * param = get_keyparam(v, KEY_MAP);
 	int major = -1, minor = -1;
 	char dev_path[FILE_NAME_SIZE];
-	char *refwwid, *alias = NULL;
+	char *refwwid;
+	char *alias __attribute__((cleanup(cleanup_charp))) = NULL;
 	int rc, count = 0;
 	struct config *conf;
 	int invalid = 0;
@@ -748,7 +749,6 @@ cli_add_map (void * v, struct strbuf *reply, void * data)
 		return 1;
 	}
 	rc = ev_add_map(dev_path, alias, vecs);
-	free(alias);
 	return rc;
 }
 
-- 
2.45.0

