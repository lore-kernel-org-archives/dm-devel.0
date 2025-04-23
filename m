Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932161862
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 00:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745367330; cv=none; b=TPRLrRnONWB/6n62Hvq0/xgs/6F/zklBN9fXv+VkufETxuuYm8hVA/TnA2IpQZqLVdawBY+YTJ/AHVCt+UgFpkDnIg0W4q0Mw+Qqgk9PQS4zp3INds4Qbx4ozgMfX//tQA0Sh1/WCRzuO1nSGDuG2IcVmfvCSWGcXYdPaRMaMPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745367330; c=relaxed/simple;
	bh=TMc1MnXO2PCPtd4eUbFXl6HnEje8r07TXzRvUAMigXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=p5aVgZy0kAacu/3q4eJteAZKrGQ6lLBQVWmjeBJFi4Uh8+hV/xs+EM6J3is5RoCRuu/3SyoalM0wPtKCMmnEo1ExyBviuzx3xr+Y/JxdcR5U1iHoD/9pDPu8Er/gJFVnQz9IGxke18xbvooEWerAxWGC+de8cJAZnWpHmj7mw7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ul2INtk7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ul2INtk7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745367327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=71gzOZSqsy2I6fNJ/dU/G7E7EOuVRbMnybdZQ+X0QLE=;
	b=Ul2INtk7dswwFLrS6ZN9u37v0qJ3K4Pj4/medKClctQ4leQsqbUr5f3Y4UxaIO/hRIan+E
	+k3/yy10kh6yekTSEewW/MHIzj35u7SR2jdYO5MTarKV8ZAO8kjI+WwMCGYJi2iL4iiI1C
	nO6JorrRLxomVEkBXYBs1gpx8HGFC0s=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-k55vC1H_PMG2gyCHmz5H6A-1; Tue,
 22 Apr 2025 20:15:23 -0400
X-MC-Unique: k55vC1H_PMG2gyCHmz5H6A-1
X-Mimecast-MFC-AGG-ID: k55vC1H_PMG2gyCHmz5H6A_1745367323
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F322B180036F;
	Wed, 23 Apr 2025 00:15:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78001180045C;
	Wed, 23 Apr 2025 00:15:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53N0FL7S1654945
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Apr 2025 20:15:21 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53N0FK9c1654944;
	Tue, 22 Apr 2025 20:15:20 -0400
Date: Tue, 22 Apr 2025 20:15:20 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/4] dm-flakey fixes
Message-ID: <aAgxGBw7ytEOifIY@redhat.com>
References: <20250422234738.1654052-1-bmarzins@redhat.com>
 <gdw3hv5qnvnrusmh6lt3kfrqlwsmf7o7azdx2sfwlebbqsecla@djyd6a7f3ag2>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <gdw3hv5qnvnrusmh6lt3kfrqlwsmf7o7azdx2sfwlebbqsecla@djyd6a7f3ag2>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UnTa5-QwUkOr4RPztXWT1kQID0ua398dWVJEMso_DLY_1745367323
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 22, 2025 at 08:02:54PM -0400, Kent Overstreet wrote:
> On Tue, Apr 22, 2025 at 07:47:34PM -0400, Benjamin Marzinski wrote:
> > This patchset handles some dm-flakey issues reported by Kent Overstreet.
> > It fixes some issues with dm-flakey's parsing and feature interactions
> > and makes corrupting read bios work.
> > 
> > Benjamin Marzinski (4):
> >   dm-flakey: Clean up parsing messages
> >   dm-flakey: error all IOs when num_features is absent
> >   dm-flakey: remove useless ERROR_READS check in flakey_end_io
> >   dm-flakey: make corrupting read bios work
> > 
> >  drivers/md/dm-flakey.c | 114 ++++++++++++++++++++++-------------------
> >  1 file changed, 62 insertions(+), 52 deletions(-)
> 
> Does it have tests now?

I tested it. Adding automated tests for it is a work in progress.

-Ben

