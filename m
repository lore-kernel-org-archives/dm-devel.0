Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38212C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 00:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647909484;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vqolWqZSryOFCGSv+IlwVUZT9g9K3Hf7kU37SZ1MUH0=;
	b=Drpd7hH7wSnhNw5H7geVNLN/N7XFkKUa12LVxV8qm9sD2Gtbo8abkT+2NsdJhiKxPM1hmt
	r1QQb7yM/6nUvTDD7ucMMaDSX8S4F0J61YgFFywgLxkdnvF0VQ5ULU/tOqhJlzY03z8uZk
	R1vse8+Nm2xXdqzli2maEzb0brNyDis=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-tqb_oXAqPHyQ7NamvyteSA-1; Mon, 21 Mar 2022 20:38:01 -0400
X-MC-Unique: tqb_oXAqPHyQ7NamvyteSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28D071800744;
	Tue, 22 Mar 2022 00:37:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12F3E2026D07;
	Tue, 22 Mar 2022 00:37:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B06F51947BBE;
	Tue, 22 Mar 2022 00:37:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 02C381947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 00:37:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E50F976C4; Tue, 22 Mar 2022 00:37:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E0DA47774
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:37:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 926E3899EC5
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 00:37:53 +0000 (UTC)
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-BpXkUHK6PQ-0T89FSBANcQ-1; Mon, 21 Mar 2022 20:37:52 -0400
X-MC-Unique: BpXkUHK6PQ-0T89FSBANcQ-1
Received: by mail-lj1-f198.google.com with SMTP id
 f12-20020a2e918c000000b002496651f1d6so5151344ljg.0
 for <dm-devel@redhat.com>; Mon, 21 Mar 2022 17:37:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=+uSxq1TmRKBpu6eHr8pRcn9H2mls4H9KC5aW+qtpnyY=;
 b=5+t85RupeB8uriLmAYnHKIpp8BGY26IoEMoHC+23HIiK2u0jIc6+t8hLcHE0Qh2HRo
 a5xdntGGCHlGvsY+1XFsaSM9OgtDc8snARBixGXi/U4wyk9icGxBVTqNk4iW3VlEppAF
 Aly7fXyIKE8asbU2PFF/74LjGr88wOLM4qkTpqqgU6wn36EIxu+grt6i0XdxyY8x7+WU
 gbSlaHxJ40gNe8lS8p+cRAlZ0vw23M+HRKPUVHYaOJWjLmE22JQCcCsElP5iMwEk8bed
 wIzph5uy+V9+4vw33B8CAMU+4+TT/QKTQdvjS5OPWNEKd8e5dtNw8is/JP9OWP70NpIF
 Q7Lg==
X-Gm-Message-State: AOAM531Gyx95YOvrSRZ7YtwmgBhNmqXRjnUe0UtsDHsNbJWOxi5+29l/
 tlNeqWD/fQS5rTLt5eFbRz9ZV4Cq0wEZvaZK9RoboXaX3NXOn5Co6pBRNkDBBeUPk5S1wIR6rT7
 OFb+LQhJVMY9bJj8T9Fxe6eF9StysgNg=
X-Received: by 2002:a2e:a58d:0:b0:247:eb93:e747 with SMTP id
 m13-20020a2ea58d000000b00247eb93e747mr16697415ljp.153.1647909470754; 
 Mon, 21 Mar 2022 17:37:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZrIwrmmESxzhK2MZHmhqjpiIRGxH0RmPJ1W3IxJ2A4ifSMwsZ2esOqUXv9d2p70HKtl8IlkXedX+hQbBRMCc=
X-Received: by 2002:a2e:a58d:0:b0:247:eb93:e747 with SMTP id
 m13-20020a2ea58d000000b00247eb93e747mr16697410ljp.153.1647909470608; Mon, 21
 Mar 2022 17:37:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-11-mwilck@suse.com>
In-Reply-To: <20220318223339.4226-11-mwilck@suse.com>
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 21 Mar 2022 19:37:39 -0500
Message-ID: <CAPt1nt4Gk5AbW6DaAqxqGp2=2+ukMTYbm9AKp1omGy5M3s4A-A@mail.gmail.com>
To: mwilck@suse.com
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 10/11] multipathd: log state changes
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  multipathd/main.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index e841ba8..4b4fa9c 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -287,6 +287,8 @@ static void __post_config_state(enum daemon_status state)
>                 running_state = state;
>                 pthread_cond_broadcast(&config_cond);
>                 do_sd_notify(old_state, state);
> +               condlog(4, "daemon state %s -> %s",
> +                       daemon_status_msg[old_state], daemon_status_msg[state]);
>         }
>  }
>
> --
> 2.35.1
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

