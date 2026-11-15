Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794764593;
	b=4BDAlsKitq8r+jJvQZf4X0MRbV7nd5ZRTv+KKWAA7vx1pNjmTj/EggaawdUtadVfAHTs
	 9+zqkKsSJ+D8RJIYx3gkoYZxKszXEXK8qZ2vqWibT0vqaE724mBnti8Gv60DTSYXEl6TX
	 x6H7p36Z2SKsOFYBDAPN4c+u6AV131iEKlxWuniJxEehgMxkGDqOr13GG2ApxyeoA536j
	 TbK7wYEQOHHfaPPiQaRoRpZTyL4QXjpwxMuLJBHpqlGArlnhSuKeHgQdYuhoc5hpvHSba
	 4dETt1rGchRBF5q70wsvuy9N+XK1zPeuTYzy4S4g8quAWNORVXDsDtTzcehhvTNCnoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794764593;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=woOfyy6+u6Bpq89IupWYIeQk6EVkwaxCSpWmgn+r9TE=;
	b=ZxlhQgudrG3LE22iqyg/Us432KEGIZVtvacrOwLU/oNo80LH1b5tkGelCtwNttkTzB5B
	 DTlZLjE3KatxPB6lxU3fcA3KBqhslb7XT4SNPwK09zcRuwTt4tTKXMQRz+8S7qlLWtlV8
	 LHYMhbacSa0D7tapyvkW618Go0qx5uOmLhyApivpjZacaWTJGylxSrxeQLIoNxrSHnydG
	 HuJCdiFDMpMdrBWp07r0RBTTrEdy9z0FoJ1e4S5K2TfN0oWG6k80XK8ObLTtiGlWWU5Un
	 dR27zbpTi6Kv5cMiCeiWU6O2li93+nmrmwySHFFNWO/jDJbVC1AOI9ZPWuxxMLPcpYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="LDXK/GA8";
	arc=none smtp.remote-ip=91.218.175.84
Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41421606A32F
	for <dm-devel@lists.linux.dev>; Sun, 15 Nov 2026 17:43:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41421606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LDXK/GA8
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=au0odLyb7/2WgYODnIjx2j64U1vQfxh6IkxY78a99H4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794764589; v=1; x=1795369389;
 b=LDXK/GA8qatl4AxoC5doVanT0Gmp/wCId8BkMLaopRin/HeDRiUhXMGlOQ2c5ZNXJo4MHuoT
 O0DyofxGhOCisLoh11BNVCTIAat9kdWV6hD8NMViUR7CHrisFonDyEyQs1iK+cWudD+BpnkEIQe
 QrND9Fs4aghv+0lBg9WbwCU4=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id d3995290662ba302;
	Sun, 15 Nov 2026 17:43:08 +0000
X-Mizu-Trace-ID: d3995290662ba302
X-Migadu-Flow: FLOW_OUT
Message-ID: <87d9b34e-1d63-41d2-9c01-595f0f1c7f23@linux.dev>
Date: Sun, 15 Nov 2026 17:43:02 +0000
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
To: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Laurence Oberman <loberman@redhat.com>
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com,
 dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 mkp@kernel.org, Benjamin Marzinski <bmarzins@redhat.com>,
 Martin Wilck <mwilck@suse.com>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
 <3332329d-b922-45a4-8333-e8353e983885@linux.dev>
 <00e03246-95dc-46dd-a2f9-89ad88f177d1@gmail.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <00e03246-95dc-46dd-a2f9-89ad88f177d1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/14/26 13:03, Xose Vazquez Perez wrote:
> On 11/10/26 10:05 AM, John Garry wrote:
> 
>> On 11/9/26 20:19, Laurence Oberman wrote:
>>> 3. Smaller points
>>>
>>> - numa with equal NUMA distance uses one path per LUN, so with two AO
>>>    paths through two HBAs, half the optimized bandwidth is idle (sdl:2
>>>    above under numa). That matches NVMe, but users coming from
>>>    dm-multipath service-time will notice. Would round-robin or
>>>    queue-depth be a better default for SCSI?
>>
>> Maybe, but round-robin may not be always ideal considering only a bio 
>> mode of operation is supported and no merging like dm-mpath RQ mode.
> 
> iopolicy can easily be customized per array/device via udev rules.
> Just like it's done for NVMe:
> https://github.com/linux-nvme/nvme-cli/blob/master/nvmf-autoconnect/ 
> udev-rules/71-nvmf-hpe.rules.in

Sure

> 
> Additionally, "service-time" and "latency" I/O policies are currently under
> development:
> https://lore.kernel.org/linux-nvme/20261026111019.3724465-1- 
> kanie@linux.alibaba.com/T/
> https://lore.kernel.org/linux-nvme/20260815173502.1185929-1- 
> nilay@linux.ibm.com/T/

I already did an experimental port of the latency iopolicy to 
libmultipath. Porting iopolicy schemes to libmultipath is not too 
challenging, really.

> 
>>> - There is no userspace tool yet to show heads, paths and ALUA state
>>>    (the equivalent of multipath -ll or nvme list-subsys). I used a
>>>    small sysfs script for this testing. Ben, is native SCSI multipath
>>>    support in multipath-tools planned?
>>
>> Well, the whole point is that we don't need userspace tools. However, 
>> I appreciate that there is no general SCSI tooling which could help 
>> here. I know that Himanshu M did work on a SCSI version of nvme-cli 
>> tool previously. Martin may know the status of that.
> 
> Agreed that userspace tools are not strictly needed for configuration, but
> observability is key.
> A standard utility to visualize the device topology, path health and ALUA
> states at a glance, similar to what multipath-tools provides, would save a
> lot of friction for sysadmins migrating away from dm-multipath.
> Relying solely on ad-hoc scripts or manual sysfs parsing can become quite
> tedious in production environments.

Right, and any info required here should be available in sysfs.

Thanks,
John


