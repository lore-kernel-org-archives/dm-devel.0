Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AACC433ED
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 02:58:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 29DF46124C
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 02:58:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29DF46124C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-4ZER49DdPF6yKVkqWvzJyg-1; Tue, 18 May 2021 22:58:36 -0400
X-MC-Unique: 4ZER49DdPF6yKVkqWvzJyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 563A2501F7;
	Wed, 19 May 2021 02:58:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 34C442ED60;
	Wed, 19 May 2021 02:58:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0CED5180B463;
	Wed, 19 May 2021 02:58:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J2tePL029477 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 May 2021 22:55:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D5C8121D0DB1; Wed, 19 May 2021 02:55:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CFFF021D0DAF
	for <dm-devel@redhat.com>; Wed, 19 May 2021 02:55:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54AE280D0E0
	for <dm-devel@redhat.com>; Wed, 19 May 2021 02:55:39 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-283-59owYwDdMjCwgwTWZDBcDQ-1; Tue, 18 May 2021 22:55:37 -0400
X-MC-Unique: 59owYwDdMjCwgwTWZDBcDQ-1
IronPort-SDR: SVWP8+oJk14ouMVk6vY2C537ZEuAyDBqCUVZLcKu0q9k0r7k6x3ZJDJaOFAxDMQ4LB9DwKo0QK
	gmNxtMclWADUqhXkHwa3/Kwxh8qk4ozVPhq3seTlst5asMWmgI9mA/SzXrpJmdc38Td7Yz7WLa
	paQh77NVjfr54Tlhj+0Ze7oDsrorNjAxrIKyyYbXID+wXyMg65jjKs5CEnP0MOuwb4K0WHT6vM
	/tmv2DPnjbF/C8UH3tiGZCoOixtZjUcSdXQvIxY5VcjJTPjuRIIWSQ8/y177SmJAgW1pEE9fJB
	6kA=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; d="scan'208";a="169197431"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 10:55:37 +0800
IronPort-SDR: m/VABTDR/OC87gsty9kjxIFVy7cMDz6XgQnAw17bMcwZKfRWu23sN7bQmkVgxrWs/Ldb48fSOv
	xh29d+iSPfr2j8Ra4EhfPq3rvBMCRPSrOHBYsJO2F2B0S/IW6I+lf3fOumgzsxUjZeMCR01z/r
	b1bo8X6MR2HY4FtRUkpeHGMo1VC0sg9noKbVZCJl9iGQMJFGdwrTgwl22GKZwxVJNJTjObVtUv
	R+PHIx1lFfsR74sgYgJnC/eUSKLEXhuDcHV4hH/fL/bYiyyJiywzAqIgg+61IV/HkUO/JheVxX
	pWNWqpYnrXwq9VVoFy63y9sL
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 May 2021 19:34:01 -0700
IronPort-SDR: cn9S+bH2vAN57lDXfGpWNGHaFTa/lMAMBGpy+k9iIXRCR04fLCAkSLAShfC5hohyVGXEguITG/
	GO4zfe4hRxkA3lMiiPPA699VG9pjN1dNP+amZ7VC5ohQMVWifka2UzbujOEC3cuLlvYrXhhrZv
	VC0oRhzfYZA2l8yfI3NmivNrk8Jtkyxn7GdWRC+WSsOCNojGZcIixiC/In4e2G/LDhMNOnu5Uc
	ZTe6KrE9pqjvFotycJ57CJLkv1wdeLFO9X9KfNcqbQvmoo5xKqSCF8vZ8rHpFcvA3+wTbUY/Ix
	GLQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 May 2021 19:55:35 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 19 May 2021 11:55:23 +0900
Message-Id: <20210519025529.707897-6-damien.lemoal@wdc.com>
In-Reply-To: <20210519025529.707897-1-damien.lemoal@wdc.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH 05/11] dm: cleanup device_area_is_invalid()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In device_area_is_invalid(), use bdev_is_zoned() instead of open
coding the test on the zoned model returned by bdev_zoned_model().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ee47a332b462..21fd9cd4da32 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -249,7 +249,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	 * If the target is mapped to zoned block device(s), check
 	 * that the zones are not partially mapped.
 	 */
-	if (bdev_zoned_model(bdev) != BLK_ZONED_NONE) {
+	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
 		if (start & (zone_sectors - 1)) {
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

