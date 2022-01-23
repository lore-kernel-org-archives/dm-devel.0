Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A618C433EF
	for <dm-devel@archiver.kernel.org>; Sun, 23 Jan 2022 16:02:14 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-frypXESrMdaebL5jBdfE4w-1; Sun, 23 Jan 2022 11:02:09 -0500
X-MC-Unique: frypXESrMdaebL5jBdfE4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DED1835B47;
	Sun, 23 Jan 2022 16:02:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 81D31798D0;
	Sun, 23 Jan 2022 16:02:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 58E341809CBA;
	Sun, 23 Jan 2022 16:02:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20NFok7V012817 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 23 Jan 2022 10:50:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7399E40CFD11; Sun, 23 Jan 2022 15:50:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F4A040CFD0B
	for <dm-devel@redhat.com>; Sun, 23 Jan 2022 15:50:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5729D80A0A0
	for <dm-devel@redhat.com>; Sun, 23 Jan 2022 15:50:46 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
	[139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-204-kph45GoePc2bqABoCSNutw-1; Sun, 23 Jan 2022 10:50:44 -0500
X-MC-Unique: kph45GoePc2bqABoCSNutw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 2F02860E33;
	Sun, 23 Jan 2022 15:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08198C340E2;
	Sun, 23 Jan 2022 15:50:41 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org, hch@lst.de
Date: Sun, 23 Jan 2022 10:50:40 -0500
Message-Id: <20220123155040.2557082-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20NFok7V012817
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] Patch "dm: fix alloc_dax error handling in alloc_dev"
	has been added to the 5.15-stable tree
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

This is a note to let you know that I've just added the patch titled

    dm: fix alloc_dax error handling in alloc_dev

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-fix-alloc_dax-error-handling-in-alloc_dev.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit e3d093f4918149685ca9303b91f9a9f61482178e
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Nov 29 11:21:35 2021 +0100

    dm: fix alloc_dax error handling in alloc_dev
    
    [ Upstream commit d751939235b9b7bc4af15f90a3e99288a8b844a7 ]
    
    Make sure ->dax_dev is NULL on error so that the cleanup path doesn't
    trip over an ERR_PTR.
    
    Reported-by: Dan Williams <dan.j.williams@intel.com>
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Link: https://lore.kernel.org/r/20211129102203.2243509-2-hch@lst.de
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 76d9da49fda75..671bb454f1649 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1794,8 +1794,10 @@ static struct mapped_device *alloc_dev(int minor)
 	if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
 		md->dax_dev = alloc_dax(md, md->disk->disk_name,
 					&dm_dax_ops, 0);
-		if (IS_ERR(md->dax_dev))
+		if (IS_ERR(md->dax_dev)) {
+			md->dax_dev = NULL;
 			goto bad;
+		}
 	}
 
 	format_dev_t(md->name, MKDEV(_major, minor));


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

