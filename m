Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C2C1A38F7
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 21:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714512565; cv=none; b=F5v1cLN1s4Yi1qVBhIxDw7M+ZHwit4uT1ducHI50yyFFyKSawCbUlMoXAnEgEecjnuK9nrCUuzGGvAfd965Pj5+/ZjLuTn7xTkEA0tPxADGivZCceFVxq44VJhZz+fAa87Ka8yNVeOmCadapMjchb+nF8N7RzAiDZ7YofFRco+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714512565; c=relaxed/simple;
	bh=ByBNS9qAJFRUNYu11k1iOZc+OIoFSFNQ24H6C6TSBmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=HGLR3Ree9lc7anZs0ES3RXgqqJWvlmLHAzPlVVlCoJQBLo9s/B1WBLJEie2GUzx7QyY4yrQVY2K6NiLjB9dBYfuCliqa8UzN1mPKWaGWPKEeBwaxY4YKgWqWJg/4WW1aPU1bccCOMHtAsMsn4O2cdxD6pqPI6eJX3dfrjCpNKtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ACy04qoK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ACy04qoK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714512562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lgs+FLTpSNDQMCNUb/rF1UEoL8ReR6K21LcUeuYXkkc=;
	b=ACy04qoK+YU2hURa1VtvaFr1iG1a1hda4EoBPXsbB3xhMs7m/xnfeCG6jtVNeD5PBNjmu5
	E3Z/0AT1CqZnRI0D4bxcus2kKngRgzZRoi5KkXIxxRISeVMZZ3WND/Oeva6fwtQ8wy9B9Z
	6ntUVkOKtAf2zWfIGF/Kk6f7UbjC/PA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-MJElOt-QOiiLv1RSPCqTFQ-1; Tue,
 30 Apr 2024 17:29:20 -0400
X-MC-Unique: MJElOt-QOiiLv1RSPCqTFQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBBC01C0C647;
	Tue, 30 Apr 2024 21:29:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A233F51BF;
	Tue, 30 Apr 2024 21:29:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43ULTJ3j2341302
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 17:29:19 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43ULTJj32341301;
	Tue, 30 Apr 2024 17:29:19 -0400
Date: Tue, 30 Apr 2024 17:29:19 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 2/5] libmultipath: change flush_on_last_del to fix a
 multipathd hang
Message-ID: <ZjFir8_To8UGoYVK@redhat.com>
References: <20240425233517.2125142-1-bmarzins@redhat.com>
 <20240425233517.2125142-3-bmarzins@redhat.com>
 <5a5aa59a1b60ee0e91abeec292ef3d591d55a7e7.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <5a5aa59a1b60ee0e91abeec292ef3d591d55a7e7.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Apr 30, 2024 at 07:06:24PM +0200, Martin Wilck wrote:
> On Thu, 2024-04-25 at 19:35 -0400, Benjamin Marzinski wrote:
> > 
> > 1. create a multipath device with a kpartx partition on top of it and
> > no_path_retry set to either "queue" or something long enough to run
> > all
> > the commands in the reproducer before it disables queueing.
> > 2. disable all the paths to the device with something like:
> >  # echo offline > /sys/block/<path_dev>/device/state
> > 3. Write directly to the multipath device with something like:
> >  # dd if=/dev/zero of=/dev/mapper/<mpath_dev> bs=4K count=1
> > 4. delete all the paths to the device with something like:
> >  # echo 1 > /sys/block/<path_dev>/device/delete
> 
> I've tried to reproduce the issue with these commands. Test system was
> using a LIO iSCSI target with 2 paths. I created a  test script
> (attached) to try the offline / IO / delete procedure repeatedly.
> I haven't been able to make multipathd hang even once.
> 
> I also played around with dd options. If I use oflag=sync or
> oflag=direct, the dd command itself hangs.
> 
> Did I set up anything wrongly, or does the behavior perhaps depend on
> the kernel, or something else perhaps? Mine was a 6.4 kernel. This is
> not to say there's something wrong with your patch, but I'd like to
> understand the error situation better, as it doesn't seem to be
> trigger-able on my test system.
> 
> multipath.conf:
> 
> defaults {
> 	verbosity 3
> 	flush_on_last_del yes

If you set flush_on_last_del to "yes", then you won't be able to hit
this, because you will never be queueing when multipathd tries to
autoremove the device. The goal of my patch was to make sure multipathd
never hung on an autoremove, regardless of the no_path_retry setting and
the flush_on_last_del setting.

With "always", the device will always have queueing disabled, so the
device can be safely removed.

With "unused", if the device is unused, queuing is disabled. Otherwise,
multipathd will skip the autoremove if the device is queueing.

With "never", multipathd will skip the autoremove if the device is
queueing.

Your script looks fine, but with a system set up to hit it, the bug
should occur every time.

-Ben

> }
> 
> blacklist {
> 	wwid QEMU
> }
> 
> overrides {
> 	no_path_retry queue
> }
> 
> Regards,
> Martin
> 
> 
> 


