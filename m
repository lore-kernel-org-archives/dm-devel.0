Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74F1168C07
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 23:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629781; cv=none; b=JY9MHdi+kff3pwQidQfEg2LFpbRZ2DOiY6s6G56JV1M+H61eh/i3eWSq6tSIu4aZ/Hs7WjGsUiyVd+EgDk3rgvWSrPXLQOL0idOAWN+KEcacbU1iKDpX/3RN+tiSvb5ZfrDahNxW19uo98gZCdFnfTF4CBoEoewHoTp5MpCAzTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629781; c=relaxed/simple;
	bh=vAv0emABfX8eRhJ+LugbzbQQ6RxBXfRV4X04uBA1pH8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EnRlOO46EvVlxCoqpcGN1+f8e1qpM5dWtyHlfiPzfeyGieIm8qt7uxrOvBccIXsQ0c/LN9WTip0PlVSx7gNWGtJyAXxKRnGFdII5Qego+W5HDtGQ+A77FLj22GH5txJQ8oAt4qXqjPvfpoYkDpepJN1ff9tSdisKdEIbI8lkUC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VsTJ1o/4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VsTJ1o/4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717629778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Cghoz3YQ3bXFrixsLjsZQ/NvXuNCVRBpv47PvSbksWU=;
	b=VsTJ1o/455NGqHN7dh5p41chgR4zGWaQvRHhduMS/A/y3dCy0I+XCdKjdrhvAtcPfcDNvX
	OjCLwK2+jHRrxbJvhfViqb+ePfO9zP9vDiQalNGEyFP4TmQ/3e+Wm2P77Y/sfhh7yeuQZ0
	CdXZ7Iew+N2U7IM5MjWSzkSDgJ7uqgk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-Zf5mR7euPyaa7iWoGju-Zg-1; Wed, 05 Jun 2024 19:22:55 -0400
X-MC-Unique: Zf5mR7euPyaa7iWoGju-Zg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EC94185B62E;
	Wed,  5 Jun 2024 23:22:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 24E78492BF0;
	Wed,  5 Jun 2024 23:22:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 455NMs2x623306
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Jun 2024 19:22:54 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 455NMsCV623305;
	Wed, 5 Jun 2024 19:22:54 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/7] multipath-tools: cli_add_map cleanup and misc fixes
Date: Wed,  5 Jun 2024 19:22:47 -0400
Message-ID: <20240605232254.623290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patchset is half a grab bag of small fixes and half cleaning up
cli_add_map() and making it accept adding a multipath device by WWID
instead of just by alias.

Benjamin Marzinski (7):
  multipathd: fix flush check in flush_map()
  libmultipath: check for not PATH_UP in detect_alua
  multipathd: refresh multipath before calling set_no_path_retry()
  libmultipath: add name and minor outputs for dm_map_present_by_uuid()
  multipath-tools: Makefile.inc: compile with -fexceptions
  multipathd: free alias if cli_add_map() is cancelled
  multipathd: make cli_add_map() handle adding maps by WWID correctly

 Makefile.inc                      |  3 +-
 libmultipath/devmapper.c          | 11 ++++-
 libmultipath/devmapper.h          |  2 +-
 libmultipath/discovery.c          |  2 +-
 libmultipath/libmultipath.version |  7 ++-
 libmultipath/valid.c              |  2 +-
 multipathd/cli_handlers.c         | 71 ++++++++++++++-----------------
 multipathd/main.c                 |  2 +-
 8 files changed, 55 insertions(+), 45 deletions(-)

-- 
2.45.0

