Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E399E3AC29
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CRrzF54m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697524317;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=m5qmOpgaAbxaCEjrKwXUvLVHntmiS31/qG1xWZzsbNk=;
	b=CRrzF54mq3WB6fmF8gg56+vKouDyYbhAXjoTfjeEFV4qsVQlSReb9LByqtNXt9DIgoitN9
	dTz24L1oOB7OSbxp2MEXNMh6kfr02tRlxczwtK6tjvPuQ54IQSvrML6S1oytdZ9+03Gx4a
	ynNGdYSumblBQ3bgHgsu73sd6NUapWw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-dXNozCP6P8O9lkIjO05ENw-1; Tue, 17 Oct 2023 02:31:55 -0400
X-MC-Unique: dXNozCP6P8O9lkIjO05ENw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E546629AB3E1
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD8651C060B0
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B367E19466EE
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E1621946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 11 Oct 2023 10:38:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 42A60492B06; Wed, 11 Oct 2023 10:38:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B2A1492B04
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 10:38:06 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1982D3C0F665
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 10:38:06 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-Y18ElG-XMD2Gu--PeCArVA-1; Wed, 11 Oct 2023 06:37:59 -0400
X-MC-Unique: Y18ElG-XMD2Gu--PeCArVA-1
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="415675484"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; d="scan'208";a="415675484"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 11 Oct 2023 03:36:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10859"; a="824114342"
X-IronPort-AV: E=Sophos;i="6.03,214,1694761200"; d="scan'208";a="824114342"
Received: from unknown (HELO smile.fi.intel.com) ([10.237.72.54])
 by fmsmga004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 11 Oct 2023 03:36:50 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97-RC1)
 (envelope-from <andriy.shevchenko@linux.intel.com>)
 id 1qqWa7-00000004azc-2aLH; Wed, 11 Oct 2023 13:36:47 +0300
Date: Wed, 11 Oct 2023 13:36:47 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH 09/14] bitmap: extend bitmap_{get,set}_value8() to
 bitmap_{get,set}_bits()
Message-ID: <ZSZ6v1qgZbqKgKXa@smile.fi.intel.com>
References: <20231009151026.66145-1-aleksander.lobakin@intel.com>
 <20231009151026.66145-10-aleksander.lobakin@intel.com>
 <ZSQq02A9mTireK71@yury-ThinkPad>
 <a28542e2-4a5b-4c29-9d4a-12a0d2ab5527@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a28542e2-4a5b-4c29-9d4a-12a0d2ab5527@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Tue, 17 Oct 2023 06:31:30 +0000
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
Cc: linux-s390@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 David Ahern <dsahern@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
 Alexander Potapenko <glider@google.com>,
 Simon Horman <simon.horman@corigine.com>, Jakub Kicinski <kuba@kernel.org>,
 ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.intel.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 11, 2023 at 11:33:25AM +0200, Alexander Lobakin wrote:
> From: Yury Norov <yury.norov@gmail.com>
> Date: Mon, 9 Oct 2023 09:31:15 -0700
> 
> > + Alexander Potapenko <glider@google.com>
> > 
> > On Mon, Oct 09, 2023 at 05:10:21PM +0200, Alexander Lobakin wrote:
> >> Sometimes there's need to get a 8/16/...-bit piece of a bitmap at a
> >> particular offset. Currently, there are only bitmap_{get,set}_value8()
> >> to do that for 8 bits and that's it.
> > 
> > And also a series from Alexander Potapenko, which I really hope will
> > get into the -next really soon. It introduces bitmap_read/write which
> > can set up to BITS_PER_LONG at once, with no limitations on alignment
> > of position and length:
> > 
> > https://lore.kernel.org/linux-arm-kernel/ZRXbOoKHHafCWQCW@yury-ThinkPad/T/#mc311037494229647088b3a84b9f0d9b50bf227cb
> > 
> > Can you consider building your series on top of it?
> 
> Yeah, I mentioned in the cover letter that I'm aware of it and in fact
> it doesn't conflict much, as the functions I'm adding here get optimized
> as much as the original bitmap_{get,set}_value8(), while Alexander's
> generic helpers are heavier.
> I realize lots of calls will be optimized as well due to the offset and
> the width being compile-time constants, but not all of them. The idea of
> keeping two pairs of helpers initially came from Andy if I understood
> him correctly.

Just a disclaimer: The idea came before I saw the series by Alexander Potapenko.

> What do you think? I can provide some bloat-o-meter stats after
> rebasing. And either way, I see no issue in basing this series on top of
> Alex' one.

-- 
With Best Regards,
Andy Shevchenko


