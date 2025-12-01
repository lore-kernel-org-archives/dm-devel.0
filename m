Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4754A7E110
	for <dm-devel@lists.linux.dev>; Mon,  1 Dec 2025 21:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764623257; cv=none; b=bCQ8GCD6rTVa+rKmkGd8duajftjtMDD/1rUD3RF+2kQ5g8C7DS0AlO5BBGnNDzxRxSP7pQtyLB1W2iNARZRsRcZ0KAkTc4FA73LD4U5yt3Jd542/vu3Ibzeez1eq4sOieh5J1gCqoH0XlxbkmtQ3pXFHdTeRLjYPfVJdOXlfXMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764623257; c=relaxed/simple;
	bh=WXeSzIsfqDr4Tc33ztKIFFcNzq6QxOXE7SMeulEs9r8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=to6WtbC5yi9V5VP1zJICy5WJxWIT106tye+ihGNZGlhRHXPd8p53d8PSDMlx9llNYPM//xmypdrIX1IDBgH/14hHvhZdsdS0X/q238gy6+c2/PA/d0eKXHUQk6k2K12Qn6B8dTQBCjfmv5ZnrpH3tSw9LugCgKS9E9rB9szwNoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FdASTKgE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FdASTKgE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764623254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QZZlhHBAuSwqNLgObqE5iS3Z/Qf7FRlhdC+800rfo+8=;
	b=FdASTKgEBqqih2psfb3miJh+xygNIfk/1Zn+IBosuLP04g8zSW9GoENTU4ywOWNkh+PdiA
	CprwRgHCLM3pTM1UpqNmh7q5F2+zautybl4aQ6snqs4GMJXZ+swfQfY18sec+BygXGr8Z1
	Tlm9ta3To+dXkmkqRt++WN+btCo4fJY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-390-fcxS6e1mOx6RHgxQG1sHUQ-1; Mon,
 01 Dec 2025 16:07:29 -0500
X-MC-Unique: fcxS6e1mOx6RHgxQG1sHUQ-1
X-Mimecast-MFC-AGG-ID: fcxS6e1mOx6RHgxQG1sHUQ_1764623247
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F6A11955E74;
	Mon,  1 Dec 2025 21:07:26 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3ABDF30001A4;
	Mon,  1 Dec 2025 21:07:24 +0000 (UTC)
Date: Mon, 1 Dec 2025 22:07:19 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
cc: "snitzer@kernel.org" <snitzer@kernel.org>, 
    "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    "hch@lst.de" <hch@lst.de>, 
    "Martin K . Petersen" <martin.petersen@oracle.com>, 
    Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
    Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: Re: [PATCH V3 3/6] dm: ignore discard return value
In-Reply-To: <5214ed1a-280a-4886-b679-db7bc99dcf94@nvidia.com>
Message-ID: <15204fb6-39a0-8bf8-5800-087562c56619@redhat.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com> <20251124234806.75216-4-ckulkarnilinux@gmail.com> <5214ed1a-280a-4886-b679-db7bc99dcf94@nvidia.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AWRFtRa-ybOsoeCRcuHJgrUEUe-hHJiwuGHFp-4lHYY_1764623247
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 1 Dec 2025, Chaitanya Kulkarni wrote:

> Hi Mike and Mikulas,
> 
> On 11/24/25 15:48, Chaitanya Kulkarni wrote:
> > __blkdev_issue_discard() always returns 0, making all error checking
> > at call sites dead code.
> >
> > For dm-thin change issue_discard() return type to void, in
> > passdown_double_checking_shared_status() remove the r assignment from
> > return value of the issue_discard(), for end_discard() hardcode value of
> > r to 0 that matches only value returned from __blkdev_issue_discard().
> >
> > Reviewed-by: Martin K. Petersen<martin.petersen@oracle.com>
> > Reviewed-by: Johannes Thumshirn<johannes.thumshirn@wdc.com>
> > Reviewed-by: Christoph Hellwig<hch@lst.de>
> > Signed-off-by: Chaitanya Kulkarni<ckulkarnilinux@gmail.com>
> > ---
> 
> 
> Gentle ping on this.
> 
> -ck

Hi

I thought that this patch would go with the other patches that do the same 
change in other subsystems - but if you want me to make it go through the 
device mapper tree, I can do it.

I staged the patch for this merge window.

Mikulas

