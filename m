Return-Path: <SRS0=KYOW=J2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9726CC433B4
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 21:37:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EFC9161445
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 21:37:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFC9161445
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-EFiJtl2FNvaCuOjL_6gPKg-1; Thu, 29 Apr 2021 17:37:29 -0400
X-MC-Unique: EFiJtl2FNvaCuOjL_6gPKg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41A97501E8;
	Thu, 29 Apr 2021 21:37:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B200F5D9C6;
	Thu, 29 Apr 2021 21:37:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E73BB1809C82;
	Thu, 29 Apr 2021 21:37:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13TLbH0U015401 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Apr 2021 17:37:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0538420B6654; Thu, 29 Apr 2021 21:37:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3CA020B6652
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 21:37:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CACD104F0A1
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 21:37:11 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-339-P_GFD8NCOPmf4NyUkTdghA-1; Thu, 29 Apr 2021 17:37:08 -0400
X-MC-Unique: P_GFD8NCOPmf4NyUkTdghA-1
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	13TLY6tO065313; Thu, 29 Apr 2021 17:37:08 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3883txsfkc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 29 Apr 2021 17:37:08 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13TLZK0m071351;
	Thu, 29 Apr 2021 17:37:07 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com
	[159.122.73.71])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3883txsfk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 29 Apr 2021 17:37:07 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id
	13TLb57F003449; Thu, 29 Apr 2021 21:37:05 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com
	(d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma02fra.de.ibm.com with ESMTP id 384ay89faf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 29 Apr 2021 21:37:05 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com
	(b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 13TLb1Bu27722106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Thu, 29 Apr 2021 21:37:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E6AEA405B;
	Thu, 29 Apr 2021 21:37:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A1E4A4054;
	Thu, 29 Apr 2021 21:37:01 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.10.4])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
	Thu, 29 Apr 2021 21:37:01 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
	(envelope-from <bblock@linux.ibm.com>)
	id 1lcELE-005V7O-TZ; Thu, 29 Apr 2021 23:37:00 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Date: Thu, 29 Apr 2021 23:37:00 +0200
Message-Id: <0427141cadc833d4cdf32cc5a22025c90b278a09.1619720034.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH,
	Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp,
	Sitz der Gesellschaft Boeblingen,
	Registergericht AmtsG Stuttgart, HRB 243294
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VzH3P8uHmWl61HfWjbJ3mCfl4YbJQYuC
X-Proofpoint-ORIG-GUID: 7laSnNPm1sUdj5j7o4edwVZIKMEDfSTU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.761
	definitions=2021-04-29_11:2021-04-28,
	2021-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	mlxscore=0 lowpriorityscore=0
	phishscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
	suspectscore=0
	bulkscore=0 priorityscore=1501 clxscore=1011 spamscore=0 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104290137
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
Cc: Steffen Maier <maier@linux.ibm.com>, Benjamin Block <bblock@linux.ibm.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [RFC PATCH] dm-rq: fix double free of blk tag set in dev
	remove after table load fails
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When loading a device-mapper table for a request-based mapped device,
and the allocation/initialization of the blk-mq tag set for the device
fails, a following device remove will cause a double free.

E.g. (dmesg):
  device-mapper: core: Cannot initialize queue for request-based dm-mq mapped device
  device-mapper: ioctl: unable to set up device queue for new table.
  Unable to handle kernel pointer dereference in virtual kernel address space
  Failing address: 0305e098835de000 TEID: 0305e098835de803
  Fault in home space mode while using kernel ASCE.
  AS:000000025efe0007 R3:0000000000000024
  Oops: 0038 ilc:3 [#1] SMP
  Modules linked in: ... lots of modules ...
  Supported: Yes, External
  CPU: 0 PID: 7348 Comm: multipathd Kdump: loaded Tainted: G        W      X    5.3.18-53-default #1 SLE15-SP3
  Hardware name: IBM 8561 T01 7I2 (LPAR)
  Krnl PSW : 0704e00180000000 000000025e368eca (kfree+0x42/0x330)
             R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
  Krnl GPRS: 000000000000004a 000000025efe5230 c1773200d779968d 0000000000000000
             000000025e520270 000000025e8d1b40 0000000000000003 00000007aae10000
             000000025e5202a2 0000000000000001 c1773200d779968d 0305e098835de640
             00000007a8170000 000003ff80138650 000000025e5202a2 000003e00396faa8
  Krnl Code: 000000025e368eb8: c4180041e100       lgrl    %r1,25eba50b8
             000000025e368ebe: ecba06b93a55       risbg   %r11,%r10,6,185,58
            #000000025e368ec4: e3b010000008       ag      %r11,0(%r1)
            >000000025e368eca: e310b0080004       lg      %r1,8(%r11)
             000000025e368ed0: a7110001           tmll    %r1,1
             000000025e368ed4: a7740129           brc     7,25e369126
             000000025e368ed8: e320b0080004       lg      %r2,8(%r11)
             000000025e368ede: b904001b           lgr     %r1,%r11
  Call Trace:
   [<000000025e368eca>] kfree+0x42/0x330
   [<000000025e5202a2>] blk_mq_free_tag_set+0x72/0xb8
   [<000003ff801316a8>] dm_mq_cleanup_mapped_device+0x38/0x50 [dm_mod]
   [<000003ff80120082>] free_dev+0x52/0xd0 [dm_mod]
   [<000003ff801233f0>] __dm_destroy+0x150/0x1d0 [dm_mod]
   [<000003ff8012bb9a>] dev_remove+0x162/0x1c0 [dm_mod]
   [<000003ff8012a988>] ctl_ioctl+0x198/0x478 [dm_mod]
   [<000003ff8012ac8a>] dm_ctl_ioctl+0x22/0x38 [dm_mod]
   [<000000025e3b11ee>] ksys_ioctl+0xbe/0xe0
   [<000000025e3b127a>] __s390x_sys_ioctl+0x2a/0x40
   [<000000025e8c15ac>] system_call+0xd8/0x2c8
  Last Breaking-Event-Address:
   [<000000025e52029c>] blk_mq_free_tag_set+0x6c/0xb8
  Kernel panic - not syncing: Fatal exception: panic_on_oops

When allocation/initialization of the blk-mq tag set fails in
`dm_mq_init_request_queue()`, it is uninitialized/freed, but the pointer
is not reset to NULL; so when `dev_remove()` later gets into
`dm_mq_cleanup_mapped_device()` it sees the pointer and tries to
uninitialized and free it again.

Fix this by also setting the pointer to NULL in
`dm_mq_init_request_queue()` after error-handling.

Cc: <stable@vger.kernel.org> # 4.6+
Fixes: 1c357a1e86a4 ("dm: allocate blk_mq_tag_set rather than embed in mapped_device")
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/md/dm-rq.c | 1 +
 1 file changed, 1 insertion(+)

Hey,

I got this report from internal testing for a distribution kernel (you
see the version information in the dmesg output), but I checked the code
for 5.12, and it looks like nothing has change really, and the same
crash would happen there as well under the same circumstances.

I'm not sure why exactly the tag set allocation/initialization failed..
like you see in the dmesg output, the stack of `table_load()` already
unwound and the IOCTL returned, so I can't check the error-code or the
tag set state. But the crash seems obvious enough to me.

I wrote a small inject to test this with 5.12, because I didn't know how
to trigger this otherwise. It just jumps to `out_tag_set` in
`dm_mq_init_request_queue()` after the tag set is allocated, but
before `blk_mq_init_allocated_queue()` could run.

Here the kernel with inject and patch applied:

  ...
  [   52.291458] sd 0:0:0:1075265560: alua: port group 00 state A preferred supports tolusnA
  [   52.291815] sd 0:0:0:1075265560: alua: port group 00 state A preferred supports tolusnA
  [  158.242153] device-mapper: core: Cannot initialize queue for request-based dm mapped device
  [  158.242233] device-mapper: ioctl: unable to set up device queue for new table.
  [  158.761525] sd 0:0:0:1075134488: alua: port group 00 state A preferred supports tolusnA
  [  158.761839] sd 0:0:0:1075134488: alua: port group 00 state A preferred supports tolusnA
  ...

>From multipath (the userspace tool) perspective, it looks like this:

  Apr 29 23:13:03 | ds8k31_err_40184014_npiv: addmap [0 20971520 multipath 1 queue_if_no_path 1 alua 1 1 service-time 0 2 1 8:0 1 8:64 1]
  Apr 29 23:13:03 | libdevmapper: ioctl/libdm-iface.c(1923): device-mapper: reload ioctl on ds8k31_err_40184014_npiv  failed: Cannot allocate memory
  Apr 29 23:13:03 | dm_addmap: libdm task=0 error: Success
  Apr 29 23:13:03 | ds8k31_err_40184014_npiv: ignoring map
  Apr 29 23:13:03 | ds8k31_err_40184015_npiv: addmap [0 20971520 multipath 1 queue_if_no_path 1 alua 1 1 service-time 0 2 1 8:16 1 8:80 1]
  create: ds8k31_err_40184015_npiv (36005076309ffd4300000000000001815) undef IBM,2107900
  size=10G features='1 queue_if_no_path' hwhandler='1 alua' wp=undef
  `-+- policy='service-time 0' prio=50 status=undef
    |- 0:0:0:1075134488 sdb 8:16  undef ready running
    `- 1:0:1:1075134488 sdf 8:80  undef ready running
  ...

Recreating the exact same crash as in the report without the patch (but
with inject) is actually not all that easy on s390x; the double free
doesn't necessarily end up touching unmapped memory, and the crashes I
got where all over the place.. so its actually quite lucky I got this
clear report.

I don't really know the device-mapper code by heart, so thats why I
marked it as RFC.


 - Benjamin

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 13b4385f4d5a..4583c5d6885f 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -569,6 +569,7 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
 	blk_mq_free_tag_set(md->tag_set);
 out_kfree_tag_set:
 	kfree(md->tag_set);
+	md->tag_set = NULL;
 
 	return err;
 }
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

