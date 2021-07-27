Return-Path: <SRS0=tlLk=MT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3776BC4338F
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 16:02:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DD7A661B7C
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 16:02:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DD7A661B7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627401753;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NSzyzrxojdL+sTtqabVHvRop6/IxP+DarCCIYYb5hms=;
	b=PfCsoxJSjSLfx4NsJSoehlIrUOxM1bjt6iRf0yxWq+9Xlh6bSdfZYm3OM0kzjrEDeBByNa
	8083K1+yWwlUQ2dT5I/KhXHfC+y8n60UKOX/BMS6Ilpjd5olCdS0VsG5bIOp5iOgGXroaS
	FihJqUEAoCSaVl/ELJUfbiX/rWqRn5A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-ioDxcjxTP2KJlfWa_NGVfA-1; Tue, 27 Jul 2021 12:02:32 -0400
X-MC-Unique: ioDxcjxTP2KJlfWa_NGVfA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FFC31008062;
	Tue, 27 Jul 2021 16:02:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB94810074E1;
	Tue, 27 Jul 2021 16:02:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8130C180BAB1;
	Tue, 27 Jul 2021 16:02:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16RFwsqu009806 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Jul 2021 11:58:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D5508203CE5B; Tue, 27 Jul 2021 15:58:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF2732044003
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 15:58:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C101D80270A
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 15:58:49 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
	[209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-211-BI86DCVZM060deuKXDQ7Dg-1; Tue, 27 Jul 2021 11:58:48 -0400
X-MC-Unique: BI86DCVZM060deuKXDQ7Dg-1
Received: by mail-qt1-f199.google.com with SMTP id
	h18-20020ac856920000b029025eb726dd9bso6616094qta.8
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 08:58:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=atmE5scVfb2O9aWWLb/VOIw6P8MjSrhPGuB4Ep/3fiI=;
	b=i/UhPxtAG08Rr2jPmVEUYNPv0IaaVSfMXUAcYhRNRFPd5jceBLRcP05fynKwi5SkHq
	Qmhal0h0rSGuWzymJ1uZAdTr/6REY1ajgbYtUk/6dDyE/Bt/HjDtHpeYzQv0nbmEUpmd
	fRNJNlc2nEN0p41Vy+lTIMMtd2H6MmhgicKRTC67wLJ2xuVwRgu734y1LvldF/Nzbms+
	TGsAkn0YX0SznidCShozNuomaoGRldJMDzpGdrolYWVns8WPt3cSd6pE+3d2N5CiakKl
	kzVEcbcP0gdE0Vj2xWogyg+5lIsRDqEsfRniDR2XJ19xs7EfcdFDNCs/81pkJogSCg5B
	Yj2A==
X-Gm-Message-State: AOAM532uxYUvumM6sf45vyER4rnNKrfFIqEZl9Ep77mpX8T+J93Eg5/b
	89azw6awRFHXoQxTb4q45ngaamT1jtQHjQAFsHSvyOWhcuOLlS9yPB0NIHbBxfeif7FkQ2Ebyey
	bPgzcQn7j/Q0mSw==
X-Received: by 2002:a05:620a:95c:: with SMTP id
	w28mr23175785qkw.52.1627401527838; 
	Tue, 27 Jul 2021 08:58:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOE+4SV5d1eT/qjDo6Wzbvz0u0RtU+A3LUlxu4pNXJTS+HBQn/7czeCezGlN5kKwEkzDmedg==
X-Received: by 2002:a05:620a:95c:: with SMTP id
	w28mr23175776qkw.52.1627401527661; 
	Tue, 27 Jul 2021 08:58:47 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	x28sm1659779qtm.71.2021.07.27.08.58.47
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 27 Jul 2021 08:58:47 -0700 (PDT)
Date: Tue, 27 Jul 2021 11:58:46 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YQAtNkd8T1w/cSLc@redhat.com>
References: <20210725055458.29008-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210725055458.29008-1-hch@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] use regular gendisk registration in device mapper
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Jul 25 2021 at  1:54P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Hi all,
> 
> The device mapper code currently has a somewhat odd gendisk registration
> scheme where it calls add_disk early, but uses a special flag to skip the
> "queue registration", which is a major part of add_disk.  This series
> improves the block layer holder tracking to work on an entirely
> unregistered disk and thus allows device mapper to use the normal scheme
> of calling add_disk when it is ready to accept I/O.
> 
> Note that this leads to a user visible change - the sysfs attributes on
> the disk and the dm directory hanging off it are not only visible once
> the initial table is loaded.

s/not/now/

> This did not make a different to my testing
> using dmsetup and the lvm2 tools.

I'll try these changes running through the lvm2 testsuite.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

