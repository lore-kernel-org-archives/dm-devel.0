Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25D36C352A1
	for <dm-devel@archiver.kernel.org>; Tue,  6 Dec 2022 18:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670352966;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LyfvhxeSwn3J0sywVU3Ma8iFq3SBFC81EsG1Ar72qc8=;
	b=UMgS8Sq3L9cW0cBshqFTZsQMMhExwaoBTFVJXOg/B4CYApv4MgEBjVEz5xZdzi2kkCiwhA
	yB/vTeifsL/gtFz+OxeBvJnTlUrkQhTwcwxJwKRaZqvtUz1DJsms1laLJ9QS6/huEujEQj
	PlExgLIXRUDe6nnV2uOVcnY4rGoINPs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-gobBlw6KPbykdal52F2xjQ-1; Tue, 06 Dec 2022 13:56:03 -0500
X-MC-Unique: gobBlw6KPbykdal52F2xjQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8595857F8F;
	Tue,  6 Dec 2022 18:56:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D0C4140EBF5;
	Tue,  6 Dec 2022 18:56:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 58A441946A52;
	Tue,  6 Dec 2022 18:55:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 20B1019465B5
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Dec 2022 18:55:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE2DF1121315; Tue,  6 Dec 2022 18:55:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B6FB91121314
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 18:55:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 922983C0D854
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 18:55:44 +0000 (UTC)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-588-poJR0r1tMeW0auQe_suuJQ-1; Tue, 06 Dec 2022 13:55:43 -0500
X-MC-Unique: poJR0r1tMeW0auQe_suuJQ-1
Received: by mail-pg1-f175.google.com with SMTP id f9so14179266pgf.7
 for <dm-devel@redhat.com>; Tue, 06 Dec 2022 10:55:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=lPHt//IGe+mjUQhKRlsPO2uaXa6rXyJmJ4qRK45NUH0=;
 b=laps1b9yC89oAvQZpGXwLEsNJpoHEoiPaoJbBigZjPWEp6Z7QWilUCtK1zcVVyZjcn
 OIhEBpFcJVYOnKLhQ7X45sOKHZXlZgKNncxXysWFmpJDQCEqnEiP5nrvZrP8fg0I+fkZ
 GOowZp6NLE0z5+je4Scau94XBhU0Cvdlc8s0K1Skq/jkccsH0blDo3VbGcvUqkPJ5BB1
 q+6LHPJ7d4cxzv7EahE5Qb9rOWX3xka05GAPnoiAxfZy7AZ7scMPh1Ndlt+xhgOe1mjN
 TeMnX3DQmprqAXXDE5u+7/r+3gFN42DkFW8XjLaCoNVg9djs+HuCxH2x2Qzg4Xtlk9gO
 DPwA==
X-Gm-Message-State: ANoB5pmclMukZjbreMcgSf/bV2CLb4iea2S5m49nZlF0yxVeAO6GeOcf
 nJ8PfU11azKfn2oIpCOz9lI=
X-Google-Smtp-Source: AA0mqf6bx+k2Mb8T/uAbgfD3OZP6qWdpYvnAIuVEpOWbtMWqssGy8l6Nv8AdnxnwAPdrxTlUU1tumA==
X-Received: by 2002:a63:5802:0:b0:46f:59af:c1f4 with SMTP id
 m2-20020a635802000000b0046f59afc1f4mr61219109pgb.344.1670352941888; 
 Tue, 06 Dec 2022 10:55:41 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:6220:45e1:53d2:e1cb?
 ([2620:15c:211:201:6220:45e1:53d2:e1cb])
 by smtp.gmail.com with ESMTPSA id
 x14-20020a170902ec8e00b0017c37a5a2fdsm12983682plg.216.2022.12.06.10.55.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 06 Dec 2022 10:55:41 -0800 (PST)
Message-ID: <5769762e-c15e-b111-e205-38d477e681f3@acm.org>
Date: Tue, 6 Dec 2022 10:55:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, snitzer@kernel.org
References: <20221206144057.720846-1-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221206144057.720846-1-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] block: remove bio_set_op_attrs
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
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, colyli@suse.de,
 linux-block@vger.kernel.org, song@kernel.org, linux-bcache@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 12/6/22 06:40, Christoph Hellwig wrote:
> This macro is obsolete, so replace the last few uses with open coded
> bi_opf assignments.

For the entire patch:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

