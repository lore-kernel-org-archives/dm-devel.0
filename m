Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 832B6C4332F
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 18:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666118894;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V/TBUc1UU6plTA84uQv/qRveePYaUng5JU/AwGfwIBs=;
	b=jPsCvrRW0Rms0hb6WWA3o9I8Eo+3E1+AqxmvmYlvhwz8GRghUYXAP+0s0H0+aDdeNuz9BI
	VmYvnP/CIILy6eICajXcJL2EWn3CjFbVt/Qmb20gWj7pTOCs3sjgZkMy/cP9BuxJh8xPC7
	2BGAjui53SEZDQzK/TvJhQlPKVlgWgg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-InY2YTnnO-uwvA7DspOHYA-1; Tue, 18 Oct 2022 14:48:11 -0400
X-MC-Unique: InY2YTnnO-uwvA7DspOHYA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F37B3C32C4B;
	Tue, 18 Oct 2022 18:48:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F2E202027061;
	Tue, 18 Oct 2022 18:48:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF7411946594;
	Tue, 18 Oct 2022 18:48:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DCADE194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 18:48:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CBE4B4030C0; Tue, 18 Oct 2022 18:48:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C54A949BB62
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 18:48:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A91F429DD98B
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 18:48:07 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-335-krmmf00GPva_EadkulpVTw-1; Tue, 18 Oct 2022 14:48:04 -0400
X-MC-Unique: krmmf00GPva_EadkulpVTw-1
Received: by mail-qt1-f197.google.com with SMTP id
 ga23-20020a05622a591700b0039ceee61202so3838331qtb.2
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 11:48:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=OMz7ZD6XCaUt0ZSMCX9PyjOg8xnpLboIrO4q8tkKQN4=;
 b=aCuNeFF6Um1z9zofTSo5SR0u4wUVlihoCIbE2Q7hqCzJ2XYmCHqWL3a2wK1LpA/qVh
 NPkAbyJn7rTpEKnxqMGFVUWCPjgEd01SOW7AfVwfpEnpuhbx/CF5RD0o3SEGYg9Stoma
 UI6rjvVPL5YbZ1c6iEqEsd6rkdOE1FdKXf+y8Lq1/oZITYSjTXAqnzM8aJrLfbb3LLgc
 BcHLxHT0WRtQUKtsrxHLC3/ayJ8J4cvCO26Z4vKCB4O9icmdkdatT9IXmOtnXVNY/stB
 zh6ZolobHIeQNiCiueVhLTX7OcPWro8iGXdJtMFX7U/eWgCclSyM3zGtBAk0e1tZUXIm
 OeYQ==
X-Gm-Message-State: ACrzQf1m2u/itpwaZR+xSnIcLGHeMVMtIn3CgssSmHVhqv80O5BZXzNR
 JdsUypUTHpYVkg86OXa3NlLlRc9UqBRjFyE0oCPCKSOMQlzhoivQAOrVqQUvzF3BbhkQ9Zx4J90
 xsgr/ofsGz72q9w==
X-Received: by 2002:ac8:5a04:0:b0:39c:da61:d961 with SMTP id
 n4-20020ac85a04000000b0039cda61d961mr3283878qta.136.1666118883815; 
 Tue, 18 Oct 2022 11:48:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4kYiFrkCC2vcc5l1VMqo1SytTgaACjV5OzWvZuMYrZY7zizmGaHRbxL7hmGyNDT7s+jTC5sg==
X-Received: by 2002:ac8:5a04:0:b0:39c:da61:d961 with SMTP id
 n4-20020ac85a04000000b0039cda61d961mr3283866qta.136.1666118883616; 
 Tue, 18 Oct 2022 11:48:03 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 w29-20020a05620a0e9d00b006ee7e223bb8sm2920872qkm.39.2022.10.18.11.48.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Oct 2022 11:48:02 -0700 (PDT)
Date: Tue, 18 Oct 2022 14:48:01 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <Y0704chr07nUgx3X@redhat.com>
References: <Y07SYs98z5VNxdZq@redhat.com>
 <Y07twbDIVgEnPsFn@infradead.org>
MIME-Version: 1.0
In-Reply-To: <Y07twbDIVgEnPsFn@infradead.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [git pull] device mapper changes for 6.1
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
Cc: Jilin Yuan <yuanjilin@cdjrlc.com>, Nikos Tsironis <ntsironis@arrikto.com>,
 Shaomin Deng <dengshaomin@cdjrlc.com>, Mike Snitzer <snitzer@kernel.org>,
 Nathan Huckleberry <nhuck@google.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Genjian Zhang <zhanggenjian@kylinos.cn>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>,
 Jiangshan Yi <yijiangshan@kylinos.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 18 2022 at  2:17P -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Oct 18, 2022 at 12:20:50PM -0400, Mike Snitzer wrote:
> > 
> > - Enhance DM ioctl interface to allow returning an error string to
> >   userspace. Depends on exporting is_vmalloc_or_module_addr() to allow
> >   DM core to conditionally free memory allocated with kasprintf().
> 
> That really does not sound like a good idea at all.  And it does not
> seem to have any MM or core maintainer signoffs.

Sorry, I should've solicited proper review more loudly.

But if you have a specific concern with how DM is looking to use
is_vmalloc_or_module_addr() please say what that is.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

