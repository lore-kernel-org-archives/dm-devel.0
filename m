Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A4DDC7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480103;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mUm8DDSoJfi2HHCvZt8bGIRQOQRly3mR2S9xZX6xFIM=;
	b=Sh/ooC87EKztq9qOytK+xIYMHFk4dEzCpDY9f/k02RYmKezq6mtgUszh301T0Or4oOkDyu
	XesPge/0e1bdB7PlDPOsv/iIyBt71fA43phbIozKhdBrpEILUle5ibEvMWwXfdc8tWyKKz
	FwxmQYfYGxhMBU8+RqapnsMWVQzskiE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-k031uJpON_ijIvYvxq3P1A-1; Tue, 30 May 2023 16:54:39 -0400
X-MC-Unique: k031uJpON_ijIvYvxq3P1A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3671D280D586;
	Tue, 30 May 2023 20:54:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2291440C6CCC;
	Tue, 30 May 2023 20:54:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A6F9E19451D4;
	Tue, 30 May 2023 20:54:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C529F1946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:35:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A32EF140EBD7; Tue, 30 May 2023 20:35:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B9CC140EBB8
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:35:09 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72BB2296A600
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:35:09 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-EEiphBbRPAmjXY_UvB16qA-1; Tue, 30 May 2023 16:32:52 -0400
X-MC-Unique: EEiphBbRPAmjXY_UvB16qA-1
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
 by mailout.west.internal (Postfix) with ESMTP id 4714F3200941;
 Tue, 30 May 2023 16:32:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute1.internal (MEProxy); Tue, 30 May 2023 16:32:16 -0400
X-ME-Sender: <xms:Tl12ZLCrjMwa5dd8nXInpbI80j8aks7WDHGQdC47Q6JkvDKgesheeg>
 <xme:Tl12ZBhWW6gzbLQXIBx87Wn5FhMOV1Jmqe7Bu4LvPr1RNpfkJmMNYXM8yoX9-WtnK
 KOwvl36hcRBn78>
X-ME-Received: <xmr:Tl12ZGmQvePgFgiwvtACF3E10lqS1U8ApvlnKupnDUwSSod63Ptq06kbfUX7FZofZWiSkLg8hdg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudeglecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedvne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:Tl12ZNw-JLuG8i_8xOIdX4SeeayTYC2T2NBU3vVW_z588mtnm1MNXQ>
 <xmx:Tl12ZAQw_DXvdm36tgmR2p2Ev34IIuqgkFUOmqOOyl5qMY21MCCl5Q>
 <xmx:Tl12ZAamGsz2l8le4BoAmD-xKUjEfjqYwtGU3y6fUVm9ndKsvfHsDw>
 <xmx:Tl12ZFSWJmukln6Pasz6VSPEKly6NXMAjEHrAUW2zz3CBGO838Esww>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:32:14 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:14 -0400
Message-Id: <20230530203116.2008-15-demi@invisiblethingslab.com>
In-Reply-To: <20230530203116.2008-1-demi@invisiblethingslab.com>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: [dm-devel] [PATCH v2 14/16] block,
 loop: Increment diskseq when releasing a loop device
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
Cc: Demi Marie Obenour <demi@invisiblethingslab.com>,
 linux-block@vger.kernel.org, xen-devel@lists.xenproject.org,
 =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The previous patch for checking diskseq in blkback is not enough to
prevent the following race:

1. Program X opens a loop device
2. Program X gets the diskseq of the loop device.
3. Program X associates a file with the loop device.
4. Program X passes the loop device major, minor, and diskseq to
   something, such as Xen blkback.
5. Program X exits.
6. Program Y detaches the file from the loop device.
7. Program Y attaches a different file to the loop device.
8. Xen blkback finally gets around to opening the loop device and checks
   that the diskseq is what it expects it to be.  Even though the
   diskseq is the expected value, the result is that blkback is
   accessing the wrong file.

To prevent this race condition, increment the diskseq of a loop device
when it is detached from its file descriptor.  This causes blkback (or
any other program, for that matter) to fail at step 8.  Export the
inc_diskseq() function to make this possible.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
I considered destroying the loop device altogether instead of bumping
its diskseq, but was not able to accomplish that.  Suggestions welcome.
---
 block/genhd.c        | 1 +
 drivers/block/loop.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 1cb489b927d50ab06a84a4bfd6913ca8ba7318d4..c0ca2c387732171321555cd57565fbc606768505 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1502,3 +1502,4 @@ void inc_diskseq(struct gendisk *disk)
 {
 	disk->diskseq = atomic64_inc_return(&diskseq);
 }
+EXPORT_SYMBOL(inc_diskseq);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index bc31bb7072a2cb7294d32066f5d0aa14130349b4..05ea5fb41508b4106f184dd6b4c37942716bdcac 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1205,6 +1205,12 @@ static void __loop_clr_fd(struct loop_device *lo, bool release)
 	if (!part_shift)
 		set_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 	mutex_lock(&lo->lo_mutex);
+
+	/*
+	 * Increment the disk sequence number, so that userspace knows this
+	 * device now points to something else.
+	 */
+	inc_diskseq(lo->lo_disk);
 	lo->lo_state = Lo_unbound;
 	mutex_unlock(&lo->lo_mutex);
 
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

