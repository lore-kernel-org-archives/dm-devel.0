Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB763C6FD18
	for <dm-devel@archiver.kernel.org>; Tue, 28 Mar 2023 13:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680011432;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mD5Fs5rUEKeKZ1OjMij2IZ9azNDPI/ngbCnsbWvf+NY=;
	b=QwRdgqdMnQSmK1fvLpQ8lzRQ5YBTPBx/3CxXSW0GaLiapRo1+9JtJTVLnRJNlbdBMWAakD
	heW/b+YoNK6bp+6htJcWyhVr7sDpr9SO71E2XQPbt5Ezv5/tUQzlQLlmq/iiWzMIZO/Urh
	gdrRefdJGgZDjnBZrOSnVVq/SjuNfmk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-jHdmNUgoMeS0Ngo5V8aJmA-1; Tue, 28 Mar 2023 09:50:31 -0400
X-MC-Unique: jHdmNUgoMeS0Ngo5V8aJmA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E603382C97A;
	Tue, 28 Mar 2023 13:50:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E42081121330;
	Tue, 28 Mar 2023 13:50:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CF896194658C;
	Tue, 28 Mar 2023 13:50:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0658C1946589
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Mar 2023 13:50:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE1BE492B01; Tue, 28 Mar 2023 13:50:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D9AD492C3E;
 Tue, 28 Mar 2023 13:50:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 32SDoGat030650;
 Tue, 28 Mar 2023 08:50:16 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 32SDoFtw030649;
 Tue, 28 Mar 2023 08:50:15 -0500
Date: Tue, 28 Mar 2023 08:50:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230328135015.GO19878@octiron.msp.redhat.com>
References: <20230323205358.29724-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230323205358.29724-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] libmultipath: use directio checker for LIO
 targets
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 23, 2023 at 09:53:58PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> LIO always responds with GOOD status to TUR. Thus TUR is
> not useful as path checker for LIO targets.
> 
> Fixes https://github.com/opensvc/multipath-tools/issues/54
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/hwtable.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 3c4f866..c2a024c 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1067,6 +1067,7 @@ static struct hwentry default_hw[] = {
>  		.pgfailback    = -FAILBACK_IMMEDIATE,
>  		.no_path_retry = 12,
>  		.prio_name     = PRIO_ALUA,
> +		.checker_name  = DIRECTIO,
>  	},
>  	/*
>  	 * DataCore
> -- 
> 2.39.2
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

