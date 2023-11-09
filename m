Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C0B38FAD
	for <dm-devel@lists.linux.dev>; Thu,  9 Nov 2023 23:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C9oS2y6f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699573579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yz+Hiy1k+3U4cwCiUP9tfVCgg58DtRoR6MJAZFWCqoI=;
	b=C9oS2y6fanDPzSaq5hqNxdbugyVo2rC/dOoVhe+YKDpiBxx8/6yQYd0KG+/E3pne/pRsAO
	UitKLc9vXsEjHpPQE8r4xbEKrZQgneyBTxJid7aqPQWUlciJFzX1zTCvp201lWUlOpU/ns
	PoiCnv6h5fDMG0idm3j4HIvVE6oSJr0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-189mBPWbNJSVjE66Jobs_g-1; Thu, 09 Nov 2023 18:46:17 -0500
X-MC-Unique: 189mBPWbNJSVjE66Jobs_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 859DD80F906;
	Thu,  9 Nov 2023 23:46:17 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7710825C1;
	Thu,  9 Nov 2023 23:46:17 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A9NkHKf100131
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 9 Nov 2023 18:46:17 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A9NkGTf100130;
	Thu, 9 Nov 2023 18:46:16 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 0/6] Two multipath features.
Date: Thu,  9 Nov 2023 18:46:10 -0500
Message-ID: <20231109234616.100125-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patchset implements two features that I had requests for. The first
commit adds the ability for multipath to control the scsi max_retries
sysfs setting. This is useful for instances where a path hangs when
attempting IO, but the path checker completes successfully. It allows
the multipath device to fail quicker. When it's used like this it needs
to be paired with the shaky path detection options, since multipathd
will restore the path on the next checker run.

The rest of the patches add the auto_resize option. This option allows
users to control when multipathd will automatically resize a device, if
it sees that all of its path devices have been resized. By default it is
set to "never" and multipath behaves like it always has, where users
need to manually resize multipath devices after all the paths have been
resized.

Differences from v1 (all from suggestions by Martin Wilck):
1/7: make the option default section only. used max_retries specific
     enums, and clarified man page entry.
3/7: Assume path size hasn't changed if we fail to get it from sysfs.
6/7: make the option default section only. removed "multipath -r"
     mention in man page. Fixed whitespace issue
7/7: removed

Benjamin Marzinski (6):
  libmultipath: Add max_retries config option
  libmutipath: Retain device size if sysfs_get_size fails.
  multipathd: check and update all paths when in cli_resize
  multipathd: move post-reloading commands into resize_map()
  multipathd: move resize_map() to multipathd/main.c
  multipathd: Add auto_resize config option

 libmultipath/config.h         |  2 ++
 libmultipath/defaults.h       |  1 +
 libmultipath/dict.c           | 63 +++++++++++++++++++++++++++++++++
 libmultipath/dict.h           |  1 +
 libmultipath/discovery.c      | 41 +++++++++++++++++++++-
 libmultipath/structs.h        | 13 +++++++
 libmultipath/sysfs.c          |  1 -
 multipath/multipath.conf.5.in | 29 +++++++++++++++
 multipathd/cli_handlers.c     | 66 ++++++++++++-----------------------
 multipathd/main.c             | 57 ++++++++++++++++++++++++++++++
 multipathd/main.h             |  2 ++
 11 files changed, 230 insertions(+), 46 deletions(-)

-- 
2.41.0

