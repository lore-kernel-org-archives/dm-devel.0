Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA12EB64D8
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 21:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686778188;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+EWZOiZueMS9QeFPFwFtNpHXEpCGpZPxNFC+BppQH7U=;
	b=Xnkokk66CM26So3QnyRTLufN84kz9Tf6AR5sB0ohu7a2jQ1RP0GhsELyhzjpd2mPWrR5pD
	/LCxSURwCoQusQkjx/dv5pD0K9NBqceWCKgJPV/GDUAyuBKdO6oLioc9vwcJi6wGzd1gJb
	Kb2vG7AJ4nsD1DsV/F0N0DvoOuAevbg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-uNw0rGRCMVmGdG2EGDgPfA-1; Wed, 14 Jun 2023 17:29:45 -0400
X-MC-Unique: uNw0rGRCMVmGdG2EGDgPfA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D887810BB3;
	Wed, 14 Jun 2023 21:29:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2FEAE492C38;
	Wed, 14 Jun 2023 21:29:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB19D19451D9;
	Wed, 14 Jun 2023 21:29:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0DC4E19451CD
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 21:29:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D392D2026D6A; Wed, 14 Jun 2023 21:29:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CBE7C2026D49
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 21:29:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0EF9811E78
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 21:29:32 +0000 (UTC)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com
 [209.85.167.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-zMg9I_QuNKCnev5dNO5_WQ-1; Wed, 14 Jun 2023 17:29:30 -0400
X-MC-Unique: zMg9I_QuNKCnev5dNO5_WQ-1
Received: by mail-oi1-f170.google.com with SMTP id
 5614622812f47-39ca48cd4c6so4299111b6e.0
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 14:29:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686778169; x=1689370169;
 h=to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=UWqZKxwDu5YhL1nVDIMntE4VwZiEq5cCOT2i8wUFGjc=;
 b=Q0BoGThzn8QiV6dSjWN9zbm7HSRqLgo7BVoWk2D+jT7JG/Bxy+mTzOBPQHMAhvgFt5
 fMyCezoR6v/jOLHAcfvLhrVQtj/wj6DvmKd8p7MIp+3vhO2o8ts0zorX8TU7/p6nEXu7
 zpPx1L0mkzzdzivAJh8NmLY6Y81ZMXlEzSGKCoCOA5G7iuGaITP8U+xCmNyeK38hM65k
 6FA1c1jrS7FjEMfkKXdSVdqeq1ZNmdxkAkTFqEbbGC8NUG42mYKtHEBX7eBE2YwPazpo
 8Z7ZF/2n5JIvbq0vy0gXEzBBq8+bLWdhTyxErLAFMFbgFj5/DlQLbVpYgAmK2TPJB2sQ
 RIHg==
X-Gm-Message-State: AC+VfDzYsX/bWLzOSKNkoaDrkMr7qrBlMJ1wCGvbar+9scSp6drbOdhk
 Vc8fqvVhKuroVhGGrcEutkx+XmppplW+ijWlLcj1a9qX8Ro=
X-Google-Smtp-Source: ACHHUZ7DmY6uYj/X2NOQAG838vo3Ko/6cnYSC3GOTmgStm8nXHVNfn+x0B/o57trCWedUzBOo84YX9borCN4ogTN51M=
X-Received: by 2002:a05:6808:148e:b0:39a:815d:8aad with SMTP id
 e14-20020a056808148e00b0039a815d8aadmr13079395oiw.11.1686778169191; Wed, 14
 Jun 2023 14:29:29 -0700 (PDT)
MIME-Version: 1.0
From: Marc Smith <msmith626@gmail.com>
Date: Wed, 14 Jun 2023 17:29:17 -0400
Message-ID: <CAH6h+heB57N4StY-Nhs+QV+Z8UkD8x8K+C1T-NVbsz55fT+kfg@mail.gmail.com>
To: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] dm-writecache - Unexpected Data After Host Crash
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I'm using dm-writecache via 'lvmcache' on Linux 5.4.229 (vanilla
kernel.org source). I've been testing my storage server -- I'm using a
couple NVMe drives in an MD RAID1 array that is the cache (fast)
device, and using a 12-drive MD RAID6 array as the origin (backing)
device.

I noticed that when the host crashes (power loss, forcefully reset,
etc.) it seems the cached (via dm-writecache) LVM logical volume does
not contain the bits I expect. Or perhaps I'm missing something in how
I understand/expect dm-writecache to function...

I change the auto-commit settings to larger values so the data on the
cache device is not flushed to the origin device:
# lvchange --cachesettings "autocommit_blocks=1000000000000"
--cachesettings "autocommit_time=3600000" dev_1_default/sys_dev_01

Then populate the start of the device (cached LV) with zeros:
# dd if=/dev/zero of=/dev/dev_1_default/sys_dev_01 bs=1M count=10 oflag=direct

Force a flush from the cache device to the backing device (all zero's
in the first 10 MiB):
# dmsetup message dev_1_default-sys_dev_01 0 flush

Now write a different pattern to the first 10 MiB:
# fio --bs=1m --direct=1 --rw=write --buffer_pattern=0xff
--ioengine=libaio --iodepth=1 --numjobs=1 --size=10M
--output-format=terse --name=/dev/dev_1_default/sys_dev_01

And then induce a reset:
# echo b > /proc/sysrq-trigger

Now after the system boots back up, assemble the RAID arrays and
activate the VG, then examine the data:
# vgchange -ay dev_1_default
# dd if=/dev/dev_1_default/sys_dev_01 bs=1M iflag=direct count=10
status=noxfer | od -t x2
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
10+0 records in
10+0 records out
50000000


So I'm expecting all "ffff" in the first 10 MiB, but instead, I'm
getting what's on the origin device, zeros (not what was written to
the cache device).

Obviously in a crash scenario (power loss, reset, panic, etc.) the
dirty data in the cache won't be flushed to the origin device,
however, I was expecting when the DM device started on the subsequent
boot (via activating the VG) that all of the dirty data would be
present -- it seems like it is not.


Thanks for any information/advice, it's greatly appreciated.


--Marc

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

