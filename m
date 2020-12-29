Return-Path: <SRS0=56Wl=GB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 802C0C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 29 Dec 2020 09:28:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DB67F207D1
	for <dm-devel@archiver.kernel.org>; Tue, 29 Dec 2020 09:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB67F207D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=synology.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-D6bB5r7BOEKEVVv9wyM7Uw-1; Tue, 29 Dec 2020 04:28:50 -0500
X-MC-Unique: D6bB5r7BOEKEVVv9wyM7Uw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A760107ACF5;
	Tue, 29 Dec 2020 09:28:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04DED10013C1;
	Tue, 29 Dec 2020 09:28:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 49E764A7C7;
	Tue, 29 Dec 2020 09:28:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BT9SbBV013082 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Dec 2020 04:28:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 83A04111286E; Tue, 29 Dec 2020 09:28:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FDA5111286F
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 09:28:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22C90858285
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 09:28:35 +0000 (UTC)
Received: from synology.com (mail.synology.com [211.23.38.101]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-406-x-Lq11oKNcSZxLDUgQ_QvQ-1;
	Tue, 29 Dec 2020 04:28:31 -0500
X-MC-Unique: x-Lq11oKNcSZxLDUgQ_QvQ-1
Received: from localhost.localdomain (unknown [10.17.198.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by synology.com (Postfix) with ESMTPSA id 553B1CE781AC;
	Tue, 29 Dec 2020 17:21:11 +0800 (CST)
From: dannyshih <dannyshih@synology.com>
To: axboe@kernel.dk
Date: Tue, 29 Dec 2020 17:18:42 +0800
Message-Id: <1609233522-25837-5-git-send-email-dannyshih@synology.com>
In-Reply-To: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
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
Cc: linux-raid@vger.kernel.org, snitzer@redhat.com, linux-block@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com,
	Danny Shih <dannyshih@synology.com>, agk@redhat.com
Subject: [dm-devel] [PATCH 4/4] md: use submit_bio_noacct_add_head for split
	bio sending back
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Danny Shih <dannyshih@synology.com>

Use submit_bio_noacct_add_head when sending split bio back to md device.
Otherwise, it might be handled after the lately split bio.

Signed-off-by: Danny Shih <dannyshih@synology.com>
Reviewed-by: Allen Peng <allenpeng@synology.com>
Reviewed-by: Alex Wu <alexwu@synology.com>
---
 drivers/md/md-linear.c | 2 +-
 drivers/md/raid0.c     | 4 ++--
 drivers/md/raid1.c     | 4 ++--
 drivers/md/raid10.c    | 4 ++--
 drivers/md/raid5.c     | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 68cac7d..24418ee 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -243,7 +243,7 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 		struct bio *split = bio_split(bio, end_sector - bio_sector,
 					      GFP_NOIO, &mddev->bio_set);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		bio = split;
 	}
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 67f157f..92e82d5 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -447,7 +447,7 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
 			&mddev->bio_set);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		bio = split;
 		end = zone->zone_end;
 	} else
@@ -552,7 +552,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
 					      &mddev->bio_set);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		bio = split;
 	}
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c034799..31cec76 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1282,7 +1282,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		bio = split;
 		r1_bio->master_bio = bio;
 		r1_bio->sectors = max_sectors;
@@ -1453,7 +1453,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		struct bio *split = bio_split(bio, max_sectors,
 					      GFP_NOIO, &conf->bio_split);
 		bio_chain(split, bio);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		bio = split;
 		r1_bio->master_bio = bio;
 		r1_bio->sectors = max_sectors;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c5d88ef..c4dc970 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1177,7 +1177,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 					      gfp, &conf->bio_split);
 		bio_chain(split, bio);
 		allow_barrier(conf);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		wait_barrier(conf);
 		bio = split;
 		r10_bio->master_bio = bio;
@@ -1460,7 +1460,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 					      GFP_NOIO, &conf->bio_split);
 		bio_chain(split, bio);
 		allow_barrier(conf);
-		submit_bio_noacct(bio);
+		submit_bio_noacct_add_head(bio);
 		wait_barrier(conf);
 		bio = split;
 		r10_bio->master_bio = bio;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3a90cc0..17458ac 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5490,7 +5490,7 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 		struct r5conf *conf = mddev->private;
 		split = bio_split(raid_bio, sectors, GFP_NOIO, &conf->bio_split);
 		bio_chain(split, raid_bio);
-		submit_bio_noacct(raid_bio);
+		submit_bio_noacct_add_head(raid_bio);
 		raid_bio = split;
 	}
 
-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

