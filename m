Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C8DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 19 May 2022 03:12:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-2dFcpANlO02wZEOtCK-s-A-1; Wed, 18 May 2022 23:12:46 -0400
X-MC-Unique: 2dFcpANlO02wZEOtCK-s-A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F38785A5BC;
	Thu, 19 May 2022 03:12:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F1B0F492C3B;
	Thu, 19 May 2022 03:12:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9F3621947065;
	Thu, 19 May 2022 03:12:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BB137194704A
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 May 2022 03:12:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 713232166B26; Thu, 19 May 2022 03:12:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C5052166B25
 for <dm-devel@redhat.com>; Thu, 19 May 2022 03:12:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50AD0811E76
 for <dm-devel@redhat.com>; Thu, 19 May 2022 03:12:43 +0000 (UTC)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-N_KNfO7AP7aeLmgbojodGQ-1; Wed, 18 May 2022 23:12:41 -0400
X-MC-Unique: N_KNfO7AP7aeLmgbojodGQ-1
Received: by mail-pg1-f177.google.com with SMTP id a38so995425pgl.9
 for <dm-devel@redhat.com>; Wed, 18 May 2022 20:12:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=9JN0fB16G2C30bXw00o2rKWge5ToDKtDbnbvpwNdZkI=;
 b=gRBJjrZdpiXEeEaYmCzNImwjrOGYx3hW7z9YofnUloA3CaZrmLavYdwKCzIPsNMh3T
 ogf5GiMRsWiXIHmOyK8hs8spMOPcjKoSrIRv7A7WJR4XAbHPF2kEaWAO3kew3eiqrAX1
 8th7tViUeGjEFSeg4lfuV4qKtxYKcpwFlKrJIxmffGmd/1pIIlEjKSb9yvNHoJP254Fu
 EqQYCIxXAb/ROlu+VeU4vN1dfbSbN5dkVorH7OoqETDmW4TnLNovVb77FcDsSuhrnlM/
 mtURGYuHH5EsmkjvoNn2a7aBFrYpAakJ6AyBnfkXgwUrz85DYaiSjwmn6DgvX/13f0ev
 uwOQ==
X-Gm-Message-State: AOAM532E1uh/CGhgmCIwcpe9QRqCNOaYk0kNHUzemyqjGerMRp6DQYie
 bFPrHp6HVLJULIdijNg2VvkXoH3P+ew=
X-Google-Smtp-Source: ABdhPJyrgMJtrLlwQnNIwf+NjlQjBMAO/19qfMKeveD8EoHEa/Q7M6uMkO2ILqaysBSDyiNbhhYuDQ==
X-Received: by 2002:a63:1050:0:b0:3c2:2f7c:cc78 with SMTP id
 16-20020a631050000000b003c22f7ccc78mr2222093pgq.238.1652929960314; 
 Wed, 18 May 2022 20:12:40 -0700 (PDT)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
 by smtp.gmail.com with ESMTPSA id
 h8-20020a654048000000b003f26c2f583asm2231364pgp.61.2022.05.18.20.12.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 20:12:39 -0700 (PDT)
Date: Wed, 18 May 2022 20:12:37 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20220519031237.sw45lvzrydrm7fpb@garbanzo>
References: <CGME20220516165418eucas1p2be592d9cd4b35f6b71d39ccbe87f3fef@eucas1p2.samsung.com>
 <20220516165416.171196-1-p.raghav@samsung.com>
 <20220517081048.GA13947@lst.de> <YoPAnj9ufkt5nh1G@mit.edu>
 <7f9cb19b-621b-75ea-7273-2d2769237851@opensource.wdc.com>
MIME-Version: 1.0
In-Reply-To: <7f9cb19b-621b-75ea-7273-2d2769237851@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk,
 Theodore Ts'o <tytso@mit.edu>, pankydev8@gmail.com, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dsterba@suse.com,
 dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, May 19, 2022 at 12:08:26PM +0900, Damien Le Moal wrote:
> On 5/18/22 00:34, Theodore Ts'o wrote:
> > On Tue, May 17, 2022 at 10:10:48AM +0200, Christoph Hellwig wrote:
> >> I'm a little surprised about all this activity.
> >>
> >> I though the conclusion at LSF/MM was that for Linux itself there
> >> is very little benefit in supporting this scheme.  It will massively
> >> fragment the supported based of devices and applications, while only
> >> having the benefit of supporting some Samsung legacy devices.
> > 
> > FWIW,
> > 
> > That wasn't my impression from that LSF/MM session, but once the
> > videos become available, folks can decide for themselves.
> 
> There was no real discussion about zone size constraint on the zone
> storage BoF. Many discussions happened in the hallway track though.

Right so no direct clear blockers mentioned at all during the BoF.

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

