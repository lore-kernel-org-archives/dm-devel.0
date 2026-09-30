Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6966042B301
	for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 19:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797283; cv=none; b=GHvJzAeN2yIZkXfAD6KwuphZiPvC+u7BRw9sxyXbkXIwdUwTkKtWqqFizUsJitSz0P7v/d2Hd3VfbsTakIBJq66YrKIH/5nVs/lmarCy/SAZY9VGl44c6jtVzKGY2pxRyTcPbXBCRlmUT/Z13aCX9R1xRQjgwMVp/V9dBBY/tUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797283; c=relaxed/simple;
	bh=5ZtchU7M/4vxIH9vNdJS4isp9Q3LDsVJjtujKzAmoNo=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=sTl+QUp7wK3EAxqZJ0NNtv8nD2TTi3LbzinnaQp5OvCdAdGTKkWYwI93XKmwshSID7J3bVDR0Qo10n6QeyQqhypAUoULE0HPhw6kko7aiqGE+Txm8Pzkkd3DqAstdGreiNJ4NyPhLRt3uXccHTdTZ0ynQT3elnB0+vh114preNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UBaLAiL7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UBaLAiL7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790797279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Zu4yxmR4VRphvXagO6qAP1Y9poApOL00kVuaOQSiNgI=;
	b=UBaLAiL7arWtjhDAkL5/gcvtaHGSpJuPMJSE3tufm/FqlX0WW/Hs6WLrIny2uX2hfP11sG
	sFK9DNU4oS55KkObNQfpViEyTnKLHfBaY+3NvK7pKtmDETfgVyftzmhd7kTJSddSN9wf4X
	0THUerzHdU+I+40YPs0M8mfDs0uMRlQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-vT3Cs1gdP66TrEnGl7LiwQ-1; Wed,
 30 Sep 2026 15:41:16 -0400
X-MC-Unique: vT3Cs1gdP66TrEnGl7LiwQ-1
X-Mimecast-MFC-AGG-ID: vT3Cs1gdP66TrEnGl7LiwQ_1790797275
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 650C7190A0B4;
	Wed, 30 Sep 2026 19:41:15 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1DFFF180056E;
	Wed, 30 Sep 2026 19:41:13 +0000 (UTC)
Date: Wed, 30 Sep 2026 21:41:11 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH 3/5] dm-writecache: fix a crash if we attempt to use non-dax
 device
Message-ID: <318ba5a1-4c4a-e37a-e391-5a8de65b92fc@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QZNIzs6jbIt5juV8A0MvLA6ajamc90iA49P1C28k-Xk_1790797275
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

If we specify a non-DAX device as a cache device in the 'P' mode,
dm-writecache crashes on NULL pointer dereference inside dax_synchronous.

Note that this is not a security bug because only root can trigger it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: a46624580376 ("dm writecache: reject asynchronous pmem devices")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5

---
 drivers/md/dm-writecache.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c
+++ linux-2.6/drivers/md/dm-writecache.c
@@ -2502,6 +2502,11 @@ invalid_optional:
 	}
 
 	if (WC_MODE_PMEM(wc)) {
+		if (!wc->ssd_dev->dax_dev) {
+			r = -EOPNOTSUPP;
+			ti->error = "Cache device is not a DAX device";
+			goto bad;
+		}
 		if (!dax_synchronous(wc->ssd_dev->dax_dev)) {
 			r = -EOPNOTSUPP;
 			ti->error = "Asynchronous persistent memory not supported as pmem cache";

