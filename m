Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C86DEB64D9
	for <dm-devel@archiver.kernel.org>; Tue,  4 Jul 2023 14:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688479601;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QpVYVRxfsBHJr9kRqazCIbd5YuBCuWYEj887d/h9te8=;
	b=ehyoBDBoXknguXGTyTdAQol9tJ7I0+4ge1qD2jLRahxxuZb4Jq8dd05ctanqJ2/UUVtXZJ
	U9SU2hhXdA3ecFCuvjph+LAti0rvQ8gVmvmqd47+QSWhX6smKlLEfZk93bEn8RcwZAlfOZ
	XeJW1tG/OsmtI3VjX84d768O5dw/0lc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-h6h0fNa8O6iNd8fg06yDtQ-1; Tue, 04 Jul 2023 10:06:38 -0400
X-MC-Unique: h6h0fNa8O6iNd8fg06yDtQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2FED2834778;
	Tue,  4 Jul 2023 14:06:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CA0240C2063;
	Tue,  4 Jul 2023 14:06:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5254A1946589;
	Tue,  4 Jul 2023 14:06:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5520A1946588
 for <dm-devel@listman.corp.redhat.com>; Tue,  4 Jul 2023 14:06:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 08490492B03; Tue,  4 Jul 2023 14:06:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 00A5B492B01
 for <dm-devel@redhat.com>; Tue,  4 Jul 2023 14:06:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D39D8858290
 for <dm-devel@redhat.com>; Tue,  4 Jul 2023 14:06:32 +0000 (UTC)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-aUaP4NFvPXK1X6aV5j9vkA-1; Tue, 04 Jul 2023 10:06:31 -0400
X-MC-Unique: aUaP4NFvPXK1X6aV5j9vkA-1
Received: by mail-pl1-f170.google.com with SMTP id
 d9443c01a7336-1b8303cd32aso44543075ad.2; 
 Tue, 04 Jul 2023 07:06:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688479590; x=1691071590;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=JV2SCOEdB9t0w6tigDexjJMYhGF54ZwsLlYmJ1gE7wU=;
 b=Gp4PloH2K7cXML/X8xz/0txQpEP6p/4kj4dygHjVBzZ8/zN/efvAZOiju3RTWqiQV7
 tfbt1ttXWY9q4xfQFAmIGeixmVjtka4xhmvzKTwpSnLKgPyy2ERiF/+xiponUxAuGlLo
 z8j5DV3yoZKRmoPkavMw+0yBeWUua0WUzdS326Gun+5M7ehxzvTPM8DjIHIGw3Rl1BGw
 sPEYB2+rPUOhjJAy7/mpDEhSXcIAbz5Hgjc+1HK9n2MgvGaRVTqKhLO4BzGtELVSFg6S
 TOsGff3jAaRFf4TYb58GN+XEu1nNbuS/bomBTbsPxiQD9qZLthYYcHqFjn+vpa0eslw6
 ddBA==
X-Gm-Message-State: ABy/qLa4/GpmsJ4kBhRM4jov0bO+PQqzJjCjslWTnbicjoUEAxc1OmUg
 wGY0vDjgh/dQ0QAOziA2cms=
X-Google-Smtp-Source: APBJJlEESj5502hCCjnCrW5aNdhMviGxH5NXIz8SFwBF+614aVB6e0+1hJtWMTw8TJzZNuQy8olTNg==
X-Received: by 2002:a17:903:447:b0:1b8:a31b:ac85 with SMTP id
 iw7-20020a170903044700b001b8a31bac85mr2719760plb.41.1688479589749; 
 Tue, 04 Jul 2023 07:06:29 -0700 (PDT)
Received: from [192.168.50.14] ([98.51.102.78])
 by smtp.gmail.com with ESMTPSA id
 jk4-20020a170903330400b001b672af624esm13083569plb.164.2023.07.04.07.06.26
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 04 Jul 2023 07:06:29 -0700 (PDT)
Message-ID: <bb91e76b-0bd8-a949-f8b9-868f919ebcb9@acm.org>
Date: Tue, 4 Jul 2023 07:06:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org
References: <20230629165206.383-1-jack@suse.cz>
 <20230704122224.16257-1-jack@suse.cz>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230704122224.16257-1-jack@suse.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 01/32] block: Provide blkdev_get_handle_*
 functions
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 "Darrick J. Wong" <djwong@kernel.org>, linux-nvme@lists.infradead.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>, dm-devel@redhat.com,
 target-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
 Jack Wang <jinpu.wang@ionos.com>, Alasdair Kergon <agk@redhat.com>,
 drbd-dev@lists.linbit.com, linux-s390@vger.kernel.org,
 linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Christoph Hellwig <hch@infradead.org>, xen-devel@lists.xenproject.org,
 Gao Xiang <xiang@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 Sven Schnelle <svens@linux.ibm.com>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, Chao Yu <chao@kernel.org>,
 Joern Engel <joern@lazybastard.org>, reiserfs-devel@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Jens Axboe <axboe@kernel.dk>, linux-nfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, linux-mm@kvack.org,
 Song Liu <song@kernel.org>, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
 ocfs2-devel@oss.oracle.com, Anna Schumaker <anna@kernel.org>,
 linux-fsdevel@vger.kernel.org, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 7/4/23 05:21, Jan Kara wrote:
> +struct bdev_handle {
> +	struct block_device *bdev;
> +	void *holder;
> +};

Please explain in the patch description why a holder pointer is 
introduced in struct bdev_handle and how it relates to the bd_holder 
pointer in struct block_device. Is one of the purposes of this patch 
series perhaps to add support for multiple holders per block device?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

