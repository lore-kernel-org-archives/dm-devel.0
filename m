Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE816EB64D8
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 16:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687451805;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DIoALQ8wDQRwxJBHto0+xV1c2yMdjn20EAgGdUEm5E0=;
	b=bVoIZ9HAN16asNydmUtX0tXTv1FmMODyrjDqyIVRewo7/+jISqNAIHSwtCtCnotfRm5CUM
	7ZbjnDEHFlWThflAyV2bLguR2+JJiY6qQQsBWtx2a9s9SvTbp+5nJ241sJ0MAxfWwTZ1lj
	A3AyLd69cyON6gTUCDfta7u65TiFp3k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-c7tCviS8PsSahXLrUjQpcw-1; Thu, 22 Jun 2023 12:35:54 -0400
X-MC-Unique: c7tCviS8PsSahXLrUjQpcw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B75A72809987;
	Thu, 22 Jun 2023 16:33:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A3BBD4087C6D;
	Thu, 22 Jun 2023 16:33:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3CB9E1946588;
	Thu, 22 Jun 2023 16:33:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8BEF61946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 16:33:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 666ED200B402; Thu, 22 Jun 2023 16:33:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F98C207B2BC
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 16:33:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 709543C285CF
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 16:28:50 +0000 (UTC)
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com
 [209.85.222.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-QCATSc7cOP-QArkqI3OmuA-1; Thu, 22 Jun 2023 12:28:32 -0400
X-MC-Unique: QCATSc7cOP-QArkqI3OmuA-1
Received: by mail-qk1-f182.google.com with SMTP id
 af79cd13be357-763e1a22a68so141674585a.0
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 09:28:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687451310; x=1690043310;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=HAMXHttBEpnNDM1/PVpXSoGpMwQvu/f70ID06t9hTiU=;
 b=OuZQVgmOu/9X+ZImE9201QjlnXdtPDuHezK46lN94uL1rUX9uq9p0suOKHpw0tx3OA
 EeoLqcCOz2NWmkxW8topSDvuhyzQYwRyhY2iKmnDCipgvR1kMctkPMEEWe6AZTWh3+X7
 RewpMOmNYpxAJdplxrkwSvlKBs3m36KvCIbhaNGF4UcqEjb/jU/ws+sqSq+etKEZwCuJ
 Bvwb/FggxJXL5vhNTNWa6d9NOLkUI6stsV1Kh9Y4H0byEa0gWXcjOs4ch8+Rv/an/gIA
 rhhaE60j1fNhV8HD6XS/sGDfrEa9NNGdbRDUbc/HVuTuU7quvTwJaxij+zWqftO4YKzm
 C3YA==
X-Gm-Message-State: AC+VfDy50WCEKPWYx8diDkDcNsufow0PWkKfZiGhBLjWlon0BneRxdXm
 QkztcGFCVphs38QfOTP43buxS8ISMDHvDBuCdePg
X-Google-Smtp-Source: ACHHUZ7p4DG4k30IC0D47LxEx/ITMdNMqVumDmArxV9J1Z5ICIuIa8XyBD7+Oxa3DSu7k7IRBmyJHg==
X-Received: by 2002:a05:620a:1a87:b0:762:1f9:648b with SMTP id
 bl7-20020a05620a1a8700b0076201f9648bmr13356035qkb.18.1687451309870; 
 Thu, 22 Jun 2023 09:28:29 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 w9-20020a05620a128900b007339c5114a9sm3523476qki.103.2023.06.22.09.28.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jun 2023 09:28:29 -0700 (PDT)
Date: Thu, 22 Jun 2023 12:28:28 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Demi Marie Obenour <demi@invisiblethingslab.com>, mpatocka@redhat.com
Message-ID: <ZJR2rGZw0Ddf3TFK@redhat.com>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
 <20230603145244.1538-1-demi@invisiblethingslab.com>
 <20230603145244.1538-2-demi@invisiblethingslab.com>
MIME-Version: 1.0
In-Reply-To: <20230603145244.1538-2-demi@invisiblethingslab.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v2 1/6] device-mapper: Check that target
 specs are sufficiently aligned
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jun 03 2023 at 10:52P -0400,
Demi Marie Obenour <demi@invisiblethingslab.com> wrote:

> Otherwise subsequent code will dereference a misaligned
> `struct dm_target_spec *`, which is undefined behavior.
> 
> Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> ---
>  drivers/md/dm-ioctl.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index cc77cf3d410921432eb0c62cdede7d55b9aa674a..34fa74c6a70db8aa67aaba3f6a2fc4f38ef736bc 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1394,6 +1394,13 @@ static inline fmode_t get_mode(struct dm_ioctl *param)
>  static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
>  		       struct dm_target_spec **spec, char **target_params)
>  {
> +	static_assert(_Alignof(struct dm_target_spec) <= 8,
> +		      "struct dm_target_spec has excessive alignment requirements");

Really not sure what you mean by "has excessive alignment requirements"...

> +	if (next % 8) {
> +		DMERR("Next target spec (offset %u) is not 8-byte aligned", next);
> +		return -EINVAL;
> +	}
> +
>  	*spec = (struct dm_target_spec *) ((unsigned char *) last + next);
>  	*target_params = (char *) (*spec + 1);
>  

But this patch and patches 2 and 3 need more review. I'd like Mikulas to review.

I did pick up patches 4-6 for the upcoming 6.5 merge window.

Note, please prefix with "dm ioctl" instead of "device-mapper".

(I just switched my "dm" prefix to "dm ioctl" and forced update on the
dm-6.5 branch, so the commit I referenced earlier for your version
copy patch is now here:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.5&id=a5a3de762b3ae8959347928843c12502b1b23163
)

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

