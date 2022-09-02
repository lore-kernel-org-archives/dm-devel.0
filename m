Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A08ECAAD3
	for <dm-devel@archiver.kernel.org>; Fri,  2 Sep 2022 00:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662077825;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C0k3U1um6H6BbuuIsRT+K4jgVAUEshctzlq+GPyFUbU=;
	b=SLldf4jrGH6rdlcEOsec4526FILsWTt1+yFKqvgB6d+4Evo6SIIkbhIIk7OY9mFcvu8wzu
	bMbJyPHp4zZeOh6kUhnGT9PxsppthDG8oXauaoHmTtpMa3BetY9Ix4M7H2ublpp3MMGxbd
	DWrSd9nmGaaKmU9OsUilhLlg+MKlNEc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-1FzYkEWRNeWoNgGA3E5zfQ-1; Thu, 01 Sep 2022 20:17:02 -0400
X-MC-Unique: 1FzYkEWRNeWoNgGA3E5zfQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64F6D101AA47;
	Fri,  2 Sep 2022 00:17:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 537F840B40C7;
	Fri,  2 Sep 2022 00:17:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1DFFC19426AB;
	Fri,  2 Sep 2022 00:17:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9F9E41946A5E
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Sep 2022 00:16:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 84099C15BBD; Fri,  2 Sep 2022 00:16:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 804D2C15BB3
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 00:16:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66C9E1C04B57
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 00:16:59 +0000 (UTC)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-515-mIXFoN9sNB-vMvL_LZFp4Q-1; Thu, 01 Sep 2022 20:16:58 -0400
X-MC-Unique: mIXFoN9sNB-vMvL_LZFp4Q-1
Received: by mail-qt1-f198.google.com with SMTP id
 bq11-20020a05622a1c0b00b003434f125b77so386302qtb.20
 for <dm-devel@redhat.com>; Thu, 01 Sep 2022 17:16:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=70lKWmlrtQoxiqEddVxE204zBfW5n8dIdIq2Ch1+cXM=;
 b=os0lOFQCvv8PHMRnjnUrDnUdlTnPvZKNazrFMFIvcAhCccHkH77N8/nZ1VcEyOqJyY
 i0BmLKXK9QVAtjiWlZJadQWa44kK9uV3eIejcXaA5T2rJgx7Ao3oLQk8dunS5AzCsGjy
 p33Um36sm16aoFPHC2sec6AO14E4CattICuJfQkfPGh2zVxDYan1pcgA9K71GV0MPtQa
 RVZ9GxhKH5PwhgBi9gHyW1dKU4eYB0foobgR17qCIkC5KWXo1cMH0PeB5BpHGte+jXgZ
 Y+RVURX0nNrMANEIKCM5JXbNoJgiiN+BAdoNixRJxY8+deGaK8g4uH+dgdKM0a0WW3vI
 GVww==
X-Gm-Message-State: ACgBeo1StcEAbkVpf6lGe5BR4Z7xZDACecSdJWHPjxly3haQRgfnb9kD
 0rdERTUr705GuibD0oG/0Ikacs/JyioXbXJtV1GCokR/6oSLhYl/uwmyt/BC9woKtN9XwcIt44O
 kJuhbkpiuIgMR1g==
X-Received: by 2002:a05:620a:2551:b0:6b8:f97f:b855 with SMTP id
 s17-20020a05620a255100b006b8f97fb855mr21703757qko.260.1662077817838; 
 Thu, 01 Sep 2022 17:16:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6oThe4Ex4yHgqF6bEQvTIX/Gkg5IvByk6dGpbsPU+Rt5JY04QaEnAC3Hf1+9V3KO2xRre6mg==
X-Received: by 2002:a05:620a:2551:b0:6b8:f97f:b855 with SMTP id
 s17-20020a05620a255100b006b8f97fb855mr21703745qko.260.1662077817650; 
 Thu, 01 Sep 2022 17:16:57 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 x6-20020ac84a06000000b00342f8143599sm157323qtq.13.2022.09.01.17.16.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Sep 2022 17:16:57 -0700 (PDT)
Date: Thu, 1 Sep 2022 20:16:56 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <YxFLeNfAb/Uzf5nD@redhat.com>
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121911eucas1p2a55dec72a6d780123e6c7655aee72457@eucas1p2.samsung.com>
 <20220823121859.163903-10-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220823121859.163903-10-p.raghav@samsung.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v12 09/13] dm-zone: use generic helpers to
 calculate offset from zone start
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
Cc: axboe@kernel.dk, bvanassche@acm.org, pankydev8@gmail.com,
 Johannes.Thumshirn@wdc.com, damien.lemoal@opensource.wdc.com,
 snitzer@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, matias.bjorling@wdc.com, gost.dev@samsung.com,
 jaegeuk@kernel.org, hch@lst.de, agk@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 23 2022 at  8:18P -0400,
Pankaj Raghav <p.raghav@samsung.com> wrote:

> Use the bdev_offset_from_zone_start() helper function to calculate
> the offset from zone start instead of using power of 2 based
> calculation.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

