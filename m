Return-Path: <SRS0=nVuD=HH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F36C433E0
	for <dm-devel@archiver.kernel.org>; Fri,  5 Feb 2021 18:39:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A85AD64EE8
	for <dm-devel@archiver.kernel.org>; Fri,  5 Feb 2021 18:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A85AD64EE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612550370;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XgJfxSnIVqfjT4JyOPDSXCs0wbRssCAEZpdIEbohYmQ=;
	b=K2WbpgNUG/CONI9NcoV4munM5ri3nHuyvpT8FVS9acpCykuOTv/t7TGEa8XdCpzBg5u9AF
	h4LvzbVk0mVCqay5g31aCfUBZdRB8GcfXSAQuyQ7U3np9tuHHJ7/J4MhjdO2kz+E3UdnIz
	ZXdXy/1hS/IPGNqT6128Cwn0ojfJECw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-h3YmsSPZPAOicVIiORrQmw-1; Fri, 05 Feb 2021 13:39:27 -0500
X-MC-Unique: h3YmsSPZPAOicVIiORrQmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC19B1800D50;
	Fri,  5 Feb 2021 18:39:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D84D35D9CC;
	Fri,  5 Feb 2021 18:39:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ABC9A4E58E;
	Fri,  5 Feb 2021 18:39:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 115IdDsZ010087 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Feb 2021 13:39:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 810A710021AA; Fri,  5 Feb 2021 18:39:13 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C9E3101E242;
	Fri,  5 Feb 2021 18:39:10 +0000 (UTC)
Date: Fri, 5 Feb 2021 13:39:09 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Message-ID: <20210205183909.GA4722@redhat.com>
References: <20210202033528.76166-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20210202033528.76166-1-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: joseph.qi@linux.alibaba.com, msb@chromium.org, dm-devel@redhat.com,
	toshi.kani@hpe.com, mbroz@redhat.com
Subject: Re: [dm-devel] dm: fix iterate_device sanity check
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 01 2021 at 10:35pm -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> According to the definition of dm_iterate_devices_fn:
>  * This function must iterate through each section of device used by the
>  * target until it encounters a non-zero return code, which it then returns.
>  * Returns zero if no callout returned non-zero.
> 
> For some target type (e.g., dm-stripe), one call of iterate_devices() may
> iterate multiple underlying devices internally, in which case a non-zero
> return code returned by iterate_devices_callout_fn will stop the iteration
> in advance.
> 
> Thus if we want to ensure that _all_ underlying devices support some kind of
> attribute, the iteration structure like dm_table_supports_nowait() should be
> used, while the input iterate_devices_callout_fn should handle the 'not
> support' semantics. On the opposite, the iteration structure like
> dm_table_any_device_attribute() should be used if _any_ underlying device
> supporting this attibute is sufficient. In this case, the input
> iterate_devices_callout_fn should handle the 'support' semantics.
> 
> Fixes: 545ed20e6df6 ("dm: add infrastructure for DAX support")
> Fixes: c3c4555edd10 ("dm table: clear add_random unless all devices have it set")
> Fixes: 4693c9668fdc ("dm table: propagate non rotational flag")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>

Thanks for auditing and fixing this up.  It has been on my todo so
you've really helped me out -- your changes look correct to me.

I've staged it for 5.12, the stable fix will likely need manual fixups
depending on the stable tree... we'll just need to assist with
backport(s) as needed.

Thanks again,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

