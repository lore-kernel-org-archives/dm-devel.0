Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D120C636CC
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 09:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676453629;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Jtzow3UhD3NMMOlAot8hJBhnKjX1d96xc4xW2Js/+2M=;
	b=D4TDyVV+qCMcEvJy30m15UfoYLV5IWskcQD21jFQpUgebpwylwZZWsUJ+gpH0ggohtFpdw
	NU9XDJrH3F9xGxcPV6GZDLyhmro4EoDd83bIzl+5V0rfAWAwkTSoPlL0LgXYZu1s7BOQIZ
	tKpWwQ6SgC6keQLFblAQjb3Vv4Xp5E4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-2YcrG3FgPYOEb4H_8uQGTA-1; Wed, 15 Feb 2023 04:33:45 -0500
X-MC-Unique: 2YcrG3FgPYOEb4H_8uQGTA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BBD3857AA3;
	Wed, 15 Feb 2023 09:33:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1A0351C55A;
	Wed, 15 Feb 2023 09:33:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F05911946A76;
	Wed, 15 Feb 2023 09:33:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A2321946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Feb 2023 18:43:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E0DCE40B40E4; Tue, 14 Feb 2023 18:43:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DA18940B40C9
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 18:43:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB4441024D28
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 18:43:39 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-Xq3Nr03TPEaAQm3YIG_Wng-1; Tue, 14 Feb 2023 13:43:38 -0500
X-MC-Unique: Xq3Nr03TPEaAQm3YIG_Wng-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 927CEB81A46
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 18:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E753C4339C
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 18:38:12 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id x29so19537862ljq.0
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 10:38:12 -0800 (PST)
X-Gm-Message-State: AO0yUKUoykVTy5RMlsbNj/wsPtc2cQSEoL9v0hWsxipb2oNUx/ehu58H
 trU3vkOvbUhoFKGREv7WsFljYDrQqlXGILiugvw=
X-Google-Smtp-Source: AK7set+CEG1WyNimA3QHERrbdHXEAIa/PyvekCI7ilROesupJOlW3Q4HK3XV52LdR4NIHD6WF+TSUEv1MtZSJfbRjm4=
X-Received: by 2002:a2e:a36a:0:b0:292:8597:6142 with SMTP id
 i10-20020a2ea36a000000b0029285976142mr495470ljn.5.1676399890282; Tue, 14 Feb
 2023 10:38:10 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZJvXpCt37nQOoe8qd1EPUpfdMM1HwHk9tVO8HdU_Azhhw@mail.gmail.com>
 <25578.37401.314298.238192@quad.stoffel.home>
 <CACsaVZJ-5y7U5xqwL9bof69EKbTk+wrHWFcBFYyP_BwVSt+CNA@mail.gmail.com>
In-Reply-To: <CACsaVZJ-5y7U5xqwL9bof69EKbTk+wrHWFcBFYyP_BwVSt+CNA@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Tue, 14 Feb 2023 10:37:58 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4XPqY18k4DB2YXqaNgABp3HYYQtS7u0bGfjBcTgkpXkQ@mail.gmail.com>
Message-ID: <CAPhsuW4XPqY18k4DB2YXqaNgABp3HYYQtS7u0bGfjBcTgkpXkQ@mail.gmail.com>
To: Kyle Sanderson <kyle.leet@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 15 Feb 2023 09:33:38 +0000
Subject: Re: [dm-devel] RAID4 with no striping mode request
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
Cc: linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>,
 John Stoffel <john@stoffel.org>, Linux-Kernel <linux-kernel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Kyle,

On Mon, Feb 13, 2023 at 1:12 PM Kyle Sanderson <kyle.leet@gmail.com> wrote:
>
[...]

> >
> > > The benefit of this can be the data disks are all zoned, and you can
> > > have a fast parity disk and still maintain excellent performance in
> > > the array (limited only by the speed of the disk in question +
> > > parity). Additionally, should 2 disks fail, you've either lost the
> > > parity and data disk, or 2 data disks with the parity and other disks
> > > not lost.

I think I understand the high level idea here. But I think we need a lot more
details on how to implement this, and what the system would look like.
Also, I don't quite follow why the data disks can be zoned devices and
still maintain excellent performance.

> > > I was reading through the DM and MD code and it looks like everything
> > > may already be there to do this, just needs (significant) stubs to be
> > > added to support this mode (or new code). Snapraid is a friendly (and
> > > respectable) implementation of this. Unraid and Synology SHR compete
> > > in this space, as well as other NAS and enterprise SAN providers.

Assume we figure out all the details. I will be happy to review patches in
MD code. But I won't be able to develop this feature myself.

Thanks,
Song

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

