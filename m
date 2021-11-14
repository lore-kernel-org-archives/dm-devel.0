Return-Path: <SRS0=k/UL=QC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A06C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 06:55:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7564961BFD
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 06:55:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7564961BFD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=squashfs.org.uk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-pSdCXV__Paqd3HAYbVtJJA-1; Mon, 15 Nov 2021 01:54:56 -0500
X-MC-Unique: pSdCXV__Paqd3HAYbVtJJA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D408D100C666;
	Mon, 15 Nov 2021 06:54:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9A8BADF9;
	Mon, 15 Nov 2021 06:54:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 994C41832DD2;
	Mon, 15 Nov 2021 06:54:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AEJDPQE020815 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 14 Nov 2021 14:13:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8B6082026D7F; Sun, 14 Nov 2021 19:13:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 868172026D46
	for <dm-devel@redhat.com>; Sun, 14 Nov 2021 19:13:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A995285A5A8
	for <dm-devel@redhat.com>; Sun, 14 Nov 2021 19:13:22 +0000 (UTC)
Received: from p3plwbeout24-06.prod.phx3.secureserver.net
	(p3plsmtp24-06-2.prod.phx3.secureserver.net [68.178.252.192]) (Using
	TLS)
	by relay.mimecast.com with ESMTP id us-mta-12-6R-a_2gYNPeTCRVgoFGtZw-1; 
	Sun, 14 Nov 2021 14:13:18 -0500
X-MC-Unique: 6R-a_2gYNPeTCRVgoFGtZw-1
Received: from mailex.mailcore.me ([94.136.40.143]) by :WBEOUT: with ESMTP
	id mKtbmwUoSZksLmKtcmV2Yl; Sun, 14 Nov 2021 12:10:32 -0700
X-CMAE-Analysis: v=2.4 cv=BuFYfab5 c=1 sm=1 tr=0 ts=61915f28
	a=EhJYbXVJKsomWlz4CTV+qA==:117 a=84ok6UeoqCVsigPHarzEiQ==:17
	a=ggZhUymU-5wA:10 a=IkcTkHD0fZMA:10 a=vIxV3rELxO4A:10 a=pGLkceISAAAA:8
	a=Mf-47KkiosanKr8LZmEA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: phillip@squashfs.org.uk
X-SID: mKtbmwUoSZksL
Received: from 82-69-79-175.dsl.in-addr.zen.co.uk ([82.69.79.175]
	helo=[192.168.178.33])
	by smtp02.mailcore.me with esmtpa (Exim 4.94.2)
	(envelope-from <phillip@squashfs.org.uk>)
	id 1mmKta-000C30-IJ; Sun, 14 Nov 2021 19:10:31 +0000
Message-ID: <4b99139a-802a-8255-adf5-2d3f9d0ccf7c@squashfs.org.uk>
Date: Sun, 14 Nov 2021 19:10:30 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
To: Pintu Agarwal <pintu.ping@gmail.com>,
	open list <linux-kernel@vger.kernel.org>,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, Richard Weinberger <richard@nod.at>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Daniel Rosenberg <drosen@google.com>, astrachan@google.com,
	speed.eom@samsung.com, Sami Tolvanen <samitolvanen@google.com>,
	snitzer@redhat.com, squashfs-devel@lists.sourceforge.net
References: <CAOuPNLinoW5Cx=xbUcT-DB4RiQkAPpe=9hsc-Rkch0LxD0mh+Q@mail.gmail.com>
	<CAOuPNLgquwOJg85kDcf67+4kTYP9N=45FvV+VDTJr6txYi5-wg@mail.gmail.com>
	<CAOuPNLjFtS7ftg=+-K3S+0ndyNYmUNqXo7SHkyV4zK4G9bZ4Og@mail.gmail.com>
	<CAOuPNLg_YwyhK6iPZZbRWe57Kkr1d8LjJaDniCvvOqk4t2-Sog@mail.gmail.com>
	<CAOuPNLgYhm=goOiABjUFsAvRW+s2NqHjHYdm5MA9PvoUAMxOpg@mail.gmail.com>
From: Phillip Lougher <phillip@squashfs.org.uk>
In-Reply-To: <CAOuPNLgYhm=goOiABjUFsAvRW+s2NqHjHYdm5MA9PvoUAMxOpg@mail.gmail.com>
X-Mailcore-Auth: 439999529
X-Mailcore-Domain: 1394945
X-123-reg-Authenticated: phillip@squashfs.org.uk
X-Originating-IP: 82.69.79.175
X-CMAE-Envelope: MS4xfHUso2MRFMIUKaKXkV4r4zvtjiGuSO64YLGmJfgfXqK/Z5mrgpPHTrhNps3oIjwGBCN35pZ8Jp4coo66A3g5RLc8sR7WED7IZgudnxcaaBOwBUooA3AY
	RyWbbeQUZnDSoh2aNl70ggo5Cxf+Hx1c7SSM1p1ajDmTdX6jm4mgoR+cuyr6C/q3M6Q+cy9MuBJLguL01SR3Nv++KFsmVIylsPUb+LWOqa9slrkXDYJAt21B
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 15 Nov 2021 01:54:31 -0500
Subject: Re: [dm-devel] Kernel-4.14: With ubuntu-18.04 building rootfs
 images and booting gives SQUASHFS error: xz decompression failed,
 data probably corrupt
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 14/11/2021 07:06, Pintu Agarwal wrote:
> + Adding squashfs-devel to get opinion from squashfs side.
> 
> On Fri, 12 Nov 2021 at 12:48, Pintu Agarwal <pintu.ping@gmail.com> wrote:
>>
>> Hi,
>>
>> On Tue, 9 Nov 2021 at 21:04, Pintu Agarwal <pintu.ping@gmail.com> wrote:
>>
>>>>> We only get these squashfs errors flooded in the boot logs:
>>>>> {{{
>>>>> ....
>>>>> [    5.153479] device-mapper: init: dm-0 is ready
>>>>> [    5.334282] VFS: Mounted root (squashfs filesystem) readonly on device 253:0.
>>>>> ....
>>>>> [    8.954120] SQUASHFS error: xz decompression failed, data probably corrupt
>>>>> [    8.954153] SQUASHFS error: squashfs_read_data failed to read block 0x1106
>>>>> [    8.970316] SQUASHFS error: Unable to read data cache entry [1106]
>>>>> [    8.970349] SQUASHFS error: Unable to read page, block 1106, size 776c
>>>>> [    8.980298] SQUASHFS error: Unable to read data cache entry [1106]
>>>>> [    8.981911] SQUASHFS error: Unable to read page, block 1106, size 776c
>>>>> [    8.988280] SQUASHFS error: Unable to read data cache entry [1106]
>>>>> ....
>>>>> }}}
>>>>>
>>
>> One more observation:
>> When I disable FEC flag in bootloader, I see the below error:
>> [    8.360791] device-mapper: verity: 253:0: data block 2 is corrupted
>> [    8.361134] device-mapper: verity: 253:0: data block 3 is corrupted
>> [    8.366016] SQUASHFS error: squashfs_read_data failed to read block 0x1106
>> [    8.379652] SQUASHFS error: Unable to read data cache entry [1106]
>> [    8.379680] SQUASHFS error: Unable to read page, block 1106, size 7770
>>
>> Also, now I see that the decompress error is gone, but the read error
>> is still there.
>>
>> This seems to me that dm-verity detects some corrupted blocks but with
>> FEC it auto corrects itself, how when dm-verity auto corrects itself,
>> the squashfs decompression algorithm somehow could not understand it.
>>
>> So, it seems like there is some mis-match between the way FEC
>> correction and the squashfs decompression happens ?
>>
>> Is this issue seen by anybody else here ?
>>
> 
> The squashfs version used by Kernel:
> [    0.355958] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> 
> The squashfs version available on Ubuntu:
> mksquashfs version 4.3-git (2014/06/09)
> 
> The squashfs version used by Yocto 2.6:
> squashfs-tools/0001-squashfs-tools-Allow-setting-selinux-xattrs-through-.patch:61:
>     printf("mksquashfs version 4.3-git (2014/09/12)\n");
> 
> We create dm-verity squashfs image using version 4.3 whereas, the
> kernel uses 4.0 version to decompress it.
> Is there something missing here?
> 
> When FEC (Forward Error Correction) comes into picture, then squashfs
> decompress fails.
> When we remove FEC flag from dm-verity then decompress works but read
> error still occurs.
> This seems as if something is missing either in FEC handling or either
> in squashfs decompress logic.
> 
> Just wanted to know if there are any fixes already available in the
> mainline for this ?
> 
> 

As Squashfs maintainer I want you to stop randomly blaming anything and 
everything here.  You won't fix anything doing that.

In a previous email you stated


> 
> One quick observation:
> This issue is seen only when we enable dm-verity in our bootloader and
> cross-building the bootloader/kernel (with Yocto 2.6 toolchain
> arm-oe-linux-gnueabi-) on Ubuntu 18.04.
> The issue is *NOT* seen (on the same device) when building the
> dm-verity enabled kernel on Ubuntu 16.04.
>
> Is it something to do with the cross-toolchain difference between
> Ubuntu 16 and 18 ?
> 

If that is the case, then it is not an issue with Squashfs or any
kernel code, it is a build time issue and *that* is where you should
be concentrating your efforts.  Find out what differences are there.

You don't seem to understand that a Squashfs filesystem generated
by any Mksquashfs 4.X is mountable *without* errors on any kernel
since 2.6.29 (January 2009).  Looking for mismatches between
Mksquashfs and/or kernel version and blaming that for the above 
different behaviour is a complete waste of time.

Phillip

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

