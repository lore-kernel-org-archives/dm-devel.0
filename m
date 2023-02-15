Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3179C636CC
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 12:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676464394;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Iia3FiBVr4t/4ICSq2eI+z2tUFmpLm4NhndxwgYhpDg=;
	b=hFNveyzXJhYBqOlVnc8iZ96bk++Jh9V7WZhanCZPGDTVfn0SIXG/K+9keN+wd5cIjn74Cq
	gVXP97jkwdFL2yVM+Kgh9ggKPW971YPRUEeyvHjcqBy0YZAGe6CvIInxXfnutXpaSQGmBC
	rQfhDYc5j4TK/zlJm1XVwlS3N6K52S4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-gJnz0GFyPFq6kOYk1Q0TJg-1; Wed, 15 Feb 2023 07:33:11 -0500
X-MC-Unique: gJnz0GFyPFq6kOYk1Q0TJg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF76888B7BA;
	Wed, 15 Feb 2023 12:33:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EB8C4492C3C;
	Wed, 15 Feb 2023 12:33:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B35261946588;
	Wed, 15 Feb 2023 12:33:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 096C21946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Feb 2023 12:14:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED586410B1AD; Wed, 15 Feb 2023 12:14:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E5B5B408573E
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 12:14:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAC3F80D0E8
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 12:14:39 +0000 (UTC)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com
 [209.85.217.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-473-RfJkKi6API6kgmeSCzKk3Q-1; Wed, 15 Feb 2023 07:14:38 -0500
X-MC-Unique: RfJkKi6API6kgmeSCzKk3Q-1
Received: by mail-vs1-f43.google.com with SMTP id z15so9003360vsj.12
 for <dm-devel@redhat.com>; Wed, 15 Feb 2023 04:14:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1676463277;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=PskCwTrWDZrWRbZCcW4kWHFjRF9OJwXOzoFc7PAWktA=;
 b=PpTLdg5e6Phb+KdxetggW0K26md9PkmrH3UFeGuQzNmNU7oPNApOjxh7yMDDEGYrpb
 pw8G5Ooe+lImLYALo9ygF+YBBZ5fS66M+f/QcrdOaY4wSwYLf1yv4yLuWfI4tZLFfFz4
 mvs7/eH/83Ui7EZo3PZuB+wlyDEpy9/FusvooDStTGYocH3EcYJRxabjiD4rDL59ouXA
 NdPYOGS7Z/2EqUF7Io4cfnU4OqaN9s9Ivms7wUpz7u1dReQ51T+BLRzjXs7N49ff4wU0
 F6GyruYwTTKYZTD0M8GsV7q+tohF2K22I/nNUT1gPnw4qLuW0BnszAjZG2z4BMxdD6Qh
 kMvQ==
X-Gm-Message-State: AO0yUKXt/93uH5cD3xJGHNJh+ihNQHCIKRvunvigDdEQy70Uib/eBPCW
 l+zit6ghPpJ7pGlFdpH1JQM70JTBHwCRzlWW/KFmpwZH41I=
X-Google-Smtp-Source: AK7set9x/and/PHwy8ehOuGorY08JFkwiPcr8BIRpcRl6vuq4LZ0jUPF4bgjC1IsV7Ek2zcjaQZ24rU/C4jOmOYVqA0=
X-Received: by 2002:a67:e0cf:0:b0:3fc:3a9e:3203 with SMTP id
 m15-20020a67e0cf000000b003fc3a9e3203mr360976vsl.84.1676463277430; Wed, 15 Feb
 2023 04:14:37 -0800 (PST)
MIME-Version: 1.0
References: <IA1PR20MB5743F5A364EB9E02890364F7DAA29@IA1PR20MB5743.namprd20.prod.outlook.com>
In-Reply-To: <IA1PR20MB5743F5A364EB9E02890364F7DAA29@IA1PR20MB5743.namprd20.prod.outlook.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Wed, 15 Feb 2023 06:14:26 -0600
Message-ID: <CAAMCDefEs9UorPKZ_M_PtvRNxbtaSE1U9-qr-hE=GnBV1dQbag@mail.gmail.com>
To: Ganapathi Kamath <hgkamath@hotmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] On allowing remounting the partition containing
 dm-mapped boot disk as read-write
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Typically double mounts are done via bind mounts (not really double
mounted just the device showing someplace else).   Or one would do a
mount -o remount,rw <originaldir> and remount it rw so you could write
to it.

A real double mount where the kernel fs modules manages both mounts as
if it was a separate device won't work reliably, as the filesystem
module/caching assumes it has total control.   So writing to a
read-write device that has a separate read-only mount with some data
in the read cache will not return the true data in all cases.    2
read-write (done any way--except with a clustering fs modules) are
going to cause corruption of the underlying filesystem.

Given that the use case for the module is dangerous and the use case
is of questionable usefulness I would think that is no point of the
module.  The module's intent seems to be to get around the exclusive
locks that the filesystem (for good reason) is putting on the device.

On Wed, Feb 15, 2023 at 3:33 AM Ganapathi Kamath <hgkamath@hotmail.com> wrote:
>
> I am just an ordinary user of Linux and ventoy .
> Q)
> https://github.com/ventoy/Ventoy/issues/2234
> Is what I have suggested here, meaningful?
> Is there contra-indications to not do it or an alternative suggestions?
> thoughts?
>
> Ventoy, a GPL software, uses a small kernel patch to achieve a small remountability feature.
> It seemed to me, that patching the kernel per distribution is sub-optimal.
> I couldn't find a previous relevant discussion on this on dm-devel, but it seems like a requirement would've been well known and this would have already been discussed. What does the actually patch do?
>
> Thx
> -Gana
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

