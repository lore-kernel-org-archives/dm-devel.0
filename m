Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A1AC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Mar 2022 18:37:04 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-jRIGlsgqODW62j_d7abEAw-1; Thu, 03 Mar 2022 13:37:01 -0500
X-MC-Unique: jRIGlsgqODW62j_d7abEAw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E1D6824FA6;
	Thu,  3 Mar 2022 18:36:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C238B804E9;
	Thu,  3 Mar 2022 18:36:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 07CB74EA37;
	Thu,  3 Mar 2022 18:36:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 223IamPG013812 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Mar 2022 13:36:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 942DE4010E6C; Thu,  3 Mar 2022 18:36:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9003F4010FCB
	for <dm-devel@redhat.com>; Thu,  3 Mar 2022 18:36:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 682651C0D105
	for <dm-devel@redhat.com>; Thu,  3 Mar 2022 18:36:48 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
	[209.85.221.51]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-204-nO5GfK3_MT2FUsEGiKrduw-1; Thu, 03 Mar 2022 13:36:46 -0500
X-MC-Unique: nO5GfK3_MT2FUsEGiKrduw-1
Received: by mail-wr1-f51.google.com with SMTP id u10so7563171wra.9
	for <dm-devel@redhat.com>; Thu, 03 Mar 2022 10:36:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=gSsCl/XOESNqiNL4KQnFJzGeYGKZJS/OXefqIbgZZJY=;
	b=VvpDVmPGrXdqwLTY+X5jtUNNIn9VAf26Hrkn/OeCPH0BQYQ6BXKS39LAAo7k1pj1Lr
	XouNmToJZx5bI3FW4nwqwHyG9UF9zhlMqTBzSlN9e3BZ5EacquKOU2LZ7bILTXTblk8a
	+48OCan8Mwqw8Y3C72+FNFCmKIHywsb6oSHKE0DtT7OMKBBVlJ8T25u5aem47uuMiMzl
	f75XCEQZuVTKRxIqACV5/G25XqjsfpA6Ixxa4T3XzqZa8N3R4zhhj2yVQ0jJf9goeWfw
	Qojp1zIyyBBamyTwl9f669bL2jgIumkiA3RsZzDwJ936814QP0FcuiPT4XdpoEeVC4D2
	YoZA==
X-Gm-Message-State: AOAM5326WitSFYGdZfqM7uy7CyK1ybQGJsUiAIfmacFAGzF1foMTk5PQ
	hTMuKJZ6E6ACKEGBI+7/EtBo4A==
X-Google-Smtp-Source: ABdhPJxWp//CMSQXMH4wlOTWsuUAaFU8DcmiZw37tn30FWgGhLmSgbx50j5GThznhd1HjqQ4Zon/5g==
X-Received: by 2002:a5d:61cb:0:b0:1f0:2598:88ff with SMTP id
	q11-20020a5d61cb000000b001f0259888ffmr7318696wrv.444.1646332605416;
	Thu, 03 Mar 2022 10:36:45 -0800 (PST)
Received: from [172.16.10.50] (213.16.240.129.dsl.dyn.forthnet.gr.
	[213.16.240.129]) by smtp.gmail.com with ESMTPSA id
	x15-20020adfdd8f000000b001f0473a0a3fsm2705941wrl.14.2022.03.03.10.36.42
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 03 Mar 2022 10:36:44 -0800 (PST)
Message-ID: <0e63b59c-779c-d85b-693e-79d2924acbe0@arrikto.com>
Date: Thu, 3 Mar 2022 20:36:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.6.1
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<012723a9-2e9c-c638-4944-fa560e1b0df0@arrikto.com>
	<c4124f39-1ee9-8f34-e731-42315fee15f9@nvidia.com>
From: Nikos Tsironis <ntsironis@arrikto.com>
In-Reply-To: <c4124f39-1ee9-8f34-e731-42315fee15f9@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbus >> Keith Busch" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/1/22 23:32, Chaitanya Kulkarni wrote:
> Nikos,
> 
>>> [8] https://kernel.dk/io_uring.pdf
>>
>> I would like to participate in the discussion too.
>>
>> The dm-clone target would also benefit from copy offload, as it heavily
>> employs dm-kcopyd. I have been exploring redesigning kcopyd in order to
>> achieve increased IOPS in dm-clone and dm-snapshot for small copies over
>> NVMe devices, but copy offload sounds even more promising, especially
>> for larger copies happening in the background (as is the case with
>> dm-clone's background hydration).
>>
>> Thanks,
>> Nikos
> 
> If you can document your findings here it will be great for me to
> add it to the agenda.
> 

Hi,

Give me a few days to gather my notes, because it's been a while since
the last time I worked on this, and I will come back with a summary of
my findings.

Nikos

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

