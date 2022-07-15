Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B80E5C43334
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jul 2022 20:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657916479;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sSIme0W6tzXY1C4Q3cotuKSB4OIx1lQJ6gpYkpMH6wc=;
	b=EpVwQri8GBgVfhaVGRxkV9hLNQ15qxGHxG0XbpC0KYJ7iD4N3gjrBeyBYtpqeWyrUbIorU
	K2xCqAhDe0ncqobMQRSmt2y1QfTGLL+Pqtz3krHJwT4gufSFdCdaVXLKoymFXJY9carSt0
	lcoa7uvOdFsOGm57dBv1SeAfKF2cV1k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-6iTGGS30Oxmak30KDs3vGw-1; Fri, 15 Jul 2022 16:21:16 -0400
X-MC-Unique: 6iTGGS30Oxmak30KDs3vGw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EA3885A5B9;
	Fri, 15 Jul 2022 20:21:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F172840CFD0A;
	Fri, 15 Jul 2022 20:21:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A7485194706F;
	Fri, 15 Jul 2022 20:21:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A2B42194706F
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Jul 2022 20:21:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6FA2F40EC003; Fri, 15 Jul 2022 20:21:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B2D840EC002
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 20:21:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53BB93C0ED42
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 20:21:12 +0000 (UTC)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-2Fn8FLVONP2HnIXsZg8wcQ-1; Fri, 15 Jul 2022 16:21:10 -0400
X-MC-Unique: 2Fn8FLVONP2HnIXsZg8wcQ-1
Received: by mail-wr1-f52.google.com with SMTP id d16so8190904wrv.10;
 Fri, 15 Jul 2022 13:21:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=7vhiJjh3WFyBtv4YUNRjLx+ofbrTWE1CdMGsJT7OWVM=;
 b=AGuTBUrBD/dRetMX6WIQIJG/FUWdCzoTtHDTIXhol/wKEU/XDBCfMOdJiORCZJCtGX
 pb+ZdPNTY7V71LhEY8MymsDB/uaEDS63DOngvzQUNskD1pSRFm/ql/cSTCJQYIOkkhTV
 oL/o9RWDEp3616nMyEY+r+uweixHGOcanmyhDBRczCbd/H6p0Jo8EesN/P5pE/W/CJFl
 G5YgMkhVeCorTXozTQsoHq6lHZ6f0QmhI5yC6w/LjlOcjVkzIX0sVhxeRybIjPcxtjO1
 rze0+W9207FrRC6rfKEUYTgz4x4SuQ2bRxBFDtrNNRn/i0fuTybGpWXRnShpzhYYhR4W
 zEyw==
X-Gm-Message-State: AJIora+qn1GW7H1uTWEAe6ZMXPyT51xnB5rReISX8ZGMR3LeNTZPu2eO
 V+xA7WyajIq/pTkuq6mK7Q==
X-Google-Smtp-Source: AGRyM1vWLJghFo4+Nw/7rg7WSzRzKWkHKtIwbO04vgAOfLyTzt+ZEXwZSynakhBnYkP97Sx73Crjfw==
X-Received: by 2002:a05:6000:1cc:b0:21d:a352:116b with SMTP id
 t12-20020a05600001cc00b0021da352116bmr13429255wrx.418.1657916463132; 
 Fri, 15 Jul 2022 13:21:03 -0700 (PDT)
Received: from localhost (127.red-81-44-149.dynamicip.rima-tde.net.
 [81.44.149.127]) by smtp.gmail.com with ESMTPSA id
 bo28-20020a056000069c00b0021dd3e2fb60sm2353332wrb.0.2022.07.15.13.21.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 Jul 2022 13:21:02 -0700 (PDT)
Message-ID: <e51be992-76cb-9607-3d63-a78e681373ab@gmail.com>
Date: Fri, 15 Jul 2022 22:21:01 +0200
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>
References: <20220714190540.117283-1-xose.vazquez@gmail.com>
 <5a3b7d5920baa0d4a967f000b3b1ea61b16cbd69.camel@suse.com>
 <3ddb4a30-b478-7d34-9e55-45b0560da2cc@gmail.com>
 <5c7214e75574c6c380261464f92c791ab1ad371d.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <5c7214e75574c6c380261464f92c791ab1ad371d.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 0/2] multipath-tools: update docs
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 7/15/22 09:33, Martin Wilck wrote:

 >> ALUA is supported in some devices, but usually it's disabled by default.
 >> To enable ALUA, the following options should be changed:

> Perhaps we should just delete the sentence "usually it's disabled by
> default"?

I do find the sentence to be accurate. "usually" does the trick.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

