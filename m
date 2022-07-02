Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59688C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 07:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657178895;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Z1RdW3bTqMePNatJ7evA+hjud2qFm/Y+w65mFfIp6B8=;
	b=XBYQLhwA9NPA1ctYCcC2CaMiSr/UYbilitvc87MvqUMDSMM1WiJ8ChtmaReiX8Ci6KjpBU
	AyEdp5N8u9urz+v5rsW0Hi3ILsLgdQK3tn+jDL+PhvyTYHAvvcTSdZHz1GaF6negn5YRUq
	59UZoNh+KqaNX/G+jxWnlGYVMKo4mw4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502--YEW1uw7O9mDnIoJK0941g-1; Thu, 07 Jul 2022 03:28:06 -0400
X-MC-Unique: -YEW1uw7O9mDnIoJK0941g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7D8B299E77C;
	Thu,  7 Jul 2022 07:28:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 933AE492CA2;
	Thu,  7 Jul 2022 07:28:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0EE7E1947073;
	Thu,  7 Jul 2022 07:28:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B79781947079
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 04:26:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A94F540E7F29; Sat,  2 Jul 2022 04:26:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A59F740E7F28
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 04:26:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DF96185A794
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 04:26:24 +0000 (UTC)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-5yP1ku2hMNe-DDpYQrs4QA-1; Sat, 02 Jul 2022 00:26:20 -0400
X-MC-Unique: 5yP1ku2hMNe-DDpYQrs4QA-1
Received: by mail-pj1-f44.google.com with SMTP id
 73-20020a17090a0fcf00b001eaee69f600so4555324pjz.1; 
 Fri, 01 Jul 2022 21:26:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=CrnMX/y17RbreUUoQH2OPYzTSPe+shNvumhDkSBxTNs=;
 b=67R2ppY4y91kBzi6eoaMP900W2waabX2U1PtNlV/Iq0ytuGllstTkRc3Q0ac7EWLR+
 0pJKRCKGHbS7kTtoy00x+JgJIa11T/CjHzXkLL/iA2s55iPPmKYYMlJLCp6IavaVC/I7
 j790rcaC7ehqsdyH9H0M92tzMsXdSYTl4w/pA5b7EMBQHQ3rz1iB27izMhj/ahYMDi5y
 3kSsi84fPynk2ptjcyD8oiL5zI67dqiEwdd0GHTk8qvvJZ79pdYYC0U52YSBYcbbU4pe
 GRdHJLLFXQabvPUKzbTTGoZqibH8WrehMqN+gQynyfCgziBE+r/SXEFLYIw6uORF9Co9
 5uEw==
X-Gm-Message-State: AJIora8Oex7U3/n0DC3r/2IR4WxN6nfKuY3MzSmloEmlshiEynq6n61u
 6UlpQ/p2zvvJNRboezikOAKWOeBlm2qmgw==
X-Google-Smtp-Source: AGRyM1uZafyoF1S6AVLn7IBZsh2efEOnKLTPX84jcOmtzDIgrEzXdlwftEixQdfH+iRTZ0auN4LeFg==
X-Received: by 2002:a17:902:d491:b0:16a:76c5:c1fa with SMTP id
 c17-20020a170902d49100b0016a76c5c1famr24976368plg.103.1656735978654; 
 Fri, 01 Jul 2022 21:26:18 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-9.three.co.id. [180.214.233.9])
 by smtp.gmail.com with ESMTPSA id
 q6-20020a63cc46000000b0040d287f1378sm16246039pgi.7.2022.07.01.21.26.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Jul 2022 21:26:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id 21DDF1038FC; Sat,  2 Jul 2022 11:23:53 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: linux-doc@vger.kernel.org
Date: Sat,  2 Jul 2022 11:23:48 +0700
Message-Id: <20220702042350.23187-1-bagasdotme@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Thu, 07 Jul 2022 07:28:03 +0000
Subject: [dm-devel] [PATCH 0/2] Documentation: dm writecache: documentation
 fixes
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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Bagas Sanjaya <bagasdotme@gmail.com>,
 Ross Zwisler <zwisler@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 Colin Ian King <colin.king@intel.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Two small documentation fixes for writecache functionality of device
mapper. The shortlog below should be self-explanatory.

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Colin Ian King <colin.king@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: dm-devel@redhat.com
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Bagas Sanjaya (2):
  Documentation: dm writecache: Add missing blank line before optional
    parameters
  Documentation: dm writecache: Render status list as list

 Documentation/admin-guide/device-mapper/writecache.rst | 2 ++
 1 file changed, 2 insertions(+)


base-commit: 089866061428ec9bf67221247c936792078c41a4
-- 
An old man doll... just what I always wanted! - Clara

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

