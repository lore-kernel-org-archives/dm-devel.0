Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D021CC77B7C
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 06:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683614003;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NB1AZF7aPr1cELlTVh9AVsj/8rxheYNW6UaOEytSpCA=;
	b=Fo4xSW592dbe5Z8ORod0nL9JT/0tNnambbkTJtV+X0Qkc3FqAlPHyj/2lrRgi/6r5rrq5o
	SE61b4FmhYtxXF2RXWCOddJbIBHMQQMg/SG28vzLkEoiKt3cPwtfHi9fFQPz5xmUeg0mvr
	6BgdysABkSstfr01HTOxgb7Z1MeayAw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-oCPwq0TpNHqovMjcsSCM9Q-1; Tue, 09 May 2023 02:33:20 -0400
X-MC-Unique: oCPwq0TpNHqovMjcsSCM9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 244B2884627;
	Tue,  9 May 2023 06:33:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF610C16026;
	Tue,  9 May 2023 06:33:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 885B619452C5;
	Tue,  9 May 2023 06:33:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B547C19452C5
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 May 2023 06:33:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9781FC15BA0; Tue,  9 May 2023 06:33:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D572C16026
 for <dm-devel@redhat.com>; Tue,  9 May 2023 06:33:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 722D685A5A3
 for <dm-devel@redhat.com>; Tue,  9 May 2023 06:33:15 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-ntgkZ21_PdidpYQv92HzkQ-1; Tue, 09 May 2023 02:33:11 -0400
X-MC-Unique: ntgkZ21_PdidpYQv92HzkQ-1
Received: by mail-qv1-f72.google.com with SMTP id
 6a1803df08f44-61b7884e391so62478016d6.3
 for <dm-devel@redhat.com>; Mon, 08 May 2023 23:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683613991; x=1686205991;
 h=content-transfer-encoding:in-reply-to:from:cc:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=/p29a3jU9JdsGK+jRm1PlnpUc4nPIekff1IWLWwyo7I=;
 b=f4ItRVZ551nDnWEUeYWNg0Fq7Hvt8OkdiuF9Tz4k7Tl6dcNCmgSr+T0XKVovtBgpCf
 7p1e+I172sn4WRJsKJXxXCXy4/GM1zvYKFWAxDFaaieFhV/cGNdk7Wkjc5BCLFf8Hmuw
 ZTFRNoz9xWFsk3DId60CocV5sKMvFVsBdVUfpiBAPTIg4p//MjzKuJFpEmiChG4UrI2r
 w9TmNkmfaQhnX3d5vat236xGk8F7yEqawV67JXqFss7WWbhpX1bSFr/P3Ooubn6WTLkT
 tj3Pya6MHg2IPqU67RP6LDzPUl13z0odwhSHvUM6FDTM7/RbPYhYHi8biPMVmHl0LOu5
 Vj3A==
X-Gm-Message-State: AC+VfDySxwwYIONjkVZo8ch0Z/yN50R4k+psX6VlzR3eXgsk4dz8Ssmq
 Yms9E7622EzkOuhpd/aRs0NHr66tb+mWhASw2X7nDWQKyNcDN8DlvCtz9H5FNIT/ALpyIJEbUo6
 Zp6V3S8FWprA5LS29oteXAlx8WoSD1qor5M6EtFrgPA2K/ghtLTG901eWxcov4jhe5JExfqDYjI
 I=
X-Received: by 2002:ad4:5cae:0:b0:61b:5dd6:1f26 with SMTP id
 q14-20020ad45cae000000b0061b5dd61f26mr18526776qvh.28.1683613991142; 
 Mon, 08 May 2023 23:33:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6XTJDHYYoXNMwBQKCiFZQoIaDirG8uP4BdmF62WfXy4/6qETYvr6Rz9yzJR49oV0rV3PZ+CQ==
X-Received: by 2002:ad4:5cae:0:b0:61b:5dd6:1f26 with SMTP id
 q14-20020ad45cae000000b0061b5dd61f26mr18526762qvh.28.1683613990858; 
 Mon, 08 May 2023 23:33:10 -0700 (PDT)
Received: from [172.16.2.39]
 (173-166-2-198-newengland.hfc.comcastbusiness.net. [173.166.2.198])
 by smtp.gmail.com with ESMTPSA id
 nd2-20020a056214420200b0061b5b399d1csm533820qvb.104.2023.05.08.23.33.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 08 May 2023 23:33:10 -0700 (PDT)
Message-ID: <e6deef8f-4e0e-3b62-b7c7-1a85dc10f0d5@redhat.com>
Date: Tue, 9 May 2023 02:33:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
To: dm-devel@redhat.com, linux-block@vger.kernel.org
References: <20230509010545.72448-1-corwin@redhat.com>
From: corwin <corwin@redhat.com>
In-Reply-To: <20230509010545.72448-1-corwin@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 0/5] Add the dm-vdo deduplication and
 compression device mapper target.
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
Cc: "vdo-devel@redhat.com" <vdo-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

It seems that two of the patches in this set are too large as they 
stand. We will divide them up and resubmit a new version,

Thank you for your understanding and forbearance,

corwin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

