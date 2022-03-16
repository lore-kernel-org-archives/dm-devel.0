Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4572C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Mar 2022 22:13:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-dbIGonTCM0ibehy1beGHdQ-1; Wed, 16 Mar 2022 18:13:46 -0400
X-MC-Unique: dbIGonTCM0ibehy1beGHdQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0555E3C02181;
	Wed, 16 Mar 2022 22:13:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DECF9468A4A;
	Wed, 16 Mar 2022 22:13:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A6A041949763;
	Wed, 16 Mar 2022 22:13:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D025E1949761
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Mar 2022 22:13:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BA3BB2156894; Wed, 16 Mar 2022 22:13:43 +0000 (UTC)
Received: from fornost.hmeau.com (vpn2-54-206.bne.redhat.com [10.64.54.206])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 752872156893
 for <dm-devel@redhat.com>; Wed, 16 Mar 2022 22:13:30 +0000 (UTC)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
 by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
 id 1nUbtK-00082l-NU; Thu, 17 Mar 2022 09:13:15 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation);
 Thu, 17 Mar 2022 10:13:13 +1200
Date: Thu, 17 Mar 2022 10:13:13 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kyle Sanderson <kyle.leet@gmail.com>
Message-ID: <YjJg+ZRQ8ufOgRtD@gondor.apana.org.au>
References: <Yh+FpKuoyj3G16lK@kroah.com> <Yh/vY4t3xnuoCW3Q@gondor.apana.org.au>
 <Yh/yr6oB5yeOUErL@silpixa00400314>
 <Yh/znCnZzWaL49+o@gondor.apana.org.au>
 <YiDHT31ujlGdQEe/@silpixa00400314> <YiEVPc2cd38AnLZB@gmail.com>
 <YiEyGoHacN80FcOL@silpixa00400314> <YiE21aPGG5DHwJvb@gmail.com>
 <YiJRQQmSxA/fbm6P@silpixa00400314>
 <CACsaVZJ2JH1M9-fB9uO=XKDuO74ZPKBHX81TQ4+bBvr_iSNiWQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACsaVZJ2JH1M9-fB9uO=XKDuO74ZPKBHX81TQ4+bBvr_iSNiWQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] Intel QAT on A2SDi-8C-HLN4F causes massive data
 corruption with dm-crypt + xfs
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
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 linux-xfs <linux-xfs@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
 Dave Chinner <david@fromorbit.com>, qat-linux@intel.com,
 Linux-Kernal <linux-kernel@vger.kernel.org>,
 Eric Biggers <ebiggers@kernel.org>,
 device-mapper development <dm-devel@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 16, 2022 at 02:38:10PM -0700, Kyle Sanderson wrote:
> > Makes sense. I'm going to send it upstream and Cc stable as documented
> > in https://www.kernel.org/doc/html/v4.10/process/stable-kernel-rules.html#option-1
> > I will then revert this change in the set that fixes the problem.
> 
> Did this go anywhere? I'm still not seeing it in any of the stable trees.

It's in the cryptodev tree which should hit mainline when the merge
window opens.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

