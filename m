Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C373434CFCF
	for <dm-devel@lists.linux.dev>; Thu,  9 Apr 2026 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775752976; cv=none; b=MoTDsBMIwnEodfHK0yHWeXp9kxq7wtyDIZBDRz1SPvRQKz6uQlNU2te+cBt+0O7BlBm/hInqJmS+8Tb/oNG5tyEhpfCF2bAlpTbxkBjmuPjuJTysvXC7c4th2LJzldwu+0jn6kVmyM185Ilsp+nF3+qduMkTssSf4nDVD4VK6Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775752976; c=relaxed/simple;
	bh=nPf1/y7HAdOn12A37OtyTQGip5MlguU5puVzg6q7pQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=o/XtZhDMTKe61mf5JcN+xtqnnyTTUnPQIjqFx/Ym3RZVBTzxksRUvYp1dDj08TgZRekSbIrL5MdaStRMTg66mlUcZfQmU/qg9Y6JjCso11B9nbRo7TxCr1hYRLsbVH3gDtK2DwLx+bUdFobmHkYNmg/nIWwQFZIc/R/mT7pT5kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XOK7MET2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XOK7MET2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775752973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=unkeWFSOGMHUQQo/TgU1Gk42YwqUaKuecXgmku2k9Z8=;
	b=XOK7MET2OkOsPrP1eY5Oc5vOz66YOE9rduXPgw9zW7xvDhx9GbIbaFyRHGzqtwpLXebNxz
	jH+O4Cc4LLtVd/liTBica+QQLqn9iP9ERi8wfNW7hvxbN0BsNZSRgt5UD2PHm2+gewMT7s
	Qlz2vG7qyWGAmKBT2yf6bspLOks9tV4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-dHifwev6Pq2Lrl8QuJKiOA-1; Thu, 09 Apr 2026 12:42:52 -0400
X-MC-Unique: dHifwev6Pq2Lrl8QuJKiOA-1
X-Mimecast-MFC-AGG-ID: dHifwev6Pq2Lrl8QuJKiOA_1775752971
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43cf6758644so588873f8f.3
        for <dm-devel@lists.linux.dev>; Thu, 09 Apr 2026 09:42:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775752971; x=1776357771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=unkeWFSOGMHUQQo/TgU1Gk42YwqUaKuecXgmku2k9Z8=;
        b=InizSe77ZDTccGQyEJQCaa0UCHDsxP0wSOddnbBzjEoZUvMWgy25H019/XgLYt6GEi
         RAP6yp58QWXpJRAlGoiA+3BjWJGXc07xMJdbWWDIrsth5Ag/lKym6KUDil/O5BkVwcPt
         +t243bZ54xm6b9QIbTFyEmLIGj4JKaQJT7MW7sWvOsbyKR2B9aG1XlUHK5DvtXPoFD8Q
         8RYrCjSHsly1yIN/CbJJeMerviktqAXLZYCh9vORmORcFKKioMsFa0A0zV1L119kp9l+
         zshz3GKXhkpjDlK7YOSqxmiScc0gffC6fon6h5CLfckW+xT3Dc+18Dki92TD3D8ostKF
         js8g==
X-Gm-Message-State: AOJu0YxVOP8OluicQd37RkER7/Jy9h8zEKLPVgLGliVH7SpbCxWloFPm
	jYyFJi0fnbpFw7eQVEsoRKIdqkhrBG+8IgmHIRXzjSniQCBmXq3AMOW3HrXxyyJwP+fYsUfreif
	ZghK3BcJYLVV2noelrNsU7/cEebVFtZfchWd4qyRWL6BrGu0PKumJTg223XG/
X-Gm-Gg: AeBDiesXjCGnqOk4N2TGWT7WLzk0wR/EtLncUGxL0tFT7mo/yjbv/tUtlgup/pBDU8/
	vNiFLgFO8+ki8NXQrTm8u8wsUWJdQL5u9M0hA+Pq0XKSJ+H3JdzGFp+q8St4x9oafHFDO6VbgU/
	tA7lWH5em0YCwVpAu97WNqiF5AEOixvsFabgFzV16hzGSur/ZbT2A1C5dITX76QdnABZUzBKGIw
	xo9Z0DYLlK6eNxJA4KRgSH8a2dz9v9vxUFDzDegv4kqejpX6Z66walmg8u1Ul6SjTTxIXp8db6E
	PDqnfeF0AOzfIarjwP6lte87gA9IHLt3GeAR5oWjjM9YBR1Nh0k+h8Z/is43HddtaRGqQnii+Gd
	kM5+D3kswF/XY+Q==
X-Received: by 2002:a05:600c:8b0a:b0:488:a2ac:a337 with SMTP id 5b1f17b1804b1-488ccffa903mr68017035e9.21.1775752971157;
        Thu, 09 Apr 2026 09:42:51 -0700 (PDT)
X-Received: by 2002:a05:600c:8b0a:b0:488:a2ac:a337 with SMTP id 5b1f17b1804b1-488ccffa903mr68016655e9.21.1775752970732;
        Thu, 09 Apr 2026 09:42:50 -0700 (PDT)
Received: from redhat.com ([150.228.103.85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5b3d4dbsm2970225e9.14.2026.04.09.09.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 09:42:50 -0700 (PDT)
Date: Thu, 9 Apr 2026 17:42:48 +0100
From: "Bryn M. Reeves" <bmr@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Tony Asleson <tasleson@redhat.com>,
	Alasdair Kergon <agk@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] dm: fix a buffer overflow in ioctl processing
Message-ID: <adfXCEMPDWBh_Bi0@redhat.com>
References: <510b5754-3944-6b4e-03b8-f3a7dc137944@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <510b5754-3944-6b4e-03b8-f3a7dc137944@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7bU_4HrOahUIAL9qhy2MLbdON4mZFSghbmob1L8jPIs_1775752971
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 09, 2026 at 05:49:58PM +0200, Mikulas Patocka wrote:
> Luckily, this bug has no security implications because:
> 1. Only root can issue device mapper ioctls
> 2. The commonly used libraries that communicate with device mapper
>    (libdevmapper and devicemapper-rs) use buffer size that is aligned to
>    8 bytes - thus, "outptr = align_ptr(outptr)" can't overshoot the input
>    buffer and the bug can't happen accidentally
> 
> Reported-by: Tony Asleson <tasleson@redhat.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Reviewed-by: Bryn M. Reeves <bmr@redhat.com>

