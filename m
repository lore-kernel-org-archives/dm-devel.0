Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9755CC64ED6
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 20:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677531381;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=weCp7W3uuWWXWSih/VLKCBAX0OzYnjGxK7XoSBjvcuM=;
	b=eVgOgWG+Oo7LleJ1DMmGa192h4YKlIfXYm6Z5eQU8V77ShQJfyzXN06vkVazcWms9mw/4N
	qjXdo1Gn7LIvefnWN7wrcKG1EdBIICj3QzA0j/TImTIVOzMJB9ChbeVdV5BtR8vm/wG2I4
	QNn+M+Aq3E46T5pDtpih3bdTMkCpxkM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-QUJPp2KYMNKtA9Q1uLT3cw-1; Mon, 27 Feb 2023 15:56:19 -0500
X-MC-Unique: QUJPp2KYMNKtA9Q1uLT3cw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6901B100F84F;
	Mon, 27 Feb 2023 20:56:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47B6C140EBF4;
	Mon, 27 Feb 2023 20:56:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F33E61946587;
	Mon, 27 Feb 2023 20:56:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A3D2A1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Feb 2023 20:56:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6833AC15BAE; Mon, 27 Feb 2023 20:56:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 60924C15BAD
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 20:56:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 458EA830F88
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 20:56:12 +0000 (UTC)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com
 [209.85.160.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-488-TkE1EShvPHiZD6IrmKwWxg-1; Mon, 27 Feb 2023 15:56:10 -0500
X-MC-Unique: TkE1EShvPHiZD6IrmKwWxg-1
Received: by mail-qt1-f170.google.com with SMTP id y10so3579327qtj.2
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 12:56:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=AW2JEf6jvay2HU8gPYuHWU/useyVGbK2YCSb3GASH7U=;
 b=dmRoEINspBh28QOz6AQ2iNgOT2Z9Q5RgpX2HGKm0Lc5WpB5a95GP23pwsUu5EoEjpJ
 daeD57OHG/raugw9+AfZa7Knj7fEys9wRf3RDgGh2LgiVt1gx3dau6dtDP3v/y3ma04H
 2yA3TuX1KZCljnD8F+aR1afjdm4zw9NiOmArCCAveledSiGKAz785MjEITEAQNbkeFCG
 y+RFNfwy3WsmFNtAdjuio/f9MZzRtSmsZUAENyJ76rkTUoL8aKYwtQOz0HwbmZ7n1OI8
 tbDxCvJUXJ1Z4MxDhIHyjM/jH1nlNeiiEHgWTcXy8zSXyIOxsAK0lYc+zB5QhIWT237x
 /p+g==
X-Gm-Message-State: AO0yUKX7PcAHMGVX/mAHxBJ0Okpizk5jpvCCWTUymerjYGEATw9lwSZa
 zNQpQo8yhOGsHgjerUyCPZ+oIwz+lrXN1fDgzQ==
X-Google-Smtp-Source: AK7set8YIHKDcPGLlL1oVyil5GeMstlHQusq255G0eAnGkVg+HCdkr0Fww4jgQNARzb0QnpV7OJSuw==
X-Received: by 2002:a05:622a:11d6:b0:3bf:d35d:98bb with SMTP id
 n22-20020a05622a11d600b003bfd35d98bbmr1104348qtk.56.1677531369830; 
 Mon, 27 Feb 2023 12:56:09 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 d13-20020ac84e2d000000b003bfbfd9a4aesm5145777qtw.56.2023.02.27.12.56.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Feb 2023 12:56:09 -0800 (PST)
Date: Mon, 27 Feb 2023 15:56:08 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: yangerkun <yangerkun@huaweicloud.com>
Message-ID: <Y/0Y6LyZqsNZhbo4@redhat.com>
References: <20230223031818.3713509-1-yangerkun@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20230223031818.3713509-1-yangerkun@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] dm-crypt: reexport sysfs of kcryptd workqueue
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
Cc: dm-devel@redhat.com, yangerkun@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 22 2023 at 10:18P -0500,
yangerkun <yangerkun@huaweicloud.com> wrote:

> From: yangerkun <yangerkun@huawei.com>
> 
> 'a2b8b2d97567 ("dm crypt: export sysfs of kcryptd workqueue")' give us
> idea to set specific CPU or limit max_active crypt work. However sysfs
> will report a warnning and fail 'cryptsetup refresh test' since the
> reload will alloc workqueue with same sysfs name, and we temporarily
> revert this feature to fix the problem.
> 
> What we actually should do is give a unique name once we try reload
> table, we can use ida now.

This header needs to be rewritten to deal directly with the fact:
1) Commit 48b0777cd93d (Revert "dm crypt: export sysfs of kcryptd
   workqueue") dealt with what you call "temporarily revert".
2) Great that you fixed it using IDA but you still haven't clearly
   explained the benefit of exposing this sysfs interface (please add
   details on which userspace is consuming it). I suppose you could
   explain by referring to commit a2b8b2d975673 (that was reverted)?

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

