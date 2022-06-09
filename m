Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 142F1C43334
	for <dm-devel@archiver.kernel.org>; Thu,  9 Jun 2022 16:36:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-QNQJHMRHNUyl-dzYJoZjCA-1; Thu, 09 Jun 2022 12:36:21 -0400
X-MC-Unique: QNQJHMRHNUyl-dzYJoZjCA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 408891C0690D;
	Thu,  9 Jun 2022 16:36:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 042F4492CA4;
	Thu,  9 Jun 2022 16:36:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CBE9B1947062;
	Thu,  9 Jun 2022 16:36:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B20F21947061
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Jun 2022 16:36:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A19D118EA4; Thu,  9 Jun 2022 16:36:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D62818EA3
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 16:36:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 828B53C1022A
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 16:36:16 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
 [209.85.221.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-qTV8P7m2MVmxGC6ltYJYLA-1; Thu, 09 Jun 2022 12:36:14 -0400
X-MC-Unique: qTV8P7m2MVmxGC6ltYJYLA-1
Received: by mail-wr1-f51.google.com with SMTP id x17so33164943wrg.6;
 Thu, 09 Jun 2022 09:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=n81KqT4tcVDUyi9Raq1Z7QINdPIzn0EFNzFSo31KApg=;
 b=kHfRTwz1fZEPL5zP4UOGDnDT7RcxGkf4LCKkYPgt/h4FxeHkz2fV/x3Nxbe+wBrGki
 reqnAeEHMDad2hkUNhb/9vSJxTnbSMBss9p7njxwSsD8Dl0+IvVatiJT7SbsfxgLqC4r
 W0/oPn4LZT2tCoIwDFrIaNHY0SQvZzklhAnJJQTRGoDbfwWvLWRfhUh3jX0zd5KSnUOi
 agfVJJHPz7zNdbOb1NGz1+AhMOhUhT1Nq1jPKoIUiCRiPjlvwTPp3NlXeWnB6HhCIObp
 E4hcFA0/cl3+U7RanzF5JU/Ra3Cj948VFApQp9EHqqa5m/W9nU++mAF2y0r7EprHTWC9
 WlUQ==
X-Gm-Message-State: AOAM530yc+YiWKwdUURC6pTeY6ozb4YVX+a24lhtc7dxraNbRiPvXfcn
 n4fdWwyDyoaIwClMha9GNTzlC6p/Iw==
X-Google-Smtp-Source: ABdhPJyBL3V2xg92kk3kA1IffKCZmrQWKqO45rLaMvXVYXh+I9Jloi1wopYlcGcg6MO2tA1var0kHg==
X-Received: by 2002:a5d:58e5:0:b0:219:e32d:cbd0 with SMTP id
 f5-20020a5d58e5000000b00219e32dcbd0mr722366wrd.28.1654792571784; 
 Thu, 09 Jun 2022 09:36:11 -0700 (PDT)
Received: from localhost (51.red-81-44-146.dynamicip.rima-tde.net.
 [81.44.146.51]) by smtp.gmail.com with ESMTPSA id
 h13-20020a5d430d000000b002130f1dfe0bsm22931450wrq.74.2022.06.09.09.36.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Jun 2022 09:36:11 -0700 (PDT)
Message-ID: <f29d01dd-676d-0d1e-77b0-df951fb7f99a@gmail.com>
Date: Thu, 9 Jun 2022 18:36:10 +0200
MIME-Version: 1.0
To: "Schremmer, Steven" <Steve.Schremmer@netapp.com>,
 Martin Wilck <mwilck@suse.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
 <20220514230148.139675-5-xose.vazquez@gmail.com>
 <SN6PR06MB4495FAEC26D7A272C2DEDA498CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
 <e014a5ee6e313404bb4d1d29c1cd4791f9660c5e.camel@suse.com>
 <SN6PR06MB44955631FFA648B74BB939318CD09@SN6PR06MB4495.namprd06.prod.outlook.com>
 <6d6f31c7e9c03eead93cc5b528bcd8979446fc91.camel@suse.com>
 <SN6PR06MB4495843B676A209F9AA0085A8CD99@SN6PR06MB4495.namprd06.prod.outlook.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <SN6PR06MB4495843B676A209F9AA0085A8CD99@SN6PR06MB4495.namprd06.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 4/9] multipath-tools: add NetApp E-Series
 NVMe to hardware table
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
Cc: "George, Martin" <Martin.George@netapp.com>,
 Hannes Reinecke <hare@suse.com>,
 ng-eseries-upstream-maintainers <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/26/22 22:10, Schremmer, Steven wrote:

> Sorry for being slow to respond to this. NetApp publishes settings for
> multipath-tools for NVMe-attach E-Series for specific distribution versions
> that we have qualified. Anyone using these settings outside of these
> versions would NOT be in a valid system configuration for NetApp support. Are
> reasonable defaults in the hardware table really useful if they cause a user
> to follow a path that leads them to an unsupported system configuration?

Do you(@NetApp crew) realize that the "NVME/.*" prod/vendor was added more than five years ago:
https://github.com/opensvc/multipath-tools/commit/4dd25783e13909cba0c38ed8bfedf76dc5a38c7b#diff-eeab98c4bb0459858e2ad17c9aa77ea30ee7a900e16cddb5325b9984b1694021

Your argument doesn't make any sense.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

