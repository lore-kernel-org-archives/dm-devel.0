Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44081EB64D8
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687455004;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6Ii2j/ocMtplsqmoL1Kj7edb9IRVUhdBk1SQgdELfJ8=;
	b=dmJOEXTOvCTGbyDKP3PD0999E9c/oUFPdpHL5r48etpEaprUmeRmDlMfw+qlSb58m5xX8m
	nGXElpuAfem8QhaJyaQXmM6lHQCFryzZvdBcKTyic/YNk2ZCIRCxWLzMXFE/IS1uiq6XY/
	ey9vglR0kCJzy6p3aHDSGtSLrDyQ8x8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-I8m-QLkZMYif0qCygXnBOA-1; Thu, 22 Jun 2023 13:30:00 -0400
X-MC-Unique: I8m-QLkZMYif0qCygXnBOA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16B5A381BDE0;
	Thu, 22 Jun 2023 17:29:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DC3DA492B01;
	Thu, 22 Jun 2023 17:29:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ABE9E1946588;
	Thu, 22 Jun 2023 17:29:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 359561946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 17:29:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2332E40C2071; Thu, 22 Jun 2023 17:29:53 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F4F240C2063;
 Thu, 22 Jun 2023 17:29:53 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id EEEB630C0457; Thu, 22 Jun 2023 17:29:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 EB4353F7CF; Thu, 22 Jun 2023 19:29:52 +0200 (CEST)
Date: Thu, 22 Jun 2023 19:29:52 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
In-Reply-To: <20230603145244.1538-2-demi@invisiblethingslab.com>
Message-ID: <7d56d190-b97c-f515-ebd0-c3790f11954@redhat.com>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
 <20230603145244.1538-1-demi@invisiblethingslab.com>
 <20230603145244.1538-2-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
Cc: stable@vger.kernel.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Sat, 3 Jun 2023, Demi Marie Obenour wrote:

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
> +	if (next % 8) {
> +		DMERR("Next target spec (offset %u) is not 8-byte aligned", next);
> +		return -EINVAL;
> +	}
> +
>  	*spec = (struct dm_target_spec *) ((unsigned char *) last + next);
>  	*target_params = (char *) (*spec + 1);
>  
> -- 
> Sincerely,
> Demi Marie Obenour (she/her/hers)
> Invisible Things Lab

Hi

Some architectures (such as 32-bit x86) specify that the alignment of 
64-bit integers is only 4-byte. This could in theory break old userspace 
code that only uses 4-byte alignment. I would change "next % 8" to "next % 
__alignof__(struct dm_target_spec)".

I think that there is no need to backport this patch series to the stable 
kernels because the bugs that it fixes may only be exploited by the user 
with CAP_SYS_ADMIN privilege. So, there is no security or reliability 
problem being fixed.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

