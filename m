Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2302E410
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 01:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709171034; cv=none; b=rUi7BqXXgBnl6PIhDPiJw9yPPs6LJjlj0VtL0cYiqQ8QyKow4YW5hMK9LtKpYsmley8aOevF9zMZECsDB9L9sSQY6tOWuWLnXcX0PQ++14N9+DACMy4eTpZRs3IC0XAOlChcBpKLZLuAEC1d6TMDT9ZE+VwBynQ8oQ1SSgfEMPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709171034; c=relaxed/simple;
	bh=h5CJevDeVLAgOM8PlGSAD+6pp7wbEEAill3QMPTNCcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=OOI6XUzoZwvXn/flZXxmURwcRjXHwVW8aL2+kJLBoemc83xWuPDsUisbcCeWhlPYFkTJHoDGfPlMxy1FW4t0ICz8iwmfFdlia8c2Kn6a4jDEkTtNpMX1JdYzJwZ4M1rOOX2rvqayPqYUnLAqM++tMxBo0mOkEM7dLZi7I8+4ruQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bMlzNkux; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bMlzNkux"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709171032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cp2uZ/Q+UnJoC/yZxBWM0l/WE9YN4IlAsRchJZIA5Ls=;
	b=bMlzNkuxrAjf1kBfmmYFCBCD4JYGdkaz1XxLK+nWzCpD2P8+Q485qQc4Ul9HOej2Z1WSV3
	acpqePDRKabVCwnxO2JDzcj6P450MUZGsS9vVQnSAAmjCGAOywfB2pL8ITWGl0fy7c0VB+
	3NnlQVDDNKhMekZChQbWQi3DeP3fYIU=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-XNRojvKVPx2oP-OYjkT4JA-1; Wed, 28 Feb 2024 20:43:49 -0500
X-MC-Unique: XNRojvKVPx2oP-OYjkT4JA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1dccd8076b0so5009315ad.0
        for <dm-devel@lists.linux.dev>; Wed, 28 Feb 2024 17:43:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709171028; x=1709775828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cp2uZ/Q+UnJoC/yZxBWM0l/WE9YN4IlAsRchJZIA5Ls=;
        b=MoG9a4R3akmj5PCUPLR+DD9eKP3Aox3bXxSfCsScqLrOOjC3TZpIc1nFd/BJrRtgVW
         UQRlhA6gAzV0vNNhJmSwcLdj4RFvJxvX5YCC/NqGU+niTs9hKNkpbti6Pfjkmj6hwG15
         Y50emlyWyz87NzVokv6Gzy+Y8c0SyY5/l8JPxBwNEHCFy80mpm5kk29a8lb/ooLtkFuN
         oqQyb4oiP8mwr4JGqzysErAcMQyP6R+Y+h1KbX7d8YzAoF5jPAgziaIuwFCNwxMngJfx
         f2YsvgHXHvS6K4mRVt6xJOqjWuI1C2Uee6w/hG+YXJiB+r/N3mIVnfKZhjWGkII2qnTn
         CXqg==
X-Forwarded-Encrypted: i=1; AJvYcCWS6hKSy15NWlvULaV/l3sF/8cnyM8czZ5exmdj0UjCJLe6ogXTWpm1nn6Qy5WKyIwobwDqsntqbblVglbpjrocwbtOe0AT8dY=
X-Gm-Message-State: AOJu0YxtJvpc0SxdQw5ubCOP2S987XFWOpnE7YseIfo8XHuL5JN8wJzd
	fM7evG9BCGE7j0dRVDUvltbDM0+Ith/qQ8hlAiPxQgD3ZfZCQfForG94eTP4AkTXpIPFyGNsH7O
	SASJdSuGPs0ee5EvZYrqX70FBndMYJIeCS0WKqfphSSFUa1ooJGWRa39l
X-Received: by 2002:a17:902:d2c2:b0:1db:8fd6:915e with SMTP id n2-20020a170902d2c200b001db8fd6915emr983989plc.33.1709171028722;
        Wed, 28 Feb 2024 17:43:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8eSN+jPorPo/AeEJbYjM2MQMeA2ypoIIBoQpNf5SwynBm/qEoEiWpH4kKEDKwWQ3sL0ppXg==
X-Received: by 2002:a17:902:d2c2:b0:1db:8fd6:915e with SMTP id n2-20020a170902d2c200b001db8fd6915emr983960plc.33.1709171028447;
        Wed, 28 Feb 2024 17:43:48 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e12-20020a170902d38c00b001dc05535632sm111923pld.170.2024.02.28.17.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 17:43:48 -0800 (PST)
Date: Thu, 29 Feb 2024 09:43:44 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] common: dm-error now supports zoned devices
Message-ID: <20240229014344.ftd6v3zrjbvtnhth@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240221063741.3563039-1-hch@lst.de>
 <20240225163828.7a3tntpg5kaywlw7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240226095829.GB26465@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240226095829.GB26465@lst.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 26, 2024 at 10:58:29AM +0100, Christoph Hellwig wrote:
> On Mon, Feb 26, 2024 at 12:38:28AM +0800, Zorro Lang wrote:
> > This patch makes sense to me, but I think this patch might cause
> > failures on old kernel which doesn't has kernel commit a951104333bd, right?
> > 
> > Is there a simple way to check if dm-error supports zoned block device? If
> > there's not, I think we have to let it fails on old kernel, to make it run
> > on newer kernel.
> 
> I don't know any way.  But as this just affects zoned devices on btrfs
> for now I guess the usual parties can just make sure it works by
> backporting the right patches.  The previous don't work wasn't even
> a not supported, but a case of dm-error being buggy for zoned devices.
> 
> In other words the original exclusion in xfstests should have never
> gone in and whoever put it there should have fixed dm-error instead.

OK, let's have this patch, and see the response from others :)

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 

