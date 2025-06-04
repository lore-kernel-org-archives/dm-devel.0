Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AD115665C
	for <dm-devel@lists.linux.dev>; Wed,  4 Jun 2025 03:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749008116; cv=none; b=DkFCapYfwYYGt1ZUuZc+DNpvCIVlinTty6KNLJ5eXvP/47/Bpg0N79NfDb/0NE4FCYtDr8vK3ynUaeCUwiTluteBxSyr/dNvbFg3o0B9d5vXLG129a/qjrAeJrNZp2koSQoaG9s4yFQt3sFYGS0ZAWKcgtwGgXE+HCe05mQdLBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749008116; c=relaxed/simple;
	bh=sZpUcPKF3uRjamIUvqOmyViEScCRHL91qmgx5N3wf7U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=FDDtFnt7HzxIft8CuokKDof6s5Jq9EH8dnlB6XrBFC0OJ4klkXlG2ve2ltphTFo/0IODBE4L8YHpIN6YHp7JjiM7D8uawWdn1gO+8sQKYCjATOviBXZ53b6U8dtvFzzSQvPMmOzuUjkAS3WQCtGMxgNswCTyBXo8T8nWy4KQOP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EVRHBA8Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EVRHBA8Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749008113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ic0v5FFn3N/qqRxDqSYPm/kMSDs+sVBDZ2kegQ9tS64=;
	b=EVRHBA8QSUZpFUSOhUk1cvYd9UgI7p56u1Jk7tVfhvd2k5l1o2FDzER9E6eK2l+wZQOwmA
	gRSzTTcDIIR42R/ntYZIjrGbdqTmXD+3ThvIt3XtX8VjFTweIt//65v4oq3nNgepHYziYg
	7IidPuxYW/tyy4FEKNKFSxfjrxe8MLc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-pErqBRI8PAu8t0WUXrsV5Q-1; Tue,
 03 Jun 2025 23:35:09 -0400
X-MC-Unique: pErqBRI8PAu8t0WUXrsV5Q-1
X-Mimecast-MFC-AGG-ID: pErqBRI8PAu8t0WUXrsV5Q_1749008107
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 029D7180AB1F;
	Wed,  4 Jun 2025 03:35:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B489B19560A3;
	Wed,  4 Jun 2025 03:35:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5543Z5j92121577
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 3 Jun 2025 23:35:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5543Z4pU2121576;
	Tue, 3 Jun 2025 23:35:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/2] libmpathpersist: reserve and release fixes
Date: Tue,  3 Jun 2025 23:35:02 -0400
Message-ID: <20250604033504.2121566-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: impXHC3wSyLBKDIyA1D0yg1UcxqQgp2ikk3j__9DPdM_1749008107
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

These are two patches libmpathpersist patches. The first deals with a
possible race condition where mpath_prout_common() can fail because a
path went down after libmpathpersist checked its status but before it
handled the prout command. Previously libmpathpersist wouldn't fail
without ever trying another path in these cases. The second patch
keeps libmpathpersit from being able to remove a reservation that
is held by a different key than the releasing device. 

Benjamin Marzinski (2):
  libmpathpersist: retry commands on other paths in mpath_prout_common
  libmpathpersist: check released key against the reservation key

 libmpathpersist/mpath_persist.h     |  3 +++
 libmpathpersist/mpath_persist_int.c | 20 ++++++++++++++++----
 libmpathpersist/mpath_pr_ioctl.c    | 24 +++++++++++++-----------
 3 files changed, 32 insertions(+), 15 deletions(-)

-- 
2.48.1

