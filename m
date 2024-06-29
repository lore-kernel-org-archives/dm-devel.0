Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E956317736
	for <dm-devel@lists.linux.dev>; Sat, 29 Jun 2024 18:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719684966; cv=none; b=rolf13liHhhDSAMBOxXWxeVlmZScZqzUnXLdQ8LcGFgUNEF3SBUylQkvSDWSxjY3mRzg0KM/u+xILrkL+vuaH1PmpFD4P35wbFg9pJLEFhzsuLrKozz18VRjXzMm8oHJp/oJV8UoyiW688zHs5yHUk4u0sK/lAzLoo7Q2Y5UuiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719684966; c=relaxed/simple;
	bh=sRpEGduP9SPZky9x//lKa5fHbfKE9ykk2lA3WvW7E2Y=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=uIoXULExMOzrcb+VdOLkapVMbZ6nRA1riV1DI6YYOjBgIs5LkMt/ZIS0V9H7jy95XGagASku1s+2VCD9z8A6jqnhM11Q8YgGwGz0ZjKndfY/EGYZ4vRdiKJPJ4+hVBgf/iZ8faHQE3AmDTOgLYssnbkX3r+ypNaCKe9RF+vLCKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IPxxJyQD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IPxxJyQD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719684962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=xjeARSeXgpxc8bfxlatTH/kv5e9qdHwwiP+kzk8DEsw=;
	b=IPxxJyQDrOdgKgLvEUSECbFqj274Fy8JXLrXW5eS4Xn+JFwWoVtO5xBKsXNNu7LmqSQbax
	AUfYoFND9JmMkIDRghpSBDpurx4gRgjPr62tV4ZJveeILOLjr5kCI6UPnVyBbLT0pbW5sC
	OrkONs7fED1FgiHqnG2r9O5xh8Jv3kg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-AKkOgFBVPF205PxVvsJdtQ-1; Sat,
 29 Jun 2024 14:15:59 -0400
X-MC-Unique: AKkOgFBVPF205PxVvsJdtQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7956519560AB;
	Sat, 29 Jun 2024 18:15:58 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9D1519560A3;
	Sat, 29 Jun 2024 18:15:57 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 8B43030C1C14; Sat, 29 Jun 2024 18:15:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 8472E40D0E;
	Sat, 29 Jun 2024 20:15:56 +0200 (CEST)
Date: Sat, 29 Jun 2024 20:15:56 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>
cc: Waiman Long <longman@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Laurence Oberman <loberman@redhat.com>, 
    Jonathan Brassow <jbrassow@redhat.com>, Ming Lei <minlei@redhat.com>, 
    Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev
Subject: dm-crypt performance regression due to workqueue changes
Message-ID: <32fd8274-d5f-3eca-f5d2-1a9117fd8edb@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hi

I report that the patch 63c5484e74952f60f5810256bd69814d167b8d22 
("workqueue: Add multiple affinity scopes and interface to select them") 
is causing massive dm-crypt slowdown in virtual machines.

Steps to reproduce:
* Install a system in a virtual machine with 16 virtual CPUs
* Create a scratch file with "dd if=/dev/zero of=Scratch.img bs=1M
  count=2048 oflag=direct" - the file should be on a fast NVMe drive
* Attach the scratch file to the virtual machine as /dev/vdb; cache mode
  should be 'none'
* cryptsetup --force-password luksFormat /dev/vdb
* cryptsetup luksOpen /dev/vdb cr
* fio --direct=1 --bsrange=128k-128k --runtime=40 --numjobs=1
  --ioengine=libaio --iodepth=8 --group_reporting=1
  --filename=/dev/mapper/cr --name=job --rw=read

With 6.5, we get 3600MiB/s; with 6.6 we get 1400MiB/s.

The reason is that virt-manager by default sets up a topology where we 
have 16 sockets, 1 core per socket, 1 thread per core. And that workqueue 
patch avoids moving work items across sockets, so it processes all 
encryption work only on one virtual CPU.

The performance degradation may be fixed with "echo 'system'
>/sys/module/workqueue/parameters/default_affinity_scope" - but it is 
regression anyway, as many users don't know about this option.

How should we fix it? There are several options:
1. revert back to 'numa' affinity
2. revert to 'numa' affinity only if we are in a virtual machine
3. hack dm-crypt to set the 'numa' affinity for the affected workqueues
4. any other solution?

Mikulas

