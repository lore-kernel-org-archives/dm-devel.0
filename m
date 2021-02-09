Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F4BC43381
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 13:51:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BFD8064ED5
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 13:51:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFD8064ED5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612878705;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=l4jbvNe5kr6KqJzH32o5gz1w73usR6QOLhrITkAgAkk=;
	b=YkglawCOj0Le50RPP+tpiXNmyxedMYMd5CBtxbpWhsPQV6RCVHIqdL8T8BOuEf71LquRIC
	4hmAK+mcYjQ2ELQCmsvi67Nl502FyPWcDnNPwps7pf/en2VOiNpQed+qpg3QKbrJEFosSM
	7MtAnprFv9qvI3ape6TqVVDSSTpvyKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-su5U9hVFPGGUawI5JMwGvA-1; Tue, 09 Feb 2021 08:51:42 -0500
X-MC-Unique: su5U9hVFPGGUawI5JMwGvA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6FC3107ACE4;
	Tue,  9 Feb 2021 13:51:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C5E55C3E6;
	Tue,  9 Feb 2021 13:51:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0FF0A18095CB;
	Tue,  9 Feb 2021 13:51:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 119DpTad023008 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 08:51:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9606B60C61; Tue,  9 Feb 2021 13:51:29 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B56E60C04;
	Tue,  9 Feb 2021 13:51:25 +0000 (UTC)
Date: Tue, 9 Feb 2021 08:51:25 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <20210209135125.GA1548@redhat.com>
References: <20210202033528.76166-1-jefflexu@linux.alibaba.com>
	<20210205183909.GA4722@redhat.com>
	<59ca57e0-5a5f-33b6-24ed-90d615c40949@linux.alibaba.com>
	<20210208151700.GA22064@redhat.com>
	<20210209052959.GA25714@redhat.com>
	<cdecf30e-cb66-a1cc-b7e0-749953af1e19@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <cdecf30e-cb66-a1cc-b7e0-749953af1e19@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Feb 09 2021 at  2:06am -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> 
> 
> On 2/9/21 1:29 PM, Mike Snitzer wrote:
> > 
> > Hi, please see these commits that I've staged in linux-next via:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next
> > 
> > 1141b9133777 dm table: fix iterate_devices based device capability checks
> > 0224c5e6fd07 dm table: fix DAX iterate_devices based device capability checks
> > 76b0e14be03f dm table: fix zoned iterate_devices based device capability checks
> > 55cdd7435e97 dm table: remove needless request_queue NULL pointer checks
> > 
> 
> Thanks. This series looks good to me.
> 
> I suddenly find that the semantics of patch 1 (1141b9133777 dm table:
> fix iterate_devices based device capability checks) is a little
> different with the original context.
> 
> -	if (blk_queue_add_random(q) && dm_table_all_devices_attribute(t,
> device_is_not_random))
> +	if (dm_table_any_dev_attr(t, device_is_not_random))
>  		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
> +	else
> +		blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);
> 
> In the original context, QUEUE_FLAG_ADD_RANDOM will only be cleared, it
> won't be set, while it could be set after patch 1. But I could see no
> harm of setting QUEUE_FLAG_ADD_RANDOM flag though.
> 
> FYI. Currently only scsi devices are still using QUEUE_FLAG_ADD_RANDOM
> flag, as all non-rotational devices should not set this flag since
> commit b277da0a8a59 ("block: disable entropy contributions for nonrot
> devices").

I fixed it, thanks.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

