Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4CE173333
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 23:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629781; cv=none; b=Wd/8yvoYzD+Qi9Pq5dsHo1QwtVPnlA+hDrA+36bellh4Q3vomtaOxXTqoTteblPodfteE1cn5ZzBXhbTgLvPoU9/xfyYfQsXhd9OXFmQk1oRdzIAU1+heuWVSFwg+OoNXcDvnHqCIMGjRh/t8o/QOlJ3syB0gcnI/KTNkZwxCMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629781; c=relaxed/simple;
	bh=pd7iuzPvz2V8sZw2LbXgeSpvwWUoZ2Dt68pkFatdvCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSuElepx259lH3OM4rNueBgqkIiyk/eOTq8DIvIRV7+LTComXeVNLZxGJuzHqEvuypXaUNYO1TrpX5nlMTERPBOEoQXjdXEh4HKXkvh5R5SSpk7eKnhsoGAg2Q+vKtt6xPz3XfTQZKabelsTDM9D9A19ZAQasFsGlVxirFxsZds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iHVMWJry; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iHVMWJry"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717629779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GOe1KfREwHWmwmSgyn/AjcS7Sesmemg2Wi/kTmOYPNk=;
	b=iHVMWJryCw9riaYtovXUmWc+nOw5CzwCqUrm/ULWEcwh+1ayHGsvxMU1oQB0AZYpAZpZ3f
	vuikyJEeJssuEoipG59x9Xr1m/ITqqW6yIdZ4B8t1Rbe7cYiAtLu7CoTj4u1JF33rU7T6/
	ckHR4iYgWh0TsEA99Lr3cAWmOy4oKfM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-lvZRUk-lNoWtVkLkjKCCCw-1; Wed,
 05 Jun 2024 19:22:55 -0400
X-MC-Unique: lvZRUk-lNoWtVkLkjKCCCw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 715FD3806700;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A3F420180E1;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 455NMtUX623318
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Jun 2024 19:22:55 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 455NMtP3623317;
	Wed, 5 Jun 2024 19:22:55 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 3/7] multipathd: refresh multipath before calling set_no_path_retry()
Date: Wed,  5 Jun 2024 19:22:50 -0400
Message-ID: <20240605232254.623290-4-bmarzins@redhat.com>
In-Reply-To: <20240605232254.623290-1-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Make sure that all callers of set_no_path_retry() update the
multipath->features string from the kernel before calling it, so that
they have the current queueing state to check.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 117570e1..3dc5e690 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -934,6 +934,8 @@ cli_restore_queueing(void *v, struct strbuf *reply, void *data)
 		pthread_cleanup_push(put_multipath_config, conf);
 		select_no_path_retry(conf, mpp);
 		pthread_cleanup_pop(1);
+		if (refresh_multipath(vecs, mpp))
+			return -ENODEV;
 		set_no_path_retry(mpp);
 	} else
 		condlog(2, "%s: queueing not disabled. Nothing to do", mapname);
@@ -956,6 +958,10 @@ cli_restore_all_queueing(void *v, struct strbuf *reply, void *data)
 			pthread_cleanup_push(put_multipath_config, conf);
 			select_no_path_retry(conf, mpp);
 			pthread_cleanup_pop(1);
+			if (refresh_multipath(vecs, mpp)) {
+				i--;
+				continue;
+			}
 			set_no_path_retry(mpp);
 		} else
 			condlog(2, "%s: queueing not disabled. Nothing to do",
@@ -983,6 +989,8 @@ cli_disable_queueing(void *v, struct strbuf *reply, void *data)
 	mpp->retry_tick = 0;
 	mpp->no_path_retry = NO_PATH_RETRY_FAIL;
 	mpp->disable_queueing = 1;
+	if (refresh_multipath(vecs, mpp))
+		return -ENODEV;
 	set_no_path_retry(mpp);
 	return 0;
 }
@@ -1001,6 +1009,10 @@ cli_disable_all_queueing(void *v, struct strbuf *reply, void *data)
 		mpp->retry_tick = 0;
 		mpp->no_path_retry = NO_PATH_RETRY_FAIL;
 		mpp->disable_queueing = 1;
+		if (refresh_multipath(vecs, mpp)) {
+			i--;
+			continue;
+		}
 		set_no_path_retry(mpp);
 	}
 	return 0;
-- 
2.45.0

