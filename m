Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDD612B93
	for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 23:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729640039; cv=none; b=OeICHXYMtHk3UA29g7jyPpuXOEJVojQIdy8brOs8fB816cRPd5/UUCwntnLMxcwlOC30R5FehroxEcW95DPEW8AJ40C78/K/azAkYFY0+brm3vZIvhGs+C9740JT4oEAWvL4+CNs2UAIxP6o8+rUp5T9v5YK+jDrrma4Kzr0Naw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729640039; c=relaxed/simple;
	bh=OEPSzHhumT3P+IUtYoDLxJLLpGy3EtRxlv+rOgRRb6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AB8hQLI70DFeIufqEMjuHqlBcqLauJ5EfJNXlYjPsHFcgIbzP3jCtco5ZTG4NW4e06wa8n1kWRuQ1I4QZOCfB1Ak/m6lcG4XwPi8z8SJzUba352nt/UMoEOPtNjzVCv92SSn19q1BwL6uQQ9dRpDgDAG5tvDMhHMcI7Wnr8PYsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AYrVSNkh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AYrVSNkh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729640036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9t6vEsu3WyG70T55zypqLBtSK0J0L7O94sZVBB2YVks=;
	b=AYrVSNkh3AuDLW+2lVwErWTmPxrYvGdfa29LgNVx3ZjBTCEaP5YJDNWCTgH5E3QPWkvkig
	q1hI9uIunbGSsfHx6n+zPnRMWh7dxN92tlBqHUnB1BNlig5KcNRzIej0BdEpS+M6lOgMdm
	93twF90f4pWaU2jg41kmC7ewWQC0qMk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-NikhB4aVORiKbeK7lW71aw-1; Tue,
 22 Oct 2024 19:33:52 -0400
X-MC-Unique: NikhB4aVORiKbeK7lW71aw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4F4919560B8;
	Tue, 22 Oct 2024 23:33:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4962519560A2;
	Tue, 22 Oct 2024 23:33:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49MNXnsK247096
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 19:33:49 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49MNXnJb247095;
	Tue, 22 Oct 2024 19:33:49 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: [RFC PATCH] 11-dm-mpath.rules: Disable blkid runs when updating the device
Date: Tue, 22 Oct 2024 19:33:49 -0400
Message-ID: <20241022233349.247087-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

When multipath reloads a device or fails or restores a path, the udev
rules disable LVM scanning, but since .DM_NOSCAN isn't set, blkid is
still run on the device. When multipath devices that are set to
queue_if_no_path lose all their paths at close to the same time, udev
workers can hang trying to run blkid. The blkid results shouldn't
change when multipathd is adding, removing, failing or reinstating
paths, aside from avoiding hanging udev processes, we're skipping
unnecessary work.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/11-dm-mpath.rules.in | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 30647b99..6a76a348 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -80,12 +80,12 @@ ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{.DM_SUSPENDED}!="1", \
 # It's exactly mpath's job to provide *seamless* device access to any of the
 # paths that are available underneath.
 ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
-	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
+	ENV{DM_ACTIVATION}="0", ENV{.DM_NOSCAN}="1", ENV{MPATH_UNCHANGED}="1"
 
 # For path failed or reinstated events, unset DM_ACTIVATION.
 # This is similar to the DM_SUBSYSTEM_UDEV_FLAG0 case above.
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
-	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
+	ENV{DM_ACTIVATION}="0", ENV{.DM_NOSCAN}="1", ENV{MPATH_UNCHANGED}="1"
 
 LABEL="check_mpath_ready"
 
@@ -113,7 +113,7 @@ LABEL="mpath_is_ready"
 ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="scan_import"
 ENV{.DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="scan_import"
 
-ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
+ENV{DM_ACTIVATION}="1", ENV{.DM_NOSCAN}="0", ENV{MPATH_UNCHANGED}="0"
 
 # The code to check multipath state ends here. We need to set
 # properties and symlinks regardless whether the map is usable or
-- 
2.46.2

