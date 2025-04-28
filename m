Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7285225F7BA
	for <dm-devel@lists.linux.dev>; Mon, 28 Apr 2025 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745853141; cv=none; b=isF5MSFCNLQMU9iREdrBeNXY3RSzn/Y1EJn8G4tufrWhGLU645At/IOnyKRl7t5GlXSUblhV1njWO8dUh2qisBXGsgiWATzN1UCMM9LJEO3YpM20S5uQoYMf/eu994nLp7Cg025bGSyKWrsHIW3jw4wN6Qvn/BTI4kHPF2EZeY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745853141; c=relaxed/simple;
	bh=73Jyfc85tF50S48/7i/r3AtucwA4Bs+M7JMI9VYfKNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=pNlWIswwDgdvjSHmoXbsFe4Zi/9hdWuqjUMzUUkjooXoOrt9tnbAWp3gyrnYmmDD5jNjCjnHO4txld1v3v9OYhOodh8j+YK39VaQqAzdAh4bN7XNA75EgzE7FVwqabbAdeb6xKlfVvPUsDjAKbAIAEnlIyX+gbi4/hR/d0C33hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i/+Gh9qr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i/+Gh9qr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745853138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FYFgQwvusQgcU3st1/IZPXQEYJRoFoZ/2JxCV2I/8sw=;
	b=i/+Gh9qrx1WSOx2ZZoknkLjeeCrcr1jxGKJ47JJZr3KR2iEZVgO8tid/TBg3/MNhYiqPLN
	a5FrpU9SgPpMAFwuAG0euvUGCjhPFc+qxYsE0Nkw5wClyXDHmHtUY7Ia+dHeO9VdAD67YU
	aUUKbCdX4FWaZ6JMWIM+tXSAV36o+KA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-329-Ph7gPgCLPC-SVruIiXTWxQ-1; Mon,
 28 Apr 2025 11:12:14 -0400
X-MC-Unique: Ph7gPgCLPC-SVruIiXTWxQ-1
X-Mimecast-MFC-AGG-ID: Ph7gPgCLPC-SVruIiXTWxQ_1745853133
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36F621800ECC;
	Mon, 28 Apr 2025 15:12:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E8FA180047F;
	Mon, 28 Apr 2025 15:12:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53SFC9C31892567
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Apr 2025 11:12:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53SFC8B41892566;
	Mon, 28 Apr 2025 11:12:08 -0400
Date: Mon, 28 Apr 2025 11:12:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        DM-DEVEL ML <dm-devel@lists.linux.dev>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Hannes Reinecke <hare@suse.com>, Chris Hofstaedtler <zeha@debian.org>,
        Christian Hesse <mail@eworm.de>,
        Mitchell Dzurick <mitchell.dzurick@canonical.com>,
        Steve Langasek <steve.langasek@ubuntu.com>
Subject: Re: Announcement: "stable" branches for multipath-tools
Message-ID: <aA-ayKBbfdplGtDb@redhat.com>
References: <df3d023177dca2006b5aab4b2c4ef78fe1acf8c5.camel@suse.com>
 <fe56f3f9-3db1-4627-ade6-6499c6553696@gmail.com>
 <8eee19603086bfa303af1a3d5446693aadf64d8b.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8eee19603086bfa303af1a3d5446693aadf64d8b.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: etcLlmpPMeOw4B_Nh_5qKqwMv_EGDf2RgGLc-eQkCc4_1745853133
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Apr 28, 2025 at 03:56:30PM +0200, Martin Wilck wrote:
> On Sat, 2025-04-26 at 14:08 +0200, Xose Vazquez Perez wrote:
> > On 2/10/25 10:25 PM, Martin Wilck wrote:
> > 
> > > the multipath-tools maintainers have decided to start providing
> > > stable
> > > branches that accumulate bug fix patches only. We currently provide
> > > two
> > > branches, stable-0.10.y [1] and stable-0.11.y [2].
> > > 
> > > The stable branches are meant as a guideline for distribution
> > > maintainers to pick bug fixes without major regression risk. Only
> > > small
> > > patches that fix actual problems are eligible for inclusion in the
> > > stable trees.
> > 
> > hwtable patches (
> > https://github.com/opensvc/multipath-tools/commits/master/libmultipath/hwtable.c
> >  )
> > could be backported, as they are low risk.
> 
> Yes, but they aren't actual, bug fixes, either, and they change default
> behavior, which I'd prefer to avoid in the stable branches.
> 
> Ben, what's your take?

I think you're right. Even if we're just adding a new built-in config,
that could change how someone's multipath setup is configured, and while
the defaults are the recommeneded way to configure the device, it still
makes sense to not change them in what would otherwise be just a bugfix
branch, which is designed to safe to pull into a distribution at any
time.

On the other hand, if there are cases where an existing built-in config
is actually broken for a device, it would make sense to pull those fixes
into the stable branch.

-Ben

> 
> Martin

