Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C70149C47
	for <dm-devel@lists.linux.dev>; Thu, 26 Sep 2024 14:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727362527; cv=none; b=bWq658rzzPNWRrow68kpyIkybIs/35NEAO1OvBBC7B2VENeII9P4va1jbDh2aU8p2e9ZcFGLOITlC2fiOPgz7hOBXNRXYquUzO+ZCGFrrttFAWmfaswYcdrKQw5Bh+UxPeaBi5fNKbVSyv4NPm6jQ1J8VzNq4Wf/oVh5ceDnGDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727362527; c=relaxed/simple;
	bh=yE24T7odiBqZG0zL2tDjFB3i4rDURHiQulEWAeSXoKs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Rp6zxbO2UyHgWr/hb5ges7jd2cg3qhJj/GwZSkbXB2AtTbmDdjd5/cyOpyQpdCbZs3SshcLhH/TKrY+/mHSklcYdfQRMtUEKFxNDhgYpcM1hSMXtICJIR+3cP6oHeb4/krcVBDghGL/wcBNGAyjnr/b4Xn3ZBSvXHpQtZOR7VlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=izwG1qP9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="izwG1qP9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727362525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s4xHQvP/3YW1QcbDbJ6trHnXJQoZ3/Pd46GPDwFyx+k=;
	b=izwG1qP97ewMKQWHoSoEQ6jD0bh+38Ox+LUHrHWtDoaZwLIZvhsb0SR5rPGNByer9ylgVw
	qqvPqHTdnUDbouMPHyvko4I1QtWBDHnrwWdyVo4wmAkd0uMbSCerzBshlx9gb2XrKZMhRv
	qshxBm5WqwCV3jOPlWf5C+UG3AM5hkY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-Gj1OZp2KOvqnKMa5LoW7IQ-1; Thu,
 26 Sep 2024 10:55:22 -0400
X-MC-Unique: Gj1OZp2KOvqnKMa5LoW7IQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC0901978F59;
	Thu, 26 Sep 2024 14:55:20 +0000 (UTC)
Received: from [10.45.225.58] (unknown [10.45.225.58])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3AFAE1956086;
	Thu, 26 Sep 2024 14:55:18 +0000 (UTC)
Date: Thu, 26 Sep 2024 16:55:15 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Akilesh Kailash <akailash@google.com>
cc: Sami Tolvanen <samitolvanen@google.com>, 
    Maxim Suhanov <dfirblog@gmail.com>, Alasdair G Kergon <agk@redhat.com>, 
    Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>, 
    security@kernel.org, dm-devel@lists.linux.dev, 
    Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
In-Reply-To: <CABSDvD+PLF_HnGeJwVheW1HGcy8hV2BpfFw3NizkCYKxDeWURQ@mail.gmail.com>
Message-ID: <00806218-5250-8541-7606-77e2248a4e59@redhat.com>
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com> <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com> <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com> <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com>
 <CABSDvD+PLF_HnGeJwVheW1HGcy8hV2BpfFw3NizkCYKxDeWURQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-1391640108-1727362520=:3044666"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-1391640108-1727362520=:3044666
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Tue, 24 Sep 2024, Akilesh Kailash wrote:

> On Tue, Sep 24, 2024 at 11:45 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> >
> >
> > On Tue, 24 Sep 2024, Akilesh Kailash wrote:
> >
> > > On Tue, Sep 24, 2024 at 10:44 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> > > >
> > > > Hi Mikulas,
> > > >
> > > > On Tue, Sep 24, 2024 at 6:18 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > > >
> > > > > Maxim Suhanov reported that dm-verity doesn't crash if an I/O error
> > > > > happens. In theory, this could be used to subvert security, because an
> > > > > attacker can create sectors that return error with the Write Uncorrectable
> > > > > command. Some programs may misbehave if they have to deal with EIO.
> > > >
> > > > I seem to recall that this was intentional. We used to restart/panic
> > > > on I/O errors with FEC enabled, but the behavior was changed in commit
> > > > 2c0468e054c0 ("dm verity: skip redundant verity_handle_err() on I/O
> > > > errors"). Akilesh, do you remember what exactly was the issue here?
> > > >
> > >
> > > I looked at the history and the original intent and the idea stems
> > > from this patch:
> > > https://lore.kernel.org/dm-devel/b004e7c7-f795-77ed-19b9-983785780e92@gmail.com/T/#mec4df1ba3f3cb63846875fb2bfc1f8b3100f31f1
> > >
> > > I think the EIO should be propagated back up the stack; I think this
> > > will trigger panic
> > > even for genuine I/O errors.
> >
> > Maxim Suhanov's point is that you should trigger panic for genuine I/O
> > errors. Otherwise the attacker could corrupt some sectors and let some
> > program receive EIO and the EIO could confuse the program to do something
> > insecure (for example, to not load a configuration file with security
> > policy).
> >
> 
> Would it be ok to trigger the panic only when the system isn't shutting down?
> During shutdown, we may end up with EIO requests from the underlying
> driver and this may
> inadvertently trigger the panic.
> 
> verity_is_system_shutting_down() should already have that logic to
> skip during the shutdown path.

OK.

I've added this logic.

Mikulas
---1463811712-1391640108-1727362520=:3044666--

