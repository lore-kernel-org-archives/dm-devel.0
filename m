Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E59D1C433F5
	for <dm-devel@archiver.kernel.org>; Sun, 24 Apr 2022 21:42:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-K84cKOrnNKmVeqQtFAUYbw-1; Sun, 24 Apr 2022 17:42:55 -0400
X-MC-Unique: K84cKOrnNKmVeqQtFAUYbw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42665185A79C;
	Sun, 24 Apr 2022 21:42:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 317B7C27E94;
	Sun, 24 Apr 2022 21:42:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F28181947BBE;
	Sun, 24 Apr 2022 21:42:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2C56A1947BBD
 for <dm-devel@listman.corp.redhat.com>; Sun, 24 Apr 2022 21:42:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1673E9E6B; Sun, 24 Apr 2022 21:42:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 110E99E6A
 for <dm-devel@redhat.com>; Sun, 24 Apr 2022 21:42:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4E4A1C05AE8
 for <dm-devel@redhat.com>; Sun, 24 Apr 2022 21:42:49 +0000 (UTC)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com
 [209.85.167.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303--refStU7OCKX_6CDzyh45A-1; Sun, 24 Apr 2022 17:42:48 -0400
X-MC-Unique: -refStU7OCKX_6CDzyh45A-1
Received: by mail-lf1-f54.google.com with SMTP id g19so23148879lfv.2
 for <dm-devel@redhat.com>; Sun, 24 Apr 2022 14:42:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=7MOvdDWFomD1nJ5GdyiOljnnxohoncHWbCnMwGFS3Nw=;
 b=Z5Z3GRzq6SzcUcUjhsMS3C5Py7drTjuo7Depkby2o/4Vv41Ys114UBA3FnV3a45vtJ
 dOy3z58sZLk8F544AOcMDadcLCPNF7Xo7gQQOUY7v9a/wkacfasnlyumIhLGcKQkYegG
 loZXk8TjT51tORPwP8fENjyw9t8HV09qzLXXN9vw43IgZ7MEoJGOQMJBxKDmbRNBFqZs
 VNtn7cGlm6CzDnvfz2F8GrBMrjjG6cCbiuA5Z3NuvxSsrKmYRe7lyE+xXZdVjmCkVa67
 vYzSNMV+yxfLeNPT2WQR2OG5Gc8Zdxs8FY8UV9abdmgokrcjCUAlKQWzPUBt3TU20VMz
 IaUw==
X-Gm-Message-State: AOAM5303A7SmgCAXkoH/uiMja52/3YEaWXkpLEMlOoiFdQnrNxYfqh9q
 5XtlktsN58jw1s7kaWiAAjYRhl/Jaowv22Opm88=
X-Google-Smtp-Source: ABdhPJx5vSXg/SzcGtNDKupP+bWR8mJxsvguP01TcmbKXgKGSc6z3r2JSWYyiTQDaklz5QDH2gNQPQ==
X-Received: by 2002:a05:6512:e87:b0:44a:5117:2b2b with SMTP id
 bi7-20020a0565120e8700b0044a51172b2bmr10666615lfb.275.1650836566169; 
 Sun, 24 Apr 2022 14:42:46 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com.
 [209.85.208.170]) by smtp.gmail.com with ESMTPSA id
 p21-20020a056512139500b00447c9b87945sm1155311lfa.172.2022.04.24.14.42.44
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 24 Apr 2022 14:42:44 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id y19so4437090ljd.4
 for <dm-devel@redhat.com>; Sun, 24 Apr 2022 14:42:44 -0700 (PDT)
X-Received: by 2002:a2e:8789:0:b0:24f:124c:864a with SMTP id
 n9-20020a2e8789000000b0024f124c864amr824977lji.164.1650836564386; Sun, 24 Apr
 2022 14:42:44 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
In-Reply-To: <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 24 Apr 2022 14:42:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wibmkFz6dybsdpW_3kUnV20FhJazerWDcbm7yCp_Xv+CA@mail.gmail.com>
Message-ID: <CAHk-=wibmkFz6dybsdpW_3kUnV20FhJazerWDcbm7yCp_Xv+CA@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH] hex2bin: make the function hex_to_bin
 constant-time
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
Cc: Andy Shevchenko <andy@kernel.org>, Mike Snitzer <msnitzer@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>, Milan Broz <gmazyland@gmail.com>,
 device-mapper development <dm-devel@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Apr 24, 2022 at 2:37 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Finally, for the same reason - please don't use ">> 8".  Because I do
> not believe that bit 8 is well-defined in your arithmetic. The *sign*
> bit will be, but I'm not convinced bit 8 is.

Hmm.. I think it's ok. It can indeed overflow in 'char' and change the
sign in bit #7, but I suspect bit #8 is always fine.

Still, If you want to just extend the sign bit, ">> 31" _is_ the
obvious thing to use (yeah, yeah, properly "sizeof(int)*8-1" or
whatever, you get my drift).

           Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

