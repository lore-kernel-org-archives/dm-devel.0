Return-Path: <SRS0=voF8=GZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8DAEC433E6
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:20:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 960AC23AA3
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:20:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 960AC23AA3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arrikto.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-XxJGvfmIPGepYy0wNdV8iA-1; Fri, 22 Jan 2021 10:20:04 -0500
X-MC-Unique: XxJGvfmIPGepYy0wNdV8iA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D0E3100C600;
	Fri, 22 Jan 2021 15:19:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 586F019C71;
	Fri, 22 Jan 2021 15:19:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D098E4BB7B;
	Fri, 22 Jan 2021 15:19:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10MFJoEx027980 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Jan 2021 10:19:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7C39410E60E0; Fri, 22 Jan 2021 15:19:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 782CF10E60DC
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:19:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 234DF185A794
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:19:48 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
	[209.85.128.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-48-zLXLOcQ_MPqYDl0FmOCWcA-1; Fri, 22 Jan 2021 10:19:45 -0500
X-MC-Unique: zLXLOcQ_MPqYDl0FmOCWcA-1
Received: by mail-wm1-f47.google.com with SMTP id i63so4634783wma.4
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 07:19:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id;
	bh=Aj2jG4Dx9flm0oPMuXc20vwUmjkNlqvwTt6EJJe8M0k=;
	b=BNAczoz7rRgDSiw1o7Ev3ykYhm2qrnyenEjMCy3kyEHtJdd4inU/iGTNNmu38WduV+
	O97kgYYIW0cAlyfDVzA/rmsw4M2S2ThlUnOPGc+sBaZAQ4X9g7Qz+CGavbvLAGDAqGqU
	tsXcr9GwrdRhrdNN7xvk52ZZXR/Osq9wqKWv3APIZetfxPrPtEf4PXKztF7DqmZEyzCa
	gu2PiJb23OQd0L40lq+iOYNxEH7+vd/T1m45513kB/I8t9KrAut8QnoC7fzSqPEwMKgM
	joLy7DMaTzkvfgviSaRExViH9eRBbOHx/6xdjAJb2J5vuhWetfsb32y1yq0XBCUieNRV
	MgAQ==
X-Gm-Message-State: AOAM531Bweqz5rgy/VjoLXHf0UMf1yvKO3Gvi+MXTrallnUT/JAw23TC
	h3F0ZLiwQ3cR/PdOq7pr0Tb6Jg==
X-Google-Smtp-Source: ABdhPJwPNi9S1fGrMsX9QrN0kwqePOHzB7GWgjpLWmSb8RUt1npv+JdxJvuTLqeiXHaCLIw2Dt7mkg==
X-Received: by 2002:a1c:c903:: with SMTP id f3mr4394786wmb.69.1611328783956;
	Fri, 22 Jan 2021 07:19:43 -0800 (PST)
Received: from snf-864.vm.snf.arr ([31.177.62.212])
	by smtp.gmail.com with ESMTPSA id
	j13sm11526650wmi.24.2021.01.22.07.19.41
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 22 Jan 2021 07:19:42 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Date: Fri, 22 Jan 2021 17:19:29 +0200
Message-Id: <20210122151931.24645-1-ntsironis@arrikto.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: ejt@redhat.com, ntsironis@arrikto.com
Subject: [dm-devel] [PATCH 0/2] dm era: Fix bugs that lead to lost writes
	after crash
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In case of a system crash, dm-era might lose the information about
blocks written during the current era, although the corresponding writes
were passed down to the origin device and completed successfully.

There are two major, distinct bugs that can lead to lost writes:
  1. dm-era doesn't recover the committed writeset after a system crash
  2. dm-era decides whether to defer or not a write based on non
     committed information

Failure to recover committed writeset
=====================================

Following a system crash, dm-era fails to recover the committed writeset
for the current era, leading to lost writes. That is, we lose the
information about what blocks were written during the affected era.

There are three issues that cause the committed writeset to get lost:

1. dm-era doesn't load the committed writeset when opening the metadata
2. The code that resizes the metadata wipes the information about the
   committed writeset (assuming it was loaded at step 1)
3. era_preresume() starts a new era, without taking into account that
   the current era might not have been archived, due to a system crash.

Steps to reproduce
------------------

1. Create two LVs, one for data and one for metadata

   # lvcreate -n eradata -L1G datavg
   # lvcreate -n erameta -L64M datavg

2. Fill the whole data device with zeroes

   # dd if=/dev/zero of=/dev/datavg/eradata oflag=direct bs=1M

3. Create the dm-era device. We set the tracking granularity to 4MiB.

   # dmsetup create eradev --table "0 `blockdev --getsz \
     /dev/datavg/eradata` era /dev/datavg/erameta /dev/datavg/eradata 8192"

4. Write random data to the first block of the device

   # dd if=/dev/urandom of=/dev/mapper/eradev oflag=direct bs=4M count=1

5. Flush the device

   # sync /dev/mapper/eradev

6. Forcefully reboot the machine

   # echo b > /proc/sysrq-trigger

7. When the machine comes back up recreate the dm-era device and ask for
   the list of blocks written since era 1, i.e., for all blocks ever
   written to the device.

   # dmsetup message eradev 0 take_metadata_snap
   # era_invalidate --metadata-snapshot --written-since 1 /dev/datavg/erameta
   <blocks>
   </blocks>

The list of written blocks reported by dm-era is empty, even though we
wrote the first 4MiB block of the device successfully. Using, e.g.,
`hexdump /dev/datavg/eradata`, one can verify that indeed the first 4MiB
block of the device was written.

Missed writes
=============

In case of a system crash, dm-era might fail to mark blocks as written
in its metadata, although the corresponding writes to these blocks were
passed down to the origin device and completed successfully.

Suppose the following sequence of events:

1. We write to a block that has not been yet written in the current era
2. era_map() checks the in-core bitmap for the current era and sees that
   the block is not marked as written.
3. The write is deferred for submission after the metadata have been
   updated and committed.
4. The worker thread processes the deferred write
   (process_deferred_bios()) and marks the block as written in the
   in-core bitmap, **before** committing the metadata.
5. The worker thread starts committing the metadata.
6. We do more writes that map to the same block as the write of step (1)
7. era_map() checks the in-core bitmap and sees that the block is marked
   as written, **although the metadata have not been committed yet**.
8. These writes are passed down to the origin device immediately and the
   device reports them as completed.
9. The system crashes, e.g., power failure, before the commit from step
   (5) finishes.

When the system recovers and we query the dm-era target for the list of
written blocks it doesn't report the aforementioned block as written,
although the writes of step (6) completed successfully.

Steps to reproduce
------------------

1. Create two LVs, one for data and one for metadata

   # lvcreate -n eradata -L1G datavg
   # lvcreate -n erameta -L64M datavg

2. Fill the whole data device with zeroes

   # dd if=/dev/zero of=/dev/datavg/eradata oflag=direct bs=1M

3. Create a dm-delay device, initially with no delay, that overlays the
   metadata device. This allows us to delay the metadata commit so we
   can reproduce the bug easier.

   # dmsetup create delaymeta --table "0 `blockdev --getsz \
     /dev/datavg/erameta` delay /dev/datavg/erameta 0 0 /dev/datavg/erameta 0 0"

4. Create the dm-era device, using the data LV for data and the dm-delay
   device for its metadata. We set the tracking granularity to 4MiB.

   # dmsetup create eradev --table "0 `blockdev --getsz \
     /dev/datavg/eradata` era /dev/mapper/delaymeta /dev/datavg/eradata 8192"

5. Change the dm-delay device table and set the write delay to 10secs

   # dmsetup suspend delaymeta; dmsetup load delaymeta --table "0 \
     `blockdev --getsz /dev/datavg/erameta` delay /dev/datavg/erameta 0 0 \
     /dev/datavg/erameta 0 10000"; dmsetup resume delaymeta

6. Run the following script:

   #!/bin/bash

   # a. Write to the first 4KiB block of the device, which maps to era block #0
   dd if=/dev/urandom of=/dev/mapper/eradev oflag=direct bs=4K count=1 &

   # b. Write to the second 4KiB block of the device, which also maps to block #0
   dd if=/dev/urandom of=/dev/mapper/eradev oflag=direct bs=4K seek=1 count=1

   # c. Sync the device
   sync /dev/mapper/eradev

   # d. Forcefully reboot
   echo b > /proc/sysrq-trigger

   The command of step (6a) blocks as expected, waiting for the metadata
   commit. Meanwhile dm-era has marked block #0 as written in the in-core
   bitmap.

   We would expect the command of step (6b) to also block waiting for
   the metadata commit triggered by (6a), as they touch the same block.

   But, it doesn't.

7. After the system comes back up examine the data device, e.g., using
   `hexdump /dev/datavg/eradata`. We can see that indeed the write from
   (6a) never completed, but the write from (6b) hit the disk.

8. Recreate the device stack and ask for the list of blocks written
   since era 1, i.e., for all blocks ever written to the device.

   # dmsetup message eradev 0 take_metadata_snap
   # era_invalidate --metadata-snapshot --written-since 1 /dev/mapper/delaymeta
   <blocks>
   </blocks>

The list of written blocks reported by dm-era is empty, even though
block #0 was written and flushed to the device.

Nikos Tsironis (2):
  dm era: Recover committed writeset after crash
  dm era: Update in-core bitset after committing the metadata

 drivers/md/dm-era-target.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

-- 
2.11.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

