Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F341F7554
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 23:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743635612; cv=none; b=ma8SLRlFP+WqygBFAT0apSllOZmxh0dxUTY2HIwtboQ4G2lGPupwet2GDA0Dqkn6QV683gy7+3ZTeWRf5ti9H9l3vKwTHfu1kA9uuY9krtunpNpgU3CzEiZVxxBy/3pV3yflceaRoC4hVGrhzXBAF4+8q5HnBUOYd4QT1rZPhq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743635612; c=relaxed/simple;
	bh=QM4CpvH7nuWCVqgKAiyqt/cEiYf6hVwmo04cAX1/1SE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=bWaMQOWMijCWZtIOJZYJRYlekQnY+oHlB68YkTbcCHccG1mBgR+0RsUN2m5I1BMqd7i5YdR3wXO0fBxC/ZUHJM0W8vX/bPKfLr4VTd+hVXRplHpcPP9KB/h/b56r0qm/+MUL7ogdK+rPVOXIUdXTkKR78I3mjzB9E6RxJ37wnUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HyQqS5pI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HyQqS5pI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743635609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pTfr4PgzkmXkZ1o7Hi8kNAQQxi6dtUkpCN0yuVggBVM=;
	b=HyQqS5pIs/hOgf0k2AchHDBFV5toxV0PbSt9Zx8wO2+zqASG/DYsnc2tTCeDw5BeOHmBK4
	gNcsEUH5bWbWzkcR/GQQKPdYfWVXcvu8DeIjtAqWV2BD3DXZOGpMl6wlujI0bEKqXqVKRM
	uAm8P0MGuFQp2d2RdBNqJ7KPFRJaMvw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-yGKyDTEfMnq828LimJJc7w-1; Wed,
 02 Apr 2025 19:13:25 -0400
X-MC-Unique: yGKyDTEfMnq828LimJJc7w-1
X-Mimecast-MFC-AGG-ID: yGKyDTEfMnq828LimJJc7w_1743635605
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4FF01800257;
	Wed,  2 Apr 2025 23:13:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6783C1801A6F;
	Wed,  2 Apr 2025 23:13:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 532NDMgn3044077
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 2 Apr 2025 19:13:23 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 532NDMwc3044076;
	Wed, 2 Apr 2025 19:13:22 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 0/4] fix issue of multipathd not tracking device
Date: Wed,  2 Apr 2025 19:13:18 -0400
Message-ID: <20250402231322.3044064-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZDSSS_eLaMYCuwUjz1ujAEFJXeHPxoNP3dnn54HB63k_1743635605
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

The first patch fixes this. The second patch is prep work. The third
patch allows mutipathd to track these offline paths that should belong
to a device, and add them to device once they come back online. The
third fourth is just a cleanup.

changes from v2
- 0002: New patch to avoid duplicating the code to determine if we
        can recheck the paths wwid.
- 0003: Always recheck WWID when path comes back online if capable
        (suggested by Martin Wilck). Fixed holdover code from v1 to
        set pp->initialized = INIT_OK when the path came back online.
        Fixed typo in documentation.

changes from v1
- 0002: Switch from tracking this state with pp->initialized to a new
        variable, as suggested by Martin Wilck. To make is so that
        multipathd can still show paths in this state without adding
        a new wildcard for it, add [offline] as a possible output for
        the %m (multipath device) path wildcard, for paths that
        couldn't be added to a multipath device because they are
        offline. Also constify a function parameter and add an
        explanitory comment as suggested by Martin.

Benjamin Marzinski (4):
  multipathd: monitor new multipath dev even if we can't update it
  libmultipath: add helper function check_path_wwid_change
  multipathd: re-add paths skipped because they were offline
  multipathd: don't update paths in INIT_MISSING_UDEV

 libmultipath/discovery.c          | 12 ++++++-
 libmultipath/discovery.h          |  2 +-
 libmultipath/libmultipath.version |  5 +++
 libmultipath/print.c              |  5 ++-
 libmultipath/propsel.c            |  4 +--
 libmultipath/structs.h            |  1 +
 libmultipath/structs_vec.c        |  5 +++
 multipathd/main.c                 | 59 +++++++++++++++++++++++++++++--
 multipathd/multipathd.8.in        |  5 +--
 9 files changed, 87 insertions(+), 11 deletions(-)

-- 
2.48.1

