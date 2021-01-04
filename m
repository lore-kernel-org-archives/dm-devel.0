Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702C3C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 20:28:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E298C2072C
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 20:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E298C2072C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1609792086;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=99kjQEEXbVP5jIIhYB9UVyALcf6tO1j+RNzpk8TSzh8=;
	b=h89rKM1tU4dQuKGOJVk5fyM8chsishc0u7YXcPgh3bwluoMbWwKK3kLjGGcHfIYCQ/0U8a
	z+ID0oZ1DidmyWJ7SZCWORDjjIlKnS2t4Vc9qgyP+kP/S/s9ZF4IgGGamj5vQtyoC3Pudq
	3iMs03GmSvVsFhgCMnHEZx44se2ikfk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-qfgFYhYuORKzEifWoYosxQ-1; Mon, 04 Jan 2021 15:28:05 -0500
X-MC-Unique: qfgFYhYuORKzEifWoYosxQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7693C107ACE4;
	Mon,  4 Jan 2021 20:28:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 89B505D9C6;
	Mon,  4 Jan 2021 20:27:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 92AA14BB7B;
	Mon,  4 Jan 2021 20:27:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 104KRspY031769 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 15:27:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2975171C8E; Mon,  4 Jan 2021 20:27:54 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A86B517250;
	Mon,  4 Jan 2021 20:27:50 +0000 (UTC)
Date: Mon, 4 Jan 2021 15:27:50 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Defang Bo <bodefang@126.com>
Message-ID: <20210104202749.GA3721@redhat.com>
References: <1608878926-2283057-1-git-send-email-bodefang@126.com>
MIME-Version: 1.0
In-Reply-To: <1608878926-2283057-1-git-send-email-bodefang@126.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] dm snap : add sanity checks to snapshot_ctr
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

On Fri, Dec 25 2020 at  1:48am -0500,
Defang Bo <bodefang@126.com> wrote:

> Similar to commit<70de2cbd>,there should be a check for argc and argv to prevent Null pointer dereferencing
> when the dm_get_device invoked twice on the same device path with differnt mode.
> 
> Signed-off-by: Defang Bo <bodefang@126.com>
> ---
>  drivers/md/dm-snap.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
> index 4668b2c..dccce8b 100644
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -1258,6 +1258,13 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  
>  	as.argc = argc;
>  	as.argv = argv;
> +
> +	if (!strcmp(argv[0], argv[1])) {
> +		ti->error = "Error setting metadata or data device";
> +		r = -EINVAL;
> +		goto bad;
> +	}
> +
>  	dm_consume_args(&as, 4);
>  	r = parse_snapshot_features(&as, s, ti);
>  	if (r)
> -- 
> 2.7.4
> 

We already have this later in snapshot_ctr:

        if (cow_dev && cow_dev == origin_dev) {
                ti->error = "COW device cannot be the same as origin device";
                r = -EINVAL;
                goto bad_cow;
        }

Which happens before the 2nd dm_get_device() for the cow device.  So
I'm not seeing how you could experience the NULL pointer you say is
possible.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

