Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF76C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jan 2022 19:05:10 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-pVG8DVguMqyYHvN1vYO_2g-1; Mon, 31 Jan 2022 14:05:05 -0500
X-MC-Unique: pVG8DVguMqyYHvN1vYO_2g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3C3A18B613D;
	Mon, 31 Jan 2022 19:05:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DDFA60854;
	Mon, 31 Jan 2022 19:05:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A3EF14CA93;
	Mon, 31 Jan 2022 19:04:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20VJ48JS023403 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 31 Jan 2022 14:04:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F373040CFD1D; Mon, 31 Jan 2022 19:04:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EED0C40CFD0F
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 19:04:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D571C1C04B64
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 19:04:07 +0000 (UTC)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
	[209.85.210.177]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-370-XUt4GwnMNjqkfhACPUFvNw-1; Mon, 31 Jan 2022 14:04:01 -0500
X-MC-Unique: XUt4GwnMNjqkfhACPUFvNw-1
Received: by mail-pf1-f177.google.com with SMTP id v74so13693545pfc.1;
	Mon, 31 Jan 2022 11:04:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:references:from:in-reply-to
	:content-transfer-encoding;
	bh=ba+ZTTm9dUGfaeSvRk+qlfqj/OlYP9s6XSq9bd25RTY=;
	b=npRwyFvxajFzPSUCWOy5Kvx56w5cPz+o+rKXEm0VLxvcVWn+groqIdJkygqqfadOgs
	yILO+yVL76vwJbTqTdG5YQkl7rx5K8jFSU1UDGAeqPEfRFc/ZUo19gyoBWU+Q+5PT5Zw
	hmCG28GEetWe/h8tEt1yrXhxVM+L44D725TIzq/Z5u+KY7Nzl9NR5QZZC5rbJlaXYj5g
	c8p+vf7VGqMn4HW/dP16VjclBQ/qoR7/qtDk1Si1MPgTkVMcgpNJbGXWvbbwqn0+uBzD
	3KabcHL919k0LEkJ3/jhpjS8lsAMfjM3cNZHsar0zlrOr9jd4bSj6VQ75j7TCbvQZQiM
	xo1w==
X-Gm-Message-State: AOAM530/CdSNf+wMR176oNcBYnDg2rt4x1lZ+Vm5PK7KaSCPkKQPI9eH
	Zk0ULJ5Wdh7hvzasvp37Xhs=
X-Google-Smtp-Source: ABdhPJzQA22tXEk8X4OPms7oAF0wKkcs2v8eBD4LAyDqrpj0MnwPbwFxejGQ4ckny7zBvb+xVPqt/g==
X-Received: by 2002:a63:343:: with SMTP id 64mr17733875pgd.463.1643655839828; 
	Mon, 31 Jan 2022 11:03:59 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19]) by smtp.gmail.com with ESMTPSA id
	e30sm5686912pge.34.2022.01.31.11.03.57
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 31 Jan 2022 11:03:58 -0800 (PST)
Message-ID: <59a907b6-596b-402c-b619-b0f5b6013dff@acm.org>
Date: Mon, 31 Jan 2022 11:03:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, "roland@purestorage.com"
	<roland@purestorage.com>, "mpatocka@redhat.com" <mpatocka@redhat.com>,
	Hannes Reinecke <hare@suse.de>, "kbus >> Keith Busch" <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>, "osandov@fb.com" <osandov@fb.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"clm@fb.com" <clm@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
	"tytso@mit.edu" <tytso@mit.edu>, "jack@suse.com" <jack@suse.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 1/26/22 23:14, Chaitanya Kulkarni wrote:
> [1]https://content.riscv.org/wp-content/uploads/2018/12/A-New-Golden-Age-for-Computer-Architecture-History-Challenges-and-Opportunities-David-Patterson-.pdf
> [2] https://www.snia.org/computational
> https://www.napatech.com/support/resources/solution-descriptions/napatech-smartnic-solution-for-hardware-offload/
>         https://www.eideticom.com/products.html
> https://www.xilinx.com/applications/data-center/computational-storage.html
> [3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy
> [4] https://www.spinics.net/lists/linux-block/msg00599.html
> [5] https://lwn.net/Articles/793585/
> [6] https://nvmexpress.org/new-nvmetm-specification-defines-zoned-
> namespaces-zns-as-go-to-industry-technology/
> [7] https://github.com/sbates130272/linux-p2pmem
> [8] https://kernel.dk/io_uring.pdf

Please consider adding the following link to the above list:
https://github.com/bvanassche/linux-kernel-copy-offload

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

