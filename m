Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EA2CC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  9 Mar 2022 01:01:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-HnAROCfMN6SUHlbwFUSqew-1; Tue, 08 Mar 2022 20:01:15 -0500
X-MC-Unique: HnAROCfMN6SUHlbwFUSqew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B5401C05B02;
	Wed,  9 Mar 2022 01:01:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6470C4010A15;
	Wed,  9 Mar 2022 01:01:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C429193212B;
	Wed,  9 Mar 2022 01:01:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4F6AB194F4AE
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Mar 2022 01:01:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B9B124010143; Wed,  9 Mar 2022 01:01:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B559B4010FCD
 for <dm-devel@redhat.com>; Wed,  9 Mar 2022 01:01:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AE59805F7C
 for <dm-devel@redhat.com>; Wed,  9 Mar 2022 01:01:08 +0000 (UTC)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-SixnJZBWOMqMqyVoF9fZWQ-1; Tue, 08 Mar 2022 20:01:06 -0500
X-MC-Unique: SixnJZBWOMqMqyVoF9fZWQ-1
Received: by mail-pg1-f169.google.com with SMTP id e6so623632pgn.2
 for <dm-devel@redhat.com>; Tue, 08 Mar 2022 17:01:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=6ZZxOF1UZdYmWcsF+G4Cy++VZ4bnPtZUo2Vt4FjwtGI=;
 b=xrtfeMM7BVTLKcfK0fgCWG6+1fqwukNY1fX6H8RWMwXML/Ta/D9c6rukJBQ3yRy2yZ
 P/C2dVORJS8VycbbXTP62Wh/s9Fg9J59wcvP+IY/SxlP4pU6CGSY6QlR5Fz8TQqkEusU
 iYtdRpIEkCWkQ8RoX06gxKM0bHwL2rXfuhuoxHQBxqmJZ5aMGC8v1csoBFfuWifPhES9
 KTsT2qukPtiuOFuUHMaWS1fEdmkPQGKbAE17RrscVu0rX7AwV27+75V+UPeFZGYj761n
 kWtwdVVE4+C45CyrsOqxT05hPETWJ2W73EfWMAX8YR2eOSx9g7nAiIjc4UJw/T3bVKzh
 DIiQ==
X-Gm-Message-State: AOAM531jqgtgz4uhDx1icxQsrTajIbF5fkUhg3wXWf1gwJlyG5ec0VQI
 EK8v9ZKseWY5bEUWKRbrpTh3ng==
X-Google-Smtp-Source: ABdhPJw8wYMUJ1TT+e5LCWPQcdeiQMTk8yoPMpHmtMfDIfhMY1+qfTodpbwOyZdHUV1wJnmVdVHYuw==
X-Received: by 2002:a05:6a00:bc8:b0:4f6:ff68:50ba with SMTP id
 x8-20020a056a000bc800b004f6ff6850bamr13433133pfu.69.1646787665250; 
 Tue, 08 Mar 2022 17:01:05 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 d20-20020a056a0010d400b004f7093700c4sm308968pfu.76.2022.03.08.17.01.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Mar 2022 17:01:04 -0800 (PST)
Message-ID: <70895fbc-392d-5ac6-4f7d-4593de5f74bb@kernel.dk>
Date: Tue, 8 Mar 2022 18:01:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Mike Snitzer <snitzer@redhat.com>
References: <20220307185303.71201-1-snitzer@redhat.com>
 <20220307185303.71201-2-snitzer@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220307185303.71201-2-snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v6 1/2] block: add ->poll_bio to
 block_device_operations
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/7/22 11:53 AM, Mike Snitzer wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> Prepare for supporting IO polling for bio-based driver.
> 
> Add ->poll_bio callback so that bio-based driver can provide their own
> logic for polling bio.
> 
> Also fix ->submit_bio_bio typo in comment block above
> __submit_bio_noacct.

Assuming you want to take this through the dm tree:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

