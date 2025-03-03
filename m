Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560A71CAA90
	for <dm-devel@lists.linux.dev>; Mon,  3 Mar 2025 15:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741017234; cv=none; b=T1YG5kRJwbdrSiqVOrKAhhRiWc93MQWuhVu/ET2hRPzZxxapw2dxjgNfpaXohjYKnA5iYKvY+pvmJJRbIRVZPCi/QYyzVuAg72QnIoT6XfDyN0wTluBOkmEb3CvGlMXvEuaOrG0PlNPzjym2OdjP832cJzps0eCV/4Sf9bFjcbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741017234; c=relaxed/simple;
	bh=bpH6+5JG33eXMLrvJySy80W3RMQEkTyr6YnQT8akLvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=B7glbHOGTCe8yKJmpLJu7mPVLbmjnLvv3FzleR5D6mbpXidI163gkIm5BlIULqhV3NrMtYC1QAZzFm5T1eLadsbDQszJzpqrljI0W4ezctnKT5Ij+um5WhQQCwXJxLUmS//CaWLGaCIcCAlWnl4Pa37IVMnleioCz4NBOSduFqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EGT6nvdV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EGT6nvdV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741017231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gskn3/hLpx11SGo8L6DYqd1yKvZ882jyL89m0QkYe9c=;
	b=EGT6nvdV0hCFTV8tgO9BAPf9u26s70xmM8CshXERHtHT8WLirnDJzsMD0vNYgIZtA7UHoP
	4WFsjzf0bFWe19NEFVuIYwnXpCTri6CDZFu4vhCYPZkQEvnSG2pL4iTfiXqCRcMTqL2B+y
	aNBYc6NQKPrTeoNFxU10N7fq0XuA5II=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-491--QBLHiaNO52Ems53peNT-Q-1; Mon,
 03 Mar 2025 10:53:49 -0500
X-MC-Unique: -QBLHiaNO52Ems53peNT-Q-1
X-Mimecast-MFC-AGG-ID: -QBLHiaNO52Ems53peNT-Q_1741017228
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C06E21975AFC;
	Mon,  3 Mar 2025 15:53:48 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.31])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15E031800944;
	Mon,  3 Mar 2025 15:53:43 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH v2 0/2] dm cache: support shrinking the origin device
Date: Mon,  3 Mar 2025 23:53:30 +0800
Message-ID: <20250303155332.45339-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ll9owexyU4exvRuNi2RWCaUU0dr2CqmpzGMXM5oVlcs_1741017228
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patch series introduces formal support for shrinking the cache
origin and ensures that failed resume attempts, such as those caused
by shrinking failures, do not trigger BUG_ON.

The only change in v2 patchset is the updated dm-cache's version number.

Ming-Hung Tsai (2):
  dm cache: prevent BUG_ON by blocking retries on failed device resumes
  dm cache: support shrinking the origin device

 drivers/md/dm-cache-target.c | 96 ++++++++++++++++++++++++++++++++++--
 1 file changed, 93 insertions(+), 3 deletions(-)

-- 
2.47.0

