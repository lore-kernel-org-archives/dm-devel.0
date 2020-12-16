Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A181C4361B
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:00:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8B47320578
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:00:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B47320578
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=matrixstorm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-fUgAUOswM8m37enEZDafFg-1; Wed, 16 Dec 2020 14:59:59 -0500
X-MC-Unique: fUgAUOswM8m37enEZDafFg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C86A259;
	Wed, 16 Dec 2020 19:59:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F0AD21E5;
	Wed, 16 Dec 2020 19:59:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1E90F180954D;
	Wed, 16 Dec 2020 19:59:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGJxjHw029822 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 14:59:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7A2482026D5D; Wed, 16 Dec 2020 19:59:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73E132026D76
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 19:59:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4360C8007D9
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 19:59:43 +0000 (UTC)
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de
	[81.169.146.221]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-437-83he0w11OsCXJfXVnhjf0Q-1; Wed, 16 Dec 2020 14:59:40 -0500
X-MC-Unique: 83he0w11OsCXJfXVnhjf0Q-1
X-RZG-AUTH: ":P3gBZUipdd99EFhDYOISZA2ym5zGOgAd5ykVVQQWw7fG5QErre8LbX52SwnSyIMB1hwG7x8pm1U="
X-RZG-CLASS-ID: mo00
Received: from [172.24.6.159] by smtp.strato.de (RZmta 47.9.1 DYNA|AUTH)
	with ESMTPSA id z076b7wBGJrc0Da
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate) for <dm-devel@redhat.com>;
	Wed, 16 Dec 2020 20:53:38 +0100 (CET)
From: =?UTF-8?Q?Stephan_B=c3=a4rwolf?= <stephan@matrixstorm.com>
To: dm-devel@redhat.com
Message-ID: <fddbff8b-a7b5-ec89-9e60-d0b35940d117@matrixstorm.com>
Date: Wed, 16 Dec 2020 20:53:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.3.1
MIME-Version: 1.0
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
Subject: [dm-devel] [PATCH] dm-raid: set discard_granularity non-zero if
	possible
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="------------81761FAEFC9D3EF1DBF7A602"
Content-Language: de-CH

This is a multi-part message in MIME format.
--------------81761FAEFC9D3EF1DBF7A602
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi

I hope this address is the right place for this patch.
It is supposed to fix the triggering of block/blklib.c:51 WARN_ON_ONCE(..) when using LVM2 raid1 with SSD-PVs.
Since commit b35fd7422c2f8e04496f5a770bd4e1a205414b3f and without this patchthere are tons of printks logging "Error: discard_granularity is 0." to kmsg.
Also there is no discard/TRIM happening anymore...

This is a rough patch for WARNING-issue

"block/blk-lib.c:51 __blkdev_issue_discard+0x1f6/0x250"
[...] "Error: discard_granularity is 0." [...]
introduced in commit b35fd7422c2f8e04496f5a770bd4e1a205414b3f
("block: check queue's limits.discard_granularity in __blkdev_issue_discard()")

in conjunction with LVM2 raid1 volumes on discardable (SSD) backing.
It seems until now, LVM-raid1 reported "discard_granularity" as 0,
as well as "max_discard_sectors" as 0. (see "lsblk --discard").

The idea here is to fix the issue by calculating "max_discard_sectors"
as the minimum over all involved block devices. (We use the meta-data
for this to work here.)
For calculating the "discard_granularity" we would have to calculate the
lcm (least common multiple) of all discard_granularities of all involved
block devices and finally round up to next power of 2.

However, since all "discard_granularity" are powers of 2, this algorithm
will simplify to just determining the maximum and filtering for "0"-cases.

Signed-off-by: Stephan Baerwolf <stephan@matrixstorm.com>
---
drivers/md/dm-raid.c | 32 ++++++++++++++++++++++++++++++--
1 file changed, 30 insertions(+), 2 deletions(-)




--------------81761FAEFC9D3EF1DBF7A602
Content-Type: text/x-patch; charset=UTF-8;
	name="0001-dm-raid-set-discard_granularity-non-zero-if-possible.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-dm-raid-set-discard_granularity-non-zero-if-possible.pa";
	filename*1="tch"

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8d2b835d7a10..4c769fd93ced 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3734,8 +3734,36 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 * RAID0/4/5/6 don't and process large discard bios properly.
 	 */
 	if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
-		limits->discard_granularity = chunk_size_bytes;
-		limits->max_discard_sectors = rs->md.chunk_sectors;
+        /* HACK */
+        if (chunk_size_bytes==0) {
+            unsigned int i, chunk_sectors=(UINT_MAX >>  SECTOR_SHIFT);
+            struct request_queue *q = NULL;
+
+            DMINFO("chunk_size is 0 for raid1 - preventing issue with TRIM");
+
+            for (i=0;i<rs->raid_disks;i++) {
+                q=bdev_get_queue(rs->dev[i].meta_dev->bdev);
+                if (chunk_sectors >  q->limits.max_discard_sectors) {
+                    chunk_sectors = q->limits.max_discard_sectors;
+                }
+                if (chunk_size_bytes < q->limits.discard_granularity) {
+                    chunk_size_bytes = q->limits.discard_granularity;
+                }
+
+                /* lcm(x,y,...,0) = 0 */
+                if (q->limits.discard_granularity == 0) {
+                    chunk_size_bytes = 0;
+                    break;
+                }
+            }
+
+            limits->discard_granularity = chunk_size_bytes;
+            limits->max_discard_sectors = chunk_sectors;
+        /* end of HACK (but not of if) */
+        } else {
+            limits->discard_granularity = chunk_size_bytes;
+            limits->max_discard_sectors = rs->md.chunk_sectors;
+        }
 	}
 }
 


--------------81761FAEFC9D3EF1DBF7A602
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--------------81761FAEFC9D3EF1DBF7A602--

