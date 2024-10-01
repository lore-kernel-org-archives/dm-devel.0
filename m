Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB3519D07A
	for <dm-devel@lists.linux.dev>; Tue,  1 Oct 2024 09:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727773927; cv=none; b=CcY7NiiiD0iic3llzrdz3cXpIDL5CRlumj2JBsM2VkIpTcBlcWqZtSCV0lJPH8YvCrUI45cPPP4XhHiEyyvJ9qbMzjXlasYMJixevP/eIYVkOybeARkd84dXRA5prJC2U1mXSlrUOTk1JSDD5ZPfXCs8kYkdZxQ5YBLDKQtnYl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727773927; c=relaxed/simple;
	bh=8dOWaVCpCLR08dPvmz1Da4SAZ1f8jXxoGntvhSmvam4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=e181fwVzZuLDXythXfiqZBmNw1UOlAyC1xzcXIwYWcXqeAqMk+SREKbyLMnfkCMNX/o7Y/Fx+WwEXhbf8bL1aRDyJuqMRLDxaiHjwn8ilY/F0R/85pWYVHMg/6eIbMEMxuib1RCB7+GakLpHurkYUdB0JO+4R2XitXsdPW1Ok1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NNjKVLYA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NNjKVLYA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727773924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xWu4AOJFpVQylof+i0Go6vWWto9LtE4OL6oK6VECt3s=;
	b=NNjKVLYAH+6OXc6VHK/n/pIrfSuDnRBXE5bOGFzTXKF1X9FkYHeMysO14NavIIbKVjUggT
	mv4/FNcrDsCivpw66s0NcBOYueAbZOTVkBDDCxBgFDwzQ0eM3dkciuTspwckzuNBOlIs+E
	x+BInq3u60ZcvTTpQoDUnV+lB2j15M0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-KTREyZ5jMbGgfV596WsXpQ-1; Tue,
 01 Oct 2024 05:11:59 -0400
X-MC-Unique: KTREyZ5jMbGgfV596WsXpQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D57A196A134;
	Tue,  1 Oct 2024 09:11:57 +0000 (UTC)
Received: from [10.45.225.58] (unknown [10.45.225.58])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EFF01955DCA;
	Tue,  1 Oct 2024 09:11:54 +0000 (UTC)
Date: Tue, 1 Oct 2024 11:11:50 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Will Drewry <wad@chromium.org>
cc: Sami Tolvanen <samitolvanen@google.com>, Milan Broz <gmazyland@gmail.com>, 
    Maxim Suhanov <dfirblog@gmail.com>, Akilesh Kailash <akailash@google.com>, 
    Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, 
    Mike Snitzer <snitzer@kernel.org>, security@kernel.org, 
    dm-devel@lists.linux.dev, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
In-Reply-To: <CAAFS_9FuSb7PZwQ2itUh_H7ZdhvAEiiX7fhxJ4kmmv9JCaHmkA@mail.gmail.com>
Message-ID: <dfc65621-bb43-1ab7-82a7-3ab15fb9f95f@redhat.com>
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com> <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com> <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com> <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com>
 <b65d67cf-9904-4182-a113-2d9a241dd668@gmail.com> <CAKeu6dUEC-j5G+KOTFUdfinMe+HTBSm6idxhHQzwVr8Sp_MfMg@mail.gmail.com> <3d31625f-3b26-47d7-b933-0bd6a89b748b@gmail.com> <CABCJKuf3bkJXS2dzud5w7MrfEcYa21mbKa=ssEOQxPzfDtzE2g@mail.gmail.com>
 <1229c48a-a225-e426-7f39-465146754975@redhat.com> <CABCJKudUHS_vzW1G08_24JxLbSmZwKUUUtaWkFSjv6gFz6+GXw@mail.gmail.com> <4c6ef1cd-9eab-c8d2-a641-50a7d6994632@redhat.com> <CAAFS_9H2EnYwRxx+j-f9TkXKdgCN7-Lgm5p0Q-RZggJaSt2g9g@mail.gmail.com>
 <c1e91fc3-41f6-9eec-1f9f-45d89b2ec241@redhat.com> <CAAFS_9HyeD795N4RFKWYcP5VCFBCxmoXgGg9UbGy80Bxz7j1mg@mail.gmail.com> <CABCJKuedOj+E15YLZrC4nePx4g4YLO-3dzc3tyyx1S1_6HysJg@mail.gmail.com>
 <CAAFS_9FuSb7PZwQ2itUh_H7ZdhvAEiiX7fhxJ4kmmv9JCaHmkA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-365385751-1727773917=:3267836"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-365385751-1727773917=:3267836
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Mon, 30 Sep 2024, Will Drewry wrote:

> On Mon, Sep 30, 2024 at 1:07 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > On Mon, Sep 30, 2024 at 10:10 AM Will Drewry <wad@chromium.org> wrote:
> > >
> > > On Mon, Sep 30, 2024 at 11:27 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > >
> > > >
> > > >
> > > > On Mon, 30 Sep 2024, Will Drewry wrote:
> > > >
> > > > > > The dm-verity behavior was reported as a security bug, so by default, it
> > > > > > should behave in the secure way - i.e. restart or panic on I/O error.
> > > > > >
> > > > > > Do you intend to use dm-verity in Android and ChromeOS in the less-secure
> > > > > > way where it returns -EIO? Have you audited the Android and ChromeOS
> > > > > > codebase so that -EIO can't cause security breach? If yes, I can make a
> > > > > > configuration switch for you that will enable the old behavior.
> > > > >
> > > > > tl;dr don't change the default behavior, but adding a reboot-on-eio is nice.
> > > >
> > > > OK, so I can revert it if you want it.
> > >
> > > That or an argument so the old behavior can remain for those who are using it
> > > (I can send a patch for that if it's easier too).
> >
> > Thanks for chiming in on this, Will! I still think that adding a
> > separate restart_on_eio (or similar) flag would be the best solution.
> >
> > > > I'd like to ask - there is another change in that patch - I changed
> > > >         kernel_restart("dm-verity device corrupted");
> > > > to
> > > >         pr_emerg("dm-verity device corrupted\n");
> > > >         emergency_restart();
> > > >
> > > > Because kernel_restart calls reboot notifiers and they may in theory wait
> > > > for the bio that caused the restart, resulting in deadlock.
> > > >
> > > > Do you want to have this part of the patch reverted too?
> > >
> > > IMHO, that's a good change!  If the policy is to restart on corruption, then
> > > it makes sense to avoid the reboot notifiers.
> >
> > While I agree that this sounds good in principle, devices that use the
> > restart feature typically need to pass the reboot reason to a PMU, for
> > example, and it looks like Android devices depend on reboot notifiers
> > for this. Here's a recent Pixel implementation that checks for the
> > "dm-verity device corrupted" command as an example:
> >
> > https://android.googlesource.com/kernel/google-modules/power/reset/+/refs/heads/android-gs-comet-6.1-android15/pixel-zuma-reboot.c#81
> 
> Good catch! (It's a shame it's using text as the API!) I totally
> spaced on that, and depending on where the corruption is, you mind end
> up in a boot loop.

If I add that 'reboot-on-eio' flag, should it also restart the kernel with 
kernel_restart("dm-verity device corrupted")? Or, should it use a 
different string?

Mikulas
---1463811712-365385751-1727773917=:3267836--

