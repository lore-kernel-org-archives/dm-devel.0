Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C051F76CE
	for <dm-devel@lists.linux.dev>; Tue,  3 Dec 2024 17:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733247493; cv=none; b=hj+A6uss0gC5os7vUR0s91FYaHnIyYk1gWfyXotyMwiwM7nuKJnFn8eA15QsJZeRs+08GTlXDU/BUVww8enkC/UDErLN7jwDGPh++hGPcj4NRVvjLuQgsk07i4wS1cPfu2ZubHUcNzEFB8vAiaBd+RumMdmhBGi1se+DUN+Nt8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733247493; c=relaxed/simple;
	bh=1gr/1lLVyQh4lHt5Baz6Do2neIRqvjhgQUeqvmnvyUA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=aHirU/gRYZ6pFmOtipNFc/1kPy99/uOQqsMgi5DHTCSvMsYmMPn7C1ag34HmOWkIG4xKFBWr09j1IK46HgXgCKxGProgmmmXZmqZMD5l7DK+rFkCTJp7D6S8h58xWDcH5NncXo2eWAfqbYIU2Ct+S+7bdaYW+kH3omp3uVsaiBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dp43gW+y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dp43gW+y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733247491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EjZGd0scGaDoK+JB0E+XeIjFjFkGX5+oEsH9HCkF2TM=;
	b=dp43gW+y14BNOBjgmgo4gcUCkwI5rj7P1/GcKGTYdJR2NgMz0dGHJbHt3TQDATn8VYRuJp
	fGoZiybnKzABKWIPkxrFZWiA1Tb6lMv0sYAfsoGyGQqlBREGD83NpT7cCqrrDlKmE2PwNs
	nb+qPkHd1U9D4hE3n12FYc44SHJ9H8E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-199-Zy79x09dORWHmW6NHMgshQ-1; Tue,
 03 Dec 2024 12:38:09 -0500
X-MC-Unique: Zy79x09dORWHmW6NHMgshQ-1
X-Mimecast-MFC-AGG-ID: Zy79x09dORWHmW6NHMgshQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E003B1955D86;
	Tue,  3 Dec 2024 17:38:08 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.41])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50E811956089;
	Tue,  3 Dec 2024 17:38:04 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 0/3] Fix dm_array_cursor skipping and error handling
Date: Wed,  4 Dec 2024 01:37:56 +0800
Message-ID: <20241203173756.1257967-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HhxSttYFoM4K-oRbkvGNldjj2lob8PunGfbb5pCBpWQ_1733247489
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patch series addresses a positioning bug in dm_array_cursor_skip()
and two other issues regarding error handling.

Ming-Hung Tsai (3):
  dm array: fix releasing a faulty array block twice in
    dm_array_cursor_end
  dm array: fix unreleased btree blocks on closing a faulty array cursor
  dm array: fix cursor index when skipping across block boundaries

 drivers/md/persistent-data/dm-array.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

-- 
2.47.0

