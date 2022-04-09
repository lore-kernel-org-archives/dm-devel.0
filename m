Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F24EDC4167B
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 06:19:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-qksn-B7aNuCuTMxjCsGP8Q-1; Mon, 11 Apr 2022 02:19:34 -0400
X-MC-Unique: qksn-B7aNuCuTMxjCsGP8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D33FF188498E;
	Mon, 11 Apr 2022 06:19:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BC1C8407F762;
	Mon, 11 Apr 2022 06:19:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ECAEA19451F2;
	Mon, 11 Apr 2022 06:19:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A9BB21940341
 for <dm-devel@listman.corp.redhat.com>; Sat,  9 Apr 2022 08:15:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 77A3041638B; Sat,  9 Apr 2022 08:15:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 73E9E41637B
 for <dm-devel@redhat.com>; Sat,  9 Apr 2022 08:15:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59E048038E3
 for <dm-devel@redhat.com>; Sat,  9 Apr 2022 08:15:40 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-tqozFUVsNIiOPPk3RhGElQ-1; Sat, 09 Apr 2022 04:15:38 -0400
X-MC-Unique: tqozFUVsNIiOPPk3RhGElQ-1
Received: by mail-wr1-f47.google.com with SMTP id d29so16008688wra.10
 for <dm-devel@redhat.com>; Sat, 09 Apr 2022 01:15:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=sw+fQbvS6SFTnotjqrxbhqCVHIPsenv7yxMzOYGId1I=;
 b=rXhPvwDXRx4/qCQDBFkk5avKGsdbAeU6NNIPERGU3Cyvro5s0/UbLLvsbrTVCWzKMP
 AyJUlktpRXTQDhjlyf1/C/TrPKAYnH8BVMaMUESa1nSHhsVSEhzpsiNjp3Q6/Mb7Mn5y
 SCiKji2/Wvki8FjTQ2I4/JVyrQOT508D+nNq/+crD5CC0aZH55J2TTCxHwRsIaxo6Ir3
 3IkXDDZUJagJW9wh9hPT3UpUBuj9RBboZRwf3KuBYCkPfDnBHhrvyK4ByqyNCvw7nrG0
 Tx8LpE9azP2GX4ye0Ff1nJ1fNHyDlzKffY+WnRgajc+xkae1y/363OZrPQaMlkfKiPRY
 BnUA==
X-Gm-Message-State: AOAM5308zqAd1ZKGD8+dbPJlHrBeWnfRhmI2bSHpkly6+kWO/IVj/ER9
 dqt0tchMQHbFIYr6jof2xeCwaQ==
X-Google-Smtp-Source: ABdhPJzQQyyFsXyXf3Tt03078VjcrkSv2k98fwj9oToPATRHlAVDyH773lIm4bEik17KjObuot5lIg==
X-Received: by 2002:a5d:6c6b:0:b0:1ea:77ea:dde8 with SMTP id
 r11-20020a5d6c6b000000b001ea77eadde8mr17920640wrz.690.1649492137216; 
 Sat, 09 Apr 2022 01:15:37 -0700 (PDT)
Received: from [192.168.169.127] (178.115.52.210.wireless.dyn.drei.com.
 [178.115.52.210]) by smtp.gmail.com with ESMTPSA id
 m20-20020a05600c4f5400b0038b5162260csm16809052wmq.23.2022.04.09.01.15.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 09 Apr 2022 01:15:36 -0700 (PDT)
Message-ID: <72e9bd34-3380-e305-65f0-a17306f5bd08@linbit.com>
Date: Sat, 9 Apr 2022 10:15:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
To: Christoph Hellwig <hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
 <20220409045043.23593-25-hch@lst.de>
From: =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph.boehmwalder@linbit.com>
In-Reply-To: <20220409045043.23593-25-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Mon, 11 Apr 2022 06:19:20 +0000
Subject: Re: [dm-devel] [PATCH 24/27] block: remove QUEUE_FLAG_DISCARD
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
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, Coly Li <colyli@suse.de>,
 Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMDkuMDQuMjIgMDY6NTAsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+IEp1c3QgdXNlIGEg
bm9uLXplcm8gbWF4X2Rpc2NhcmRfc2VjdG9ycyBhcyBhbiBpbmRpY2F0b3IgZm9yIGRpc2NhcmQK
PiBzdXBwb3J0LCBzaW1pbGFyIHRvIHdoYXQgaXMgZG9uZSBmb3Igd3JpdGUgemVyb2VzLgo+IAo+
IFRoZSBvbmx5IHBsYWNlcyB3aGVyZSBuZWVkcyBzcGVjaWFsIGF0dGVudGlvbiBpcyB0aGUgUkFJ
RDUgZHJpdmVyLAo+IHdoaWNoIG11c3QgY2xlYXIgZGlzY2FyZCBzdXBwb3J0IGZvciBzZWN1cml0
eSByZWFzb25zIGJ5IGRlZmF1bHQsCj4gZXZlbiBpZiB0aGUgZGVmYXVsdCBzdGFja2luZyBydWxl
cyB3b3VsZCBhbGxvdyBmb3IgaXQuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3
aWcgPGhjaEBsc3QuZGU+Cj4gUmV2aWV3ZWQtYnk6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGlu
LnBldGVyc2VuQG9yYWNsZS5jb20+Cj4gQWNrZWQtYnk6IENocmlzdG9waCBCw7ZobXdhbGRlciA8
Y2hyaXN0b3BoLmJvZWhtd2FsZGVyQGxpbmJpdC5jb20+IFtidHJmc10KCkkgdGhpbmsgeW91IG1h
eSBoYXZlIGEgdHlwbyB0aGVyZTogbXkgQUNLIHdhcyBmb3IgZHJiZCwgbm90IGJ0cmZzLgoKPiBB
Y2tlZC1ieTogQ29seSBMaSA8Y29seWxpQHN1c2UuZGU+IFtiY2FjaGVdCj4gLS0tCj4gICBhcmNo
L3VtL2RyaXZlcnMvdWJkX2tlcm4uYyAgICAgICAgICB8ICAyIC0tCj4gICBibG9jay9ibGstY29y
ZS5jICAgICAgICAgICAgICAgICAgICB8ICAyICstCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==

