Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159601AC8BC
	for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 18:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203514; cv=none; b=OWtg0Cfgmf1969tyawwi1Pad+B2YZgQPnnrOngpdRX1JSPrqRwI2qQ3NXIyrYYAk9rHi3o3e+kfDLeycOhN9lOmGt4m4vMzl2Y+SgBxSjseVDqYam6tva0CPvo4nARISyuSk08+Qn35yYzbqggRcc8s6PeyvIUDrxXgvfyJC08I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203514; c=relaxed/simple;
	bh=DvcSZ95SIoOG9royPMe2PcsmxG9sxbNnoBe9HRfVH90=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Svcyq0mu9clqUBfDNWAYNUMv0mWscXkDkL1TL3zTdspdj0SB68vbba9VCwAgJzgSooFwJYmN9l69SS14Tp9JmNoaDll4FfqxFlrBrFGkG6JmweAVS3oSe1e/eEIQB+c3ubelNPuEChD5ew1TJQZqzJ3PUBoJhLKDLnZUN++VOlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FOsnRUQF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FOsnRUQF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727203510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ruwNgo8gGjZ/UGoRyaOeUF7iT/c6vB+CTnGmC/8Yi/4=;
	b=FOsnRUQFaryShHjRuaLoY0PovlI93PJFM7dEGTU64JUBW90n8vol/gQSLsZKVosr1KHUPQ
	HAwwECiTqomMJKk/0ZVqXTJkZj1yW8SZrDf0VFazncJRxBxRFkm2eEym3URKrRcq4ftFNA
	t3fM5zjhzj+kJ6KJbcVYlw56k3T7LNE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-41-J1YrNzFQMaqJmVqarJRrAA-1; Tue,
 24 Sep 2024 14:45:05 -0400
X-MC-Unique: J1YrNzFQMaqJmVqarJRrAA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16C7C190307E;
	Tue, 24 Sep 2024 18:45:04 +0000 (UTC)
Received: from [10.45.226.79] (unknown [10.45.226.79])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 079F5195ED11;
	Tue, 24 Sep 2024 18:36:55 +0000 (UTC)
Date: Tue, 24 Sep 2024 20:36:53 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Akilesh Kailash <akailash@google.com>
cc: Sami Tolvanen <samitolvanen@google.com>, 
    Maxim Suhanov <dfirblog@gmail.com>, Alasdair G Kergon <agk@redhat.com>, 
    Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>, 
    security@kernel.org, dm-devel@lists.linux.dev, 
    Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
In-Reply-To: <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com>
Message-ID: <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com>
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com> <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com> <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="-1463811712-1637518873-1727202980=:2933431"
Content-ID: <46f8c61e-734a-7e0f-8ce4-0c4f59bce7e6@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-1637518873-1727202980=:2933431
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <0929d95a-ac3a-2bc5-ef5c-9eb88a19d7d0@redhat.com>



On Tue, 24 Sep 2024, Akilesh Kailash wrote:

> On Tue, Sep 24, 2024 at 10:44 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > Hi Mikulas,
> >
> > On Tue, Sep 24, 2024 at 6:18 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> > >
> > > Maxim Suhanov reported that dm-verity doesn't crash if an I/O error
> > > happens. In theory, this could be used to subvert security, because an
> > > attacker can create sectors that return error with the Write Uncorrectable
> > > command. Some programs may misbehave if they have to deal with EIO.
> >
> > I seem to recall that this was intentional. We used to restart/panic
> > on I/O errors with FEC enabled, but the behavior was changed in commit
> > 2c0468e054c0 ("dm verity: skip redundant verity_handle_err() on I/O
> > errors"). Akilesh, do you remember what exactly was the issue here?
> >
> 
> I looked at the history and the original intent and the idea stems
> from this patch:
> https://lore.kernel.org/dm-devel/b004e7c7-f795-77ed-19b9-983785780e92@gmail.com/T/#mec4df1ba3f3cb63846875fb2bfc1f8b3100f31f1
> 
> I think the EIO should be propagated back up the stack; I think this
> will trigger panic
> even for genuine I/O errors.

Maxim Suhanov's point is that you should trigger panic for genuine I/O 
errors. Otherwise the attacker could corrupt some sectors and let some 
program receive EIO and the EIO could confuse the program to do something 
insecure (for example, to not load a configuration file with security 
policy).

Mikulas
---1463811712-1637518873-1727202980=:2933431--

