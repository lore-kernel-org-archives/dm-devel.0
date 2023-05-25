Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AC81C77B7E
	for <dm-devel@archiver.kernel.org>; Thu, 25 May 2023 22:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685052643;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NXUHA2OJvFThk8evg/7O6W2xRs3pWISYkLbjx7QJmsQ=;
	b=U3nxiPeWS2KiWpdm0nz8fwR8QkVhDvR/sZCavEIlbueJ3/7i/cOMrjPWbFWqNhl6XOpPub
	eX9MbvCTWawoqCBYI8qXoFQmYvWkTIinfSEBWoDJJAP4fzpI1HK5K0nxYU1FL8Nq83sgiD
	IwdKKfcKVaY4PRVrc3nfQpridyEj5FM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-aciKXGGeOdmKRTvOv7hT3w-1; Thu, 25 May 2023 18:10:39 -0400
X-MC-Unique: aciKXGGeOdmKRTvOv7hT3w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C0B5811E78;
	Thu, 25 May 2023 22:10:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4DAA6200BA65;
	Thu, 25 May 2023 22:10:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 052AD19465A4;
	Thu, 25 May 2023 22:10:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E3E8D19465A0
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 May 2023 22:10:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C7EA540CFD46; Thu, 25 May 2023 22:10:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C0C0540CFD45
 for <dm-devel@redhat.com>; Thu, 25 May 2023 22:10:34 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4DA78032FA
 for <dm-devel@redhat.com>; Thu, 25 May 2023 22:10:34 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-0OuOS1-qM3-eAoe2A0rkVA-1; Thu, 25 May 2023 18:10:31 -0400
X-MC-Unique: 0OuOS1-qM3-eAoe2A0rkVA-1
Received: by mail-pl1-f181.google.com with SMTP id
 d9443c01a7336-1b00f9c4699so258865ad.3; 
 Thu, 25 May 2023 15:10:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685052630; x=1687644630;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=KWofwYKm4U81VvMJrWpV6xYO9a00UoFB6BWy/cnrY+E=;
 b=ZjNP5eQWzAFI0MxmlDV7CaWUaqp/LMIqjiEAQu2P7G2oDhTeCK6GFdI0DEMzjTB+8P
 yXTmJeRoAF6oUkou5fOpyVy9VDczmJrSNcn4tzR43VhNUoruR+/On7pUOQqDg7jDAyGt
 +GHDoDIAlET+jY8e8AsLJOhpyZjwmX7OA5ZQxJN3G6W4MOLaDy1S/NZBzq0y0CszO3jH
 IVLcLICbPMMDBxEt6lWaA6AlCj2zqfaZy/FiU8PsoPFMlX3F70Yr5Oqb23/f2McQ7V0a
 2+WiL1mxM6ikp0Lgijtpx0RaHqnNy69DGp2CgQI8YyqHYe8HEncOTKE43sVnX7X25EcU
 rKGA==
X-Gm-Message-State: AC+VfDwwMDeBPc1YShV+Wupo8VbBpjk0w+lPZJ7QcF+LNMGwAOD02nSl
 LPxHeMk1RUMyzFP2bWKnF+o=
X-Google-Smtp-Source: ACHHUZ5Fueh+Lk77s0gKla6CGp/NJ6W4v5JX985lwO2Vn9KOfWlWO5tn1wZM76Ka+eDaDGz9n18pwg==
X-Received: by 2002:a17:903:1112:b0:1a6:74f6:fa92 with SMTP id
 n18-20020a170903111200b001a674f6fa92mr288936plh.19.1685052629979; 
 Thu, 25 May 2023 15:10:29 -0700 (PDT)
Received: from localhost ([2600:380:b551:e8fe:da52:61ec:2b97:ae7f])
 by smtp.gmail.com with ESMTPSA id
 e10-20020a17090301ca00b001ae626d051bsm1879811plh.70.2023.05.25.15.10.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 25 May 2023 15:10:29 -0700 (PDT)
Date: Thu, 25 May 2023 12:10:27 -1000
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Message-ID: <ZG_c0xGh9xbXOFSt@slm.duckdns.org>
References: <20230509015032.3768622-1-tj@kernel.org>
 <20230509015032.3768622-4-tj@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230509015032.3768622-4-tj@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 03/13] dm integrity: Use
 alloc_ordered_workqueue() to create ordered workqueues
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
Cc: dm-devel@redhat.com, kernel-team@meta.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 08, 2023 at 03:50:22PM -1000, Tejun Heo wrote:
...
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: dm-devel@redhat.com
> Cc: linux-kernel@vger.kernel.org

Hey, I'm going to apply this to wq/for-6.5-cleanup-ordered. As it's an
identity conversion, it shouldn't break anything. Please holler if you have
any concerns.

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

