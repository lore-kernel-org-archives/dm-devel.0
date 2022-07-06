Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0505C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 15:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657120231;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OMFjOnMEHcthfjREcxwOKIztm4dBL18Zf42br5XOsng=;
	b=ikyBfFDl+O/7uoCJKnZaK5yr3V2JprBLLGy26o6KzDNBYQfAFMYx7lL41mgXHe2Ydadu2t
	223s8+lhQQO3RpKqnvgDlaN2oBPquLmYMipgyZjIbf7lpMmirau96Vm57cJsEoRTXdHwwf
	LEUuWDP0qUocZ2JULUiklbg0hyUY9OU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-0yiQwOjPOrqOTiuLfEY5kg-1; Wed, 06 Jul 2022 11:10:24 -0400
X-MC-Unique: 0yiQwOjPOrqOTiuLfEY5kg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF6751C08974;
	Wed,  6 Jul 2022 15:10:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C9A102024CB6;
	Wed,  6 Jul 2022 15:10:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 967511947063;
	Wed,  6 Jul 2022 15:10:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1A787194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 15:09:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EBA34400DB35; Wed,  6 Jul 2022 15:09:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E7BCA40CFD0A
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 15:09:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C280C101A59C
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 15:09:12 +0000 (UTC)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com
 [209.85.160.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-h9bl7TGWPAWSnJXGkSzkPg-1; Wed, 06 Jul 2022 11:09:11 -0400
X-MC-Unique: h9bl7TGWPAWSnJXGkSzkPg-1
Received: by mail-qt1-f177.google.com with SMTP id i11so18608098qtr.4
 for <dm-devel@redhat.com>; Wed, 06 Jul 2022 08:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Tsz2MOLF2Bl4qmuGvjK22N+/EXyHNeIKMYNiVvkEHV8=;
 b=7vdnV2fj30HcNYva2pMmor6OETQ/wPoUyPBM8xN8pw80dcn9MxUqKHTdgsv+SK+h+3
 mLgk6OANoOuCygDmobXrC866dfbMyjv+MBAYbytr5uIbliRC1zux6Y/2XlN7w5QnZhSO
 tiHPbvKM8VLU6DOVTQzLb09vLG5bsya9cuO1IZE9n2d+Klccuyu0mq+SAKKaxJ6dkzga
 IrQ2pYdnsM7C51lzSkjceU5Tsl3Ekqop08XC69zl7pQUh4erClqo3SJGYMc2vMwiVtnM
 GBTBYI2BabHRYAqmTaHqmY/Aq04JNGwnE2yoU67hD38hVj92PIblSH75V/nNnyBC5hu5
 3sHQ==
X-Gm-Message-State: AJIora8JiJNy6Ygx470lXX8U+vpWLrCtluYTzyJCvjZUoFwXOIX8ukdb
 0Bsg0hlmNMvuyJCO8eW/aA3cgic=
X-Google-Smtp-Source: AGRyM1t5PF0DSFrQbt4bi5LBPcIBQxZL7P89Hk2jkSRxl7RATw5BhQNCdgNUDq/Dg1qVd17q5SsXwQ==
X-Received: by 2002:a05:622a:110b:b0:31d:3958:e6e9 with SMTP id
 e11-20020a05622a110b00b0031d3958e6e9mr22319256qty.660.1657120150141; 
 Wed, 06 Jul 2022 08:09:10 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 u16-20020a05620a431000b006a7284e5741sm30587670qko.54.2022.07.06.08.09.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Jul 2022 08:09:09 -0700 (PDT)
Date: Wed, 6 Jul 2022 11:09:08 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <YsWllA0uZadrrXut@redhat.com>
References: <20220627153526.3750341-1-mka@chromium.org>
 <20220627083512.v7.3.I5aca2dcc3b06de4bf53696cd21329dce8272b8aa@changeid>
MIME-Version: 1.0
In-Reply-To: <20220627083512.v7.3.I5aca2dcc3b06de4bf53696cd21329dce8272b8aa@changeid>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v7 3/3] dm: verity-loadpin: Use
 CONFIG_SECURITY_LOADPIN_VERITY for conditional compilation
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, Kees Cook <keescook@chromium.org>,
 linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
 "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jun 27 2022 at 11:35P -0400,
Matthias Kaehlcke <mka@chromium.org> wrote:

> The verity glue for LoadPin is only needed when CONFIG_SECURITY_LOADPIN_VERITY
> is set, use this option for conditional compilation instead of the combo of
> CONFIG_DM_VERITY and CONFIG_SECURITY_LOADPIN.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> Acked-by: Kees Cook <keescook@chromium.org>

Acked-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

