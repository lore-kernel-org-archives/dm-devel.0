Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03098C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 07:57:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9254F61052
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 07:57:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9254F61052
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-jctyU29OP6SC64HMTogCaw-1; Thu, 29 Jul 2021 03:57:21 -0400
X-MC-Unique: jctyU29OP6SC64HMTogCaw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B5CC101C8A9;
	Thu, 29 Jul 2021 07:57:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 424B519C79;
	Thu, 29 Jul 2021 07:57:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5F0634BB7C;
	Thu, 29 Jul 2021 07:57:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16T7oBSS015574 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 03:50:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D0608111287C; Thu, 29 Jul 2021 07:50:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBE1B111287A
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 07:50:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F4478CA940
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 07:50:08 +0000 (UTC)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
	[209.85.128.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-159-QvbbvFAwNtCB_j453edBRA-1; Thu, 29 Jul 2021 03:50:05 -0400
X-MC-Unique: QvbbvFAwNtCB_j453edBRA-1
Received: by mail-wm1-f46.google.com with SMTP id k4so3088461wms.3;
	Thu, 29 Jul 2021 00:50:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=udUb3L8Bif4FLui4619O9MaK2lof2JoopjmyT+I1elI=;
	b=jKtZNLUBo7oEuzvQPZ2xgn8xPTvQQIFr2S44qgUr94FAWOcV0Yggk0dLJxLBLBLA8g
	EYKLs1vPkwQ4jtuJeAZEZ9qbFqcCgDEKhleXFD19gjq4/Xs9oPa2xgjKT0ZNf5cXYt9q
	43G19W4EQh+nJwcSr7LNcYx4pHo6I16mCbVnZ9RilwdpEkkMA/UEZjtSho4xePBIHrHB
	+NH73GyQwWrxK+H2ZkHYkJ4fuPtGL56hF2C3UBodGeXqooYObfL7Q7fLEFrMYny46Iu2
	9J+zLnNwCdgUaHKhkU5pQT40PokYtrw1nvAq1sYj2LnuTpN/cuaFG6xjlTU9xjIYJdWt
	EHfA==
X-Gm-Message-State: AOAM532JQhOKi89+V+aB8glKD2+LE6Ib+j29XBfqphS3FhKrtuDNgYpc
	h4eXIyA9H3zxsOZYiPRqAEdE0QqMZjE=
X-Google-Smtp-Source: ABdhPJyaIq8e9VQSmaYYwVo045uqXv5SeZPkxkRxeuEE9SyU02Zo9KPSdAZRKPt9b4eoJTXU1npvmQ==
X-Received: by 2002:a05:600c:4f86:: with SMTP id
	n6mr7183657wmq.60.1627545003895; 
	Thu, 29 Jul 2021 00:50:03 -0700 (PDT)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id
	l41sm2533846wmp.23.2021.07.29.00.50.02
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 29 Jul 2021 00:50:03 -0700 (PDT)
To: Mike Snitzer <snitzer@redhat.com>
References: <20210725055458.29008-1-hch@lst.de> <YQAtNkd8T1w/cSLc@redhat.com>
	<20210727160226.GA17989@lst.de> <YQAxyjrGJpl7UkNG@redhat.com>
	<9c719e1d-f8da-f1f3-57a9-3802aa1312d4@gmail.com>
	<YQGDLIbefYvSHJqi@redhat.com>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <96450487-a95e-85f2-3721-181125825bab@gmail.com>
Date: Thu, 29 Jul 2021 09:50:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQGDLIbefYvSHJqi@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] use regular gendisk registration in device mapper
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 28/07/2021 18:17, Mike Snitzer wrote:
> On Tue, Jul 27 2021 at  4:38P -0400,
...
 
> Once I installed all deps, I got all but one passing with Christoph's changes:
> 
> Block_size: 512, Data_size: 256000B, FEC_roots: 9, Corrupted_bytes: 4 [no-superblock][one_device_test]Usage: lt-veritysetup [-?Vv] [-?|--help] [--usage] [-V|--version]
>         [--cancel-deferred] [--check-at-most-once] [--data-block-size=bytes]
>         [--data-blocks=blocks] [--debug] [--deferred] [--fec-device=path]
>         [--fec-offset=bytes] [--fec-roots=bytes] [--format=number]
>         [-h|--hash string] [--hash-block-size=bytes] [--hash-offset=bytes]
>         [--ignore-corruption] [--ignore-zero-blocks] [--no-superblock]
>         [--panic-on-corruption] [--restart-on-corruption]
>         [--root-hash-file=STRING] [--root-hash-signature=STRING]
>         [-s|--salt hex string] [--uuid=STRING] [-v|--verbose]
>         [OPTION...] <action> <action-specific>
> -s=e48da609055204e89ae53b655ca2216dd983cf3cb829f34f63a297d106d53e2d: unknown option
> [N/A, test skipped]
> FEC repair failed
> FAILED backtrace:
> 500 ./verity-compat-test
> FAIL: verity-compat-test
> 
> Seems like a test bug.

This is a bug in RHEL7 libpopt where -s=XXX is invalid syntax (works in recent distros), fixed in testsuite just by using the long option.
(Released RHEL7 kernel does not support verity FEC so it never hits this code without recompiling own kernel.)

Thanks for the report!

Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

