Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E627EB64DA
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 17:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687455110;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TgMs1m1wkIGDKrxkKGjb13OAj8rDp7G93IDPlm/Pvhs=;
	b=cUdYaBdP49cBuWpipz2kxCyRIMnAnsbL81Wv7fdSnlxleAakDwM0mfnrmn4ZRaMf7sb1J7
	gCKJ0Ez55hxEBJwq1gpDz5wZLPbCLlHN9QvJe4w7SVIAw8iS9uMclgvgY1fWkgDtE2is9O
	XdJuH1ZmvUVSq4npbH0xL69X4kBFMpg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-9wj2g3V3MkqOMCCEo_NDtw-1; Thu, 22 Jun 2023 13:31:30 -0400
X-MC-Unique: 9wj2g3V3MkqOMCCEo_NDtw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F73F3C025D0;
	Thu, 22 Jun 2023 17:31:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5ACB92166B25;
	Thu, 22 Jun 2023 17:31:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1D0031946588;
	Thu, 22 Jun 2023 17:30:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 65CCF1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 17:30:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4D9C32166B3A; Thu, 22 Jun 2023 17:30:57 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EA6D2166B25;
 Thu, 22 Jun 2023 17:30:49 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id 78C5430C0457; Thu, 22 Jun 2023 17:30:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 77DE53F7CF; Thu, 22 Jun 2023 19:30:49 +0200 (CEST)
Date: Thu, 22 Jun 2023 19:30:49 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
In-Reply-To: <20230603145244.1538-3-demi@invisiblethingslab.com>
Message-ID: <d0ac7c9b-fbb-b79e-3a34-f5bc4ae87ba@redhat.com>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
 <20230603145244.1538-1-demi@invisiblethingslab.com>
 <20230603145244.1538-3-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v2 2/6] device-mapper: Avoid pointer
 arithmetic overflow
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
Cc: stable@vger.kernel.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Sat, 3 Jun 2023, Demi Marie Obenour wrote:

> Especially on 32-bit systems, it is possible for the pointer arithmetic
> to overflow and cause a userspace pointer to be dereferenced in the
> kernel.
> 
> Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-ioctl.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 34fa74c6a70db8aa67aaba3f6a2fc4f38ef736bc..64e8f16d344c47057de5e2d29e3d63202197dca0 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1396,6 +1396,25 @@ static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
>  {
>  	static_assert(_Alignof(struct dm_target_spec) <= 8,
>  		      "struct dm_target_spec has excessive alignment requirements");
> +	static_assert(offsetof(struct dm_ioctl, data) >= sizeof(struct dm_target_spec),
> +		      "struct dm_target_spec too big");
> +
> +	/*
> +	 * Number of bytes remaining, starting with last. This is always
> +	 * sizeof(struct dm_target_spec) or more, as otherwise *last was
> +	 * out of bounds already.
> +	 */
> +	size_t remaining = (char *)end - (char *)last;
> +
> +	/*
> +	 * There must be room for both the next target spec and the
> +	 * NUL-terminator of the target itself.
> +	 */
> +	if (remaining - sizeof(struct dm_target_spec) <= next) {
> +		DMERR("Target spec extends beyond end of parameters");
> +		return -EINVAL;
> +	}
> +
>  	if (next % 8) {
>  		DMERR("Next target spec (offset %u) is not 8-byte aligned", next);
>  		return -EINVAL;
> -- 
> Sincerely,
> Demi Marie Obenour (she/her/hers)
> Invisible Things Lab
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

