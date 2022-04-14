Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20193C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 16:47:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-GNPdXTCCPwSbe-a3ZO0tAA-1; Thu, 14 Apr 2022 12:47:45 -0400
X-MC-Unique: GNPdXTCCPwSbe-a3ZO0tAA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BC2B3C13A12;
	Thu, 14 Apr 2022 16:47:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ADE48111F3DF;
	Thu, 14 Apr 2022 16:47:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 670461940344;
	Thu, 14 Apr 2022 16:47:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2295B19451F2
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 16:47:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0003114583C3; Thu, 14 Apr 2022 16:47:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F03A314583C1
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 16:47:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D62BB811E78
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 16:47:41 +0000 (UTC)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com
 [209.85.219.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-oSX00u5YO-ORU8ZXWDEIUg-1; Thu, 14 Apr 2022 12:47:40 -0400
X-MC-Unique: oSX00u5YO-ORU8ZXWDEIUg-1
Received: by mail-qv1-f41.google.com with SMTP id y19so4408751qvk.5
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 09:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Ty/dU487bLZfcGLIg9ghBZfbnwjxk4KNFc68gWKIFyA=;
 b=qjrz69rnFrkw01ouC6spCDbfKRIztUzD3GYNTvfn+gW5BBmkJ7/4MJXYI5W4sAVKyW
 Me0wrFX1vJiPTAfw43Rmk/i69U8TnV+EgTWmgz3H8yIJHmh0nkDzE3vWCVdrbJslf+bg
 yfu0fUsf2/DHV1wb9AqWY6R3ALmMQClrKU1LTOBL7vg2AYR/espnhC4pE/BxQVlqcvpc
 9mk9XDEjDnVGqW0vygpG29Y8e9HQzlKLUoycbKxVNVY06JnjpYzY2nIdcgTp1TajBWmE
 2aC3dLq9NK6FFo4476uLzD++/PYB/j6HEf17tEDFKQRp4cazYB6ov1wZt8vvDS54baGq
 HWvw==
X-Gm-Message-State: AOAM531G+PWcxw0q3fFTSiVCcB6wOfHWvWzmlXEB4zJm14jT53ad4fh2
 XDqs7H6Do7flZTssFmWnn38Ah8wdLRiIAbU=
X-Google-Smtp-Source: ABdhPJyxmi3WnlNvyRJBVdePMpNjlg6qv9LtuPlhqYmYpgPoD4EouwEgqaGKI8B6bBJjzFYwZwMcsg==
X-Received: by 2002:a05:6214:1101:b0:444:43ec:a93b with SMTP id
 e1-20020a056214110100b0044443eca93bmr4021843qvs.130.1649954859509; 
 Thu, 14 Apr 2022 09:47:39 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 o10-20020ac85a4a000000b002ed143903a9sm1495500qta.45.2022.04.14.09.47.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Apr 2022 09:47:39 -0700 (PDT)
Date: Thu, 14 Apr 2022 12:47:38 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Message-ID: <YlhQKj0iLM8mT+WK@redhat.com>
References: <20220414083436.pweunapygdtuzwaf@shindev>
 <YlhL878nAVPkNK1n@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YlhL878nAVPkNK1n@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [bug report] BUG for REQ_OP_WRITE_ZEROES to dm-zoned
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Damien Le Moal <Damien.LeMoal@wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Apr 14 2022 at 12:29P -0400,
Mike Snitzer <snitzer@kernel.org> wrote:
 
> Thanks for the report, I've staged a fix here (btw, your change above
> needs to be paired with the 2nd hunk of my fix otherwise you won't get
> the bio split you desire):
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.18&id=3dfb6f5e95f26215ca08d348ca2ddb5ea6ea2349
> 
> I'll be sending this to Linus later today or tomorrow.

FYI, I revised that commit with further cleanup to not pass
'unsigned *len' to alloc_multiple_bios(), this commit is what will be
sent upstream soon:

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.18&id=c2228f993c7592783b0a2bf7d169b17dfa4cbe2a

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

