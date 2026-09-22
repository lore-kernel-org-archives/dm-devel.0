Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8695678EB
	for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 17:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098879; cv=none; b=Y3mPc6T6UElcOH0/kXsssWxgn8MuddNsckuWpBL6bkfenZuNtivCDJpdcyanfTdRYEGeOVWwBQ1PpEcI03fd/QBkBu15PluzB+zKkVAN1CDfTEIEBF0ARCSiYem38k3MuMQE93OH2NDuVirkcfSEyGGdh0aBpfo4GlObQfNFLxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098879; c=relaxed/simple;
	bh=bL61/s1nRIFUuUAZjAnE4SavHPvqtVNijrzovwJl52g=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BKbrdJSxMUP10cqI9nwgMsD+6krgmvLzO33+5dDapy2QyODixSoVEyOvqNWygvCgTTlViWOgDKOOArpPUjrkrBf2MnQjneAGSSVJ4BYpbTngg3QKXg03bxLz09YA1C2Y1kTk3oDoJlfIwld/Y95a8+t4hK7M5zBZmEh4gWQY8UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EdH50Q/3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EdH50Q/3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790098877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ECVSatl7iD9FklQr4YgVEzn30aY0TJa7tslzxf55YrM=;
	b=EdH50Q/3FjJtVnQKluFwxT70hOWCOhNnwh/Tk1QtkY323dJMg7D87wyvY4CQSxFgwz1zAP
	KvTQQy7UTpmvFjZCR5NLXbCd5xBCKtoXxYJ767ItqxxELXGlEyELlHCZBF4oJfZa0aql0K
	SQvFWoxroXs/ZgykKniOPdAxsFH/nF8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587--yykJJ3lPFCa4-U1PybGVQ-1; Tue,
 22 Sep 2026 13:41:12 -0400
X-MC-Unique: -yykJJ3lPFCa4-U1PybGVQ-1
X-Mimecast-MFC-AGG-ID: -yykJJ3lPFCa4-U1PybGVQ_1790098871
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8EC23180066C;
	Tue, 22 Sep 2026 17:41:11 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AADD330001B9;
	Tue, 22 Sep 2026 17:41:09 +0000 (UTC)
Date: Tue, 22 Sep 2026 19:41:06 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?ISO-8859-15?Q?L=E9o_Terziman?= <leo.terziman@gmail.com>
cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [BUG] NULL deref in mempool_free_bulk via crypt_endio on dm-crypt
 teardown (6.8 -> 7.0 regression)
In-Reply-To: <CAKjZdKjO0WVs2T3jM3txaqxYEt4uJhSc_G9mviWiq9XBe+8jkw@mail.gmail.com>
Message-ID: <61ea45dc-d0a6-e5e1-fcf5-14c512b17114@redhat.com>
References: <CAKjZdKjO0WVs2T3jM3txaqxYEt4uJhSc_G9mviWiq9XBe+8jkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Ue2q4DMfK756ZWapKY9f0YrLEHCjvmpKlFa66WTeMJw_1790098871
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="-1463801984-263208959-1790085153=:217987"
Content-ID: <91848acf-1742-94da-4847-c71a2526d4c0@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463801984-263208959-1790085153=:217987
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <130d1c3c-d8b1-c2e3-790b-be259fa6b730@redhat.com>



On Wed, 16 Sep 2026, Léo Terziman wrote:

> NULL pointer dereference in mempool_free_bulk via crypt_endio during
> dm-crypt device teardown
> 
> SUMMARY
> =======
> Since upgrading from Ubuntu 24.04 (Linux 6.8) to Ubuntu 26.04 (Linux 7.0),
> this machine panics roughly once a week. The panic is always a NULL pointer
> dereference in mempool_free_bulk(), reached from crypt_endio() in dm_crypt
> via bio_put()/bio_free(), running in softirq context from a SCSI completion.
> 
> It reproduces during teardown of a dm-crypt device: a late bio completion
> arrives after the dm-crypt target's bio_set has already been destroyed, so
> bio_free() returns the bio to a mempool whose ->elements is NULL.
> 
> The system was stable on 6.8 for approximately two years with the identical
> storage configuration and the identical backup script. Nothing in userspace
> changed at the time the crashes began.
> 
> 
> ENVIRONMENT
> ===========
> Distribution:  Ubuntu 26.04 LTS
> Kernel:        7.0.0-31-generic #31-Ubuntu PREEMPT(lazy) x86_64
> Hardware:      Supermicro X13SAE-F, BIOS 5.3 06/04/2026
> Memory:        64 GB ECC (ie31200_edac; 0 CE, 0 UE reported)
> DKMS modules:  none
> Taint:         G W  -- the W is an unrelated boot-time WARN in i915
>                (print_ddi_port, intel_bios.c VBT parsing, headless system).
>                No out-of-tree modules are loaded.
> 
> 
> STORAGE STACK
> =============
> Four backup volumes, each:
> 
>   iSCSI (iscsi_tcp, Synology target over TCP/IP)
>     -> sd (SCSI disk)
>       -> dm-crypt
>         -> btrfs (zstd:3, blake2b csums, async discard enabled)
> 
> Mounted together nightly by a backup script, then unmounted and torn down
> (umount -> cryptsetup close -> iscsiadm logout) when the backup finishes.
> 
> Separate from this, the system also uses hardware RAID -> bcache -> btrfs
> for primary storage and md RAID1 for SSD storage. Neither appears in any
> crash trace.
> 
> 
> TRIGGER
> =======
> Every crash occurs during teardown of the backup volumes, within seconds of
> unmount. The preceding log is consistent across occurrences:
> 
>   [256109.45] BTRFS info (device dm-15): last unmount of filesystem ...
>   [256109.53] sd 9:0:0:1:  [sdb] Synchronizing SCSI cache
>   [256109.75] BTRFS info (device dm-16): last unmount of filesystem ...
>   [256109.96] sd 10:0:0:1: [sdc] Synchronizing SCSI cache
>   [256110.06] BTRFS info (device dm-17): last unmount of filesystem ...
>   [256110.17] sd 11:0:0:1: [sdd] Synchronizing SCSI cache
>   [256111.50] BTRFS info (device dm-18): last unmount of filesystem ...
>   [256115.15] BTRFS warning (device dm-18): folio private not zero on folio
>               906100736
>               [~100 more identical warnings for consecutive folios]
>   [256115.18] BUG: kernel NULL pointer dereference, address: 0000000000000000
> 
> The "folio private not zero" flood immediately before the oops indicates
> btrfs is releasing folios that still carry I/O state, i.e. the unmount is
> completing while work is still outstanding beneath it.

I suspect that this is btrfs bug. It seems that btrfs closes a block 
device without waiting for bios to finish.

The mempool_free function was reworked between 6.8 and 7.0. In 6.8 it 
didn't crash if we attempted to free an entry into a free mempool. In 7.0 
it crashes in this case. So, the btrfs bug could have been there forever, 
it was just latent and didn't result in a crash on old kernels.

You can try to apply the patch 83f7e52b7ed1c3e03b79123e20b6f6adf8d886bb - 
maybe it helps.

Mikulas

---1463801984-263208959-1790085153=:217987--

