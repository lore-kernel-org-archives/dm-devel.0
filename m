Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC84C43217
	for <dm-devel@archiver.kernel.org>; Tue, 29 Nov 2022 02:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669688900;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Mrvo6lNFnK06jX5D15kwwS+2nZVi/QsIv3zPuF2vetw=;
	b=CnHBj0b42vEL+KWHyvDywaDbrjNOy9wFacW1XGtzdu7Y2skGdYt4V4OpO4ty8GF48BmpDN
	yr6BDKI8RAMzX9ohwfTS+samDPxmrTTpx7RTCWOWlUjfVSD09INnQh/gWfiKLmIpBEKVlI
	Y/RjjawWq6HLOLLVc94fbkdjNWX3mco=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-3boOF-ZrNwiEF9NDu0jpMA-1; Mon, 28 Nov 2022 21:28:17 -0500
X-MC-Unique: 3boOF-ZrNwiEF9NDu0jpMA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78C4F3C021A0;
	Tue, 29 Nov 2022 02:28:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5919F1415100;
	Tue, 29 Nov 2022 02:28:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1EEEA19465BA;
	Tue, 29 Nov 2022 02:28:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0CDD61946594
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Nov 2022 02:28:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D9FFB4B4011; Tue, 29 Nov 2022 02:28:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D26274B400F
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 02:28:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B81D93C02583
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 02:28:12 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-348-MDmULDJKOGGdbaiVAYOrsA-1; Mon, 28 Nov 2022 21:28:08 -0500
X-MC-Unique: MDmULDJKOGGdbaiVAYOrsA-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NLmTV6cMwz4f3jLk;
 Tue, 29 Nov 2022 10:27:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP1 (Coremail) with SMTP id cCh0CgBHPaweboVjlJ0JBQ--.11870S6;
 Tue, 29 Nov 2022 10:28:02 +0800 (CST)
From: Luo Meng <luomeng12@huawei.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, ejt@redhat.com
Date: Tue, 29 Nov 2022 10:48:48 +0800
Message-Id: <20221129024850.1842973-3-luomeng12@huawei.com>
In-Reply-To: <20221129024850.1842973-1-luomeng12@huawei.com>
References: <20221129024850.1842973-1-luomeng12@huawei.com>
MIME-Version: 1.0
X-CM-TRANSID: cCh0CgBHPaweboVjlJ0JBQ--.11870S6
X-Coremail-Antispam: 1UD129KBjvdXoW7JrWxtr4rWFyxCw1kCr1kGrg_yoWfGrb_Ca
 45Xay7KFWUWw1S93Wayr4fZr4jya40qr1IyF1FqayakrWqqFn3ur1rtFyDAw1UAr1fC3Wq
 yFnrXa47ZryrGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUbDxYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
 Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r15M2
 8IrcIa0xkI8VCY1x0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
 021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
 xl6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl
 6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4
 xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8
 JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l42
 xK82IY64kExVAvwVAq07x20xyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
 xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrx
 kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
 6r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
 CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUcrgADUUU
 U
X-CM-SenderInfo: 5oxrzvtqj6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [dm-devel v2 2/4] dm clone: Fix UAF in clone_dtr()
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
Cc: luomeng12@huawei.com, yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Dm_clone also has the same UAF problem when dm_resume()
and dm_destroy() are concurrent.

Therefore, canceling timer again in clone_dtr().

Fixes: 7431b7835f554 (dm: add clone target)
Signed-off-by: Luo Meng <luomeng12@huawei.com>
---
 drivers/md/dm-clone-target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 2f1cc66d2641..29e0b85eeaf0 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1958,6 +1958,7 @@ static void clone_dtr(struct dm_target *ti)
 
 	mempool_exit(&clone->hydration_pool);
 	dm_kcopyd_client_destroy(clone->kcopyd_client);
+	cancel_delayed_work_sync(&clone->waker);
 	destroy_workqueue(clone->wq);
 	hash_table_exit(clone);
 	dm_clone_metadata_close(clone->cmd);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

