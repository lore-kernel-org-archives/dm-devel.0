Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B4E0C7EE25
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 13:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686316949;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B/NHO/2mCBm43n9QPB6VHnpJ2ZiRicHg4oP7F7oI1g8=;
	b=W+lwZhc3esfXpOI9jzQr8Mv/y34YVxrCAl6xi1XiG30klOJhUlE/hy0RdA6VJMapWOb2Lc
	5dV8J0fVnLxHQPoQGUV4Z5/kk15LJSZsIis9Iq6Zkp+PD+RvQuwUju0BlrwxKw52OO8PHw
	t9nvEeNxhd5NMFtZEmVWckrraEMmT5M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620--sUivv0SN7aTY-JpM5Jw3A-1; Fri, 09 Jun 2023 09:22:27 -0400
X-MC-Unique: -sUivv0SN7aTY-JpM5Jw3A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6D0C8039C9;
	Fri,  9 Jun 2023 13:22:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 84AF11072B;
	Fri,  9 Jun 2023 13:22:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4444E19451C1;
	Fri,  9 Jun 2023 13:22:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 00FD0194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 13:22:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D737F40B4CD7; Fri,  9 Jun 2023 13:22:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CF78640B4CD6
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 13:22:22 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2CF4811E88
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 13:22:22 +0000 (UTC)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com
 [209.85.160.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-mJVa_OgFNiuO0m7x4J-EEw-1; Fri, 09 Jun 2023 09:22:21 -0400
X-MC-Unique: mJVa_OgFNiuO0m7x4J-EEw-1
Received: by mail-qt1-f174.google.com with SMTP id
 d75a77b69052e-3f9a949c012so15120621cf.0
 for <dm-devel@redhat.com>; Fri, 09 Jun 2023 06:22:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686316940; x=1688908940;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=3ItSZqiZR0dUIQmEkEzuGcGQcKdyOeKjnBx3LrxDDhQ=;
 b=Lilsi4bKZsqVNoFVBhqYGNHdc9ylupCN360dPmMCMuqybxSh/SnGtbkLFOcOyB+h0w
 bk9ZuNkHL7LmE0bkhgOs5kHw0SFw/gj7XEb+NZx0bkxgqzJP86Zlu3wxHqs6KKlU12yn
 X9eYWNeaaC7SPLnfuo7OLBYJKV8E9iUqwt1L2Z6U4OdmVuxeimjx4neinxtJxFTytn35
 pdQcllxissTkwCDmn9HVkPw0yRnoubCgp9mBd6yeBAZPv0qS3UK/95EB/sk81nrPvr+y
 GoqcwVdTqa9JfNzQVebX/CuArztaXoy5Ot2fF2BvdaFCNMV+uZMKlJpuEcUX5az1/D+5
 oKow==
X-Gm-Message-State: AC+VfDypbP2lrMMt3QLYGIkf+73Xg/maVIIEWSJaklBcuq7bg3ZFo7Xc
 3Ixnt43evikNUItZlP1WRqYgY3c=
X-Google-Smtp-Source: ACHHUZ7EaXUkLQWa4KL7eGOdK/zJn4Oe2c+mBf8RG5CIwOab23xBx689Kz4XeWIsapxaCANxot2Leg==
X-Received: by 2002:a05:622a:288:b0:3f6:b32c:3766 with SMTP id
 z8-20020a05622a028800b003f6b32c3766mr1862912qtw.11.1686316940294; 
 Fri, 09 Jun 2023 06:22:20 -0700 (PDT)
Received: from localhost ([37.19.196.165]) by smtp.gmail.com with ESMTPSA id
 z4-20020ac87104000000b003f6be76a5c1sm1159305qto.6.2023.06.09.06.22.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Jun 2023 06:22:19 -0700 (PDT)
Date: Fri, 9 Jun 2023 09:22:18 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>
Message-ID: <ZIMnivRz/3xfHKgV@redhat.com>
References: <alpine.LRH.2.21.2304171433370.17217@file01.intranet.prod.int.rdu2.redhat.com>
 <ZD61QWC6TW59anIM@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZD61QWC6TW59anIM@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] block: fix a crash when bio_for_each_folio_all
 iterates over an empty bio
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
Cc: linux-block@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 18 2023 at 11:20P -0400,
Mike Snitzer <snitzer@kernel.org> wrote:

> On Mon, Apr 17 2023 at  3:11P -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > If we use bio_for_each_folio_all on an empty bio, it will access the first
> > bio vector unconditionally (it is uninitialized) and it may crash
> > depending on the uninitialized data.
> > 
> > This patch fixes it by checking the parameter "i" against "bio->bi_vcnt"
> > and returning NULL fi->folio if it is out of range.
> > 
> > The patch also drops the test "if (fi->_i + 1 < bio->bi_vcnt)" from
> > bio_next_folio because the same condition is already being checked in
> > bio_first_folio.
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> This fix is a prereq for this dm-crypt patch to use folios:
> https://patchwork.kernel.org/project/dm-devel/patch/alpine.LRH.2.21.2302161619430.5436@file01.intranet.prod.int.rdu2.redhat.com/
> Mikulas explained why an empty bio is possible here:
> https://listman.redhat.com/archives/dm-devel/2023-April/053916.html
> 
> Reviewed-by: Mike Snitzer <snitzer@kernel.org>

Hey Jens (and Matthew),

Can you please pick this up?

Without it DM needs to do the checking (by open-coding a fixed variant
of bio_for_each_folio_all); while we _could_ do that: fixing
bio_first_folio seems best.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

