Return-Path: <SRS0=voF8=GZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D73BC433DB
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:22:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 300EB239D4
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:22:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 300EB239D4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arrikto.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-_4zQteouOL-dEqir1_MsgQ-1; Fri, 22 Jan 2021 10:22:22 -0500
X-MC-Unique: _4zQteouOL-dEqir1_MsgQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48ACE802B42;
	Fri, 22 Jan 2021 15:22:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 253E85B4A6;
	Fri, 22 Jan 2021 15:22:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E7B504BB7B;
	Fri, 22 Jan 2021 15:22:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10MFMF74028262 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Jan 2021 10:22:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4B2D2EE84E; Fri, 22 Jan 2021 15:22:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 431CCED143
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:22:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E256E101A562
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:22:10 +0000 (UTC)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
	[209.85.128.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-355-nfiiXSVDOHe8aEqgj1WK6w-1; Fri, 22 Jan 2021 10:22:08 -0500
X-MC-Unique: nfiiXSVDOHe8aEqgj1WK6w-1
Received: by mail-wm1-f48.google.com with SMTP id v184so4667749wma.1
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 07:22:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id;
	bh=53SgvnLqoF7ix7pCD9rMyWD1exySStDsIK9JTw0Vm4s=;
	b=CI8egBN0dT3rZge+iXMwDCQcv0rs9E8p9lOnAZ31xfpvAJ7b8lItcGP9olBrS10vYX
	zbP10PbeEjoKYPjSFgHt9cNKJ7ggkKop9pQRX2HaWdQH4Ldx4sCofnyfTSosMP6wdtwT
	gp1Qyvrlt7tlOxQFVM2pfJofYA+9jq+zag79A7wVRCOutEXUMg2ncedtvGIwz7eJC/aT
	K7OECFUved30GbvR1zINgevN5BXJc2Skz7sVmGVT3aoB+TIcXRaDdDr9+Tevie/faRvB
	p52Hkoe7ArwF/EOHTon4PXFgy85ePJk6ybY8OCQGuYgPqF2MWbGO/+0RfXOLkKPVV47w
	+1LA==
X-Gm-Message-State: AOAM531DD897mGQ5fJNaVPTmP/G18+Tbeb1zWLjsWb8M0r8msYWGDFsf
	f0bCmGWM9keD6f6YyNHhN9RF9Q==
X-Google-Smtp-Source: ABdhPJwNiu1wNgp6BnWDCdC7F6pVTfbCuoKwIaZtO/UsagsqiGOioWtnfhEhYRrog6qz7qqOtB1dDw==
X-Received: by 2002:a7b:ca4d:: with SMTP id m13mr4625798wml.28.1611328927261; 
	Fri, 22 Jan 2021 07:22:07 -0800 (PST)
Received: from snf-864.vm.snf.arr ([31.177.62.212])
	by smtp.gmail.com with ESMTPSA id
	z1sm12660938wru.70.2021.01.22.07.22.05
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 22 Jan 2021 07:22:06 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Date: Fri, 22 Jan 2021 17:22:03 +0200
Message-Id: <20210122152204.24738-1-ntsironis@arrikto.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: ejt@redhat.com, ntsironis@arrikto.com
Subject: [dm-devel] [PATCH 0/1] dm era: Fix digestion bug that can lead to
	lost writes
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In case of devices with at most 64 blocks, the digestion of consecutive
eras uses the writeset of the first era as the writeset of all eras to
digest, leading to lost writes. That is, we lose the information about
what blocks were written during the affected eras.

The root cause of the bug is a failure to reinitialize the on-disk
bitset cache when the digestion code starts digesting a new writeset.

Steps to reproduce
------------------

1. Create two LVs, one for data and one for metadata

   # lvcreate -n eradata -L1G datavg
   # lvcreate -n erameta -L64M datavg

2. Fill the whole data device with zeroes

   # dd if=/dev/zero of=/dev/datavg/eradata oflag=direct bs=1M

3. Create a dm-delay device, which inserts a 500 msec delay to writes:

   # dmsetup create delaymeta --table "0 `blockdev --getsz \
     /dev/datavg/erameta` delay /dev/datavg/erameta 0 0 /dev/datavg/erameta 0 500"

4. Create a 256MiB (64 4MiB blocks) dm-era device, using the data LV for
   data and the dm-delay device for its metadata. We set the tracking
   granularity to 4MiB.

   # dmsetup create eradev --table "0 524288 era /dev/mapper/delaymeta \
     /dev/datavg/eradata 8192"

5. Run the following script:

   #!/bin/bash

   # Write to block #0 during era 1
   dd if=/dev/urandom of=/dev/mapper/eradev oflag=direct bs=4K count=1

   # Increase era to 2
   dmsetup message eradev 0 checkpoint

   # Write to block #1 during era 2
   dd if=/dev/urandom of=/dev/mapper/eradev oflag=direct bs=4K count=1 seek=1024 &

   # Increase era to 3
   dmsetup message eradev 0 checkpoint

   # Sync the device
   sync /dev/mapper/eradev

6. Remove the device, so we can examine its metadata

   # dmsetup remove eradev

7. Examine the device's metadata with `era_dump --logical /dev/mapper/delaymeta`

   <superblock uuid="" block_size="8192" nr_blocks="64" current_era="3">
       <era_array>
           <era block="0" era="2"/>
           <era block="1" era="0"/>
           <era block="2" era="0"/>
           ...
           <era block="63" era="0"/>
       </era_array>
   </superblock>

   We see that:
    a. Block #0 is marked as last written during era 2, whereas we wrote
       to it only during era 1
    b. Block #1 is not marked as written at all, whereas we wrote to it
       during era 2

8. Examining the data device, e.g., with `hexdump /dev/datavg/eradata`,
   we can see that both blocks #0 and #1 are written, as expected.

Nikos Tsironis (1):
  dm era: Reinitialize bitset cache before digesting a new writeset

 drivers/md/dm-era-target.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
2.11.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

