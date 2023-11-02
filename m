Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E810722305
	for <dm-devel@lists.linux.dev>; Thu,  2 Nov 2023 22:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DDRONkuE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698963310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ZAliMUydK520JzF6o3wXCzSMwEO0o+8lW6N/5W4hxM=;
	b=DDRONkuElhfmo1JYefuECbyEQsTkxeY9+LTFsgbluQmM3UZWnJqnDYhHrVi4ZZ70pBnwdE
	4ZnyEe8X5lKuOwOlwiPFgRBkOaijWjo5dpObzTRNl89rfv9rN3pED+k3yI7K7BvQtTF4Rp
	JdpwkaFOjkialtoNL3gT2Q16l1hFnzA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-Yra5K17IMMiOUR-9tPGiHQ-1; Thu, 02 Nov 2023 18:15:08 -0400
X-MC-Unique: Yra5K17IMMiOUR-9tPGiHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2576C811E86;
	Thu,  2 Nov 2023 22:15:08 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EB151121308;
	Thu,  2 Nov 2023 22:15:08 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A2MF7gj105385
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 2 Nov 2023 18:15:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A2MF76h105384;
	Thu, 2 Nov 2023 18:15:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/7] libmutipath: Retain device size if sysfs_get_size fails.
Date: Thu,  2 Nov 2023 18:15:02 -0400
Message-ID: <20231102221507.105371-3-bmarzins@redhat.com>
In-Reply-To: <20231102221507.105371-1-bmarzins@redhat.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
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

When paths are allocated their size is initialized to 0. If they've
already set a size, and a future call to sysfs_get_size() fails during
the parsing, assume that the size hasn't changed, instead of setting it
to 0. All other failures in sysfs_get_size() already retain the existing
size.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/sysfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index c45296af..ad3d6612 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -175,7 +175,6 @@ sysfs_get_size (struct path *pp, unsigned long long * size)
 
 	if (r != 1) {
 		condlog(3, "%s: Cannot parse size attribute", pp->dev);
-		*size = 0;
 		return 1;
 	}
 
-- 
2.41.0

