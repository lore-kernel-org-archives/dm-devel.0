Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CF815E5BC
	for <dm-devel@lists.linux.dev>; Mon,  1 Jul 2024 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719841361; cv=none; b=O5J62B0F7Ly2X7OresjvC7AqNm++mGxFALa9wuUnl826IddvTV8rVMBxsUPzYgaoeAA2onr8dB5ThKCbgrBSff762CG//XdKvRRCV1+coG6dp+hAacCV7WpvlOQPnFzlG5fjWmt0IhOMDpEvJNulRFNn9a9dzoZBNB1D/Np/naE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719841361; c=relaxed/simple;
	bh=92/SR3+ittNLh2Rsy76Cz2RIU6V8eOAhn7AYJBLat38=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=F/2GtN6I0pEM6I25qd4L+BRzcizi79y5Bipecak0MpDDSKvibpVjpRJ0L3UJ7p7/xBE9Bh8QMXleTOhW6zTv8+U0wfqtSN6RtUwGcDr9Xs5Alrqso+YxipX3ydx05csV0EcmiWUTxWssRqf5fB//n+DKRUGnkd1R/6ruMMWyx5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=THb29ITa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="THb29ITa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719841358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E0HQdp4BRkZxb6hA/5Q0WjRUWoRI6uTvZSiyunG2Nc0=;
	b=THb29ITa706ej8QS2Dvtnb76WVM8zPRlsWcNS8XClbzTYX8w7vJcakHW+spye1s4hrGCT2
	I6PE8vbA7X9d6n5ZmcjRZh7NGmCob8cJuXlHKBwptQTz3Z+0SmDxFR7nuyVOGZZOURDBqm
	dknawcF9yWi+BkibbXWf39P7Levmeo8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-gvXgAmFGPlWT2QszDnWHhA-1; Mon,
 01 Jul 2024 09:42:33 -0400
X-MC-Unique: gvXgAmFGPlWT2QszDnWHhA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D41BA19560BA;
	Mon,  1 Jul 2024 13:42:31 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AE4C3000223;
	Mon,  1 Jul 2024 13:42:31 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id E9CE830C1C14; Mon,  1 Jul 2024 13:42:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id E8E9D3FB52;
	Mon,  1 Jul 2024 15:42:29 +0200 (CEST)
Date: Mon, 1 Jul 2024 15:42:29 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?ISO-8859-15?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>
cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
    Waiman Long <longman@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Laurence Oberman <loberman@redhat.com>, 
    Jonathan Brassow <jbrassow@redhat.com>, Ming Lei <minlei@redhat.com>, 
    Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
    users@lists.libvirt.org
Subject: Re: dm-crypt performance regression due to workqueue changes
In-Reply-To: <ZoKqYg7TKiozapmW@redhat.com>
Message-ID: <e52c5a40-8ca9-38ae-1595-3785c6ac435@redhat.com>
References: <32fd8274-d5f-3eca-f5d2-1a9117fd8edb@redhat.com> <ZoGSJWMD9v1BxUDb@slm.duckdns.org> <e64c112-4fa9-74da-68ce-c1eec19460f2@redhat.com> <ZoKqYg7TKiozapmW@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="185210117-223779599-1719839675=:700989"
Content-ID: <42b1735e-969f-b8d6-2c61-eda77a311fc@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185210117-223779599-1719839675=:700989
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <69bd3f6f-9476-86a4-732-3fadbfafeb2@redhat.com>



On Mon, 1 Jul 2024, Daniel P. Berrangé wrote:

> On Sun, Jun 30, 2024 at 08:49:48PM +0200, Mikulas Patocka wrote:
> > 
> > 
> > On Sun, 30 Jun 2024, Tejun Heo wrote:
> > 
> > > Do you happen to know why libvirt is doing that? There are many other
> > > implications to configuring the system that way and I don't think we want to
> > > design kernel behaviors to suit topology information fed to VMs which can be
> > > arbitrary.
> > > 
> > > Thanks.
> > 
> > I don't know why. I added users@lists.libvirt.org to the CC.
> > 
> > How should libvirt properly advertise "we have 16 threads that are 
> > dynamically scheduled by the host kernel, so the latencies between them 
> > are changing and unpredictable"?
> 
> NB, libvirt is just control plane, the actual virtual hardware exposed
> is implemented across QEMU and the KVM kernel mod. Guest CPU topology
> and/or NUMA cost information is the responsibility of QEMU.
> 
> When QEMU's virtual CPUs are floating freely across host CPUs there's
> no perfect answer. The host admin needs to make a tradeoff in their
> configuration
> 
> They can optimize for density, by allowing guest CPUs to float freely
> and allow CPU overcommit against host CPUs, and the guest CPU topology
> is essentially a lie.
> 
> They can optimize for predictable performance, by strictly pinning
> guest CPUs 1:1 to host CPUs, and minimize CPU overcommit, and have
> the guest CPU topology 1:1 match the host CPU topology.
> 
> With regards,
> Daniel

The problem that we have here is that the commit 
63c5484e74952f60f5810256bd69814d167b8d22 ("workqueue: Add multiple 
affinity scopes and interface to select them") changes the behavior of 
unbound workqueues, so that work items are only executed on CPUs that 
share last level cache with the task that submitted them.

If there are 16 virtual CPUs that are freely floating across physical 
CPUs, virt-manager by default selects a topology where it advertises 16 
sockets, 1 CPU per socket, 1 thread per CPU. The result is that the 
unbound workqueues are no longer unbound, they can't move work across 
sockets and they are bound to just one virtual CPU, causing dm-crypt 
performance degradation. (the crypto operations are no longer 
parallelized).

Whose bug is this? Is it a bug in virt-manager because it advertises 
invalid topology? Is this a bug in that patch 63c5484e7495 because it 
avoids moving work items across sockets?

Mikulas
--185210117-223779599-1719839675=:700989--

