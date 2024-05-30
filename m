Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5993442076
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 16:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717088106; cv=none; b=ctjwMQjGebxA1v2pEEBfssjUMktlWRA5Pzd3GVf+Ew4uPP9YmSnCyssRDFNNNxcIAbWpShE2YJWhyU6cvqBXjB4P/H401H69mbM5CAxG3vwZ8LUQw1lO9k4148i8wWU1Kc/74brC7o1XJ+GZHglx5VoJHr8cREDekYpNmSdakNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717088106; c=relaxed/simple;
	bh=S71otdVZTwTFDASiQTEFNZ82UHvR+RJbLWXIGdd7JzA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TRlHboBt5TUHO+1m2nA9Kezha2PDDmcNGpZjZF7oXRHqkzaWCY2eKgP5LeW7sQNThoBixEmHeeAoHNy0CLvtxx/61I/VhzOIyOk5WplI1L/2CjJGOMDl+xKtLRsFjRzm/Kl7i2TpPy4lUuPCd3RKi8CJ+0yfzesTVV8mNBCyp2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ijWH+A0u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ijWH+A0u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717088104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JTm1XEuMmL1gG6NkNFSd3xF2QoRvy3PZKMrHrAB2OxE=;
	b=ijWH+A0ua++8ZoTvtfX4cYI8n6TDt+kLeETmvkKRL+OS1TxqJCVx5P7yZ4zohr/IfjmHd8
	As19BUAW640QYyWG/zPuYcbuDUn2vVNKz1bMkuxST4Dmg9cg0QZL4Tp3wR/eahZ27+5Uzt
	Ulp4G3bfGNd2Fmu1z5IQ+MOkgm9Rvd0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-gqinex18PZSPx9pJy11WUw-1; Thu, 30 May 2024 12:55:02 -0400
X-MC-Unique: gqinex18PZSPx9pJy11WUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C48F8008A4;
	Thu, 30 May 2024 16:55:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 028F0C15BB1;
	Thu, 30 May 2024 16:55:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44UGt1hn397025
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 30 May 2024 12:55:01 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44UGt03j397024;
	Thu, 30 May 2024 12:55:00 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>
Subject: [PATCH v2 0/7] multipath-tools man pages: add missing information
Date: Thu, 30 May 2024 12:54:53 -0400
Message-ID: <20240530165500.397009-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patchset is inspired by:
https://lore.kernel.org/dm-devel/1673555329-9850-1-git-send-email-bmarzins@redhat.com/

It removes the useless pathgroup wildcards section from the "show
wildcards" output and adds wildcards descriptions to the multipathd.8
man page, along with some issing multipathd commands.  In the process of
doing this, I noticed some instances where either the man page or
multipathd wasn't giving the correct information, and fixed those up.

Changes in V2 (based on comments by Martin Wilck):
0003: change print format from "%i" to "deferred:%i"
0007: Multiple man page changes. I left the order the same as shown in
      "multipathd show wildcards", since it doesn't seem like an
      alphabetic order makes more sense. Also, I'm not really sure what
      to call the H and T members of the NVMe %i (H:C:I:L) output.
      I ended up calling them Controller and Namspace Instance Numbers
      based on their in-kernel variable names. But if there is a
      better name, I'd happily use that.

Benjamin Marzinski (6):
  multipath-tools man pages: don't assume multipath.socket is enabled
  libmultipath: print all values in snprint_failback
  multipathd: Stop double counting map failures for no_path_retry > 0
  multipath-tools man pages: add missing multipathd commands
  libmultipath: change the vend/prod/rev printing
  multipath-tools man pages: Add format wildcard descriptions

Nitin Yewale (1):
  libmultipath: remove pathgroup wildcard options

 libmultipath/print.c       |  22 +--
 libmultipath/structs_vec.c |   5 +-
 multipathd/multipathd.8.in | 309 +++++++++++++++++++++++++++++++++++--
 3 files changed, 311 insertions(+), 25 deletions(-)

-- 
2.45.0

