Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C1DDC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 00:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647909275;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jykPp6PKjhPb9GCGDTtCenQKatg7tOigAhX5586lleM=;
	b=GFWxxF+/HMYMrQG13mhR3FMWTaMB3/hxfvBUdqgAGFpMuIcjBR201FLArYPTa6akY2Gsaz
	xMVYKshWr17JrH94jUXNjmu5RqaDzvxBDpH4c/kpsw1WpjYpr8K9XrZUmOVsPvWZGc/Py2
	cIIi1F7HT0Pa72XinePrGbsu0fmDi9M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-LNNekqzLM6SEd2UerWZ29w-1; Mon, 21 Mar 2022 20:34:32 -0400
X-MC-Unique: LNNekqzLM6SEd2UerWZ29w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82F6D185A79C;
	Tue, 22 Mar 2022 00:34:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F030B776C;
	Tue, 22 Mar 2022 00:34:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 899981947BBE;
	Tue, 22 Mar 2022 00:34:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 045851947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 00:34:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B0ABB4B8D4D; Tue, 22 Mar 2022 00:34:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AD3E14B8D64
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:34:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7ED021C0B040
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:34:27 +0000 (UTC)
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-wUU_OvtmOduiymvCXMf0lg-1; Mon, 21 Mar 2022 20:34:26 -0400
X-MC-Unique: wUU_OvtmOduiymvCXMf0lg-1
Received: by mail-lf1-f72.google.com with SMTP id
 s17-20020ac25ff1000000b0044877550d2aso4133574lfg.2
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 17:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=0dd+Xth9DxEUdwiuw9hX6hwRBPlJZi9rPF2cLej3im4=;
 b=MEPwa/S/KYiEPuEO5aW41m/dwcoZE1ynfPQ+6+XorQMveH9xVz/ifQnVTeyENxNFAr
 cZaE3jFQo3IN5OxAqY0l6BjkB2BaggbY6BQbOUc9wSBLrFzYMOEojPWldyoVahV3aXbI
 /mKBGWtSw9uDVmtDKuU+LvcR3G9bXsozdt/lKkl4ZDvDmszazxZNOTadt/WK78yb0Ofe
 LXH4dCTel346wIE9t+ixvxOtXTLdwScIpoUMe2en9srA66aulMrinPu6yX67ZHhYE4zU
 tiNr/jirEKpNOFQTkk7dsbU8XZcZjtsdV6vJjU6G5aIbbHnivuKy1phYfX66rNrOixZG
 G2kA==
X-Gm-Message-State: AOAM533SpgX4rA9YAFWcNhWtpqSh8atXSIfp2eRBrv4BOQH49V6JtAX/
 tyxEsF3mLqStUxXdQhmm18iXEMDs5tc1E2sdTbrJYEd5vHXcbFsWu2DGSQ+cuKjwT7OgybVghNU
 UXuS4QYWJC0G6YgqQugjVtl6tbdZjEOs=
X-Received: by 2002:a19:910f:0:b0:44a:1343:706d with SMTP id
 t15-20020a19910f000000b0044a1343706dmr10059401lfd.337.1647909264499; 
 Mon, 21 Mar 2022 17:34:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwHnTOIIoyC1nPWoJhyCJ4e7b8F+lFlL1cpQvMbt42Y+e1CwVTMuIJSVJVgqPmH1g/QX7mF/9kKo0i68Z5vI8=
X-Received: by 2002:a19:910f:0:b0:44a:1343:706d with SMTP id
 t15-20020a19910f000000b0044a1343706dmr10059396lfd.337.1647909264334; Mon, 21
 Mar 2022 17:34:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-8-mwilck@suse.com>
In-Reply-To: <20220318223339.4226-8-mwilck@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 21 Mar 2022 19:34:13 -0500
Message-ID: <CAPt1nt5ntVjCJYVF8B7+uvjoypoUSdGChc3G+jycRHte-V2BOA@mail.gmail.com>
To: mwilck@suse.com
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2 07/11] multipathd: use remove_map_callback
 for delayed reconfigure
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
> If multipathd needs to delay reconfigure() because it's waiting for a map
> creation uevent, it can happen that child() isn't woken up if the map
> being waited for is removed before the uevent arrives. Fix this by
> unblocking reconfigure() with the remove_map_callback() function.
>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index f3b8eb4..4721cd8 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -319,6 +319,17 @@ static bool unblock_reconfigure(void)
>         return was_delayed;
>  }
>
> +/*
> + * Make sure child() is woken up when a map is removed that multipathd
> + * is currently waiting for.
> + * Overrides libmultipath's weak symbol by the same name
> + */
> +void remove_map_callback(struct multipath *mpp)
> +{
> +       if (mpp->wait_for_udev > 0)

Is there a reason why you don't decrement wait_for_udev, and check
need_to_delay_reconfig() like in ev_add_map()? I realize that it
doesn't hurt anything to unblock the reconfigure even if there are
other devices that need a delay. The main thread will notice that it
still needs to delay. I'm just wondering why we do it differently
here?

-Ben

> +               unblock_reconfigure();
> +}
> +
>  void schedule_reconfigure(enum force_reload_types requested_type)
>  {
>         pthread_mutex_lock(&config_lock);
> --
> 2.35.1
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

