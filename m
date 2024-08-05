Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55636770F5
	for <dm-devel@lists.linux.dev>; Mon,  5 Aug 2024 15:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722871662; cv=none; b=eezJr7I/tKjfmQw+zBXQtqnCo+LmKLcr+5+Y2AYALTpxcfuN81ytWeQNCRSV0ZO9SqZiEpfGRns0lDRquqV0ceR5vuy/2I/382dUdyDsFeZICzbPXNkdGdkm4cDCW83o42Agm91wYxZY4/QzDYqxknW5Q2H3qJOFwhg9M+8zA84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722871662; c=relaxed/simple;
	bh=hxRY3ugPzahtlJ8uky/sfXgV1yIeyy/QzuvDtaq8kEY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=Y2y+bpqlS0GHz9kxNa3N97J9ilaY2J+dWSp/LXnraHjjSdZ0Yem+ef1MlJGAnjjt+RN/POD4IhA0P4Zk7J94F1cA+D4hACQ/VlG6VCM4wuwc918r/c4D6ABXXYLCHNGDK9GyFgbPMedyWoJTWcCfIYEzkP/1+BOcnMGK2ZgPq8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HsTKFQYK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HsTKFQYK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722871660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=vNZpfi1ggYr8TiK+jucofPwRIqJVZNg4BEDMG6gzA30=;
	b=HsTKFQYKZTG5DWiLYNqAvpUzop3WZBm38x/EhgbC/s3Y5VZHLbxH46YryZ8vM01MaL0J39
	ayzNUkA4lUIf/qLZ6l080f7v9yDcS3RE2O5Nhy4eNaZEbdf5Wc9PgDPVVDYyjVkJC99Zt/
	Cqp15aTp6wGspYQQmltowYpa5UO4Zck=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-m1vkRD4HNpO_A6RebKAxUA-1; Mon,
 05 Aug 2024 11:27:36 -0400
X-MC-Unique: m1vkRD4HNpO_A6RebKAxUA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B3A01955BEF;
	Mon,  5 Aug 2024 15:27:35 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1258919560AA;
	Mon,  5 Aug 2024 15:27:35 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 04C4D30F3625; Mon,  5 Aug 2024 15:27:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 020FE45586;
	Mon,  5 Aug 2024 17:27:34 +0200 (CEST)
Date: Mon, 5 Aug 2024 17:27:33 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Khazhismel Kumykov <khazhy@google.com>, 
    Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: [PATCH 1/2] dm suspend: return -ERESTARTSYS instead of -EINTR
Message-ID: <ef2ae856-54dc-4428-a8e-47efedc52e1@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

This commit changes device mapper, so that it returns -ERESTARTSYS
instead of -EINTR when it is interrupted by a signal (so that the syscal
will restart the ioctl).

The manpage signal(7) says that the ioctl function should be restarted if
the signal was handled with SA_RESTART.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2024-07-30 14:06:55.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2024-07-31 18:10:21.000000000 +0200
@@ -2737,7 +2737,7 @@ static int dm_wait_for_bios_completion(s
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 
@@ -2762,7 +2762,7 @@ static int dm_wait_for_completion(struct
 			break;
 
 		if (signal_pending_state(task_state, current)) {
-			r = -EINTR;
+			r = -ERESTARTSYS;
 			break;
 		}
 

