Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11DFBC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jul 2022 18:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658513580;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=r9mrusie4QELlsjOk+oJ9Ga4H0EUB65gDiWTN1bbwHI=;
	b=WCogRPA3O0+BhvW7huZ7/qp4MU2H4q1K9JUi8X3Xncl0hvYLxJvhEkR+K8X2vBFWl52zWk
	cZYqUZkMt7pfIXkU1g2ZXvGSilOIL9BrddRl30+W0vxXuMIhippMU8IoRNCtd6UAoBi+JA
	6guxScR6bIaU2g/n7ZRDF9i0KxZCByE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-Ac8-sCI9PXWs3THJbJ3XlQ-1; Fri, 22 Jul 2022 14:12:57 -0400
X-MC-Unique: Ac8-sCI9PXWs3THJbJ3XlQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AB52805B9A;
	Fri, 22 Jul 2022 18:12:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E3EE400DFD7;
	Fri, 22 Jul 2022 18:12:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E6266194704D;
	Fri, 22 Jul 2022 18:12:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7DD591947049
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Jul 2022 18:12:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6897D1121315; Fri, 22 Jul 2022 18:12:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 64B3A1121314
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 18:12:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AF3D1857F02
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 18:12:52 +0000 (UTC)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-W_ayLEsFPoeFRs3Q3HpslA-1; Fri, 22 Jul 2022 14:12:42 -0400
X-MC-Unique: W_ayLEsFPoeFRs3Q3HpslA-1
Received: by mail-pl1-f178.google.com with SMTP id x1so3442843plb.3;
 Fri, 22 Jul 2022 11:12:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=94Oby05bvjJaQQASVxPlgqvgjisXx8t3hxHO3QsA8+k=;
 b=yDvdPmvV3U9js7mMVqZ+aBOR8GbNQAGwoN4m51+NI/2vz1EEAzBI3ROo72tPOSz7LY
 ZRQNN/uHrQ2kKyJJ4sXfVbmnEZ0iSeNu5UJriRMwOMz7Y/vlKKExNc/meOyMgz2mm7A1
 pxLgP5cviwzTFp3k52a8UBbcezrsaaDTYw01LGfgMAtRhAVQ/YYZOb3VKp3Go6UiPxnG
 OgiV9XHT9M/71gw/J8w1sfWNktMdYs8ChTttRtgrk+b3NPvAlGh1oiODunkW7YkKrUBj
 NbGSp39PmwHQzHi9L7GvuxqNz9ATdHHym5laZrYsJXZRUbQPFRJexDHa/P/1Ja5E8YOm
 C+iQ==
X-Gm-Message-State: AJIora/1oM7EvZxQs1nG6Za4Ki80Qgf5SRoM/itsOjIclBI34EFORCJt
 qXimjFiqLwxKzh8Dmg9te0Y=
X-Google-Smtp-Source: AGRyM1vmngp+q5tAzlDopuZuD6x6siNgfw4OExR8SHfAeKtUxThUPYuDDHzVOa8fIkfovNQQ/T66+w==
X-Received: by 2002:a17:902:aa84:b0:16d:3ec4:cfc8 with SMTP id
 d4-20020a170902aa8400b0016d3ec4cfc8mr1015154plr.153.1658513560961; 
 Fri, 22 Jul 2022 11:12:40 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9cf6:7e29:d977:6fc7?
 ([2620:15c:211:201:9cf6:7e29:d977:6fc7])
 by smtp.gmail.com with ESMTPSA id
 d1-20020a170902cec100b0016cbb46806asm4104906plg.278.2022.07.22.11.12.39
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 22 Jul 2022 11:12:40 -0700 (PDT)
Message-ID: <cabd732a-9942-3ece-8141-c0bc6378faca@acm.org>
Date: Fri, 22 Jul 2022 11:12:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@infradead.org>,
 Nathan Huckleberry <nhuck@google.com>
References: <20220722093823.4158756-1-nhuck@google.com>
 <YtrTI/CJMoLihA/1@infradead.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YtrTI/CJMoLihA/1@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 0/3] dm-verity: optionally use tasklets in
 dm-verity
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
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Sami Tolvanen <samitolvanen@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Alasdair Kergon <agk@redhat.com>
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

On 7/22/22 09:41, Christoph Hellwig wrote:
> We've been tying to kill off task lets for about 15 years.  I don't
> think adding new users will make you a whole lot of friends..

+1 for not using tasklets. At least in Android the real-time thread 
scheduling latency is important. Tasklets are not visible to the 
scheduler and hence cause latency spikes for real-time threads. These 
latency spikes can be observed by users, e.g. if the real-time thread is 
involved in audio playback.

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

