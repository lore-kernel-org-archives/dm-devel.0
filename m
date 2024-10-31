Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0F013E03A
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 18:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730399590; cv=none; b=IyhPFW6uzke6Rz7qGTmqRwwHBSLYYG1CK5gVYlZcEwQk0UMM0WJPQ/Y4LP4E+NANzM34z4lpYbHQd/N3djonjQUS8N0rLc6hcDBi3i5f0QDAzvk1sL5RCw3YGuTaT4YWiAt3aRIF/J387C2y8H8zHsMWqVHrcjKYiAZiZEeue5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730399590; c=relaxed/simple;
	bh=FY6t5gkS/tCdW50icsvMe5c5Zt6ookNTraVa9hrBIgU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BsL431BMlV3stmX1BUDiosmT99ILLbfSfu9M+sJUSlj8yIXxdiYVjnWc9bSpXqi3VgIylDE+hlhDdGKr9zj1Rj5uJ5pjJRAxR7dsKH5kQAsf9R21Wcs8gAS3ZZ1fnfpmx8gyquOCvizq9yoPEmu61q0dGXIUBt04ZT82zGyY/wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YPIOltMc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YPIOltMc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730399586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0SuQ9d1ez6jfs0r1ynXGwKpf7Pr5d0zsuStQGI7iV3U=;
	b=YPIOltMcuVFWz28msYP0XpzoWTNdZUR/6uCK1gntebAwv3bbadcZIMpLiJ/4RSGQ+upKop
	bWtqXS9/4P+8ZiYSeUFdJeL2ocmM/uMknKN01CL1vbZSJ9hj/NpkIkOJ1YTI1J/7ceINPW
	LS3Mr/l7mRSq/lG2l92OiXY+1s+8ips=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-78-4iCC9W4HPqeL7hSfczCSaQ-1; Thu,
 31 Oct 2024 14:33:05 -0400
X-MC-Unique: 4iCC9W4HPqeL7hSfczCSaQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 313801955F43;
	Thu, 31 Oct 2024 18:33:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C02F1300018D;
	Thu, 31 Oct 2024 18:33:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49VIX2LM391433
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:33:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49VIX1JM391432;
	Thu, 31 Oct 2024 14:33:01 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/8] multipath fixes to tableless device handling
Date: Thu, 31 Oct 2024 14:32:53 -0400
Message-ID: <20241031183301.391416-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patchset include a couple of miscellaneous cleanups, but is mostly
in response to issues brought up in
https://github.com/opensvc/multipath-tools/issues/100
It adds auto restarting to the multipathd.service unit file. I'm fairly
conflicted about the correct limits to be placed on these restarts, so
if anyone has strong opinions and a good argument, I'm more than willing
to change them.

The bulk of the changes deal with how multipath handles devices without
any table. Multipath was supposed to delete these if they were left
behind after a failed device creation, but that code was broken.
However devices aren't typically left behind after failed creates, so it
didn't matter.  

A bigger issue is that multipathd and multipath could fail if tableless
devices were present. With this patchset, they will simply ignore
tableless devices that don't have a multipath prefixed DM UUID. The last
patch is a RFC patch that changes the behavior for tableless devices
that do have a multipath prefixed DM UUID. It makes multipath remove
these devices on the grounds that they are likely failed creates.
However, looking at the libdevmapper code, I'm not sure that we actually
want to do this.  When a DM_DEVICE_CREATE task is run, it will first
create a tableless device, and then immediately load the table and
resume the device. So it's possible any that tableless devices which
multipath sees are actually in the process of getting created. I left
the patch as part of the set, but I'm not sure that removing the devices
is the right answer here. I haven't ever seen any tableless multipath
devices lying around (and I couldn't force any to get created when I
tried). Unless other people have seen these, then I don't think the
final patch of this set should go in.

Benjamin Marzinski (8):
  multipathd: print an error when failing to connect to multipathd
  libmultipath: check DM UUID earlier in libmp_mapinfo__
  libmultipath: Don't fail dm_get_maps for DMP_NOT_FOUND
  multipathd.service: restart multipathd on failure
  libmultipath: use MAPINFO_CHECK_UUID in dm_get_multipath
  libmultipath: signal multipath UUID device with no table
  libmultipath: fix removing device after failed creation
  libmultipath: remove devices with no table and multipath DM UUID

 libmultipath/devmapper.c         | 56 +++++++++++++++++++++++---------
 libmultipath/devmapper.h         |  6 ++--
 multipathd/multipathd.service.in |  3 ++
 multipathd/uxclnt.c              |  4 ++-
 4 files changed, 51 insertions(+), 18 deletions(-)

-- 
2.46.2

