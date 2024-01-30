Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3FF78B6C
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 18:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706640348; cv=none; b=AUcOgIaTqlPFx4atwNLRY9Z7Y36W7zPveNmYEsm/m/ontyPLBBvMxpoOsuAVteqi242j2JnO3FQtuz+c/Du2vYRngu0P5aisPNRzh5PvHg+ehYEOVmYyHieGKMdEjORKeMZTA+A8XgFdGmFBLnUPCKnBf7Yb+7wMtVMckO7yuhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706640348; c=relaxed/simple;
	bh=6k1fDLN1tmHibR1hX9wCHfHwh6Izhw7B4LaQ7yf8nRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=muYQf5XFNkINltr7xpQyxsisZlwfJb7BJBkfIO6S8/XkbNETFdY4XD4j6Jmc/E1o4ZM8iTdglsDjdi41G2WYm5x7C/8HsTsEGuSOB/jLbk2qAJFrDxS/Qz6cyUbO5qhtDx/Jd8guQL+zcwm//JR+hybDxMAmqSocXzNdMgdXma4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f8DBrwsm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f8DBrwsm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706640345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pei0rtQZyoo2mLUciN167JKb1MqRw42OiAeXvL7ZQ5k=;
	b=f8DBrwsmaALrTwZ0HmN0j8YlGhVzUhhqAZxZVJ3GK4wXvJ81Vk3Dyf4hlrFeFeH48HVaid
	9b9OmzzI5w4mU9F1fFq5irxiCSP8I3nhuq6/uXEPy/R9eOB6TE3eQVnfWo1Ox+v6r5nYlL
	g/EAyxlMJLbSY9rA4Qkh2CtOHmRP7xY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-WDkIzKD4OqC70zJLQWHaFQ-1; Tue, 30 Jan 2024 13:45:39 -0500
X-MC-Unique: WDkIzKD4OqC70zJLQWHaFQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9880484AC60;
	Tue, 30 Jan 2024 18:45:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92A6F492BE2;
	Tue, 30 Jan 2024 18:45:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40UIjdef256956
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 30 Jan 2024 13:45:39 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40UIjd6R256955;
	Tue, 30 Jan 2024 13:45:39 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/2] libmultipath: fix displaying auto_resize config setting
Date: Tue, 30 Jan 2024 13:45:37 -0500
Message-ID: <20240130184538.256941-2-bmarzins@redhat.com>
In-Reply-To: <20240130184538.256941-1-bmarzins@redhat.com>
References: <20240130184538.256941-1-bmarzins@redhat.com>
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

When 56476ebd3 ("multipathd: fix auto-resize configuration") removed
AUTO_RESIZE_UNDEFINED, it didn't update print_auto_resize() to print
a value for when it was set to 0 (which is now AUTO_RESIZE_NEVER).

Fixes: 56476ebd3 ("multipathd: fix auto-resize configuration")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 0a160e92..5af036b7 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1691,8 +1691,6 @@ def_auto_resize_handler(struct config *conf, vector strvec, const char *file,
 int
 print_auto_resize(struct strbuf *buff, long v)
 {
-	if (!v)
-		return 0;
 	return append_strbuf_quoted(buff,
 			v == AUTO_RESIZE_GROW_ONLY ? "grow_only" :
 			v == AUTO_RESIZE_GROW_SHRINK ? "grow_shrink" :
-- 
2.43.0

