Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D9F1CF83
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 19:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OEneXBeh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704309323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GYaFswZvSZ1McIfBw9+lOGHjxGf1ascQqpXeNmvVMbU=;
	b=OEneXBehpdA1tbH5+VoCYF2jKlHsfxHNbGBp5asyXbmlauX6dzIm4T9fCHdcYyKQlvTPOX
	LDuBGkX8uVxTJS83SP3kOKHap8watodbilJfvIURq1TLylwbPe9hsIt2LP/duFeZpFqT9e
	cP/IVnaee53K5pvXVWRnC5hNbEOCuUU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-YUXQZRevPU2d7ZOmL1DGTw-1; Wed,
 03 Jan 2024 14:15:21 -0500
X-MC-Unique: YUXQZRevPU2d7ZOmL1DGTw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A97F63804505;
	Wed,  3 Jan 2024 19:15:14 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 925392166B31;
	Wed,  3 Jan 2024 19:15:14 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 7FE5C30C1C03; Wed,  3 Jan 2024 19:15:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 7BA8E3FB49;
	Wed,  3 Jan 2024 20:15:14 +0100 (CET)
Date: Wed, 3 Jan 2024 20:15:14 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, 
    Greg KH <gregkh@linuxfoundation.org>
cc: "Yang, Chenyuan" <cy54@illinois.edu>, 
    "security@kernel.org" <security@kernel.org>, 
    "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    "agk@redhat.com" <agk@redhat.com>, 
    "snitzer@kernel.org" <snitzer@kernel.org>, 
    "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>, 
    "Zhang, Lingming" <lingming@illinois.edu>, 
    "Marinov, Darko" <marinov@illinois.edu>, 
    "Zhao, Zijie" <zijie4@illinois.edu>
Subject: Re: [LInux Kernel Crash] "WARNING: kmalloc bug in ctl_ioctl"
In-Reply-To: <2023121655-exporter-deed-6fcb@gregkh>
Message-ID: <b7e39bbd-356e-8bae-7fca-e71ff067149@redhat.com>
References: <PH7PR11MB576877FF72A9B2D43EAA1AEBA093A@PH7PR11MB5768.namprd11.prod.outlook.com> <2023121655-exporter-deed-6fcb@gregkh>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="185210117-1716462743-1704287069=:2256001"
Content-ID: <821f5184-f95-e2b0-e87d-6d1decf8cb6b@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185210117-1716462743-1704287069=:2256001
Content-Type: text/plain; CHARSET=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Content-ID: <c3b28ab3-198b-fc38-d245-d02eee2da070@redhat.com>



On Sat, 16 Dec 2023, Greg KH wrote:

> On Fri, Dec 15, 2023 at 09:47:17PM +0000, Yang, Chenyuan wrote:
> > Hello Linux Kernel community,
> > 
> > We encountered a crash bug when testing the driver implemented in 
> > `drivers/md/dm-ioctl.c` by using Syzkaller. Notably, we generate the 
> > spec for this driver by ourselves and Syzkaller doesn¢t have 
> > specification for it.
> > 
> > Based on our understanding, this bug is caused by `dmi = 
> > kvmalloc(param_kernel->data_size, GFP_NOIO | __GFP_HIGH);` in ` 
> > drivers/md/dm-ioctl.c` 
> > (https://github.com/torvalds/linux/blob/3bd7d748816927202268cb335921f7f68b3ca723/drivers/md/dm-ioctl.c#L1966), 
> > which `kvmalloc` a size more than INT_MAX.
> > 
> > A possible patch is to have a more strict check for the 
> > `param_kernel->data_size` in `copy_params` before calling `kvmalloc` 
> > while currently it only checks minimal size 
> > (https://github.com/torvalds/linux/blob/3bd7d748816927202268cb335921f7f68b3ca723/drivers/md/dm-ioctl.c#L1944).
> 
> Great, submit a patch based on this and see if it solves the issue you
> reported!
> 
> thanks,
> 
> greg k-h

Hi

I'd like to ask - what is the proper way of fixing these types of reports? 
(in this case, there is no overflow, and in the other case, there is 
kvcalloc that alrady checks for overflow). The offending ioctl can only be 
called by root - so there is no security danger.

Should we add the INT_MAX test before every kvmalloc call? (but repeating 
the same piece of code is anti-pattern).

Should we use __GFP_NOWARN? (but this would shut up also genuine 
warnings).

Should the warning be dropped from kvmalloc?

Should we do nothing because only root can trigger the warning?

Mikulas
--185210117-1716462743-1704287069=:2256001--

