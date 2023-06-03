Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE6FFC7EE24
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685804008;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TfjIQO0R3UYg56Fau/OvZhQFHAlab9FwmZbuTiZ/ChM=;
	b=F6x6CMOUqy9+QPNFINrUZDcVy+AyLy6Ot3juSQpjbsOwZBbSjxvA7sFRHzdbhGk/c7a7IN
	5qEolloVrtNipnyCFqZooGLBXuWXgxG4iWcaLL9Iqqe8AV650QKzr8foB5RiG5zvqVFULT
	9DHdZf0F6s8/ANcxDc3SmuGqQy0Zfl4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-_S5CJJsZO2K3ed-DKxYiZw-1; Sat, 03 Jun 2023 10:53:25 -0400
X-MC-Unique: _S5CJJsZO2K3ed-DKxYiZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 184A43C02B6A;
	Sat,  3 Jun 2023 14:53:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 07DC914171BB;
	Sat,  3 Jun 2023 14:53:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EAA4819465A0;
	Sat,  3 Jun 2023 14:53:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 94FF51946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 14:53:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 84B308162; Sat,  3 Jun 2023 14:53:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D2F77AE4
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 14:53:21 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D2E31C05B1F
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 14:53:21 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com
 [66.111.4.26]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-ILTdWFfHM8qgWix5Y8QH9Q-1; Sat, 03 Jun 2023 10:53:18 -0400
X-MC-Unique: ILTdWFfHM8qgWix5Y8QH9Q-1
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
 by mailout.nyi.internal (Postfix) with ESMTP id A327A5C0159;
 Sat,  3 Jun 2023 10:53:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
 by compute4.internal (MEProxy); Sat, 03 Jun 2023 10:53:18 -0400
X-ME-Sender: <xms:3lN7ZDh0ghprryGPMdaiACNxoWXEEKem6yL6dvmc3n-t-nETHQ_DdA>
 <xme:3lN7ZADoi3kninUTuKyUXtKvKRcNQP7vtLHwKQY9PtybFM5DKQjQa70QS46r8EmyY
 jnBp94KXrFfVJk>
X-ME-Received: <xmr:3lN7ZDEgYkoYkalymaERFrHb-nZJ36wRxW6TUnSiDF3yNkxG26kICKyHuQeGldrxQzXxT5YA-ZM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelhedgkedvucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
 gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgepfeenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:3lN7ZAQnw0SkrMHFCS0p0iopaEzemtYID1_vMBL78G5aKDJKd2XE4g>
 <xmx:3lN7ZAz5GEjqcHqmK8AqRBurFZGxdT4Yx3eFTmd4qfNzSMIyAhfgxw>
 <xmx:3lN7ZG5uWaIEqaxRGNfUBeLmI0boc_uTNYnsrB2PNvWHXv5nzwK1lw>
 <xmx:3lN7ZM_zq6bg6ishrr7qL4RYTXdtAYevKXPMS3sPIORVoqmAw8I1xw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 3 Jun 2023 10:53:17 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Sat,  3 Jun 2023 10:52:42 -0400
Message-Id: <20230603145244.1538-5-demi@invisiblethingslab.com>
In-Reply-To: <20230603145244.1538-1-demi@invisiblethingslab.com>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
 <20230603145244.1538-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v2 4/6] device-mapper: Avoid double-fetch of
 version
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
 drivers/md/dm-ioctl.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index da6ca26b51d0953df380582bb3a51c2ec22c27cb..7510afe237d979a5ee71afe87a20d49f631de1aa 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1873,30 +1873,33 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
  * As well as checking the version compatibility this always
  * copies the kernel interface version out.
  */
-static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
+static int check_version(unsigned int cmd, struct dm_ioctl __user *user,
+			 struct dm_ioctl *kernel_params)
 {
-	uint32_t version[3];
 	int r = 0;
 
-	if (copy_from_user(version, user->version, sizeof(version)))
+	if (copy_from_user(kernel_params->version, user->version, sizeof(kernel_params->version)))
 		return -EFAULT;
 
-	if ((version[0] != DM_VERSION_MAJOR) ||
-	    (version[1] > DM_VERSION_MINOR)) {
+	if ((kernel_params->version[0] != DM_VERSION_MAJOR) ||
+	    (kernel_params->version[1] > DM_VERSION_MINOR)) {
 		DMERR("ioctl interface mismatch: kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
 		      DM_VERSION_MAJOR, DM_VERSION_MINOR,
 		      DM_VERSION_PATCHLEVEL,
-		      version[0], version[1], version[2], cmd);
+		      kernel_params->version[0],
+		      kernel_params->version[1],
+		      kernel_params->version[2],
+		      cmd);
 		r = -EINVAL;
 	}
 
 	/*
 	 * Fill in the kernel version.
 	 */
-	version[0] = DM_VERSION_MAJOR;
-	version[1] = DM_VERSION_MINOR;
-	version[2] = DM_VERSION_PATCHLEVEL;
-	if (copy_to_user(user->version, version, sizeof(version)))
+	kernel_params->version[0] = DM_VERSION_MAJOR;
+	kernel_params->version[1] = DM_VERSION_MINOR;
+	kernel_params->version[2] = DM_VERSION_PATCHLEVEL;
+	if (copy_to_user(user->version, kernel_params->version, sizeof(kernel_params->version)))
 		return -EFAULT;
 
 	return r;
@@ -1922,7 +1925,10 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 	const size_t minimum_data_size = offsetof(struct dm_ioctl, data);
 	unsigned int noio_flag;
 
-	if (copy_from_user(param_kernel, user, minimum_data_size))
+	/* Version has been copied from userspace already, avoid TOCTOU */
+	if (copy_from_user((char *)param_kernel + sizeof(param_kernel->version),
+			   (char __user *)user + sizeof(param_kernel->version),
+			   minimum_data_size - sizeof(param_kernel->version)))
 		return -EFAULT;
 
 	if (param_kernel->data_size < minimum_data_size) {
@@ -2034,7 +2040,7 @@ static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *us
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

