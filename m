Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6BB7C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 00:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647909370;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ozyv0XhURgD7VzYEelodYGgioZMMWQFACsMv6Ui/K5Q=;
	b=b74UB67vrDxrZs499vyru1LeiK1SjT4YnQpx1srDUCJH7bi+G528XSFX1zqKnGCJs+725+
	14InbP1AcZSPXsrOuDN9B/W6bwYH8QyeNFp3BqZ9fd5c6bS+8PCCMSoyvz5dJxdAvHOLPH
	zKjor/tixDInDcreJUIv2SN0Cy+iwE0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-Fz3uVwGhPk-f4pNWTipIrw-1; Mon, 21 Mar 2022 20:36:06 -0400
X-MC-Unique: Fz3uVwGhPk-f4pNWTipIrw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E5B1811E76;
	Tue, 22 Mar 2022 00:36:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6C5C946A0D4;
	Tue, 22 Mar 2022 00:36:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 390BF1947BBE;
	Tue, 22 Mar 2022 00:36:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B9BBB1947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 00:36:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A695CC26E9A; Tue, 22 Mar 2022 00:36:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A2AECC26EA1
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:36:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8712185A5BE
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:36:02 +0000 (UTC)
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-k6tAHwyAM5eu_lH5enHeqw-1; Mon, 21 Mar 2022 20:36:01 -0400
X-MC-Unique: k6tAHwyAM5eu_lH5enHeqw-1
Received: by mail-lj1-f197.google.com with SMTP id
 e3-20020a2e9303000000b00249765c005cso3201912ljh.17
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 17:36:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=aG+/w5jPulTPWmJx4HYSeLKqHOGmQjsyRIJAx+OfEMM=;
 b=XsyOsv3I8J7LTM3zSzUMPCJqgaHGTnxV/+/rWlI7yPq09B864ugI8ATKvThv8QORvK
 HYsg9bzpKVxZtNN6m2OkKyrmc0Ph6F3yzLnGE72CwYtjeWipebxr294RWzg8iBNvC3Jy
 9fazLd3Jg3q2yzlgIpmiMOJv+7eMcvv/Qqsv8lPP9kyIJuZ39dYbpakxsYhA65AjBljX
 +jaFolpjJwj/X2lSIjI7SlTnD4PlOAZy3ZIg1giQyYnSmtcl/EO5TaziMuzDsmFZGhJd
 fu4io5F2LNl8ylzlPDhA5ons0hcGAFpIZM6nAw9zeBabluXuI3Mt4dXiKeQ1P7XrfONO
 wBvQ==
X-Gm-Message-State: AOAM533QlMxsq5j2Dhs3gynrkA0Gl+Z6RMEWOLOr7J4Jfd/o64hf8h7F
 drvGJbdvvhGKxuHz5bMx5p9NlkJ3BjZ8qTW0U/8S43IX0aYO1690C86OEdi7HDFSsapYZxlX/pH
 mgul2mDWenWvTQuqjr8kD1TdVMvYem7I=
X-Received: by 2002:a05:6512:3f0a:b0:44a:e3f:2862 with SMTP id
 y10-20020a0565123f0a00b0044a0e3f2862mr11703326lfa.397.1647909359811; 
 Mon, 21 Mar 2022 17:35:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuMXSBByM2P100Pgs/4YGi+41nlKMl9IkaYmOxtg5+vnKTs0BVcsarFe3DHUVwZoFeeIAdYzHAs97m2d1JUqI=
X-Received: by 2002:a05:6512:3f0a:b0:44a:e3f:2862 with SMTP id
 y10-20020a0565123f0a00b0044a0e3f2862mr11703316lfa.397.1647909359666; Mon, 21
 Mar 2022 17:35:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-10-mwilck@suse.com>
In-Reply-To: <20220318223339.4226-10-mwilck@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 21 Mar 2022 19:35:48 -0500
Message-ID: <CAPt1nt4y15sr9jEagLt14wHEb-WVYuZ4w9KzgHdOnEu5um_5Qw@mail.gmail.com>
To: mwilck@suse.com
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 09/11] multipathd: improve logging of
 reconfigure()
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
> Print a message when reconfigure() actually starts doing something,
> and when a reconfigure() call is delayed.
>
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  multipathd/main.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 4721cd8..e841ba8 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2840,6 +2840,7 @@ reconfigure (struct vectors *vecs, enum force_reload_types reload_type)
>         if (verbosity)
>                 libmp_verbosity = verbosity;
>         setlogmask(LOG_UPTO(libmp_verbosity + 3));
> +       condlog(2, "%s: setting up paths and maps", __func__);
>
>         /*
>          * free old map and path vectors ... they use old conf state
> @@ -3419,6 +3420,7 @@ child (__attribute__((unused)) void *param)
>                         pthread_mutex_lock(&config_lock);
>                         __delayed_reconfig = true;
>                         pthread_mutex_unlock(&config_lock);
> +                       condlog(3, "delaying reconfigure()");
>                 }
>                 lock_cleanup_pop(vecs->lock);
>                 if (!rc)
> --
> 2.35.1
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

