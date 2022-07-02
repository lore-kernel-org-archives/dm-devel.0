Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45512C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119335;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GphSdG327O26PFnK+7EW5BthbBhZNiwg+PkHmryGabU=;
	b=OyHHggawNRYBcL+sCMjSr1MEu1G7qec5jgBNFrzXnOhu1PL7EHHrKF9ss4LJD1o3H/rJHF
	Gc9dGVOnWV+jLSi9Np2M6HxMJOdTk30fwCW3c9wkZkS2uxt191MP6Qdg/nLGUB78RTN6Qa
	cVKjn4lUFH6pZ777ZFIvP94jbupS0TI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-YT94YzZhNjKmK01f44HDaw-1; Wed, 06 Jul 2022 10:55:34 -0400
X-MC-Unique: YT94YzZhNjKmK01f44HDaw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBA361C18261;
	Wed,  6 Jul 2022 14:55:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D83CD18ECC;
	Wed,  6 Jul 2022 14:55:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A47131947063;
	Wed,  6 Jul 2022 14:55:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A5CCC1947042
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 18:36:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 905B018EB7; Sat,  2 Jul 2022 18:36:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C21618EA8
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 18:36:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7148329DD983
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 18:36:32 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp03.smtpout.orange.fr
 [80.12.242.125]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 us-mta-116-F0aG5nxqPQSrWH0sgW5rcg-1; Sat, 02 Jul 2022 14:36:31 -0400
X-MC-Unique: F0aG5nxqPQSrWH0sgW5rcg-1
Received: from pop-os.home ([90.11.190.129]) by smtp.orange.fr with ESMTPA
 id 7hrUoTjFU4Ltq7hrUonitC; Sat, 02 Jul 2022 20:28:59 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 02 Jul 2022 20:28:59 +0200
X-ME-IP: 90.11.190.129
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 vneethv@linux.ibm.com, oberpar@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
 svens@linux.ibm.com, almaz.alexandrovich@paragon-software.com,
 yury.norov@gmail.com, andriy.shevchenko@linux.intel.com,
 linux@rasmusvillemoes.dk
Date: Sat,  2 Jul 2022 20:28:53 +0200
Message-Id: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: [dm-devel] [PATCH 0/4] Introduce bitmap_size()
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
Cc: linux-s390@vger.kernel.org, ntfs3@lists.linux.dev,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This serie introduces bitmap_size() which returns the size, in bytes, of a
bitmap. Such a function is useful to simplify some drivers that use vmalloc() or
other functions to allocate some butmaps.
It also hides some implementation details about how bitmaps are stored (array of
longs)

Before introducing this function in patch 3, patch 1 and 2 rename some functions
with the same name but with different meaning.

Finaly, patch 4 makes use of the new function in bitmap.h.


Other follow-up patches to simplify some drivers will be proposed later if/when
this serie is merged.

Christophe JAILLET (4):
  s390/cio: Rename bitmap_size() as idset_bitmap_size()
  fs/ntfs3: Rename bitmap_size() as ntfs3_bitmap_size()
  bitmap: Introduce bitmap_size()
  bitmap: Use bitmap_size()

 drivers/md/dm-clone-metadata.c |  5 -----
 drivers/s390/cio/idset.c       |  8 ++++----
 fs/ntfs3/bitmap.c              |  4 ++--
 fs/ntfs3/fsntfs.c              |  2 +-
 fs/ntfs3/index.c               |  6 +++---
 fs/ntfs3/ntfs_fs.h             |  2 +-
 fs/ntfs3/super.c               |  2 +-
 include/linux/bitmap.h         | 15 +++++++++------
 lib/math/prime_numbers.c       |  2 --
 9 files changed, 21 insertions(+), 25 deletions(-)

-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

