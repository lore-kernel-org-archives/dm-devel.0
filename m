Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8030CCA479
	for <dm-devel@archiver.kernel.org>; Mon, 18 Jul 2022 23:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658187780;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WnIgEfqrtC2QElNJ6NrVJpqt0E8bl2JDTAmdjNCbYXs=;
	b=MVti5pS2mgJ/s5GKoQEkHPGrQH56aX9Cslph9MPGvC6kL0O0FIP26EKGbvj4Rj2xmlGCWZ
	dixxrEP2buJrJW9LTzQ+Y28WELw3zQ5an7ri6Qow+SL/JoxHotCCsvHXL1+kt36zdslzYi
	Er2veiqX9PtBu4TzJJHx3EWS0zKLQg8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-EaqTZkW1Ogy0UZoIHKKeLQ-1; Mon, 18 Jul 2022 19:42:56 -0400
X-MC-Unique: EaqTZkW1Ogy0UZoIHKKeLQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A57C5804184;
	Mon, 18 Jul 2022 23:42:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 24B0E492C3B;
	Mon, 18 Jul 2022 23:42:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B02231947061;
	Mon, 18 Jul 2022 23:42:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D0D99194705F
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Jul 2022 23:42:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AC123C28133; Mon, 18 Jul 2022 23:42:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A6F8FC15D67
 for <dm-devel@redhat.com>; Mon, 18 Jul 2022 23:42:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E4768037AC
 for <dm-devel@redhat.com>; Mon, 18 Jul 2022 23:42:50 +0000 (UTC)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com
 [209.85.128.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-MDMSgS4JP8SPfvUoPOlY5g-1; Mon, 18 Jul 2022 19:42:43 -0400
X-MC-Unique: MDMSgS4JP8SPfvUoPOlY5g-1
Received: by mail-yw1-f176.google.com with SMTP id
 00721157ae682-31e45527da5so25477037b3.5
 for <dm-devel@redhat.com>; Mon, 18 Jul 2022 16:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Fdwo892EWIW1Y32bf4ujqomqp34wsbvkXOhTjTQ9ay0=;
 b=GtfARV1A/Vr9bvT6lOlGJixILP2Gey3SUqf+QRYcrGl/mLwphKLUAz65NThY65/1m5
 rwp3pHaXL/ECDF1bYog/9VunYLA4MvHrINDdM81nyxMpG0dGRIfhAihpu1bFclqHSp9q
 CC4PvNvzCbfePKuCQxg6zjTqM6MOxxJOJZ4OSfYP42qAQhFdyZKBgEMoU1LqVoAdlths
 Z/MeM1+Bl44YDQF7mQ7n1Ri/vxxb36oRYhaMsDVyL2zF3naiLJCIN1qZrOrzoJQlUdEX
 3hqQHFKSYf1voXxq25FkTFvveH3JLeOX5ab5Yal3vacLFpLjCM7da9Le5sBxEsgVRov2
 v5Wg==
X-Gm-Message-State: AJIora81n+DHSBDnRtiPep+ZY2LAegBbliWaScE9dEk8DdKg3+0DR6Vj
 2nhGeH5NqBiEHWL6oMqqPm+Z5NZsISbWn9q7j4iQ4g7lEeU=
X-Google-Smtp-Source: AGRyM1s7goTrVWuATwjOLxGNG1hUSLNURpzW90XmxiyJZEUnRSARH/dinORe36qNgea/XpmB92WOBwx+1YMUdfPucL0=
X-Received: by 2002:a0d:d8d6:0:b0:31d:44f:e04b with SMTP id
 a205-20020a0dd8d6000000b0031d044fe04bmr34100749ywe.296.1658187756826; Mon, 18
 Jul 2022 16:42:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220704000225.345536-1-dlunev@chromium.org>
 <20220704100221.1.I15b3f7a84ba5a97fde9276648e391b54957103ff@changeid>
 <YtB45Lte5UhlEE6y@redhat.com>
 <CAONX=-dEG121RQ6L-4fPMXrLXb3JeYNVNiPzHXNaRLbwRzb3bw@mail.gmail.com>
 <alpine.LRH.2.02.2207150528170.5197@file01.intranet.prod.int.rdu2.redhat.com>
 <cca5b463-a860-de8d-b7e4-a8d30aef2ff2@gmail.com>
In-Reply-To: <cca5b463-a860-de8d-b7e4-a8d30aef2ff2@gmail.com>
From: Daniil Lunev <dlunev@chromium.org>
Date: Tue, 19 Jul 2022 09:42:26 +1000
Message-ID: <CAONX=-fJHgfGkwR5A1MT+8FHckueehOsUS_LyHkjrgp4Y+vOgw@mail.gmail.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 1/1] dm: add message command to disallow
 device open
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
Cc: Brian Geffon <bgeffon@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

We understand that if someone acquires root it is a game over. The intent of
this mechanism is to reduce the attack surface. The exposure might be a
certain system daemon that is exploited into accessing a wrong node in
the filesystem. And exposing modifiable system memory is a pathway for
further escalation and leaks of secrets. This is a defense in depth mechanism,
that is intended to make attackers' lives harder even if they find an
exploitable
vulnerability.
We understand that in regular situations people may not want the behaviour,
that is why the mechanism is controlled via a side channel - if a message is
never sent - the behaviour is not altered.
--Daniil

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

