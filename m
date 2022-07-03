Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA65CCA473
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 15:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119812;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=01Cn72xFT7eukF5KSFJ0hD7Gd32/qLxylIRXOeLAKI0=;
	b=ebfL0/pLSbwspvhkrQbsiYkfGUZEPMcFwuM8TAXIL4m5LX7U0XQVjjZoeS3DlfXH6gLW5p
	ZcWqEAq81InzpeCNeGYqEB3gCvtpMpg46aDITdnmp+Z7lc1ISS5HJH21FVzMW7G2FM5cUN
	egiS8zaGeDmkd9TmAXmpAf4YTkEqHag=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-bJujitLlPYS4FFmW3fzGZQ-1; Wed, 06 Jul 2022 11:03:28 -0400
X-MC-Unique: bJujitLlPYS4FFmW3fzGZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A899D2932480;
	Wed,  6 Jul 2022 15:03:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 64ABE40E80E0;
	Wed,  6 Jul 2022 15:03:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 05892194706F;
	Wed,  6 Jul 2022 15:03:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7A0C31947040
 for <dm-devel@listman.corp.redhat.com>; Sun,  3 Jul 2022 15:22:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 69C511121319; Sun,  3 Jul 2022 15:22:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 659221121315
 for <dm-devel@redhat.com>; Sun,  3 Jul 2022 15:22:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AA623C01D87
 for <dm-devel@redhat.com>; Sun,  3 Jul 2022 15:22:07 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-bHYExFjcOyWcuYVUZlyGPA-1; Sun, 03 Jul 2022 11:22:05 -0400
X-MC-Unique: bHYExFjcOyWcuYVUZlyGPA-1
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="346938825"
X-IronPort-AV: E=Sophos;i="5.92,241,1650956400"; d="scan'208";a="346938825"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 03 Jul 2022 08:21:01 -0700
X-IronPort-AV: E=Sophos;i="5.92,241,1650956400"; d="scan'208";a="542233739"
Received: from smile.fi.intel.com ([10.237.72.54])
 by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 03 Jul 2022 08:20:57 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
 (envelope-from <andriy.shevchenko@linux.intel.com>)
 id 1o81P4-0014Px-0j; Sun, 03 Jul 2022 18:20:54 +0300
Date: Sun, 3 Jul 2022 18:20:53 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <YsGz1Xp0RDM5ZhVY@smile.fi.intel.com>
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <98f5d3d855a9c687ccc035edf62016b02a6876b7.1656785856.git.christophe.jaillet@wanadoo.fr>
 <YsC0GpltMVaCPhkJ@yury-laptop>
 <4dc5d50a-2291-1d3a-efac-3f6378a15d69@wanadoo.fr>
MIME-Version: 1.0
In-Reply-To: <4dc5d50a-2291-1d3a-efac-3f6378a15d69@wanadoo.fr>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 3/4] bitmap: Introduce bitmap_size()
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
Cc: linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org,
 ntfs3@lists.linux.dev, gor@linux.ibm.com, Yury Norov <yury.norov@gmail.com>,
 linux@rasmusvillemoes.dk, hca@linux.ibm.com, snitzer@kernel.org,
 oberpar@linux.ibm.com, linux-kernel@vger.kernel.org,
 almaz.alexandrovich@paragon-software.com, dm-devel@redhat.com,
 svens@linux.ibm.com, vneethv@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 03, 2022 at 08:50:19AM +0200, Christophe JAILLET wrote:
> Le 02/07/2022 =E0 23:09, Yury Norov a =E9crit=A0:
> > On Sat, Jul 02, 2022 at 08:29:36PM +0200, Christophe JAILLET wrote:

...

> > This should be dropped, for sure, and kmalloc() at line 128 should be
> > replaced with bitmap_alloc().
>=20
> This kmalloc() is for a structure and a flexible array.
>=20
> You mean re-arranging the code to allocate the structure alone at first,
> then the bitmap?

It's one way, but it will increase fragmentation of memory. The other one
as it seems to me is to name a new API properly, i.e. bitmap_size_to_bytes(=
).

In such case you won't need renames to begin with. And then would be able
to convert driver-by-driver in cases of duplicated code.

I think that's what confused Yuri and I kinda agree that bitmap_size() shou=
ld
return bits, and not bytes. Also argument for pure bitmap_size() would be
bitmap itself, but we have no way to detect the length of bitmap because we
are using POD and not a specific data structure for it.

--=20
With Best Regards,
Andy Shevchenko


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

