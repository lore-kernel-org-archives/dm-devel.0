Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A15C43334
	for <dm-devel@archiver.kernel.org>; Sun,  5 Jun 2022 18:15:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-lkhEVTSyMrmeoGb26L--hA-1; Sun, 05 Jun 2022 14:15:34 -0400
X-MC-Unique: lkhEVTSyMrmeoGb26L--hA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F1523806658;
	Sun,  5 Jun 2022 18:15:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 717E61402410;
	Sun,  5 Jun 2022 18:15:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 00697194707A;
	Sun,  5 Jun 2022 18:15:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7ED7194706E
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Jun 2022 18:15:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 84D931121314; Sun,  5 Jun 2022 18:15:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 813FD1121315
 for <dm-devel@redhat.com>; Sun,  5 Jun 2022 18:15:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67D7B811E75
 for <dm-devel@redhat.com>; Sun,  5 Jun 2022 18:15:28 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-EqBJf6CJN8-xqafHdhNwew-1; Sun, 05 Jun 2022 14:15:19 -0400
X-MC-Unique: EqBJf6CJN8-xqafHdhNwew-1
Received: by mail-pj1-f47.google.com with SMTP id
 mh16-20020a17090b4ad000b001e8313301f1so4263892pjb.1
 for <dm-devel@redhat.com>; Sun, 05 Jun 2022 11:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:references:from:in-reply-to
 :content-transfer-encoding;
 bh=XSlVkyH7U19xGkYlKr/QL4qLZZfZicYNepi5FhO2rEw=;
 b=0arJR1LUuk9vsYk801KNyTF8PGP/NC9IUb+NT2/vupbTjlQ4BOIJto9met8TUg78jY
 8NnulnSHU498Wz1bNVNB+y5nUFYqFjhkGs1Pj3veU4xHm1T69te3/AkDlbTol/8lSDbs
 +frfvAMl/OaEYd9eoIPK361f3YrWnxB+50I2GYCPwqQuelIeCuAqiWL6S9IQCVUc8K6J
 vPcVRUo6HGleZ3GxUgVc+mJ4mif3PctmrNcBTEv/mnwhbNLQ43PxgV8kBy9BayfVbtkh
 DyNNDMpzHMJg2QOFB6ehechIEhC9YLzJUJiEqPORhr0TUexvCZL2PoyQda9jh8AQCtmu
 pmfA==
X-Gm-Message-State: AOAM532mPQ+aVpic+YFIhdEQFPMkMSIlRsutBKcE2ymKh/fIpMFMQc/W
 QeRMof1e4O8Sg/r89K79dsM=
X-Google-Smtp-Source: ABdhPJzwmoB07s/jOnk8v4k4T/5zMb0rCKNH1kw1FFfezoahiovaXCjjQpB7yOYVhdgpQekTAqpCEA==
X-Received: by 2002:a17:902:ef49:b0:15e:b6ed:4832 with SMTP id
 e9-20020a170902ef4900b0015eb6ed4832mr19851455plx.173.1654452917814; 
 Sun, 05 Jun 2022 11:15:17 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd?
 ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
 by smtp.gmail.com with ESMTPSA id
 y189-20020a6264c6000000b0050dc762814asm9061560pfb.36.2022.06.05.11.15.15
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 05 Jun 2022 11:15:16 -0700 (PDT)
Message-ID: <09be5981-705a-5c82-a189-dd7f0475d227@acm.org>
Date: Sun, 5 Jun 2022 11:15:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Mike Christie <michael.christie@oracle.com>, linux-block@vger.kernel.org, 
 dm-devel@redhat.com, snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <923053d3-adf8-e4b4-9ef3-8e920ae90a79@acm.org>
 <d18d9e19-d184-357c-9921-d024f0b50d1a@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d18d9e19-d184-357c-9921-d024f0b50d1a@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 0/8] Use block pr_ops in LIO
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/5/22 09:55, Mike Christie wrote:
> libiscsi is not suitable for this type of setup.
I think that this setup can be tested as follows with libiscsi:
* Configure the backend storage.
* Configure LIO to use the backend storage on two different servers.
* On a third server, log in with the iSCSI initiator to both servers.
* Run the libiscsi iscsi-test-cu test software on the third server and
   pass the two IQNs that refer to the LIO servers as arguments.

 From the iscsi-test-cu -h output:

     iscsi-test-cu [OPTIONS] <iscsi-url> [multipath-iscsi-url]

Did I perhaps overlook or misunderstand something?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

