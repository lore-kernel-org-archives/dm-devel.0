Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E47D21B183
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 23:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745365667; cv=none; b=kZIfi8VDlicY6Pc8Mr1BfJLQGhCq1UvLKOwLs1GPC8+n69Zb+OQNkKqdpl7+5PCDDzAnV4uMyu8/ag8zzKMxVIGZHlxpD4BTFq0yDhtjyCwO91SPk8fbGiHcdvZxpx4ZqRoyGPZphaV1zpYNK/gXFRVkp5WXU2s84+Dond76bbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745365667; c=relaxed/simple;
	bh=zfmY4jtrPMhkBsA6251mKJhToDHQfhf3KC0Um24FEDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=fcv9VnBFDX+nmphl6rJSsZjY3VGzAk3yAhxBNx9zPXFPr3CDW4Ar8gsOTkILfJRryVm7+uqJ7GmZXa6irPNQpq7q1yuuXe7+l3L6L+74KZVREQ5l865GoJ09mAMDDKmZyS7xNBu1wRuZYBbBWRR98lexsyxqN0TOf8i8SUH7BUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CVPyjqf/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CVPyjqf/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745365662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NlLgpqq9dH0ZqXHdZ5RDxuWlUnhlQi9eZ4TlMPnl9NA=;
	b=CVPyjqf/wHTsIWPyAXQDlTeYqKIU2ZlbPYOUYHIoi43MjN4ms7mO4T3vVyAZjbfNTkRyZQ
	hV6u6r4ngtoDdbmirP5aMtCJBB9x+kT6LZxDjxB5KwrrL5Vye0BcItQzz/PRT4L8gl0F7H
	vtJI+79hudT6CB5kZKIF9sC5dpxYl3M=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-67-DawOnOt0NoKVcINaFeE-sw-1; Tue,
 22 Apr 2025 19:47:41 -0400
X-MC-Unique: DawOnOt0NoKVcINaFeE-sw-1
X-Mimecast-MFC-AGG-ID: DawOnOt0NoKVcINaFeE-sw_1745365660
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B80B11955DCC;
	Tue, 22 Apr 2025 23:47:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3A20180010A;
	Tue, 22 Apr 2025 23:47:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53MNlcn51654065
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Apr 2025 19:47:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53MNlcuR1654064;
	Tue, 22 Apr 2025 19:47:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/4] dm-flakey fixes
Date: Tue, 22 Apr 2025 19:47:34 -0400
Message-ID: <20250422234738.1654052-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 62TFxqQogA26rOQlk3TNiHNrt-zT77JPPgi9klD7zGo_1745365660
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patchset handles some dm-flakey issues reported by Kent Overstreet.
It fixes some issues with dm-flakey's parsing and feature interactions
and makes corrupting read bios work.

Benjamin Marzinski (4):
  dm-flakey: Clean up parsing messages
  dm-flakey: error all IOs when num_features is absent
  dm-flakey: remove useless ERROR_READS check in flakey_end_io
  dm-flakey: make corrupting read bios work

 drivers/md/dm-flakey.c | 114 ++++++++++++++++++++++-------------------
 1 file changed, 62 insertions(+), 52 deletions(-)

-- 
2.48.1

