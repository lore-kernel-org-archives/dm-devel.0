Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D7E38F
	for <dm-devel@lists.linux.dev>; Fri, 17 May 2024 00:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715906495; cv=none; b=f/dqlBQSzvUI+fRHEdRlRSCeRZ2HClfSXvQre7VhSFUBwVtz7GVDA53ceNWZX/dvn/qcucKBm4XYf3O2aqXt07Mx49r3Av+ad6Eb5BXHRKRwj/6SZoAf2IVERa//d91AAramVud83uRr9HkZT2Bk/0NrP48v5plFSlWgeEHml3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715906495; c=relaxed/simple;
	bh=ct30iUcaE98wJOSKUXpwNtUeXWIs4PQY870FIMSSiuI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aMI2oZ7/PLzujE9F/B6SlbNI7J/9HlBuwL1QwWo1ug3mde6gs/xpr1DRpvnLiSJfBZFuikO3mLOfFOdbqt+smxsbDix98ZpVoDLEronfn8J5IcF9Jb8wCyKWMwzHSdWqHcQ/Bl1ZgoBJ8S9X8SYtpO7DEcFkMlYJkaDya5/xgtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YJ5gQocP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YJ5gQocP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715906493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=I2LxHqr8sNqYfNAdl5l0jBFo3YkVt/8DexLUOpd503U=;
	b=YJ5gQocP2oboF+NjXEOY0zkYUlnVXJH9Eab9GB/wDTaccb1qsP9UbDvzrAROBtpibzbszA
	p/juGakVLO83Z5QBiZwB4rcdtUbyBzLkhHG3mZkRuokPgSEO+WHyCPC+oskQMaxn/BRFz+
	2DGEx95AaP7Xu0Mgo+91f4bWCnSpIEc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-7me5V8DkNfq-xHWcOw6heA-1; Thu, 16 May 2024 20:41:29 -0400
X-MC-Unique: 7me5V8DkNfq-xHWcOw6heA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E1D5801211;
	Fri, 17 May 2024 00:41:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6206A40C6CB7;
	Fri, 17 May 2024 00:41:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44H0fTET139626
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 20:41:29 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44H0fTCw139625;
	Thu, 16 May 2024 20:41:29 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 0/2] dm: mpath dm_get_device fix
Date: Thu, 16 May 2024 20:41:27 -0400
Message-ID: <20240517004129.139615-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

dm-mpath shouldn't be calling dm_get_device() in multipath_message().
If you run:

# dmsetup message <mpath_dev> 0 "fail_path <device_not_in_multipath>"

the dm_get_device() call in multipath_message() will add that incorrect
device to the devices list, fail to find a matching pgpath, and then
remove it.  multipath shouldn't be messing with the devices table
outside of its constructor and destructor.

To fix it, this patchset factors out a helper function from
dm_get_device() to turn the device path string into a dev_t.
multipath_message() calls that helper function and uses the dev_t to
find the correct pgpath instead.

Benjamin Marzinski (2):
  dm: factor out helper function from dm_get_device
  dm mpath: don't call dm_get_device in multipath_message

 drivers/md/dm-mpath.c         | 11 ++++-------
 drivers/md/dm-table.c         | 33 ++++++++++++++++++++++++---------
 include/linux/device-mapper.h |  5 +++++
 3 files changed, 33 insertions(+), 16 deletions(-)

-- 
2.45.0

