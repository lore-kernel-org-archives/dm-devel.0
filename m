Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D709C64EC4
	for <dm-devel@archiver.kernel.org>; Thu,  9 Mar 2023 14:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678372541;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zUIrNEVb1aihJC0QSnU3vxva7B8D+nV8B0jwoGVWbJw=;
	b=Bt/5a+j066q5XxUxtChK6KLvZiUJpW6pbbzG+IG8P/0hKeHSRk4hVyiRmKHqMBh4g7WiGE
	fERS5kfNE0to/unTC1ilnjdDpcAYOjkvEKXTCskfDam6D4paVYpESq6i+DrD7UM97mN8Fe
	zoEzB0ZO/L4AZQfk4KDGsec3kaKJx/w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-9KkvcfA0PrGkQrST4VWInQ-1; Thu, 09 Mar 2023 09:35:38 -0500
X-MC-Unique: 9KkvcfA0PrGkQrST4VWInQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DE31280AA33;
	Thu,  9 Mar 2023 14:35:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BAED7440DD;
	Thu,  9 Mar 2023 14:35:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F67B19465B3;
	Thu,  9 Mar 2023 14:35:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 35D0D1946597
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Mar 2023 14:35:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0C7CF492B00; Thu,  9 Mar 2023 14:35:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 057DD492C3E
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 14:35:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF4A8280AA25
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 14:35:29 +0000 (UTC)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-j0eY-60_ODOUhK8L05yLQw-1; Thu, 09 Mar 2023 09:35:28 -0500
X-MC-Unique: j0eY-60_ODOUhK8L05yLQw-1
Received: by mail-wr1-f52.google.com with SMTP id h14so2089679wru.4
 for <dm-devel@redhat.com>; Thu, 09 Mar 2023 06:35:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678372527;
 h=content-disposition:mime-version:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=XyWSDrqwblVWEPr5uC2sGDccu0Dwv5MmFgW/a8PRARw=;
 b=L5NxTgyK/fglO7l1vjibD9UZ5DNpw+gQTCq1bO8aaCQYYdGVFWIbKbfx85qmnKv9Ph
 o7WBfJL0QLSRat8spbHJ6jiPi1obcH7U5lYJ4YfKcVy5LAjkJlG4FRh31GZ2y1XtR1Hy
 ls05XM0An9NdSt7q/A2HS/kjBFOjndDpVVHB6p7wtUjo9KGEYRQIwm+qd2RIpdY8nJTU
 GLarQUzuBHM+Lzlab1GsKVGYYQTqdWquRklHsGCVwqm3CzfV4JQo/h9eGWv+fgDeeFp0
 QMbzhrwCht5LqNoPeC426asBAkb2t2ykFVlYefyG7tqq+j2Y4b5k1Um++bg4jbDil9WT
 X9FA==
X-Gm-Message-State: AO0yUKVOWEQp5XtotvdgeLaCFZNaXf3yjKoRScdxiJxXIvnL45HHxnce
 vdVcGEPBCuP77GkzUFxR0OY=
X-Google-Smtp-Source: AK7set9V09LkWLQZiGqTNJAMyRr3Qk1Ga63Qswx+XjECtnQRrHfhRYzOh72gE5Fb/B+63Hq3m7Triw==
X-Received: by 2002:a5d:5254:0:b0:2c5:8c03:573f with SMTP id
 k20-20020a5d5254000000b002c58c03573fmr12489231wrc.31.1678372526756; 
 Thu, 09 Mar 2023 06:35:26 -0800 (PST)
Received: from localhost ([102.36.222.112]) by smtp.gmail.com with ESMTPSA id
 p13-20020a056000018d00b002c5691f13eesm17755999wrx.50.2023.03.09.06.35.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Mar 2023 06:35:26 -0800 (PST)
Date: Thu, 9 Mar 2023 17:35:20 +0300
From: Dan Carpenter <error27@gmail.com>
To: snitzer@kernel.org
Message-ID: <7df2de70-c883-4733-9c07-bf69a8ada5bb@kili.mountain>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [bug report] dm crypt: conditionally enable code needed
 for tasklet usecases
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Mike Snitzer,

The patch ae75a25bd83f: "dm crypt: conditionally enable code needed
for tasklet usecases" from Mar 6, 2023, leads to the following Smatch
static checker warning:

	drivers/md/dm-crypt.c:2758 crypt_dtr()
	warn: 'cc' was already freed.

drivers/md/dm-crypt.c
    2739         if (cc->dev)
    2740                 dm_put_device(ti, cc->dev);
    2741 
    2742         kfree_sensitive(cc->cipher_string);
    2743         kfree_sensitive(cc->key_string);
    2744         kfree_sensitive(cc->cipher_auth);
    2745         kfree_sensitive(cc->authenc_key);
    2746 
    2747         mutex_destroy(&cc->bio_alloc_lock);
    2748 
    2749         /* Must zero key material before freeing */
    2750         kfree_sensitive(cc);
                                 ^^

    2751 
    2752         spin_lock(&dm_crypt_clients_lock);
    2753         WARN_ON(!dm_crypt_clients_n);
    2754         dm_crypt_clients_n--;
    2755         crypt_calculate_pages_per_client();
    2756         spin_unlock(&dm_crypt_clients_lock);
    2757 
--> 2758         if (test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags) ||
                                                           ^^^^^^^^^
    2759             test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))
                                                            ^^^^^^^^^
UAF.  This wasn't tested, right?  If this passes testing then it means
kfree_sensitive() is broken.  (Normally UAF bugs can only be detected
with KASan, but kfree_sensitive() should poison the data I thought).

    2760                 static_branch_dec(&use_tasklet_enabled);
    2761 
    2762         dm_audit_log_dtr(DM_MSG_PREFIX, ti, 1);
    2763 }

regards,
dan carpenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

