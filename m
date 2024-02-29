Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE1036124
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 01:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709171897; cv=none; b=eUqVRhbeniAURO9yiyJ04poDHTWEFNaFTCImgnhd2nLhMQVgICAhBCqawf26bGEl1gSkL68NJXNb3vZnUk+nuA0o37foMcCw5aXpUh1EbpyEENia9Vz2WJtNBXqV1MhRkKxYy38cJwkA2pkbkRYEKPAYKRBSi1yWdbFzrKJydgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709171897; c=relaxed/simple;
	bh=IYig77YEv1NKxK+R1MxmG87N8OelSY22SDj0xOuRrXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RyL9gce//ujnkEoxansG8+C63sZE23yfDQCp7TfNVYO998J47JbWRZ0wP/e2NM4JlFH+jcoUm0mwznJ/348Eor5gZha6B2oaq4ddB4/1fDkGx+iWAB4vMpoDysKKR1PwhIgOGRzlkWKNq8Uqo6aGHBDaMbtR8Pko/kdWEsKREF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dT6Fo9OK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dT6Fo9OK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709171894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jixexeCnL2JWSdvup7vdXN4oKQ42WOX6Non5+vXo4v0=;
	b=dT6Fo9OKOeZDgQq4MGDx6NtMDHiBK/o7jey1Rq8EnEXEfCK+8oldy7+7eOjmqhS/usHm8E
	+L9EJgmZCOtZpy/siET6nXyRBrgd6lTL2YYepQii8aYDNjQflJfZYIgR9VmAj/KelS0JOZ
	/4oQ4NDi3v1sqC9urD7wt8AIJtZyMqQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-xG_-cM6mORSIpoGeu4axmA-1; Wed, 28 Feb 2024 20:58:11 -0500
X-MC-Unique: xG_-cM6mORSIpoGeu4axmA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B01D4845E60;
	Thu, 29 Feb 2024 01:58:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A42DE492BE8;
	Thu, 29 Feb 2024 01:58:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41T1wAcp686429
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Feb 2024 20:58:10 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41T1w9qK686428;
	Wed, 28 Feb 2024 20:58:09 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        sushmbha <sushmita.bhattacharya@oracle.com>
Subject: [PATCH 0/2] Add sched_prio config option
Date: Wed, 28 Feb 2024 20:58:07 -0500
Message-ID: <20240229015809.686418-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patchset is based on discussions at:
https://github.com/opensvc/multipath-tools/issues/82

The first patch fixes a condlog logging level, and the second patch adds
the new config option, so that users can change multipathd's realtime
priority or stop multipath from running ched_setscheduler() at all.
After we do some testing with multipathd not using a realtime policy, I
think we can probably change the defaults

Benjamin Marzinski (2):
  multipathd: use condlog level for setscheduler error message
  multipathd: Add sched_prio defaults section option

 libmultipath/config.c         |  1 +
 libmultipath/config.h         |  1 +
 libmultipath/defaults.h       |  1 +
 libmultipath/dict.c           | 23 +++++++++++++++++++++++
 multipath/multipath.conf.5.in | 13 +++++++++++++
 multipathd/main.c             | 11 ++++++-----
 6 files changed, 45 insertions(+), 5 deletions(-)

-- 
2.43.0

