Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91E16C77B7E
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 18:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685645175;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UP93FNYLA6L4JqRlhcNQAWbVnLrwP7Vnaw6RsJHUypM=;
	b=ZpfITUPckF5dkpPKl4l/+RhgB42pLmwNwjNPA9d7omuyyGpyneapQutCMKWLdF9/r6sV98
	NMGvZwewDpvgbiUhxUQBnaCOmxFM+xfQH3BkLuI9jsEsE+PmogXidP8STTHfXySmt1QeH1
	6aKNmbWg1M6eOfc7K6I8R/CgIkfA+8E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-XawkdkeUMDWHeYjDxUZpxg-1; Thu, 01 Jun 2023 14:46:13 -0400
X-MC-Unique: XawkdkeUMDWHeYjDxUZpxg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA6A5800BFF;
	Thu,  1 Jun 2023 18:46:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56C1814171BC;
	Thu,  1 Jun 2023 18:46:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 359651946595;
	Thu,  1 Jun 2023 18:46:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D244F194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 18:46:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C0A33492B0B; Thu,  1 Jun 2023 18:46:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B8E41492B0A
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 18:46:09 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A585185A793
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 18:46:09 +0000 (UTC)
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com
 [209.85.219.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-6s_fae4QNSOJVUDt_mHtFg-1; Thu, 01 Jun 2023 14:46:08 -0400
X-MC-Unique: 6s_fae4QNSOJVUDt_mHtFg-1
Received: by mail-qv1-f42.google.com with SMTP id
 6a1803df08f44-6260a9ef126so10580986d6.2
 for <dm-devel@redhat.com>; Thu, 01 Jun 2023 11:46:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685645167; x=1688237167;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=OhyufVORgAPdxy2e2nylP7DQVEhvcm7KBzR049ls10E=;
 b=NbrbdAZPsPmK3MnFCAZWjO1JcVWIotcaj+eZEgIQQz6ITMe7TmdWQAMcpDmq7HE0QG
 qQw4/9MwAUdkWZuUFC11oMbU7MJLoVlsbZeQBiwJJnANitTxEtRaXE4aFFZlOf1hlbQK
 +N1ox43JrdOVe/Xq8otE1185N9J6SqsbBgb/GujYg7QzpTRUfRr/AwxB0uCi18risQvs
 uM6rYhqjwzkUcJmNyUqjI45Vub9hxzVrToNZuDRvPM8tCgkbdhhHZMAb1ItDV7/jPK+S
 m0c+DxcXxrvTkcssme7ttjtwoqBF5kGfLcGHjRIIyYyVS9W3xkcUF6PlT2EC9X8V3GYb
 fkyA==
X-Gm-Message-State: AC+VfDwA406sf01/Zc9JoYgKDN9W+J3oBGAcMoqgl4hCOd2wig1zSlX4
 Bqw5OKYyuOyzgd5J6WVhTsmEMmw=
X-Google-Smtp-Source: ACHHUZ6u3xR1YiMGmuLlFSVcpQijECu4NK+3gxplM1YXFxd6uPbdqueU4kLpHglpcsupIu+Tz62ckA==
X-Received: by 2002:a05:6214:aca:b0:625:b849:fa3 with SMTP id
 g10-20020a0562140aca00b00625b8490fa3mr11540334qvi.30.1685645167691; 
 Thu, 01 Jun 2023 11:46:07 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 y3-20020ac87c83000000b003e89e2b3c23sm7940746qtv.58.2023.06.01.11.46.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Jun 2023 11:46:07 -0700 (PDT)
Date: Thu, 1 Jun 2023 14:46:06 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <ZHjnbkcpZ/yZWRsE@redhat.com>
References: <20230502101934.24901-1-johannes.thumshirn@wdc.com>
 <20230502101934.24901-17-johannes.thumshirn@wdc.com>
 <alpine.LRH.2.21.2305301045220.3943@file01.intranet.prod.int.rdu2.redhat.com>
 <ZHYbIYxGbcXbpvIK@redhat.com>
 <alpine.LRH.2.21.2305301527410.18906@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2305301527410.18906@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v5 16/20] dm-crypt: check if adding pages to
 clone bio fails
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
Cc: "axboe @ kernel . dk" <axboe@kernel.dk>, shaggy@kernel.org,
 damien.lemoal@wdc.com, cluster-devel@redhat.com, kch@nvidia.com,
 agruenba@redhat.com, linux-mm@kvack.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 jfs-discussion@lists.sourceforge.net, willy@infradead.org, ming.lei@redhat.com,
 linux-raid@vger.kernel.org, song@kernel.org, dm-devel@redhat.com,
 linux-block@vger.kernel.org, rpeterso@redhat.com,
 linux-fsdevel@vger.kernel.org, hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 30 2023 at  3:43P -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 30 May 2023, Mike Snitzer wrote:
> 
> > On Tue, May 30 2023 at 11:13P -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > Hi
> > > 
> > > I nack this. This just adds code that can't ever be executed.
> > > 
> > > dm-crypt already allocates enough entries in the vector (see "unsigned int 
> > > nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;"), so bio_add_page can't 
> > > fail.
> > > 
> > > If you want to add __must_check to bio_add_page, you should change the 
> > > dm-crypt code to:
> > > if (!bio_add_page(clone, page, len, 0)) {
> > > 	WARN(1, "this can't happen");
> > > 	return NULL;
> > > }
> > > and not write recovery code for a can't-happen case.
> > 
> > Thanks for the review Mikulas. But the proper way forward, in the
> > context of this patchset, is to simply change bio_add_page() to
> > __bio_add_page()
> > 
> > Subject becomes: "dm crypt: use __bio_add_page to add single page to clone bio"
> > 
> > And header can explain that "crypt_alloc_buffer() already allocates
> > enough entries in the clone bio's vector, so bio_add_page can't fail".
> > 
> > Mike
> 
> Yes, __bio_add_page would look nicer. But bio_add_page can merge adjacent 
> pages into a single bvec entry and __bio_add_page can't (I don't know how 
> often the merging happens or what is the performance implication of 
> non-merging).
> 
> I think that for the next merge window, we can apply this patch: 
> https://listman.redhat.com/archives/dm-devel/2023-May/054046.html
> which makes this discussion irrelevant. (you can change bio_add_page to 
> __bio_add_page in it)

Yes, your patch is on my TODO list.  I've rebased my dm-6.5 branch on
the latest block 6.5 branch.  I'll be reviewing/rebasing/applying your
patch soon.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

