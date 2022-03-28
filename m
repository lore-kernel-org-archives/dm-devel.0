Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D454EC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 29 Mar 2022 05:32:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-_LQF_AU6MFqMXkt8XDwxaQ-1; Tue, 29 Mar 2022 01:32:07 -0400
X-MC-Unique: _LQF_AU6MFqMXkt8XDwxaQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D7468FD0CA;
	Tue, 29 Mar 2022 05:32:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 72BDB432465;
	Tue, 29 Mar 2022 05:32:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4D80F1940345;
	Tue, 29 Mar 2022 05:32:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 183FD1947BBE
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Mar 2022 11:18:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E986E42D3D1; Mon, 28 Mar 2022 11:18:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E537142D3CA
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 11:18:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC2353C11A00
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 11:18:22 +0000 (UTC)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
 [209.85.167.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-KM_bLZRAOzmKDYAHD033LQ-1; Mon, 28 Mar 2022 07:18:20 -0400
X-MC-Unique: KM_bLZRAOzmKDYAHD033LQ-1
Received: by mail-lf1-f49.google.com with SMTP id d5so24096342lfj.9
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 04:18:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:from:to:date:message-id:user-agent
 :mime-version:content-transfer-encoding;
 bh=QtYy8qA9A7f/3Xy7Dur/JEWyQGPt7QBEGPR9HcaH88s=;
 b=eFYVo7Sv9OzCE9pa0IDruGLduoaAPgUxQPI06HuphmqQNZ/sxeX/csOOHUM/lqTjIC
 N0iYmmVOEhGn8nnH8iVsJ2yqc8WoNo0T1rWRO3UCP5qtoggz5F9JdcoCVS0xCPRlbMxS
 OOD7OrHQRncAfHzMSIgTtLdMPYEQ4z+4TkF5Oz7hQsriusVpjW+WuDqHCE32J1Omczsn
 Myc2ja2UMseeKy7kdc6jXn6dpwaW/PAm0i90mPddRM28tWXFliVqyDl1dWcXpJ2U7gGk
 78em74fx50lyMfxum9IoqAEWH6okqyvjnxWFXMk6CzasT5bCE60R220w9eI4AcWXjrQh
 RgWA==
X-Gm-Message-State: AOAM532OYhA66Om4ZIv5KIQw3z97ycAJtAP2k8q9hr3BpP67vyV+R62j
 OXtxlnLfmPPrzySnvkHzy+usrY4fpOemBVE2
X-Google-Smtp-Source: ABdhPJyG6HakjF8S+cSEVLGRq5jL+P4HH8LNlrkQBxNGFhsYxM9yivaZAvLE+OFDpuX+6LG5nXUfTw==
X-Received: by 2002:a19:6709:0:b0:448:3162:d843 with SMTP id
 b9-20020a196709000000b004483162d843mr19212735lfc.95.1648466297580; 
 Mon, 28 Mar 2022 04:18:17 -0700 (PDT)
Received: from [127.0.1.1] ([2.92.192.17]) by smtp.gmail.com with ESMTPSA id
 r20-20020a2e5754000000b002480655267dsm1624572ljd.67.2022.03.28.04.18.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 28 Mar 2022 04:18:16 -0700 (PDT)
From: Kirill Tkhai <kirill.tkhai@openvz.org>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, 
 linux-kernel@vger.kernel.org, khorenko@virtuozzo.com,
 kirill.tkhai@openvz.org
Date: Mon, 28 Mar 2022 14:18:16 +0300
Message-ID: <164846619932.251310.3668540533992131988.stgit@pro>
User-Agent: StGit/1.5
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Tue, 29 Mar 2022 05:32:01 +0000
Subject: [dm-devel] [PATCH 0/4] dm: Introduce dm-qcow2 driver to attach
 QCOW2 files as block device
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset adds a new driver allowing to attach QCOW2 files
as block devices. Its idea is to implement in kernel only that
features, which affect runtime IO performance (IO requests
processing functionality). The maintenance operations are
synchronously processed in userspace, while device is suspended.

Userspace is allowed to do only that operations, which never
modifies virtual disk's data. It is only allowed to modify
QCOW2 file metadata providing that disk's data. The examples
of allowed operations is snapshot creation and resize.

Userspace part is handled by already existing utils (qemu-img).

For instance, snapshot creation on attached dm-qcow2 device looks like:

# dmsetup suspend $device
# qemu-img snapshot -c <snapshot_name> $device.qcow2
# dmsetup resume $device

1)Suspend flushes all pending IO and related metadata to file,
  leaving the file in consistent QCOW2 format.
  Driver .postsuspend throws out all images's cached metadata.
2)qemu-img creates snapshot: changes/moves metadata inside QCOW2 file.
3)Driver .preresume reads new version of metadata
  from file (1 page is required), and the device is ready
  to continue handling of IO requests.

This example shows the way of device-mapper infrastructure
allows to implement drivers following the idea of
kernel/userspace components demarcation. Thus, the driver
uses advantages of device-mapper instead of implementing
its own suspend/resume engine.

The below fio test was used to measure performance:

# fio --name=test --ioengine=libaio --direct=1 --bs=$bs --filename=$dev
      --readwrite=$rw --runtime=60 --numjobs=2 --iodepth=8

The collected results consists of the both: fio measurement
and system load taken from /proc/loadavg. Since loadavg min
period is 60 seconds, fio's runtime is 60 too.
Here is average results of 5 runs (IO/loadavg is also average
of IO/loadavg of 5 runs):

-------------------------------------------+---------------------------------+--------------------------+
                  qemu-nbd (native aio)    |             dm-qcow2            |          diff, %         |
----+--------------------------------------+---------------------------------+--------------------------+
bs  |  RW   | IO,MiB/s  loadavg  IO/loadavg|  IO,MiB/s   loadavg   IO/loadavg|IO     loadavg  IO/loadavg|
------------|------------------------------+---------------------------------+--------------------------+
4K  | READ  |  279       1.986     147     |  512        2.088     248       |+83.7    +5.1     +68.4   |
4K  | WRITE |  242       2.31      105     |  770        2.172     357       |+217.9   -5.9     +239.7  |
----+-------|------------------------------+---------------------------------+--------------------------+
64K | READ  |  1199      1.794     691     |  1218       1.118     1217      |+1.6     -37.7    +76     |
64K | WRITE |  946       1.084     877     |  1003       0.466     2144      |+6.1     -57      +144.5  |
------------|------------------------------+---------------------------------+--------------------------+
512K| READ  |  1741      1.142     1526    |  2196       0.546     4197      |+26.1    -52.2    +175.1  |
512K| WRITE |  1016      1.084     941     |  993        0.306     3267      |-2.2     -71.7    +246.9  |
----|-------|------------------------------+---------------------------------+--------------------------+
1M  | READ  |  1793      1.174     1542    |  2373       0.566     4384      |+32.4    -51.8    +184.2  |
1M  | WRITE |  1037      0.894     1165    |  1068       0.892     1196      |+2.9     -0.2     +2.7    |
----|-------+------------------------------+---------------------------------+--------------------------+
2M  | READ  |  1784      1.084     1654    |  2431       0.788     3090      |+36.3    -27.3    +86.8   |
2M  | WRITE |  1027      0.878     1172    |  1063       0.878     1212      |+3.6     0        +3.4    |
----+-------+------------------------------+---------------------------------+--------------------------+
(NBD attaching string: qemu-nbd -c $dev --aio=native --nocache file.qcow2)

As in diff column, dm-qcow2 driver has the best throughput
(the only exception is 512K WRITE), and the smallest
loadavg (the only exception is 4K READ). The density
of dm-qcow2 is significantly better.

(Note, that tests are made on preallocated images, when
 all L2 table is allocated, since QEMU has lazy L2 allocation
 feature, which is not implemented in dm-qcow2 yet).

So, one of the reasons of implementing the driver is providing
better performance and density than it's done in qemu-nbd.
The second reason is a possibility to unify virtual disks format
for VMs and containers, so a disk image can be used to start
both of them.

This patchset consists of 4 patches. Patches [1-2] make small
changes in dm code: [1] exports a function, while [2] makes
.io_hints be called for drivers not having .iterate_devices.
Patch [3] adds dm-qcow2, while patch [4] adds a userspace
wrapper for attaching such the devices.

---

Kirill Tkhai (4):
      dm: Export dm_complete_request()
      dm: Process .io_hints for drivers not having underlying devices
      dm-qcow2: Introduce driver to create block devices over QCOW2 files
      dm-qcow2: Add helper for working with dm-qcow2 devices


 drivers/md/Kconfig           |   17 +
 drivers/md/Makefile          |    2 +
 drivers/md/dm-qcow2-cmd.c    |  383 +++
 drivers/md/dm-qcow2-map.c    | 4256 ++++++++++++++++++++++++++++++++++
 drivers/md/dm-qcow2-target.c | 1026 ++++++++
 drivers/md/dm-qcow2.h        |  368 +++
 drivers/md/dm-rq.c           |    3 +-
 drivers/md/dm-rq.h           |    2 +
 drivers/md/dm-table.c        |    5 +-
 scripts/qcow2-dm.sh          |  249 ++
 10 files changed, 6309 insertions(+), 2 deletions(-)
 create mode 100644 drivers/md/dm-qcow2-cmd.c
 create mode 100644 drivers/md/dm-qcow2-map.c
 create mode 100644 drivers/md/dm-qcow2-target.c
 create mode 100644 drivers/md/dm-qcow2.h
 create mode 100755 scripts/qcow2-dm.sh

--
Signed-off-by: Kirill Tkhai <kirill.tkhai@openvz.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

