Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D413C1D52B
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e0a06xOc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FYyoABWT3x0JD7trEIFiW7Wltp0dabbBEnKyvhAEAog=;
	b=e0a06xOcE6zDY8vjZLNDS0opgvLZXUkWDuElZhYX/TdkD4Sp8nKW1wFkBUhC1DrxzFFB4V
	rSLVMG58HQrvy1LYUXkJY4vrnoRr0ltICG4/svYtRwifAlLq17zMIWqfXjpu4zZOj+FfVt
	ctVsIngwhXOuVsaOxBYGkGfr+IWQ2Ro=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-FJncusPXM8KbpjoGLdsCxQ-1; Wed, 03 Jan 2024 12:56:44 -0500
X-MC-Unique: FJncusPXM8KbpjoGLdsCxQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FBFC859B83;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 29E382026D66;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403Huhfs018473
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403Huhih018472;
	Wed, 3 Jan 2024 12:56:43 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 02/18] multipathd: make flush_map() delete maps like the multipath command
Date: Wed,  3 Jan 2024 12:56:27 -0500
Message-ID: <20240103175643.18438-3-bmarzins@redhat.com>
In-Reply-To: <20240103175643.18438-1-bmarzins@redhat.com>
References: <20240103175643.18438-1-bmarzins@redhat.com>
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

When the multipath command tries to delete a multipath device, it first
disables queueing and then suspends the device to force the IOs to get
flushed. Then it attempts to delete the device and any kpartx
partitions.  multipathd, on the other hand, simply tries to delete the
device and kpartx partitions, without disabling queueing or suspending.
If there are no paths but there is outstanding IO, multipathd will hang
trying to delete the last kpartx device. This is because it must be the
last opener of the multipath device (multipath won't try to delete the
device if it has any openers besides the kpartx devices) and the kernel
will not allow the last opener of a block device to close until all the
outstanding IO is flushed.  This hang can be avoided if multipathd calls
dm_suspend_and_flush_map() like the multipath command does, instead of
dm_flush_map().

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4a7e0ba1..6b66a5ee 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -788,7 +788,7 @@ sync_maps_state(vector mpvec)
 int
 flush_map(struct multipath * mpp, struct vectors * vecs)
 {
-	int r = dm_flush_map(mpp->alias);
+	int r = dm_suspend_and_flush_map(mpp->alias, 0);
 	if (r) {
 		condlog(0, "%s: can't flush", mpp->alias);
 		return r;
-- 
2.43.0

