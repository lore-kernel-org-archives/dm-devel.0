Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8D13C98AF
	for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 17:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607089; cv=none; b=PxLDY4rn+DYwNWAsQ6IrJJL6JE3BHOXiEkSA9xcZWNp7SuOFOwyyOH+ZMcYAdQmDRF389LmAsk5Uvm9U8tsyC/IHhYhCrToPmXh3RwqeUipiPk29Dvo5pQat3B7CFv4Ns3GpIPI+ko5KXf95FBnHoxPQjtmRNzujvf3AEIghsAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607089; c=relaxed/simple;
	bh=FKki8YvjRGl3IV+MB8oBC8OufI1Lje1cXulSL/xWcXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fOh8b74Vw+r2NhCsD4cwx9+bFDiylwYQkSmyvGwZoSRpsl0gR6G5RePr+a+a0QrYUy1mliTLs31V7SHldOgcwpBSrgWI1OnAvX1kZMr3DVQzZ1lLH/SphcisjZ56CZNCP+aHjO727I+mLUyUZZtfXMIfkpAN9ckWRAWWpXmJ1LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I5kW85pq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I5kW85pq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778607087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=93htoaqCpwle6G4SYJvr3M/wLK+ZI3QpTyktqLRcDTI=;
	b=I5kW85pq9DgjaY99i0ofmqIxs/4GpA3/wDrbsiDbZhNUkyLLQtYj0eGFss1osgy7QRoQru
	t9qs14PQXueDuIRFt+eXv/YI533SgLoA5NcmBrX1IAp35v/N+XIIZ//CUFwX5d06oJKdwT
	iFWkLY0C3qgOUo4QdMYKkw/+NPfYr5s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-341-NGIG7R1ZOmui3NPKOISLQw-1; Tue,
 12 May 2026 13:31:23 -0400
X-MC-Unique: NGIG7R1ZOmui3NPKOISLQw-1
X-Mimecast-MFC-AGG-ID: NGIG7R1ZOmui3NPKOISLQw_1778607082
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03CCA1956062;
	Tue, 12 May 2026 17:31:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C190D19560A6;
	Tue, 12 May 2026 17:31:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64CHVKMx3320121
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 13:31:20 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64CHVJjc3320119;
	Tue, 12 May 2026 13:31:19 -0400
Date: Tue, 12 May 2026 13:31:19 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Bruce Johnston <bjohnsto@redhat.com>,
        Matthew Sakai <msakai@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [RFC PATCH] dm: add deviceless messages
Message-ID: <agNj5_hUfXaGQ8Nu@redhat.com>
References: <3bdbd9fa-52ce-ab52-569f-29d4a30c6780@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <3bdbd9fa-52ce-ab52-569f-29d4a30c6780@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xmQkg8woRxN3J4P8E-2xONaNJ0MPXXUtxwUEiCVzMeM_1778607082
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 12, 2026 at 03:36:01PM +0200, Mikulas Patocka wrote:
> The VDO code needs to perform some calculations before creating a device. 
> The calculations should be performed in the kernel, so that the same logic 
> is not duplicated in the kernel and in the userspace.
> 
> However, currently it is not possible to call a device mapper target 
> when no device exists.
> 
> This commit solves the problem by adding "deviceless" messages. If the 
> message starts with '%', the name is a name of a target, not a name of a 
> device. The message will be directed to the target by calling the 
> "deviceless_message" method. The target can perform the requested 
> calculations in this method and return the result back to userspace.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

