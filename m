Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F2E1C683
	for <dm-devel@lists.linux.dev>; Fri, 20 Dec 2024 02:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734660184; cv=none; b=YtKTGc+VQm/KedYRNxb4q2K2lUbTcszhzjR7iA+iMINg7KwhWAjdmtLdr8TtQmsLnHA4vnCMtCmjjI9KLjE2+GHU4Xc1KNOOO9AiEhaDbrTemxPIVTON3QTnmuagmCjRDEY9lC8NJC3K5L7u8qBOQQF0hAa7CaO5z1HEK/IU6GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734660184; c=relaxed/simple;
	bh=KphF6qejrR0OY0nmHfg1SCoRoU7jxyOn7zBzNLkXR7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=F8nvg9kLkQ7tKtQw/mVq7G6ywwa1rY7yMKfv50kEPTVUvwT5ilx96SyzE9jyhYz7ZoFLkhngZqhjfkVfPjgQISgyPLEqEMWjeAd29gRByDYKFy4qxnOmEr4E2pMT5cfrxtFkl5hc0Iw7PWOKWj9t0NfqEOBmdo8TZKA75u5KHOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hGJrdfpV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hGJrdfpV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734660181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KbEnWwSdBnUqrY+s/0uupwvjaJMA9mIseRqd/zW09aw=;
	b=hGJrdfpV+ka8krQEkFOBa/Y+PPk7ZZQpNFj1/nAXyhQJvORezhvLnH2qslLkegrLw5gFVi
	GqZ1lQWOksdYU3nvhsXf/PxbPQE6b5l9Uvjsmyj52g58chL03XoYPm7ygaigwivEQqfTpo
	HJi6x8885+zEV+qRJqaPoiak9Of+4zM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-18-C6ILFvKMP4KAPhLXw8XLCA-1; Thu,
 19 Dec 2024 21:03:00 -0500
X-MC-Unique: C6ILFvKMP4KAPhLXw8XLCA-1
X-Mimecast-MFC-AGG-ID: C6ILFvKMP4KAPhLXw8XLCA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0207A1955D55;
	Fri, 20 Dec 2024 02:02:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A62BE1955F54;
	Fri, 20 Dec 2024 02:02:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BK22arq1759386
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 21:02:36 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BK22ZUn1759385;
	Thu, 19 Dec 2024 21:02:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Muneendra Kumar <muneendra.kumar@broadcom.com>
Subject: [PATCH 0/2] multipath: set rport port_state on NVMe FPIN events
Date: Thu, 19 Dec 2024 21:02:33 -0500
Message-ID: <20241220020235.1759375-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TUxbWI3qVCy-BZ93wFOmd_wLGZdkYgYUbzZuPFBEfZo_1734660179
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When multipathd handles link integrity FPIN events, it sets the rport
associated with the effected SCSI paths to Marginal. These patches make
it do the same thing for NVMe paths.

I actually have a stupid Fibre Channel question. Does the host number
and the target wwpn uniquely identfy an rport? I never see the channel
set to anything other than 0, but I don't think that it MUST be 0. But
if we knew that there was only one rport for a given host number and
target WWPN, we could stop checking as soon as we found one. These
patches don't do that. They check all the rports.

Benjamin Marzinski (2):
  libmultipath: export udev pthread cleanup functions
  multipathd: set rport port_state to marginal for NVMe devices

 libmultipath/discovery.c          |  4 +-
 libmultipath/discovery.h          |  2 +
 libmultipath/libmultipath.version |  6 +++
 multipathd/fpin_handlers.c        | 74 ++++++++++++++++++++++++++++---
 4 files changed, 78 insertions(+), 8 deletions(-)

-- 
2.46.2

