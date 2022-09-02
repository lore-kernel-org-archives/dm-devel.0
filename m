Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8002FC38145
	for <dm-devel@archiver.kernel.org>; Fri,  2 Sep 2022 00:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662078549;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KvzX9/mNwxmuW+AaIDEdAdOWhEczKaEiKtl0WwRRZ64=;
	b=elnelzxGvCYmO+cvzG3oF7X3jm6OOQdqIL3gF4qV2w+kUYdqdk8vp1CjMPPv6eAWjHp19t
	jKF12z7AGCBM4+VtwOxZS1MBS7Yut4hxKVugwlcPl0pawB65HOfOAcypJ2ssIgd+8k4yfu
	VA1oQTFcVPHsoTRyb/VQahMQUN71Pz0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-t2LHekxdNXiXFQ_TUq3R0A-1; Thu, 01 Sep 2022 20:29:08 -0400
X-MC-Unique: t2LHekxdNXiXFQ_TUq3R0A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3093818188A2;
	Fri,  2 Sep 2022 00:29:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1F04492C3B;
	Fri,  2 Sep 2022 00:29:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9817E19426AB;
	Fri,  2 Sep 2022 00:29:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E8EA1946A5E
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Sep 2022 00:29:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 457EE945D0; Fri,  2 Sep 2022 00:29:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 41DB918ECC
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 00:29:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26C4B101A58F
 for <dm-devel@redhat.com>; Fri,  2 Sep 2022 00:29:03 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-150-TKiLB6IfM-iRJO5n_0IqjQ-1; Thu, 01 Sep 2022 20:29:02 -0400
X-MC-Unique: TKiLB6IfM-iRJO5n_0IqjQ-1
Received: by mail-qk1-f200.google.com with SMTP id
 s9-20020a05620a254900b006b54dd4d6deso715082qko.3
 for <dm-devel@redhat.com>; Thu, 01 Sep 2022 17:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=JoL26AsmguCoQC8iT7uL94/0V02t17IP8zjffwCfRFk=;
 b=ecOecuHHwkcNeEnzGRDC2I3OvA9mPdk43f4AzPvph1Bu1omu+wC7SsJzY7Q233YIKi
 OY6+iNYrxP1x2tGjHvJjV9LB/VcWWnNPdusu3RWIhlNkmsrcsOAto9XYvUCDjcU+/L7s
 ksQi8wGrMORfLohRzDnotHY3Mc4HMxOPpOnme2SOmOT00AmpOc+PQUlAbfdPDGnZWTBT
 v3N/xDls8tihMaTgFvpwSxLlD7OwWEE01L5mTdbkkft7xmtZnX2s/1pHeMN1XW8812hH
 YEjNsp7e+9YQ0lo4oaYHOT7fvDyeh37yzKnNDRnBKvYFj3G+H6kcOiG3FdhX44YldnOJ
 Q3XA==
X-Gm-Message-State: ACgBeo0MXTn8EDFA0v56VG1U9iDMoB+Fn5egG/gMARJOd9vIJHwvZOlg
 OB3K8qNanN5TziZ+reNpX56MKPlR9zg0SZkZ7EELeh3AhEFxBRATY4YD4WIW+jagbyEGfZzKq6q
 q2lk7fAZUAvTs4g==
X-Received: by 2002:a05:622a:56:b0:344:50e3:3363 with SMTP id
 y22-20020a05622a005600b0034450e33363mr26078608qtw.217.1662078541490; 
 Thu, 01 Sep 2022 17:29:01 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4ummQqIzdjpLP2wlMT3mmzaahpZ4roXiEIZrDjJAlvbH341hXfcfEvnw7FaTjjSfTvav+c8Q==
X-Received: by 2002:a05:622a:56:b0:344:50e3:3363 with SMTP id
 y22-20020a05622a005600b0034450e33363mr26078588qtw.217.1662078541288; 
 Thu, 01 Sep 2022 17:29:01 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 15-20020ac84e8f000000b0031f0b43629dsm180519qtp.23.2022.09.01.17.29.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Sep 2022 17:29:00 -0700 (PDT)
Date: Thu, 1 Sep 2022 20:28:59 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <YxFOS8fq8AeE5mkf@redhat.com>
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121914eucas1p2f4445066c23cdae4fca80f7b0268815b@eucas1p2.samsung.com>
 <20220823121859.163903-13-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220823121859.163903-13-p.raghav@samsung.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v12 12/13] dm: introduce DM_EMULATED_ZONES
 target type
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
 matias.bjorling@wdc.com, Johannes.Thumshirn@wdc.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, gost.dev@samsung.com,
 jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 23 2022 at  8:18P -0400,
Pankaj Raghav <p.raghav@samsung.com> wrote:

> Introduce a new target type DM_EMULATED_ZONES for targets with
> a different number of sectors per zone (aka zone size) than the underlying
> device zone size.
> 
> This target type is introduced as the existing zoned targets assume
> that the target and the underlying device have the same zone size.
> The new target: dm-po2zone will use this new target
> type as it emulates the zone boundary that is different from the
> underlying zoned device.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

This patch's use of "target type" jargon isn't valid. 

Please say "target feature flag" and rename DM_EMULATED_ZONES to
DM_TARGET_EMULATED_ZONES in the subject and header.

But, with those fixed:

Signed-off-by: Mike Snitzer <snitzer@kernel.org>

(fyi, I'll review patch 13, the dm-po2zone target, tomorrow)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

