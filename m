Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7C315E5A2
	for <dm-devel@lists.linux.dev>; Mon,  1 Jul 2024 13:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719840322; cv=none; b=hESwbKygCtwOJqbVR6Vp9BEW71kwf0GDRxFzLPYw7ayVBtx51rA4l3abEox0mX1MWxTzcbb+cbcdW6NDXqZ0gtGPHduluOCvdKmpxUZOtD3I+VH2QhBwW0oYQv1tEwCQnBaihoypa8yHSb4r1+JlD67rzmE77xVsd9UIFcP5KBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719840322; c=relaxed/simple;
	bh=E7WGqYQ5XsL70e6FskwkWLTXyyK4uuEzCIVRfrp+FIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPmcg2uzOe9L3RLiij5v1gEfB6JH57voqF7wlnj35AnwU0u/5WliUvtDiKhmSM+Jx+F2qyOl4l3MErG8hh5j1DIVFaZdAsG02BlTrehoS8xXep5J/VDaitlwf3GMu1/7f+2bqwQr/N5mroZGER9rbcEn1ndlplyR6Nc+MI4kPFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UYgc8xmT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UYgc8xmT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719840319;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W9n3jyEHRQHTUMDV4hJHIiWOZIRhBAfse04rCoeLgEg=;
	b=UYgc8xmT3TIHdXiuQZ6dBAC8f1wITx4tKits9Zc8bdd/LE9fRJSZXfM/E2rkpS8nluRqye
	SZFiiSNevvBxQTuNPTHyoqzjPcMY/+rpqmdiZXC4zTIvDlbO3WaoNlP2TaCTerdAqS5nIq
	eohrskmlPtCgWWXiAVWfR/pOiwPXEuI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-2RsFG1nZMAe1ZBs5uh4seg-1; Mon,
 01 Jul 2024 09:25:13 -0400
X-MC-Unique: 2RsFG1nZMAe1ZBs5uh4seg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C09AF19373DD;
	Mon,  1 Jul 2024 13:25:11 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.124])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BFFEA1956089;
	Mon,  1 Jul 2024 13:25:06 +0000 (UTC)
Date: Mon, 1 Jul 2024 14:25:03 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michal =?utf-8?B?UHLDrXZvem7DrWs=?= <mprivozn@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Waiman Long <longman@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Laurence Oberman <loberman@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Ming Lei <minlei@redhat.com>, Ondrej Kozina <okozina@redhat.com>,
	Milan Broz <gmazyland@gmail.com>, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, users@lists.libvirt.org
Subject: Re: dm-crypt performance regression due to workqueue changes
Message-ID: <ZoKuLzyhE8N4RaW4@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <32fd8274-d5f-3eca-f5d2-1a9117fd8edb@redhat.com>
 <ZoGSJWMD9v1BxUDb@slm.duckdns.org>
 <e64c112-4fa9-74da-68ce-c1eec19460f2@redhat.com>
 <b0e364d2-0def-4909-98c6-ce7188b7819f@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b0e364d2-0def-4909-98c6-ce7188b7819f@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Jul 01, 2024 at 02:48:07PM +0200, Michal Prívozník wrote:
> On 6/30/24 20:49, Mikulas Patocka wrote:
> > 
> > 
> > On Sun, 30 Jun 2024, Tejun Heo wrote:
> > 
> >> Hello,
> >>
> >> On Sat, Jun 29, 2024 at 08:15:56PM +0200, Mikulas Patocka wrote:
> >>
> >>> With 6.5, we get 3600MiB/s; with 6.6 we get 1400MiB/s.
> >>>
> >>> The reason is that virt-manager by default sets up a topology where we 
> >>> have 16 sockets, 1 core per socket, 1 thread per core. And that workqueue 
> >>> patch avoids moving work items across sockets, so it processes all 
> >>> encryption work only on one virtual CPU.
> >>>
> >>> The performance degradation may be fixed with "echo 'system'
> >>>> /sys/module/workqueue/parameters/default_affinity_scope" - but it is 
> >>> regression anyway, as many users don't know about this option.
> >>>
> >>> How should we fix it? There are several options:
> >>> 1. revert back to 'numa' affinity
> >>> 2. revert to 'numa' affinity only if we are in a virtual machine
> >>> 3. hack dm-crypt to set the 'numa' affinity for the affected workqueues
> >>> 4. any other solution?
> >>
> >> Do you happen to know why libvirt is doing that? There are many other
> >> implications to configuring the system that way and I don't think we want to
> >> design kernel behaviors to suit topology information fed to VMs which can be
> >> arbitrary.
> 
> Firstly, libvirt's not doing anything. It very specifically avoids doing
> policy decisions. If something configures vCPUs so that they are in
> separate sockets, then we should look at that something. Alternatively,
> if "default" configuration does not work for your workflow well,
> document recommended configuration.

Actually in this particular case, it is strictly speaking libvirt.
If the guest XML config does not mention any <topology> info, then
libvirt explicitly tells QEMU to set sockets=N,cores=1,threads=1.
That matches QEMU's own historical built-in default topology.

None the less, my advice for mgmt applications using libvirt would
likely be to explicitly request sockets=1,cores=N,threads=1. This
is because it gives slightly better compatibility with unpleasant
software that applies licensing / subscription rules that penalize
use of many sockets, while being happy with any number of cores.


Either way though, the topology is a lie when the guest CPUs
are not pinned to host CPUs, so making performance decisions based
on this is unlikely to yield the desired results. Historically the
cores vs sockets distinction hasn't seemed to make much difference
to guest OS performance, as the OS' haven't made significant
decisions on this axis. Exposing threads != 1 though has always been
a big no though, unless strictly pinning 1:1 guest:host CPUs, as that
has had notable impacts on scheduling decisions.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

