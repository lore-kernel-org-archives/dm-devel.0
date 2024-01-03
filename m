Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041FD1CFBD
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i9dm43wG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GAUx19JmRE/uMkubjUxEoWlwKTGdaXfBNQiV6IstKvc=;
	b=i9dm43wGDk7LL3VVt+PSYykuzGX7hLx3Rz/QCjXHCmniu95hBg6jwSNPCk4JZOPa/3Ex+V
	9Ckdf28AMSkVcCnY+EH6OlrrYBDWkBByc6YAAUy/d166zSP/QRvB/EgDrmIT/UzBg24N3p
	9/i0x46tPbRS6RJi8mGIIsPY0yKJYyM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-367-3w3AMG_nMC29Cdectykyrg-1; Wed,
 03 Jan 2024 12:56:45 -0500
X-MC-Unique: 3w3AMG_nMC29Cdectykyrg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80B2E2823F62;
	Wed,  3 Jan 2024 17:56:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B0251C060AF;
	Wed,  3 Jan 2024 17:56:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403HujuI018507
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403Huj1h018506;
	Wed, 3 Jan 2024 12:56:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 10/18] libmultipath: print error when find_mp_by_str() fails.
Date: Wed,  3 Jan 2024 12:56:35 -0500
Message-ID: <20240103175643.18438-11-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
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

None of the callers of find_mp_by_str() print any message if they fail
because the map name is invalid. Print one in find_mp_by_str() to save
the effort of adding it to all the callers.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 1b305fd1..74e31a13 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -480,11 +480,16 @@ struct multipath *
 find_mp_by_str (const struct _vector *mpvec, const char * str)
 {
 	int minor;
+	struct multipath *mpp;
 
 	if (sscanf(str, "dm-%d", &minor) == 1)
-		return find_mp_by_minor(mpvec, minor);
+		mpp = find_mp_by_minor(mpvec, minor);
 	else
-		return find_mp_by_alias(mpvec, str);
+		mpp = find_mp_by_alias(mpvec, str);
+
+	if (!mpp)
+		condlog(2, "%s: invalid map name.", str);
+	return mpp;
 }
 
 struct path *
-- 
2.43.0

