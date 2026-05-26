Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C712F33FE33
	for <dm-devel@lists.linux.dev>; Tue, 26 May 2026 19:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779823695; cv=none; b=H9xDqSsTt2HrTuWX1bcFEuy6CXMQtxbgnUvoXPgW1Tq3o5YJfmnTY7FjQcGyCHYH4AobeJv8WLkkuNjTRiiuSLEesa7txK7dHWyeMhmhxlcLab6aoLd8iMsTW8sgpj1+Td0N5pTiCMLkG1usgD70BkOA9pk103OJA3smuo2OvTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779823695; c=relaxed/simple;
	bh=6GG9F2KZm3mqjjx2JsbzE/NnRnPg09L4udxOzEZdDl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=HmeiJ6fkO+BMl7+1uGqt1ygP8T3YGZvR6Bl2gFyODGArXxbfyOiOQjH2IYAtmRRlD8HV4H0JRVFIu0FjHvOvMp4anWDSEp2yWRE4B92evwfNoJ2g9WtTQ0ifsD4+fZb8zK60ZMM0sdHm2gvjN3qBGRqDFqBdEg3pDU+qhu9pnPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f4i3sefx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f4i3sefx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779823692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2XAm2rnSCSQDIEA7dUZRrXQ+JUGnFhPkt3UdnjgYGCE=;
	b=f4i3sefxXq47wYG/1zTCz2YNFT43S8dEG+dw5PfkKjk7fpgGmtlAkscmhU2e4B3kJKAF/c
	PwbBVcnnbC0rUyFxF/V/gHTeN0+3dw3CS0cnJwxePqFyE4ka8Fuq3IX2o2RtBM7zqTueLL
	HEUDl5A4T9FKbTulRpURPsktjXsf4VY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-gGjTLrzpPtem0hxUXOzoaQ-1; Tue,
 26 May 2026 15:28:10 -0400
X-MC-Unique: gGjTLrzpPtem0hxUXOzoaQ-1
X-Mimecast-MFC-AGG-ID: gGjTLrzpPtem0hxUXOzoaQ_1779823689
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B60E01956046;
	Tue, 26 May 2026 19:28:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F5E81800465;
	Tue, 26 May 2026 19:28:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64QJS7834146547
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 15:28:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64QJS63K4146546;
	Tue, 26 May 2026 15:28:06 -0400
Date: Tue, 26 May 2026 15:28:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [BUG] multipath-tools: 0 cyl reported on large disks due to
 overflow
Message-ID: <ahX0RqXAVsKWUIGN@redhat.com>
References: <02a2bb69-c13d-43bb-bbed-2a1bd3007ba4@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <02a2bb69-c13d-43bb-bbed-2a1bd3007ba4@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TJdmMZ1TAyJB-3nkpDFUcP0ee7HEtL9N3Jz1bBMW-QM_1779823689
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 22, 2026 at 11:10:36PM +0200, Xose Vazquez Perez wrote:
> Hi,
> 
> An integer overflow occurs in libmultipath/discovery.c:get_geometry() when
> querying geometry on large disks resulting in "0 cyl" being reported:
> 
> # multipath -ll -d -v3
> ... | sdgm: 0 cyl, 64 heads, 32 sectors/track, start at 0
> 
> # fdisk -l /dev/sdgm
> Disk /dev/sdgm: 12 TiB, 13194139533312 bytes, 25769803776 sectors
> Units: sectors of 1 * 512 = 512 bytes
> 
> # dmesg | grep sdgm
> sd 5:0:3:100: [sdgm] 25769803776 512-byte logical blocks: (13.2 TB/12.0TiB)
> 
> 
> The root cause is that struct hd_geometry, from libmultipath/structs.h,
> defines cylinders as an unsigned short.
> 
> Since it is a legacy interface, it should either sanitize the log output
> or avoid relying on CHS geometry for large devices.

I'm totally fine with never reporting the geometry info or moving it to
log level 4 (since there can be value to even pointless debugging
messages. They can show you where you made it to if you happned to hang
in a function)

But I don't personally have a problem with multipath simply passing
along the geometry data it gets from the disk. Sure, it may be garbage,
but then DM's garbage matches the disk's garbage. I highly doubt that
anything actually cares what geometry a DM device reports. But I don't
see any benefit to changing what it currently does.

Thoughts?
-Ben 

