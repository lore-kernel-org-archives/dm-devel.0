Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21634C77B78
	for <dm-devel@archiver.kernel.org>; Fri,  7 Apr 2023 20:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680898128;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+ZmDZH043eoW64YI/IvdSFPbg/Tnd9+4oXDopNkZhnk=;
	b=aFb0bc6p0zXubgfKgkdt/nrU+QrKTPdyiFHK+HVW8AJFCoDsx5Z+u/Euxuv6I6TGW4xWN9
	vhLRwN1k78/tIGUdmx1K2FL84I/435wJuWJvIx8foa6MXgFXYDDIG5woukCyHzhexhyy0s
	xMXvQO0jGfBYaDbGWeMZnkpgbnkdd9c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-JZiI2xUwNGS6jYKgmPbWYg-1; Fri, 07 Apr 2023 16:08:45 -0400
X-MC-Unique: JZiI2xUwNGS6jYKgmPbWYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AC4E855304;
	Fri,  7 Apr 2023 20:08:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 354E3C1602A;
	Fri,  7 Apr 2023 20:08:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F330619465BB;
	Fri,  7 Apr 2023 20:08:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B144719465B5
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Apr 2023 20:08:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9681F492B01; Fri,  7 Apr 2023 20:08:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F528492B00
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:08:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 753653802B8C
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:08:37 +0000 (UTC)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-6T9rkWF0MlCrgK2URbGKVA-1; Fri, 07 Apr 2023 16:08:35 -0400
X-MC-Unique: 6T9rkWF0MlCrgK2URbGKVA-1
Received: by mail-pj1-f50.google.com with SMTP id
 r7-20020a17090b050700b002404be7920aso42407013pjz.5
 for <dm-devel@redhat.com>; Fri, 07 Apr 2023 13:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680898114; x=1683490114;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=CkZ9epVN8TkdRsJcbdQlduPOctGu1N9KX0JTrq0nz1g=;
 b=wHnw7u7alcTrQFUGZmwK6ii6MQHV5yfowawWRPJ+qAHh+8lHMs8fym7f2FDX5MAeNx
 Ig99jtl+yHAmYqFk38cNwWkFicULE2RocQJFdGqSXavKlP4hLHFgkw5vmjpQimzZy41P
 rGkEtQQTd7Gjop/IZIwWDnDIeujCs6iyRCRV+8goy1/M1YFOum6e8spKgQtZTrgaRfwO
 obBW1EioVgMFmaWbWh8XoTof2y1neS5b989qU7x7wJ6tUSVZUESR4WLjSsHjMXTOCOM/
 +WSu0wC8h9q2/7DW5np3i0fdHnra5N7VC4gup/eMSW7mELsN9N22s9D/GAstLjJfYlNq
 qhaA==
X-Gm-Message-State: AAQBX9c4YsWCZHfFjFtGg78g3g9RIzfnuK0SybPgSoOwZUXUUqG3w24z
 0+kMDeq6tfPjPt3Vt6v/d4c=
X-Google-Smtp-Source: AKy350bkZ/dbg++B75vxCCybX1JJjWE1bjDcXVcXGtkaYO/su68D56optz/DjfTQFNhiuhs1ZBvehA==
X-Received: by 2002:a17:903:2309:b0:1a2:55c9:1808 with SMTP id
 d9-20020a170903230900b001a255c91808mr4182456plh.17.1680898113889; 
 Fri, 07 Apr 2023 13:08:33 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:f2c:4ac2:6000:5900?
 ([2620:15c:211:201:f2c:4ac2:6000:5900])
 by smtp.gmail.com with ESMTPSA id
 ju20-20020a170903429400b0019aafc422fcsm3272871plb.240.2023.04.07.13.08.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 07 Apr 2023 13:08:33 -0700 (PDT)
Message-ID: <0d7d40a3-bd58-03f2-5bf2-706ed2e6155f@acm.org>
Date: Fri, 7 Apr 2023 13:08:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
To: Mike Christie <michael.christie@oracle.com>, hch@lst.de,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com, kbusch@kernel.org,
 target-devel@vger.kernel.org
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-5-michael.christie@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230407200551.12660-5-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v6 04/18] scsi: Move sd_pr_type to scsi_common
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
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 4/7/23 13:05, Mike Christie wrote:
> LIO is going to want to do the same block to/from SCSI pr types as sd.c
> so this moves the sd_pr_type helper to scsi_common and renames it. The
> next patch will then also add a helper to go from the SCSI value to the
> block one for use with PERSISTENT_RESERVE_IN commands.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

