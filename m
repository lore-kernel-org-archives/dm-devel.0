Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC287C64EC7
	for <dm-devel@archiver.kernel.org>; Sun, 26 Feb 2023 02:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677376908;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OFA0rPPzDL/jwBbpjd542piJN3uKPGSv+VrfpqICxXg=;
	b=ERAhrAX8nd5FYP+irnjYgIM94ghWHoYmT2LOtsnGO6aWsefj5KvHHPTteXhScERNtwoTLz
	GsZLmJZ4rYlbQUsgWOvaxzW+A2mujfW/7e/8Cq4GbSpwgkt/thqL0TBZm8AGm3rM9dOu05
	gKp/QEob+yBXJTMTSBQm+WkX4IpZNho=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-yqzNOGtBN6OVCaW6Se_GIg-1; Sat, 25 Feb 2023 21:01:45 -0500
X-MC-Unique: yqzNOGtBN6OVCaW6Se_GIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C570380406E;
	Sun, 26 Feb 2023 02:01:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4D0B8404BEC0;
	Sun, 26 Feb 2023 02:01:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0DDC319465B1;
	Sun, 26 Feb 2023 02:01:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 46C7619465A4
 for <dm-devel@listman.corp.redhat.com>; Sun, 26 Feb 2023 02:01:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 39C7C1415113; Sun, 26 Feb 2023 02:01:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 31861140EBF4
 for <dm-devel@redhat.com>; Sun, 26 Feb 2023 02:01:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 159203C02B66
 for <dm-devel@redhat.com>; Sun, 26 Feb 2023 02:01:19 +0000 (UTC)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-547-kog4EhMEOTKM3FJh3_HgEQ-1; Sat, 25 Feb 2023 21:01:16 -0500
X-MC-Unique: kog4EhMEOTKM3FJh3_HgEQ-1
Received: by mail-pl1-f174.google.com with SMTP id p20so2177658plw.13;
 Sat, 25 Feb 2023 18:01:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ypKOgjk9Tyqc0r8DgCf1p+SxUXCBGzKz2HATmqad/5s=;
 b=TvurGE0lgfiLRjjek5TZSxJORa/0jxJAHrKicPGmTx2sLOahNdhqqVAw99hVHI0ORh
 A6p5sOy7RaamzO9/Txju0o7jBpUkays8V1ObHoLVGNqpB3iSH6uV4LmUFsxSh3qg1Nsr
 ozmSTLRWkRn2abdjjZBTW0t4Q9Y2V3tt503TgM6ePnjLV1/35ym3x1j/ijVKKHS49dz0
 KSUMj5zwMsuVqXtJ28MNB0RctSJ7+hnEV9T+JmYCwPmC+sjiSKoHFRgqViEieExoxgL2
 W9v4TYcF+t60ryUkC8wdiCXkgZdpSy7gJS8f8nDe3/dqI4T1SYdjjHy0MlWMKsAiaOrs
 RJAA==
X-Gm-Message-State: AO0yUKXic0n9dhF3+JtMnauVh4oiRD4kLiEINluHNlO7zZWmyXfCdG65
 VQg9nPolets3k82dQRTlgk4=
X-Google-Smtp-Source: AK7set8lx6sOiJZbuqKtx6guCdn8BH7OGO3oHPlE+gpduOM1iwG/l4ju04qaJJtLL6lOrwQybpJ1Fw==
X-Received: by 2002:a17:90b:1e11:b0:22c:d44:5669 with SMTP id
 pg17-20020a17090b1e1100b0022c0d445669mr4587448pjb.22.1677376875574; 
 Sat, 25 Feb 2023 18:01:15 -0800 (PST)
Received: from [192.168.3.219] ([98.51.102.78])
 by smtp.gmail.com with ESMTPSA id
 hg3-20020a17090b300300b00233afe09177sm3633555pjb.8.2023.02.25.18.01.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 25 Feb 2023 18:01:14 -0800 (PST)
Message-ID: <b7020147-2382-71f6-5237-8501562f8011@acm.org>
Date: Sat, 25 Feb 2023 18:01:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To: yangerkun <yangerkun@huaweicloud.com>, agk@redhat.com,
 snitzer@kernel.org, dm-devel@redhat.com
References: <20230223031947.3717433-1-yangerkun@huaweicloud.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230223031947.3717433-1-yangerkun@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] dm-crypt: fix softlockup in dmcrypt_write
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
Cc: yangerkun@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 2/22/23 19:19, yangerkun wrote:
> @@ -1924,6 +1926,10 @@ static int dmcrypt_write(void *data)
>   
>   		BUG_ON(rb_parent(write_tree.rb_node));
>   
> +		if (time_is_before_jiffies(start_time + HZ)) {
> +			schedule();
> +			start_time = jiffies;
> +		}

Why schedule() instead of cond_resched()?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

