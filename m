Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32A59EB64DC
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 07:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686726425;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=swxBJrlO+fSbXWhRDB0bjbHOXtPOBki+5oMOkvaB9Oc=;
	b=JViMYu1smdWekW8OvS5M4GcVqCxCVbQiuz0K/vsO5M07p+5yys6aWVoSV6rNZeCDKbdxKA
	RatXosiYQEa8rT3H3zw4Bv2xfPHOUcBPKYD7Pfsi0gQ7ZFAi64vQVALbDWXI0HDZFN7wyg
	IEDz2eU0BFcGKA6thfaVgArcBNHeQ88=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-v7ObmtDMPdSKTUNFaAuo3A-1; Wed, 14 Jun 2023 03:06:58 -0400
X-MC-Unique: v7ObmtDMPdSKTUNFaAuo3A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A9F3101AA4A;
	Wed, 14 Jun 2023 07:06:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 597BC1415102;
	Wed, 14 Jun 2023 07:06:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 135C419452CA;
	Wed, 14 Jun 2023 07:06:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 86847194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Jun 2023 13:14:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 28426492CAC; Tue, 13 Jun 2023 13:14:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2091A492CA6
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 13:14:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 012B1185A791
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 13:14:02 +0000 (UTC)
Received: from eu-smtp-delivery-151.mimecast.com
 (eu-smtp-delivery-151.mimecast.com [185.58.86.151]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384)
 id us-mta-107-5lTqd4EkOLuwqggYkhXS8Q-1; Tue, 13 Jun 2023 09:14:00 -0400
X-MC-Unique: 5lTqd4EkOLuwqggYkhXS8Q-1
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-243-RHC9QOAiM16LchjskEkjgg-1; Tue, 13 Jun 2023 14:13:58 +0100
X-MC-Unique: RHC9QOAiM16LchjskEkjgg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 13 Jun
 2023 14:13:54 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Tue, 13 Jun 2023 14:13:54 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Andy Shevchenko' <andriy.shevchenko@linux.intel.com>, Mike Snitzer
 <snitzer@kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Thread-Topic: [PATCH v1 1/1] dm integrity: Use %*ph for printing hexdump of a
 small buffer
Thread-Index: AQHZnXeLSrJRda3jvkm5aLqRk0NSF6+Ithrw
Date: Tue, 13 Jun 2023 13:13:54 +0000
Message-ID: <516b13b634374885891ac1e808d37ce3@AcuMS.aculab.com>
References: <20230612214751.9662-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230612214751.9662-1-andriy.shevchenko@linux.intel.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Wed, 14 Jun 2023 07:06:43 +0000
Subject: Re: [dm-devel] [PATCH v1 1/1] dm integrity: Use %*ph for printing
 hexdump of a small buffer
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
Cc: Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Andy Shevchenko
> Sent: 12 June 2023 22:48
> 
> The kernel already has a helper to print a hexdump of a small
> buffer via pointer extension. Use that instead of open coded
> variant.
> 
> In long term it helps to kill pr_cont() or at least narrow down
> its use.
> 
> Note, the format is slightly changed, i.e. the colon is not printed
> before the buffer dump and the trailing space is always printed.
> These are not a problem since it's a debug message. Also the IV dump
> is limited by 64 bytes which seems fine.
...
> +#define DEBUG_bytes(bytes, len, msg, ...)	printk(KERN_DEBUG msg " %*ph\n", ##__VA_ARGS__, len,
> bytes)

Using:
	printf(KERN_DEBUG msg "%s%*ph\n", ##__VA_ARGS__, len ? ": " : "", len, bytes)
would add back the optional ':'.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

