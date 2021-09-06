Return-Path: <SRS0=WplP=N4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70DEC433F5
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 08:15:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4FC6361039
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 08:15:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4FC6361039
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-iAtbeqfeNQK0p9w42NSnTw-1; Mon, 06 Sep 2021 04:14:53 -0400
X-MC-Unique: iAtbeqfeNQK0p9w42NSnTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FBBE107ACE8;
	Mon,  6 Sep 2021 08:14:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7266260CA0;
	Mon,  6 Sep 2021 08:14:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 475B9180B52A;
	Mon,  6 Sep 2021 08:14:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1864HDLw018413 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 6 Sep 2021 00:17:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7CCCA568ED; Mon,  6 Sep 2021 04:17:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76CCB568F0
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 04:17:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF31F8556F0
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 04:17:09 +0000 (UTC)
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155]) by
	relay.mimecast.com with ESMTP id us-mta-261-QeMjgXMFMy2jCCoKNposjA-1;
	Mon, 06 Sep 2021 00:17:06 -0400
X-MC-Unique: QeMjgXMFMy2jCCoKNposjA-1
Received: from localhost.localdomain (unknown [10.214.16.253])
	by mail-app4 (Coremail) with SMTP id cS_KCgBHTys5ljVhEVO2Ag--.60760S4; 
	Mon, 06 Sep 2021 12:17:01 +0800 (CST)
From: Dinghao Liu <dinghao.liu@zju.edu.cn>
To: dinghao.liu@zju.edu.cn, kjlu@umn.edu
Date: Mon,  6 Sep 2021 12:16:16 +0800
Message-Id: <20210906041616.22812-1-dinghao.liu@zju.edu.cn>
X-CM-TRANSID: cS_KCgBHTys5ljVhEVO2Ag--.60760S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJrWfuFyUZFy8tFy3Aw1UZFb_yoW8WF47pr
	48GasxCr48t39FqFWDGw4kK345Kwn0gryqyrs7CayrZa1YgF43ur18GrWUXFWUGFy7Ga4U
	AF1UAr4DWay0k3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUk21xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2
	jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
	x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
	GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
	6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
	C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48J
	MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
	IF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
	87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgQABlZdtVpWtAAAsG
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
X-Mailman-Approved-At: Mon, 06 Sep 2021 04:14:38 -0400
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] [v2] dm raid: fix mddev unlocking in raid_ctr()
	error paths
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

mddev_unlock() is called on all paths after we call mddev_lock_nointr(),
except for three error handling paths, which may cause a deadlock.

Fixes: 9dbd1aa3a81c ("dm raid: add reshaping support to the target")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---

Changelog:

v2: - Simplify the error handling paths.
---
 drivers/md/dm-raid.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index d9ef52159a22..741bab00e922 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3249,14 +3249,12 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	rs->md.in_sync = 0; /* Assume already marked dirty */
 	if (r) {
 		ti->error = "Failed to run raid array";
-		mddev_unlock(&rs->md);
-		goto bad;
+		goto bad_unlock;
 	}
 
 	r = md_start(&rs->md);
 	if (r) {
 		ti->error = "Failed to start raid array";
-		mddev_unlock(&rs->md);
 		goto bad_md_start;
 	}
 
@@ -3265,7 +3263,6 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		r = r5c_journal_mode_set(&rs->md, rs->journal_dev.mode);
 		if (r) {
 			ti->error = "Failed to set raid4/5/6 journal mode";
-			mddev_unlock(&rs->md);
 			goto bad_journal_mode_set;
 		}
 	}
@@ -3304,10 +3301,12 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	mddev_unlock(&rs->md);
 	return 0;
 
+bad_unlock:
 bad_md_start:
 bad_journal_mode_set:
 bad_stripe_cache:
 bad_check_reshape:
+	mddev_unlock(&rs->md);
 	md_stop(&rs->md);
 bad:
 	raid_set_free(rs);
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

