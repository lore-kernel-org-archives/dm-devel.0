Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7011EC43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119239;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0rT+ynTPZImlAopZKMgBSsT70kFvLpYOlh5Edw5XlSA=;
	b=eS73XUgOWWXbgf5JMgAr51lQe+4yISI2+du7E9/eSRkFthi/1MLzC4NbipHVk4bkL6o5n+
	nMiwt+LpXokWJukfVvomC10yGc7S/Qe/G9JHKDwL6agPLPXYG4u8XwE5lSeN9kyF7EA1Eh
	ty/jRJyYsubvK+CXlg3ITC3LihhaOvc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-5-3stGYKPBGhlCbaZJMq8A-1; Wed, 06 Jul 2022 10:53:56 -0400
X-MC-Unique: 5-3stGYKPBGhlCbaZJMq8A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8817585A581;
	Wed,  6 Jul 2022 14:53:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 709AD2EF97;
	Wed,  6 Jul 2022 14:53:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2B4841947063;
	Wed,  6 Jul 2022 14:53:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7EF131947042
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 18:55:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 69FC52166B29; Sat,  2 Jul 2022 18:55:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6640C2166B26
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 18:55:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A02C38035A2
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 18:55:35 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-yfVjea6-O5Gls1t1CKpXZA-1; Sat, 02 Jul 2022 14:55:33 -0400
X-MC-Unique: yfVjea6-O5Gls1t1CKpXZA-1
X-IronPort-AV: E=McAfee;i="6400,9594,10396"; a="308391991"
X-IronPort-AV: E=Sophos;i="5.92,240,1650956400"; d="scan'208";a="308391991"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 02 Jul 2022 11:54:27 -0700
X-IronPort-AV: E=Sophos;i="5.92,240,1650956400"; d="scan'208";a="681765037"
Received: from smile.fi.intel.com ([10.237.72.54])
 by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 02 Jul 2022 11:54:23 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
 (envelope-from <andriy.shevchenko@linux.intel.com>)
 id 1o7iG4-0013pn-0n; Sat, 02 Jul 2022 21:54:20 +0300
Date: Sat, 2 Jul 2022 21:54:19 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <YsCUW6vT7LlAv2UE@smile.fi.intel.com>
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <3f2ad7fb91948525f6c52e0d36ec223cd3049c88.1656785856.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
In-Reply-To: <3f2ad7fb91948525f6c52e0d36ec223cd3049c88.1656785856.git.christophe.jaillet@wanadoo.fr>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 02, 2022 at 08:29:09PM +0200, Christophe JAILLET wrote:
> In order to introduce a bitmap_size() function in the bitmap API, we have
> to rename functions with a similar name.
> 
> Add a "idset_" prefix and change bitmap_size() into idset_bitmap_size().
> 
> No functional change.

...

> -		memset(set->bitmap, 0, bitmap_size(num_ssid, num_id));
> +		memset(set->bitmap, 0, idset_bitmap_size(num_ssid, num_id));

Why not to use bitmap_zero()?

...

> -	memset(set->bitmap, 0xff, bitmap_size(set->num_ssid, set->num_id));
> +	memset(set->bitmap, 0xff, idset_bitmap_size(set->num_ssid, set->num_id));

Why not to use bitmap_fill() ?


-- 
With Best Regards,
Andy Shevchenko


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

