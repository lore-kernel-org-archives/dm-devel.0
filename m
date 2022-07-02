Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DBDCC43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119129;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XhaReISiReK5MyYX3lVSzivYxUkOWlJ+DN2lK3k0JPA=;
	b=RS0LOaX+dKzH1MduvJGs15/Vk3ODdp8JEcO1k3XXtJuv21sY3vrBmytH4GTueE/XSCTHCT
	aZG0IZNFWEjxUd/HfMf/QMkzWpD8XYRFrGkqK08vYdSSUCXFgqgqPwzjlzT3oB7cy/UaFv
	XgrCy0qB61FP7T6sy8Ip+iyBhM/GiHU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-lI6YDqWGODia4pH7VBt_NA-1; Wed, 06 Jul 2022 10:52:05 -0400
X-MC-Unique: lI6YDqWGODia4pH7VBt_NA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 187933C2F765;
	Wed,  6 Jul 2022 14:52:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 05B4A40EC002;
	Wed,  6 Jul 2022 14:52:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C0F281947063;
	Wed,  6 Jul 2022 14:52:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 40EBC1947042
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 19:32:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 221B418EB5; Sat,  2 Jul 2022 19:32:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E69A18EA8
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 19:32:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 032D3811E75
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 19:32:38 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-oqL1wG2rOhunj5zM9XOzWw-1; Sat, 02 Jul 2022 15:32:35 -0400
X-MC-Unique: oqL1wG2rOhunj5zM9XOzWw-1
X-IronPort-AV: E=McAfee;i="6400,9594,10396"; a="369188843"
X-IronPort-AV: E=Sophos;i="5.92,240,1650956400"; d="scan'208";a="369188843"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 02 Jul 2022 12:32:34 -0700
X-IronPort-AV: E=Sophos;i="5.92,240,1650956400"; d="scan'208";a="624624692"
Received: from smile.fi.intel.com ([10.237.72.54])
 by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 02 Jul 2022 12:32:30 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
 (envelope-from <andriy.shevchenko@linux.intel.com>)
 id 1o7iqw-0013qw-2i; Sat, 02 Jul 2022 22:32:26 +0300
Date: Sat, 2 Jul 2022 22:32:26 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <YsCdSkzSbVz9gnci@smile.fi.intel.com>
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <3f2ad7fb91948525f6c52e0d36ec223cd3049c88.1656785856.git.christophe.jaillet@wanadoo.fr>
 <YsCUW6vT7LlAv2UE@smile.fi.intel.com>
 <6063ee97-1bbe-2391-78cb-57572851a52c@wanadoo.fr>
MIME-Version: 1.0
In-Reply-To: <6063ee97-1bbe-2391-78cb-57572851a52c@wanadoo.fr>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 1/4] s390/cio: Rename bitmap_size() as
 idset_bitmap_size()
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
 ntfs3@lists.linux.dev, yury.norov@gmail.com, gor@linux.ibm.com,
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

On Sat, Jul 02, 2022 at 09:24:24PM +0200, Christophe JAILLET wrote:
> Le 02/07/2022 =E0 20:54, Andy Shevchenko a =E9crit=A0:
> > On Sat, Jul 02, 2022 at 08:29:09PM +0200, Christophe JAILLET wrote:

...

> > > -=09=09memset(set->bitmap, 0, bitmap_size(num_ssid, num_id));
> > > +=09=09memset(set->bitmap, 0, idset_bitmap_size(num_ssid, num_id));
> >=20
> > Why not to use bitmap_zero()?

...

> > > -=09memset(set->bitmap, 0xff, bitmap_size(set->num_ssid, set->num_id)=
);
> > > +=09memset(set->bitmap, 0xff, idset_bitmap_size(set->num_ssid, set->n=
um_id));
> >=20
> > Why not to use bitmap_fill() ?

> For this initial step, I wanted to keep changes as minimal as possible (i=
.e
> just function renaming)
>=20
> In fact, I plan to send a follow-up patch on this file.
> This would remove the newly renamed idset_bitmap_size() function, use the
> bitmap API directly (as you pointed-out) with
> "set->num_ssid * set->num_id" as size.
>=20
> It is already done this way in idset_is_empty(), so it would be more
> consistent.
>=20
> If the serie needs a v2 (or if required), I can add an additional 5th pat=
ch
> for it. Otherwise it will send separatly later.

If you use bitmap APIs as I suggested above as the first patch, the rest wi=
ll
have less unneeded churn, no?


--=20
With Best Regards,
Andy Shevchenko


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

