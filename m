Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8965CC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 00:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647908634;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t3c6iei/ph0eDEjWl3YpCDn5eEpJqEmhvNQ9ym5dI84=;
	b=PpKFyrurterQNQnSe6HJ2C64H6jjO5ZqEu4nCjUm2qikIJ+KoImzH4i10oYJBgqGn70vK5
	STddpxRbUON2OV3/Wizgyh45Lc1zjvZ2DtecxbcI/TBRtm4FuqApYF1/j5A2c/z1ydYB4/
	DviNINbJG4v70dBCMy/VOBBz7/6D3xk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-qeVxHnTzPXedyxdKJVUsSw-1; Mon, 21 Mar 2022 20:23:52 -0400
X-MC-Unique: qeVxHnTzPXedyxdKJVUsSw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 112241875067;
	Tue, 22 Mar 2022 00:23:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C1A341427AE4;
	Tue, 22 Mar 2022 00:23:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 65BF11947BBE;
	Tue, 22 Mar 2022 00:23:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0F2BD1947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 00:23:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B85DA1402427; Tue, 22 Mar 2022 00:23:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B4C1F140240A
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:23:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C1231C05AFD
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:23:47 +0000 (UTC)
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-qpBDLjDaP_e9xoSSZH1-wA-1; Mon, 21 Mar 2022 20:23:46 -0400
X-MC-Unique: qpBDLjDaP_e9xoSSZH1-wA-1
Received: by mail-lj1-f200.google.com with SMTP id
 6-20020a2eb946000000b002463d2915d2so6877664ljs.9
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 17:23:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Grv6crEACOLohA1wu6BXHq4/fC+qKmfR1pMektGckmU=;
 b=xW9OsCJUgHiBtR/dMRu+qIkEqM5zgvS3Qm9K6mSeEgG7CbxBL80Ec8h9OHYkOZ6mZu
 wWk/DaoCOg1RLjrnEblC7B5UZpxoCKUdMbAu+B3q/3lhljapVfI6Y91AX0uks7ztcyje
 yBTJDLUepgUJTWw9Og/C2stl5PcW1LI47KqxXhmc83yKMY5mdKghUuERsG/1QtpsyqgL
 dnAIMkVYiNUHvZwYGYzzUbUVwNIaQWyjjPNk2EV9f3iIwmsj/lF6xtoT3EZoFInqEtV8
 xluxb+/wWZuHOjNGj/P50k5xeK3EPji9WhFkhNKLJwAVOuhYa5296Y2omWDK/95xZ12l
 WXYg==
X-Gm-Message-State: AOAM532II7ob/s3z1ZLr06B0TeXe64ejsILLmNgCVDVlmTj7xQMs/XZK
 OGCjj1dsr080zRI84O71jyYUxq4r5h0MrME2VY+oiRaB2Ec6cdQce8ra8mTK5Gkcer9pnPc0rxQ
 /ZNmj8fVlBIWAoNyeRtZpsVh1LqcA2b4=
X-Received: by 2002:a05:651c:311:b0:23f:d9fc:9e89 with SMTP id
 a17-20020a05651c031100b0023fd9fc9e89mr16993229ljp.136.1647908624460; 
 Mon, 21 Mar 2022 17:23:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWgq/XuKXnM5nH9y22/tGbSsJusmqTKMCpPPGBWqLmLkC4HsFvvWgfROaPaRvAZZ+7tFn5x1wuo4W+bP1rjkk=
X-Received: by 2002:a05:651c:311:b0:23f:d9fc:9e89 with SMTP id
 a17-20020a05651c031100b0023fd9fc9e89mr16993219ljp.136.1647908624270; Mon, 21
 Mar 2022 17:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-6-mwilck@suse.com>
In-Reply-To: <20220318223339.4226-6-mwilck@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 21 Mar 2022 19:23:33 -0500
Message-ID: <CAPt1nt6M0hj+3_a1UwKxc2aJd+hc_91gmz_8oODq5=Ec68D02Q@mail.gmail.com>
To: mwilck@suse.com
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v2 05/11] multipathd: remove volatile
 qualifier from running_state
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
> running_state is only accessed while holding the config_lock, the
> volatile qualifier is superfluous.
>
> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  multipathd/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 1454a18..f3b8eb4 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -127,7 +127,7 @@ static int poll_dmevents = 0;
>  static int poll_dmevents = 1;
>  #endif
>  /* Don't access this variable without holding config_lock */
> -static volatile enum daemon_status running_state = DAEMON_INIT;
> +static enum daemon_status running_state = DAEMON_INIT;
>  /* Don't access this variable without holding config_lock */
>  static bool __delayed_reconfig;
>  pid_t daemon_pid;
> --
> 2.35.1
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

