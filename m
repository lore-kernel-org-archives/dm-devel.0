Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350E478F29
	for <dm-devel@lists.linux.dev>; Mon, 28 Apr 2025 21:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745876723; cv=none; b=gZwzIfSCKZ8zV04Yidvfb5fxfFOcf9QZGI3rhOv68fn4BRujTC8BLowrDdyW8+u2Baa5l8gI1fYrlKLnCiyJYMBlDq/iDfizsSAQrs7IeDVPDvF/C30IReslhDZ15E/nwGb/IDV78/ErpjL6KPs93AKrFPSIWDfMYUbvZcSjzec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745876723; c=relaxed/simple;
	bh=MYomZuZVHBcUbqKD8Od5nzxYWT6yyjPRcZ3qGXGktT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mODsbMDftJ5g5JUWQfs/gTDv4DdCYdHPYSekYWsJeVGVj8tt4QsmqC8M6lpJaEkrTYavcb+TC81/3vb/YtgzporDkNIbsb8wxvd4gz8E4qAIsVcirIQ24CsHxkRGQXEGvHwKSRqSxtsXOqzAcddqn1anCOyWNhHm77jh+zKbIJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HPIVklCZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HPIVklCZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745876720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xc7RtSZxTilhkrBlJEai7E6wIt96DRbVHohRZwQXX2w=;
	b=HPIVklCZFtxxY42MI9Tfgq/mZF8Pch/AJwgAdOAn5oU644lEqbx4fT0Qtk6krCbTp1exjG
	my5mlaAq77rDLJRAB5uMAJxt8+22KBLP1TTu+XHM3baG+pBt2/04bfsCXDvYWJdF8Hjvw4
	LBvxQLlr751vhDdvjIxFot3jPL+QFss=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-412-FeOTgBnrMVKixTlqSONsnw-1; Mon,
 28 Apr 2025 17:45:18 -0400
X-MC-Unique: FeOTgBnrMVKixTlqSONsnw-1
X-Mimecast-MFC-AGG-ID: FeOTgBnrMVKixTlqSONsnw_1745876717
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB9AE1800876;
	Mon, 28 Apr 2025 21:45:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA4611800361;
	Mon, 28 Apr 2025 21:45:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53SLjFDc1905346
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Apr 2025 17:45:15 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53SLjFBF1905345;
	Mon, 28 Apr 2025 17:45:15 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/2] multipathd: disable queueing on invalid multipath devices
Date: Mon, 28 Apr 2025 17:45:14 -0400
Message-ID: <20250428214514.1905327-3-bmarzins@redhat.com>
In-Reply-To: <20250428214514.1905327-1-bmarzins@redhat.com>
References: <20250428214514.1905327-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WO4_e-Bkf6MccNIUiWXBc7FtcXbE5hUzRNgQAqExBt4_1745876717
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If the multipath configuration has changed and a multipath device is no
longer valid after a reconfigure, disable queueing on it before
attempting to delete it. This makes it more likely to be deleted and if
the device isn't valid, then it there is no defined no_path_retry value
for it.

Fixes: https://github.com/opensvc/multipath-tools/issues/113
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index bdd97178..83a0b055 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -820,6 +820,10 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 			 * remove all current maps not allowed by the
 			 * current configuration
 			 */
+			ompp->retry_tick = 0;
+			ompp->no_path_retry = NO_PATH_RETRY_FAIL;
+			ompp->disable_queueing = 1;
+			dm_queue_if_no_path(ompp, 0);
 			if (dm_flush_map(ompp->alias) != DM_FLUSH_OK) {
 				condlog(0, "%s: unable to flush devmap",
 					ompp->alias);
-- 
2.48.1

