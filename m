Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.36
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301548;
	b=y1RI39+MjbqIc9dKH0LNyKlqwxzitRB4XDRdLHZtyju4Sn4SWv1heOPqzkcRBujEw0FN
	 h70qMlwF2PWCtfX0YpYZApxJ+tkYdpXLtwJJza0BXOXNIZAZpC+D+7tWP1cH/zHAhL58h
	 v2E3mnD86HvambJqvy6VICulNSWnL/r33Vl8zt8bM7Fz5aEoTESqIah/YzZs51S5leRdx
	 hF8EMBfdWSPnTrYOXMoSiG4oUnpkcdIYV+tx5uEywYVBPyyTr4DQEelTwWOp+bZK9r6qG
	 Xoj1b5eqR7waexpuR5mBz9GxWXWLL77doJRamHLuhfMs1dn7Pa6YbgC651MGtaRcLgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301548;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=OK9denJsYmTCyLolpT52rwyfXM56TL7yf+QKigAqDXY=;
	b=Rwho+/0urcay94/FDnc55i8Ov6VqsBm0Kude2tUDC5z9r3DQOpzHBy3WwO9mXyryqokd
	 X9vdASSkkBHVT7QPd8OSuI++/NF68Bdl47d2dZ5dj+6QV6OUJX+m/YdeZnzauYo0pVB0x
	 jZteP8VgWAQx/wc/AY/7cGtzqiychcPFNeeum/oRNL97cE/h/bE5/SjMC2m/9bmi9HyUd
	 ZE9RAl9Ey1MFkozyB754GQ7j1DJNn8AHptmkgTN/4p9m7nx23ZU7CmKLAzlvG/gZdou+L
	 uWaBnTj4LchTR1mdS9m92SWH5QBXucF7c7y+zixXvfdRLNfgOzlQ3cCUq9VLdzkvSKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rTp6QS1p;
	arc=none smtp.remote-ip=95.215.58.36
Received: from mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57651606A31C
	for <dm-devel@lists.linux.dev>; Tue, 10 Nov 2026 09:05:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57651606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rTp6QS1p
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=HDOxu6zXX3pmMziswx/K9hIQGw+W8txU+GPPJxltLSk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794301545; v=1; x=1794906345;
 b=rTp6QS1prJKB5Qj5y/Mp4lDGTaRPWcKvcniGGrcSc0SSgUolCKSmVtFl9ibXjqw9fQuzFtye
 eoL5CKE8x9D/2Svur2RS5rg6p05LcxsB3Ccwda1PLI+m5iBHOwFSjCukCrZj55ydRC/GaCtAhZV
 BAthYGUuEVW4khx7Iay8KJRI=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 711b39cf1d6a3c7d;
	Tue, 10 Nov 2026 09:05:45 +0000
X-Mizu-Trace-ID: 711b39cf1d6a3c7d
X-Migadu-Flow: FLOW_OUT
Message-ID: <3332329d-b922-45a4-8333-e8353e983885@linux.dev>
Date: Tue, 10 Nov 2026 09:05:43 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/29] Native SCSI Multipath support
To: Laurence Oberman <loberman@redhat.com>,
 james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de,
 michael.christie@oracle.com
References: <20261108204733.557995-1-john.garry@linux.dev>
 <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 20:19, Laurence Oberman wrote:
> I have been testing v9 (your scsi-multipath-v7.4-v9 branch, on
> 7.4-rc1) on real hardware 

Good to know.

> and found two problems with ALUA arrays,
> one in scsi_dh_alua and one in the series itself.
> 
> Setup:
> - HP P2000 G3 FC array, implicit ALUA, two port groups (one per
>    controller)
> - 2 FC HBAs, 2 target ports each, 30 LUNs with 4 paths per LUN
> - scsi_mod.multipath=on, dm-multipath not in use
> - Under dm-multipath, the same LUNs show port group 1 at prio 50
>    (active/optimized) and port group 0 at prio 10
>    (active/non-optimized)
> 
> 1. sdev->access_state is wrong after boot (scsi_dh_alua, not this
>     series)
> 
> After boot, every path read active/optimized in
> /sys/class/scsi_device/H:C:T:L/device/access_state, while sg_rtpg
> reports port group 0 as active/non-optimized. No
> "alua: port group XX state ..." message was logged at all.

In this series, ALUA state really has been ignored. It was felt that 
driving ALUA state and sdev->access_state by device handler ALUA driver 
should should not be relied on for Native SCSI multipath. There had been 
considerable discussion on this on list. I already have the work done 
for ALUA support from some time ago and can be posted once this series 
is accepted.

> 
> Since 50759b881e1d ("scsi: device_handler: alua: Call
> scsi_device_put() from non-atomic context"), alua_rtpg_queue() only
> queues an RTPG if sdev->handler_data is set, but alua_bus_attach()
> sets handler_data after alua_initialize() has tried to queue the
> initial RTPG. That RTPG is dropped, and access_state stays at its
> zeroed default (active/optimized) until something calls
> scsi_dh_activate(). dm-multipath hides this through pg_init; native
> multipath never calls activate, so the series sees every path as
> optimized.
> 
> I have sent a separate fix for this to linux-scsi:
> https://lore.kernel.org/linux-scsi/20261109201120.1067815-1- 
> loberman@redhat.com/
> It is independent of your series, but without it, native multipath
> on ALUA arrays has no correct path state.

Ack

> 
> 2. ANO paths are ranked the same as AO paths
> 
> With the ALUA state corrected (by writing "activate" to dh_state, or
> with the fix above), I/O still went to active/non-optimized paths.
> scsi_multipath_sdev_init() sets mpath_device->access_state to
> MPATH_STATE_OPTIMIZED and nothing updates it, while
> __mpath_find_path(), mpath_round_robin_path() and
> mpath_queue_depth_path() rank paths by that field. Only
> scsi_mpath_is_optimized()/is_disabled() read sdev->access_state.
> 
> With numa, the first path in dev_list wins for every node, and
> dev_list order follows sd probe completion, so for about a third of
> the LUNs the current path was an ANO path. Example, LUN sdn, reads
> completed per path for a 2000 x 1M O_DIRECT dd (:0/:3 AO, :1/:2 ANO
> at the time):
> 
>    sdn:0 0sdn:1 2000sdn:2 0sdn:3 0
> 
> Every read went through the non-owning controller. From the code, for
> these LUNs the numa recheck of is_optimized() fails on every I/O and
> __mpath_find_path() picks the same ANO path again.
> 
> With the change below (a template callback so the selectors use the
> live state), plus the scsi_dh_alua fix, all 30 LUNs pick an AO
> current path at boot, and on LUN sdl (:0/:2 AO, :1/:3 ANO):
> 
>    numa         2000     0     0     0
>    round-robin  1000     0  1000     0
>    queue-depth 18039     0 13961     0   (8 parallel dd, 64k)
> 
> No I/O reached the ANO paths under any policy. This is a test patch to
> show the problem, not a polished change - feel free to fold it in or
> do it differently.

I'll check it. Sounds like a real problem.

As you may know, this code is really a refactoring of the NVMe multipath 
code. The ambition was to have NVMe use libmultipath eventually, so it 
would be good for any change to work for both NVMe and SCSI.

> 
> 3. Smaller points
> 
> - numa with equal NUMA distance uses one path per LUN, so with two AO
>    paths through two HBAs, half the optimized bandwidth is idle (sdl:2
>    above under numa). That matches NVMe, but users coming from
>    dm-multipath service-time will notice. Would round-robin or
>    queue-depth be a better default for SCSI?

Maybe, but round-robin may not be always ideal considering only a bio 
mode of operation is supported and no merging like dm-mpath RQ mode.

> 
> - There are no Documentation/ABI entries for the new sysfs attributes
>    (scsi_mpath_device vpd_id/iopolicy/multipath, delayed_removal_secs,
>    mpath_dev, mpath_numa_nodes, mpath_queue_depth), and the
>    scsi_mod.multipath and multipath_iopolicy parameters are not in
>    kernel-parameters.txt. I have a draft ABI file if useful.

Cool, I would suggest to post if and when this is merged. I would rather 
not post another version of this series. It is just "experimental".

> 
> - There is no userspace tool yet to show heads, paths and ALUA state
>    (the equivalent of multipath -ll or nvme list-subsys). I used a
>    small sysfs script for this testing. Ben, is native SCSI multipath
>    support in multipath-tools planned?

Well, the whole point is that we don't need userspace tools. However, I 
appreciate that there is no general SCSI tooling which could help here. 
I know that Himanshu M did work on a SCSI version of nvme-cli tool 
previously. Martin may know the status of that.

> 
> - CONFIG_SCSI_MULTIPATH/CONFIG_LIBMULTIPATH are only enabled in your
>    branch's x86_64_defconfig, so building from a distro config leaves
>    them off, and scsi_mod.multipath= is silently ignored. Maybe worth a
>    note in the cover letter.

I thought that the kernel warns of unrecognised params (which would 
happen for a relevant module disabled).

> 
> I have not tested failover or path loss yet; I will follow up with
> that and a Tested-by once done.

ok.

Thanks
