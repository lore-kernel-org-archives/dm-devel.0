Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D6A7C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 18 Oct 2022 22:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666132016;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hGYIS6NSuUMg7UiI8mWorRjJx6yh89fcj7f+eZkd5Ks=;
	b=QH2cAa25yLmd+j2U6B5Ps+zDbO5CCD4+QcJAidZEFRTFiaIEV/Yfi7UxCMHWHPFm4wzmAD
	IyoGzk0UczTijCrrONPVeMk2F+2zFKLKu8cxUm9PNd5JePVCWMpNG8f7oBjKGwGLL318IU
	gt7bcE8cZJlHp29yh+tA/bayjoTzpAw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-X_s3_JzoPDiEMwrq2VDaeQ-1; Tue, 18 Oct 2022 18:26:53 -0400
X-MC-Unique: X_s3_JzoPDiEMwrq2VDaeQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4293A29DD994;
	Tue, 18 Oct 2022 22:26:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 507D72166B41;
	Tue, 18 Oct 2022 22:26:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C10C51946594;
	Tue, 18 Oct 2022 22:26:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 005F4194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 22:26:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D64FE40E290C; Tue, 18 Oct 2022 22:26:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CEE2C40E290B
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 22:26:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8CCA857F8F
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 22:26:40 +0000 (UTC)
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com
 [209.85.219.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-644-qlpBkD3hPJaojykpDdARnw-1; Tue, 18 Oct 2022 18:26:38 -0400
X-MC-Unique: qlpBkD3hPJaojykpDdARnw-1
Received: by mail-qv1-f51.google.com with SMTP id g9so10233327qvo.12
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 15:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=B1l2vnLm/0Lgbz9B99VIiD/UIQurnKKZZ/zYmbgiPeE=;
 b=lVPyMHql2F39xYEGVRYNmn8MNfe9SAEARxEotJcRFDFobbQkejjEVc9EAn0LbjpDPM
 qqKq5rlyzwwFaYoETr75jHABsDIj6HqhR1eLN0BNuUZEDXWfARuxO6MXtC/yyPr1yHjI
 Jghc694GMIY05pI5cQF6DJ6oy9wPxNsdN3wBwsitKJXUVFRqT7ZdC+w+VaTRE2td2sDt
 dWJe+LVomPRJp3qQyucY2LnLEJ8PUCfSBM5eKumh/Zp8HNCCmn4NVsBkzA8/TJteTiHZ
 GSZ8IjP8xgUMPAflF9JeW9tNQkN7LqalEYyZJ9XPAcBUFJew7Efe+FYI5kH9pg0jf/qU
 +wdw==
X-Gm-Message-State: ACrzQf1WY13t/EipC/6DbJiFTRsDCFr1L4Omov2BeTTS9oIPmZv1l9lT
 AzT1xtUQH2GVCebozjDll0WUvKH2wKOSow==
X-Google-Smtp-Source: AMsMyM4uR5mQYlR435JmcuH8oYKvQSf+GY+zpUDkQAPY/Mth1fVI1VBPl62yXYd8N4i5cGfZX+1pXQ==
X-Received: by 2002:a0c:aacd:0:b0:4ad:fe0:4e84 with SMTP id
 g13-20020a0caacd000000b004ad0fe04e84mr4293087qvb.8.1666131998079; 
 Tue, 18 Oct 2022 15:26:38 -0700 (PDT)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com.
 [209.85.128.182]) by smtp.gmail.com with ESMTPSA id
 s7-20020a05620a254700b006af0ce13499sm3357143qko.115.2022.10.18.15.26.37
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 18 Oct 2022 15:26:37 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id
 00721157ae682-360871745b0so151229367b3.3
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 15:26:37 -0700 (PDT)
X-Received: by 2002:a81:2544:0:b0:360:c270:15a1 with SMTP id
 l65-20020a812544000000b00360c27015a1mr4162300ywl.67.1666131513519; Tue, 18
 Oct 2022 15:18:33 -0700 (PDT)
MIME-Version: 1.0
References: <Y07SYs98z5VNxdZq@redhat.com> <Y07twbDIVgEnPsFn@infradead.org>
 <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
 <CAHk-=wiE_p66JtpfsM2GMk0ctuLcP+HBuNOEnpZRY0Ees8oFXw@mail.gmail.com>
 <Y08W5Tj1YC8/BZDM@redhat.com> <b9608b92-fab8-93a0-2821-80a49c3328eb@gmail.com>
In-Reply-To: <b9608b92-fab8-93a0-2821-80a49c3328eb@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Oct 2022 15:18:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wje72wCLtizgPoae=yZf-n0p9dbZe+gxFqa3Cu=i6Bk6w@mail.gmail.com>
Message-ID: <CAHk-=wje72wCLtizgPoae=yZf-n0p9dbZe+gxFqa3Cu=i6Bk6w@mail.gmail.com>
To: Milan Broz <gmazyland@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [git pull] device mapper changes for 6.1
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
Cc: linux-block@vger.kernel.org, Shaomin Deng <dengshaomin@cdjrlc.com>,
 Nikos Tsironis <ntsironis@arrikto.com>, Mike Snitzer <snitzer@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Nathan Huckleberry <nhuck@google.com>,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Genjian Zhang <zhanggenjian@kylinos.cn>,
 Jilin Yuan <yuanjilin@cdjrlc.com>, Alasdair G Kergon <agk@redhat.com>,
 Jiangshan Yi <yijiangshan@kylinos.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 18, 2022 at 3:11 PM Milan Broz <gmazyland@gmail.com> wrote:
>
> The problem is that ioctl() are often just translated to -EINVAL.

Oh, that's absolutely a real problem.

Don't use one single error number.

           Linus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

