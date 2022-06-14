Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C29C43334
	for <dm-devel@archiver.kernel.org>; Tue, 14 Jun 2022 16:50:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-AWZ4zCv_NI-ykKUjWTK4og-1; Tue, 14 Jun 2022 12:50:10 -0400
X-MC-Unique: AWZ4zCv_NI-ykKUjWTK4og-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B3F13C025C4;
	Tue, 14 Jun 2022 16:50:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ECC5C1410F34;
	Tue, 14 Jun 2022 16:50:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B977194706D;
	Tue, 14 Jun 2022 16:50:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9ABFD194707C
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Jun 2022 16:50:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 606042166B29; Tue, 14 Jun 2022 16:50:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C1FA2166B26
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 16:50:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B50A811E75
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 16:50:06 +0000 (UTC)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-6kPJi6tfPM-YFWbIOZ0L2Q-1; Tue, 14 Jun 2022 12:50:04 -0400
X-MC-Unique: 6kPJi6tfPM-YFWbIOZ0L2Q-1
Received: by mail-pl1-f175.google.com with SMTP id f8so8207768plo.9
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=rvC+/Nedl9BjCL7ECC1s6Y7dE729kKFDRLyBn5eLgMM=;
 b=5Jrp6fMVuxyymsbpcZjzgtiXDnPYMIKAvh/h75rPR2NO13sZixHlSc29yuPOXzPatb
 P325WYM57tt2p0NR/8l2QUP/tFD6WH8yqj0P1ZnUOLvyV7EUssEC/PPXNngiQZptDHUp
 GD36K6UdxrgbQP18+8XRcQo6cXsCUVTbeGWs2oCc4OOx2bm2v+nT0XQog0U/mjN3r2gl
 3KzhCBh7o47eqUcIcybkLPq4I/ajLCI1NqWU9+LhI9bPuTaYAVVvDjgEv/vBv/zYD1iH
 POGhPDvA8+O7lLr2bLpno/hv311iKhL/DRvTCT2Bo5iALQ2waGcSMAlf+/stYpCwJAuX
 eiLg==
X-Gm-Message-State: AOAM53187kGGahU6PHlzHcka4ZMm9ddVC3z74q8XDlJrCqe1ufnvmBcB
 dR6Rs5AErq8bjN/9qG8TmUo=
X-Google-Smtp-Source: ABdhPJxf83xDgUq/xVfuQbUWGq9naHpl9VkamWa843H3rtpL1WAvJxeaa3kiRQy91HP+pkdeRWUVVw==
X-Received: by 2002:a17:902:f2ca:b0:167:8898:bad0 with SMTP id
 h10-20020a170902f2ca00b001678898bad0mr5107113plc.170.1655225402791; 
 Tue, 14 Jun 2022 09:50:02 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ab60:e1ea:e2eb:c1b6?
 ([2620:15c:211:201:ab60:e1ea:e2eb:c1b6])
 by smtp.gmail.com with ESMTPSA id
 z6-20020a17090a170600b001cd4989ff42sm7626942pjd.9.2022.06.14.09.50.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 14 Jun 2022 09:50:01 -0700 (PDT)
Message-ID: <4b846753-bb89-c123-2813-bcb587fdcaaf@acm.org>
Date: Tue, 14 Jun 2022 09:50:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220614090934.570632-1-hch@lst.de>
 <20220614090934.570632-5-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220614090934.570632-5-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 4/6] block: cleanup variable naming in
 get_max_io_size
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
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/14/22 02:09, Christoph Hellwig wrote:
> get_max_io_size has a very odd choice of variables names and
> initialization patterns.  Switch to more descriptive names and more
> clear initialization of them.

Hmm ... what is so odd about the variable names? I have done my best to 
chose clear and descriptive names when I introduced these names.

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

