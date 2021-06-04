Return-Path: <SRS0=uf5V=K6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C1FC4708F
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 06:25:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C9A0961405
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 06:25:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9A0961405
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=opensource.wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-5xMM50GbOiWurRzz56waRw-1; Fri, 04 Jun 2021 02:25:25 -0400
X-MC-Unique: 5xMM50GbOiWurRzz56waRw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBABD801B14;
	Fri,  4 Jun 2021 06:25:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CDFA81B428;
	Fri,  4 Jun 2021 06:25:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 98F871800FFC;
	Fri,  4 Jun 2021 06:25:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1540mL0l025082 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Jun 2021 20:48:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DB72B1175403; Fri,  4 Jun 2021 00:48:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D681C1175402
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 00:48:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 190CF101D220
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 00:48:17 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-532-7Nk4XhuuPhOvAnhqLg1Tkg-1; Thu, 03 Jun 2021 20:48:13 -0400
X-MC-Unique: 7Nk4XhuuPhOvAnhqLg1Tkg-1
IronPort-SDR: PuM1gRionuN75v8OpjuCPeYhka8SHJ21wGXLggJKfNmRnfYDPnsllkTXv7NykIJmG9/pUlFRO8
	/H0QalzFoxykwmLCbjW6z6sjdZU9fag5mCdUQm4oiIhPvmQSBU1kDk3D7/WS0WSuYIVf9H0sVF
	5kwz8xAA2nLT8YHPekUTXpY1I/Q4rHK5NUInpw76hr9odlqMq0Jpttwu+WHY2yNLsIBYSeI1kL
	n8an7umVuW84IDfL+xUptSA5YVmLyFmKyGFzaggeTjtAq4bqsrqa1yzREdwCwopjJA5QeepHLy
	YcY=
X-IronPort-AV: E=Sophos;i="5.83,246,1616428800"; d="scan'208";a="282065032"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 04 Jun 2021 08:47:06 +0800
IronPort-SDR: 8JkYOiN9C9GiWo+8oUF10RLrix4VzZubUtW1uS54iy1Tbv979dal1ThQrub92VnBS/l++262i9
	sfEM7VRFIeTBhMPXDcgSe8Rk8pOO0sk8acNzuNb58isNOolF2HE90FLI5+O0V/HKCEPUKe0bPl
	jVwzvROUGe3dyVI4nieew1mGCAmEPlVm9uFeslVqXzEYVB7WiealvVGwCY3EptRRSKz7lZHMBa
	WFV1R65MJf62pe9KZ5cH2ZylW//os7jBtAUqR3Cjwjw2afgT/PDMJlzMWGlm4dzVa/HuGWMV8c
	Cx6zWTGXu7nM0D+2eMb4idhQ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	03 Jun 2021 17:24:52 -0700
IronPort-SDR: XyVEy4Q684E+VflC8ajmbbHy+6U5xywaewdtRiAaKQsrLQYB4UULUemDzcpL/U7L45GoKtUbMW
	QJZpQIi/JB7Z/y6BopRf1tlpR7VFbTYChnfqgSBuqOXq2ng/oWGTDJ8JlQLh3tj/9jrZ3SfwAN
	pnloigY1DXMkgkF4TeUbhVgaRFruh6tnKWiN+X7hVzg5hxHArRLV4lQsCNwQ5f8f6elMaX2NMe
	5ceqvib1zm26Y5xlnnefg0R+HpOweSqMMiPSTwWu/jnpIEt+YXflxsHD4jfJeXTedA9uffWQ0M
	zwE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
	by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	03 Jun 2021 17:47:07 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Fx3xk0vWsz1RwqT
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 17:47:06 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	(amavisd-new, port 10026)
	with ESMTP id rqVuBZK8G_rx for <dm-devel@redhat.com>;
	Thu,  3 Jun 2021 17:47:05 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com
	[10.149.53.254])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Fx3xh688xz1RwqQ;
	Thu,  3 Jun 2021 17:47:04 -0700 (PDT)
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Date: Fri,  4 Jun 2021 09:47:03 +0900
Message-Id: <20210604004703.408562-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1540mL0l025082
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Jun 2021 02:21:36 -0400
Subject: [dm-devel] [PATCH] dm: fix uninitialized variable use
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

From: Damien Le Moal <damien.lemoal@wdc.com>

In dm_io_dec_pending(), make sure that the bio variable is initialized
to io->orig_bio before using it.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 3a1e343c53ae ("dm: Forbid requeue of writes to zones")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a89bb9bbe82d..e687d60212b6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -796,6 +796,7 @@ void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 	}
 
 	if (atomic_dec_and_test(&io->io_count)) {
+		bio = io->orig_bio;
 		if (io->status == BLK_STS_DM_REQUEUE) {
 			/*
 			 * Target requested pushing back the I/O.
@@ -804,7 +805,7 @@ void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 			if (__noflush_suspending(md) &&
 			    !WARN_ON_ONCE(dm_is_zone_write(md, bio)))
 				/* NOTE early return due to BLK_STS_DM_REQUEUE below */
-				bio_list_add_head(&md->deferred, io->orig_bio);
+				bio_list_add_head(&md->deferred, bio);
 			else
 				/*
 				 * noflush suspend was interrupted or this is
@@ -815,7 +816,6 @@ void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 		}
 
 		io_error = io->status;
-		bio = io->orig_bio;
 		end_io_acct(io);
 		free_io(md, io);
 
-- 
2.31.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

