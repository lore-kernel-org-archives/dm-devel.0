Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2ABC433E6
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 14:31:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ED05C64E27
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 14:31:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED05C64E27
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-Pu7lF7WRNKGyPFLm9IkeYA-1; Tue, 09 Feb 2021 09:31:13 -0500
X-MC-Unique: Pu7lF7WRNKGyPFLm9IkeYA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E440107ACE4;
	Tue,  9 Feb 2021 14:31:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 31EEE60C04;
	Tue,  9 Feb 2021 14:31:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EF28418095CE;
	Tue,  9 Feb 2021 14:31:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 119EV6qr029031 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 09:31:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2BE4E112C08A; Tue,  9 Feb 2021 14:31:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 267A4112C08B
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 14:31:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17772101A585
	for <dm-devel@redhat.com>; Tue,  9 Feb 2021 14:31:03 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-205-OyfKa6UsOUWgc3orum0_8w-1;
	Tue, 09 Feb 2021 09:31:01 -0500
X-MC-Unique: OyfKa6UsOUWgc3orum0_8w-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id E9F9B4031C;
	Tue,  9 Feb 2021 09:30:55 -0500 (EST)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Tue, 9 Feb 2021 15:30:50 +0100
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: <Damien.LeMoal@wdc.com>, <snitzer@redhat.com>, <hare@suse.de>,
	<ming.lei@redhat.com>, <agk@redhat.com>, <corbet@lwn.net>,
	<axboe@kernel.dk>, <jack@suse.cz>, <johannes.thumshirn@wdc.com>,
	<gregkh@linuxfoundation.org>, <koct9i@gmail.com>, <steve@sk2.org>,
	<dm-devel@redhat.com>, <linux-block@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 9 Feb 2021 17:30:23 +0300
Message-ID: <1612881028-7878-2-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1612881028-7878-1-git-send-email-sergei.shtepa@veeam.com>
References: <1612881028-7878-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx02.amust.local (172.24.0.172) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D265617465
X-Veeam-MMEX: True
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
Cc: pavel.tide@veeam.com, sergei.shtepa@veeam.com
Subject: [dm-devel] [PATCH v5 1/6] docs: device-mapper: add remap_and_filter
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

remap_and_filter - describes the new features that
blk_interposer provides for device mapper.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 .../admin-guide/device-mapper/index.rst       |   1 +
 .../device-mapper/remap_and_filter.rst        | 132 ++++++++++++++++++
 2 files changed, 133 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/remap_and_filter.rst

diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
index 6cf8adc86fa8..e868d5bbec7e 100644
--- a/Documentation/admin-guide/device-mapper/index.rst
+++ b/Documentation/admin-guide/device-mapper/index.rst
@@ -27,6 +27,7 @@ Device Mapper
     linear
     log-writes
     persistent-data
+    remap_and_filter
     snapshot
     statistics
     striped
diff --git a/Documentation/admin-guide/device-mapper/remap_and_filter.rst b/Documentation/admin-guide/device-mapper/remap_and_filter.rst
new file mode 100644
index 000000000000..b896a7de2c97
--- /dev/null
+++ b/Documentation/admin-guide/device-mapper/remap_and_filter.rst
@@ -0,0 +1,132 @@
+=================
+DM remap & filter
+=================
+
+Introduction
+============
+
+Usually LVM should be used for new devices.
+The administrator has to create logical volumes for the system partition
+when installing the operating system. For a running system with
+partitioned disk space and mounted file systems, it is quite difficult to
+reconfigure to logical volumes. As a result, all the features that Device
+Mapper provides are not available for non-LVM systems.
+This problem is partially solved by the DM remap functionality, which
+uses the kernel's blk_interposer.
+
+Blk_interposer
+==============
+
+Blk_interposer extends the capabilities of the DM, as it allows to
+intercept and redirect bio requests for block devices that are not
+DM devices. At the same time, blk_interposer allows to attach and detach
+from devices "on the fly", without stopping the execution of user
+programs.
+
+Blk_interposer allows to do two tasks: remap and filter.
+Remap allows to redirect all requests from one block device to another.
+Filter allows to do additional processing of the request, but without
+redirection. An intercepted request can get to the block device to which
+it was addressed, without changes.
+
+Remap
+=====
+
+Consider the functionality of the remap. This will allow to connect
+any block device with a DM device "on the fly".
+Suppose we have a file system mounted on the block device /dev/sda1::
+
+  +-------------+
+  | file system |
+  +-------------+
+        ||
+        \/
+  +-------------+
+  |  /dev/sda1  |
+  +-------------+
+
+Creating a new DM device that will be mapped on the same /dev/sda1::
+
+  +-------------+  +-----------+
+  | file system |  | dm-linear |
+  +-------------+  +-----------+
+           ||         ||
+           \/         \/
+         +---------------+
+         |   /dev/sda1   |
+         +---------------+
+
+Redirecting all bio requests for the /dev/sda1 device to the new DM
+device::
+
+  +-------------+
+  | file system |
+  +-------------+
+        ||
+        \/
+   +----------+    +-----------+
+   |  remap   | => | dm-linear |
+   +----------+    +-----------+
+                         ||
+                         \/
+                   +-----------+
+                   | /dev/sda1 |
+                   +-----------+
+
+To achieve this, you need to:
+
+Create new DM device with option 'noexcl'. It's allowed to open the
+underlying block-device without the FMODE_EXCL flag::
+
+  echo "0 `blockdev --getsz $1` linear $DEV 0 noexcl" | dmsetup create dm-noexcl
+
+Call remap command::
+
+  dmsetup remap start dm-noexcl $1
+
+Remap can be used to extend the functionality of dm-snap. This will allow
+to take snapshots from any block devices, not just logical volumes.
+
+Filter
+======
+
+Filter does not redirect the bio to another device. It does not create
+a clone of the bio request. After receiving the request, the filter can
+only add some processing, complete the bio request, or return the bio
+for further processing.
+
+Suppose we have a file system mounted on the block device /dev/sda1::
+
+  +-------------+
+  | file system |
+  +-------------+
+        ||
+        \/
+  +-------------+
+  |  /dev/sda1  |
+  +-------------+
+
+Creating a new DM device that will implement filter::
+
+  +-------------+
+  | file system |
+  +-------------+
+        ||
+        \/
+    +--------+    +----------+
+    | filter | => | dm-delay |
+    +--------+    +----------+
+        ||
+        \/
+  +-------------+
+  |  /dev/sda1  |
+  +-------------+
+
+Using filter we can change the behavior of debugging tools:
+ * dm-dust,
+ * dm-delay,
+ * dm-flakey,
+ * dm-verity.
+
+In the new version, they will be able to change the behavior of any
+existing block device, without creating a new one.
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

