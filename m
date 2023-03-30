Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A19C77B60
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 20:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680208301;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lrVcWcH1Ngk47U2xO8zoWzic+b5re/PAZTNMx2+no3I=;
	b=dKHgKtrGuu3ESo01L6ejux1VsUGfGmryfKOzec75d2SysxLSPtXvjlE+cK4GoZXTCooaAI
	HQNJ8NoalI4j7jH1lK7ek2FwJPTOLucZvGrSnznNP2OI9yn112SWlQ042ih0gK7AK6ofv5
	HKL87VJE6hmsJDCDJsPHjKyIzTHkLnY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-nE_nVJJ_NseaPEei5T6z0w-1; Thu, 30 Mar 2023 16:31:37 -0400
X-MC-Unique: nE_nVJJ_NseaPEei5T6z0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82830857FB2;
	Thu, 30 Mar 2023 20:31:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E63864020C86;
	Thu, 30 Mar 2023 20:31:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A48E1194658F;
	Thu, 30 Mar 2023 20:31:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3507C1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 20:31:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 14871C15BB8; Thu, 30 Mar 2023 20:31:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D23BC15BA0
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 20:31:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6A8B385054D
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 20:31:31 +0000 (UTC)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-eQLoq12dNSGVI5c0FhsDPg-1; Thu, 30 Mar 2023 16:31:30 -0400
X-MC-Unique: eQLoq12dNSGVI5c0FhsDPg-1
Received: by mail-qt1-f178.google.com with SMTP id cj15so12284011qtb.5
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 13:31:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680208289;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=OhCjWj6A07ChaEE/VAs2MqHk+Daf+HpCUVuoJdoHHkY=;
 b=WVkjUCr8AwTjpg98eiHvAFVjnzewBrEsehMUgax4AsoG+AD1v6brzXLT9tmWJIjF2h
 TVDPs0bMxWM8o4X8GFwxYARasMUA6pAPkY6LRA+BHb9ckZjus0HQUGrIGc8lYhwOHi7G
 WMdl+ai1vysCAW0V7Xi0EkdJuXY+LNlsWwkWcnFj6vP0JGT4Df1ObYHE/N4qES19JSX0
 l5WA94L2IA7Ym5VkzDibW7vkMFztELte6yJ48LgO7aLICmw5YYTuxA153ejcjGKMcTGq
 +GWxJ2uT1lCGgTTV1Xu4EYDNKeN3XVH4/jOot+vx1pkWPEMxuOrguQSDxGncK2nlX0lp
 XVtA==
X-Gm-Message-State: AAQBX9cB+Vca6nQPQDjN0viY/nmM3fYbt4+y7N0MH8MbWkYTPpZ/xiaz
 YzWhf6m8fsQSUJzgViCs4PlOb4M=
X-Google-Smtp-Source: AKy350Ys1PW85D28/axnMtdHaVIykTLm2UcqEqmi84VV10hdDWNkCTOzLB3TCnPz6RapbsyWeLZuyQ==
X-Received: by 2002:a05:622a:1208:b0:3e4:dcb4:169 with SMTP id
 y8-20020a05622a120800b003e4dcb40169mr33830225qtx.16.1680208289629; 
 Thu, 30 Mar 2023 13:31:29 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 s9-20020ac87589000000b003e4f1b3ce43sm117842qtq.50.2023.03.30.13.31.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Mar 2023 13:31:29 -0700 (PDT)
Date: Thu, 30 Mar 2023 16:31:28 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <ZCXxoMlJVnVH0TQ2@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [git pull] device mapper fixes for 6.3-rc5
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
Cc: linux-block@vger.kernel.org, Orange Kao <orange@aiven.io>,
 dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 197b6b60ae7bc51dd0814953c562833143b292aa:

  Linux 6.3-rc4 (2023-03-26 14:40:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.3/dm-fixes-2

for you to fetch changes up to 666eed46769d929c3e13636134ecfc67d75ef548:

  dm: fix __send_duplicate_bios() to always allow for splitting IO (2023-03-30 15:54:32 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix 2 DM core bugs in the code that handles splitting "abnormal" IO
  (discards, write same and secure erase) and issuing that IO to the
  correct underlying devices (and offsets within those devices).
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmQl7tQACgkQxSPxCi2d
A1rZ8ggA0MT7yLR2Bu2ZwyCXInkDdWH5cgQ5V9KqbOq80/8pMHQdxkuILej/mv6P
I3YNzRXZMkYLDoXEN6ISd6P4D+FWxP++AqPcEk8rp4eiSvmxi+R7PYe4wPDTPaKT
OAzwu1GmrJ88lUGAvfY9fNDuCApFubskasfIApUFFAQinuDPpo8fexmiiyNxPLIE
MKPoRUzsDe34C6QLjlv4BJ0hHd+zYwnwCckSlekRYdiOR8Gx4VD1mK7z3Dm8xBpA
ERCHbjCCSuz4FTyiLYJziIjZW/gY9u4N3H5w1njsnUCUmUs6/N3ETsO6qEfzeLVc
Snxdmfp+UNQnpFLA5OHfTduvU8ufKw==
=RpDD
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Mike Snitzer (2):
      dm: fix improper splitting for abnormal bios
      dm: fix __send_duplicate_bios() to always allow for splitting IO

 drivers/md/dm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

