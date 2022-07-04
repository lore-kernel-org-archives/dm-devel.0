Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F188CCA473
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119239;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HfQA5qVzHHXuTtKT53ZJTwNZp5KBCHetQDnCZ1hafQo=;
	b=Lg3btG8x7rySjc2FIUVv0Q3gJNlTVkRLSqKqwGDHdo6lmqNXyFLL4UX/ms2x3++btrM3LO
	T0v9ggBFZtVKObLSZkypIeHNCC1UwfdnsQUh/phpMiQx/gSQy3ADxLNiMYGJ8JtezVt706
	9aQrrNJPxkv1hXfxxQCxo4T2IZYyRNk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-2xYsJxjlMRG_D8JR9_82Vw-1; Wed, 06 Jul 2022 10:53:57 -0400
X-MC-Unique: 2xYsJxjlMRG_D8JR9_82Vw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5ECCC38217F1;
	Wed,  6 Jul 2022 14:53:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B284C30C00;
	Wed,  6 Jul 2022 14:53:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B9AB91947074;
	Wed,  6 Jul 2022 14:53:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 664691947041
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 00:02:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 314B7492CA5; Mon,  4 Jul 2022 00:02:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D0AC492CA3
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 00:02:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5537B85A580
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 00:02:35 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-SPSMWZHTObWvPIGnEet2Sw-1; Sun, 03 Jul 2022 20:02:33 -0400
X-MC-Unique: SPSMWZHTObWvPIGnEet2Sw-1
Received: by mail-pj1-f46.google.com with SMTP id w24so7746032pjg.5
 for <dm-devel@redhat.com>; Sun, 03 Jul 2022 17:02:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=bdZMx96lFpA7S1ssPrnhd1zMXzAzvtb+hhHFnjZtUgk=;
 b=N1kJthi23ijOluVoq69Gd9C3JCoHl5NJj/aDOB77bvFJJqKTCjyest7lM0sxoGcwXi
 lmY74DXC68o1tp1xgwMLZzvHSc/74OmAZjm7jzg/9Gdin5Sy6DTCGGrujc3612+tWTJR
 fQ7w9yLhKwB0ADLbsL3dHAm/enS4eqxYO+efQJlzRRvq8q0gKE1OXmHOrb+clYmz0M9Q
 NMm9TOxox+iMKrD2fKx0OEz2NAvnkW6rydteMHjZ/dn9xcadcS9kA17mQaQh2aQkW4dC
 tTfNHgkxl0J7MGozj4ACCkQ8AW3/BNRf3oXsw5zxvgt+2S2dC02Fkl/DGJ+HRyWsf+49
 kyXQ==
X-Gm-Message-State: AJIora8/fcRgmNU2/Cu2mKzbyZ2ziRPG5ETIqYYsBR2/neO/mJnbAzff
 YGiG0e3HjmmU59J0p55yCceiQNvYimy/aA==
X-Google-Smtp-Source: AGRyM1uPU3xRrYI6KERUteamcE7kNew25JL2on5eGPfHlgelNP+XwwsSeOyFdA9OnPTTkOMJ0SZtBA==
X-Received: by 2002:a17:902:cf06:b0:16b:cc33:5bce with SMTP id
 i6-20020a170902cf0600b0016bcc335bcemr10733042plg.152.1656892952487; 
 Sun, 03 Jul 2022 17:02:32 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com
 (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
 by smtp.gmail.com with ESMTPSA id
 63-20020a621542000000b00525204224afsm20014171pfv.94.2022.07.03.17.02.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 03 Jul 2022 17:02:32 -0700 (PDT)
From: Daniil Lunev <dlunev@chromium.org>
To: Alasdair Kergon <agk@redhat.com>
Date: Mon,  4 Jul 2022 10:02:24 +1000
Message-Id: <20220704000225.345536-1-dlunev@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: [dm-devel] [PATCH 0/1] Signal to disallow open of a dm device
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
Cc: dm-devel@redhat.com, Daniil Lunev <dlunev@chromium.org>,
 Mike Snitzer <snitzer@kernel.org>, Brian Geffon <bgeffon@google.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There was a previuous discussion upstream about this kind of
functionality (see https://lkml.org/lkml/2022/1/24/633). The previous
patchset was rejected with concerns about how the feature was
integrated. This patch takes a different approach, and instead of
tying itself to unrelated mechanisms (e.g. deffer remove), this one
allows an explicit signal via message interface to signalize device
mapper shall block any further access to the device. The primary use
case is to restrict userspace access to decrypted data after a device
was setup with a kernel facility (e.g. swap).


Daniil Lunev (1):
  dm: add message command to disallow device open

 drivers/md/dm-core.h          |  1 +
 drivers/md/dm-ioctl.c         | 10 ++++++++++
 drivers/md/dm.c               | 12 ++++++++++++
 drivers/md/dm.h               | 10 ++++++++++
 include/uapi/linux/dm-ioctl.h |  5 +++++
 5 files changed, 38 insertions(+)

-- 
2.31.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

