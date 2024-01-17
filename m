Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030704683
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 01:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705454361; cv=none; b=rpkNfcNrHN6kcO2WUYMgKW6BvwbYsAqrBRh3VwS6OOb5dn7H6AwHIdrs4vWttSIjGNph4brTOITBkR6UNW/JzlypGawIneL3axwWsHP1mPKcBT2xTuqb7zysmovqlOs8Ogko9scZ4m/RITAQCQ/QwvlveUn1Ww5glmKssln1O74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705454361; c=relaxed/simple;
	bh=zN4AUf5vDWhXitl2JICvPY1jK9F3rqGZkLK9TbDGa+g=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-Originator:Content-Transfer-Encoding:Content-Type; b=KscEeytd9Eb+0DAbEqN7nVjlw+LtQXaJlkLHy57c4JMES4JnBIxBME7w6osPxsi/SRCcAnv3wwcC8rRhiikPVqnaeKh7Ra4PQ00L5Ix6FryG9Ls0A7wWX0Tn/jxil+IpQWKOG1uDW2iJYXsmprU83j/X/1QCVnvukgYMOhb94JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WLaW45sz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WLaW45sz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705454357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dIsWu9xziRzlBDCp8qqqfUxflxmETSpPIXLgNbqE7DI=;
	b=WLaW45szW53eADbgSejLNHL3XSiHUC4PaahSpO/TPIGx95+kOdgl6xC/wCmwrjZzlokJv2
	4l8O6J+hwWrou8CswMAeADxYudKVEU7bRAIHOLhAR/F3ECt82vNfOgfOaXSYVoIK4MDJaX
	sfpY8VZn4k4MtQ9CXth/CDuEB343TJ4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-tRbe0B2uMx-xLCvj4GN-NQ-1; Tue,
 16 Jan 2024 20:19:13 -0500
X-MC-Unique: tRbe0B2uMx-xLCvj4GN-NQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4869C2802E46;
	Wed, 17 Jan 2024 01:19:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 430FD1121306;
	Wed, 17 Jan 2024 01:19:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40H1JD5D018729
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 20:19:13 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40H1JDEa018728;
	Tue, 16 Jan 2024 20:19:13 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: device-mapper development <dm-devel@lists.linux.dev>
Cc: Martin Wilck <Martin.Wilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v2 2/2] multipathd: fix auto-resize configuration
Date: Tue, 16 Jan 2024 20:19:12 -0500
Message-ID: <20240117011912.18710-3-bmarzins@redhat.com>
In-Reply-To: <20240117011912.18710-1-bmarzins@redhat.com>
References: <20240117011912.18710-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The code acted like AUTO_RESIZE_UNDEFINED didn't exist, but since
conf->auto_resize was never set to AUTO_RESIZE_NEVER, the default was in
fact AUTO_RESIZE_UNDEFINED, which ended up getting treated like
AUTO_RESIZE_GROW_SHRINK. Remove AUTO_RESIZE_UNDEFINED and explicitly
default auto_resize tp AUTO_RESIZE_NEVER.

Fixes: 981b83ad1 ("multipathd: Add auto_resize config option")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c  | 1 +
 libmultipath/structs.h | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index b7dbc6f5..83fa7369 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -927,6 +927,7 @@ int _init_config (const char *file, struct config *conf)
 	conf->retrigger_tries = DEFAULT_RETRIGGER_TRIES;
 	conf->retrigger_delay = DEFAULT_RETRIGGER_DELAY;
 	conf->uev_wait_timeout = DEFAULT_UEV_WAIT_TIMEOUT;
+	conf->auto_resize = DEFAULT_AUTO_RESIZE;
 	conf->remove_retries = 0;
 	conf->ghost_delay = DEFAULT_GHOST_DELAY;
 	conf->all_tg_pt = DEFAULT_ALL_TG_PT;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index a1aac1b4..734905e2 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -180,7 +180,6 @@ enum queue_mode_states {
 };
 
 enum auto_resize_state {
-	AUTO_RESIZE_UNDEF = 0,
 	AUTO_RESIZE_NEVER,
 	AUTO_RESIZE_GROW_ONLY,
 	AUTO_RESIZE_GROW_SHRINK,
-- 
2.43.0

