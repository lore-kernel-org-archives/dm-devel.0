Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA79D20C02E
	for <dm-devel@lists.linux.dev>; Mon, 28 Apr 2025 21:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745876724; cv=none; b=gaNPdKTdYBcFoYHN93KA0GX5qcx009V9XXnvYOzGf10Dh2s5BlVCKWPdZ8JoE6xsS9JBeDNPpdCRGfj9yZuk5p/lJ4IC8Qbsy3M5fMOKAMYbV1jBe9K2ohA9hxddNPCjxHreKihjJaZWEfG2g4mLhmAGPReC4tMG5w0cTHuadpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745876724; c=relaxed/simple;
	bh=QmK0aMHkxsKtr/vArgGWkzZPuXKUMnNlpRgb5qCDo4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=dDGMMsR28rmPBQ4WQ4mS9pCaVkhKTM83YoTXlxWty7gV6VtGDpdBMRxEREJKrGLBagzRvPokF28YMQWk81dBj0YwDkm8ZYz1p+7vgog5vmqn+B13zqeVxu/vp9v9WjsXa6INnCYZ7B8gl0ZlpV9QNTv4bTtKKSUK05js25ygv2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OXGMnc/i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OXGMnc/i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745876721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XxMh8uoJlFFx0o4VBNf6a7L9PEew1j74ZLbxtjmKpcE=;
	b=OXGMnc/i/ngLyj2eK8N/Gtkr3KQqQLCqG5uv4ejQ1oFJ5qtRhy8szPNnZ1BKwKcehpax6Q
	SO0RNi3wv/2W6IKBxlT8RBeeRwlO/jAs0C6XjWLBiOqgYTfSll8VbOqx0ZA49W3/9SfdRW
	QHCWF5n1wMb8/kvJwAa3HeaPOtN9KnU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-a3Axe6mGOnmET8EtLtFmMg-1; Mon,
 28 Apr 2025 17:45:18 -0400
X-MC-Unique: a3Axe6mGOnmET8EtLtFmMg-1
X-Mimecast-MFC-AGG-ID: a3Axe6mGOnmET8EtLtFmMg_1745876717
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B7AF71956088;
	Mon, 28 Apr 2025 21:45:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65B47195608D;
	Mon, 28 Apr 2025 21:45:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53SLjFl31905338
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Apr 2025 17:45:15 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53SLjEwH1905337;
	Mon, 28 Apr 2025 17:45:14 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/2] Handle blacklisted maps on reconfigure
Date: Mon, 28 Apr 2025 17:45:12 -0400
Message-ID: <20250428214514.1905327-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B8vKhptVpZByYPXyDNS6QArEFO91GoexHZU1cR51GVE_1745876717
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patchset is meant to deal with the issue from:
https://github.com/opensvc/multipath-tools/issues/113

If a multipath device that is in-use becomes blacklisted on a multipathd
reconfigure, its paths weren't always getting removed and the device
device could get stuck with queueing enabled, even if there were no
usable paths. This patchset deals with this by marking blacklisted paths
with INIT_REMOVED, making sure they are linked to the multipath device,
and disabling queueing on the invalid multipath device.


Benjamin Marzinski (2):
  libmutipath: handle blacklisted paths on map_discovery
  multipathd: disable queueing on invalid multipath devices

 libmultipath/structs_vec.c | 15 +++++++++++----
 multipathd/main.c          | 16 ++++++++++++++++
 2 files changed, 27 insertions(+), 4 deletions(-)

-- 
2.48.1

