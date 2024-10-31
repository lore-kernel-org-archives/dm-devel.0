Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A495419DF4F
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730387091; cv=none; b=RX7BtRU/Piy1vCUYa/azg1mpooEzuTbOBkxuUYqfnrakR4l7gLUedY/oF+HzrHNsiKi+gV1WhHhMkIrFf1PEsgpM9LtBMWzUP1pqtYfQX1gAYrJqOCDQAngb4Nek5jwAqCHdsDszS6GTn1EYRdKuVWM/F0zoRQZWkuRW3DxUnM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730387091; c=relaxed/simple;
	bh=+tA4wDwz2TZPaOmAL4MX7TXfay5AGNbePbf9bAg+wQk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=H3gQk7fgBu2apW1RXyd2kEWT8MslKDFeFOHtRFtuPrL14XhlH5Lo2Jnly+KbX22I5kl5Rr0EQyqNT3lklXSlcT/mS9FvKVwVJM8YR586LDR+KmP7iUn4UbTUHM8mG1dnUhEDes2OFDMF5eS47CVFe7ly6X9mOTUS502NAES96zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J+x1jHsj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J+x1jHsj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730387088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A/q5mWsXuigjNpZnr7miQ4hULfB2Xqrs3t/tTlz/hD8=;
	b=J+x1jHsjRtiXVRk2SSQME6qyk9wRTehRnDlT1M0WELWafo45WIntODOOWO5/LZUEtqmaYt
	fa9And2vBiA6IGQjfLZai+/QKorYtPssnpa8MIpBtca7dMtrd6Phkeu3igGOXufxJmEhCc
	nja0AtGHxNrJVWdcxSPxnFphsS8bSpc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-175-zLwZ1Q03P8-GOTAOrm71AA-1; Thu,
 31 Oct 2024 11:04:45 -0400
X-MC-Unique: zLwZ1Q03P8-GOTAOrm71AA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6FDD1955EA9;
	Thu, 31 Oct 2024 15:04:44 +0000 (UTC)
Received: from [10.45.225.180] (unknown [10.45.225.180])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE8E71956054;
	Thu, 31 Oct 2024 15:04:42 +0000 (UTC)
Date: Thu, 31 Oct 2024 16:04:38 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: Colin Ian King <colin.i.king@gmail.com>, Alasdair Kergon <agk@redhat.com>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] dm ioctl: rate limit a couple of ioctl based error
 messages
In-Reply-To: <ZyEQ-mT-ojb6R0a7@kernel.org>
Message-ID: <d731f5f9-087d-50b9-998f-d9baac4fdb98@redhat.com>
References: <20241024110431.1906858-1-colin.i.king@gmail.com> <ZyEQ-mT-ojb6R0a7@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40



On Tue, 29 Oct 2024, Mike Snitzer wrote:

> On Thu, Oct 24, 2024 at 12:04:31PM +0100, Colin Ian King wrote:
> > It is possible to spam the kernel log with a misbehaving user process that
> > is passing incorrect dm ioctls to /dev/mapper/control. Use a rate limit
> > on these error messages to reduce the noise.
> > 
> > Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> 
> Mikulas, please update the header to include the context that
> stress-ng is what Colin was using when he experienced excessive
> warnings.
> 
> Thanks.
> 
> Acked-by: Mike Snitzer <snitzer@kernel.org>

OK, done.

Mikulas

