Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784ED20A5EA
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 11:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733398937; cv=none; b=pMkaw1QrnQso1Mkm2Ih8n92J1K+qXK5NpqeeDb5BFYic0vnONROTNb/GTh6XET3uvKhcBPvFHRORowMI6qSKlbmTEALCDEoytrxZurJFI2AoO2PN6BJKqOWepyiT9YzGE8+/byOMqFZx/yfXfH4zJmeqq2/CwA2Fy44dhF+LYPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733398937; c=relaxed/simple;
	bh=uzuPmxxKxNz6r54lvNQE+R+eDC9enCIN0Kz8w3e+K3g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Wny1S3GvLIOx3pNQ5wmIU0QOV1KPrOvsGVBVqGSP/MG9mI/zgxfep6W9zqpSDtpTNURWVno3NiLxPYw095Nkv+3UPlsZ+lqs8ZrmOdWvxmPzEK+ACNlIaFeBGPoa3LBD0RmBUKNQH159eclK28seTCOOuh9/siXVUios10LWhqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G8GCeNCt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8GCeNCt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733398931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=keb1hERFeMScJfDORGcgzlgKb1cSelDBID1fsOFZawI=;
	b=G8GCeNCtCmSYNNJdCFU4iJK/OEMNXiqKzFxfPK/+r1gFcsZ/YxOFU2B/Oemb3y/b1Z2tXG
	ZUkbsrnq5lTw/nEX9NPkKutEqXWmK1H3iZA2yOO/mPzJH5l5w4lacpIiRAyLTglXjis9Hv
	N2EIphT22MHSzwG3KfLCC1N5KlDLAu8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-rfFoLjL7PN2TJ-j_zVf6gA-1; Thu,
 05 Dec 2024 06:42:10 -0500
X-MC-Unique: rfFoLjL7PN2TJ-j_zVf6gA-1
X-Mimecast-MFC-AGG-ID: rfFoLjL7PN2TJ-j_zVf6gA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 244651954ADD;
	Thu,  5 Dec 2024 11:42:09 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.108])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C3221956095;
	Thu,  5 Dec 2024 11:42:04 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH v2 0/3] Fix dm_array_cursor skipping and error handling
Date: Thu,  5 Dec 2024 19:41:50 +0800
Message-ID: <20241205114153.1496986-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IR2ed4CdEKPTiPZIOlVp_HQIldkTv1fkOxpEhKhQqk8_1733398929
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

 drivers/md/persistent-data/dm-array.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

-- 
2.47.0

