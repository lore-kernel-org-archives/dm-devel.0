Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E645535E958
	for <dm-devel@lists.linux.dev>; Mon, 30 Mar 2026 17:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774892505; cv=none; b=QPGmnM3ZhivoN+N+7X7r4e/TUgcK2EkGj6LbtexxXI1SIW+5oART6cyDCtANGf+vLdE0gARL96KWr9MAv141BLvDFw8ufiYJ1z9xYcGxZbRHEU5KJzfR2KOMTjLJPL+FN59llHXE3KyBiKWgZZfMMQ0Jb0vgFiKBw5moi0wbWck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774892505; c=relaxed/simple;
	bh=7Ex+IHlQ5LGBygkW9AJsz7rWZfANYU1Or5qqBv3+nCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=hjxbepw9vRU09gl29qWj0+WoP6CySFFzIynWHseyGGrmzVyryWPGViJPbw8rRFPvZlcoXOsd75r/T1Akz/kQhL+dvGKZimFj48fUdx4vuM8sNiCzZjh8ae52TxoZn6Sz+cuxK1D0uaYRnc3BMSajSe/j5wJmN0bH/crqi7P+zJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CqGCQ9yC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CqGCQ9yC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774892502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KjAWJsmW8nvZ1Pwi9ZA0aaQfxC/daPsNZ0tDao62I4Y=;
	b=CqGCQ9yCXA9DwFg4aWLt6QX7B6KDDhYXtDV5X2tgs6csgOKXXUVa3g1CIoRh0vDe5nZ77A
	MweLj8uQyHKyWm9PC1c2w31Us5kjLJCwgyRd9KxI9NxungUsmqJceX+r5OU1VX3+Ph8k3F
	yJdrh8w4Rp5nKQQBFshwqzANaqS1OKQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-660-UoVtbQsVNESKp4WLOzFpwA-1; Mon,
 30 Mar 2026 13:41:41 -0400
X-MC-Unique: UoVtbQsVNESKp4WLOzFpwA-1
X-Mimecast-MFC-AGG-ID: UoVtbQsVNESKp4WLOzFpwA_1774892500
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCE2F18600C7;
	Mon, 30 Mar 2026 17:41:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 62D5A1944DCD;
	Mon, 30 Mar 2026 17:41:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62UHfZeU1380169
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 30 Mar 2026 13:41:35 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62UHfYS71380168;
	Mon, 30 Mar 2026 13:41:34 -0400
Date: Mon, 30 Mar 2026 13:41:34 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
        mpatocka@redhat.com, snitzer@kernel.org
Subject: Re: [PATCH 1/3] dm-integrity: fix mismatched queue limits
Message-ID: <acq1zq78j-aS39KV@redhat.com>
References: <20260325193608.2827042-1-kbusch@meta.com>
 <acbdfhN8AT7p4qrN@redhat.com>
 <acbqQ5YaFPMQ23UI@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <acbqQ5YaFPMQ23UI@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CkdCKvW0rVXengy4NKwI3nSXw8ZmN9lOH4UoUFDybMo_1774892500
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 27, 2026 at 02:36:19PM -0600, Keith Busch wrote:
> On Fri, Mar 27, 2026 at 03:41:50PM -0400, Benjamin Marzinski wrote:
> > > @@ -4047,9 +4047,15 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
> > >  	struct dm_integrity_c *ic = ti->private;
> > >  
> > >  	if (ic->sectors_per_block > 1) {
> > > -		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
> > > -		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
> > > -		limits->io_min = ic->sectors_per_block << SECTOR_SHIFT;
> > > +		limits->logical_block_size =
> > > +				max(limits->logical_block_size,
> > > +				    ic->sectors_per_block << SECTOR_SHIFT);
> > > +		limits->physical_block_size =
> > > +				max(limits->physical_block_size,
> > > +				    ic->sectors_per_block << SECTOR_SHIFT);
> > > +		limits->io_min =
> > > +				max(limits->io_min,
> > > +				    ic->sectors_per_block << SECTOR_SHIFT);
> > >  		limits->dma_alignment = limits->logical_block_size - 1;
> > >  		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
> > 
> > Shouldn't this also respect the underlying device's discard_granularity?
> 
> It doesn't appear to. I left it unchanged as I'm not very familiar with
> this device mapper, so that seemed safer. But I thought it was fine as
> is: this dm doesn't appear to forward discards, so the underlying
> device's constraints aren't brought into the operation. It looks like it
> just sets a "DISCARD_FILLER" pattern into metadata.

If you set allow discards, dm-intergrity should pass them down.

For example:

VALID:
# modprobe scsi_debug dev_size_mb=1024 lbpu=1
# integritysetup format -s 1024 /dev/sda
# integritysetup open --allow-discards /dev/sda integrity-test
# cat /sys/block/sda/queue/discard_granularity                  
512
# cat /sys/block/dm-1/queue/discard_granularity
1024
# blkdiscard -o 1024 -l 16384 /dev/mapper/integrity-test
# echo $?
0

perf trace:
      blkdiscard   11852 [000] 256486.743981:    block:block_bio_queue: 253,1 DS 0 + 2 [blkdiscard]
 kworker/0:1-eve   11763 [000] 256486.744063:    block:block_bio_queue: 8,0 DS 16504 + 2 [kworker/0:1]
 kworker/0:1-eve   11763 [000] 256486.744076:     block:block_rq_issue: 8,0 DS 1024 () 16504 + 2 0x2,0,4 [kworker/0:1]
         swapper       0 [000] 256486.745099:  block:block_rq_complete: 8,0 DS () 16504 + 2 0x2,0,4 [0]
         swapper       0 [000] 256486.745104: block:block_bio_complete: 253,1 DS 0 + 2 [0]


INVALID:
# modprobe scsi_debug dev_size_mb=1024 lbpu=1 sector_size=4096
# integritysetup format -s 1024 /dev/sda
# integritysetup open --allow-discards /dev/sda integrity-test
# cat /sys/block/sda/queue/discard_granularity
2048
# cat /sys/block/dm-1/queue/discard_granularity
1024
# blkdiscard -o 1024 -l 16384 /dev/mapper/integrity-test
blkdiscard: BLKDISCARD: /dev/mapper/integrity-test ioctl failed: Input/output error
# echo $?
1

perf trace:
      blkdiscard   12191 [000] 257234.995337:    block:block_bio_queue: 253,1 DS 0 + 2 [blkdiscard]
 kworker/0:1-eve   11763 [000] 257235.046620:    block:block_bio_queue: 8,0 DS 16504 + 2 [kworker/0:1]
 kworker/0:1-eve   11763 [000] 257235.046623: block:block_bio_complete: 8,0 DS 16504 + 2 [-5]
 kworker/0:1-eve   11763 [000] 257235.046629: block:block_bio_complete: 253,1 DS 0 + 2 [-5]

-Ben

