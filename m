Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B872333D51A
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 23:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781566580; cv=none; b=k/eZDuhJXuXngjDHfOV/flCQoX+9jiLUO0yRktkSM8RABgEBD7Lg5aTF9L6OWz7FF+wzOd4cSy2yMfV7AQ42DTjQHuvMXc7WxvZ4OHmV1vXuNo/zUrKtx0M1+9cU8EY+/cCsWntsildpL43PDDUYgWdC7uCgnUBnpnFia8CDDqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781566580; c=relaxed/simple;
	bh=4CFyotZSLal9Jdipd8Tj/H92TZgBATXn6Rey+dwLm9U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=i1nw62abVG5E9vxhm6RvK8SuZgEVNDGJNGd3U7yThfZBG2tVZPoMpL+Ces0ssActN3mT4B375snQZPVYxQexEarobnj/bvr0tp0o/YiTBU87L+bhY8/hlxIIcER9dLbJVMRtpjt8g8R+X/T3y6FrQqSqvqX+RCCG7CD8an8cvU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bRnsvH0d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bRnsvH0d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781566578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S0jnPcahm2SBzTYH51+55AuBEQEKmNaTNwC6/Sx+4oM=;
	b=bRnsvH0dJLohcyNhpo55yzlhEgE8EhXyU3JkhPQ5JUAei6qnIBGV8SOAQM9IyDyDSMhcm8
	x8qkFJPNV2aP0EetFyyooDQ2GQkIw1RiJraYahVit81krgbZS1Ne+1+xX3XKrL3Q+VNBmf
	6lpaLmRWBHVvSwryQdpN2UGbqq0CdLM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-115-EEG-h47iMhGvyZZsSYFY0w-1; Mon,
 15 Jun 2026 19:36:14 -0400
X-MC-Unique: EEG-h47iMhGvyZZsSYFY0w-1
X-Mimecast-MFC-AGG-ID: EEG-h47iMhGvyZZsSYFY0w_1781566573
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5757219560AA;
	Mon, 15 Jun 2026 23:36:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E495195410F;
	Mon, 15 Jun 2026 23:36:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65FNaB1r804981
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 19:36:12 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65FNaB3s804976;
	Mon, 15 Jun 2026 19:36:11 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2 0/4] minio cleanup patches.
Date: Mon, 15 Jun 2026 19:36:07 -0400
Message-ID: <20260615233611.804954-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kvx3EEEnBSFVJSzNR6cfPfoJLKBBNe_ZUZ0Snj2w4hM_1781566573
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patchset is to deprecate the rr_weight, rr_min_io_rq, and rr_min_io
multipath config options. It's a companion of the patchset to handle
their deprecation in the man pages.
https://lore.kernel.org/all/20260607103831.336833-2-xose.vazquez@gmail.com/

It does not completely remove the minio setting code, since there are
ideas for reusing this in the future. The final patch is simply a change
to avoid a kernel warning message that I hit while testing these
patches.

Changes in V2 (due to issues pointed out by Xose Vazquez Perez):
0001: removed rr_weight_mode enum, default value, and print_rr_weight()
      function declaration
0002: changed do_default() to mp_set_default()
0003: Removed comment mentioning the DM target version check for
      the minio source.

Benjamin Marzinski (4):
  libmultipath: deprecate rr_weight, and make it do nothing
  libmultipath: deprecate rr_min_io_rq, and make it do nothing
  libmultipath: deprecate rr_min_io
  libmultipath: don't set hwhander for bio based devices

 libmultipath/config.c    |  6 ---
 libmultipath/config.h    |  6 ---
 libmultipath/configure.c |  1 -
 libmultipath/defaults.h  |  3 +-
 libmultipath/dict.c      | 90 +++++++---------------------------------
 libmultipath/dict.h      |  1 -
 libmultipath/dmparser.c  | 28 +------------
 libmultipath/hwtable.c   |  3 --
 libmultipath/propsel.c   | 54 ++++++------------------
 libmultipath/propsel.h   |  1 -
 libmultipath/structs.h   |  7 ----
 tests/hwtable.c          | 13 ++----
 tests/test-lib.c         |  2 -
 13 files changed, 33 insertions(+), 182 deletions(-)

-- 
2.53.0

