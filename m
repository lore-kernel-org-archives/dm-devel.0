Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7A42F531F
	for <dm-devel@lists.linux.dev>; Fri,  8 May 2026 21:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778274246; cv=none; b=lacnt5JBYA+tEzKMNCfmSWIfZzyUQ54qK1A61xOI0iOnp2H/oGkH6TXmtFTEJSTZD9xUx/hP20x5wTmmdpjfb6ie1kSwM2DuRcUz6CwsJ0q6wHbLsIv6OVcFIyi8ramcYIXDCVpEVxRBwknzajMQow3tITxmTmrbxBtGb73dmP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778274246; c=relaxed/simple;
	bh=4Qw0mc6UzNoGbdse8F0YRgJ60AlGKysi3i9KVaday4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KpVtuNwRU8gR32F66HaHuumrI7Sqpk1WRpVM8Yu9K4MKc/6FaH0TbD3AU1OOneiTGoh/NTy4xFv90D5PQ3o+m2vVZ/tdhFk8IIEtlsvqSYMb+C5byGkKN1vsyB8HiKIL4+g+IYnNY22j04SHlB/mj+mwrfJ66jqcjLBsN0cq0D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=acQpXIIS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="acQpXIIS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778274243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4a7oLWPX2Ue241EnKiN0F8sGBaxvEOreT6lnifqlk5M=;
	b=acQpXIISFy3u/t6pggRaroW6XScxq/VcR2XZGUMyAF+aqrJg913dxZR2VXu/UuSHfD6pBl
	OrF7Wv1+t/3Hef7XuKrrE02pRR4oV2JTQ1bLB2vNK7pYyp/JrCPEeNAb0RvbDXSOER99j9
	GGjCPI/Z7fhfUQVXeo0liASvXCnB3to=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-rOeH_s-YPhu3dn68ALzHuQ-1; Fri, 08 May 2026 17:04:01 -0400
X-MC-Unique: rOeH_s-YPhu3dn68ALzHuQ-1
X-Mimecast-MFC-AGG-ID: rOeH_s-YPhu3dn68ALzHuQ_1778274241
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8ece46c4ba9so464545685a.0
        for <dm-devel@lists.linux.dev>; Fri, 08 May 2026 14:04:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778274241; x=1778879041;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4a7oLWPX2Ue241EnKiN0F8sGBaxvEOreT6lnifqlk5M=;
        b=PzGwep/6Kb8hS5jOknvqa1Itp7I7UpDlfh3Xj+F/rIkyz8dEkKWuHXSaNVlS8VpuI1
         2Ae8b9EECT70Y9AAx+McsGfpwmvIqhHRSVJDdM+1vvQ1H5M4NP5Co6EX5AV0odSPOzcN
         hElVPc5hRqxT1D+AH+ivf4RIC2KTF34Z9ykJ9YHl8mMj88cyEX7Ng/55fqjXriDhaDgc
         GSJvk+v77GbDLRudThzh1HaXbQkwSkdLwrPDU3BzCICtBS4uhMm1tF6HZez/6KkOe5IC
         XmPp0pfspT1GiTqdzoODyniy+ocR7OtLAElb6Bu4k24Y1eq9Q0JI8fpOkbJQLmMV4TpC
         pYuw==
X-Gm-Message-State: AOJu0Yw8c1DYGBVJWIXzKapKwM/JcGlJcBbpRvwaioVBng2cUJPooNdH
	VPQ7dRy+j/r3XoMj4RN4fWbOK7rjMXsVh4jv08CLo5qKPI3Uis5eOZfNVN8mxdV3oQ6MsfADPtz
	5kqPEhHxlfwez9ZDA0+1iFlLYVAwqLDj1okhiy/1fYd4GnBWt3FsxeYofEsAE
X-Gm-Gg: AeBDiets07YEC7bD+UrwFC1W+RmgM81iv8yEJxDQsyD3PE0cD8uxVdA5wbJQG8PdrVo
	gx266AhfjKNy5X5PNpcL1v/UqeeKnlTp4QCcRBhYlu+rojnmUBJYGjE27XEmVbBWjFV/BS/kd1R
	H34TXrBLjsozo+BxudpvwuuI0KvFif7vpEITp5Ix8RTe6rMEcrqhJa5JNBwXsylO9lNfH015UtU
	0Qrq24hH2tr6lzQr8z2pUWR7c0Rcg1aAqenMD658/5DDw17l1a+UVTRLlpd7skZmFMDGpNbqxRS
	p/8avswjndwk1OLmw8UUKBlZArSrY3kFHxmblIkEzxgGorNWkbVUpWYDQjhMsr+SmG8I82Iy6TA
	0SY+Ufqs1fr8wYz/A4Lr6HvrZfG9Tueck2wC17ZFWCzi9vjVGGXcw3YGDU9j8KITZid1arw==
X-Received: by 2002:a05:620a:2684:b0:8d4:20f6:a52 with SMTP id af79cd13be357-904d65e2d8amr2097536885a.47.1778274240822;
        Fri, 08 May 2026 14:04:00 -0700 (PDT)
X-Received: by 2002:a05:620a:2684:b0:8d4:20f6:a52 with SMTP id af79cd13be357-904d65e2d8amr2097531085a.47.1778274240249;
        Fri, 08 May 2026 14:04:00 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:2500:540d:8da2:f197:6711? ([2600:4040:530f:2500:540d:8da2:f197:6711])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2cd04c68sm2364097985a.46.2026.05.08.14.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2026 14:03:59 -0700 (PDT)
Message-ID: <02d4d5fe-fd48-4d85-a55c-cf061d477ff9@redhat.com>
Date: Fri, 8 May 2026 17:03:58 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm vdo: add optional Intel IAA-backed compression support
To: "..." <439291857@qq.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel <dm-devel@lists.linux.dev>
References: <tencent_C10B5DDE03BCA1510BF6D23F384A4C120308@qq.com>
 <a986902e-014c-2df6-4e0d-de99a62f90f2@redhat.com>
 <b3033f45-ec82-4c01-9234-5616bd9877b1@redhat.com>
 <1f86bcf5-eb34-6df6-e69a-7be0ff9240cd@redhat.com>
 <3cc1960e-0780-49ed-b186-267212259844@redhat.com>
 <tencent_39E77FF894122536176CBD0F78C7A3E4ED09@qq.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <tencent_39E77FF894122536176CBD0F78C7A3E4ED09@qq.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PAQHKwfowkXystz_wvboe0cm99M3N5tz9ja0QDnknUM_1778274241
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 5/8/26 1:21 AM, ... wrote:
> 
> Hi,
> 
> Sorry for the late reply. I spent some time reworking the prototype 
> along the
> lines suggested in the previous discussion, and also tried to make the
> VDO-level measurements more explicit.
> 
> There were two main points in the previous feedback. The first was that IAA
> support should not add IAA-specific branches in the VDO data path, such as:
> 
>      if (iaa_enabled)
>              ...
>      else
>              ...
> 
> Instead, the VDO compression path should use the kernel asynchronous
> compression API, so that IAA can be plugged in through the existing 
> crypto API
> and the VDO code does not need to know about a specific accelerator. The
> second point was that the benefit should be shown at the dm-vdo level, 
> because
> raw compression-algorithm benchmarks do not necessarily translate into
> user-visible VDO throughput or data-efficiency gains.
> 
> The attached patch is my current prototype for the first point. It 
> replaces the
> direct LZ4 calls in the VDO compression path with a crypto acomp based
> compression context. The prototype uses the configured crypto compression
> algorithm for VDO compression and decompression, so the IAA path can be 
> reached
> through deflate-iaa without adding IAA-specific checks in data-vio.c.

In the future please submit patches (even prototypes) according to the 
official guidelines: 
https://docs.kernel.org/process/submitting-patches.html. Patches sent as 
attachments may get overlooked.

> This is still an RFC prototype, not a final patch series. In particular, 
> I am
> not trying to claim that this patch solves the full long-term metadata 
> problem
> for mixing arbitrary compression algorithms in one VDO format. My immediate
> goal is narrower: make the IAA implementation follow the generic async
> compression API direction, and check whether that is an acceptable basis for
> preparing a proper mergeable series.

In general, this approach looks reasonable. However, I do not think we 
can separate this work from the larger concerns of supporting multiple 
compression algorithms. From what I can see, IAA acceleration does not 
support the LZ4 algorithm, only deflate. That means that adding IAA 
support necessarily means having two different compression algorithms to 
support. We cannot simply change the algorithm out from under volumes 
that already have LZ4-compressed data.

> The attached patch also contains a small amount of temporary
> compression-statistics/debug code. I used it only to identify the VDO
> compression entry point and report VDO-level input and payload sizes for the
> comparison below. It is not required for the functional part of IAA support,
> and I can drop it or keep it behind debug guards when splitting the work 
> into
> reviewable patches.
> 
> For the VDO-level test, the data set was silesia.tar, a tar archive of the
> files from the Silesia corpus. I did not configure the VDO thread counts, so
> they used the default startup parameters. For this test I only enabled VDO
> compression and disabled deduplication:
> 
>      lvcreate --type vdo -n vdo_lv -L 180G -V 200G \
>          --compression=y --deduplication=n \
>          vdo_vg
> 
> I then created and mounted an ext4 filesystem on top of the VDO device, and
> used dd on regular files in the mounted filesystem to measure read/write
> throughput. The write test copied the Silesia tar archive into the mounted
> filesystem:
> 
>      dd if=../silesia_raw.tar of=./silesia.tar bs=1M oflag=direct
> 
> The read test read the same file back from the mounted ext4 filesystem:
> 
>      dd if=./silesia.tar of=/dev/null bs=1M iflag=direct
> 
> After the write test, I queried the VDO compression statistics with:
> 
>      dmsetup message vdo_vg-vpool0-vpool 0 compress-stats
> 
> The temporary compress-stats fields mean:
> 
>      calls: number of VDO compression calls counted in this run
>      input_bytes: total bytes passed to the compressor by VDO
>      payload_bytes: total compressed payload bytes produced by the 
> compressor
>      saved_bytes: input_bytes - payload_bytes
>      ratio_x100: payload_bytes / input_bytes * 100, truncated to an integer
>      ratio: the same payload/input ratio printed as a decimal value
> 
> LZ4 result:
> 
>      write:
>          202+1 records in
>          202+1 records out
>          211,957,760 bytes copied, 0.357554 s, 593 MB/s
>      read:
>          202+1 records in
>          202+1 records out
>          211,957,760 bytes copied, 0.183408 s, 1.2 GB/s
>      compress-stats:
>          calls 51626
>          input_bytes 211460096
>          payload_bytes 122705607
>          saved_bytes 88754489
>          ratio_x100 58
>          ratio 0.58x
> 
> IAA/deflate result:
> 
>      write:
>          202+1 records in
>          202+1 records out
>          211,957,760 bytes copied, 0.228480 s, 928 MB/s
>      read:
>          202+1 records in
>          202+1 records out
>          211,957,760 bytes copied, 0.183265 s, 1.2 GB/s
>      compress-stats:
>          calls 51626
>          input_bytes 211460096
>          payload_bytes 107585987
>          saved_bytes 103874109
>          ratio_x100 50
>          ratio 0.50x
> 
> The two runs had the same number of compression calls and the same VDO
> compression input size. On this 211.5 MB VDO compression input, IAA/deflate
> stored about 107.6 MB of payload, while LZ4 stored about 122.7 MB. That is
> about 15.1 MB less payload for IAA/deflate on this data set.

I have two concerns with this benchmark. First, you have disabled 
deduplication here. However, for any normal dm-vdo volume, deduplication 
should be on. The deduplication overhead should be part of the 
comparison when measuring throughput. (Deduplication is the core feature 
of dm-vdo. Any user who does not want the deduplication features is most 
likely better off using a different storage target altogether.)

Second, what does the performance look like when the IAA hardware is not 
present, or is disabled? It's worth making sure there is no performance 
regression in that case.

> The throughput result also looks more useful than my earlier report. 
> With the
> default VDO thread settings, the write-side dd result improved from 593 MB/s
> with LZ4 to 928 MB/s with IAA/deflate, while the read-side result stayed
> essentially the same at about 1.2 GB/s. This matches the lower-level 4KB
> compression tests I ran earlier: IAA showed higher compression bandwidth 
> than
> LZ4 at that granularity, while its decompression bandwidth was not 
> better than
> LZ4. So the VDO result is consistent with IAA helping the compressed 
> write path
> more than the read/decompression path.
> 
> My question is whether this revised approach is a reasonable direction for
> adding IAA support to dm-vdo: use the generic async compression API in 
> the VDO
> compression path, avoid IAA-specific branches, and then split the prototype
> into smaller reviewable patches. If this direction looks acceptable, I can
> continue by removing or isolating the temporary statistics code, 
> improving the
> benchmark description, and preparing a proper patch series.

The use of the async compression API here seems reasonable. We could 
switch the existing LZ4 calls to do LZ4 through the regular crypto 
interface. However, supporting deflate-iaa would need much more than 
this, as previously mentioned.

There are also a few places where your patch does too much. For 
instance, there is no need to add a module parameter for the algorithm, 
since the algorithm cannot be changed yet. (When it is added, that 
parameter should probably be set on the table line and not with a module 
parameter anyway.)

Matt

> Regards,
> Ze Fu
> 原始邮件
> ------------------------------------------------------------------------
> 发件人：Matthew Sakai <msakai@redhat.com>
> 发件时间：2026年5月5日 01:03
> 收件人：Mikulas Patocka <mpatocka@redhat.com>
> 抄送：... <439291857@qq.com>, dm-devel <dm-devel@lists.linux.dev>
> 主题：Re: dm vdo: add optional Intel IAA-backed compression support
> 
> 
> 
> 
> On 5/4/26 12:01 PM, Mikulas Patocka wrote:
>  >
>  >
>  > On Wed, 29 Apr 2026, Matthew Sakai wrote:
>  >
>  >>
>  >>
>  >> On 4/29/26 11:24 AM, Mikulas Patocka wrote:
>  >>> Hi
>  >>>
>  >>> I think the best way how to support it would be to modify the VDO target
>  >>> to use the asynchronous compression API (so that it could use arbitrary
>  >>> algorithms). Then, the support for IAA could be plugged in easily with
>  >>> little or no extra code.
>  >>
>  >> I agree that this is the right approach, but supporting arbitrary compression
>  >> algorithms will require some significant changes on its own. dm- 
> vdo currently
>  >> has nowhere to store information about what algorithm is used for which
>  >> blocks, so it would require reworking the metadata. (We would probably store
>  >
>  > You can store the algorithm in the superblock and use it for all blocks on
>  > the device. This would be not as flexible as per-block algorithm
>  > specification, but it should be relatively easy to implement - and it
>  > would allow you to evaluate whether different algorithms improve
>  > performance or compression ratio.
> 
> We could do that, certainly. It means picking the compression algorithm
> at format time, which also means no existing vdo volumes could take
> advantage of it. But we'd still need an upgrade for existing volumes to
> handle the new superblock field. I think managing the compression
> algorithm per-block is not that much more work, especially since I've
> already written much of it.
> 
>  >> the extra compression information in the compression block header.) This
>  >> metadata rework in turn will require some effort to make sure we can continue
>  >> to support existing users who will want to continue to use dm- 
> vdo volumes in
>  >> the current format.
>  >
>  > Mikulas
>  >
> 
> 

