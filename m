Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30E34C6FD1C
	for <dm-devel@archiver.kernel.org>; Thu, 23 Mar 2023 08:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679561157;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JMAGlUlz0b/1XJuWp2wc+IvzGhAGX0pd3STQcnDChhY=;
	b=VpwjhtONik5ic7CaRrbAjTpRPc1jb+UPqYMp/NQYYRr6QRlTE+sRrby5n1VAgD9wNHZlqp
	ygUAlK1S9GtGmLCKP8z12uwe/M2De/oHLt2GdmEXeVHP6Dt/+iZxigtG1N+J+S5yD6ujz3
	3GYC/mWbZ+t8CyVhYZ31n6NC1z4m4fY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-_sCOE9BNPay7V-UB0WBgGg-1; Thu, 23 Mar 2023 04:45:53 -0400
X-MC-Unique: _sCOE9BNPay7V-UB0WBgGg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5B378030D4;
	Thu, 23 Mar 2023 08:45:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 924F7492C3E;
	Thu, 23 Mar 2023 08:45:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6439319465BB;
	Thu, 23 Mar 2023 08:45:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 03BB91946589
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Mar 2023 08:45:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EB9A7140E96A; Thu, 23 Mar 2023 08:45:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E463D1410F1E
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 08:45:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD5432810C12
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 08:45:50 +0000 (UTC)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com
 [209.85.219.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-qYke0TjuPASDLd_7BbeuQg-1; Thu, 23 Mar 2023 04:45:49 -0400
X-MC-Unique: qYke0TjuPASDLd_7BbeuQg-1
Received: by mail-qv1-f41.google.com with SMTP id g9so13708241qvt.8
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 01:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679561148;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=evssvPrw+DhBofFcFzIRjRUNXZNClv8YgLvtxtwDqiI=;
 b=uZ19/v2nZoCWwa8HusgjgLN+AS1k9OrH4sP60r4wYPXnlhntYCHUEnYmvqlZ0AAAkN
 nZesVmt/twTZWWXDEZH0fDR2iyy4q68ucG6uTeIEt6ACyF8FNoLmKmWHkZOQemvpVrCA
 DRuDexOIl3IAl1BrDO6o2u61qi0+sLU2pZu0uBst0dPNCw16khmJJp/iZGHtwnIdTQgd
 NSkpFkpy8rI+xG+I+FZgx5Np1eaPbntdB2qhmFlXhrLRIvu98rGeZZDA0f+IGYTx2ggM
 vtSjcRuHFT8e/xGXcUSnvwvYGsqNJjVXSTgZ79OmG33hi1cAm1anHE3O0/EpSjZaQSQX
 B7vg==
X-Gm-Message-State: AO0yUKVfQs4DeR89Hvhf+8+3YdPa6ghntZO1lH0moaxxdApSSjgkdtBT
 uYID8gaLw0fJB5K2+4umsA66TYlAatxOi/oT3Kre
X-Google-Smtp-Source: AK7set+8WYzFPFeDCCUuPAk3zFhYtRw6zNiznuwYUOueNru5oa1073CNzC54ZMlZgRv0MgEtpo4Olg==
X-Received: by 2002:a05:6214:5296:b0:5b5:99b6:f0d0 with SMTP id
 kj22-20020a056214529600b005b599b6f0d0mr8733965qvb.32.1679561148565; 
 Thu, 23 Mar 2023 01:45:48 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 s189-20020a372cc6000000b007429961e15csm13101911qkh.118.2023.03.23.01.45.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Mar 2023 01:45:48 -0700 (PDT)
Date: Thu, 23 Mar 2023 04:45:47 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Joe Thornber <thornber@redhat.com>
Message-ID: <ZBwRu/h8YlZRcmpk@redhat.com>
References: <20230322181845.29848-1-snitzer@kernel.org>
 <20230322181845.29848-2-snitzer@kernel.org>
 <CAJ0trDaZtr4Wa7KXUMCimgMO=UmfTa3nBLTC=rZB9Kf_pvhHKQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ0trDaZtr4Wa7KXUMCimgMO=UmfTa3nBLTC=rZB9Kf_pvhHKQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [dm-6.4 PATCH 1/8] dm: split discards further if
 target sets max_discard_granularity
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
Cc: keescook@chromium.org, heinzm@redhat.com, dm-devel@redhat.com,
 nhuck@google.com, ebiggers@kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 23 2023 at  4:00P -0400,
Joe Thornber <thornber@redhat.com> wrote:

> Also nacking this patch since you refused to test it.  I said I'd test
> since you haven't, but you couldn't wait.

[Pleaase don't top-post.]

That's fine. I had already dropped this patch from linux-next due to
my testing showing it doesn't work.  I didn't think to email the list
last night.  My bad.

But I didn't refuse to test it. That implies malice or something.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

