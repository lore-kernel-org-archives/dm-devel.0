Return-Path: <SRS0=0/yZ=PI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCB7C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 20 Oct 2021 01:18:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9AAEB60F57
	for <dm-devel@archiver.kernel.org>; Wed, 20 Oct 2021 01:18:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9AAEB60F57
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-T_kUc-j0MCuM1KQkxYaaew-1; Tue, 19 Oct 2021 21:18:08 -0400
X-MC-Unique: T_kUc-j0MCuM1KQkxYaaew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE95D104ECE6;
	Wed, 20 Oct 2021 01:18:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4F6E1B5C2;
	Wed, 20 Oct 2021 01:18:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9A0A81801241;
	Wed, 20 Oct 2021 01:18:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19K1I2xE021550 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Oct 2021 21:18:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 509FF100725E; Wed, 20 Oct 2021 01:18:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C44A100725D
	for <dm-devel@redhat.com>; Wed, 20 Oct 2021 01:17:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93611899EC0
	for <dm-devel@redhat.com>; Wed, 20 Oct 2021 01:17:59 +0000 (UTC)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com
	[209.85.208.43]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-33-1AE-uB--M6KgySYPpo68Ow-1; Tue, 19 Oct 2021 21:17:57 -0400
X-MC-Unique: 1AE-uB--M6KgySYPpo68Ow-1
Received: by mail-ed1-f43.google.com with SMTP id r4so12990153edi.5
	for <dm-devel@redhat.com>; Tue, 19 Oct 2021 18:17:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=68D4DgU0Gfq6tJiaJ4ylSiWHWaQusu7jN9KQPJh8Yao=;
	b=dqdb5VIIJcPXs+V0196FznzyMFJ+H/ddhaVVAaOF7rtxx6dyzxQymB7LdW7QGuu+yI
	/oE+palTjHOvcMUX3ONZO9ythwmMgoOr8DmaTN8r/uFq0CFNBVmtmjtAGi6oLz1Nz9Ei
	2GWoabIxBbsoKj+cTG8WaXMmu+kcP/zsDt0/JZmQn4vqTv3ND/o0+/NXXJwDs9b6Myl+
	nUTcND4E//aCBoIVyIXSr3Locb17AN+xwZxR0gmBCOn/LCsnmwAxlcX/PPB2fLgY7KTL
	5guy/s9H67gNXtDWgPu5bsLJL5L4W/caT2BzA0buQD1XfAw7PZsTFwyGSOnbHjOWaXUD
	IhEQ==
X-Gm-Message-State: AOAM533gUCzdBh6IH6rHNEWnSshCC/GgOb+ctSkWF2CI5Mxzv2rkKob/
	p0sAM86SeYqcohaW8/5yadFvuRlMXrTeBAyT1A8I
X-Google-Smtp-Source: ABdhPJzqIAixH5xb6XZi6BJcjotcCt9fJHXaH8ukKPm5mfhjV4y4E91wWyp/uxyejasfz/CYDGdKUWkE+WIKVCncPQg=
X-Received: by 2002:a05:6402:2552:: with SMTP id
	l18mr59252094edb.370.1634692676573; 
	Tue, 19 Oct 2021 18:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <163469252421.3058604.4246950335082826987.stgit@olly>
In-Reply-To: <163469252421.3058604.4246950335082826987.stgit@olly>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 19 Oct 2021 21:17:45 -0400
Message-ID: <CAHC9VhRg=2yPdVMcCmP9=++jHtHWP7t3S9dhKj9QFjpFyKvCjw@mail.gmail.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-audit@redhat.com
Subject: Re: [dm-devel] [PATCH] audit: correct the AUDIT_DM_CTRL and
	AUDIT_DM_EVENT numbering
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 19, 2021 at 9:15 PM Paul Moore <paul@paul-moore.com> wrote:
>
> Due to conflict with the audit and SELinux trees the device mapper
> audit record types need to be renumbered before landing in Linus'
> tree.
>
> Link: https://lore.kernel.org/lkml/CAHC9VhTLmzDQPqsj+vyBNua1X13UK_tTcixKZ7WWYEqMXVOXdQ@mail.gmail.com/
> Fixes: c1d7fa96e74b ("dm: introduce audit event module for device mapper")
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  include/uapi/linux/audit.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Alasdair or Mike, please merge this into the device-mapper tree before
you send it to Linus during the upcoming merge window.

> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 6650ab6def2a..809e4c2041b3 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -118,8 +118,8 @@
>  #define AUDIT_TIME_ADJNTPVAL   1333    /* NTP value adjustment */
>  #define AUDIT_BPF              1334    /* BPF subsystem */
>  #define AUDIT_EVENT_LISTENER   1335    /* Task joined multicast read socket */
> -#define AUDIT_DM_CTRL          1336    /* Device Mapper target control */
> -#define AUDIT_DM_EVENT         1337    /* Device Mapper events */
> +#define AUDIT_DM_CTRL          1338    /* Device Mapper target control */
> +#define AUDIT_DM_EVENT         1339    /* Device Mapper events */
>
>  #define AUDIT_AVC              1400    /* SE Linux avc denial or grant */
>  #define AUDIT_SELINUX_ERR      1401    /* Internal SE Linux Errors */

-- 
paul moore
www.paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

