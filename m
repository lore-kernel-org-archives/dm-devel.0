Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 988D4C636CD
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 16:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675268464;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K2HHBzxArZS/KxHzip8JbuPC16HoV8NO2SJw1vhAMfk=;
	b=OeYE5JeCcjUipxIquZViNybxxLT7c908jymMdPcRGqk5yoGV2mwVed40q6e3lOPWrH+8W8
	g1ReKFBjNXFmNoDS8Mo7FqDey+lvjcD8GrfgJ/ycF2zXWrydzhzZEGAFHNIn8tEnbz1xxw
	95TVyEl/ldl8k4Urz8zFj+oiiTVRCV0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-uIGVDorfMPeMuEvuF0WuxQ-1; Wed, 01 Feb 2023 11:21:03 -0500
X-MC-Unique: uIGVDorfMPeMuEvuF0WuxQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3185F85CCE1;
	Wed,  1 Feb 2023 16:21:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ACFE1112132C;
	Wed,  1 Feb 2023 16:20:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6BD9519465A3;
	Wed,  1 Feb 2023 16:20:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 02D85194658F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 16:20:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 72FCBC16021; Wed,  1 Feb 2023 16:20:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BD8FC15BAE
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 16:20:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D08C85CCE8
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 16:20:47 +0000 (UTC)
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com
 [209.85.160.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-467-6METVoL9NQe1SzjtyEX2IQ-1; Wed, 01 Feb 2023 11:20:45 -0500
X-MC-Unique: 6METVoL9NQe1SzjtyEX2IQ-1
Received: by mail-qt1-f173.google.com with SMTP id m12so6036299qth.4
 for <dm-devel@redhat.com>; Wed, 01 Feb 2023 08:20:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=noq+YbeE236EHFR6uS+msxJQ+c1izg5uQQ3Qx3fszIw=;
 b=f3EUpQcOKCgY1E+15/zBLSkoz1suhBPpjF7KbczRb23Krvd/quWIpE5mYg3bGbSMtR
 +3b6RRG4EndKvWtMWs9eCXxfiRaCxyGAdTHKGU8pFsCwmgPdxwK8QvkvUAHMNcon9u20
 I9S+VehdDxJRK47u8H/DtLA03rpItqR5Tplsf+u/RWHAam564+3LeeYspIWTlPkZwM3U
 ewTLlp1E/rOkWcXhMlFjmh6ycQ3bHBaDpkIRRVN4gO5cL8AGLIvtLa/gCJ4nvbTFsWLa
 wDhdVQUqg85ipvSbxlOphmRkfHn4WSLN44mR2Bx/XV46WNqyWdsfeZSwlV51YAK7J3YH
 WmrQ==
X-Gm-Message-State: AO0yUKV80NG4S06IVd/3o4lbZnRKsGcM1uzwG65iumboje3c65X0CDQf
 T3lTfvXioSyZofSbHk5QQecVn1c=
X-Google-Smtp-Source: AK7set8N3mTDGMBP/PwPPPAWv/Z9SzXUrzgDxsKRoKrK9xXlffAgw2mOCczQv7shZ9LLEmCYz4Ml8w==
X-Received: by 2002:a05:622a:1a1a:b0:3b9:a4cc:1df with SMTP id
 f26-20020a05622a1a1a00b003b9a4cc01dfmr5467047qtb.57.1675268445094; 
 Wed, 01 Feb 2023 08:20:45 -0800 (PST)
Received: from localhost ([66.187.232.66]) by smtp.gmail.com with ESMTPSA id
 o8-20020ac80248000000b003b64f1b1f40sm12037346qtg.40.2023.02.01.08.20.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Feb 2023 08:20:44 -0800 (PST)
Date: Wed, 1 Feb 2023 11:20:43 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Tomas Melin <tomas.melin@vaisala.com>
Message-ID: <Y9qRW5AEXZL0jLnF@redhat.com>
References: <20230131111552.24349-1-tomas.melin@vaisala.com>
MIME-Version: 1.0
In-Reply-To: <20230131111552.24349-1-tomas.melin@vaisala.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] md: dm-table: ensure dev_t is initialized
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
Cc: dm-devel@redhat.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 31 2023 at  6:15P -0500,
Tomas Melin <tomas.melin@vaisala.com> wrote:

> Avoid returning uninitialized value in case
> lookup fails.
> 
> Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
> ---
>  drivers/md/dm-table.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 8fc44c9f746a..71c59455bf3b 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -331,7 +331,7 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
>   */
>  dev_t dm_get_dev_t(const char *path)
>  {
> -	dev_t dev;
> +	dev_t dev = 0;
>  
>  	if (lookup_bdev(path, &dev))
>  		dev = name_to_dev_t(path);

dev_t dm_get_dev_t(const char *path)
{
        dev_t dev;

        if (lookup_bdev(path, &dev))
                dev = name_to_dev_t(path);
        return dev;
}

If lookup fails then:
                dev = name_to_dev_t(path);

name_to_dev_t() will initialize dev no matter what.

Nacked-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

