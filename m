Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C9BEC77B75
	for <dm-devel@archiver.kernel.org>; Tue, 18 Apr 2023 15:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681832250;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uxAIXJB74KxAYPaRJZ7rfK9MaCbQ6axXvAkPGGzzUw8=;
	b=IyeHy5vXNTphrsFR0haHDXqOpmZ/oIC/J2NmjJGb432eoWDbrsSv7MPOeYY8wmx1ZdvX6G
	7+bAJpVRhm1FyM9OM3ZpDZTH3Yeh8Ak8d6G9H4iPyRRvWjDMAC3C+4NAxANMFASyhuNJWk
	U3/tibWPLNrhzz/Aid1V7vBpq+wmsDo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-MBv-f4l1PAeLnhITJ1yM6A-1; Tue, 18 Apr 2023 11:37:28 -0400
X-MC-Unique: MBv-f4l1PAeLnhITJ1yM6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7417E8996F4;
	Tue, 18 Apr 2023 15:37:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 72B0740C83A9;
	Tue, 18 Apr 2023 15:37:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 225351946595;
	Tue, 18 Apr 2023 15:37:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 541D6194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Apr 2023 15:20:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 442AC492B03; Tue, 18 Apr 2023 15:20:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C748492B01
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 15:20:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 211391C05ACC
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 15:20:37 +0000 (UTC)
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com
 [209.85.219.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-uFH2GMsdN16wyoBkkPMbgQ-1; Tue, 18 Apr 2023 11:20:35 -0400
X-MC-Unique: uFH2GMsdN16wyoBkkPMbgQ-1
Received: by mail-qv1-f44.google.com with SMTP id qf26so2518988qvb.6
 for <dm-devel@redhat.com>; Tue, 18 Apr 2023 08:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681831235; x=1684423235;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=7CLdgn7FEJW50mDtv/lWeNBJ9hKg2Ov/8WlFbqJpJIs=;
 b=Wn5lhxgeEruQJIu/cN6usOBP1LSRc4PoO3TbUjaocxvuzS5qvdHeCz/8vVr3nBWm38
 hYPX74ZPaUnrc5WCsXMh7ETwlz4GWlsn4FEqExlgQmnqNY+Y65BYceXCOxwk1Ud4yloQ
 examoc/0Ii0ew2emwrwDZs66dKpBaWeisDJShEO1vhv/kUaFjNqNbCLrGEHnxjumsVNP
 2UNQTo0afVAjM6ANls6xrexvaB+S8mzrLI26WlRhH+Teolt3JN5aaGezmbHK5N8ZySaO
 gIpzFoBnUlWb7npIWxvIugbOTnl/URV6SraM8YNsb4aahFvNbRAQxgRenfNepTM0xUiq
 wdIQ==
X-Gm-Message-State: AAQBX9doYxBdMKZfTbxiL+P4zZhhUjFgWFK/NVF1OnrZNYmgBiA1h2d4
 P1gd1xpRTs6uDau7mzSKzB4u5UR1o/lu6pr4E5dd
X-Google-Smtp-Source: AKy350Y4cXxw9vWWlQiQfrff6ZcA7eR3+1dB65GdR9xdlfjhUTfjBpewtj4Qo98QVfFPqX6aFoZqOg==
X-Received: by 2002:ad4:5c43:0:b0:5be:cb17:90ab with SMTP id
 a3-20020ad45c43000000b005becb1790abmr27221625qva.40.1681831234997; 
 Tue, 18 Apr 2023 08:20:34 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 y16-20020ad457d0000000b005ef40ffd97asm3799930qvx.0.2023.04.18.08.20.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Apr 2023 08:20:34 -0700 (PDT)
Date: Tue, 18 Apr 2023 11:20:33 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <ZD61QWC6TW59anIM@redhat.com>
References: <alpine.LRH.2.21.2304171433370.17217@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2304171433370.17217@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
 dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
 Matthew Wilcox <willy@infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 17 2023 at  3:11P -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> If we use bio_for_each_folio_all on an empty bio, it will access the first
> bio vector unconditionally (it is uninitialized) and it may crash
> depending on the uninitialized data.
> 
> This patch fixes it by checking the parameter "i" against "bio->bi_vcnt"
> and returning NULL fi->folio if it is out of range.
> 
> The patch also drops the test "if (fi->_i + 1 < bio->bi_vcnt)" from
> bio_next_folio because the same condition is already being checked in
> bio_first_folio.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

This fix is a prereq for this dm-crypt patch to use folios:
https://patchwork.kernel.org/project/dm-devel/patch/alpine.LRH.2.21.2302161619430.5436@file01.intranet.prod.int.rdu2.redhat.com/
Mikulas explained why an empty bio is possible here:
https://listman.redhat.com/archives/dm-devel/2023-April/053916.html

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

