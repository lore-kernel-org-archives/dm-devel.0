Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A963920D4F6
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 18:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745347393; cv=none; b=Kd4L7YLg+xrigbdsWmDEHE97w30puWdjWQtEgakoOm0ol/I2mZmuyKEHX6EdCcZBwfXj2za43apvM5m7BUS9yqBtX7BcG1S4USDnuYw0gDxpmCBLnE9LQliwHNmaUi3oyT9Uhwh4m8XgFnhXlTNh6sSBalQlYV8StGLiaRtEvzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745347393; c=relaxed/simple;
	bh=dtF4ZXudoYr4DUQlg7C0dSU+gLOKl3Tyjl5jXbB5TV4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=diV4d+JP8iDMksH1HC5ttc5TW+SWh8yQv2K3FlkPSkdbX8D6CJPc4E1jwtoziPMxZ2VdQa/3DtUCOc58TTAZdiZds5OAz/+Ny9AYJurjRs1ucVRN01T/WrV8n+UiqaT0UvEE07qVl2DccLf2fzbKP+9tN9sVMwYQubGgdhuRs78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eD+Bx2ZP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eD+Bx2ZP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745347389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=37OvEDZw4JLJz7b4TF4TpazsNXf4OtLZGAIGUHTCyug=;
	b=eD+Bx2ZPHrFTRXQ12bos2vkA73G+VWKCAZQSF5CCoezrV+lzqH9BXs7KXg6p4hoZpfGiJT
	sS+1vEHE0flFDeXQgbb6IWw8gLqH+schz1f/aPNNlnToFN0NehD8b8EvCcasB5ZllDpdiU
	NmvjfY5SYM+qXRnwut9jdcfwJGxv6c8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-324-dm5RJpKdPfqMbCmen17Wqg-1; Tue,
 22 Apr 2025 14:43:08 -0400
X-MC-Unique: dm5RJpKdPfqMbCmen17Wqg-1
X-Mimecast-MFC-AGG-ID: dm5RJpKdPfqMbCmen17Wqg_1745347387
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A28121800360;
	Tue, 22 Apr 2025 18:43:06 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 685971800378;
	Tue, 22 Apr 2025 18:43:04 +0000 (UTC)
Date: Tue, 22 Apr 2025 20:42:59 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
    Christoph Hellwig <hch@lst.de>, Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2] dm-delay: Prevent zoned write reordering on suspend
In-Reply-To: <6d4718f8-49c2-451f-8253-37a0ba039c80@kernel.org>
Message-ID: <9825d394-19f3-d454-4c86-93a9c2fc798e@redhat.com>
References: <20250411000435.1007720-1-dlemoal@kernel.org> <81bd6eca-6d62-6934-9007-28eaef465bb7@redhat.com> <79733459-5674-4bd3-9a33-dd5fbd7ed651@kernel.org> <cadd3b0f-2eca-c8af-62e9-27dd528007bd@redhat.com> <222c2fac-ae6d-4b6a-8a83-a40eaf044d44@kernel.org>
 <d9c47917-0ff9-5d6a-01a3-cbb357ca6812@redhat.com> <6d4718f8-49c2-451f-8253-37a0ba039c80@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Up_eQSTSKqL_Wjudwou40WLoCML-knENtCZXwth3yzI_1745347387
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 22 Apr 2025, Damien Le Moal wrote:

> It is not because you do not see a clean solution that there is not one. So
> unless you have completely made up your mind already and are not willing to

I haven't made up my mind completely.

> I do not understand what you are talking about. A zoned DM device is zoned
> because it is on top of a zoned device. That bottom zoned device may be another
> DM target or a real zoned device. For the real zoned device, zone write plugging
> is always used so it does not matter if the host controller does or does not
> preserve command order.

I understand that. I don't understand why can't DM devices also use write 
plugging. What kind of problem are you trying to fix - a performance 
problem or a correctness problem?

> There will always be at most 1 in-flight write per zone, which makes 
> reordering of commands completely irrelevant for write commands success.

If reordering is irrelevant for the underlying device, why is it relevant 
for DM?

If the host controller may reorder commands (as you say), why can't DM do 
it?

Mikulas

