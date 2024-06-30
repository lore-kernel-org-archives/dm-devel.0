Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D402C6A3
	for <dm-devel@lists.linux.dev>; Sun, 30 Jun 2024 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719767593; cv=none; b=bVIL58ABJ1sdBq4YyI61SimxrRNjBwCeGQGhkbmsCHpNJnCrdrsuryxmDzo9QxX1Rl4vBpJgOzeIZ4GdCxw2YVU97vG+8QycosOgRfvhtaG8KefM+6qZ1Bh/H49ob82nzzQJh5QQ1cMP3+qAuvqMriqOGC7ZDBpFPzCT1eYQefA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719767593; c=relaxed/simple;
	bh=Qvyy3/lXwyEKWXW3eZp7oyXDjXCqcmUmVrNjAO+0GB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y24meo2feUIxbmt3agEdkTbmb2fM7yM30xHtehCyAs5KUWiLVMv5fbBBQ4bWM4QRmsypfVZNt2X54wJTROwIhHKA2TdV+F2vIWGyPjp5lXiWKypoUiXaTMQ09XlGWLEk4TGEmhziRorjfjg/pcKJNytWJrsGhn2VEcrEoPVgbss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E5OqIqSC; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E5OqIqSC"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7f61549406eso88482339f.1
        for <dm-devel@lists.linux.dev>; Sun, 30 Jun 2024 10:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719767591; x=1720372391; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0TlkErQpa0xa7YZ2T83OsxknNGSqMh+VvQCwH5wNmHY=;
        b=E5OqIqSCA1uCMqJCWnG2u7GkCYQetqR8tUdVd3aZLDdGsUM20YO8nqCBXHiK/DH0Pl
         /Jztlutiks+9XineM+5UNs7e8JrJtzkL3lSmDucH0CFZc03nAHZn654noKS+WJUNyquj
         6nqfEcrricJJgNY4TgebugmTeAT1h2jPVCPXX/4FkZHy118/nP9/KPuUH8AXxLjX6nle
         rXjcsxhIkrO6CQHBayl7b9JD6zl9Zt5wAKCxGWnD2W8825t7bQ35QNvLEZHwBPK7MRTh
         0wLbGCU28kQQZyAbxBVGt5kRiO9IpUFyHIlh3Px/PC4lCVQdHEYG5vJjAaFoQZHxf6aa
         bwYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719767591; x=1720372391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0TlkErQpa0xa7YZ2T83OsxknNGSqMh+VvQCwH5wNmHY=;
        b=vYY9GanuO0b+Sd0kN4rvg18zRDm+AxwBAl00+85E5Lk7uFul1g38eCADc0NacdL4At
         hTzfhU1DaGGf4NuFFUy3s3YiawR74Wq/pG6ITUaha2c4V5qjv+Lakb6uOs/lBNnk+VKJ
         bvr9Gom9y4Wt5f1ManhjRwL76StnO1Mpgd/8v8F65fHOjo5T2o6wH4IZVjffXZtAFEoR
         ibB7xkZ4fDmgRLhBqkJMpNHBianH7z1K2Pv/SfjuHUZX5Ha2c0EInpbLwFBsy0D4nYnT
         tRPkaI26advLSIzqBeSWvlC66+jRDmrIy+IoG7pjcUkYHC2+U/R3HeGyUalmsVXM+ViM
         swXA==
X-Forwarded-Encrypted: i=1; AJvYcCWDd7KzwXR+kK0yyNNXNO01bsS/w5xh1dE3E07YrpVUGh0k0UuyiS28fVlxGfv6QPq30U3HphGIhohYOpEIFWRBdufM1e2efdA=
X-Gm-Message-State: AOJu0Yzo5HmoZstdahz5om1gXFYqeBJLuvqTy8/y6WeCUyL2Pf0XZ8fO
	U71Wc0j3Vy5YMwbv6NYalJyy2285H1+5NJq/nnwI7aPcAOqRu8aM
X-Google-Smtp-Source: AGHT+IHL5QOdEfhGtEp4jRiJ9wOspdZ3OAW2+SZYHN4iHgTZ+RSxfUJigxeqU9GpA9qg3ovx2PO/Ow==
X-Received: by 2002:a6b:7314:0:b0:7f6:1f20:f136 with SMTP id ca18e2360f4ac-7f62ee7a0cbmr443659739f.19.1719767591625;
        Sun, 30 Jun 2024 10:13:11 -0700 (PDT)
Received: from localhost (dhcp-141-239-149-160.hawaiiantel.net. [141.239.149.160])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6a7e5cd2sm3894217a12.28.2024.06.30.10.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jun 2024 10:13:11 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Sun, 30 Jun 2024 07:13:09 -1000
From: Tejun Heo <tj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
	Waiman Long <longman@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Laurence Oberman <loberman@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Ming Lei <minlei@redhat.com>, Ondrej Kozina <okozina@redhat.com>,
	Milan Broz <gmazyland@gmail.com>, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: dm-crypt performance regression due to workqueue changes
Message-ID: <ZoGSJWMD9v1BxUDb@slm.duckdns.org>
References: <32fd8274-d5f-3eca-f5d2-1a9117fd8edb@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32fd8274-d5f-3eca-f5d2-1a9117fd8edb@redhat.com>

Hello,

On Sat, Jun 29, 2024 at 08:15:56PM +0200, Mikulas Patocka wrote:
> With 6.5, we get 3600MiB/s; with 6.6 we get 1400MiB/s.
> 
> The reason is that virt-manager by default sets up a topology where we 
> have 16 sockets, 1 core per socket, 1 thread per core. And that workqueue 
> patch avoids moving work items across sockets, so it processes all 
> encryption work only on one virtual CPU.
> 
> The performance degradation may be fixed with "echo 'system'
> >/sys/module/workqueue/parameters/default_affinity_scope" - but it is 
> regression anyway, as many users don't know about this option.
> 
> How should we fix it? There are several options:
> 1. revert back to 'numa' affinity
> 2. revert to 'numa' affinity only if we are in a virtual machine
> 3. hack dm-crypt to set the 'numa' affinity for the affected workqueues
> 4. any other solution?

Do you happen to know why libvirt is doing that? There are many other
implications to configuring the system that way and I don't think we want to
design kernel behaviors to suit topology information fed to VMs which can be
arbitrary.

Thanks.

-- 
tejun
