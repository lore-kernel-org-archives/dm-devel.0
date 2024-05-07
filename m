Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C2053E16
	for <dm-devel@lists.linux.dev>; Tue,  7 May 2024 21:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116590; cv=none; b=RNpyEtkvs0R0AZwz4dHeOW6D5tJD1rwUybFJj3KygLlQG4t44lpGWdQlR4RoIQ0qaGO+3Ulx6JEFxzIGGHYXCOyPPWu6DR6/CyuQaoFLgbOGtRdfdEISYAVUn+E4H2c5O1hGv9NPRS7hnoclB74EOh4oyYawNvb+ZYOjdUB7U5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116590; c=relaxed/simple;
	bh=Q1vGruqUKrNM46alBEBrrB7+4TNSfAh4HfgKgzfD448=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jmFi59YVNPTdWqxifyiIAg+gVL/5tKuMrCGHKBS9ncTgbxBou9rMjtwh7fHjTBEs+HHAdlyrAZF1fqprstfhPyoBLDc8Thdsn23tm3ZU0QYn8gL8tvk3JoZVZysUFivYlI/vxz10JgpzU+Ga5u229jpnc09SXUIky8T5/bcJ7eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IdN0HguJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IdN0HguJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715116588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Cv2VuPrihKdd/sTtrx06MuGPRuxXldtdGlYk7ty0KZA=;
	b=IdN0HguJtA51es1m8uBQA5tk+Qy8divr4Skbj0qDQMY48ZcHJUZye5ArMpg9vQD+CRejtW
	S93R67M8yr9YcBoYB67NsLmU/M9K2EHvpkFBzaqJm/OFZCQahzVfIHp8I+gATGf4XzdQ/z
	lE9wM5TwnlKU3AaPmxnTebIFNvfnm6Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-KPOYcDTROTmBC7sibPCUGg-1; Tue, 07 May 2024 17:16:26 -0400
X-MC-Unique: KPOYcDTROTmBC7sibPCUGg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 871F880021D;
	Tue,  7 May 2024 21:16:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 434FF4750A0;
	Tue,  7 May 2024 21:16:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 447LGQci026718
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 7 May 2024 17:16:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 447LGQ7S026717;
	Tue, 7 May 2024 17:16:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Heinz Mauelshagen <mauelshagen@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 0/3] dm-delay synchronization cleanup
Date: Tue,  7 May 2024 17:16:22 -0400
Message-ID: <20240507211626.26706-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patchset fixes a possible crash in delay_dtr() caused by the
delay_timer queueing work on a destroyed workqueue. It also cuts down
on the amount of locking and waiting the dm-delay does.

Benjamin Marzinski (3):
  dm-delay: fix workqueue delay_timer race
  dm-delay: change locking to avoid contention
  dm-delay: remove timer_lock

 drivers/md/dm-delay.c | 52 +++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

-- 
2.45.0

