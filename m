Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F254BC47082
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 14:16:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 907C461026
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 14:16:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 907C461026
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1622038580;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D89R7vyrwb7qOV94zoO9xG8+2lPW6PIDLxJtnRRlHfo=;
	b=aLFrIDCu1qtIEr75xA5KNd9AauqXk6K4WUKzL9tvPSR0ljj9rrn1ZTX+mQzGF+3pj161IZ
	GB46IpkHVSEkQnNzpAHYOUGJui69Llnecplo3UjzF6HAHXWW6v5yITco2xfI0YZXNzM7+u
	vLOIH3HYAX8pGz2YLkVlp1+2CJTRjUk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-r-37Nzf9OPulRwrcvfmiXQ-1; Wed, 26 May 2021 10:16:17 -0400
X-MC-Unique: r-37Nzf9OPulRwrcvfmiXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC0C5803F50;
	Wed, 26 May 2021 14:16:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E531EE14B;
	Wed, 26 May 2021 14:16:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 15F4655345;
	Wed, 26 May 2021 14:16:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14QEG69O028056 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 May 2021 10:16:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B22F5E156; Wed, 26 May 2021 14:16:06 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C3FF019D9D;
	Wed, 26 May 2021 14:16:01 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 14QEG1NP026392; Wed, 26 May 2021 10:16:01 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 14QEG1Fb026388; Wed, 26 May 2021 10:16:01 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 26 May 2021 10:16:01 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Damien Le Moal <Damien.LeMoal@wdc.com>
In-Reply-To: <CH2PR04MB70783B1B24BD10E2BE380D1FE7259@CH2PR04MB7078.namprd04.prod.outlook.com>
Message-ID: <alpine.LRH.2.02.2105261013460.25928@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2105251548340.29706@file01.intranet.prod.int.rdu2.redhat.com>
	<CH2PR04MB70783B1B24BD10E2BE380D1FE7259@CH2PR04MB7078.namprd04.prod.outlook.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH v2] dm-kcopyd: avoid useless atomic operations
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



On Tue, 25 May 2021, Damien Le Moal wrote:

> On 2021/05/26 4:50, Mikulas Patocka wrote:
> > The functions set_bit and clear_bit are atomic. We don't need atomicity
> > when making flags for dm-kcopyd. So, change them to direct manipulation of
> > the flags.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > Index: linux-2.6/drivers/md/dm-kcopyd.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-kcopyd.c
> > +++ linux-2.6/drivers/md/dm-kcopyd.c
> > @@ -812,7 +812,7 @@ void dm_kcopyd_copy(struct dm_kcopyd_cli
> >  	if (!test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags)) {
> >  		for (i = 0; i < job->num_dests; i++) {
> >  			if (bdev_zoned_model(dests[i].bdev) == BLK_ZONED_HM) {
> > -				set_bit(DM_KCOPYD_WRITE_SEQ, &job->flags);
> > +				job->flags |= 1UL << DM_KCOPYD_WRITE_SEQ;
> 
> How about using the BIT() macro ?
> 
> job->flags |= BIT(DM_KCOPYD_WRITE_SEQ);
> 
> But I know some do not like that macro :)

Yes - it is better to use it.
I also changed flags from unsigned long to unsigned, to make the structure 
smaller.


From: Mikulas Patocka <mpatocka@redhat.com>

dm-kcopyd: avoid useless atomic operations

The functions set_bit and clear_bit are atomic. We don't need atomicity
when making flags for dm-kcopyd. So, change them to direct manipulation of
the flags.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-kcopyd.c
+++ linux-2.6/drivers/md/dm-kcopyd.c
@@ -341,7 +341,7 @@ static void client_free_pages(struct dm_
 struct kcopyd_job {
 	struct dm_kcopyd_client *kc;
 	struct list_head list;
-	unsigned long flags;
+	unsigned flags;
 
 	/*
 	 * Error state of the job.
@@ -418,7 +418,7 @@ static struct kcopyd_job *pop_io_job(str
 	 * constraint and sequential writes that are at the right position.
 	 */
 	list_for_each_entry(job, jobs, list) {
-		if (job->rw == READ || !test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags)) {
+		if (job->rw == READ || !(job->flags & BIT(DM_KCOPYD_WRITE_SEQ))) {
 			list_del(&job->list);
 			return job;
 		}
@@ -529,7 +529,7 @@ static void complete_io(unsigned long er
 		else
 			job->read_err = 1;
 
-		if (!test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags)) {
+		if (!(job->flags & BIT(DM_KCOPYD_IGNORE_ERROR))) {
 			push(&kc->complete_jobs, job);
 			wake(kc);
 			return;
@@ -572,7 +572,7 @@ static int run_io_job(struct kcopyd_job
 	 * If we need to write sequentially and some reads or writes failed,
 	 * no point in continuing.
 	 */
-	if (test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags) &&
+	if (job->flags & BIT(DM_KCOPYD_WRITE_SEQ) &&
 	    job->master_job->write_err) {
 		job->write_err = job->master_job->write_err;
 		return -EIO;
@@ -716,7 +716,7 @@ static void segment_complete(int read_er
 	 * Only dispatch more work if there hasn't been an error.
 	 */
 	if ((!job->read_err && !job->write_err) ||
-	    test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags)) {
+	    job->flags & BIT(DM_KCOPYD_IGNORE_ERROR)) {
 		/* get the next chunk of work */
 		progress = job->progress;
 		count = job->source.count - progress;
@@ -809,10 +809,10 @@ void dm_kcopyd_copy(struct dm_kcopyd_cli
 	 * we need to write sequentially. If one of the destination is a
 	 * host-aware device, then leave it to the caller to choose what to do.
 	 */
-	if (!test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags)) {
+	if (!(job->flags & BIT(DM_KCOPYD_WRITE_SEQ))) {
 		for (i = 0; i < job->num_dests; i++) {
 			if (bdev_zoned_model(dests[i].bdev) == BLK_ZONED_HM) {
-				set_bit(DM_KCOPYD_WRITE_SEQ, &job->flags);
+				job->flags |= BIT(DM_KCOPYD_WRITE_SEQ);
 				break;
 			}
 		}
@@ -821,9 +821,9 @@ void dm_kcopyd_copy(struct dm_kcopyd_cli
 	/*
 	 * If we need to write sequentially, errors cannot be ignored.
 	 */
-	if (test_bit(DM_KCOPYD_WRITE_SEQ, &job->flags) &&
-	    test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags))
-		clear_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags);
+	if (job->flags & BIT(DM_KCOPYD_WRITE_SEQ) &&
+	    job->flags & BIT(DM_KCOPYD_IGNORE_ERROR))
+		job->flags &= ~BIT(DM_KCOPYD_IGNORE_ERROR);
 
 	if (from) {
 		job->source = *from;
Index: linux-2.6/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid1.c
+++ linux-2.6/drivers/md/dm-raid1.c
@@ -364,7 +364,7 @@ static void recover(struct mirror_set *m
 
 	/* hand to kcopyd */
 	if (!errors_handled(ms))
-		set_bit(DM_KCOPYD_IGNORE_ERROR, &flags);
+		flags |= BIT(DM_KCOPYD_IGNORE_ERROR);
 
 	dm_kcopyd_copy(ms->kcopyd_client, &from, ms->nr_mirrors - 1, to,
 		       flags, recovery_complete, reg);
Index: linux-2.6/drivers/md/dm-zoned-reclaim.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-zoned-reclaim.c
+++ linux-2.6/drivers/md/dm-zoned-reclaim.c
@@ -134,7 +134,7 @@ static int dmz_reclaim_copy(struct dmz_r
 	dst_zone_block = dmz_start_block(zmd, dst_zone);
 
 	if (dmz_is_seq(dst_zone))
-		set_bit(DM_KCOPYD_WRITE_SEQ, &flags);
+		flags |= BIT(DM_KCOPYD_WRITE_SEQ);
 
 	while (block < end_block) {
 		if (src_zone->dev->flags & DMZ_BDEV_DYING)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

