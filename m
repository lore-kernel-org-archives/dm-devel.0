Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E415F21CC41
	for <dm-devel@lists.linux.dev>; Mon, 31 Mar 2025 23:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743463060; cv=none; b=EpM5sNRRZtfxm/JkN/4Oc35yq/CRnWxGM5rKQX2zmrrJxtu1P+aymP9Z7p0bRniu/UR+SeKgceKnILy0TloPSGTK5z1e+vLHIkKmJlrPZrE3Z0o8SfDnLP0cjea/d5Q+Or4Ed7v4wCAVTGCwgP1e9S2h7vX2OWNgyRap+NPLNQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743463060; c=relaxed/simple;
	bh=eztvyTZ2rWuQHnf9kqwSDRdj0zcfJQZRMOBbLoBIZBw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=qHDBOhQLQe6mv/BZKxGYihGOiAaQ0iV5K+hzaob5y0FRBFiu1yxc5vZF5iTpc6o7Tu//78h0uDaeDHusvQMtlHnhhiyqKtKKI+Ht8G/ZPVDbNcqMru7o4UYa6WHfSyMkzdhdNxW0Ab4TSiivz9Zr/ofDgsOoFg79M/9KTGxTcj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N61nuuQj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N61nuuQj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743463057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YcrcpkSyDD6/AcVjAjHQ0S2i4xSAQcbZ7OMSn5yxsrM=;
	b=N61nuuQja+qqeCDotecpr1K5zgutnl2CRbOjBrZkBLwMhFYXt5JIoUHcWjMTds9Hk3p7lV
	pmXE+2fwEyuVOEA6j4u97+X85pFSMCsy1xfzcxx24MSqV2on1APido+3k9YdjKrUy/yv+T
	K6tvXf9lCiOKk1UCxDCdiZjp9yY/Gls=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-o6d2ba3NMOO1dvdKHIYvmw-1; Mon,
 31 Mar 2025 19:17:34 -0400
X-MC-Unique: o6d2ba3NMOO1dvdKHIYvmw-1
X-Mimecast-MFC-AGG-ID: o6d2ba3NMOO1dvdKHIYvmw_1743463053
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 008481956053;
	Mon, 31 Mar 2025 23:17:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A24403001D0E;
	Mon, 31 Mar 2025 23:17:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52VNHVUU2857667
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 31 Mar 2025 19:17:31 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52VNHU322857666;
	Mon, 31 Mar 2025 19:17:30 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 0/3] fix issue of multipathd not tracking device
Date: Mon, 31 Mar 2025 19:17:27 -0400
Message-ID: <20250331231730.2857655-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MYLHYGPvlRSRUAQxqpTvHXBJYFyMpE_xJ2TigNKo4JE_1743463053
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

I ran into an issue where multipathd wasn't tracking a multipath
device that was created by the multipath command. It turns out that if
multipathd fully initialized a path device, and that device later
goes offline and then a multipath device that could use that path is
created by multipath, multipathd will attempt to reload the device
to use the offline path, which will fail. This will cause it to not
track the multipath device at all.

The first patch fixes this. The second patch allows mutipathd to track
these offline paths that should belong to a device, and add them to
device once they come back online. The third patch is just a cleanup.

changes from v2
- 0002: Switch from tracking this state with pp->initialized to a new
        variable, as suggested by Martin Wilck. To make is so that
        multipathd can still show paths in this state without adding
        a new wildcard for it, add [offline] as a possible output for
        the %m (multipath device) path wildcard, for paths that
        couldn't be added to a multipath device because they are
        offline. Also constify a function parameter and add an
        explanitory comment as suggested by Martin.

Benjamin Marzinski (3):
  multipathd: monitor new multipath dev even if we can't update it
  multipathd: re-add paths skipped because they were offline
  multipathd: don't update paths in INIT_MISSING_UDEV

 libmultipath/print.c       |  5 +++-
 libmultipath/structs.h     |  1 +
 libmultipath/structs_vec.c |  5 ++++
 multipathd/main.c          | 60 ++++++++++++++++++++++++++++++++++++--
 multipathd/multipathd.8.in |  5 ++--
 5 files changed, 70 insertions(+), 6 deletions(-)

-- 
2.48.1

