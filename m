Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C102D7DDD
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 18:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763491338; cv=none; b=iThwBWRK5ydWUu4lzTbcCMsi/QmVIGGe26OQBkW+KEXOL816C5W/S8Rjv1dx2xR+sSnbEn+EaEKOaSMbg7A12Odu5GMaMnWMAhB3rnH6Rma09MA2wb+5z+P603BxAFJmjsjnSE2rr0mgpyPxmh1u4qCBjl3yhbDWIsAKa6TPKkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763491338; c=relaxed/simple;
	bh=4UuRYFeGAdoTlNxDNPqu6TSWsME75fBKGx3v9jRQ+Xs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Frft+ZgSTimQIcufBlcRDdvVror0X9MyD7RzsC0jumyA6qoNEW0hIYU4rw0WnRgkaeQMNgLBU3ViirXRRGh4M94+SJPjLZtBvuRkVo7JxO8I/WN2DTNayGKESgoBmy1SegwhUyh3OTUk/yDDHza+SIjNw+J42ERKdEgW3fyLXnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WIP0Cfz/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WIP0Cfz/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763491335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mAdgqjZmqkNrORjXsj1T2KhBd906JY3Ty/7X9IERoHQ=;
	b=WIP0Cfz/PS9Pslgbkj9Kos5Oxb5GUbNBHTGF7VSxQEy1+5uy7wwiYI8gK9WMi1AJdHqIRK
	xtLM1U1crZlu2F6jWanjI9yT/s5uIPDFcjcJ+4qcLIEY6XwCelanbScppzGeG3cFjA0o/J
	oFGnJ1MvW3BDksdFu8aguobUJ6XsfGo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-lt5jG3vsO1CF1lJsK_i_JA-1; Tue,
 18 Nov 2025 13:42:12 -0500
X-MC-Unique: lt5jG3vsO1CF1lJsK_i_JA-1
X-Mimecast-MFC-AGG-ID: lt5jG3vsO1CF1lJsK_i_JA_1763491331
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F220D1956088;
	Tue, 18 Nov 2025 18:42:10 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9CE2180049F;
	Tue, 18 Nov 2025 18:42:08 +0000 (UTC)
Date: Tue, 18 Nov 2025 19:42:04 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    michael.christie@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
In-Reply-To: <22e40d78-8a14-4101-ba0b-58e94b494432@oracle.com>
Message-ID: <702ec1b5-2995-1f3c-04a3-3a4372460b42@redhat.com>
References: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com> <6b3582bb-1e50-4e7a-972f-a82f62f46e7c@oracle.com> <9d2816c3-fc01-44d0-a9ca-4129515bd0ca@oracle.com> <4ba947ac-969a-49da-193a-ea5cea43c14e@redhat.com>
 <22e40d78-8a14-4101-ba0b-58e94b494432@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lNm81JClqbDPEU-cWppz66kMcoEiwVtD9MqATh_Wh4g_1763491331
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 18 Nov 2025, John Garry wrote:

> On 18/11/2025 17:09, Mikulas Patocka wrote:
> > In crypt_io_hints - should I set "limits->atomic_write_hw_max",
> > "limits->atomic_write_hw_unit_max" or both?
> > 
> > I think that we haven't settled about that when we talked about it.
> 
> If you are going to set one then set both of them.
> 
> I already tested this, so it's fine.
> 
> Thanks,
> John

Hi

I committed those two patches - you can have look at linux-dm.git, branch 
for-next.

Mikulas

