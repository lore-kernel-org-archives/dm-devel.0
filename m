Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B9F146586
	for <dm-devel@lists.linux.dev>; Thu, 26 Sep 2024 20:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727383488; cv=none; b=WPrLh6LoWSRJoI+0O61D0rmyc0/Sm3Gln7no2roX/7MIs7Dc96DHNMVfCwdwAt5pimhwOiSyiDy294O2NPnycLBwXNPlFtBNA9Tx7MGKN5aH+vTe6t76vWtjqpR2cuJdbFm8l9piREisW5M3ZQBMosx1zWVe8PTmfQu1pPFI5y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727383488; c=relaxed/simple;
	bh=5fDjXUE4lLHodZxT9BjM/iihP/NF6Pv4IAa2dBYkbAU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cZSG68cJRrHfxEV5hqYt6QL898q9I/ECRuAHo30Fgp0HAIx9dczzhR9PCcWecbIg3Kj7y3Qbd8I+gm5ZXcICA4lXXoGqwpp9mYMK6p8ljV3oTL7IVyGRxjQnvosaKxwUkh7vrX1yIfF993Remf7nYPalY4hRacl/3TGwRDVsOhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OCf4xSfh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OCf4xSfh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727383484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yapMVSp2gHYTAEZwm8ZvaZy42ry+SyLTOMHR2lrIYFM=;
	b=OCf4xSfhG9az7Vjq1WyZufaUyE/1SJKIBsJV7VP4mTKz03B6SDnr1C7yqZw8yz8+CGrNX3
	AjEcoia+kRcvlDktSIsQ5JsOOHD5oxPgdUmwfpOWmxB/MD7Njh+/HRbzoMWg55vwcH0W2N
	oRs4TPrQgci/xHD2ws0kCy+mF4ER9e8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-189-glyPQ-hQOTyIHzkeDx34Eg-1; Thu,
 26 Sep 2024 16:44:41 -0400
X-MC-Unique: glyPQ-hQOTyIHzkeDx34Eg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9DB2193611B;
	Thu, 26 Sep 2024 20:44:39 +0000 (UTC)
Received: from [10.45.225.58] (unknown [10.45.225.58])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 69B6419560A3;
	Thu, 26 Sep 2024 20:44:36 +0000 (UTC)
Date: Thu, 26 Sep 2024 22:44:31 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>
cc: Milan Broz <gmazyland@gmail.com>, Maxim Suhanov <dfirblog@gmail.com>, 
    Akilesh Kailash <akailash@google.com>, Alasdair G Kergon <agk@redhat.com>, 
    Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>, 
    security@kernel.org, dm-devel@lists.linux.dev, 
    Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
In-Reply-To: <CABCJKuf3bkJXS2dzud5w7MrfEcYa21mbKa=ssEOQxPzfDtzE2g@mail.gmail.com>
Message-ID: <1229c48a-a225-e426-7f39-465146754975@redhat.com>
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com> <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com> <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com> <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com>
 <b65d67cf-9904-4182-a113-2d9a241dd668@gmail.com> <CAKeu6dUEC-j5G+KOTFUdfinMe+HTBSm6idxhHQzwVr8Sp_MfMg@mail.gmail.com> <3d31625f-3b26-47d7-b933-0bd6a89b748b@gmail.com> <CABCJKuf3bkJXS2dzud5w7MrfEcYa21mbKa=ssEOQxPzfDtzE2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="-1463811712-1447079960-1727381939=:3059652"
Content-ID: <927fbd71-ae6b-9dd7-0e4f-79826f05aeb5@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-1447079960-1727381939=:3059652
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <f3a67caa-ab7d-a4e2-5fbc-cce20af8fa9d@redhat.com>



On Thu, 26 Sep 2024, Sami Tolvanen wrote:

> On Tue, Sep 24, 2024 at 11:35 PM Milan Broz <gmazyland@gmail.com> wrote:
> >
> > On 9/25/24 8:09 AM, Maxim Suhanov wrote:
> > > Hello.
> > >
> > >> This is a very strange reasoning. I can say that restarting on an IO error
> > >> (that can happen in normal situations) could cause another security issue,
> > >> such as DoS. EIO is not a data integrity error; it can happen even higher
> > >> in the storage stack... and the application should handle it anyway.
> > >
> > > In the default mode of operation, there should be no panic/reboot on
> > > an I/O error.
> > >
> > > The issue and the proposed patch affect the non-default modes:
> > > panic_on_corruption and restart_on_corruption.
> > > Users relying on one of those two modes expect the system to crash if
> > > something goes wrong [1]. So, DoS is expected here. Returning I/O
> > > errors to the reader isn't something that is expected here (see [1]).
> > >
> > > The issue allows the attacker to "downgrade" the "panic_on_corruption"
> > > and "restart_on_corruption" modes to the default one by creating
> > > unreadable sectors on the underlying media (e.g., through the Write
> > > Uncorrectable command).
> >
> > Sorry, but I do agree with this.
> >
> > Panic/Restart should happen on data corruption (or failed Reed-Solomon
> > FEC data recovery fail). IO error (and other errors that basically translates
> > to this) can mean something else and userspace application must process
> > it in error path (think about network failure).
> >
> > This is how is the dm-verity flag is documented:
> >
> > restart_on_corruption
> >      Restart the system when a corrupted block is discovered. This option is
> >      not compatible with ignore_corruption and requires user space support to
> >      avoid restart loops.
> >
> > It says nothing about restart on other error, that can come from crypto, network
> > or whatever. You are redefining the policy here.
> 
> I thought about this a bit more, and I agree with Milan. I/O errors
> can be temporary and applications should be expected to handle them.
> IMO we should trigger a restart/panic only if the underlying device
> has corrupted data. If there's a use case for restarting on I/O errors
> too, there should be a separate flag for that.

See for example openssh, the function read_config_file_depth. There is:

while (getline(&line, &linesize, f) != -1) {
	... process_config_line_depth
}
free(line);
fclose(f)
if (bad_options > 0)
	fatal("%s: terminating, %d bad configuration options",
		filename, bad_options);A
return 1;

So, the function doesn't distinguish between error and eof. If reading the 
config file returns -EIO, the function exits with 1 as if the file was 
empty.

If an attacker can trigger -EIO on some file in /etc/ssh/sshd_config.d/, 
openssh would behave as if the file didn't exist. If the file contains 
some security-related settings, they are lost.

Another example - if the iptables binary can't be executed due to -EIO, 
would the system erroneously boot with active networking without firewall? 
Do the boot scripts really propagate the iptables error so that no network 
devices are activated if iptables failed? I don't know how systemd handles 
this, but the old sysvinit scripts didn't seem to propagate the error.

I understand that some users want to prevent applications from seeing 
-EIO. Testing the whole system for -EIO is hard.

Mikulas
---1463811712-1447079960-1727381939=:3059652--

