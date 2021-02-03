Return-Path: <SRS0=/TsO=HF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 132FAC433E0
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 19:31:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 76F5160295
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 19:31:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76F5160295
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612380675;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=U+4mi27xrV9eo2EziflWVLuqse4Wj3L9zxWIRu96HE0=;
	b=RjnhAummwXxavF4gykZpxqX5JKCHsO054VZGYOayO6AI8GhdBGkCaWsdbkrun/0Z9gVvF7
	HMcgM+Q5HteBw9/npV3xXxWomx9EdjtZF6CBDisiC0Gf2yLzw7zhn8IQEE7WQZVefzTYcc
	5o+FVEoAvnWxEgEm7KMEuJOepblADgw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-vttM_rt3Oo6HszFQCjczgQ-1; Wed, 03 Feb 2021 14:31:13 -0500
X-MC-Unique: vttM_rt3Oo6HszFQCjczgQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A4F4180A09B;
	Wed,  3 Feb 2021 19:31:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 890D05D9E8;
	Wed,  3 Feb 2021 19:31:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6333F57DFA;
	Wed,  3 Feb 2021 19:31:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 113JUxPc005438 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 14:30:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 19026722C6; Wed,  3 Feb 2021 19:30:59 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 317F450DE3;
	Wed,  3 Feb 2021 19:30:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 113JUr6I021179; 
	Wed, 3 Feb 2021 13:30:53 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 113JUqw3021178;
	Wed, 3 Feb 2021 13:30:52 -0600
Date: Wed, 3 Feb 2021 13:30:52 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210203193052.GA15006@octiron.msp.redhat.com>
References: <20210202214131.19901-1-mwilck@suse.com>
	<20210202214131.19901-3-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210202214131.19901-3-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 2/3] multipathd: ev_add_path: fail if
 add_map_with_path() fails
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

On Tue, Feb 02, 2021 at 10:41:30PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If start_waiter was set before and the "rescan" label was used,
> we may try to set up an empty/invalid map.
> Always fail if add_map_with_path() isn't successful.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

This patch looks fine, but I don't think that there was any risk before.
I don't see how you could loop back to rescan with mpp == NULL, which
is what would need to happen before you could ever run this code.
At any rate

Reviewed-by: Benjamin Marzinski <bmarzin@redhat.com>
> ---
>  multipathd/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 43d7768..425492a 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1028,7 +1028,7 @@ rescan:
>  			 */
>  			start_waiter = 1;
>  		}
> -		if (!start_waiter)
> +		else
>  			goto fail; /* leave path added to pathvec */
>  	}
>  
> -- 
> 2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

