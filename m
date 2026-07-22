Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD215361972
	for <dm-devel@lists.linux.dev>; Wed, 22 Jul 2026 16:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784736859; cv=none; b=myXSQWmb6oVcQTOaQcuhakZkH+MS2xjRVPgVM9YVxt29TX3pCidEqB/pQMIjecOfGFcJ06YKWyZYhz6Otx89Vl4o9Dhv7L0lyLl4e5t4LS/GDZ4LN6OoFA5lz0mhwGsKFp4Nl/NMSwwEdHmtQgfPV68qqs9bl3EiEbZgw7iM7dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784736859; c=relaxed/simple;
	bh=zZSRjKIUu561WSAK9qeD5q8tJGO4IuVnXWLCjLH8+eY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Rhs0HqHU3xWGixQmW7OIQm1hzO5qXTTAMiOUULnL+lBT6fbgvj3yhGFz40FSkWR5Y6ZjWcMKbO/0WS/GslnfCGDOGFtldggJ0/EgUYNohenhRJ3VLUUbBJpYVUFJlpldhyjE/xFPZMwpOkbt9X+heb7JDEZYyE9StVmtqo7ts+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OvX5OQ4k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OvX5OQ4k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784736856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GG8CuwzAfwHLKzzy9zLI0CXfaqSyvjUOjY82/Cc040s=;
	b=OvX5OQ4kkBoab04yckWVL/CKswSssfmOUC0XdIin+yDJbPgJ8SliRN2DqsZ359JyUqMowz
	OyVzA/Xny1v2kYZTwv7Tq1gqTSDor/bz4I/+pdI1nT2Iq+jJYWcMu2YcY6maAgR02yIkVJ
	qD15YBon4aJxfwdvvNIlqK6rn7PV0aw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-167-iD6RB3oMNxmbcb3ClNkm4Q-1; Wed,
 22 Jul 2026 12:14:13 -0400
X-MC-Unique: iD6RB3oMNxmbcb3ClNkm4Q-1
X-Mimecast-MFC-AGG-ID: iD6RB3oMNxmbcb3ClNkm4Q_1784736852
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBFF618002FB;
	Wed, 22 Jul 2026 16:14:11 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 137AC180058F;
	Wed, 22 Jul 2026 16:14:09 +0000 (UTC)
Date: Wed, 22 Jul 2026 18:14:03 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Junzhe Yu <junzheyu1@gmail.com>
cc: snitzer@kernel.org, bmarzins@redhat.com, agk@redhat.com, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [BUG] dm-integrity: dangling reboot notifier after resume vs
 remove race
In-Reply-To: <2582d759-1e99-4a31-9a1b-5eccf0af3891@gmail.com>
Message-ID: <0ce40d40-1a42-7ee8-2fbd-6e1e8f9ce4b9@redhat.com>
References: <2582d759-1e99-4a31-9a1b-5eccf0af3891@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: _gfv4nP9mmsigtu4czl_xY53bPvwNMt67l5n1zZwxLI_1784736852
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Sat, 18 Jul 2026, Junzhe Yu wrote:

> Hello,
> 
> I am reporting a KASAN slab use-after-free in dm-integrity involving the
> reboot notifier registration path.
> 
> Summary
> =======
> 
> A late do_resume() can register ic->reboot_notifier on a dm_integrity_c
> object that a concurrent DM_DEV_REMOVE path is destroying. The removal path
> unregisters the old notifier via dm_integrity_postsuspend() and later frees
> ic in dm_integrity_dtr(), but does not unregister the notifier that the
> racing resume just installed. The global reboot notifier chain is then left
> with a dangling node; a later notifier_chain_register() walk touches it and
> panics under KASAN.

Hi

Does this patch fix it?

Mikulas


dm: fix resume-vs-remove race

If the user issues the resume ioctl and the remove ioctl at the same
time, it may be possible that the device is resumed after it is suspended
in __dm_destroy. The result is that the table is destroyed without
calling the postsuspend method.

Dm targets expect that they may be removed only after the postsuspend
method method was called. If we break this expectation, it can cause
misbehavior in various targets. For example - in the dm-integrity target,
the reboot notifier is not unregistered, leading to use-after-free.

Fix this bug by refusing to resume if the device is being destroyed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2026-07-13 20:58:56.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2026-07-22 17:40:29.000000000 +0200
@@ -3140,7 +3140,7 @@ retry:
 	r = -EINVAL;
 	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
 
-	if (!dm_suspended_md(md))
+	if (!dm_suspended_md(md) || test_bit(DMF_FREEING, &md->flags))
 		goto out;
 
 	if (dm_suspended_internally_md(md)) {

