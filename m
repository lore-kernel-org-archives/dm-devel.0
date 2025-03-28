Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C505E3C0C
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 15:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743175161; cv=none; b=RLIIZA52LeKpOPcUjkMJSi09G/Y5gUfnalJi1blu/vSAk9V1x3Q+ZZW6HF2OLoiFD0RJ7rwxmwhn5C4mLtNbAyp2f8Nz0HvEPcebE0hkWUEqqV63+fyj1+xT4OM9WQsUFJRqj887sXdTGyPEFRU2/viA689OwoA108nK0GfrArk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743175161; c=relaxed/simple;
	bh=UjtZS0F1y21KphDNCU29PyIZMUOAGoXmUW7TDwRos9E=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=G5MUwsMmcuHuAs0H9jrhNX8wuCzeCr9HnsiysueJlPOPt97XMu1WBqycTwEiDWGTje1U2mJEcbI6hptd7tUN1c/ygJZY5Gi9rG7cvt7kL525jO7zANH/vxw6PRi6yBZ5pUJmzMPcSZnWQPe5zkicO/e8hjEU9oy02PWPVIaUrUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JZmqdj50; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JZmqdj50"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743175158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=hDjyJO/CJkoe5rgKMAyTkxuecZjFaEBVlAh6W2Ub9Wc=;
	b=JZmqdj50vb7pnFnL/F/vfT9B/djQWsfQGOAaFJnFnfXAqS1aMiLaa1Ls3ldefE95tlslmg
	wrrUOwr7aGZH9crJM4qSGs4TYAz68zq5UIvFs1I8RnK3jH85Vvgn3EHIyufxED+dd3HoaO
	OPA4lR6fcpW8SJcBu7zJ3QMRcKpRQvk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-FC-u2a34MW-lyFZEFJnQfA-1; Fri,
 28 Mar 2025 11:19:14 -0400
X-MC-Unique: FC-u2a34MW-lyFZEFJnQfA-1
X-Mimecast-MFC-AGG-ID: FC-u2a34MW-lyFZEFJnQfA_1743175153
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4019196D2E5;
	Fri, 28 Mar 2025 15:19:13 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 45A7830001A1;
	Fri, 28 Mar 2025 15:19:12 +0000 (UTC)
Date: Fri, 28 Mar 2025 16:19:07 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-ebs: fix prefetch-vs-suspend race
Message-ID: <cd746c88-fcfd-12c0-8d57-29881ec4c96c@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x_QVX6QMioVd-lG4bUjx2N6PLqnNwyy9QHMEW2Yus0Q_1743175153
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There's a possible race condition in dm-ebs - dm bufio prefetch may be in
progress while the device is suspended. Fix this by calling
dm_bufio_client_reset in the postsuspend hook.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-ebs-target.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6/drivers/md/dm-ebs-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ebs-target.c	2025-02-24 12:41:49.000000000 +0100
+++ linux-2.6/drivers/md/dm-ebs-target.c	2025-03-28 15:41:13.000000000 +0100
@@ -390,6 +390,12 @@ static int ebs_map(struct dm_target *ti,
 	return DM_MAPIO_REMAPPED;
 }
 
+static void ebs_postsuspend(struct dm_target *ti)
+{
+	struct ebs_c *ec = ti->private;
+	dm_bufio_client_reset(ec->bufio);
+}
+
 static void ebs_status(struct dm_target *ti, status_type_t type,
 		       unsigned int status_flags, char *result, unsigned int maxlen)
 {
@@ -447,6 +453,7 @@ static struct target_type ebs_target = {
 	.ctr		 = ebs_ctr,
 	.dtr		 = ebs_dtr,
 	.map		 = ebs_map,
+	.postsuspend	 = ebs_postsuspend,
 	.status		 = ebs_status,
 	.io_hints	 = ebs_io_hints,
 	.prepare_ioctl	 = ebs_prepare_ioctl,

