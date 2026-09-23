Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1DE4718E1
	for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 09:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790157521; cv=none; b=Makdt+Ru0WbfgKQNbmboDxrB7CHDMEzWT7SgCAyZm+/MghtSbxM3VJRfzoljILYeszftQaFyH2mP0rtu0BIBlvJRrSMlhi0tcqmsb9Xca189i5GXBkT3D0YwAoZ90skW/bmkoF/npDKd1gbXAMHYiqDrXwYbVfgfuuiRP72dv+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790157521; c=relaxed/simple;
	bh=Ewb5vtsCwy9weKsdC41CYy5PZB6uFtx4Vsqm/CY/95k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=EXGvC5/Jsn/++8o2262t9EYfBkDGTq3gTthfXZM2VXzY/1gv3W19rUD6c2x2FJ+5DV7HulDXBLwr7K2GanITRTukZA60cSsAtJTs4pcSxdvMmTlVDlmOEbfzL7g4kO7e2TzmHC5jAUrOw6fsBipAqn5al002LKOlqONcHBLVpqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q/3xp+9J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q/3xp+9J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790157518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XADAmWPRAFo3Wikfq3m+Ve1SmhqcQPLmkoVN0EyX4dQ=;
	b=Q/3xp+9J9RiXqv4z8rImzXr0v3lWbczFaVj4vzV1OSt8OBU3Phw8dnluv5KDxuDeqfF98E
	iwv08BMEqTmi2Ykb6XxzC2vbKW39dLZJUG8lk95/fAvI7cafHyVcs43N7gqiiEaJLgqEvV
	ox/ZzO2IQ6JSXA7vH+lXEO+kRwKv23w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-CHDgkbCoOPuEqWPWV6fo9A-1; Wed,
 23 Sep 2026 05:58:34 -0400
X-MC-Unique: CHDgkbCoOPuEqWPWV6fo9A-1
X-Mimecast-MFC-AGG-ID: CHDgkbCoOPuEqWPWV6fo9A_1790157513
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0C5F1944A89;
	Wed, 23 Sep 2026 09:58:32 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D34EC18005B8;
	Wed, 23 Sep 2026 09:58:27 +0000 (UTC)
Date: Wed, 23 Sep 2026 11:58:25 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Itai Handler <itai.handler@gmail.com>
cc: Eric Biggers <ebiggers@kernel.org>, Milan Broz <gmazyland@gmail.com>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
    Shuah Khan <skhan@linuxfoundation.org>, 
    Randy Dunlap <rdunlap@infradead.org>, dm-devel@lists.linux.dev, 
    linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] dm-crypt: allow encryption sector size up to
 PAGE_SIZE
In-Reply-To: <CAFpOueSjekxhjEosQGiZ9BiDh5tFOqBPX5w_2PVsrcN6pO+dHw@mail.gmail.com>
Message-ID: <9a6c20da-4da9-4a8d-a6d4-f18900228bf6@redhat.com>
References: <20260922120330.127262-1-itai.handler@gmail.com> <07e750dc-570b-4f69-9ec3-68de51416a06@gmail.com> <20260922134945.667305-1-itai.handler@gmail.com> <20260922213457.GA3536981@google.com>
 <CAFpOueSjekxhjEosQGiZ9BiDh5tFOqBPX5w_2PVsrcN6pO+dHw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: tvOF0xJjUYzrZeF77K6EfYsX_TGj6T5NhxGuJMocc0c_1790157513
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 23 Sep 2026, Itai Handler wrote:

> If there is a specific correctness, security, or architectural reason
> why dm-crypt should retain 4096 bytes as an absolute limit even on
> systems with larger PAGE_SIZE, I would be very interested to understand
> it. Otherwise, I think the question is better evaluated independently
> of whether QCE is a suitable accelerator.
> 
> Thanks,
> Itai

There is one important problem - the SSDs and HDDs today have 4k hardware 
sector size.

If you use 64k encryption sectors, the disk may write only a part of the 
64k sector during power failure. When you attempt to read and decrypt such 
a sector, you get garbage.

This is not a problem for XTS or ECB, but it is problem for CBC and most 
other encryption modes. So, the patch should reject using larger sectors 
with cipher modes other than XTS and ECB.

Mikulas

