Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8BFAC7EE29
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 00:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686269428;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gvs2aho51pCqZbBn6NhLck+m2rsh7ftf15MB+8Wqpg0=;
	b=Ny4JzDNwhsOfslarE4cn4ycF/xZuLifI+ZbLgtRmolOLjWlBd07h2gBcEbOsmoGYwPG/g7
	StQLpfiaCjAjsvakL/A8NzVhVsTriOZux4+9uk7nmP48+Q7T/nVLiVdEx+7sLgwPhCxj+X
	AhYfl8H/qLmuQxrJyRuuwKqtN8heGAw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-sHxQbpNnOxKcqjpn4s_8Mw-1; Thu, 08 Jun 2023 20:10:24 -0400
X-MC-Unique: sHxQbpNnOxKcqjpn4s_8Mw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2555803DDD;
	Fri,  9 Jun 2023 00:10:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8C7372026D49;
	Fri,  9 Jun 2023 00:10:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4ACD519451C0;
	Fri,  9 Jun 2023 00:10:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0FD00194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 00:10:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D589D40CFD47; Fri,  9 Jun 2023 00:10:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CDD7F40CFD46
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 00:10:18 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2D7E185A793
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 00:10:18 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-NMCj-OBoPZCNTmA_Ouocxg-1; Thu, 08 Jun 2023 20:10:17 -0400
X-MC-Unique: NMCj-OBoPZCNTmA_Ouocxg-1
Received: by mail-pl1-f180.google.com with SMTP id
 d9443c01a7336-1b04706c974so2649795ad.2
 for <dm-devel@redhat.com>; Thu, 08 Jun 2023 17:10:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686269416; x=1688861416;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=eSknQxfSV4+v9bHiWDr5V1hQkXbY8spDyyTXR1H3Z7w=;
 b=hNGdYyt0iLDyvW5YSibgCStWSjGr/93x5N8ZGhBIp1RW1suWt11vIu3/2XSgzIPr5A
 vhc6yrQWC3+/xJZ+DA7NEMcIsYOE6/TiG+mXoCkqvwPKKBryPTXQLJfvc3Vc0apVL/kr
 MDZVhsAjQm3+VWYWr66vHiJtwqBvk3k9vBpO61+eMPKyNhrnefBGHtTCqMaQBN88fsnS
 8QY9assGy+OYIpmdlwsWm3OMIS0zQsfkkaLJENnQpfrrpcUribWJIOcmlAc7sSRpf4ld
 6J2jyNd/9g10j22QybAKFABO98uY9syfDr0pH5r0NNc/p5j8LoEPLAn6VSIMKS/xpa3t
 3UHw==
X-Gm-Message-State: AC+VfDwHsGbrcH/XJy7aK77tMHhuSzwombAfnXEScuoH5k1Vk3M1fsJI
 oIEhWjChxpMeFQ1NjVYPr15sVnMbb6tzLWPCCak=
X-Google-Smtp-Source: ACHHUZ45Am6lEfPDHZXqbwBRcUTK946UynbP/40rwMJHewDfZDlg3Hu4zbYOxv8aShlKmaGa6Khcbw==
X-Received: by 2002:a17:903:120d:b0:1ad:f138:b2f6 with SMTP id
 l13-20020a170903120d00b001adf138b2f6mr10756391plh.16.1686269416027; 
 Thu, 08 Jun 2023 17:10:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au.
 [49.179.79.151]) by smtp.gmail.com with ESMTPSA id
 b13-20020a170903228d00b001ae8b4dc49bsm1972178plh.13.2023.06.08.17.10.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Jun 2023 17:10:15 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1q7Phl-009U1b-0E;
 Fri, 09 Jun 2023 10:10:13 +1000
Date: Fri, 9 Jun 2023 10:10:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Message-ID: <ZIJt5V2aO15yVt3B@dread.disaster.area>
References: <ZHB954zGG1ag0E/t@dread.disaster.area>
 <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
 <ZHFEfngPyUOqlthr@dread.disaster.area>
 <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
 <ZHYB/6l5Wi+xwkbQ@redhat.com>
 <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
 <ZHYWAGmKhwwmTjW/@redhat.com>
 <CAG9=OMMnDfN++-bJP3jLmUD6O=Q_ApV5Dr392_5GqsPAi_dDkg@mail.gmail.com>
 <ZHqOvq3ORETQB31m@dread.disaster.area>
 <yq1sfb21zsa.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
In-Reply-To: <yq1sfb21zsa.fsf@ca-mkp.ca.oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Joe Thornber <thornber@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Joe Thornber <ejt@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 07, 2023 at 10:03:40PM -0400, Martin K. Petersen wrote:
> 
> Dave,
> 
> > Possibly unintentionally, I didn't call it REQ_OP_PROVISION but that's
> > what I intended - the operation does not contain data at all. It's an
> > operation like REQ_OP_DISCARD or REQ_OP_WRITE_ZEROS - it contains a
> > range of sectors that need to be provisioned (or discarded), and
> > nothing else.
> 
> Yep. That's also how SCSI defines it. The act of provisioning a block
> range is done through an UNMAP command using a special flag. All it does
> is pin down those LBAs so future writes to them won't result in ENOSPC.

*nod*

That I knew, and it's one of the reasons I'd like the filesystem <->
block layer provisioning model to head in this direction. i.e. we
don't have to do anything special to enable routing of provisioning
requests to hardware and/or remote block storage devices (e.g.
ceph-rbd, nbd, etc). Hence "external" devices can provide the same
guarantees as a native software-only block device implementations
like dm-thinp can provide and everything gets just that little bit
better behaved...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

