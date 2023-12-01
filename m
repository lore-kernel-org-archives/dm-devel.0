Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3923C4EB59
	for <dm-devel@lists.linux.dev>; Fri,  1 Dec 2023 18:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dg1frynI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701455221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t0521JByidsQbjEBYMVN+PIKT+knjBZrZHeRGCGUqss=;
	b=dg1frynIIl0uDLQMvDUGp+QjxrwK/xE4VywM7VwdBhtV7NVoDaBlY/l7zYZGMSrafuvpX7
	Kpoc/EWXpoGIcNBzijyafa7ORfitRYkebCr2HejPWSIzqxmDWBvd1Qua7KhTeY6ps8fBPL
	6HQv5c5TwiF5dJoIzPdJnv+yFoxIWBw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-NvDoWc9IPIW0LEu49X4SNg-1; Fri, 01 Dec 2023 13:26:59 -0500
X-MC-Unique: NvDoWc9IPIW0LEu49X4SNg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0CA8862CA2;
	Fri,  1 Dec 2023 18:26:58 +0000 (UTC)
Received: from redhat.com (unknown [10.22.32.92])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 432482166B26;
	Fri,  1 Dec 2023 18:26:58 +0000 (UTC)
Date: Fri, 1 Dec 2023 12:26:56 -0600
From: David Teigland <teigland@redhat.com>
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: Joe Thornber <thornber@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: Stuck IOs with dm-integrity + md raid1 + dm-thin
Message-ID: <ZWolcKU3EIS55zO7@redhat.com>
References: <fb4ae62-522-e262-df25-c82e8acf8baf@ewheeler.net>
 <CAJ0trDaipa_80xqVpDkJdm-SSCaN7g_O-m9-StG10P_DUxmtEA@mail.gmail.com>
 <CAJ0trDbP4BFjb0KQ+t4Lh1JdVjP9sbMiwJEOXPkGEV_R95rFoQ@mail.gmail.com>
 <12d141ed-84d2-411f-3e61-7a8d5bc7f0dc@ewheeler.net>
 <CAJ0trDaRQaDicO9ho8Hokj68vEopaJwM8YKwPEjzYkWBXE0dWg@mail.gmail.com>
 <cb3f4665-fcfc-c08-2dce-99c071c2a569@ewheeler.net>
 <bb6deb36-dd80-1649-11b6-bdcf24cb4e4@ewheeler.net>
 <7bcbab39-9ad0-4e9-d49e-5c229689915f@ewheeler.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7bcbab39-9ad0-4e9-d49e-5c229689915f@ewheeler.net>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 30, 2023 at 04:40:00PM -0800, Eric Wheeler wrote:
> 	integritysetup format $idev0 --integrity xxhash64 --batch-mode
> 	integritysetup format $idev1 --integrity xxhash64 --batch-mode
> 
> 	integritysetup open --integrity xxhash64 --allow-discards $idev0 dm-integrity0
> 	integritysetup open --integrity xxhash64 --allow-discards $idev1 dm-integrity1
> 
> 	mdadm --create $MD_DEV --metadata=1.2 --assume-clean --level=1 --raid-devices=2 /dev/mapper/dm-integrity[01]
> 
> 	# 1. This should be enough to trigger it:
> 	SSD_DEV=$MD_DEV
> 
> 	# 2. If not, then wrap /dev/md9 in a linear target:
> 	#linear_add ssd $MD_DEV
> 	#SSD_DEV=/dev/mapper/ssd

Interesting that just adding a linear layer there would have some effect.

> 	# Create a writable header for the PV meta:
> 	dd if=/dev/zero bs=1M count=16 oflag=direct of=/tmp/pvheader
> 	loop=`losetup -f --show /tmp/pvheader`
> 	linear_add pv $loop /dev/nullb0
> 
> 	# Create the VG
> 	lvmdevices --adddev $SSD_DEV
> 	lvmdevices --adddev /dev/mapper/pv
> 	vgcreate $VGNAME /dev/mapper/pv $SSD_DEV
> 
> 	# Create the pool:
> 	lvcreate -n pool0 -L 1T $VGNAME /dev/mapper/pv
> 	lvcreate -n meta0 -L 512m $VGNAME $SSD_DEV
> 
> 	# Make sure the meta volume is on the SSD (it should be already from above):
> 	pvmove -n meta0 /dev/mapper/pv

I'd omit that pvmove if possible just in case it makes some unexpected
change.  You have more than enough layers to complicate things as it is
without pvmove adding dm-mirror to the mix.

> 	lvconvert -y --force --force --chunksize 64k --type thin-pool --poolmetadata $VGNAME/meta0 $VGNAME/pool0

It's not a bad idea to use mdraid over dm-integrity, but it would be
interesting to know if doing raid+integrity in lvm would have the same
problems. e.g.

lvcreate --type raid1 --raidintegrity y -m1 -L 512m -n meta0 $vg /dev/ram[01]
lvcreate -n pool0 -L 1T $vg /dev/nullb0
lvconvert --type thin-pool --poolmetadata meta0 $vg/pool0

Dave

