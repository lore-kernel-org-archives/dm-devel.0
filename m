Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2385C18EFFA
	for <dm-devel@lists.linux.dev>; Mon, 30 Sep 2024 16:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727713643; cv=none; b=N/m5ysOVq9Pm/9hUdI6DRYbTTCr6YSV0WC1V6hOBxZn8iUrjA5JnZTbdBxeJbL6Iz418tdn77LJ42L0g69awUfnKVtNYhhxhQj1j+dNoKWk9Sb8Ea+Pa4/9fBhM2SAqpK9CRVGo4bEiNlv17gn1X5987AHe/KBlenQy5G3COcHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727713643; c=relaxed/simple;
	bh=KTeJzxg32Z1a0bSGXA4l0+T4xoh+RZoCJQPWtDGgnJg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=eXIpPPB/a/Np7G5zY2Z7QuQ28aj0XhjE1J0DyaGqK9BaaDOhoxzsHnIGKm/t+drK5YdEiAI1tQw8a+8tO3bB4kTKJlECkYbWkZQh8Z2Eh9nd5ZcqiGrUdWUe7IV3SfRsc3J877HK9Wo3audhCuNIyU1/+Gu6qqM0kLq770oAgs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hm22WQzk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hm22WQzk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727713641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uz7xbpvFVIqvPsy6RlRz0dKRPprcPpCdLQIk/6IYlI=;
	b=Hm22WQzkxywBa0ccCFSSxnUdmtmJ0gmdpCNqh9BBgHV66EFqad+GFoD9UQQ0OFOutFY/2E
	NPMWdZVducLKYNmf8nEXtYeQX1gHIzI3GDmo5mIGdYNddmI9thNYPyEFTKsOi+TQnXDHvm
	0HC9mfGulB4tV9MPvMcRDzkyC3/rwgY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-22--MUHCtZ8N5eMOduVsr86xQ-1; Mon,
 30 Sep 2024 12:27:15 -0400
X-MC-Unique: -MUHCtZ8N5eMOduVsr86xQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2400A197702D;
	Mon, 30 Sep 2024 16:27:14 +0000 (UTC)
Received: from [10.45.225.58] (unknown [10.45.225.58])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18FAB3003E4D;
	Mon, 30 Sep 2024 16:27:10 +0000 (UTC)
Date: Mon, 30 Sep 2024 18:27:07 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Will Drewry <wad@chromium.org>
cc: Sami Tolvanen <samitolvanen@google.com>, Milan Broz <gmazyland@gmail.com>, 
    Maxim Suhanov <dfirblog@gmail.com>, Akilesh Kailash <akailash@google.com>, 
    Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, 
    Mike Snitzer <snitzer@kernel.org>, security@kernel.org, 
    dm-devel@lists.linux.dev, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
In-Reply-To: <CAAFS_9H2EnYwRxx+j-f9TkXKdgCN7-Lgm5p0Q-RZggJaSt2g9g@mail.gmail.com>
Message-ID: <c1e91fc3-41f6-9eec-1f9f-45d89b2ec241@redhat.com>
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com> <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com> <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com> <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com>
 <b65d67cf-9904-4182-a113-2d9a241dd668@gmail.com> <CAKeu6dUEC-j5G+KOTFUdfinMe+HTBSm6idxhHQzwVr8Sp_MfMg@mail.gmail.com> <3d31625f-3b26-47d7-b933-0bd6a89b748b@gmail.com> <CABCJKuf3bkJXS2dzud5w7MrfEcYa21mbKa=ssEOQxPzfDtzE2g@mail.gmail.com>
 <1229c48a-a225-e426-7f39-465146754975@redhat.com> <CABCJKudUHS_vzW1G08_24JxLbSmZwKUUUtaWkFSjv6gFz6+GXw@mail.gmail.com> <4c6ef1cd-9eab-c8d2-a641-50a7d6994632@redhat.com> <CAAFS_9H2EnYwRxx+j-f9TkXKdgCN7-Lgm5p0Q-RZggJaSt2g9g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 30 Sep 2024, Will Drewry wrote:

> > The dm-verity behavior was reported as a security bug, so by default, it
> > should behave in the secure way - i.e. restart or panic on I/O error.
> >
> > Do you intend to use dm-verity in Android and ChromeOS in the less-secure
> > way where it returns -EIO? Have you audited the Android and ChromeOS
> > codebase so that -EIO can't cause security breach? If yes, I can make a
> > configuration switch for you that will enable the old behavior.
> 
> tl;dr don't change the default behavior, but adding a reboot-on-eio is nice.

OK, so I can revert it if you want it.

I'd like to ask - there is another change in that patch - I changed
	kernel_restart("dm-verity device corrupted");
to
	pr_emerg("dm-verity device corrupted\n");
	emergency_restart();

Because kernel_restart calls reboot notifiers and they may in theory wait 
for the bio that caused the restart, resulting in deadlock.

Do you want to have this part of the patch reverted too?

Mikulas

