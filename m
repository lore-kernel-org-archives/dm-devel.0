Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A43241C63
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 03:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764644540; cv=none; b=Hm4KBdF0YS73K2oXhUQdmFy98A2OikWQ98i7U371ObafC2gUTLwmk10gWVG5Kwdz/QlnfS43rFby9Ub3wsawrGBYxnXLaphut+IknCXGaN7+xHsns1nKvveTbwCEm3z7NxpVVugp46JmNipUa+OzzsEdFdADcBMZ5QhM8yJniMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764644540; c=relaxed/simple;
	bh=GVcf/c2eCGniPW2TShR6Fu/RET9haEG6E9Hz3cA1zBk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=JEPsckTsSsJ0YRzEUbjN9ey4LC2xeOz4OBbtnLoM0kMu1whJ6cjgHrx42Wkgk7ylUa8VUCwaSao4Y9FUjbK9XHCYEWupOv6acdz3WZsslk5PjdBRhosgGUT7uhzNdIr2gibsAb8SsRtDHR+ItxwPdSYOm5plGqwcighEkhVBYoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E5zVl8sT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E5zVl8sT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764644538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dKyG9HV51K6+ME0VIpQfcpCvakILqrRh4/SeIfJvB5I=;
	b=E5zVl8sTcIcnecYq71VZ3glUUtCWcI8Cs7e4MBVowdWtJarL+1pZ6A46O25fYDpa1D1HG3
	IexIPD+bpz38YEGCMLjyYgFXPHYm3sgEXl+lWpOm0ydnLas4KH4e0suxSfhYFhsftt7R8a
	6ZUfzzCsfuhiESda/LCVGgu6exB2EF8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-164-eSzBC9gBPfOP7UuhUVU6GQ-1; Mon,
 01 Dec 2025 22:02:16 -0500
X-MC-Unique: eSzBC9gBPfOP7UuhUVU6GQ-1
X-Mimecast-MFC-AGG-ID: eSzBC9gBPfOP7UuhUVU6GQ_1764644535
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0CEB195608E;
	Tue,  2 Dec 2025 03:02:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2EEE11956095;
	Tue,  2 Dec 2025 03:02:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5B232DEC1432977
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 1 Dec 2025 22:02:13 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5B232DbC1432976;
	Mon, 1 Dec 2025 22:02:13 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/4] multipath-tools: Yet Another PR fix
Date: Mon,  1 Dec 2025 22:02:09 -0500
Message-ID: <20251202030213.1432964-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8BfS3vqzM-6mix5duFXu7yvD7fBv_d1A62qqyFqKsfo_1764644535
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

I ran into some cases where checking the number of registered keys made
multipathd think all paths had been registered, when they hadn't. The
last two patches in this patchset rework that code. The first two are
just fixes to other issues I happened to notice while working on this
code.

Benjamin Marzinski (4):
  libmpathpersist: fix register retry status checking
  multipath-tools man pages: fix multipathd commands keyword ordering
  multipathd: remember number of registered keys when ioctl fails
  libmpathpersist: fix code for skipping multipathd path registration

 libmpathpersist/mpath_persist_int.c | 20 ++++----
 libmpathpersist/mpath_updatepr.c    | 48 ++++++++++++++-----
 libmpathpersist/mpathpr.h           |  4 +-
 multipathd/callbacks.c              |  1 +
 multipathd/cli.c                    |  1 +
 multipathd/cli.h                    |  2 +
 multipathd/cli_handlers.c           | 39 ++++++++++++++--
 multipathd/main.c                   | 72 +++++++++++++++++++----------
 multipathd/main.h                   |  3 +-
 multipathd/multipathd.8.in          | 24 ++++++----
 10 files changed, 155 insertions(+), 59 deletions(-)

-- 
2.50.1

