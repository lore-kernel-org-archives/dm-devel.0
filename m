Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D7C1B85CA
	for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 18:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727201461; cv=none; b=vBA42zZ7fBbiwxTpu+cxUS0QImNtLeAg+gO2GF9HAzI0dsjxZaDtx20PnCi2HY1HpnXGRjruFOWvXtjI3P1g6UB/iAhlLg4EfHWGAyn6lclWslqj6NW8u0AlHI8wPwCV9RgRIklYtU26hIwYOmjKDuP6RdJl4BXscTHgrldbhiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727201461; c=relaxed/simple;
	bh=R3GKGJIkH5RtELdr2cC79aQSmcge0vC2kFB19nFQZeU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nKWW3mmuJ0oHQAVDHyJ+BerVRi1UXbICfBHqCPdDs98rp9+AeKCztrB01nfXogI/nTDhxpfEKTO7Wk6lSauRsPYllQMXa3VzX4yiHiamWLvnlCzWLfoYw+znMtujmun14MC4JfH/1hs72NyvLYUq3mQgqnDTlqwcH982XbJPPAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XS1Wp7qf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XS1Wp7qf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727201458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DYg2lGHz8TXjjMNnHGOly8NYsOq20FA7uwRScYmXTM8=;
	b=XS1Wp7qfbrtHW9oDnv0xiYAZ+CBwG5gk0aiYQS5XjXqncO3en8/byHkfyep6LfHWtrlnWF
	Ijh9DyvH+EJOzr/Xrql+ix+SgDVHda8pNjp5LQlOqOqiXfj3FAkNltJiXmvGToistE7hYI
	wmVezY6ltD3sd0A1bMSrNSg88E6IgB8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-315-n0ICrWjgNyCqRJcipJ_2NQ-1; Tue,
 24 Sep 2024 14:10:55 -0400
X-MC-Unique: n0ICrWjgNyCqRJcipJ_2NQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E108B1944B39;
	Tue, 24 Sep 2024 18:10:53 +0000 (UTC)
Received: from [10.45.226.79] (unknown [10.45.226.79])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CFE619560A3;
	Tue, 24 Sep 2024 18:10:51 +0000 (UTC)
Date: Tue, 24 Sep 2024 20:10:47 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>
cc: Akilesh Kailash <akailash@google.com>, Maxim Suhanov <dfirblog@gmail.com>, 
    Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, 
    Mike Snitzer <snitzer@kernel.org>, security@kernel.org, 
    dm-devel@lists.linux.dev, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
In-Reply-To: <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com>
Message-ID: <934fc549-d219-9696-43d7-57532dbcb3b0@redhat.com>
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com> <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-634968277-1727201453=:2933431"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-634968277-1727201453=:2933431
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Tue, 24 Sep 2024, Sami Tolvanen wrote:

> Hi Mikulas,
> 
> On Tue, Sep 24, 2024 at 6:18 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > Maxim Suhanov reported that dm-verity doesn't crash if an I/O error
> > happens. In theory, this could be used to subvert security, because an
> > attacker can create sectors that return error with the Write Uncorrectable
> > command. Some programs may misbehave if they have to deal with EIO.
> 
> I seem to recall that this was intentional. We used to restart/panic
> on I/O errors with FEC enabled, but the behavior was changed in commit
> 2c0468e054c0 ("dm verity: skip redundant verity_handle_err() on I/O
> errors"). Akilesh, do you remember what exactly was the issue here?

> > Index: linux-2.6/drivers/md/dm-verity-target.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-verity-target.c        2024-09-23 17:48:08.000000000 +0200
> > +++ linux-2.6/drivers/md/dm-verity-target.c     2024-09-24 11:34:08.000000000 +0200
> > @@ -273,7 +273,7 @@ out:
> >                 return 0;
> >
> >         if (v->mode == DM_VERITY_MODE_RESTART)
> > -               kernel_restart("dm-verity device corrupted");
> > +               emergency_restart();
> 
> Can we still log the reason for the restart? I remember some folks
> used to rely on the "dm-verity device corrupted" message in the kernel
> log.
> 
> Sami

OK. I've applied this on the top of my patch.

Mikulas



diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 88012845bced..c9451df72c5a 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -272,8 +272,10 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
 	if (v->mode == DM_VERITY_MODE_LOGGING)
 		return 0;
 
-	if (v->mode == DM_VERITY_MODE_RESTART)
+	if (v->mode == DM_VERITY_MODE_RESTART) {
+		pr_emerg("dm-verity device corrupted\n");
 		emergency_restart();
+	}
 
 	if (v->mode == DM_VERITY_MODE_PANIC)
 		panic("dm-verity device corrupted");
@@ -602,11 +604,13 @@ static void verity_finish_io(struct dm_verity_io *io, blk_status_t status)
 			DMERR_LIMIT("%s has error: %s", v->data_dev->name,
 					blk_status_to_str(status));
 
-		if (v->mode == DM_VERITY_MODE_RESTART)
+		if (v->mode == DM_VERITY_MODE_RESTART) {
+			pr_emerg("dm-verity device corrupted\n");
 			emergency_restart();
+		}
 
 		if (v->mode == DM_VERITY_MODE_PANIC)
-			panic("dm-verity device has I/O error");
+			panic("dm-verity device corrupted");
 	}
 
 	bio_endio(bio);
---1463811712-634968277-1727201453=:2933431--

