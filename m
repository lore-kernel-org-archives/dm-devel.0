Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF575396
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gtEizLKB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119579;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HLvkudqanD7ho/JohV3yYMvdl0m/YZEqjpT0bM0Y7Gw=;
	b=gtEizLKBqnJbI7vg7ASEwWVSQbplEChcipRNEiFSv90sId5ZOgS9QZrEaIdsC3doHs5HGX
	HCrcgVHgsT6qxzwJRXimaAlgfZQA3U/5PPUf/eAms3igLGsjEQJw5N68qG8wcJk/KZn07g
	l3ZxTTlvOQYe9WABgwbGbaqGwifKfpY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-vR6vvakCNC6nO0k-aIl1qQ-1; Mon, 23 Oct 2023 23:52:48 -0400
X-MC-Unique: vR6vvakCNC6nO0k-aIl1qQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F9D180F8FD
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 389352026D4C
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 056491946589
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B3F241946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 967031C060BC; Tue, 24 Oct 2023 03:52:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D2FE1C060B6
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:46 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E677857CE9
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:46 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-2YKFmmucNHmpfZawCOmwyg-1; Mon, 23 Oct 2023 23:52:30 -0400
X-MC-Unique: 2YKFmmucNHmpfZawCOmwyg-1
Received: by mail-qt1-f175.google.com with SMTP id
 d75a77b69052e-41cbd1d7e04so23843131cf.1
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119550; x=1698724350;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=HLvkudqanD7ho/JohV3yYMvdl0m/YZEqjpT0bM0Y7Gw=;
 b=N7JmQ+F/lxHubobe9gQmyzu2ZqOiIrokJdBSN6Qpr22jV2//Mz9cQGF/Z9c8TcIaNJ
 JbXv1P8n3viwlmKLjcEy/C95H31EFuT9Ka4K2mIQunyxKqk3VYVWhV017NyV8ZhPoPKj
 e+ea6UsVb+Kgk/ObJ5ukUbwiZM6DMG3YAhBm8OSSlVprxi5dhh4l+MNjhanDP9uLfU+N
 VP12U5eSiwK2wF4lZ9awiSsNCrv+IsGWXZgXpbaiQPbprTHY9kpIzJBR6gh6BzXm99aH
 1BCdcXz1iKGTq+JXHX3migXPIDGRN8fiUlkUkNIakbRabg+gTuojxALGIHyNXfADN3eO
 ql0g==
X-Gm-Message-State: AOJu0YzvY7vJdw94W5r/6jwfFlkWMKwvhW3R9BmrmJHKjkpVH8gKSZMs
 OTFR9Uz2XBCZjWro0Wh+aQxD/yyQZPFDDi8Fvg==
X-Google-Smtp-Source: AGHT+IHxiDP0oQS0IHZl9PGSzz8xG4YIOPId7UdDJm7uyxgqMm7h4born+PADWw4P1qOvg39+RCjvw==
X-Received: by 2002:ac8:5c08:0:b0:41b:ff51:4e72 with SMTP id
 i8-20020ac85c08000000b0041bff514e72mr11390786qti.48.1698119550281; 
 Mon, 23 Oct 2023 20:52:30 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 kr25-20020ac861d9000000b004181c32dcc3sm3179140qtb.16.2023.10.23.20.52.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:29 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:29 -0400
Message-ID: <85311850a862fe6ccb946634429b890a.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 11/19] dm verity: set DM_TARGET_SINGLETON feature
 flag
References: <1696457386-3010-12-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-12-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 2
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> The device-mapper has a flag to mark targets as singleton, which is a
> required flag for immutable targets. Without this flag, multiple
> dm-verity targets can be added to a mapped device, which has no
> practical use cases and will let dm_table_get_immutable_target return
> NULL. This patch adds the missing flag, restricting only one
> dm-verity target per mapped device.
> 
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v1-v10:
>   + Not present
> ---
>  drivers/md/dm-verity-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This seems reasonable to me and matches with other users of
DM_TARGET_IMMUTABLE.

Alasdair, Mike, can we get an ACK on this?

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 26adcfea0302..80673b66c194 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1503,7 +1503,7 @@ int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned i
>  
>  static struct target_type verity_target = {
>  	.name		= "verity",
> -	.features	= DM_TARGET_IMMUTABLE,
> +	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
>  	.version	= {1, 9, 0},
>  	.module		= THIS_MODULE,
>  	.ctr		= verity_ctr,
> -- 
> 2.25.1

--
paul-moore.com

