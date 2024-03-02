Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E6D6FB5
	for <dm-devel@lists.linux.dev>; Sat,  2 Mar 2024 00:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709339865; cv=none; b=BH+q8j8swcvqHkqgJinIr9J2CkhtO9QVtkIIj2K6wsoC+qRZ+r9tvX6n7O4gT81QSl+hwKd9be3Hq3MThYGg2c6T7MbbpYH4lpfUtBPQIHE3If+6zDQNLC95GXCQtkhKoN7mB9dw7kLNd0gREdDjV1o9b3R/69cBlmXQEn9MMn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709339865; c=relaxed/simple;
	bh=5qaUK7UXvgOFM9mOb9phRLhyKlpRsLa9D5H0xGdFPL0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qhXnlaIv1hm+tt5OQowOkhdWe7P2n0gJkhR1WvRYjHap6qNzWSYrZRyAen0jpuN8lqMLoBohopM/fEKvJY5NPQuvv23+fokJFPxeZ4xmS1NEOt8tNUvCTP2EOtk6FU0Faad5CkYI9XnuofdAQcjSovfI2Af35CUCs3EFT9pmcTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VRTw4IIk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VRTw4IIk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709339862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kuY1lHVinRdDcv3NWOGxi0X8POeJcBE2Pfk+U+BDyII=;
	b=VRTw4IIkK2EZ/5AIjZyovN7LmvTsYNfikugOsxtaWhoV/X/ZICy5zClAolGyu7U4zuS1sY
	+h6dm1EhCmie/IGvZ2v6mkq/8Eej4zzTfZGaVnLT+UjFpPt7cY+SRClpFRO/1bctajRv9W
	8olMcCLMaSBQDvLQ+oPD2dBJdWbDJxQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-t4p1YwNtPHK8kdOKdajfSQ-1; Fri, 01 Mar 2024 19:37:37 -0500
X-MC-Unique: t4p1YwNtPHK8kdOKdajfSQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8B54185A784;
	Sat,  2 Mar 2024 00:37:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB6FAC185C1;
	Sat,  2 Mar 2024 00:37:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 4220bUKi782705
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 1 Mar 2024 19:37:30 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 4220bUd0782695;
	Fri, 1 Mar 2024 19:37:30 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        sushmbha <sushmita.bhattacharya@oracle.com>
Subject: [PATCH v2 0/2] make multipathd scheduling configurable
Date: Fri,  1 Mar 2024 19:37:28 -0500
Message-ID: <20240302003730.782685-1-bmarzins@redhat.com>
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

This patchset is based on discussions at:
https://github.com/opensvc/multipath-tools/issues/82

The first patch fixes a condlog logging level, and the second patch
makes it possible to turn off realtime scheduling or adjust the priority
at compile time. After we do some testing with multipathd not using a
realtime policy, I think we can probably change the defaults

Changes from v1 (suggested by Martin Wilck):
02: make scheduling configurable at compile time, instead of by a config
    option.

Benjamin Marzinski (2):
  multipathd: use condlog level for setscheduler error message
  multipathd: make multipathd scheduling configurable

 Makefile.inc        | 6 ++++++
 README.md           | 3 +++
 multipathd/Makefile | 3 +++
 multipathd/main.c   | 7 ++++---
 4 files changed, 16 insertions(+), 3 deletions(-)

-- 
2.43.0

