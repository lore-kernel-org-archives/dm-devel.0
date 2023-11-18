Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D330BA38
	for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 00:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iH9fmjn/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700267647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+h65ibuj8hYEUieRtmIpCHkKO+gVkeLp+C3AkWcFRIU=;
	b=iH9fmjn/3aXTw2k7W3W25/am3S6O1LFlpFInFGZcY8Kb/Rfv7f19//BfqIFszxkTLUVKfw
	ujZoE70pT41Gr6D0l5SXXAhgrCKOEhQcTtzlWumkZs3E4j62Oby5WCXljd7TFsDc1Mv/En
	uq6Mg8+nsgOkZdS26xgqAXTlT0m+ds4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-523-rRrxX6VYMU2qp7zuvjliEA-1; Fri,
 17 Nov 2023 19:34:05 -0500
X-MC-Unique: rRrxX6VYMU2qp7zuvjliEA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B71D329AB435
	for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 00:34:05 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC0E540C6EB9;
	Sat, 18 Nov 2023 00:34:05 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id 709813003C; Fri, 17 Nov 2023 19:34:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 0/5] dm vdo io-submitter: clean up interface
Date: Fri, 17 Nov 2023 19:34:00 -0500
Message-Id: <cover.1700266895.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Update function names and eliminate unnecessary helpers.

Mike Snitzer (5):
  dm vdo io-submitter: remove get_bio_sector
  dm vdo io-submitter: rename to vdo_submit_metadata_vio
  dm vdo io-submitter: rename to vdo_submit_flush_vio
  dm vdo io-submitter: rename to vdo_submit_data_vio
  dm vdo io-submitter: rename to vdo_submit_vio and submit_data_vio

 drivers/md/dm-vdo/block-map.c        | 40 +++++++++---------
 drivers/md/dm-vdo/data-vio.c         |  4 +-
 drivers/md/dm-vdo/dedupe.c           |  2 +-
 drivers/md/dm-vdo/io-submitter.c     | 63 +++++++++++++---------------
 drivers/md/dm-vdo/io-submitter.h     | 28 ++++++-------
 drivers/md/dm-vdo/packer.c           |  2 +-
 drivers/md/dm-vdo/recovery-journal.c |  6 +--
 drivers/md/dm-vdo/repair.c           |  7 ++--
 drivers/md/dm-vdo/slab-depot.c       | 42 +++++++++----------
 drivers/md/dm-vdo/vdo.c              | 18 ++++----
 10 files changed, 104 insertions(+), 108 deletions(-)

-- 
2.40.0

