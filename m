Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857E3C76196
	for <dm-devel@archiver.kernel.org>; Tue, 28 Mar 2023 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680021384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ASXgnrzhANAqnOAVui4CRs61vC2YsRMof2Jke+oJ93k=;
	b=OgUgFbnr7vvGLijdknrltHk4V4AiQeOi+hBNw/SKeAAXzdld9/tSim9JPvLiCh6u0dQiyL
	4SiHVl6B1LTQPsS5sbHPUhmgzeABfHmR3KvN+B4AFPmukvpRlIYUKSPWUma5J1D7y9HsI8
	SgaNPQi6pXS1CeZFUF1Mc/xwRW51cDQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-cvSm7m65O2CEVvY3vQ8SzQ-1; Tue, 28 Mar 2023 12:36:21 -0400
X-MC-Unique: cvSm7m65O2CEVvY3vQ8SzQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6BEB8030A0;
	Tue, 28 Mar 2023 16:36:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 82C7C2166B26;
	Tue, 28 Mar 2023 16:36:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 361C1194658D;
	Tue, 28 Mar 2023 16:36:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DD23F194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Mar 2023 16:36:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC0D74020C83; Tue, 28 Mar 2023 16:36:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C4A914020C82
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 16:36:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9B203C0C884
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 16:36:16 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
 [209.85.160.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-4MwXelgBMg-B7y2i5rhs0Q-1; Tue, 28 Mar 2023 12:36:11 -0400
X-MC-Unique: 4MwXelgBMg-B7y2i5rhs0Q-1
Received: by mail-qt1-f181.google.com with SMTP id hf2so12476793qtb.3
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 09:36:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680021371;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=qZR6cbXQdwB5nUHvEEH2VeiB5R9CC8hRiYSzmgcjAyg=;
 b=mcahBufY2ppDopDKmS8rzVYyzrVTj0AcsjhyLjTmJyuLwnK7LwdADCuSc93sHEfgmy
 qfKu9jkDxKYUYYmJyA4VwmVb5FF14kgjTFhep0VdD17+E9ZgGZK2pQH0bLezscM8DL+C
 vquRXHuXwZ+dV99mXDl/mUys/JP0Fc5V42a0jQaEe58u3GXgAlgLUOOa4qlpCwQmFvWo
 Qmox2z+dVzyYCJYwsuYnDKvw2gp+SrtX3ZKitXVIyWBoPJJHT5tbYQ01uLbxn5LMeMwj
 FVDAD5M2htZtu28I2x9eizeF3I8ib63hK9fd6YVnWQFLh68iUpD6FD43rdcQjnC4KZVO
 6J4w==
X-Gm-Message-State: AO0yUKVPzpy0VNaKVQNxCfwicHR0T1G5UMfVOY5VdXGiVc/gH/TFUjod
 ADiwYrCXfSv7J7CDndzcScDXwS4=
X-Google-Smtp-Source: AK7set8/4ablYvt1w3rWWxBu5RP3Per1gtZi0bV85eHN9m6lD3okcPGkDhxHJ2UAhi56YjYdObx6pQ==
X-Received: by 2002:ac8:7d46:0:b0:3e3:95fb:8771 with SMTP id
 h6-20020ac87d46000000b003e395fb8771mr28046888qtb.31.1680021371021; 
 Tue, 28 Mar 2023 09:36:11 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 t23-20020ac865d7000000b003b635a5d56csm15765739qto.30.2023.03.28.09.36.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Mar 2023 09:36:10 -0700 (PDT)
Date: Tue, 28 Mar 2023 12:36:09 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <ZCMXecSrJ97oCD+s@redhat.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
 <20230324181741.13908-2-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20230324181741.13908-2-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v5 01/18] block: Add PR callouts for read
 keys and reservation
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, chaitanyak@nvidia.com,
 Chaitanya Kulkarni <kch@nvidia.com>, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
 james.bottomley@hansenpartnership.com, dm-devel@redhat.com,
 target-devel@vger.kernel.org, martin.petersen@oracle.com, kbusch@kernel.org,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 24 2023 at  2:17P -0400,
Mike Christie <michael.christie@oracle.com> wrote:

> Add callouts for reading keys and reservations. This allows LIO to support
> the READ_KEYS and READ_RESERVATION commands and will allow dm-multipath
> to optimize it's error handling so it can check if it's getting an error
> because there's an existing reservation or if we need to retry different
> paths.

Not seeing anything in DM's path selectors that adds these
optimizations. Is there accompanying multipath-tools callouts to get
at this data to optimize path selection (via DM table reloads)?

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

