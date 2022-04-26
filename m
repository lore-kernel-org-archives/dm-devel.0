Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E9AC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 12:15:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-Lffmn9xnPjya9NM66AGBnA-1; Wed, 27 Apr 2022 08:14:55 -0400
X-MC-Unique: Lffmn9xnPjya9NM66AGBnA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01C9418019E6;
	Wed, 27 Apr 2022 12:14:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E850C573E95;
	Wed, 27 Apr 2022 12:14:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9AD6A1947042;
	Wed, 27 Apr 2022 12:14:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9802E1947BBE
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Apr 2022 10:38:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9E6CD40F9D51; Tue, 26 Apr 2022 10:38:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 99FC640F9D40
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 10:38:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3231C802C16
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 10:38:01 +0000 (UTC)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com
 [209.85.218.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-tDZcAyQUOGmUQXyadQ60nw-1; Tue, 26 Apr 2022 06:37:49 -0400
X-MC-Unique: tDZcAyQUOGmUQXyadQ60nw-1
Received: by mail-ej1-f50.google.com with SMTP id i27so35125731ejd.9;
 Tue, 26 Apr 2022 03:37:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=CgFp2WaCcF7mJ1vuNaXuB9bhKVjzq7HvUAGwhn7dW2o=;
 b=gdyYSKrY949SpNqrUSSIaiz6Z0ylh9FtqdGfJ/3lg5VvB4Cxp/mU4Mba9ycy50t3AI
 wM6Jlv17LyBrQJbJJ4IO6PCYkwtK/5pDWQckkw305pfn9ji3N9yner+bd6zVaRsADKi/
 8mXB3ODkB/RpPXBi7nyTVdV9DyY4VXHqvNsMGLjAOA+tIVzBy6d/i9U1ZKB3nYfef8UO
 P0Hwn3Wjt+nLlqVjNMU6Us+aXM92M+gOZgbiLTAcxdM+cE+zl92NIGOgP4FdpZXbsesd
 OdmX/0eAtkgyx+g4hFIccCIHYSOzFz9GnuNczSj/QABmX6DkBZoSaXO0vMSqJDQ5jlFq
 huWg==
X-Gm-Message-State: AOAM531jb67hT5f6mwNDJ1ime+7W+va+XRLhNrtKVamTSLqEZxkoSQcv
 pQQj5OnAUEpQqfIVyoIPwvfeRnAapQgFCaZ6ibCbzWrSoN4XnTPT
X-Google-Smtp-Source: ABdhPJzTXvRlV+WIN8e2ogRFUwOeqfmDUolzB484W3uEbhLAan9KK8JsmvmFWYbjQlPmMaJHh9L5HNPj0TKEDcszNlo=
X-Received: by 2002:a17:907:628e:b0:6d9:c6fa:6168 with SMTP id
 nd14-20020a170907628e00b006d9c6fa6168mr20352022ejc.132.1650969467772; Tue, 26
 Apr 2022 03:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241643030.17244@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2204241643030.17244@file01.intranet.prod.int.rdu2.redhat.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 26 Apr 2022 12:37:08 +0200
Message-ID: <CAHp75VdHnvv6FH1BKcs8WgGF3nJpj77TsrmsQGBSpsAQU_S-bw@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Wed, 27 Apr 2022 12:14:17 +0000
Subject: Re: [dm-devel] [PATCH] hex2bin: fix access beyond string end
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
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>,
 device-mapper development <dm-devel@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Apr 24, 2022 at 10:48 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> If we pass too short string to "hex2bin" (and the string size without the
> terminating NUL character is even), "hex2bin" reads one byte after the
> terminating NUL character. This patch fixes it.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

You need to provide a Fixes tag.

...

>         while (count--) {
> -               int hi = hex_to_bin(*src++);
> -               int lo = hex_to_bin(*src++);
> +               int hi, lo;
>
> -               if ((hi < 0) || (lo < 0))
> +               hi = hex_to_bin(*src++);
> +               if (hi < 0)
> +                       return -EINVAL;

return hi;

> +               lo = hex_to_bin(*src++);
> +               if (lo < 0)
>                         return -EINVAL;

return lo;

>                 *dst++ = (hi << 4) | lo;

And on top of that it would be nice to understand if we need to
support half-bytes, but in any case it's not a scope of the patch
right now.

-- 
With Best Regards,
Andy Shevchenko

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

