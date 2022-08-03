Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 159CFC19F28
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 04:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659499968;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PtUkxwg9Iz67wVpE/YXGGV0nUPxsvFrzZsWwoijbiAQ=;
	b=V7uVyqiorHlMzSqnywqi8r/FTqu6g938Y1eAYh1QUDZO3f0aI5l6vp+ntGIQ9sepzjKv3y
	cqrnWU1abVAJXLiseHjqpFZODdS784oSZ9gxUmgMLFZfGOAGwuzSCvFxZY+9FdbxOBI6bG
	+sdArqWb6Wqb50NPKOEeEH+gb5P/OLE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-qi4KZFvXNVWn3pB4gjOBlw-1; Wed, 03 Aug 2022 00:12:45 -0400
X-MC-Unique: qi4KZFvXNVWn3pB4gjOBlw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1B5B801755;
	Wed,  3 Aug 2022 04:12:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7166D2166B26;
	Wed,  3 Aug 2022 04:12:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3A3F81946A56;
	Wed,  3 Aug 2022 04:12:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D82F11946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 04:12:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A5B472166B2A; Wed,  3 Aug 2022 04:12:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A1D362166B26
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 04:12:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85CF6962CC0
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 04:12:39 +0000 (UTC)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com
 [209.85.219.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-caMda3YhNVSLHm0c-Pu8pA-1; Wed, 03 Aug 2022 00:12:37 -0400
X-MC-Unique: caMda3YhNVSLHm0c-Pu8pA-1
Received: by mail-yb1-f174.google.com with SMTP id 123so26609308ybv.7
 for <dm-devel@redhat.com>; Tue, 02 Aug 2022 21:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=cBLTjlzefU+wV6vGj0COojpi+1jnoL0XJw2TFigcBEM=;
 b=0fCj13EECq4ERPcw2zbOr4Z54NPo2elAh5Jg9zwmWM2j+z/wUMKqYg9JiKCri/vLTc
 1Gg+p9M/3EVDpbvjEv27gJ8KyU9x0KORGn8izEaeNP5fgwjz7+BCrA7WvlKngcTqIKMa
 uXK0EG/1ism6EvDzxoqAmQy4vl6v16cK3d+sp/e3V0N02dwVdiWlcQ72/tHypn1xvF8F
 7tsRhKw/8JE10VC8+fd9Ni14lOs3CRHK8NWsJbONCo3lEibnJU05Y4BUpL9Af5zmXvtF
 eK/PUdJJy6J3+j6gHM7I6tDxRaL8AkyVvApXGVcqO2P3TUt86BNKIWYElHn3RVnJDKF0
 0DKg==
X-Gm-Message-State: ACgBeo0QHXRbgBndZRqpE7/cp4cmdFz8ac8jOmi8+5+j0JgrRNswiYNL
 DCSeN5j267BNaE4JzPkQ1FoxUAK1qNEYR3HtMkswUw==
X-Google-Smtp-Source: AA6agR7EIuoh5Nv9c51B42311sXsZ7jHn4Hl76TruUb9ImpYEb06vAq9p3ocFdGuWV007jE1JxoiaKwdMithR2IRJfo=
X-Received: by 2002:a25:c206:0:b0:67a:6ba0:98f5 with SMTP id
 s6-20020a25c206000000b0067a6ba098f5mr940817ybf.507.1659499957299; Tue, 02 Aug
 2022 21:12:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220704000225.345536-1-dlunev@chromium.org>
 <20220704100221.1.I15b3f7a84ba5a97fde9276648e391b54957103ff@changeid>
 <YtB45Lte5UhlEE6y@redhat.com>
 <CAONX=-dEG121RQ6L-4fPMXrLXb3JeYNVNiPzHXNaRLbwRzb3bw@mail.gmail.com>
 <alpine.LRH.2.02.2207150528170.5197@file01.intranet.prod.int.rdu2.redhat.com>
 <cca5b463-a860-de8d-b7e4-a8d30aef2ff2@gmail.com>
 <CAONX=-fJHgfGkwR5A1MT+8FHckueehOsUS_LyHkjrgp4Y+vOgw@mail.gmail.com>
In-Reply-To: <CAONX=-fJHgfGkwR5A1MT+8FHckueehOsUS_LyHkjrgp4Y+vOgw@mail.gmail.com>
From: Daniil Lunev <dlunev@chromium.org>
Date: Wed, 3 Aug 2022 14:12:26 +1000
Message-ID: <CAONX=-ft=ewFDui4jmd2fvcNr2EJc90=ZNOueDdp6HaPZmvObQ@mail.gmail.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello all
To signal boost here. What can we do to advance the discussion on this
topic? Can we move forward with the approach or are there any
alternative suggestions how the desired behaviour can be achieved?
Thanks,
--Daniil

On Tue, Jul 19, 2022 at 9:42 AM Daniil Lunev <dlunev@chromium.org> wrote:
>
> We understand that if someone acquires root it is a game over. The intent of
> this mechanism is to reduce the attack surface. The exposure might be a
> certain system daemon that is exploited into accessing a wrong node in
> the filesystem. And exposing modifiable system memory is a pathway for
> further escalation and leaks of secrets. This is a defense in depth mechanism,
> that is intended to make attackers' lives harder even if they find an
> exploitable
> vulnerability.
> We understand that in regular situations people may not want the behaviour,
> that is why the mechanism is controlled via a side channel - if a message is
> never sent - the behaviour is not altered.
> --Daniil

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

