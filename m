Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C330B1E49B
	for <dm-devel@lists.linux.dev>; Mon,  1 Jul 2024 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719841263; cv=none; b=lS4f2gmmkTuPX6HYr0LQ+8fc/6gXzOjyVn/EvkAFPH6BVyExhxlpropSI9ZIplq4+7Lx8oHY3Q61bPzwk4kCXhJMLGxnkHhW/0649zViZ2YlYNU4wK+HIG9ePK9vHv1F1Y6iXetmYExVrk8MsctkPNpGYocwangmy+klsn3Y7V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719841263; c=relaxed/simple;
	bh=7Ay1laCevjUlOnyjHqK0zzhVTrBp9D3JP4nWPTYLxeU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=GKN0LfUInfqbq+oOgFpnWO0wuHyuSWbw5HHgVWPmePRgLDmT+9oToMDmMbxeXw9y3f36RzBbQIwfzXaywQRfoHepz6TWYVD5LykZNwbI/rxKNaxKtg2BPp4TOqHcJGN76gxVh/trTnihJEDF8mNy4h7S1jcqvp5RBmhICMi7ly0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R7fDIYRh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R7fDIYRh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719841260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hTYOayuneP6Ga6FNzZGkvmV+Bd9uCXqmhszSCbB9GN8=;
	b=R7fDIYRh12/fViMzIhPTcYEWM7CM+QZLBvzXh79Emt0focAekQ4a9Elg4ZP2Jxd4guIzVN
	4HTQkkjdp4N1xaHzrtZM2NtYIrA8K8KzDnrf+1tCUgF233HILZa8adjvEo4MTvolzss+ai
	403U2Xfb9fw/Yc4tlEOJGF4t4woBiFU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-184-ioAozpRcOd-J2dcxDXwTRg-1; Mon,
 01 Jul 2024 09:40:56 -0400
X-MC-Unique: ioAozpRcOd-J2dcxDXwTRg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13C9F1933181;
	Mon,  1 Jul 2024 13:40:55 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D6E61955E80;
	Mon,  1 Jul 2024 13:40:54 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 4B0DA30C1C14; Mon,  1 Jul 2024 13:40:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 481ED3FB52;
	Mon,  1 Jul 2024 15:40:53 +0200 (CEST)
Date: Mon, 1 Jul 2024 15:40:53 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?ISO-8859-15?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>
cc: =?ISO-8859-15?Q?Michal_Pr=EDvozn=EDk?= <mprivozn@redhat.com>, 
    Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
    Waiman Long <longman@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Laurence Oberman <loberman@redhat.com>, 
    Jonathan Brassow <jbrassow@redhat.com>, Ming Lei <minlei@redhat.com>, 
    Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
    users@lists.libvirt.org
Subject: Re: dm-crypt performance regression due to workqueue changes
In-Reply-To: <ZoKuLzyhE8N4RaW4@redhat.com>
Message-ID: <ede7d32c-5668-a2dc-ca9-e4b56cdfb42@redhat.com>
References: <32fd8274-d5f-3eca-f5d2-1a9117fd8edb@redhat.com> <ZoGSJWMD9v1BxUDb@slm.duckdns.org> <e64c112-4fa9-74da-68ce-c1eec19460f2@redhat.com> <b0e364d2-0def-4909-98c6-ce7188b7819f@redhat.com> <ZoKuLzyhE8N4RaW4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="185210117-1674295890-1719840823=:700989"
Content-ID: <f9cdb176-e39e-5db6-cbb3-1e6d8f2a179d@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185210117-1674295890-1719840823=:700989
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <766d6b71-af3a-cc50-6a1e-eeb13db77236@redhat.com>



On Mon, 1 Jul 2024, Daniel P. Berrangé wrote:

> On Mon, Jul 01, 2024 at 02:48:07PM +0200, Michal Prívozník wrote:
> > On 6/30/24 20:49, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Sun, 30 Jun 2024, Tejun Heo wrote:
> > >>
> > >> Do you happen to know why libvirt is doing that? There are many other
> > >> implications to configuring the system that way and I don't think we want to
> > >> design kernel behaviors to suit topology information fed to VMs which can be
> > >> arbitrary.
> > 
> > Firstly, libvirt's not doing anything. It very specifically avoids doing
> > policy decisions. If something configures vCPUs so that they are in
> > separate sockets, then we should look at that something. Alternatively,
> > if "default" configuration does not work for your workflow well,
> > document recommended configuration.
> 
> Actually in this particular case, it is strictly speaking libvirt.
> If the guest XML config does not mention any <topology> info, then
> libvirt explicitly tells QEMU to set sockets=N,cores=1,threads=1.
> That matches QEMU's own historical built-in default topology.
> 
> None the less, my advice for mgmt applications using libvirt would
> likely be to explicitly request sockets=1,cores=N,threads=1. This
> is because it gives slightly better compatibility with unpleasant
> software that applies licensing / subscription rules that penalize
> use of many sockets, while being happy with any number of cores.
> 
> 
> Either way though, the topology is a lie when the guest CPUs
> are not pinned to host CPUs, so making performance decisions based
> on this is unlikely to yield the desired results. Historically the
> cores vs sockets distinction hasn't seemed to make much difference
> to guest OS performance, as the OS' haven't made significant
> decisions on this axis. Exposing threads != 1 though has always been
> a big no though, unless strictly pinning 1:1 guest:host CPUs, as that
> has had notable impacts on scheduling decisions.
> 
> With regards,
> Daniel

I think there should be some way how to tell the guest kernel "the vCPUs 
are free-floating, the topology is a lie", so that it can stop making 
incorrect decisions based on the fake topology.

Mikulas
--185210117-1674295890-1719840823=:700989--

