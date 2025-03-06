Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB067207A04
	for <dm-devel@lists.linux.dev>; Thu,  6 Mar 2025 08:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741250532; cv=none; b=ReKx+oBsKwUd309ecj7YA456IDeVsXG8d0LRojWtSyzcWXVRmCnJsFgijCO/9IXjcmQc8cfWgabZsXQmfesXun47MH/pPcJO7a0kVJhvkV9UVmgA4P1uH0uaw71aAM5Ci+sYiXXg447j9tBtlXUyv9/H+Yo9P9gJqAL0TwCBXzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741250532; c=relaxed/simple;
	bh=jr3P3S8yQL5CjMLFS8Ik4XxbVecKfn5LuhVj6Aw1E+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=VidRXT5z3Eh3as6H/dspaQynbP7/YnRBXeE5RqjC6Yo8m1OFKjU3Ty8YQ3aHlbWgFpIX2ETPTP7rcMuOJ66ieSMYNF7LABru+fRbxmk+dYAO7aQSmoyksskEG2iwVg7tzedG1y0vrzm3Ia2kfIaSkTAZFg0Q4KXb66z+4OJxW/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bsYGukAw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bsYGukAw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741250528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AUQosI4ymurc2kxYY2k0+Z7G6zE1zI/0te1FCt27cRM=;
	b=bsYGukAwccI8zDvegKLOoXdeV0aDJ8WRvrx4gordcOuPlCQSjVM9fWMq1XWdBbDIKo+phE
	M/XC1AIBFd4D6JPzvdgwJhJrwOCvk7ILIT1xllErD3QlkNCXWYJWXHWVgw8H7kzIN4WLvc
	N5jvsF8u420kTce6j8Vn7FPAa/15XzA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-LarCtRqxOr2o9BkEA3qWxw-1; Thu,
 06 Mar 2025 03:42:04 -0500
X-MC-Unique: LarCtRqxOr2o9BkEA3qWxw-1
X-Mimecast-MFC-AGG-ID: LarCtRqxOr2o9BkEA3qWxw_1741250523
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B7BC180AF74;
	Thu,  6 Mar 2025 08:42:03 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 770D2300019E;
	Thu,  6 Mar 2025 08:41:57 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH v3 0/2] dm cache: support shrinking the origin device
Date: Thu,  6 Mar 2025 16:41:49 +0800
Message-ID: <20250306084151.371591-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SwXkMxnUJ_oHEch0BguDTHFIQSnUlVqWIdpDDKsGmhg_1741250523
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patch series introduces formal support for shrinking the cache
origin and ensures that failed resume attempts, such as those caused
by shrinking failures, do not trigger BUG_ON.

The v3 patchset fixes the bitwise casting warning reported by sparse.

Ming-Hung Tsai (2):
  dm cache: prevent BUG_ON by blocking retries on failed device resumes
  dm cache: support shrinking the origin device

 drivers/md/dm-cache-target.c | 96 ++++++++++++++++++++++++++++++++++--
 1 file changed, 93 insertions(+), 3 deletions(-)

-- 
2.47.0

