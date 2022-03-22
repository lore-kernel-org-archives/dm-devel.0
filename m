Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E9FC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 00:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647909827;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5ZBjAdTnyw8ZRW+M1spn6P2XUIfGF+usZ+Br8M8/S+s=;
	b=S86BkQorITYO0zm+bLH5qnCEIQ4YiUEQSmZeyEzs2VVmg3/Flz6zecw6cdmX9WXyFAamwy
	1Y0ohZgh+e+3dLfEnlKmmWdhJDqpMMIHr0GJ2hduawOXCMje+9P/2SBwUv51olgushjAOA
	ZY2vHLYKgWAlxPhpohkom9RRNUPikj8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-s5o-UuGrN-6AvoVeqG5QNg-1; Mon, 21 Mar 2022 20:43:45 -0400
X-MC-Unique: s5o-UuGrN-6AvoVeqG5QNg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12957185A7A4;
	Tue, 22 Mar 2022 00:43:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9F86846A0DD;
	Tue, 22 Mar 2022 00:43:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4D3BE1947BBE;
	Tue, 22 Mar 2022 00:43:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 68BB11947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 00:43:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 52AE0140242B; Tue, 22 Mar 2022 00:43:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F3851400E76
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:43:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 371BD38008A1
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:43:42 +0000 (UTC)
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-URqs1Do9N9eoRuXYA0AH5A-1; Mon, 21 Mar 2022 20:43:40 -0400
X-MC-Unique: URqs1Do9N9eoRuXYA0AH5A-1
Received: by mail-lf1-f72.google.com with SMTP id
 x26-20020a056512131a00b00448708fa822so4154089lfu.6
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 17:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VNilxV2LOF0HwzB7Hz37/xhD41weyx3bnZBZpfWXWI0=;
 b=8Kjzk4wvf/MNrI0YEEvt2yS95YTzoV6fQ2vvWtirHg8WZFE282oPVaAFaoFiKMmRse
 B+FukGZj0HUFi57abkzA9hvus0hoK8gjqr3fScJAn1Ag5V/7+HsVPtoVMffukv5eRZAo
 qHaWj1eibuAKnzl/FXkGgWqP2Mz45jUuaj9OqXLYWKh+nLScINNFH6UVTtd899aTBOFK
 RSSb1PSS9NYqp5kEw9OQMnryTXsaMnseXyXL+vQwDFpRg/hjDyLwbz+d0pVeZWEz9pLa
 PXKbuH/oqSTW1lA+mqEYQUI6GVP6qWle5T2eJSnxPki+KhptkwwGlulCIOxArkARFb+3
 3JqA==
X-Gm-Message-State: AOAM531Mm6ep6TMMmqzkd9IKMegRCMZZELUATvGVGuuQ6nVNRn6eSu4+
 q/hhV9pYbnR63Wi+gvjLJ+HtA+UPvbswOUaPDaYDcQts5XxcuXow7xcv/6VTwO2M50Ri89JoXtk
 YZJByt0N3l+yrNr13J5BEkL40tgDPcEk=
X-Received: by 2002:a2e:a372:0:b0:249:7108:6778 with SMTP id
 i18-20020a2ea372000000b0024971086778mr12633751ljn.403.1647909819327; 
 Mon, 21 Mar 2022 17:43:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgwINrVSdYMEghIWoL7uAnSsIW4ULH1mou4lQ9+ivUNL76QFSj1B6y2n68sXlDY5f9GYW2ATWG3dn1JOfr/Jg=
X-Received: by 2002:a2e:a372:0:b0:249:7108:6778 with SMTP id
 i18-20020a2ea372000000b0024971086778mr12633743ljn.403.1647909819137; Mon, 21
 Mar 2022 17:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-12-mwilck@suse.com>
In-Reply-To: <20220318223339.4226-12-mwilck@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 21 Mar 2022 19:43:28 -0500
Message-ID: <CAPt1nt4Ug=Z0mn1TUzmKevYqm3Uqy-sGXBc9rQRdZUgHFi3i9g@mail.gmail.com>
To: mwilck@suse.com
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v2 11/11] multipathd: remove unhelpful
 startup / shutdown messages
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
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 18, 2022 at 5:33 PM <mwilck@suse.com> wrote:
>
> From: Martin Wilck <mwilck@suse.com>
>
> These messages are noisy in the system log without being actually helpful.

I've actually found the "start up" and "shut down" messages useful a
number of times, for tracking when multipathd starts up and shuts
down. Since people generally run multipathd constantly, they rarely
appear more than a couple of times per boot. I would prefer if they
could stay.  I'm fine with removing the others.

-Ben

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 4b4fa9c..6e6635b 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2560,7 +2560,6 @@ checkerloop (void *ap)
>         rcu_register_thread();
>         mlockall(MCL_CURRENT | MCL_FUTURE);
>         vecs = (struct vectors *)ap;
> -       condlog(2, "path checkers start up");
>
>         /* Tweak start time for initial path check */
>         get_monotonic_time(&last_time);
> @@ -3241,8 +3240,7 @@ child (__attribute__((unused)) void *param)
>
>         post_config_state(DAEMON_START);
>
> -       condlog(2, "--------start up--------");
> -       condlog(2, "read " DEFAULT_CONFIGFILE);
> +       condlog(3, "read " DEFAULT_CONFIGFILE);
>
>         if (verbosity)
>                 libmp_verbosity = verbosity;
> @@ -3435,7 +3433,6 @@ child (__attribute__((unused)) void *param)
>
>         exit_code = 0;
>  failed:
> -       condlog(2, "--------shut down-------");
>         /* All cleanup is done in the cleanup_child() exit handler */
>         return sd_notify_exit(exit_code);
>  }
> --
> 2.35.1
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

