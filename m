Return-Path: <SRS0=/efG=IB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7B0C433E0
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 01:24:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BFE9564FB8
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 01:24:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFE9564FB8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-CAmMs8btOmqmD3Ox9XKuuw-1; Tue, 02 Mar 2021 20:24:26 -0500
X-MC-Unique: CAmMs8btOmqmD3Ox9XKuuw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8416100CCC6;
	Wed,  3 Mar 2021 01:24:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EEAFB10023AD;
	Wed,  3 Mar 2021 01:24:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1ECF718095CB;
	Wed,  3 Mar 2021 01:24:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1231OCZs026596 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 20:24:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 875F411EB17; Wed,  3 Mar 2021 01:24:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8158C11FC8D
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 01:24:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B27191871BF3
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 01:24:09 +0000 (UTC)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
	[209.85.221.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-489-JgTsrLZwO8KxWT0ck1K2dg-1; Tue, 02 Mar 2021 20:24:07 -0500
X-MC-Unique: JgTsrLZwO8KxWT0ck1K2dg-1
Received: by mail-wr1-f41.google.com with SMTP id d11so21834531wrj.7
	for <dm-devel@redhat.com>; Tue, 02 Mar 2021 17:24:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:references:from:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=j+TskAmxVvB6XS/wZqmaLwtizhGj4SCvwaNpjLgPyEE=;
	b=g50NqPuT1JEkYIryH5qmNGoeRoQKiNNMsWI+6GoFyoJtQTbufRnUrd/nxcwn2tRtcR
	WAx/+MIujK/iNOuF0oxkp8qZmHWHT8WAJXmJQxQfKUoX+whSy1mpd8JPPUsKlWRuGPXU
	z78IdqOvJH5bX8pNAyiJL0yJXU2QMsHxa6wbmf+ys0+/sv8suQHsZnwZrdAXQJrQcu8Q
	FWUhVgFvVN99/gaAaQrh8n2sdJMxqv3RWdtHjGGk7QxkE4V0X6QYpYABN3feu38F4ovH
	Q5BuNTOgDrJqHV7BqALDBaIztn3FZLlVz8MAjKxBBoF0/uoytbjN2V1U1FQ49C8MbYti
	pwBA==
X-Gm-Message-State: AOAM531xUBrY5VupnQ5sI5v6N/+YszA8uBZPhjsSO9TSu2lQokfTuyew
	KZy7WT9BKDGGqrHKUX/FOuorNwhY+Q==
X-Google-Smtp-Source: ABdhPJybwxvpiDLNdXCquMpOqtHOMrPM2ffP9nJUSBjgJvTgsurYI74a4JMtw3oYkhpuQ6gTpISc8Q==
X-Received: by 2002:adf:dc91:: with SMTP id r17mr21102882wrj.293.1614734646463;
	Tue, 02 Mar 2021 17:24:06 -0800 (PST)
Received: from localhost (157.red-83-38-167.dynamicip.rima-tde.net.
	[83.38.167.157]) by smtp.gmail.com with ESMTPSA id
	u3sm13472449wrt.82.2021.03.02.17.24.05
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 02 Mar 2021 17:24:06 -0800 (PST)
To: Benoit Chatelain <bchatelain@cines.fr>, DM-DEVEL ML <dm-devel@redhat.com>
References: <388321540.261431070.1614606275832.JavaMail.zimbra@cines.fr>
	<e8c80d5b-419e-2799-072e-4a2e91940838@gmail.com>
	<668683972.267173179.1614699701122.JavaMail.zimbra@cines.fr>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <8506a3a7-ccb4-59f5-2575-2b631d7e6117@gmail.com>
Date: Wed, 3 Mar 2021 02:24:04 +0100
MIME-Version: 1.0
In-Reply-To: <668683972.267173179.1614699701122.JavaMail.zimbra@cines.fr>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] multipath with SAS and FC.
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/2/21 4:41 PM, bchatelain@cines.fr wrote:

> It's work good.
> 
> I have add this line to device in multipath.conf :
>    path_grouping_policy "group_by_prio

That's not enough to run properly in active/passive mode with ALUA.
Mainly, because the default value of failback is "manual".

This is a minimal config to work flawlessly:
devices {
	device {
		vendor "COMPELNT"
		product "Compellent Vol"
		path_grouping_policy "group_by_prio"
		prio "alua"
		failback "immediate"
		no_path_retry 30
	}
}

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

