Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E638C7EE31
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 14:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685542082;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7UDe++52N1MyAMeQWM9+xLUuSVLwKIdRGohKGSclHUs=;
	b=MAUQOTCegZW0iFLdUxkKwRHaL9OaRIADeoq+KeCmHcyvufRVmQeCdCcc4Qhb7I1/GSK+/G
	+NQY39eUNlc0k4m3gbmqwuoX8T/1xJxTZx8TvEUEQgTiFwzqlCFNwmMgLxKfFazAjpZCrq
	9xSdVnTP6meJpbOgQ88pUeDi9zApMBM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-GOqDHg9wNL6_cigg1ajcag-1; Wed, 31 May 2023 10:07:58 -0400
X-MC-Unique: GOqDHg9wNL6_cigg1ajcag-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AAD72812944;
	Wed, 31 May 2023 14:07:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE37F492B0A;
	Wed, 31 May 2023 14:07:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C8D0319465A0;
	Wed, 31 May 2023 14:07:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E2131946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 13:52:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5C5AF140E963; Wed, 31 May 2023 13:52:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 55052140E962
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:52:01 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 315461C0693D
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:52:01 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-mMjPTsnpPVe8rHW3PsHl4g-1; Wed, 31 May 2023 09:51:58 -0400
X-MC-Unique: mMjPTsnpPVe8rHW3PsHl4g-1
Received: from [2001:4bb8:182:6d06:2e49:a56:513a:92ee] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4LMZ-00HQu7-1g; Wed, 31 May 2023 12:55:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 14:55:11 +0200
Message-Id: <20230531125535.676098-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] fix the name_to_dev_t mess v2
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
Cc: Loic Poulain <loic.poulain@linaro.org>,
 Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

this series tries to sort out accumulated mess around the name_to_dev_t
function.  This function is intended to allow looking up the dev_t of a
block device based on a name string before the root file systems is
mounted and thus the normal path based lookup is available.

Unfortunately a few years ago it managed to get exported and used in
non-init contexts, leading to the something looking like a path name
also beeing lookuped up by a different and potential dangerous
algorithm.

This series does a fair amount of refactoring and finally ends up with
the renamed and improved name_to_dev_t only beeing available for the
early init code again.

The series is against Jens' for-6.5/block tree but probably applies
against current mainline just fine as well.

A git tree is also available here:

    git://git.infradead.org/users/hch/block.git blk-init-cleanup

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/blk-init-cleanup

Changes since v1:
 - really propagate the actual error in dm_get_device
 - improve the documentation in kernel-parameters.txt
 - spelling fixes

Diffstat:

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

