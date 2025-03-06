Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6FB18C332
	for <dm-devel@lists.linux.dev>; Thu,  6 Mar 2025 03:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741231076; cv=none; b=el8+hVzTFY94sJHWRYnXZJcpAz2jINMaZoKAxF9ZpYHQBiB02bjXR4GbPzbmOgJqhYsLKrvNXacXDXUNxob1PvgbaZOdNouIL7q8wvCy3xI8T/FtwomlzIkgcX2w2O8SRTbQXhMx4xmh5QpwuID4IArA2epKF7zJZkJmeNVvdJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741231076; c=relaxed/simple;
	bh=NetiTk2z2uS4piV1pabjw2+nl0oqy/DGbbGUtJ78j2g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=gamd/zJ7FOHoy/bfJJ4Wiea8O6e1B8qC0pmADb9p6gNItVMMfa1L8FCIHrEHGZWDKSN0OBfz8AKKLVS1Q5SCaMmmbnqe6mVs5QX+7HdtnETmGxuHEbV+Bny5FWcI6tezuYap760Rd7V3XGx2NfM8SnU4XqSowhjDZsgg/ZqxPBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dagnxedB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dagnxedB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741231072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eAFRXj70V5/NW5FZWsEcF9HXonHDHpj4IZnt/0NOE/g=;
	b=dagnxedBqBTDA0xaxVL0JRNTX6yRCzQaQj8LQlRwf3ceQx/aBFQLxGzT973kKbWJqgyrqP
	/7NqkaIgfZb7asnkzuXb++ohYgpBNgdii0SGI4F5NSHmYcOmQu4sroIxu4tGR9EtszXIJt
	mnh4WYzK9aUmblzqt6bnNTSkdBYZDxM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-551-4ivDEcI-Ov6ATq6aQ9qNdQ-1; Wed,
 05 Mar 2025 22:17:49 -0500
X-MC-Unique: 4ivDEcI-Ov6ATq6aQ9qNdQ-1
X-Mimecast-MFC-AGG-ID: 4ivDEcI-Ov6ATq6aQ9qNdQ_1741231068
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64EDF180025B;
	Thu,  6 Mar 2025 03:17:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D24091955DCE;
	Thu,  6 Mar 2025 03:17:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5263HkCW3103648
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Mar 2025 22:17:46 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5263Hk8I3103647;
	Wed, 5 Mar 2025 22:17:46 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] multipathd: add multipathd-queueing.service to gitignore
Date: Wed,  5 Mar 2025 22:17:46 -0500
Message-ID: <20250306031746.3103639-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mp74olBXKrjR-4hhwUMjUHmJckeMC6GzP3KoARqEH2w_1741231068
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 6a1f6fc2..d867ed81 100644
--- a/.gitignore
+++ b/.gitignore
@@ -25,6 +25,7 @@ multipathd/multipathd.8
 multipathd/multipathc
 multipathd/multipathd.service
 multipathd/multipathd.socket
+multipathd/multipathd-queueing.service
 mpathpersist/mpathpersist
 mpathpersist/mpathpersist.8
 abi.tar.gz
-- 
2.48.1

