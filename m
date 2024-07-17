Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44571836C4
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239878; cv=none; b=JVPb5yMvkzIzX88cnWg9q6n2sMyhm/XdBt4hqwPgO9WalIDui/rtcNw2EbSAP760V1bObGFXdM65fSg2OAPWaZvAU1gnAE/HVEuAX8SWNlAb2Mt1/VfcvD5F2Sl26xZmOLI+AEHxuEdU95THvk+nP4jPr05SQCHFQIyaXo3kj2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239878; c=relaxed/simple;
	bh=dz+fdtdNFECphCMYVy0NFwyKj631zd9ecp4rTO/Fyhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oL9S5h+VzhvU55rnsU8IQ53zAshszaqjqEstxBnQWruIjc90LWdJzzX6v5lX+Plfqcn7hIvN5znVMwxqKlu6Gy+FZLMIZ+6AciRwS3RzCXxwI/RGfLxTrzGYbdMO+B1lDylx9FBjmmuKgZSCTgao5h7Gqhd2P8XFm4FTY+Sy8w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MN7dhu48; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MN7dhu48"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DTVmmShzvdSOrCvehQ0TGYrWXMGz8j38e+bRFRa3Zjk=;
	b=MN7dhu48IecwcxFRjyTxr87FDMFB0TyB5VOaLR61us4vuCVwfoCSHEvS70zAn5K6iSlg0B
	6D4eKrJSKEcJptt43+uuzWgbUuM3L3HvnfkbIiuPDnv0gFl6mBNwrkPPfvpQt/noApWzNd
	wT6SU6GXkYRHU0QwkLK30EHilm5ejAQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-dUQAttbmNPyWTSuRJgh1lA-1; Wed,
 17 Jul 2024 14:11:11 -0400
X-MC-Unique: dUQAttbmNPyWTSuRJgh1lA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B00531955D44;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 460781955E80;
	Wed, 17 Jul 2024 18:11:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB9vU2173604
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB9VQ2173603;
	Wed, 17 Jul 2024 14:11:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 12/20] multipathd: resync map after setup_map in resize_map
Date: Wed, 17 Jul 2024 14:10:58 -0400
Message-ID: <20240717181106.2173527-13-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

In resize_map() it was possible to exit after calling setup_map()
without resyncing the mpp state with the kernel. This meant that the mpp
state in multipathd might not match with the kernel state at all.

Once setup_map() has been called, setup_multipath() and sync_map_state()
are now always called, to make sure the mpp matches the kernel state.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index aa3c7eb6..6d1a5382 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1534,6 +1534,7 @@ needs_ro_update(struct multipath *mpp, int ro)
 int resize_map(struct multipath *mpp, unsigned long long size,
 	       struct vectors * vecs)
 {
+	int ret = 0;
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
 	unsigned long long orig_size = mpp->size;
 
@@ -1543,7 +1544,8 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 		condlog(0, "%s: failed to setup map for resize : %s",
 			mpp->alias, strerror(errno));
 		mpp->size = orig_size;
-		return 1;
+		ret = 1;
+		goto out;
 	}
 	mpp->action = ACT_RESIZE;
 	mpp->force_udev_reload = 1;
@@ -1551,13 +1553,14 @@ int resize_map(struct multipath *mpp, unsigned long long size,
 		condlog(0, "%s: failed to resize map : %s", mpp->alias,
 			strerror(errno));
 		mpp->size = orig_size;
-		return 1;
+		ret = 1;
 	}
+out:
 	if (setup_multipath(vecs, mpp) != 0)
 		return 2;
 	sync_map_state(mpp);
 
-	return 0;
+	return ret;
 }
 
 static int
-- 
2.45.0

