Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2F8FC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 18:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666118691;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XGFdihIaWJ5SA5/KWiLwCn1W9VAIVJodzjCt9xrmItA=;
	b=i2FA3378Y0jbUq7jQcK6+4ey3zSp7rA+wscDdgtLBu8NOnEAQDN8GN+Epk7O9oSk+sse0O
	dw1J5kO97ZzOaD/rUpk8Ix8Qu7G1VuNpGbsrtpynwRWNhP0K3a/0EkVV0xzXgU8OsCNaX3
	Ol7ExkSQyIr19GEAYI5qav/svMNAaa4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-A4evipIENDWdtuKQznwWFA-1; Tue, 18 Oct 2022 14:44:48 -0400
X-MC-Unique: A4evipIENDWdtuKQznwWFA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE4DC811E75;
	Tue, 18 Oct 2022 18:44:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68A484030C7;
	Tue, 18 Oct 2022 18:44:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4512D1946594;
	Tue, 18 Oct 2022 18:44:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6ABE1194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 18:44:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5B7572022C33; Tue, 18 Oct 2022 18:44:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 54CA52022C2B
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 18:44:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 376EA3C0DDB2
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 18:44:39 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-365-oqSkpPh-PQ2Cluy1WrjOAg-1; Tue, 18 Oct 2022 14:44:37 -0400
X-MC-Unique: oqSkpPh-PQ2Cluy1WrjOAg-1
Received: by mail-qt1-f175.google.com with SMTP id l28so10261697qtv.4
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 11:44:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=stlH/SoLoTxeHdDl6sjryAM2rO8hfi05PwPVPZbgTnE=;
 b=h/5W1HOnhLFr+wMb1Z3Iguwjp1i7tz4cQbiE/4JG/OOlal3lDWOGfJC0oqRel9evyk
 lI4das4m6FlmUZs4vANczaeqVbNl1GBKhhvVmhIpMRNbNt6SIOXvx5El7wDOZQ6/mhMw
 wfv4bKuRYM7qg9sH/pNlXJti+AqSxeO+CnnprF80p7M+gn9aCPJvrm6+fByVOloq5Tzm
 P/7R1USrNN6pP6OZZiiitc7iNI/9c7nLX8hFylzpwHGQF1CZVAIHzulWT8zthVltRq15
 dWn8mps28oIM2uzvUVrkHVgyWyEofkCEXGtON7FHRMYDZJVQ3ryHENW97omjqdq9gj54
 zT/Q==
X-Gm-Message-State: ACrzQf0E1jkX9h7Yd7iRZy6GPvXGj2I1eeRhvFaj+V48zTP4zxciq8rB
 tkGOi8/VR7dHJY6Znj+hUv5mQ5I=
X-Google-Smtp-Source: AMsMyM6CrAbtDjrjT2e043kwE0xeXRgbI9q5gHVmvpiuLusuhlpMS2D1xi9kn0v7CVVHfKrOwIm2VA==
X-Received: by 2002:a05:622a:18a0:b0:39b:e6e5:3f6b with SMTP id
 v32-20020a05622a18a000b0039be6e53f6bmr3250715qtc.613.1666118677335; 
 Tue, 18 Oct 2022 11:44:37 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 u6-20020a05620a430600b006e16dcf99c8sm3042688qko.71.2022.10.18.11.44.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Oct 2022 11:44:36 -0700 (PDT)
Date: Tue, 18 Oct 2022 14:44:35 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Y070ExTjLGLStSQ0@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [git pull] device mapper fix for 6.1-rc2
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit bb1a1146467ad812bb65440696df0782e2bc63c8:

  Merge tag 'cgroup-for-6.1-rc1-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup (2022-10-17 18:52:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.1/dm-fix

for you to fetch changes up to 141b3523e9be6f15577acf4bbc3bc1f82d81d6d1:

  dm bufio: use the acquire memory barrier when testing for B_READING (2022-10-18 12:38:16 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix dm-bufio to use test_bit_acquire to properly test_bit on arches
  with weaker memory ordering.

----------------------------------------------------------------
Mikulas Patocka (1):
      dm bufio: use the acquire memory barrier when testing for B_READING

 drivers/md/dm-bufio.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

