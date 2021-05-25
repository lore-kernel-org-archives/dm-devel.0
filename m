Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67D9C47087
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 419C16141C
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 419C16141C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-eD5HBmybObWYGUAiPMssBg-1; Tue, 25 May 2021 17:25:41 -0400
X-MC-Unique: eD5HBmybObWYGUAiPMssBg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99EBA64159;
	Tue, 25 May 2021 21:25:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C66E5C1D5;
	Tue, 25 May 2021 21:25:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 49B111804480;
	Tue, 25 May 2021 21:25:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PLPGFA003324 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 17:25:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C2484200FA7C; Tue, 25 May 2021 21:25:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE59E2021456
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AF94833969
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:16 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-140-s-M1-z1-M82F7uDZtTY2uQ-3; Tue, 25 May 2021 17:25:10 -0400
X-MC-Unique: s-M1-z1-M82F7uDZtTY2uQ-3
IronPort-SDR: qRB+1IcHNJoEv5yS3Khk9YH25zII6GOXSbBj+KC0IrysV74765VvG5Safw7Ss6q+ehZAYXovqo
	HA+BOrXf1/Uub7lYJ+5q9FMzvRYkLOee4+YOOSLyui8l3EnvuC1UjnnhnwDvCt8sWRewuFRK6/
	NJTyDgdntTGP5IQug05M4t5/ijvCXg0UQ+Q73qiqpoDkhDTg/XQDbnKU+JucCY9dZpaKN7thdS
	2/Kg04NIr61RWAOrC8TpoAtf9KhBSptNMRUmcB2A2chGV5Hz8OHuylKpwMvHaytV4j4aNItHIq
	EAU=
X-IronPort-AV: E=Sophos;i="5.82,329,1613404800"; d="scan'208";a="168717524"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 26 May 2021 05:25:10 +0800
IronPort-SDR: KVhC/jAa0O3iVsRsmN8KQH2smCGJvlx8Nl1Nb6iT7Koq9OUiAM3N7WHGZUvuZwxWnQpaXOSwVg
	7aslZ3svc8bvth0Ka18HbiMrxHd5jqOc19EBNK8xYE/mSO9oi9jrF7HuZn3I1z7d9lcahrJGYy
	qXnaNChvr5c1VmXzH/SEn79Ufc8Cl0HamYIsn233HqCTqEa+WG5+tvkCoJvnWN51NWqMyp7gXh
	expvwucFoAzRr/sdbFmMPzbr7t7IVR3dowhdQ0olOySQ6eGQyeW7D7oWfZaWZ+JCEwg1X1BEw2
	GgJs+aXtBejpFAR4bCKXjaXS
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	25 May 2021 14:03:20 -0700
IronPort-SDR: 9MGmzkS4eqpzox3GSh+m6FwTZ2A8jKGfs3LK10mBr04kxWvv+f5pPf+dITjf+/Rgr/JwS4Y91l
	/qfqaRsYRFK/hntKveHxn9+PNamC60e0DQFaBnC4AJvxCnCVJHvk0rc8K0JrNNogBqlGlaDdse
	vjnA+wsKHtk2X2cyt7se75j0b6h2J4rz05kaMfbrCaBoDnKg6KD59UIK963ti52Y3PY0qjkPRn
	uSvw1Sx6Yg/+cwXjPx1w8baliE444Y83EBleDFznQqcptUe+kG38/AEBTdCAjatLi0Q6g7Jc1o
	f3Y=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip01.wdc.com with ESMTP; 25 May 2021 14:25:10 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 26 May 2021 06:24:55 +0900
Message-Id: <20210525212501.226888-6-damien.lemoal@wdc.com>
In-Reply-To: <20210525212501.226888-1-damien.lemoal@wdc.com>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
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
Subject: [dm-devel] [PATCH v5 05/11] dm: cleanup device_area_is_invalid()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In device_area_is_invalid(), use bdev_is_zoned() instead of open
coding the test on the zoned model returned by bdev_zoned_model().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

