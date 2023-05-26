Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DADB2C7EE2F
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 04:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685335920;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/i5lHlcdEIvZfwkCUfrQXaBE79t1uI4RKrRBHGgp+Lk=;
	b=N4Teio2zPXY6eqCj879yWo47Dz4NpdPq4oviBASnm2J/0aMnoV54svUjernBMZZhHoa76j
	trVw3m/MNI49X8v7SljtxRrdR52KMW349Jw6fraR9CSddQ4iL5TaXmQP/iftqpt9p4R8aB
	HGsP9mN+disHxpLWHNiolXI9I8E0rWE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-MDeQBTTWPNG6o-R0JL0cFg-1; Mon, 29 May 2023 00:51:57 -0400
X-MC-Unique: MDeQBTTWPNG6o-R0JL0cFg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A014D101AA74;
	Mon, 29 May 2023 04:51:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EBD152166B2F;
	Mon, 29 May 2023 04:51:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D4ED1946595;
	Mon, 29 May 2023 04:51:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9137919465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 10:25:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 82FDC40CFD47; Fri, 26 May 2023 10:25:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BDC540CFD46
 for <dm-devel@redhat.com>; Fri, 26 May 2023 10:25:42 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DF903C0D197
 for <dm-devel@redhat.com>; Fri, 26 May 2023 10:25:42 +0000 (UTC)
Received: from out30-99.freemail.mail.aliyun.com
 (out30-99.freemail.mail.aliyun.com [115.124.30.99]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384)
 id us-mta-172-Z1DDY11sPECLAX0C9n9hZg-1; Fri, 26 May 2023 06:25:38 -0400
X-MC-Unique: Z1DDY11sPECLAX0C9n9hZg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R921e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046056;
 MF=durui@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VjW4mAL_1685096732
Received: from localhost(mailfrom:durui@linux.alibaba.com
 fp:SMTPD_---0VjW4mAL_1685096732) by smtp.aliyun-inc.com;
 Fri, 26 May 2023 18:25:33 +0800
From: Du Rui <durui@linux.alibaba.com>
To: snitzer@kernel.org
Date: Fri, 26 May 2023 18:25:32 +0800
Message-Id: <20230526102532.29276-1-durui@linux.alibaba.com>
In-Reply-To: <ZGz32yw7ecKhW+lj@redhat.com>
References: <ZGz32yw7ecKhW+lj@redhat.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 29 May 2023 04:51:50 +0000
Subject: Re: [dm-devel] dm overlaybd: targets mapping OverlayBD image
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
Cc: gscrivan@redhat.com, durui@linux.alibaba.com, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, alexl@redhat.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.alibaba.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike:

> I appreciate that this work is being done with an eye toward
> containerd "community" and standardization 

> it appears that this format of OCI image storage/use is only
> used by Alibaba? 

> But you'd do well to explain why the userspace solution isn't
> acceptable.

Yes overlaybd has origins in container community, but this work (kernel 
modules) does *NOT* actually target at container. Because on-demand lazy
loading of container images involves complex interactions with the image 
registry through HTTP(s) protocol, and possibly with other transport 
serivces (like HTTP proxy, sock5 proxy, P2P, cache, etc.). This is better 
implemented in user-space and finally exported to kernel as a virtual 
block device like TCMU or ublk. The user-space impl of Overlaybd has a 
very large install base in Alibaba, as well as some other big companies, 
including another major cloud provider. (We'd better not unveil their
names before we get their permissions). And We are pleased with the
flexibility in user-space that allows for easy integration to various 
systems / environments.

We implement this kernel module and try to contribute it to upstream
because we belive it is useful for device mapper and LVM ecology:

(1) dm-overlaybd essentially implements generic redistributable snapshot
    of an block device. This may enable LVM to push/pull individual 
    snapshots to/from a volume repo globally distributed.

(2) dm-overlaybd is highly efficent. Its index performance doesn't degrade 
    with the number of snapshots increasing. In constrast, qcow2 (dm-qcow2) 
    do not support efficient external snapshots. It has O(n) overhead in 
    this case, where n is the number of (backing-file) snapshots.

(3) dm-zfile is an efficient generic compressed block device. This allows
    LVM to support compressed snapshot, in order to save disk space without
    compromise much performance, and may even improve performance in some
    cases.


> I also have doubts that this solution is _actually_ more performant
> than a proper filesystem based solution

This proposal is not focused on performance, it's focused on new features
to dm and LVM as described above, but I still advice you to run benchmarks
and see the results. After all, ext4, xfs and other mature file systems are
highly optimized as well.

> solution that allows page cache sharing

Page cache sharing can be realized with DAX support of the dm targets
(and the inner file system), together with virtual pmem device backend.

> There is an active discussion about, and active development effort
> for, using overlayfs + erofs for container images.  I'm reluctant to
> merge this DM based container image approach without wider consensus
> from other container stakeholders.

This proposal intends to help dm and lvm ecology, and is not related to 
those file systems. It actually supports all kinds of file systems with 
full capabilities. It is of little use in container, as the user-space 
implementation is more feasible. And, there is nothing preventing the 
container stakeholders to continue discussing and developing overlayfs, 
erofs, composefs, etc.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

