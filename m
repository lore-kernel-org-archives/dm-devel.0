Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F2BEC7EE2E
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 06:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685945052;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CkpQYg4i8yQA+lG5eWytPyp55Ibmww3a+ETYYP9rYIg=;
	b=QzQv8eRenQ5Y2SIi65MqD2El50gFo3+8ruUgILe/OjEOkIiX02s8OJMbeBevOWdWlg1NS7
	wh+wxBm/3q4vpd2bXOf/7mYUbj7likut1loSj/OLWfUcCRXKMTFhgV6caHG20+g6f2IbHh
	S0sFpknyepotA1MI5DMl51kKKUynLx8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-QO9TtkRhOhOV89MR5nkkoQ-1; Mon, 05 Jun 2023 02:04:08 -0400
X-MC-Unique: QO9TtkRhOhOV89MR5nkkoQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE65A3C0026A;
	Mon,  5 Jun 2023 06:04:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4A3A840C6EC4;
	Mon,  5 Jun 2023 06:04:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D9FB19465A0;
	Mon,  5 Jun 2023 06:04:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 054791946595
 for <dm-devel@listman.corp.redhat.com>; Sun,  4 Jun 2023 14:07:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A386B400F16; Sun,  4 Jun 2023 14:07:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B7EE492B00
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 14:07:45 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B6BF1C060D1
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 14:07:45 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-aeg2QjswP_KIzfctZhlfww-1; Sun, 04 Jun 2023 10:07:43 -0400
X-MC-Unique: aeg2QjswP_KIzfctZhlfww-1
Received: by mail-pl1-f173.google.com with SMTP id
 d9443c01a7336-1b04949e4e9so17719015ad.3; 
 Sun, 04 Jun 2023 07:07:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685887662; x=1688479662;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=pkEw/KYBvgWhOLNM0awAyhWUoE1Lxhm/fdFvbR4InGY=;
 b=efmaYrJDp/KiZIHEQrLOr8rKWwYuzbNfb/VBwzzY2AHU2maSOHoQ4JGR8Yb1UhMTnl
 oNvii2iYlQ4nbrGwT3IBJZ2zHDjEiFQ2Z2VHK8/+Gz6FvO2QD/313rsBLtE8aFtXlnWm
 h59pe91k0XMdgqdD04ZdhmmKNy0ErHZ+vzpFmEKopTJXyCpUf+nm3vKDFIZN8AezCLRm
 SC3l6wlOGtQHI+pMn+DuRdHByYz2xMRlasIig8l2YXabaxfcbbtd7mnKgDzptGy2m+wG
 QT5n1z0Yg3qrEuU2JuqxW3xBiYO+rOecIx4O2+3zA2fjV2smsD26FXnMHTpD/dyB7ZVA
 yczA==
X-Gm-Message-State: AC+VfDySusodtaWAoEz1bUPIyzkNO5SrPW4xLyVyd6Eu/uIUKT3+xwml
 Lg60zm0NexEYR0HB7olP5wA=
X-Google-Smtp-Source: ACHHUZ4m/5ASswOxVbMqoY93tfCOr0cytCR0d/Pt7IDfBW5yo80YfeKXNMg1Bi3YljOor5oTesOIew==
X-Received: by 2002:a17:903:2602:b0:1af:b049:b32e with SMTP id
 jd2-20020a170903260200b001afb049b32emr1855563plb.56.1685887661830; 
 Sun, 04 Jun 2023 07:07:41 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-54.three.co.id.
 [116.206.12.54]) by smtp.gmail.com with ESMTPSA id
 q3-20020a17090311c300b001b0f727bc44sm4703578plh.16.2023.06.04.07.07.39
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 04 Jun 2023 07:07:41 -0700 (PDT)
Message-ID: <65b7bc64-4a4b-c056-db65-cd77bcc3d1d9@gmail.com>
Date: Sun, 4 Jun 2023 21:07:38 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
To: Russell Harmon <eatnumber1@gmail.com>
References: <ZHs2BHGBrJ-YGd-v@debian.me>
 <20230603201525.9409-1-eatnumber1@gmail.com>
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20230603201525.9409-1-eatnumber1@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 05 Jun 2023 06:04:03 +0000
Subject: Re: [dm-devel] [PATCH] Improve the dm-integrity documentation.
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com,
 linux-doc@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/4/23 03:15, Russell Harmon wrote:
> Thanks for taking a look. Here's the multi-patch series plus the changes
> you suggested.
> 
> 

This is v2, right? Next reroll, remember to version your patches
(pass -v to git-format-patch(1)).

Also, I don't see description (that would be commit message
once applied by jon) in all patches on this series. I hope you
have a time reading Documentation/process/submitting-patches.rst
so that trivial mistakes like this shouldn't happen again. In
any case, when preparing patch series, always add cover letter
by passing --cover-letter to git-format-patch(1) then edit the
generated template (look for 0000-*-cover-letter.patch).

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

