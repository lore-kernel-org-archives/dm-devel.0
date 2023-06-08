Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CAF7C7EE2F
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 07:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686294055;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g6AEC0U/1ypSY3uCfebYa1CwTNkxaf3gSscMjcDOlvA=;
	b=dWN4dn+iKJzwbit1AGhVcTEZgvHYW6RHp+kQuYat6rY26Ygr77vOPnuanVR0ospvgDl324
	BS3RTB3Vvva5OUrp00skocyJajEH2S+ppohTwDkSJu6UKocNv4Etzj9dENCWfGM1r0MEiv
	wigMBLStoBhR7BAvxVKXwSCfkC8vkqM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-bvN-vq7UNza69JJJA_CBbA-1; Fri, 09 Jun 2023 03:00:51 -0400
X-MC-Unique: bvN-vq7UNza69JJJA_CBbA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0B91100AF66;
	Fri,  9 Jun 2023 07:00:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ACC8240CFD00;
	Fri,  9 Jun 2023 07:00:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 388AF19451CE;
	Fri,  9 Jun 2023 07:00:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 279B4194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 08:47:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 070A540CFD47; Thu,  8 Jun 2023 08:47:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F3C9840CFD46
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 08:47:32 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D426B3825BA4
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 08:47:32 +0000 (UTC)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-8bgzWgKkNNa3p50NPnS1Dg-1; Thu, 08 Jun 2023 04:47:30 -0400
X-MC-Unique: 8bgzWgKkNNa3p50NPnS1Dg-1
Received: by mail-wm1-f49.google.com with SMTP id
 5b1f17b1804b1-3f6d7abe934so1827105e9.2
 for <dm-devel@redhat.com>; Thu, 08 Jun 2023 01:47:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686214050; x=1688806050;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=3Z0zXMf0/p1bWmc9mPlzpLlXYRZkfsnJE7sT8NRRA6c=;
 b=Ujkhs2L/YbSHqlU/xUhT2wbpnZlj8bNhad88sXf0RzOxsaHofGh7G/ipDAhKV8hYHt
 GnXIcwK3yYy4e0uRPlWJizT7Aoh/YnFF8JDqCUVtfvqu3xCGd8n12jHFXR+SuvQd4WaT
 4b43Rm3ezYZrll/vK9Yk0BFZC40xPx9XTzRxwSU+IjoT70gEIddAVkG644TgO1hBl6n+
 B9YicHNWL+TnjRC6Z3SUVtJqjqvFyV5KyfdSyFWkT/lHQ8UW2rKU+O875UJIdKvqXzjP
 tmZKZaWVUSPSPfI4R26fULid4FzkCxPP1e6BUpHvmQxwCVDLwQWw8QstQkYBcnnvAqJq
 m6Cg==
X-Gm-Message-State: AC+VfDwMdl2HGL5mH8jLmta0YQg96y2BAlEGCu8PVsvT4YItHF+9c/6c
 MAUzvWfK3Gv61lOYQROinjcy6w==
X-Google-Smtp-Source: ACHHUZ64php+m1QCHow4PROIWkYJdsxvPRvM75l2Ndr3HzBRHztMsSyV31x82/mpTwubbqm80EXyLg==
X-Received: by 2002:a05:600c:d6:b0:3f6:389:73b1 with SMTP id
 u22-20020a05600c00d600b003f6038973b1mr839950wmm.6.1686214049725; 
 Thu, 08 Jun 2023 01:47:29 -0700 (PDT)
Received: from equinox
 (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa.
 [2001:8b0:dfde:e1a0::2]) by smtp.gmail.com with ESMTPSA id
 n19-20020a7bcbd3000000b003f73a101f88sm1253740wmi.16.2023.06.08.01.47.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Jun 2023 01:47:29 -0700 (PDT)
Date: Thu, 8 Jun 2023 09:47:27 +0100
From: Phillip Potter <phil@philpotter.co.uk>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <ZIGVn9E9ME26V0Gn@equinox>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-7-hch@lst.de> <ZH+6qd1W75G49P7p@equinox>
 <20230608084129.GA14689@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230608084129.GA14689@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Fri, 09 Jun 2023 07:00:46 +0000
Subject: Re: [dm-devel] [PATCH 06/31] cdrom: remove the unused mode argument
 to cdrom_release
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Chris Mason <clm@fb.com>, dm-devel@redhat.com,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Pavel Machek <pavel@ucw.cz>,
 Miquel Raynal <miquel.raynal@bootlin.com>, Jack Wang <jinpu.wang@ionos.com>,
 linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
 Richard Weinberger <richard@nod.at>, linux-pm@vger.kernel.org,
 linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: philpotter.co.uk
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 08, 2023 at 10:41:29AM +0200, Christoph Hellwig wrote:
> On Wed, Jun 07, 2023 at 12:00:57AM +0100, Phillip Potter wrote:
> > Looks good, thanks.
> > 
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> 
> Hmm, these signoffs don't really make sense here.  Were they intended
> as Reviewed-bys?
> 
Hi Christoph,

Yes indeed - I was under the impression it was appropriate for a
maintainer to signal their approval of a patch to maintained code using
a Signed-off-by tag due to their involvement in the submission process?
Apologies if I've got this wrong, happy to send Reviewed-bys by all
means.

Regards,
Phil

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

