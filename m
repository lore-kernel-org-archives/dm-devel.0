Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B82D178372
	for <dm-devel@lists.linux.dev>; Wed, 21 Aug 2024 21:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724276383; cv=none; b=nPalTBeKPsK6naCx2ZZ0rZI1BFrM9rlnbkE8vlBlGm18FDv1tBBjd04FqGLcphIgvdsVWNhrFUzeav30fiQJcC+oS1StriTwcosTdS/esa7CU5jgTBHUSdQg12UjlW36cSdH8wtMLH3lVtwkVsSMxvZn63e1lPjkZjInJX7PQ7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724276383; c=relaxed/simple;
	bh=pOwO2E8B+DbgMlyTF+nhtcaOGAY1lQANOYC5GF+z8ao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aRmZLSme8i5N1M3Jyl+LUMO5QoyUVsrbnHDJ00z1dlkHTKEUGqESvn4cwcnzB5uBkXcv2/GF3TFI0VKmkBjIuNfaUzd1XBIhu0HaPQ8DPZc9IYbYkLI2Fua7JsdhyQyCEZFpS8mI0cumFp+zax5OfTRIZaSgLb0/YF1BcdQL0QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T9okU7v3 reason="signature verification failed"; arc=none smtp.client-ip=170.10.129.124; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T9okU7v3"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-2689e7a941fso83541fac.3
        for <dm-devel@lists.linux.dev>; Wed, 21 Aug 2024 14:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724276380; x=1724881180;
        h=content-transfer-encoding:mime-version:list-unsubscribe
         :list-subscribe:list-id:precedence:dkim-signature:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PqlvP3RzvApaA6uBh8VzpcyOPcH0XWTzCP4WmrvJr9M=;
        b=UyPilCIazSEssOOxttaGMIWFvapHsORjCKevMBXYJiVmv1DDFPlYtJiO0qrLYmdjWZ
         llMdttsfJE1fuN/Vnyocn3orXpPlicCEJknMIRoTdaFBcj01K6U2Nt9hJsxvQ4/8cNGe
         Ujcx/S/XPRuvOsQ8b+FZihvUCDwoY2A6iyQKRXxzFsrdT9hOHzV9T18WFBzWrNVR8M8j
         jIiMPfTZuljXdf7KQ+1KbbNpwiOOJD7+4rpYgsOlNXTpFTLUN3F8pbGhpudT4ZgHvrlm
         UuvrJd30Wj/HRQ3NmTr1u1Pa84rEeQPNFdcU8OMhrUfkWTqP7F798zHwkmIzJpFFsZGR
         bJCw==
X-Gm-Message-State: AOJu0YydJX4nWDX6A0m0pOC9kkNz6+JHnPSQ4DnliWYthS/2PXd9YYmO
	goLNqHayaMyf6qI/VGLtYFWxL5K/pPj3xTT9/3+LhwMxKWSA5F06IswPoyzEng==
X-Google-Smtp-Source: AGHT+IEIvhqCmkcUTfwvS9UErFgOeN0LioFxnXKP4KPK3nGRNhX7DX8LfFGk6WCa0h9QSA1SHhb7QA==
X-Received: by 2002:a05:6870:71d6:b0:270:2c3:f362 with SMTP id 586e51a60fabf-2738be24ddemr3826859fac.32.1724276380052;
        Wed, 21 Aug 2024 14:39:40 -0700 (PDT)
Received: from localhost (dhcp-132-71.EECS.Berkeley.EDU. [128.32.132.71])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-7cd9acabac9sm66490a12.28.2024.08.21.14.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2024 14:39:39 -0700 (PDT)
From: David Chu <thedavidchu@berkeley.edu>
To: mpatocka@redhat.com,
	David Chu <thedavidchu@berkeley.edu>
Cc: dm-devel@lists.linux.dev
Subject: Re: dm-integrity and write reordering
Date: Wed, 21 Aug 2024 14:39:08 -0700
Message-ID: <219dcade-3d6b-b5ac-c11b-efb8dcd3bc63@redhat.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <CAHge_00RZ7r8Np0F4PdH50hTsX-OrkXznKU2u+R9qD16=vx0_Q@mail.gmail.com>
References: <CAHge_00RZ7r8Np0F4PdH50hTsX-OrkXznKU2u+R9qD16=vx0_Q@mail.gmail.com>
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124]) (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits)) (No client certificate requested) by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91071D12F4 for <dm-devel@lists.linux.dev>; Wed, 21 Aug 2024 20:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com; s=mimecast20190719; t=1724270900; h=from:from:reply-to:subject:subject:date:date:message-id:message-id: to:to:cc:cc:mime-version:mime-version:content-type:content-type: in-reply-to:in-reply-to:references:references; bh=fBQXoB3FDv+Jsur9P822UcZn4fuAMFTapF27zvyax9g=; b=T9okU7v3Pvb0LJDYNUWZADXe7y2VSpPfMiBMY3fti8qpygUuR80GsdGGHyZeW+521lOYj6 GwNM3tGK8YD70q6AsKd+LgCPrWVj6CbdK4X2NuwV23Rwzc8/EpItmk01UM5TnhjqAOQc6p nyrW0qwSBwlPYcJeWk8oqaqmniZz7AI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id us-mta-361-S_TamtTLPIK-by7EKfcjSg-1; Wed, 21 Aug 2024 16:08:16 -0400
X-MC-Unique: S_TamtTLPIK-by7EKfcjSg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40]) (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits) key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256) (No client certificate requested) by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA1BE19560AD; Wed, 21 Aug 2024 20:08:15 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222]) by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E2EE19560AA; Wed, 21 Aug 2024 20:08:14 +0000 (UTC)
Precedence: bulk
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Message-ID: <20240821213908.ncABY_hI_vgRL2_D6op6zyvqXFMDDMmEp86kM_0IhOo@z>

From: Mikulas Patocka <mpatocka@redhat.com>





Hi Mikulas,

On Wed, 21 Aug 2024, Mikulas Patocka wrote:
> 'D' - do nothing - dm-integrity doesn't do anything to try to maintain 
> data/metadata integrity - if the system crashes, the metadata may be 
> corrupted. It may be useful for things like operating system installation, 
> where you don't recover from a crash at all.

Thanks for the quick and detailed response! I am actually *not interested
in crashes*, but in what happens during a normal run, when there are two data
writes to the same sector on disk. Let's say these writes are write A and
write B, and we are running dm-integrity in 'D' mode (so there is no journal).

dm-integrity makes sure that if the writes' sector ranges intersect, then one
write will not be sent to disk until the other returns, like so:

  Write A and B
    | 
    v
  -----------------------------------------
  | dm-integrity                          |
  -----------------------------------------
    |             ^                    |
    v Write A     | Write A end_io     v Write B
  -----------------------------------------
  | disk                                  |
  -----------------------------------------

dm-integrity then stores the hash of write B.

This behavior suggests to me that dm-integrity assumes that if write A returns
before write B is sent to disk, then write A must be written to disk *before*
write B (or maybe write A is never written, but in any case, write B is the
final write). Otherwise, if the disk reorders write A and write B, then there
would be a mismatch between the hash that dm-integrity stores and the actual
write on disk.

Is this the assumption dm-integrity is making?
And if so, how does it square with the hardware reordering I/O requests?

Thanks,
David
