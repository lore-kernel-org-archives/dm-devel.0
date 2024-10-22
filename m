Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1046148FEB
	for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 07:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729581148; cv=none; b=rP43BN2mV3F/8sbyTEcja6hkYQeDSanMYlW21OnQLqY6/OzlhhUD+ZI/GXHLhDL7H2G3ODt452HsVt33Y5N3OyVXT3ocM7U2Cd4BkTrBFXdISPCtIVJk0uog3jfpHrm8yPfHB/Zxlls2iagccuA5EAdVxCOT6woeGPioUm2AmQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729581148; c=relaxed/simple;
	bh=Km50rYp8S9mnhb/sHkpqdRG8B7sSxz7kAcjt4h/YAcM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S6+U8waRhD/S3braE9eWmnehprdQhU1Ha5xvX11BirQhhl66+SVn1GW/bubZBlgV8qwPbx8YsiBufahZMESOuZzilaBCFCyg6kLh9qvzjZo4L8U52oeb7tlWIIxDJ5Hr2P//WjNldRP3jQwhtkPnc2g2Ufq/xdZet+inXI5juA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZiZ0S7kq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZiZ0S7kq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729581145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=m6h7m+loEYctk136TgxbvTpV8jwGViB5lI37p9V5j8s=;
	b=ZiZ0S7kq7ti7J8Cen/fOkhc8YUXKugjl4KndNWE+XWPyw1obP4TIw3Z1omUFKaKtd4AB3E
	+0c4qjqEd1ddRjRgnPWQ5i/Q471vBl9yA46XHybsNBgA1XmyX651+4BN5T1ZYKuxMwAkMU
	mBh5KU+oyox03z8fv8HVaBECCBcrw3I=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-mTk3nAVAOXC5GUVuRIaSdw-1; Tue,
 22 Oct 2024 03:12:22 -0400
X-MC-Unique: mTk3nAVAOXC5GUVuRIaSdw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BC991955D45;
	Tue, 22 Oct 2024 07:12:21 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.92])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7326E19560AE;
	Tue, 22 Oct 2024 07:12:16 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	thornber@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 0/5] dm cache: fix OOB and error handling in cache creation and resizing
Date: Tue, 22 Oct 2024 15:06:11 +0800
Message-ID: <20241022070611.777552-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patch series addresses various issues during cache device
initialization and resizing, includes out-of-bounds memory accesses,
flushing uninitialized delayed_work, and optimizing bitset checking.

Ming-Hung Tsai (5):
  dm cache: correct the number of origin blocks to match the target
    length
  dm cache: fix flushing uninitialized delayed_work on cache_ctr error
  dm cache: fix out-of-bounds access to the dirty bitset when resizing
  dm cache: optimize dirty bit checking with find_next_bit when resizing
  dm cache: fix potential out-of-bounds access on the first resume

 drivers/md/dm-cache-target.c | 59 ++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

-- 
2.47.0

