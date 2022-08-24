Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 473ADC04AA5
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 23:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661384622;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xLijG7iKDqramIUF5OtOWX/GVX7bRwTUE5J+mSdgRGI=;
	b=gxN+vZElEktOnOuV5SMG3WjKxRq1UhqLf408aqMKV+jEN4XGhGo4DhEJchkyEemP5zH8ur
	Fqmb1f2spZgD4CK34ZauUIrzsPO146t1uSiGrUblUCUWa7pEKmAXQzH0ZcElVg0lqVNtJH
	Ab2ITnD6c4iA9AdZtfji5aexazc7Inw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-SFjKwXARPV6Wg0XHvsmyWg-1; Wed, 24 Aug 2022 19:43:41 -0400
X-MC-Unique: SFjKwXARPV6Wg0XHvsmyWg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72F971C09C88;
	Wed, 24 Aug 2022 23:43:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C1A874011960;
	Wed, 24 Aug 2022 23:43:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 87AD11946A47;
	Wed, 24 Aug 2022 23:43:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3B9CD1946A43
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 23:43:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D42A02166B29; Wed, 24 Aug 2022 23:43:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CFBDF2166B26
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 23:43:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B523D801231
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 23:43:16 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-252-jm5qDIBCNcuBnv7PFvFBTw-1; Wed, 24 Aug 2022 19:43:14 -0400
X-MC-Unique: jm5qDIBCNcuBnv7PFvFBTw-1
Received: by mail-pj1-f53.google.com with SMTP id
 r14-20020a17090a4dce00b001faa76931beso3211193pjl.1
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 16:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=EPlW+LT0JWjQkhBvgWfOXTs2CfL6vJ2ig51kjDOzuvE=;
 b=QQ4ixFDUgvBOOa0KLakVHirvh9bH8o71kNhyJ8noIRAD6PAXjE1b3ozVFMYQs80Cqg
 UwCJpo1DChy8DjOKsYxtE+HzF2D/ZY/EHjCnbr8pTkQyuWFfO+XDi8LeWkkY5LESPZ+y
 zl5WkYKy1EtGWpFAqgdrQKEGCZzOT49t4NZRx6I3t52/VepyX5e5Bbphr/8DN9atWugt
 Mr6eIU1lq/2t/qiBv95mSfDQp1xxnwRkrnPVUBBOA5thFGHLm7jI4OthdXo5J5u4Dz8n
 jLe6suYv1g9QB1wbxUkQ13laiUVzz6d4vnTd/EvjQNzEwjvB1LvQ/a8rC93IlOJHvS9Q
 2Hiw==
X-Gm-Message-State: ACgBeo2027ZXMjuGgCXJ5vvY3iIRcwEp7beni7ZUSXvLLPbpEnGZx/s3
 r16f0P0YIwuVTJ1kprqqrTptxfTwlGg=
X-Google-Smtp-Source: AA6agR7Mb+gBrHZFZa0PQclCVYsledOVzIfWAydKgjAvBC0iL0nu5UUGGqPzSq+P7kwYhTCFCJNDMA==
X-Received: by 2002:a17:902:e742:b0:172:fdcc:a52f with SMTP id
 p2-20020a170902e74200b00172fdcca52fmr1150155plf.40.1661384593748; 
 Wed, 24 Aug 2022 16:43:13 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:222f:dc9c:99a3:dfb8?
 ([2620:15c:211:201:222f:dc9c:99a3:dfb8])
 by smtp.gmail.com with ESMTPSA id
 y4-20020a17090322c400b0016c0c82e85csm13195300plg.75.2022.08.24.16.43.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 24 Aug 2022 16:43:12 -0700 (PDT)
Message-ID: <89b2bb4b-1848-22cc-9814-6cb6726afc18@acm.org>
Date: Wed, 24 Aug 2022 16:43:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Adam Manzanares <a.manzanares@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CGME20220522220139uscas1p1e3426b4457e0753c701e9917fe3ec6d2@uscas1p1.samsung.com>
 <20220522220128.GA347919@bgt-140510-bm01>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220522220128.GA347919@bgt-140510-bm01>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [ANNOUNCE] CFP: Zoned Storage Microconference -
 Linux Plumbers Conference 2022
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "mb@lightnvm.io" <mb@lightnvm.io>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/22/22 15:01, Adam Manzanares wrote:
> Zoned Storage Devices (SMR HDDs and ZNS SSDs) have demonstrated that they can
> improve storage capacity, throughput, and latency over conventional storage
> devices for many workloads. Zoned storage technology is deployed at scale in
> some of the largest data centers in the world. There's already a
> well-established set of storage vendors with increasing device availability and
> a mature software foundation for interacting with zoned storage devices is
> available. Zoned storage software support is evolving and their is room for
> increased file-system support and additional userspace applications.
> 
> The Zoned Storage microconference focuses on evolving the Linux zoned
> storage ecosystem by improving kernel support, file systems, and applications.
> In addition, the forum allows us to open the discussion to incorporate and grow
> the zoned storage community making sure to meet everyone's needs and
> expectations. Finally, it is an excellent opportunity for anyone interested in
> zoned storage devices to meet and discuss how we can move the ecosystem forward
> together.

Hi Adam,

On https://lpc.events/event/16/contributions/1147/ I see four speakers 
but no agenda? Will an agenda be added before the microconference starts?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

