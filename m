Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58833C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  1 Apr 2022 14:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648824448;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PsnpzMNUNeRNCK1O8CvSn5A3+tiwVJYSSC6LHjQKtIM=;
	b=PsfmiYaj8wzpKb0eAS1LmhXe82jQIwXidQDRMVcWX8JhwbTc33OOR1ef9C3FOFTk498CG9
	S+Tu5LSxykWg6xoiY5IyqnieyeUEwBhvIPJsILy+XkjE62FOG2dqr3F/JssAAftJozW+9I
	khFvVeRFkDAYrS7UScWdlfACRFYmxWc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-aEkwypeQPFK3lUlBAjOwhQ-1; Fri, 01 Apr 2022 10:47:27 -0400
X-MC-Unique: aEkwypeQPFK3lUlBAjOwhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C959899EC1;
	Fri,  1 Apr 2022 14:47:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1EA1940CFD0B;
	Fri,  1 Apr 2022 14:47:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E89191947BBF;
	Fri,  1 Apr 2022 14:47:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8C87E1947BBE
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Apr 2022 14:47:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7DF5C40E8842; Fri,  1 Apr 2022 14:47:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 79EA440E8841
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 14:47:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FA3C83395E
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 14:47:24 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-KszjGaKUOz2B6xqcl8V0pw-1; Fri, 01 Apr 2022 10:47:20 -0400
X-MC-Unique: KszjGaKUOz2B6xqcl8V0pw-1
Received: by mail-qk1-f198.google.com with SMTP id
 207-20020a3703d8000000b0067b14f0844dso1966262qkd.22
 for <dm-devel@redhat.com>; Fri, 01 Apr 2022 07:47:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ubFWiDA1LlelDhe80vrrUD2k2vJd+0aq256Lv6ITnp4=;
 b=cPxnF7TAeIMR2lIY85wKI79dS0XxpbiExZ7TdnsrZsTsLgdpwbCGGYVB/auwIEy9J2
 BM9KHvlbNfcF3pzvY8njYnoMUQDIGSQ/nVV0ESlI5Es8sh/7eo0BviusSwkTwIbkkObP
 ko9Zy4yVr6xhxUatIh13IKczJZjQgpZ7CAY+/RBPrGTCQmDNu+j7unCSj0/QeDBRJ5oY
 jO/p9tUUBAYF/PQ2OVOREVBs8vWmI7SGEpg9E9Gyx0+in+dcJRC1478KGWzEg4rgs+aR
 l1ucWySd2YLZUVE/zCPZhmSDncfqzy9G9LgafPRPaObl0OEpXf3ZZCU1ztxvhhFxQ1xX
 IGMQ==
X-Gm-Message-State: AOAM533EmjF+flFHlY9SryOEY3wJcSeHYufTT0P3hPPqfcpgZvpTU1Fe
 ySK1iM0S1RMJZ/afAVqot86trfpXdxSQXpByZhCz3O8GkkNgBdFHwC124b2eLnKCx8n7JutfqpA
 Jq57ALpcuZkZERw==
X-Received: by 2002:a05:620a:24c7:b0:67f:9270:4b6a with SMTP id
 m7-20020a05620a24c700b0067f92704b6amr6635672qkn.52.1648824440263; 
 Fri, 01 Apr 2022 07:47:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQRpmdsYnSYXtR8AnJ7zoL6DR0xqqC0MlDkItb7ArARcr3IO6CN0vjf0PcccOnDEIXfYu9qA==
X-Received: by 2002:a05:620a:24c7:b0:67f:9270:4b6a with SMTP id
 m7-20020a05620a24c700b0067f92704b6amr6635649qkn.52.1648824439903; 
 Fri, 01 Apr 2022 07:47:19 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 q204-20020a3743d5000000b0067ece232979sm1374993qka.116.2022.04.01.07.47.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Apr 2022 07:47:19 -0700 (PDT)
Date: Fri, 1 Apr 2022 10:47:18 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Message-ID: <YkcQdjE6uTfScyEy@redhat.com>
References: <20220327053742.2942-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20220327053742.2942-1-xiam0nd.tong@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] md: fix missing check on list iterator
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
Cc: stable@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Mar 27 2022 at  1:37P -0400,
Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:

> The bug is here:
>     bypass_pg(m, pg, bypassed);
> 
> The list iterator 'pg' will point to a bogus position containing
> HEAD if the list is empty or no element is found. This case must
> be checked before any use of the iterator, otherwise it will lead
> to a invalid memory access.
> 
> To fix this bug, run bypass_pg(m, pg, bypassed); and return 0
> when found, otherwise return -EINVAL.
> 
> Cc: stable@vger.kernel.org
> Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/md/dm-mpath.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index f4719b65e5e3..6ba8f1133564 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1496,12 +1496,13 @@ static int bypass_pg_num(struct multipath *m, const char *pgstr, bool bypassed)
>  	}
>  
>  	list_for_each_entry(pg, &m->priority_groups, list) {
> -		if (!--pgnum)
> -			break;
> +		if (!--pgnum) {
> +			bypass_pg(m, pg, bypassed);
> +			return 0;
> +		}
>  	}
>  
> -	bypass_pg(m, pg, bypassed);
> -	return 0;
> +	return -EINVAL;
>  }
>  
>  /*
> -- 
> 2.17.1
> 

Did you acually hit a bug (invalid memory access)?

I cannot see how given the checks prior to iterating m->priority_groups:

        if (!pgstr || (sscanf(pgstr, "%u%c", &pgnum, &dummy) != 1) || !pgnum ||
            !m->nr_priority_groups || (pgnum > m->nr_priority_groups)) {
                DMWARN("invalid PG number supplied to bypass_pg");
                return -EINVAL;
        }

So I have _not_ taken your "fix".

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

