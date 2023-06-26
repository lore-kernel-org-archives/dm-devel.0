Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F261CEB64D7
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jun 2023 15:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687794077;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=Jfzzz+t0G1Nm8de4m7szDuVaUeBy6GtcfCxIMNHw2+k=;
	b=E/jMmenI0Zh+UPll5kfimzMXi4Q7H+jgiME/9cmoQXgZ55zSr22LbS+K5hgNrVo8RMqbZ3
	6prCFYqYTZ4yXBK6nfpIX7jdG/z2AcfEXTdOA+8FvE8aJPMCrH13iciXVIQqNzDYhDaeRO
	aDloklDslPolv8y+BqlEUnintjaiVag=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-YSi9wOJHO1mMjt3SWBRYkQ-1; Mon, 26 Jun 2023 11:41:13 -0400
X-MC-Unique: YSi9wOJHO1mMjt3SWBRYkQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41B24800159;
	Mon, 26 Jun 2023 15:40:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E2E851121339;
	Mon, 26 Jun 2023 15:40:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7E58F1946588;
	Mon, 26 Jun 2023 15:40:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 48CBA1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 15:40:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12BDCC1ED98; Mon, 26 Jun 2023 15:40:42 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 04CEDC1ED97;
 Mon, 26 Jun 2023 15:40:42 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id E8B0330C045B; Mon, 26 Jun 2023 15:40:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 E1B323FB76; Mon, 26 Jun 2023 17:40:36 +0200 (CEST)
Date: Mon, 26 Jun 2023 17:40:36 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Marc Smith <msmith626@gmail.com>
In-Reply-To: <CAH6h+hfninB96O6z7rUFX=KWspnB-WR6oCzBEOF2+49vKfjQKg@mail.gmail.com>
Message-ID: <2e3230-9ff7-dc7-4e5f-18cb1ad9fa32@redhat.com>
References: <CAH6h+heB57N4StY-Nhs+QV+Z8UkD8x8K+C1T-NVbsz55fT+kfg@mail.gmail.com>
 <CAH6h+hfninB96O6z7rUFX=KWspnB-WR6oCzBEOF2+49vKfjQKg@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] Fwd: dm-writecache - Unexpected Data After Host Crash
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="185210117-1214614054-1687794036=:2314063"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185210117-1214614054-1687794036=:2314063
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Thu, 15 Jun 2023, Marc Smith wrote:

> Hi Mikulas,
> 
> Apologies for the direct message, but I noticed it seems you're the
> original author of dm-writecache and wanted to get your thoughts on
> the issue described below... I've been going through the code in
> dm-writecache.c and trying to educate myself; it seems that
> writecache_read_metadata() is used to read the full set of metadata
> only in the writecache_resume() function. In writecache_ctr() only the
> first block of metadata is retrieved. So it seems this explains why in
> my example below with a system crash (eg, reset / power off / panic)
> the dirty data that resides on the SSD is not populated on VG
> activation.
> 
> It made me wonder if this is perhaps a bug in LVM2 where the 'resume'
> message is not being issued to the DM target (and therefore not
> populating the in-memory metadata structure properly).
> 
> I tried an older 5.4.x kernel as well but the issue still persists in
> that environment.
> 
> Thanks for your time.
> 
> 
> --Marc

Hi

I reproduced the issue that you reported, but I think this is not a bug in 
writecache, but an expected behavior.

Note that O_DIRECT doesn't guarantee that the written data is flushed to 
the stable storage. With O_DIRECT, we bypass kernel page cache, but the 
data may be still cached in the hardware cache inside the disk and if the 
power failure happens, the data may be lost. You need to use the "fsync" 
or "fdatasync" syscall - it will issue the flush command to the disk and 
when it returns, it is guaranteed that the data is persistent.

In a similar way, if we write data to dm-writecache, it is not guranteed 
that the data will be written when the I/O finishes. It may still be 
cached inside dm-writecache, until "fsync" or "fdatasync" is called.

If I add "--end_fsync=1" to the fio command that you posted below, there 
is no longer any data loss - after a reboot, the device will contain 0xff. 
So, dm-writecache works as expected, flushing the data when "fsync" is 
called.

Mikulas

> ---------- Forwarded message ---------
> From: Marc Smith <msmith626@gmail.com>
> Date: Wed, Jun 14, 2023 at 5:29 PM
> Subject: dm-writecache - Unexpected Data After Host Crash
> To: <dm-devel@redhat.com>
> 
> 
> Hi,
> 
> I'm using dm-writecache via 'lvmcache' on Linux 5.4.229 (vanilla
> kernel.org source). I've been testing my storage server -- I'm using a
> couple NVMe drives in an MD RAID1 array that is the cache (fast)
> device, and using a 12-drive MD RAID6 array as the origin (backing)
> device.
> 
> I noticed that when the host crashes (power loss, forcefully reset,
> etc.) it seems the cached (via dm-writecache) LVM logical volume does
> not contain the bits I expect. Or perhaps I'm missing something in how
> I understand/expect dm-writecache to function...
> 
> I change the auto-commit settings to larger values so the data on the
> cache device is not flushed to the origin device:
> # lvchange --cachesettings "autocommit_blocks=1000000000000"
> --cachesettings "autocommit_time=3600000" dev_1_default/sys_dev_01
> 
> Then populate the start of the device (cached LV) with zeros:
> # dd if=/dev/zero of=/dev/dev_1_default/sys_dev_01 bs=1M count=10 oflag=direct
> 
> Force a flush from the cache device to the backing device (all zero's
> in the first 10 MiB):
> # dmsetup message dev_1_default-sys_dev_01 0 flush
> 
> Now write a different pattern to the first 10 MiB:
> # fio --bs=1m --direct=1 --rw=write --buffer_pattern=0xff
> --ioengine=libaio --iodepth=1 --numjobs=1 --size=10M
> --output-format=terse --name=/dev/dev_1_default/sys_dev_01
> 
> And then induce a reset:
> # echo b > /proc/sysrq-trigger
> 
> Now after the system boots back up, assemble the RAID arrays and
> activate the VG, then examine the data:
> # vgchange -ay dev_1_default
> # dd if=/dev/dev_1_default/sys_dev_01 bs=1M iflag=direct count=10
> status=noxfer | od -t x2
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 10+0 records in
> 10+0 records out
> 50000000
> 
> 
> So I'm expecting all "ffff" in the first 10 MiB, but instead, I'm
> getting what's on the origin device, zeros (not what was written to
> the cache device).
> 
> Obviously in a crash scenario (power loss, reset, panic, etc.) the
> dirty data in the cache won't be flushed to the origin device,
> however, I was expecting when the DM device started on the subsequent
> boot (via activating the VG) that all of the dirty data would be
> present -- it seems like it is not.
> 
> 
> Thanks for any information/advice, it's greatly appreciated.
> 
> 
> --Marc
> 
--185210117-1214614054-1687794036=:2314063
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--185210117-1214614054-1687794036=:2314063--

