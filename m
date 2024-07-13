Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC6F19478
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850720; cv=none; b=u7hfr5ZYC/66Ah+Y2oCFmzlPJtM9OdRzHPtK2u0RbPvEMEyeKM6Qif7Q+tUyj/APZ8SIogZd83gPkNlBZUc0Px+0J8KpGaX21AHP4MC+AM1oKC+odPy3b/1AoLWW9orAa/a1z8eBs1s2EA5sf2JVb+LKeaCSb6gYEfknVPufCbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850720; c=relaxed/simple;
	bh=KRrZiGCaSUVaDkrcSCNHXMY05HLhvjWTHndE7OpmB34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UwMlWGKZa8+KIZM0RqyZ+fxBFAWzLKF4m+1yoBFMsxiahzJSbKJdOt8TlFqjcuZsGXjnxcejlHUPp9nktfPGCf/JqlId3luAkfVC7kTa3UVDtur0g0ld6dznQJIaoQgIr5OTKC/vSIUQNvIuf36dcjCmgYQ2liv5A3tcORXZ5hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VwxfbTjK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VwxfbTjK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QllqKhk9nE3UhLl1kNsKRnbT0TpQj8pJM4wZJYDnBNQ=;
	b=VwxfbTjKji7KEkSv4svMtxbjgMhJRBm5G8W/QgJ3YqEbaoZm5x8YEYdqZHVTQEcHmWQIKK
	JijOMu9bkmrpefnJ7hyN5BRlIywD3qTJk/jgV+WW2gY5EiElyrE3gFzTnQMx3NfGX/UiVT
	VviEKa1IgvX/KR85GUXz7mKAztBm/cw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-396--zdGa-rgNTi3XUXQzMgsNw-1; Sat,
 13 Jul 2024 02:05:13 -0400
X-MC-Unique: -zdGa-rgNTi3XUXQzMgsNw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2025119560AA;
	Sat, 13 Jul 2024 06:05:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB4531955F3B;
	Sat, 13 Jul 2024 06:05:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D65AYl2015566
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D65ApF2015565;
	Sat, 13 Jul 2024 02:05:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 18/22] multipathd: don't read conf->checkint twice in check_path
Date: Sat, 13 Jul 2024 02:05:02 -0400
Message-ID: <20240713060506.2015463-19-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

check_path() already has saved the value of conf->checkint in the local
variable checkint, so there's no reason to read it again.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e32af693..daf668eb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2510,9 +2510,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		 * upon state change, reset the checkint
 		 * to the shortest delay
 		 */
-		conf = get_multipath_config();
-		pp->checkint = conf->checkint;
-		put_multipath_config(conf);
+		pp->checkint = checkint;
 
 		if (newstate != PATH_UP && newstate != PATH_GHOST) {
 			/*
-- 
2.45.0

