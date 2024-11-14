Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D0418C32C
	for <dm-devel@lists.linux.dev>; Thu, 14 Nov 2024 11:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731585183; cv=none; b=E4UrWDP+4ylpRMtDRgwXQA+1XHF7U2RRoDiOcxk9a+OCskowb4bad9YAbbUgxxr2kfPxwULbfkj/SlCyNhz5WXi+TTQcTcRMMr+tp4vM0Bx5FlnJc6+X9K9gWx+FT4YEktp5k67VJ4psbIwenJJyptQc/iDlj5+6jX+/Loou20A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731585183; c=relaxed/simple;
	bh=zCa5Fh3htp1rTFM2a0REC9zUahAF+CJ/sS/ug00Uqzc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XGQtqPyM8CMiXFqsOkP4BgZtKAEYA4IhLWpDEfO9R1pUuBzzOhsntnPDzPFACoUKxsaF0zX23dbeDB/xehsZvr4v1VmC5FHwP0L2oE++V5As7SkRpSiepb91ftKPu6jvIIF/mIGeuGiCdR20ms8mW4r+MJ3hWxNu6WM+8sxT3/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cq3KS+GK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cq3KS+GK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731585180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CDgvIe7Dumrnez9vkncEVNQLsu1Vtx62ikTQTnwYCHI=;
	b=Cq3KS+GK//PpN7NblUCUJOzKvBYkg7a2Y5HhD9Kp75KLXsOrxfogsGtM9qScgnotKL+RiV
	7oS8TujOktAji5NjLx/88Sx3i/dOlW6r1c+lW/X+Xz22Jh9FFA+09+RmtW5w+bsFZZOx8l
	EO9dbi5Ih0BMAUzsK+1oUOtz1adx/r0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-MzbkMhXGM5CcWu2ZWZ03eA-1; Thu,
 14 Nov 2024 06:52:57 -0500
X-MC-Unique: MzbkMhXGM5CcWu2ZWZ03eA-1
X-Mimecast-MFC-AGG-ID: MzbkMhXGM5CcWu2ZWZ03eA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 254751955F35;
	Thu, 14 Nov 2024 11:52:56 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC2431956089;
	Thu, 14 Nov 2024 11:52:53 +0000 (UTC)
Date: Thu, 14 Nov 2024 12:52:50 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Red Hat Product Security <secalert@redhat.com>
cc: syzkaller@googlegroups.com, dm-devel@lists.linux.dev, chenyuan0y@gmail.com, 
    agk@redhat.com, snitzer@kernel.org, zzjas98@gmail.com
Subject: Re: [drivers/md/dm.c] general protection fault in
 cleanup_mapped_device
In-Reply-To: <341212200.103258.1731582827130@app132157.ycg201.service-now.com>
Message-ID: <d83d7d8f-de7b-8191-5c61-e8cfe28c92b3@redhat.com>
References: <341212200.103258.1731582827130@app132157.ycg201.service-now.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _1YLNi0_FP-rvl5avsAZPRLnh0RgTI1iCl8VxJTxHmQ_1731585176
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-138866749-1731585175=:1055718"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-138866749-1731585175=:1055718
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi


On Thu, 14 Nov 2024, Red Hat Product Security wrote:

> 
> Hello!
> 
> INC3151607 ([drivers/md/dm.c] general protection fault in cleanup_mapped_device) has been acknowledged.
> 
> Opened for: chenyuan0y@gmail.com
> Followers: Alasdair Kergon, snitzer@kernel.org, Mikulas Patocka, dm-devel@lists.linux.dev, zzjas98@gmail.com, syzkaller@googlegroups.com
> 
> Rohit Keshri updated your request with the following comments:
> 
> Hello Chenyuan,
>  
> It seems, This is with fault-injection turned on, which is an artificial use case.
>  
> Can this be triggered by a user without that enabled?

No. Normally, small memory allocations don't fail (the kernel will 
activate the OOM killer when it is running out of memory). So, this bug 
can't happen under normal circumstances and you don't need to escalate it 
as a security issue.

> If not, It would be right to send a normal fix for this to the developers for the subsystem

The upstream fix is fed13a5478680614ba97fc87e71f16e2e197912e. You can 
backport it to RHEL.

Mikulas

> Please let us know your thoughts.
>  
> Regards,
> Rohit
> 
> How can I track and update my request?
> 
> To respond, reply to this email. You may also create a new email and 
> include the request number (INC3151607) in the subject.
> 
> Thank you,
> Product Security
> 
>  
> Ref:MSG97709557
> 
> 
---1463811712-138866749-1731585175=:1055718--

