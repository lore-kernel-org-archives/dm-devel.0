Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46CB6C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  9 Mar 2022 16:12:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-Em8SiVxYOVGFVJzCiT9iDA-1; Wed, 09 Mar 2022 11:12:01 -0500
X-MC-Unique: Em8SiVxYOVGFVJzCiT9iDA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF48318019EE;
	Wed,  9 Mar 2022 16:11:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 67343C50941;
	Wed,  9 Mar 2022 16:11:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 66E8D195355C;
	Wed,  9 Mar 2022 16:11:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5FD0D194F4AE
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Mar 2022 15:50:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A7D8141DC2A; Wed,  9 Mar 2022 15:50:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 26722141DC28
 for <dm-devel@redhat.com>; Wed,  9 Mar 2022 15:50:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F28B385A5BC
 for <dm-devel@redhat.com>; Wed,  9 Mar 2022 15:49:59 +0000 (UTC)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com
 [209.85.218.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-nQjfPAzEOcC50f-iS5ZJkA-1; Wed, 09 Mar 2022 10:49:58 -0500
X-MC-Unique: nQjfPAzEOcC50f-iS5ZJkA-1
Received: by mail-ej1-f42.google.com with SMTP id bg10so6033121ejb.4
 for <dm-devel@redhat.com>; Wed, 09 Mar 2022 07:49:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=xrbpP/Yfwao8lnj7LaSM/uRQpgaSVRznTS0TTH/HjZY=;
 b=dUPPs2XuWq+pR3oYKMf9iF9zgWpT8FnaNo8yQWmblrIuGIbLpRK6t7UQHuJ2aNWSC/
 TTrMhtsn9evTBaa4JBrelZeUJJap0CAzDJzz+cjrX7olmVtPOxQ3kaGRVBdEtMoHZoAf
 GiFa1ROpNzRD5rf86Q9nkuTXhfT6avomtXbA5yHD9e7yUIIt6kUzAWnxcSblWjpca7H9
 6kgcKMa0N2iOJXeHnsSbHkU5/iOg/JmoZ7h/yHlqe7kE/gSGF4qzbvHLDE//+WDB7UHD
 aczGaNKEjPB/w9KslV+26ZSkOSjX+/BgfvcaXX4XT9XJB4rrbS/bWDtqbOBvs5gJvd/C
 qClQ==
X-Gm-Message-State: AOAM5322Rhvsuk62V17RASh+1SYNX6wNRYXw+uw876HlE0I99fa3rG4+
 YPrifz0/YUECbf/4nzXnZwmscw==
X-Google-Smtp-Source: ABdhPJxZ5pBljQ9c4cS3Z9+taf/t5M3OBOhL/UO8YvG/idZkX4Ez6hrxTSX+wbR+RbFNFZdxzRpO9g==
X-Received: by 2002:a17:907:7f2a:b0:6d6:df12:7f57 with SMTP id
 qf42-20020a1709077f2a00b006d6df127f57mr390349ejc.122.1646840996396; 
 Wed, 09 Mar 2022 07:49:56 -0800 (PST)
Received: from [172.16.10.50] (213.16.174.189.dsl.dyn.forthnet.gr.
 [213.16.174.189]) by smtp.gmail.com with ESMTPSA id
 h8-20020a50ed88000000b004160630c980sm960188edr.62.2022.03.09.07.49.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Mar 2022 07:49:55 -0800 (PST)
Message-ID: <2015a35a-915c-351f-81cf-bd7dfe4502a1@arrikto.com>
Date: Wed, 9 Mar 2022 17:49:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Mikulas Patocka <mpatocka@redhat.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
 <012723a9-2e9c-c638-4944-fa560e1b0df0@arrikto.com>
 <c4124f39-1ee9-8f34-e731-42315fee15f9@nvidia.com>
 <23895da7-bcec-d092-373a-c3d961ab5c48@arrikto.com>
 <alpine.LRH.2.02.2203090347500.17712@file01.intranet.prod.int.rdu2.redhat.com>
From: Nikos Tsironis <ntsironis@arrikto.com>
In-Reply-To: <alpine.LRH.2.02.2203090347500.17712@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
 Offload
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
 Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dsterba@suse.com" <dsterba@suse.com>,
 "kbus @imap.gmail.com>> Keith Busch" <kbusch@kernel.org>,
 "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
 Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
 "martin.petersen@oracle.com >> Martin K. Petersen"
 <martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/9/22 10:51, Mikulas Patocka wrote:
> 
> Hi
> 
> Note that you must submit kcopyd callbacks from a single thread, otherwise
> there's a race condition in snapshot.
> 

Hi,

Thanks for the feedback. Yes, I'm aware of that.

> The snapshot code doesn't take locks in the copy_callback and it expects
> that the callbacks are serialized.
> 
> Maybe, adding the locks to copy_callback would solve it.
> 

That's what I did. I used a lock to ensure that kcopyd callbacks are
serialized for persistent snapshots.

For transient snapshots we can lift this limitation, and complete
pending exceptions out-of-oder and in "parallel", i.e., without
explicitly serializing kcopyd callbacks. The locks in pending_complete()
are enough in this case.

Nikos

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

