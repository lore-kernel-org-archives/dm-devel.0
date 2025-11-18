Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F2D332ED9
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 18:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763489007; cv=none; b=HvVAA2ZLPYwCLEFyNkcBNniGgm6Gkdq70hRsGNgcgII8d4+XT2Ji+5gOtBn/aTpm6DZHtOULA5Eeo4Kbqyt/08OnsC3r3lFLmpaUZASpmcecL8FW0Hwb0lXpAX1nMLz9Vw5hvWAHjXUTBkcpYVRhp+SXFyxcUI3kQ2gGdHlayuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763489007; c=relaxed/simple;
	bh=C4K1EuZ4y/hjarUGvfsykH0gCtQnE6wVx9ZAPj8Ch/8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=eVR9kv5gaIe6F3TqIpFgLHmULwApM+hoNSzeIM3aSkTjZ3OUENexZRkySDtRCx/h9xSgmxsf7YWFZa5uSXwwRiYAtuHTlMA97qhgia9fwNOWjjIOgI7NsGcazoA/+L+C5viEhQPUMTBR19Nipztl4moUZO/HhbhlmgPhbzlmlis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hXKI+hDa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hXKI+hDa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763489004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHOTMcsmyPt3trlLaZ8uRRSxzJpc5fFVJQlVHVyHh/8=;
	b=hXKI+hDaMMPLUc5kWumuMnQsqcmuhrOXSdNxKZlFpPhG2iD1rc2m/hdUAZyVO65HPgdAXU
	dFAc71lyXEESeu5PO21D8EbqtI6IsVd6mjlEgD5TfEaZEyu9BRuLc+/YhNa45x86vju9fe
	re1IaA1ELmZAafbf47EeygiNsk1xcYI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-163-dHTtsguIPbGqTXK78mOHyw-1; Tue,
 18 Nov 2025 13:03:20 -0500
X-MC-Unique: dHTtsguIPbGqTXK78mOHyw-1
X-Mimecast-MFC-AGG-ID: dHTtsguIPbGqTXK78mOHyw_1763488999
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC234195609D;
	Tue, 18 Nov 2025 18:03:18 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDD321800878;
	Tue, 18 Nov 2025 18:03:16 +0000 (UTC)
Date: Tue, 18 Nov 2025 19:03:12 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, Guangwu Zhang <guazhang@redhat.com>, 
    Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH] dm-verity: disable recursive forward error
 correction
In-Reply-To: <CABCJKuf=8svp8WbE7SOKJhFaWh_8iCXYc41tgu_1po7_AVz0qQ@mail.gmail.com>
Message-ID: <5ee412ad-799e-a570-5921-940661449d80@redhat.com>
References: <75ef45cb-4c00-4b27-87cd-3c2914f5dbcc@redhat.com> <CABCJKuf=8svp8WbE7SOKJhFaWh_8iCXYc41tgu_1po7_AVz0qQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7bnyboeFGgafuCELp_LYlTiOixJ6bEtuItLAfl3p-N0_1763488999
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-1303078282-1763488998=:1055457"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-1303078282-1763488998=:1055457
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Mon, 17 Nov 2025, Sami Tolvanen wrote:

> Hi Mikulas,
> 
> On Fri, Nov 14, 2025 at 7:54 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > Hi
> >
> > What do you think about this patch?
> >
> > There are two problems with the recursive correction:
> >
> > 1. It may cause denial-of-service. In fec_read_bufs, there is a loop that
> > has 253 iterations. For each iteration, we may call verity_hash_for_block
> > recursively. There is a limit of 4 nested recursions - that means that
> > there may be at most 253^4 (4 billion) iterations. Red Hat QE team
> > actually created an image that that pushes dm-verity to this limit - and
> > this image just makes the udev-worker process get stuck in the 'D' state.
> >
> > 2. It probably doesn't work. In fec_read_bufs we store data into the
> > variable "fio->bufs", but fio bufs is shared between recursive
> > invocations, if "verity_hash_for_block" invoked correction recursively, it
> > would overwrite partially filled fio->bufs.
> >
> > So, I'm suggesting to remove recursive correction at all. This patch
> > passed the cryptsetup testsuite. Does it pass your tests too?
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Reported-by: Guangwu Zhang <guazhang@redhat.com>
> 
> This looks reasonable to me. I only remember seeing recursive error
> correction trigger in a real system when someone attempts to use the
> wrong root hash, which is obviously not recoverable.
> 
> Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
> 
> Sami

Thanks, OK.

I staged the patch for 6.19.

Mikulas
---1463811712-1303078282-1763488998=:1055457--

