Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 748B8C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 01:48:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-Y4-Z5gkXPtGpcncrgEUzxQ-1; Sun, 06 Mar 2022 20:48:26 -0500
X-MC-Unique: Y4-Z5gkXPtGpcncrgEUzxQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D95123C14840;
	Mon,  7 Mar 2022 01:48:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 841DE1121321;
	Mon,  7 Mar 2022 01:48:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5B018194E109;
	Mon,  7 Mar 2022 01:48:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8CFD4194E107
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 01:48:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7CFFEC202C9; Mon,  7 Mar 2022 01:48:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7937FC202C5
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 01:48:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F03882A682
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 01:48:20 +0000 (UTC)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-Epn2BsMdPvSWDWD9vlTGJA-2; Sun, 06 Mar 2022 20:48:18 -0500
X-MC-Unique: Epn2BsMdPvSWDWD9vlTGJA-2
Received: by mail-pl1-f170.google.com with SMTP id z3so3977351plg.8
 for <dm-devel@redhat.com>; Sun, 06 Mar 2022 17:48:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=bk2SrrmMwatO8jIwgacbXdZ4/wRBNWsFXgo/yRl17T4=;
 b=mWtUjnGXgI6lZsyWWUaMZemDYrEfF7EtJBa7OD9Q1f4/Cl0urP4Y/B0dCsNx7E2zxW
 MWV2oocIj/JoPPlqIGHGY4JgsSJO69m5GnqdOO0uQ1mhnuvEBXGbBkS6Z+YQ0EgrXNOp
 mcG9j3vHegofLn3dqp5h+leQ2GXxXVsRrntdqJOpDnHb0u+xPxyXZPJciPTGyZ4OXyZg
 ffalbXJzXU0Ie+KFE+r/hA6+L5FQCPMx3vckGEP1hyBqxyxPzgd/2nvCTogNHrsddtpm
 E3WFF26oxdE6Uar9xkj3cczA33ubqsiBnywvZTuc1qn1HxH1NEc4e7WxBvnz8CvN1f9v
 ocEw==
X-Gm-Message-State: AOAM532GI6XldO+ezMLEV7RaUqn8hpUTdRhnoTV0JOIz0SxuUEkURAE2
 Xjh+4zPhOy0772Cj2yk4wpkmZg==
X-Google-Smtp-Source: ABdhPJw4tIzpDi8DJH6TcUSQE31XToP6eLrLTWEl2sq3N8CBypa2+SNU3rgG8PftpPRJ1suDhMy+yg==
X-Received: by 2002:a17:90a:12c8:b0:1bf:6484:3e27 with SMTP id
 b8-20020a17090a12c800b001bf64843e27mr2912077pjg.209.1646617697215; 
 Sun, 06 Mar 2022 17:48:17 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 nk11-20020a17090b194b00b001beed2f1046sm14238923pjb.28.2022.03.06.17.48.16
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 06 Mar 2022 17:48:16 -0800 (PST)
Message-ID: <2ced53d5-d87b-95db-a612-6896f73ce895@kernel.dk>
Date: Sun, 6 Mar 2022 18:48:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
References: <20220305020804.54010-1-snitzer@redhat.com>
 <20220305020804.54010-3-snitzer@redhat.com> <20220306092937.GC22883@lst.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220306092937.GC22883@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v5 2/2] dm: support bio polling
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/6/22 2:29 AM, Christoph Hellwig wrote:
>> +/*
>> + * Reuse ->bi_end_io as hlist head for storing all dm_io instances
>> + * associated with this bio, and this bio's bi_end_io has to be
>> + * stored in one of 'dm_io' instance first.
>> + */
>> +static inline struct hlist_head *dm_get_bio_hlist_head(struct bio *bio)
>> +{
>> +	WARN_ON_ONCE(!(bio->bi_opf & REQ_DM_POLL_LIST));
>> +
>> +	return (struct hlist_head *)&bio->bi_end_io;
>> +}
> 
> So this reuse is what I really hated.  I still think we should be able
> to find space in the bio by creatively shifting fields around to just
> add the hlist there directly, which would remove the need for this
> override and more importantly the quite cumbersome saving and restoring
> of the end_io handler.

If it's possible, then that would be preferable. But I don't think
that's going to be easy to do...

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

