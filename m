Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 789B6C7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 21:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685655069;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MAuK6T1BAURQ1yhO0xWI3SVks7hY/3h9l482eIkXeS0=;
	b=h8pY9wEWPXPHXFS2xBz2RCDM/CEtAOtWCB994Ngub7bJK/7QzLtRxDWLqh81NHvm8z5NeW
	cuoHZhfqq0jGNExVoQC0WGWPAIOOxAncYBIVcoiUsYVBQ1n2WSHiv2yU85Isw/hXeWKlHm
	PD/kQt6GrWxhOMG4ANLB//AH/lNBjbw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-mMV7UpoyOBa4AvhMb-BucA-1; Thu, 01 Jun 2023 17:31:07 -0400
X-MC-Unique: mMV7UpoyOBa4AvhMb-BucA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D598B101A53B;
	Thu,  1 Jun 2023 21:31:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F354492B0A;
	Thu,  1 Jun 2023 21:31:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E34C419465A0;
	Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6ACA5194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4D33DC154D9; Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 45657C154D7
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25CDF800B2A
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 21:31:03 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com
 [66.111.4.29]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-zAeM7f-vNySdm-CtQQcxng-1; Thu, 01 Jun 2023 17:31:01 -0400
X-MC-Unique: zAeM7f-vNySdm-CtQQcxng-1
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
 by mailout.nyi.internal (Postfix) with ESMTP id 51B315C01D4;
 Thu,  1 Jun 2023 17:25:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
 by compute4.internal (MEProxy); Thu, 01 Jun 2023 17:25:20 -0400
X-ME-Sender: <xms:wAx5ZCop7mZ0sTHJh6aoixbkmxXE2hpeBBeaZkvdf0fWSbsehwCnGw>
 <xme:wAx5ZApfEXNvHSO10vsufNin_SAdjUB3gVaNzAkdWzjJShuQG0v7xXjdTTDuL3PbQ
 AuwmDJkN4i0a7k>
X-ME-Received: <xmr:wAx5ZHPLYNpMCuEbyVrjrHzrxcFisklaeh4Xortc_jx63i9ls9tcqnqszl1clo4EzXEbzPztBOU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeluddgudeiudcutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedune
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:wAx5ZB5e536P_TRuBejVQt_cQiplNTKjKAzNptqLpQPP2iATdXDspQ>
 <xmx:wAx5ZB7L_eqEFw3Ns9k1frl4_L1CH2Jr5jaUtLU9OLBdKUU3u_eVBg>
 <xmx:wAx5ZBgMG9dI4j10NYs_2vLlWxLRnHWZqQBkNLxmHhAXvYdKoRsUqw>
 <xmx:wAx5ZLncHxR2y9IyXXRcNarRGZph6zvk8iAelJKk8lHREVjQGLCDAw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Jun 2023 17:25:19 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Thu,  1 Jun 2023 17:24:53 -0400
Message-Id: <20230601212456.1533-5-demi@invisiblethingslab.com>
In-Reply-To: <20230601212456.1533-1-demi@invisiblethingslab.com>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 4/6] device-mapper: Avoid double-fetch of version
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
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The version is fetched once in check_version(), which then does some
validation and then overwrites the version in userspace with the API
version supported by the kernel.  copy_params() then fetches the version
from userspace *again*, and this time no validation is done.  The result
is that the kernel's version number is completely controllable by
userspace, provided that userspace can win a race condition.

Fix this flaw by not copying the version back to the kernel the second
time.  This is not exploitable as the version is not further used in the
kernel.  However, it could become a problem if future patches start
relying on the version field.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/md/dm-ioctl.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index da6ca26b51d0953df380582bb3a51c2ec22c27cb..fd46b249f6f856c49752063fc49d720e95df0525 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1873,12 +1873,13 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
  * As well as checking the version compatibility this always
  * copies the kernel interface version out.
  */
-static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
+static int check_version(unsigned int cmd, struct dm_ioctl __user *user,
+			 struct dm_ioctl *kernel_params)
 {
-	uint32_t version[3];
 	int r = 0;
+	uint32_t *version = kernel_params->version;
 
-	if (copy_from_user(version, user->version, sizeof(version)))
+	if (copy_from_user(version, user->version, sizeof(user->version)))
 		return -EFAULT;
 
 	if ((version[0] != DM_VERSION_MAJOR) ||
@@ -1922,7 +1923,10 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 	const size_t minimum_data_size = offsetof(struct dm_ioctl, data);
 	unsigned int noio_flag;
 
-	if (copy_from_user(param_kernel, user, minimum_data_size))
+	/* Version has been copied from userspace already, avoid TOCTOU */
+	if (copy_from_user((char *)param_kernel + sizeof(param_kernel->version),
+			   (char __user *)user + sizeof(param_kernel->version),
+			   minimum_data_size - sizeof(param_kernel->version)))
 		return -EFAULT;
 
 	if (param_kernel->data_size < minimum_data_size) {
@@ -2034,7 +2038,7 @@ static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *us
 	 * Check the interface version passed in.  This also
 	 * writes out the kernel's interface version.
 	 */
-	r = check_version(cmd, user);
+	r = check_version(cmd, user, &param_kernel);
 	if (r)
 		return r;
 
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

