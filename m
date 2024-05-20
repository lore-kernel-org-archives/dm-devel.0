Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F94D3611A
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 23:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716248291; cv=none; b=gzyjFmeZw1cdRce6eCNsDxu7XXCQ+gcQhTaiTB7IcN83jznFIB3P0/LrmfMOjrxyMzKUDsydNMoxsC2cxyKIDqeTxbq3BJQfjIhD32sTJPECzWt/7RrKvkZqzwcAZW6i+esfPEA+jBHf+42MNHTVq/XblWXF47xWWClMj5+dmJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716248291; c=relaxed/simple;
	bh=4bt++waHQ2R9Zb+35vuWAqwJuOZtjry6e4NbK1b92Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SVbRR/iO3NiqSMnJoMUZQx62zitDgsJpeFXDuyz1WQPa2jg1tuyCgC3mdACRACQw37hhCO+oZV58/xc5YLbyC10dq9KmxIs3o6S9SyN+0wtycv8Mw0Qo6VUgFSmvrA/btQ3j4gWSWGdb1dClBoFeKZFPbqhX1n33WnYLGcG6xfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U4pV8Hiy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U4pV8Hiy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716248287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fauhI+WTcIHybbUJ8pD1S39Ntn+ZMExqf1NyHL9VO5E=;
	b=U4pV8HiyCYhb4EZojd4hqH2dWsR4ciTfzqLr6u4CXZ7IbAvDHMbceRmadR+fS7BQ3ByIG8
	4OTi6UWQcUrSmHzQEMM2Fg8d62HBaR5B8+qfAt6YwNHKcSDkrxwEafd/LMtQd3R5afOMJr
	V73b0JB1ZBlUjXJBqLVQQQoi/IUMRDA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-XkeEGymNNfO4XtB35qu82g-1; Mon, 20 May 2024 19:38:04 -0400
X-MC-Unique: XkeEGymNNfO4XtB35qu82g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13436185A780;
	Mon, 20 May 2024 23:38:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 07E252026D6E;
	Mon, 20 May 2024 23:38:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44KNc3Z5190804
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 20 May 2024 19:38:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44KNc3Hl190803;
	Mon, 20 May 2024 19:38:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/2] multipathd: accept more multipath device names
Date: Mon, 20 May 2024 19:38:01 -0400
Message-ID: <20240520233803.190793-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The multipathd commands with a $map argument will only accept
dm-<number> and aliases for $map. Make them accept WWIDs as well. Also,
change find_mp_by_str() to not skip devices with aliases of the form
dm-<something_that_starts_with_a_number>, which are horrible names, but
still valid.

Benjamin Marzinski (2):
  libmultipath: accept poorly chosen aliases in find_mp_by_str
  libmultipath: accept wwids in find_mp_by_str

 libmultipath/structs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
2.45.0

