Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC8BC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jan 2022 18:24:45 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-oLlJb7q_NWalIsPNSf12Og-1; Thu, 13 Jan 2022 13:24:42 -0500
X-MC-Unique: oLlJb7q_NWalIsPNSf12Og-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1F6D2F25;
	Thu, 13 Jan 2022 18:24:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 628507F808;
	Thu, 13 Jan 2022 18:24:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F3BA918077BC;
	Thu, 13 Jan 2022 18:24:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20DIH87F007679 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 Jan 2022 13:17:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F3D562166BA9; Thu, 13 Jan 2022 18:17:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDA652166BA4
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 18:17:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F538800B29
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 18:17:01 +0000 (UTC)
Received: from mellanox.co.il (mail-il-dmz.mellanox.com [193.47.165.129]) by
	relay.mimecast.com with ESMTP id us-mta-595-YP2apyVPNAOV6ZaT4FfO7A-1;
	Thu, 13 Jan 2022 13:16:59 -0500
X-MC-Unique: YP2apyVPNAOV6ZaT4FfO7A-1
Received: from Internal Mail-Server by MTLPINE1 (envelope-from
	israelr@nvidia.com) with SMTP; 13 Jan 2022 20:10:13 +0200
Received: from rsws47.mtr.labs.mlnx (rsws47.mtr.labs.mlnx [10.210.9.30])
	by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 20DIADSU009929;
	Thu, 13 Jan 2022 20:10:13 +0200
From: Israel Rukshin <israelr@nvidia.com>
To: dm-devel <dm-devel@redhat.com>
Date: Thu, 13 Jan 2022 20:09:00 +0200
Message-Id: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
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
Cc: Israel Rukshin <israelr@nvidia.com>, Max Gurtovoy <mgurtovoy@nvidia.com>,
	Nitzan Carmi <nitzanc@nvidia.com>
Subject: [dm-devel] [RFC PATCH 0/1] Add inline encryption support for
	dm-crypt
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

Hi,

I am working to add support for inline encryption/decryption
at storage protocols like nvmf over RDMA. The HW that I am
working with is ConnecX-6 Dx, which supports inline crypto
and can send the data on the fabric at the same time.

This patchset is based on v5.16-rc4 with Eric Biggers patches
of the HW wrapped keys.
It can be retrieved from branch "wip-wrapped-keys" at
https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git

I tested this patch with modified nvme-rdma as the block device
and created a DM crypt on top of it. I got performance enhancement
compared to SW crypto. I tested the HW wrapped inline mode with
the HW and the standard mode with a fallback algorithm.

Israel Rukshin (1):
  dm crypt: Add inline encryption support

 block/blk-crypto.c    |   3 +
 drivers/md/dm-crypt.c | 202 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 180 insertions(+), 25 deletions(-)

-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

