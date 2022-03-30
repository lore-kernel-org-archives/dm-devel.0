Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF9B4C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 16:07:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-KnyR36FOMcumhedpMyvawQ-1; Wed, 30 Mar 2022 12:07:40 -0400
X-MC-Unique: KnyR36FOMcumhedpMyvawQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D73F811E75;
	Wed, 30 Mar 2022 16:07:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF18AC202CA;
	Wed, 30 Mar 2022 16:07:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7B80A1947BBB;
	Wed, 30 Mar 2022 16:06:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC64A19451F3
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 16:06:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 63A6A57E42B; Wed, 30 Mar 2022 16:06:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F97E57E42A
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 16:06:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6237328EC12E
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 16:06:55 +0000 (UTC)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com
 [209.85.218.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-fJgboBJfPZG5_IoVNgSRoA-1; Wed, 30 Mar 2022 12:06:51 -0400
X-MC-Unique: fJgboBJfPZG5_IoVNgSRoA-1
Received: by mail-ej1-f46.google.com with SMTP id bi12so42561938ejb.3;
 Wed, 30 Mar 2022 09:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=HkRM1644sEkQj+vw7+BpYrEb8FFczpism1W+jxUvao0=;
 b=j0ppEbaNOly9LZ9uuBmRr5Qd322QsOnJXeqXIUTJ8i95+4/LpgXag9R3NXZofjmQyy
 DwYUDM9eRTYO4FyvFUGsekZxlORXLWzn0G6bCV0BDP7JY/AbJp9MoYDy85+vIQC2mVVy
 tAnNMxstJxGoaF1Un+hLMu5IZkYhU9Dbfrz6EqTTQQQWAFccLJbFeopmQabx3VGy1bTt
 IyUqDfOgRm7/VgScTbP1rIML3/ax3bdfoT/G2rhFWgPU5ILvI+yQcF93KRmVAHcjHuc5
 npfvUnxrtQRwLeFXgbYxajperVywwlCY28tL9E8jfTgFB6QLC0xyCSF1wuQNgPxoAsp2
 AmSw==
X-Gm-Message-State: AOAM533XUT382Hzl+hNTPSCk5dTblC58PONJigCIUWdBDOU53vP7EwRT
 3NkvfHEgnk8rnv1iJGfAibfF124hfDg=
X-Google-Smtp-Source: ABdhPJxDNuGHTUmFeM8HOccXKYnLtEa6vqnOdswNiaFVA+fcUuwZtdgQLruyjGdOkxmBUJd3vMOJ9Q==
X-Received: by 2002:a17:907:d2a:b0:6df:8b4b:2b3b with SMTP id
 gn42-20020a1709070d2a00b006df8b4b2b3bmr192289ejc.575.1648656409154; 
 Wed, 30 Mar 2022 09:06:49 -0700 (PDT)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 u9-20020a170906124900b006ce88a505a1sm8586578eja.179.2022.03.30.09.06.48
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 30 Mar 2022 09:06:48 -0700 (PDT)
Message-ID: <51adf3ef-c71c-48b3-59ac-035e09d20f04@gmail.com>
Date: Wed, 30 Mar 2022 18:06:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
References: <4ed29ab9-5cbc-2185-d87d-9a6dbe82a460@redhat.com>
 <alpine.LRH.2.02.2203261023170.21027@file01.intranet.prod.int.rdu2.redhat.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <alpine.LRH.2.02.2203261023170.21027@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH] dm-integrity: fix a BUG if we shrink the
 device
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
Cc: Ondrej Kozina <okozina@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
 Daniel Zatovic <dzatovic@redhat.com>
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

On 26/03/2022 15:24, Mikulas Patocka wrote:
> The patch f6f72f32c22c ("dm integrity: don't replay journal data past the
> end of the device") skips journal replay if the target sector points
> beyond the end of the device. Unfortunatelly, it doesn't set the journal
> entry unused, which resulted in this BUG being triggered:
> BUG_ON(!journal_entry_is_unused(je))
> 
> This patch fixes the crash.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: f6f72f32c22c ("dm integrity: don't replay journal data past the end of the device")
> Cc: stable@vger.kernel.org	# v5.7+
> 
> ---
>   drivers/md/dm-integrity.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux-dm/drivers/md/dm-integrity.c
> ===================================================================
> --- linux-dm.orig/drivers/md/dm-integrity.c	2022-02-10 18:16:42.000000000 +0100
> +++ linux-dm/drivers/md/dm-integrity.c	2022-03-25 18:20:27.000000000 +0100
> @@ -2473,9 +2473,11 @@ static void do_journal_write(struct dm_i
>   					dm_integrity_io_error(ic, "invalid sector in journal", -EIO);
>   					sec &= ~(sector_t)(ic->sectors_per_block - 1);
>   				}
> +				if (unlikely(sec >= ic->provided_data_sectors)) {
> +					journal_entry_set_unused(je);
> +					continue;
> +				}
>   			}
> -			if (unlikely(sec >= ic->provided_data_sectors))
> -				continue;
>   			get_area_and_offset(ic, sec, &area, &offset);
>   			restore_last_bytes(ic, access_journal_data(ic, i, j), je);
>   			for (k = j + 1; k < ic->journal_section_entries; k++) {
> 

If it helps anything,
Tested-by: Milan Broz <gmazyland@gmail.com>

Mike, please send this to stable ASAP, this is a quite serious bug.

Thanks,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

