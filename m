Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6E31F942C
	for <dm-devel@lists.linux.dev>; Fri,  3 Jan 2025 16:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735921285; cv=none; b=ZsdvRQDcIHEnXD0LKC+8t40OXj9tZeGrzpVCu6j55B7SVJbC3gF8kHWhD0owRYlBxD/hqyc9QHgdiPivjmnfHlosYvxVt5D0lHEFjsua0ykWb1EDCEnXMEscyPALcogt4K7Poc7cIdZp2zImt5ffm5b2hjcOITbf2Iwd3Wf68eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735921285; c=relaxed/simple;
	bh=XtCxCsyFaT2aTAPEyVFYtq3CDfR/K9SGICq0OBCes0k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bWzo06pRVi9J8F0KgYst3BPLQkWZ3nWLx0oGXh/j90hVJDnsTSFI4t3S2H2pRc/dnpuDzLFobTpKRlbi9SbT2acjFWmj1b0v4QfVtBWYcnrMoJXgoOEQ4ZmtuapVH9UIXneDwWhQwnXwbQq7bFntpPoKv88ZW1hXZhQqsAG3i5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EycZJs0/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EycZJs0/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735921282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B8spL43ZQz2UCHW30ztMjR9tOsebXIHHpfJ2lMl5/sM=;
	b=EycZJs0/uLUFSCzkQ+Lzh+WoDTq2PAVCKwTwoA+zOFFGZaOEgRX143Vphg0EVDen97QE8o
	z7VqUNL7RAgc2MFec6bPMJYBOWYf2Tf7xaHvfO+PqRuw17gUeNck8Xm0XKLzZ0ZJdWze7X
	qUnFmCg4c1IVjWgyu0xJJKS7+xIWICE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-7q5Sa6nQOFmzimpzQnZJ8g-1; Fri,
 03 Jan 2025 11:21:19 -0500
X-MC-Unique: 7q5Sa6nQOFmzimpzQnZJ8g-1
X-Mimecast-MFC-AGG-ID: 7q5Sa6nQOFmzimpzQnZJ8g
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B42019560AE;
	Fri,  3 Jan 2025 16:21:18 +0000 (UTC)
Received: from [10.45.224.27] (unknown [10.45.224.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F85B1955F41;
	Fri,  3 Jan 2025 16:21:15 +0000 (UTC)
Date: Fri, 3 Jan 2025 17:21:13 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mohammed Anees <pvmohammedanees2003@gmail.com>
cc: snitzer@kernel.org, agk@redhat.com, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, zkabelac@redhat.com
Subject: Re: dm: Allow the use of escaped characters in str_field_delimit()
In-Reply-To: <20241215101336.1456-1-pvmohammedanees2003@gmail.com>
Message-ID: <034eaa34-1737-6f75-2227-4e0dfbc753cf@redhat.com>
References: <Z1hrfMRedzEJb26O@kernel.org> <20241215101336.1456-1-pvmohammedanees2003@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-1776060455-1735921277=:187354"
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-1776060455-1735921277=:187354
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Sun, 15 Dec 2024, Mohammed Anees wrote:

> > It would seem Mohammed cared enough to write the patch, but not reply
> > to you with further clarification on why it needed...
> 
> I thought I had already replied to the concern, but it seems 
> the message didn’t get sent, apologies for that oversight!
> College academics kept me tied up, and I lost track of this,
> apologies once again.
> 
> > BUT, in this instance it follows that: if lvm2 is allowing weird names
> > which require escacped characters _and_ dm-init is used then dm-init
> > needs to support handling them (dm-init is all about _not_ using
> > normal initramfs with lvm2 in all its glory).
> 
> I completely agree with your point and am more than happy to 
> provide further details or make any additional updates to 
> the patch if needed, please let me know if anything else if needed. 
> Thank you for your time.
> 
> Regards
> Mohammed Anees

Hi

I don't want to bloat the code with the logic that no one uses. I would 
only accept the patch if there were some real scenario where you need to 
use escaped characters in device names or table parameters.

Mikulas
---1463811712-1776060455-1735921277=:187354--

