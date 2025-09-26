Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7322F2F83C2
	for <dm-devel@lists.linux.dev>; Fri, 26 Sep 2025 17:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758907742; cv=none; b=HzC++OskjrUn5WK7WRnlCvcPEM4b1WAspRx1LT9dqCzxRZ8XhdYKOVx/vkKHlYE3YXFh3gB+V7TA5THrux/uDGgau8aH1FNYYtD/Zc7ffP4hDRxJLDpQGKfjWAVFSFdkijbusu0TT2RUpgEUKcjg74AiBN+RCPbkLjAwsHdC4QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758907742; c=relaxed/simple;
	bh=iBTzbS/EqHaKJgiVzYc5pgQUjvWb5U8+oG1zlvpTC9c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=f/2UmxvZn19mtT5VZP1m7dsNqp12QkaGd8DssetRLtEPOEUxnlShLzJdp0HMZh37bmYl84NnLIm7QhY1NrqMDY7DIqLYrw/Za3tepTZK0YGLIvCH/KVga/75snXpus4o0ILBATFhXSm+GC1nG9gWVVjmxfmN3VAT1vdMdGZQ8l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EFsycKQ3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EFsycKQ3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758907739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FIuq8SQaNWWMmmafrjqFHW5fK98++NjM6qA+/BCjz94=;
	b=EFsycKQ38gMu5UsWIvxoX6RSt2WpYjhKSvCR+8PrhRHDFgSXlbulssB34Y0ygJwR83qxhb
	QXkGr4XhZ73s1P/+0d7IhFDpsqTcBlqpeaExe3GcTqPnz3E9bwCKr4a/Bh3CWt1qhyotFY
	O9avDktaxyOx654ylg1LSk9F4hldUsk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-JtOLnY7LPlu1kGvgsYrDtg-1; Fri,
 26 Sep 2025 13:28:57 -0400
X-MC-Unique: JtOLnY7LPlu1kGvgsYrDtg-1
X-Mimecast-MFC-AGG-ID: JtOLnY7LPlu1kGvgsYrDtg_1758907736
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BD82195608D;
	Fri, 26 Sep 2025 17:28:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2AF4230001B7;
	Fri, 26 Sep 2025 17:28:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58QHSs9u1548364
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 13:28:54 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58QHSsmE1548363;
	Fri, 26 Sep 2025 13:28:54 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 0/4] libmultipath: Yet Another PR patchset
Date: Fri, 26 Sep 2025 13:28:50 -0400
Message-ID: <20250926172854.1548351-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V1eXmaArKOv_8PkHGx1PLHuJ7FjpndAXXoPtZuTq3EU_1758907736
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patchset handles 4 separate issues:
1. The self-preemption workaround for changing keys using REGISTER AND
   IGNORE, while the path holding the reservation was down was broken
   by a recent commit.
2. mpathpersist was failing a RESERVE command issued on a multipath
   device that held a reservation, when the holding path was down.
   Issuing an identical reserve on a device that holds a reservation
   is supposed to succeed, and multipathd has enough information to
   know the device is actually holding the reservation. So if
   multipathd says that the device is holding the reservation, it
   should not fail, even if the path holding the reservation is down.
3. mpathpersist was not clearing the reservation when the key holding
   it was unregistered, if the path holding the reservation was down.
4. When unregistering a key that holds a reservation, depending on the
   order that the paths got unregistered, there was a window where
   IO going to the device could fail. This should not happen because
   the reservation should be removed and the key should be unregistered
   atomically.

Changes in V2:
0004: reworked how the unregister infromation is passed to an from
      mpath_prout_rel() to make it less confusing, at Martin's
      suggestion.

Feel free to reformat my patches. I forgot to do that first. Sorry.

Benjamin Marzinski (4):
  libmpathpersist: Fix REGISTER AND IGNORE while holding a reservation
  libmpathpersist: Handle RESERVE with reservation held by failed path
  libmpathpersist: use check_holding_reservation in mpath_prout_rel
  libmpathpersist: Fix unregistering while holding the reservation

 libmpathpersist/mpath_persist.h     |   3 +
 libmpathpersist/mpath_persist_int.c | 204 ++++++++++++++++++----------
 2 files changed, 134 insertions(+), 73 deletions(-)

-- 
2.50.1

