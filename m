Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4EC1C61DA4
	for <dm-devel@archiver.kernel.org>; Thu,  9 Mar 2023 14:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678372995;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gWcbTiekp2uKB1PUU0E4CuFZjZLZOk3pznTzsiRBPNw=;
	b=N39A9wkJdRv0D2qUiTQMzuMeP3WiIkSknOQDbDclOE+PccpufAgrXwqjU0JrHlYa3MIpNO
	LFe0Id1tQZGloo1ksALkceTc51wUyljfJhSTkFtReUHOvLaN17MHam3bbYSxZS5FLfCOBJ
	O2wyv9XhubRUENiIZ/+LgnVc0SsvQ5s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-zvrtZfe2M7KGu2rluu_kRg-1; Thu, 09 Mar 2023 09:43:13 -0500
X-MC-Unique: zvrtZfe2M7KGu2rluu_kRg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2826E857A9F;
	Thu,  9 Mar 2023 14:43:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C81D11410DD9;
	Thu,  9 Mar 2023 14:43:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 90BCD19465B5;
	Thu,  9 Mar 2023 14:43:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 441391946597
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Mar 2023 14:43:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 504BC2026D68; Thu,  9 Mar 2023 14:43:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 480B32026D4B
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 14:43:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 243923C18356
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 14:43:05 +0000 (UTC)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
 [209.85.128.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-WvnjTGwnO6arvZgggzW68g-1; Thu, 09 Mar 2023 09:43:03 -0500
X-MC-Unique: WvnjTGwnO6arvZgggzW68g-1
Received: by mail-wm1-f54.google.com with SMTP id az36so1319572wmb.1
 for <dm-devel@redhat.com>; Thu, 09 Mar 2023 06:43:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678372982;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=bsfch2unRHFJhM7XtsKHfIQkZSGbxKj64qJqfrNvNi8=;
 b=fuI/ebIo6aQ9qSJDtgZRtRbZ6fZ9MHTXG0YnjcPb0Iqyz7H+tb2ZV5WsZF4l/cAy7R
 wDDymGbs89Nq/dglMuvtCxUkUj6ZMVawf2ITla8dltM8RKG62xdKIReb15z2yBC7N1LU
 veCy7hvHsZHZeIvMkL65uPKp8gpuHHekcEqxpMD/xa95NxmY59TbYczGNPVsFSKPYUFn
 UeMvt/dxmkK7bxvqeEoO/yX4bscF+pEK49Yz9fYS/xPWwNGTLtuJtrkLZLrIl0H/v/zN
 qV7Wxm/pwA2zemHB5LyashznTMoD5CtGeZfSnrmJ26lK7UORyOCizTgP7AMI4dk7zN/K
 hMbw==
X-Gm-Message-State: AO0yUKUxQ1eIx7itRhZVrZhkP0jm+MF1R6CqCHKO0o0EmqOtLfgCACjR
 wAMbPucqfA+NEzU8DE1RoyA=
X-Google-Smtp-Source: AK7set991tYEW9gU2nltpn5ugrI6Kp6Hzu7SuXq6u529EkB4aD/PzJ9VmzhAyGsNuFkws53IgPDBAw==
X-Received: by 2002:a05:600c:468b:b0:3df:fcbd:3159 with SMTP id
 p11-20020a05600c468b00b003dffcbd3159mr15986236wmo.3.1678372981831; 
 Thu, 09 Mar 2023 06:43:01 -0800 (PST)
Received: from localhost ([102.36.222.112]) by smtp.gmail.com with ESMTPSA id
 n8-20020a05600c294800b003e2052bad94sm27382wmd.33.2023.03.09.06.43.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Mar 2023 06:43:01 -0800 (PST)
Date: Thu, 9 Mar 2023 17:42:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: snitzer@kernel.org
Message-ID: <5e9f73e8-26a3-47ff-aeee-7e723b66c7c9@kili.mountain>
References: <7df2de70-c883-4733-9c07-bf69a8ada5bb@kili.mountain>
MIME-Version: 1.0
In-Reply-To: <7df2de70-c883-4733-9c07-bf69a8ada5bb@kili.mountain>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [bug report] dm crypt: conditionally enable code
 needed for tasklet usecases
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 09, 2023 at 05:35:20PM +0300, Dan Carpenter wrote:
> --> 2758         if (test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags) ||
>                                                            ^^^^^^^^^
>     2759             test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))
>                                                             ^^^^^^^^^
> UAF.  This wasn't tested, right?  If this passes testing then it means
> kfree_sensitive() is broken.  (Normally UAF bugs can only be detected
> with KASan, but kfree_sensitive() should poison the data I thought).
> 

Nope.  This is thing where you need KASan to detect the bug.  I'm wrong
and continually demonstrate how even twenty years in to it I still don't
understand pointers.

regards,
dan carpenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

