Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0143AC0015E
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jun 2023 00:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687910860;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LEUaL4eXbnhOt883pWnRI9HPOYh8VP3oL1OzRRxv//s=;
	b=Q6k3ZcZsmOI5B/qfQYndgkeWmb95VMwUPoTLtZhdkrB4aaTUxFAf3PXGy940va63GH2TEw
	AG5Pvf0LSOg+ObEXmD7QJuXSZqdYbyJELTXrDooRjg8wqCOOAA9yg2YvlwwN/icJ8FPM4H
	ancTE4qWHsiSDlVkSpgS193n6+Rs004=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-RiUpa1wiNo-ml_UXpMIaTw-1; Tue, 27 Jun 2023 20:07:37 -0400
X-MC-Unique: RiUpa1wiNo-ml_UXpMIaTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2FE33C0FCAE;
	Wed, 28 Jun 2023 00:07:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B16C4F5CD0;
	Wed, 28 Jun 2023 00:07:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1FADE19465B5;
	Wed, 28 Jun 2023 00:07:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E6DFD1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 14:51:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B91B9200B680; Mon, 26 Jun 2023 14:51:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B1A1D200B677
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 14:51:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9834B88CC42
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 14:51:37 +0000 (UTC)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
 [209.85.167.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-clkqJuT8OW-Fg28VFkWkgw-1; Mon, 26 Jun 2023 10:51:34 -0400
X-MC-Unique: clkqJuT8OW-Fg28VFkWkgw-1
Received: by mail-lf1-f49.google.com with SMTP id
 2adb3069b0e04-4f76a0a19d4so4527463e87.2
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 07:51:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687791091; x=1690383091;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=9gU1jNjcV6TD928B0r4atzgfh+TbbilOvGXXldqDgK0=;
 b=Aprhkb2BhEi2PZWJS3DPDm1aILEtwgYB+6PC2A6t+q4TM3j2P8t1Z3tfEB+VPS/X04
 cYUIJbjHaQDRPeRFuFYEkrS9AvNOxBQ/UDI6YZT9BJknD0JkPm27OKWOhMR4M/0a3XWs
 orE9gQmMwyXs4AZEaGuDvSlrCzHeHUZ4TcSyH6jphY1YCazJ0hOnCIKpHOehOF2dUm/e
 AZGIgAFV3N46ULE4cc6HHvVGbuzV1qXuLjur82oM1n2UZNsUIhl5Ey7RffRTWW/KssOB
 7lC67GtwigmLpRasPS7fE6WfNQsCeyHRkQF5nQmBjBSj/r5Dl24DTIgrvrAn3uuJBQ0e
 VxLA==
X-Gm-Message-State: AC+VfDwpPqgE3G4bKKYxAbBf+S05mCWAxXcy7qieAyXEdadLC0hWU5yZ
 4Snykziq3dHZU3fKMYmNmya5Ww==
X-Google-Smtp-Source: ACHHUZ6CgCGY0Hct7p+o+Enwx0beOYHQwNpJ6fFz/NAiG9n54W1RtKHH9zAN0ucOoL1tyevnuFlEkQ==
X-Received: by 2002:a05:6512:3b95:b0:4f9:5d2a:e0f5 with SMTP id
 g21-20020a0565123b9500b004f95d2ae0f5mr12257430lfv.19.1687791090735; 
 Mon, 26 Jun 2023 07:51:30 -0700 (PDT)
Received: from localhost ([102.36.222.112]) by smtp.gmail.com with ESMTPSA id
 m8-20020adffe48000000b002c71b4d476asm7611864wrs.106.2023.06.26.07.51.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 26 Jun 2023 07:51:29 -0700 (PDT)
Date: Mon, 26 Jun 2023 17:51:26 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Markus Elfring <Markus.Elfring@web.de>
Message-ID: <79fdecc7-138f-476f-bc40-3603aac408ad@kadam.mountain>
References: <20230624230950.2272-3-demi@invisiblethingslab.com>
 <3241078c-2318-fe1b-33cc-7c33db71b1a6@web.de>
 <ZJh73z2CsgHEJ4iv@itl-email>
 <e42e8115-6f75-447e-9955-ca4ad43ed406@kadam.mountain>
 <c1b84520-94d2-2c5c-6eed-2a0697c086a4@web.de>
MIME-Version: 1.0
In-Reply-To: <c1b84520-94d2-2c5c-6eed-2a0697c086a4@web.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 28 Jun 2023 00:07:30 +0000
Subject: Re: [dm-devel] [v2 2/4] dm ioctl: Allow userspace to provide
 expected diskseq
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
Cc: kernel-janitors@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
 Demi Marie Obenour <demi@invisiblethingslab.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linaro.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The reason why Markus was banned was because he doesn't listen to
feedback.  I've told him several times in the past week to stop
bothering people who are trying to work but he is not going to listen.

Meanwhile, I have seen Markus fix bugs so if he wanted to focus on
fixing bugs he probably could.

regards,
dan carpenter


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

