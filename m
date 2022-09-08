Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7950C54EE9
	for <dm-devel@archiver.kernel.org>; Thu,  8 Sep 2022 15:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662650757;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6ho+UnECWUNfeOlZ0U+aNKIbjpcqVD8PZS6nvUqOpZs=;
	b=ZuaejV1/+zR/VyEMIQACv+6xZG2EV34uO+Sk93TksycgnLf93O7txKQn7f1ATV3k8UdZfU
	zvMgzVrnkTDd80BXSKz0mN7CMi9iLSOnfiRJ2uLndy97GgQpk8NegquyOXiymk0Tt04hOK
	m0hx0/QDdGHpz6MmSxhW2D0OJyYVm88=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-q6fY9qwbPmqEDXcD5TIJ_g-1; Thu, 08 Sep 2022 11:25:56 -0400
X-MC-Unique: q6fY9qwbPmqEDXcD5TIJ_g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEE5685A58A;
	Thu,  8 Sep 2022 15:25:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B63B614152E0;
	Thu,  8 Sep 2022 15:25:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B5451946A44;
	Thu,  8 Sep 2022 15:25:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B92C41946A41
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Sep 2022 15:25:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9507C40334F; Thu,  8 Sep 2022 15:25:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 91927492C3B
 for <dm-devel@redhat.com>; Thu,  8 Sep 2022 15:25:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51E3018E6C71
 for <dm-devel@redhat.com>; Thu,  8 Sep 2022 15:25:46 +0000 (UTC)
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com
 [209.85.222.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-nZI52fBgNcqas8kr2Iw1lA-1; Thu, 08 Sep 2022 11:25:41 -0400
X-MC-Unique: nZI52fBgNcqas8kr2Iw1lA-1
Received: by mail-qk1-f169.google.com with SMTP id b9so13172730qka.2
 for <dm-devel@redhat.com>; Thu, 08 Sep 2022 08:25:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=We7YdNWL+dA6SvrcsgfeWC+uhCMnz0P9xITf03yypx8=;
 b=UbJHTr/dpxfYydWQ4cWe8nOGmRypkJiOg/N2o29wQh+NtGLPsD6/iaO+cbG7hgQYfp
 GkHf5byv20NKiPp4UuFL1/sCTmylcmzUMMd9zoj359cp01EZpPjVRJcA8MUpkQHA8KRP
 8ajp6J07uUr4v4EZYyORuBuVVQLeL0/cngngB3Y20rqQhT8JbxCTAQ9/xsRoEE9/Kh+U
 /JgGGi151es6Hv3reOSCbb/dDcz9/Yqos0samSpbkFATA6/N+feY3T22Z/GxfhyINy86
 YV4zk+aWsxXMKdAvc0hjVHYZ2C7DRBJ945CRujxx/ExdNJ31bEm+WsAXMHaL3nyAyMC4
 d/tQ==
X-Gm-Message-State: ACgBeo22ApUaRxqvG5+xDsxus5VOh/zEP5Gya3NxshwSquI2pGrm69nH
 yNMNxI/yXqRSNZVZUVL/lP1S4Dg=
X-Google-Smtp-Source: AA6agR786+XZqALGz47aUlYlRGU0gUHtl1jtiHS/dbi/BYJRHk2Rm8IwMyj9N3uQYj24nkxsh4cIdA==
X-Received: by 2002:a05:620a:2451:b0:6cb:b4db:a3ad with SMTP id
 h17-20020a05620a245100b006cbb4dba3admr5003410qkn.216.1662650737962; 
 Thu, 08 Sep 2022 08:25:37 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 s13-20020a05620a0bcd00b006bb82221013sm17379003qki.0.2022.09.08.08.25.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Sep 2022 08:25:37 -0700 (PDT)
Date: Thu, 8 Sep 2022 11:25:36 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Kees Cook <keescook@chromium.org>
Message-ID: <YxoJcG5MN4OdaulL@redhat.com>
References: <20220907133055.1.Ic8a1dafe960dc0f8302e189642bc88ebb785d274@changeid>
 <166259004596.4128104.7200162640366282166.b4-ty@chromium.org>
MIME-Version: 1.0
In-Reply-To: <166259004596.4128104.7200162640366282166.b4-ty@chromium.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] dm: verity-loadpin: Only trust verity targets with
 enforcement
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
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, dianders@chromium.org,
 linux-security-module@vger.kernel.org, mka@chromium.org,
 sarthakkukreti@chromium.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 07 2022 at  6:34P -0400,
Kees Cook <keescook@chromium.org> wrote:

> On Wed, 7 Sep 2022 13:30:58 -0700, Matthias Kaehlcke wrote:
> > Verity targets can be configured to ignore corrupted data blocks.
> > LoadPin must only trust verity targets that are configured to
> > perform some kind of enforcement when data corruption is detected,
> > like returning an error, restarting the system or triggering a
> > panic.
> > 
> > 
> > [...]
> 
> Applied to for-next/hardening, thanks!
> 
> [1/1] dm: verity-loadpin: Only trust verity targets with enforcement
>       https://git.kernel.org/kees/c/2e1875c05267

Does this mean you're intending to send this upstream?  I prefer to
take all DM changes unless there is an external dependency.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

