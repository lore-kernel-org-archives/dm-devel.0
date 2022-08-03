Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46089C19F28
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 04:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659501001;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yW5jqoo6rwCyID1fPDVAV0N+qq20RrLp803gXqpQSko=;
	b=HUzfCIL+4LS5UHygBMx5N2y6rW3IbuEI7/qQUigOgUnhRyXiu3QQrW6kH96CdhHC8jzL2R
	SLT9pW3/H1jl1kVi08VybC8OfFalXydf1w6k+v+aIwvn/pr2ob00+PQViJoAx4SnIpFFwt
	7ceeSW6yNB40lLjRMib54lamXtV1t84=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-LptUG9qcPYazr7a-4gzykQ-1; Wed, 03 Aug 2022 00:29:57 -0400
X-MC-Unique: LptUG9qcPYazr7a-4gzykQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 598C0101A588;
	Wed,  3 Aug 2022 04:29:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 052EA4010FA5;
	Wed,  3 Aug 2022 04:29:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B22991946A53;
	Wed,  3 Aug 2022 04:29:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 174311946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 04:29:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EBC8540C1288; Wed,  3 Aug 2022 04:29:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E7E504010FA5
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 04:29:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CECE5101A586
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 04:29:53 +0000 (UTC)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com
 [209.85.128.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-K0B__5OJNS-rR3Rxg_u8iw-1; Wed, 03 Aug 2022 00:29:52 -0400
X-MC-Unique: K0B__5OJNS-rR3Rxg_u8iw-1
Received: by mail-yw1-f179.google.com with SMTP id
 00721157ae682-328303afa6eso8979707b3.10
 for <dm-devel@redhat.com>; Tue, 02 Aug 2022 21:29:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=NbtXNCpzIHOXao+YSnQZdhcH786as3lUPJ/TZmv8CNw=;
 b=vvzW8ldHK/rDvduMMZY++ThYDNPLyACqdmax4vfhKBni+A2hMRR3GrZsJCOUT6XwSt
 a/boL+zJs4fJ0KBSYU2Ugjx4eJj7+/hZRzeHBAp4tW4RSTnP9hJqogE/ezAbNx5Gn9zS
 wI6DM2p220Ucc72bsTNDi25xADAffSf/d34ws2Hh2SQcBYK6M7wnA2QhpG6xjmtry2Cl
 YCtOSxjFjJTzyXD4GEknIKYqNYrfCIziVejFskAlJlQHmZkrqhe3kAgOY+Cd83wbD464
 TfzC7MmXv7SO0vCoHRhE06L5gXeVOgTOLAK6RhaNpZPdd1eFElSjA+Trsj5CrG0cH8FI
 Zc6g==
X-Gm-Message-State: ACgBeo3a+Qfid2UGh87E6z7oTEai7K4lMCj67+WoY9M2LP+a+PCIkTFJ
 5jJ2keTF4mFVbFYFhGOH0tWUw7RQYfn+FnWrMgvMlQ==
X-Google-Smtp-Source: AA6agR4WjX/epmvJWCEqJybFZZuQMaMMSBvBmrgjPDfUnQXu59XYjGRrURmOgu9EbFsiDo3C7nrzNWdlWn0yVmaLHM8=
X-Received: by 2002:a81:81c1:0:b0:31e:7378:960c with SMTP id
 r184-20020a8181c1000000b0031e7378960cmr21836822ywf.266.1659500991420; Tue, 02
 Aug 2022 21:29:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220704000225.345536-1-dlunev@chromium.org>
 <20220704100221.1.I15b3f7a84ba5a97fde9276648e391b54957103ff@changeid>
 <YtB45Lte5UhlEE6y@redhat.com>
 <CAONX=-dEG121RQ6L-4fPMXrLXb3JeYNVNiPzHXNaRLbwRzb3bw@mail.gmail.com>
 <alpine.LRH.2.02.2207150528170.5197@file01.intranet.prod.int.rdu2.redhat.com>
 <cca5b463-a860-de8d-b7e4-a8d30aef2ff2@gmail.com>
 <CAONX=-fJHgfGkwR5A1MT+8FHckueehOsUS_LyHkjrgp4Y+vOgw@mail.gmail.com>
 <CAONX=-ft=ewFDui4jmd2fvcNr2EJc90=ZNOueDdp6HaPZmvObQ@mail.gmail.com>
 <Yun4LH+StcuBXRtO@sol.localdomain>
In-Reply-To: <Yun4LH+StcuBXRtO@sol.localdomain>
From: Daniil Lunev <dlunev@chromium.org>
Date: Wed, 3 Aug 2022 14:29:40 +1000
Message-ID: <CAONX=-esLr5bGUks_a8wQBky37NnCawh2eOMemYg32HcPA7pmA@mail.gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
 linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> This seems like an access control policy, which the Linux kernel already has a
> lot of mechanisms for.  Chrome OS already uses SELinux.  Couldn't this be solved
> by giving the device node an SELinux label that no one has permission to open?
That would be the ideal solution, but there is a number of challenges
that prevent
us enabling enforcement on all SELinux domains unfortunately. While in the long
run that would be a preferred option, in the short run this doesn't
seem feasible. I
would assume the problem of enabling full SELInux enforcement would plague
any big project that didn't have them enabled from the get going.
--Daniil

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

