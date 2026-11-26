Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795670684;
	b=aRgSlXitXmNMKwuagHnD9kNDk1oFgINqaATY37uEwvoh0oh4V2dY4YVjXr+g+ypRpnm2
	 hV6F7uqA4pPN3xAaiKi3j/+eM2/wr4Lqc3PQZXApnRqVVgQMt5otu+9YnN30yGochOcUh
	 hRFcnXtmgAp+HSZCLVYY8pxZA8+6E3TJ+apuoiaNCUsltSLwf4bI8B3UL+ckPcRAhUZJ/
	 BB0FMY13RRSauy/3ZgRmtAbIAy08rf3EZpcUtDG3p0rS8gZlss/F47MItLKaaE9uAI5/1
	 Zgf9eXZsMZZsE8USIHH9oc7WEgDN9idYt1qHpnr4bq43uU28U3/1i/QSO3COIQLNInw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795670684;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:X-Scanned-By:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Transfer-Encoding:content-type;
	bh=tEvkJhsziMpwi5bugaOt2Cx0gm1M2ADW27CWQRumcYM=;
	b=Fk5WFFGoR1E61HoqS2s3W9lpVvfQXJIRpO90RJpc60pdevfcmXzRnC/MKdW0Rlcs5236
	 4ZrkiT5UVDiZY9wKsbObiLTv07ahXb5CZjGMutrl6LcZk4FFdwEVJo1ExNnF3Ldyc1jlA
	 XkoNnFRcF70FtTCsIYwXf0SUHCXI5/CqKI5JPWt95DTLrTeOgmtrPky9DA0sS9OBCRwV4
	 KFjxodjT/a9MSyYAzpoKdxOz6w2rvDkeJCJrLPlyd7OQBiDN3H6brtTbnXnWhCVHo4UzV
	 bvGIZiBQtbuQdSqKysgUEBZ7dcuw1yle5tgSb4swQmQs4iFcrs+hekw411abn/HzMzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FXg3Shsi;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B7C606A31C
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 05:24:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55B7C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=FXg3Shsi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795670682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tEvkJhsziMpwi5bugaOt2Cx0gm1M2ADW27CWQRumcYM=;
	b=FXg3ShsigcNHuKw9HdWaSWz6SXFSdnuRY9vIOeQndu4gkG2CADUzfP1VIaJ27F9UvfEpZ8
	kf/V0KdKhalaR6bpzmJzD4grroefgD94rA/PQT2VkO9P616kSFVrcvDtDqhsYk5oqgbclH
	BL2KxohRjQ664PazdvwTK3fyBfpJdHg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125-vt6bgcQ0OYKygbiUfO62gw-1; Thu,
 26 Nov 2026 05:24:37 +0000
X-MC-Unique: vt6bgcQ0OYKygbiUfO62gw-1
X-Mimecast-MFC-AGG-ID: vt6bgcQ0OYKygbiUfO62gw_1795670676
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E47A1956054;
	Thu, 26 Nov 2026 05:24:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36AB0195B3C5;
	Thu, 26 Nov 2026 05:24:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AQ5OYDp725775
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 00:24:34 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AQ5OYpu725774;
	Thu, 26 Nov 2026 00:24:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/4] multipath: add the ability to wait on events
Date: Thu, 26 Nov 2026 00:24:30 -0500
Message-ID: <20261126052434.725762-1-bmarzins@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NX-bknF8PREBnetgo-qIMlBzcc2csGwq2jQhEpO2aXM_1795670676
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Multipathd doesn't react immediately to multiple things. Reconfiguration
doesn't happen immediately. Devices can be added and removed from the
system, and multipathd doesn't react until it gets a uevent. Sometimes
users need to wait for multipathd to finish handling these events before
doing further work. For instance a user script that reconfigures
multipath, and then verifies the new configuration can fail if the
reconfigure doesn't happen fast enough. User scripts might also need to
wait till a device is completely removed from multipath handling before
they can continue, or wait for a multipath device to be fully added
through udev, etc.

This patchset doesn't add all of these wait commands. It just adds the
architecture for doing them and adds the "reconfigure wait" and
"reconfigure all wait" commands, to schedule and then wait for a
reconfigure. Tracking uevent removes and additions (and first change
events for multipath devices) so these can be waited on is more
complicated and I haven't finished with them yet. But I wanted to make
sure that we agree on the overall waiting architecture.

Benjamin Marzinski (4):
  multipathd: make the wakeup and drain idle_fd code generic
  multipathd: add infrastructure for uxlsnr waiting on events
  multipathd: make cli_handlers take a wait_node
  multipathd: add commands to wait for reconfigures to complete

 multipathd/callbacks.c     |   3 +
 multipathd/cli.c           |   1 +
 multipathd/cli.h           |   7 +-
 multipathd/cli_handlers.c  | 246 ++++++++++++++++++++-----------------
 multipathd/main.c          |  22 +++-
 multipathd/main.h          |   3 +-
 multipathd/multipathd.8.in |  19 ++-
 multipathd/uxlsnr.c        | 140 ++++++++++++++++++---
 multipathd/uxlsnr.h        |   4 +
 9 files changed, 312 insertions(+), 133 deletions(-)

-- 
2.56.0

