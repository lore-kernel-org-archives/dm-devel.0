Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A40EEAA42
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 03:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694748856;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+oKTd2fx3I05+CSZSAzPIohYh69k8dEB6vV1HWr1+cQ=;
	b=gXJ/L2nJN38XY7vhnInRALlQC5GH+L4eUa+s8R55/RCItzFC9QhF/LWnwE8q+SV3+juDiz
	G+/iXoA7VKuqvQPwcLkdtjp19EPClWa6SA0EQNQ8HChuH7/QUqo1vEFL6HBTI/Afuh73KT
	IbVLGwzzqBAgDuIFaxpqxSBsXZ5gptM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-4TQLOpxnP56RSVNHVdzUhQ-1; Thu, 14 Sep 2023 23:34:13 -0400
X-MC-Unique: 4TQLOpxnP56RSVNHVdzUhQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4ECE90636A;
	Fri, 15 Sep 2023 03:34:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1291B40C6EA8;
	Fri, 15 Sep 2023 03:34:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A7DC0194658C;
	Fri, 15 Sep 2023 03:34:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 114621946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 03:34:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F17112026D68; Fri, 15 Sep 2023 03:34:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E9F172026D4B
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 03:34:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CACF288B7A1
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 03:34:04 +0000 (UTC)
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com
 [209.85.219.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-EtBW6rP7NmyXceqv4pZ6pw-1; Thu, 14 Sep 2023 23:34:02 -0400
X-MC-Unique: EtBW6rP7NmyXceqv4pZ6pw-1
Received: by mail-qv1-f45.google.com with SMTP id
 6a1803df08f44-65627d499e1so5678106d6.0
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 20:34:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694748842; x=1695353642;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=iaRpWeQBHF9xrScwEaYmj1hDO7gFWhFOcR6aMt6yIR4=;
 b=vAx97C9LAy9Yiv7n1Zu8EyMNmsjr95oRB17roh7sO4X2IkYz4C1xhPPNuOsZdkNWU7
 sHaS143MVF65UsQu1Mt6VeqBL8EyxaaXx4XzNclItZ9Be3GVZ6YGktddmJRnhQS+Lvtt
 bc2wVnfxvNtfiCrfR0qzpYnr/7GBl42MBxBVBxDU0Wp2SUUsEEXLNt1lWPO84jDR0xbW
 tsSpuw8It6LWZvOkbAeCWmITYkEdiCbqzBzKmOg8GEWSSXeDxKR4y0AWOmljaXdozpKw
 389kVfmuVxtE2E69JiCVyj8hwfaOOrqTIscM8mvKbCPzymQqz5sjcxl3cSz4rYEPXqWG
 mRsQ==
X-Gm-Message-State: AOJu0YyfZeA1j3xBhhN1QjUF1eT7dHQixA4Cyujz0vDY7+unqoi4dcGq
 5cCfHpaR2YXy8MNRZ/922G3AbmI=
X-Google-Smtp-Source: AGHT+IEBEYKRA2Zo7KXzkVVYdgYjkcKhhHD3gv62cQKEjoTRsB89tTRb5JOZnctFnGbpqENER6tIsg==
X-Received: by 2002:a0c:b4c9:0:b0:635:f899:660b with SMTP id
 h9-20020a0cb4c9000000b00635f899660bmr523466qvf.36.1694748842373; 
 Thu, 14 Sep 2023 20:34:02 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 e3-20020ad44183000000b0063d30c10f1esm781581qvp.70.2023.09.14.20.34.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 20:34:01 -0700 (PDT)
Date: Thu, 14 Sep 2023 23:34:00 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: kernel test robot <lkp@intel.com>
Message-ID: <ZQPQqCzlu3AUtumF@redhat.com>
References: <202309151023.QPBCNoCN-lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202309151023.QPBCNoCN-lkp@intel.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [device-mapper-dm:for-next 2/4]
 drivers/md/persistent-data/dm-extent-allocator.c:530:24: error: expected ';
 ' after expression
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
Cc: Joe Thornber <ejt@redhat.com>, llvm@lists.linux.dev, dm-devel@redhat.com,
 oe-kbuild-all@lists.linux.dev
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 14 2023 at 10:54P -0400,
kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   edcabec81f12dfc9b86b05084bba3232efdc5e4e
> commit: 59d814674dd66fc64ba229605174bfe0b8e566d5 [2/4] dm persistent data: Introduce extent allocator
> config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20230915/202309151023.QPBCNoCN-lkp@intel.com/config)
> compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230915/202309151023.QPBCNoCN-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202309151023.QPBCNoCN-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> drivers/md/persistent-data/dm-extent-allocator.c:530:24: error: expected ';' after expression
>            spin_unlock(&ea->lock)
>                                  ^
>                                  ;
>    drivers/md/persistent-data/dm-extent-allocator.c:544:24: error: expected ';' after expression
>            spin_unlock(&ea->lock)
>                                  ^
>                                  ;
>    2 errors generated.


These were my fault.. Fixed, sorry about the noise.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

