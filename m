Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5041022315
	for <dm-devel@lists.linux.dev>; Thu,  2 Nov 2023 22:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="POMuf9ha"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698963313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oKzBDfgO1TpSPn0kFXZEiDDKT4LmFJk/hrEHtdqhZlY=;
	b=POMuf9haOtwMw7Q8huixe5GTQUvFm63T/h4Ko/uOces/mA73cEqPA7w7t3ZjvnYQPSnC0G
	D+l+3COfapivOdE9ELqg7dQZchhRSVgWvFVREIq0IeNhJ8L0s1aZhpF2ByQLIKQ4G9k0I2
	T0N1IaEyhKvrLu6UjnJMqcFzWXuqw/U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-60ZndOu8M6GFDlAAu9pe1Q-1; Thu, 02 Nov 2023 18:15:08 -0400
X-MC-Unique: 60ZndOu8M6GFDlAAu9pe1Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D82FC185A782;
	Thu,  2 Nov 2023 22:15:07 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D02E425C0;
	Thu,  2 Nov 2023 22:15:07 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A2MF7mw105377
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 2 Nov 2023 18:15:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A2MF7iP105376;
	Thu, 2 Nov 2023 18:15:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/7] Two multipath features.
Date: Thu,  2 Nov 2023 18:15:00 -0400
Message-ID: <20231102221507.105371-1-bmarzins@redhat.com>
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

Benjamin Marzinski (7):
  libmultipath: Add max_retries config option
  libmutipath: Retain device size if sysfs_get_size fails.
  multipathd: check and update all paths when in cli_resize
  multipathd: move post-reloading commands into resize_map()
  multipathd: move resize_map() to multipathd/main.c
  multipathd: Add auto_resize config option
  libmultipath.version: bump ABI version to 22.0.0

 libmultipath/config.c             |  5 ++
 libmultipath/config.h             |  6 +++
 libmultipath/configure.c          |  1 +
 libmultipath/defaults.h           |  1 +
 libmultipath/dict.c               | 82 +++++++++++++++++++++++++++++++
 libmultipath/dict.h               |  1 +
 libmultipath/discovery.c          | 42 +++++++++++++++-
 libmultipath/hwtable.c            |  1 +
 libmultipath/libmultipath.version |  2 +-
 libmultipath/propsel.c            | 35 +++++++++++++
 libmultipath/propsel.h            |  2 +
 libmultipath/structs.h            | 15 ++++++
 libmultipath/sysfs.c              |  1 -
 multipath/multipath.conf.5.in     | 38 ++++++++++++++
 multipathd/cli_handlers.c         | 65 ++++++++----------------
 multipathd/main.c                 | 53 +++++++++++++++++++-
 multipathd/main.h                 |  2 +
 17 files changed, 304 insertions(+), 48 deletions(-)

-- 
2.41.0

