Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A726AC433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 07:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667462241;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:resent-to:
	 resent-from:resent-message-id:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=Wx+cps1VICynQRdf3ux/d5H6XUJa9oO7EwplXWykcCA=;
	b=CSdaM34HrJqUq4xO4x/B7lBB1kVIILhh66AgGrY0G+qx+mDe3luc34AJNfbBlgEgAtbV/w
	pJuaQJpCPpMlCdt4fx5mKp2J0lZ77DhK22HQgkPXWYBEK6dr8v21H6rm05F/AXzahsukWl
	3b1yBm22KNcvSORZIc68pp68PZyVe+8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-Tk4IUMYgPaq72Vlvu0BrDA-1; Thu, 03 Nov 2022 03:57:20 -0400
X-MC-Unique: Tk4IUMYgPaq72Vlvu0BrDA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BABE58279A6;
	Thu,  3 Nov 2022 07:57:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A57962166B26;
	Thu,  3 Nov 2022 07:57:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 699E0194704D;
	Thu,  3 Nov 2022 07:57:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 557C11946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 06:50:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3E601121331; Thu,  3 Nov 2022 06:50:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EC56A1121325
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 06:50:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDD2E38041CE
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 06:50:11 +0000 (UTC)
Received: from havoc.proulx.com (havoc.proulx.com [96.88.95.61]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-344-OC6jJyLDOV-KQ9owHECC0w-1; Thu,
 03 Nov 2022 02:50:10 -0400
X-MC-Unique: OC6jJyLDOV-KQ9owHECC0w-1
Received: by havoc.proulx.com (Postfix, from userid 1027)
 id A133966C; Thu,  3 Nov 2022 00:42:27 -0600 (MDT)
Resent-From: Mailing List Manager <mlmgr@proulx.com>
Resent-Date: Thu, 3 Nov 2022 00:42:27 -0600
Resent-Message-ID: <20221103064227.GA14995@havoc.proulx.com>
Resent-To: dm-devel@redhat.com
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com
 [209.85.219.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-kD30BMINPXWZhaKep1o6XA-1; Thu, 03 Nov 2022 02:18:54 -0400
X-MC-Unique: kD30BMINPXWZhaKep1o6XA-1
Received: by mail-qv1-f46.google.com with SMTP id x15so541686qvp.1
 for <dm-devel@redhat.com>; Wed, 02 Nov 2022 23:18:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:subject:from:to:content-language
 :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=lwx4XT229z7abPi9xbwNzyrsP9LF8LJFLXXMOC+Hm1Y=;
 b=Vai4h7IOt4kLugfHGiz68UI2haKdkfCd2K7CM6JPsJ5P7hICDUGHg6JUOPAo5pEfcJ
 hvUShANjVML8pGa32Gp5/8dnak8gaMpHiNYeudo3B5fkpknUYejoPoesM/by+fjx8KXX
 PZHZHgt+SagJzWqFwGVC0wiJGsKQDfa8BGKjac7aciGhXIoWkHdTTerZEMyWuoq0TSYK
 B9zciWNx7GPNfzKuxNaS38zUXkFIHpx7kzSeKF1Tgy1gR7O5xBWhDDaukCOnMLlKt/X2
 FMQzq/6jkkz7arqy6LWX5dBZ6H2by0ZHTS43XZDejJpSteWaJc6oM3KJkcphGFyCOmqC
 YlbQ==
X-Gm-Message-State: ACrzQf3uWAhAD/S85Ss2Fg7WcT3Xzn0UlU/r0N1AY1IrccZHWQLH8eGK
 6q+7vSPqoiY/Y3JAJ7XDe4jtVde9zb4=
X-Google-Smtp-Source: AMsMyM6MKZvD1O2l8NYSCDLP3vrzp73bXfvoBBwoTwSZtT1kHIOVfGtrsCM/mfpr85N/tt3tXb7qKA==
X-Received: by 2002:a05:6214:1c44:b0:4bb:5fab:3af with SMTP id
 if4-20020a0562141c4400b004bb5fab03afmr25248353qvb.23.1667456333710; 
 Wed, 02 Nov 2022 23:18:53 -0700 (PDT)
Received: from [10.139.255.254] ([89.187.170.135])
 by smtp.gmail.com with ESMTPSA id
 ck10-20020a05622a230a00b0035cd6a4ba3csm7847701qtb.39.2022.11.02.23.18.52
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 02 Nov 2022 23:18:53 -0700 (PDT)
Message-ID: <376f5465-9e5d-636c-e4ef-d5827d4ec980@gmail.com>
Date: Thu, 3 Nov 2022 02:18:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
To: device-mapper development <dm-devel@redhat.com>
From: Demi Marie Obenour <demiobenour@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Thu, 03 Nov 2022 07:57:16 +0000
Subject: [dm-devel] =?utf-8?q?Kernel_panic_when_device=E2=80=99s_table_re?=
 =?utf-8?q?ferences_itself?=
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SWYgSSBydW46CgokIHN1ZG8gZG1zZXR1cCBjcmVhdGUgYmFkZGV2ICctLXRhYmxlPTAgMTAyNCB6
ZXJvJwokIHN1ZG8gZG1zZXR1cCBsb2FkIGJhZGRldiAnLS10YWJsZT0wIDEwMjQgbGluZWFyIC9k
ZXYvbWFwcGVyL2JhZGRldiAwJwokIHN1ZG8gZG1zZXR1cCBzdXNwZW5kIGJhZGRldgokIHN1ZG8g
ZG1zZXR1cCByZXN1bWUgYmFkZGV2Cgp0aGUga2VybmVsIGltbWVkaWF0ZWx5IHBhbmljcy4gIENv
bnNvbGUgb3V0cHV0IGluZGljYXRlcyBpbmZpbml0ZQpyZWN1cnNpb24gaW4gZG1fYmxvY2tfaW9j
dGwuICBUaGlzIGlzIEZlZG9yYeKAmXMgTGludXggNi4wLjUgaW4gY2FzZSBpdAptYXR0ZXJzLgot
LSAKU2luY2VyZWx5LApEZW1pIE1hcmllIE9iZW5vdXIgKHNoZS9oZXIvaGVycykKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

