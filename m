Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF8CC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 07:23:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-P9rInlpkNtqjb1Jx1b8RbA-1; Wed, 25 May 2022 03:23:00 -0400
X-MC-Unique: P9rInlpkNtqjb1Jx1b8RbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4845A3C0CD4F;
	Wed, 25 May 2022 07:22:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6D29E40C128B;
	Wed, 25 May 2022 07:22:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4DFFE194EB88;
	Wed, 25 May 2022 07:22:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 425DF1947058
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 09:08:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2225840CF8F5; Fri, 20 May 2022 09:08:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E62E40CF8EB
 for <dm-devel@redhat.com>; Fri, 20 May 2022 09:08:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06E7E29AB3F5
 for <dm-devel@redhat.com>; Fri, 20 May 2022 09:08:47 +0000 (UTC)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com
 [209.85.217.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-2E_0l1DEOdeyVZ9sIjOjoQ-1; Fri, 20 May 2022 05:08:45 -0400
X-MC-Unique: 2E_0l1DEOdeyVZ9sIjOjoQ-1
Received: by mail-vs1-f42.google.com with SMTP id c26so7772631vsl.6
 for <dm-devel@redhat.com>; Fri, 20 May 2022 02:08:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=LP4RUW2X4gd93NV/k6yvJ+PBTOUEtjcm8kWRfEEJZks=;
 b=vZ2IrQXpNzdm68UZzBSEus6AGhRVLlEWuLt1DZuv4IDgm5GRUnBMEk748cNorQospc
 waqt+eCDozFrWWlbhaPqIr+H5h+SoWrssCIM2HMM4MYV0EuDqsHbL6/rmOBAxtZZLI96
 SXO71SNozUxwOREhJDH5bDPOqeub+fIYcEqK7h/Mxd71vtBtqDZKQeeXNrKv3TZ0fhbB
 my1Ef8KiqTuRsLHyyO2wRSC0Lff5bz3o/Al9ZL35jzzuBdJ17JJsyef9cOjSxwQZkUe/
 u1COMWDUuS8+vkh/5RKmuWgaao9VCB0Y7qjNkCVT3OWDb72fuFGTHzBa/hHnAO3BxfIa
 8W/A==
X-Gm-Message-State: AOAM530w7tGqbNVj9fqpSP+58FcIAwGvWsQvl2FYIncuS2HSxV3gO19n
 FCFbhIu4LrPzHSL1ifxyZgzxlv6/6CeLxU3AB92JfporMR2pYA==
X-Google-Smtp-Source: ABdhPJyaX/cH/r1Acb+5ohB8KnuycJOBRkuFt0VcKp+DklDvnAFG+t0JkhueoY9TwfOm2LG6L+Vt4fhzl9UlMp078YA=
X-Received: by 2002:a67:e15a:0:b0:335:e5c6:9381 with SMTP id
 o26-20020a67e15a000000b00335e5c69381mr4088794vsl.0.1653037724571; Fri, 20 May
 2022 02:08:44 -0700 (PDT)
MIME-Version: 1.0
From: Jasper Surmont <surmontjasper@gmail.com>
Date: Fri, 20 May 2022 12:08:34 +0300
Message-ID: <CAH4tiUu0P2FSQaN9Rk+-BC=wPntC=bBZxxj-b=3i3R6gzU8i5g@mail.gmail.com>
To: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Wed, 25 May 2022 07:22:55 +0000
Subject: [dm-devel] [Question] Changes to dm do not reflect in underlying
 block device
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I created my own dm which performs some checks on writing / reading
before it remaps the request to an underlying block dev. After I set
it up and write changes (eg using 'dd') to /dev/mapper/<name>, I see
it happened correctly (eg using 'hd' on /dev/mapper/<name>). However,
the underlying block device did not change at all (again using 'hd' on
/dev/sdb1 for example).
1. How is it possible that, even though the changes are not yet
persisted to /dev/sdb1, the dm has the correct data?
2. Is this normal behavior? If not, what can I do or what am I doing
wrong to fix this?

Thanks!

Cheers, Jasper

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

