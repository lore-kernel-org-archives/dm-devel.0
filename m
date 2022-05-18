Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9C99C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 23:07:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-dah9zY-qMNOSW1lDBWUGcA-1; Wed, 18 May 2022 19:06:59 -0400
X-MC-Unique: dah9zY-qMNOSW1lDBWUGcA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FE2C3801EC0;
	Wed, 18 May 2022 23:06:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B64AFC27E8A;
	Wed, 18 May 2022 23:06:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8705C1947B91;
	Wed, 18 May 2022 23:06:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DBD011947B91
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 23:06:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BC14A7AD5; Wed, 18 May 2022 23:06:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B73DA7774
 for <dm-devel@redhat.com>; Wed, 18 May 2022 23:06:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B689811E75
 for <dm-devel@redhat.com>; Wed, 18 May 2022 23:06:53 +0000 (UTC)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-xW6W1hP9MhOxUOMJUB-OKA-1; Wed, 18 May 2022 19:06:51 -0400
X-MC-Unique: xW6W1hP9MhOxUOMJUB-OKA-1
Received: by mail-pj1-f45.google.com with SMTP id ev18so3495916pjb.4
 for <dm-devel@redhat.com>; Wed, 18 May 2022 16:06:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=M2OU/ev/wtDvqHYNj5hP9zKluj3H/LLJ6QYPls9G5Tw=;
 b=NIzfBABO+m7dRSgvIBhau1Yfi63l8sUMWihoiJVo4W7Tf1dnS2Iz0pDywFvb7p7w7M
 hhHVwyqfB/ou2xNZudLWjs+qO2zXwO1wryOHeB0G/ms0w7BoW2KPzR37gnG8DBIJZNqX
 yWXnHscI4a31rEFe2wHIop9WRDnKOsbGHlpVCQAsNf3hkxxbc+ItV/oMeFO3xefgGvws
 zpW17DyFVR4ycWgRYCLR/iQwSwwaUKDRpznDEKXh9mT6sJuSXK3kogEcJBwMuLYMh0KW
 XY06FjD27Wag3tX3ppTt0Cytl+G65N5u1GHsr9lDSEtobFwzdc/pmr9v2NE7fPZzTE09
 mEWw==
X-Gm-Message-State: AOAM530Fl9jeZwdC2bcK0CzETQJottWB1sIAEXT2pNvq+x53ovNDyMCl
 Ov0g3QJ8pK8cDREmt7tUxBY=
X-Google-Smtp-Source: ABdhPJxrRrwxuaXVXZU5unUYT2Wp/ah35BZYv61mf/nd9Yr//ww7daRstQvEvrGocfyzbj6E/VCrbQ==
X-Received: by 2002:a17:90a:9282:b0:1dc:4a1b:ea55 with SMTP id
 n2-20020a17090a928200b001dc4a1bea55mr1854383pjo.24.1652915210525; 
 Wed, 18 May 2022 16:06:50 -0700 (PDT)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
 by smtp.gmail.com with ESMTPSA id
 t1-20020a17090340c100b0015e8d4eb271sm2130390pld.187.2022.05.18.16.06.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 16:06:49 -0700 (PDT)
Date: Wed, 18 May 2022 16:06:46 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20220518230646.5xx6dpo4helwyqcv@garbanzo>
References: <CGME20220516165418eucas1p2be592d9cd4b35f6b71d39ccbe87f3fef@eucas1p2.samsung.com>
 <20220516165416.171196-1-p.raghav@samsung.com>
 <20220517081048.GA13947@lst.de> <YoPAnj9ufkt5nh1G@mit.edu>
MIME-Version: 1.0
In-Reply-To: <YoPAnj9ufkt5nh1G@mit.edu>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v4 00/13] support non power of 2 zoned devices
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk, pankydev8@gmail.com,
 gost.dev@samsung.com, damien.lemoal@opensource.wdc.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dsterba@suse.com,
 dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 17, 2022 at 11:34:54AM -0400, Theodore Ts'o wrote:
> On Tue, May 17, 2022 at 10:10:48AM +0200, Christoph Hellwig wrote:
> > I'm a little surprised about all this activity.
> > 
> > I though the conclusion at LSF/MM was that for Linux itself there
> > is very little benefit in supporting this scheme.  It will massively
> > fragment the supported based of devices and applications, while only
> > having the benefit of supporting some Samsung legacy devices.
> 
> FWIW,
> 
> That wasn't my impression from that LSF/MM session, but once the
> videos become available, folks can decide for themselves.

Agreed, contrary to conventional storage devices, with the zone storage
ecosystem we simply have a requirement of zone drive replacements matching
zone size. That requirement exists for po2 or npo2. The work in this patch
set proves that supporting npo2 was in the end straight forward. As the one
putting together the BoF I can say that there were no sticking points raised
to move forward with this when the topic came up. So I am very surprised to
hear about any other perceived conclusion.

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

