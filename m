Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CAFCC0015E
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 18:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690481790;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=iM11O9VJwQNcaeGTDk8f4J5qwAEwxb2M7t4p57oWUUM=;
	b=MTjNlOt1+ZEexpxS/OqDFP7dsWeWhKosFJXcxEB68JVPrabcfzPJotHPQGS8MFTBVxDAfI
	g/Q1gIRMQKQHU7jjuArHomAD4K1vnH2KNjCWQrPAY0vXZ8dT14shTkLPxgVZfZoEHiGZzP
	GCYWunrNGC47K+3MdflA2VzhRLwV5V4=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-w_BC6PI5NBK7I6pGrqIGbA-1; Thu, 27 Jul 2023 14:16:28 -0400
X-MC-Unique: w_BC6PI5NBK7I6pGrqIGbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7907238117F1;
	Thu, 27 Jul 2023 18:16:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0BBBFC57964;
	Thu, 27 Jul 2023 18:16:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C02791946A72;
	Thu, 27 Jul 2023 18:16:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CC9461946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 18:16:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A6B81201F11C; Thu, 27 Jul 2023 18:16:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EE55200B409
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 18:16:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AD32185A793
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 18:16:17 +0000 (UTC)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-oHziMJnHOzW2kjf83klDpQ-1; Thu, 27 Jul 2023 14:16:15 -0400
X-MC-Unique: oHziMJnHOzW2kjf83klDpQ-1
Received: by mail-ed1-f71.google.com with SMTP id
 4fb4d7f45d1cf-51da39aa6dcso751351a12.2
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 11:16:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690481773; x=1691086573;
 h=to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=XBmzlijPeZjOfn9iskKxDWi7M9o3Nkol7WdaRebzG48=;
 b=SjDU4jF/Vbr3vCEb0Tewt9VQYe62GkshQZxbpJS7Pk0X0Vg819JJ6co/uru0o8FgCr
 cq4ojh8Ra64nyRr60XbgIvFO4H9m5pGIGy1ykY66CMgv0/EX2YBJfHuxb61n7UFDJxUw
 u4BqCThPFJ2bs2YV+j7nQZzIVYfWAFLi8MTGQ4cMhipsNoXlC+clpbRe0cY+Cti+yVe4
 cYPf566OJ76PVeIdsqx7mco/qYnNmAH4Xhisu2VYfEql69lTlTxKvqEbRUaQ4lnFB8Kc
 QRqC1zTnprvqE+YtEyUI7lybQGl+o4V7PhyQN2NWbvE2qbOLL+PX5cZXBZoN7PgBxMk1
 l03A==
X-Gm-Message-State: ABy/qLYR9bbgf9La3NQnykbyOyFbFR67hJw2dgZFkmfDutQfw1/sYkpB
 +xkZ/uzAmdpY98Q6A8rKYER5flNQJLMz/lVfcnmLEQZKaMMErDi5qnxy1BKtADLu9eMqb8BmtFl
 mW6iKtAsyzHOo2ZP4//Gy+JYsZWyPZrbOoLBQe+8=
X-Received: by 2002:a05:6402:7d2:b0:522:57f3:fb40 with SMTP id
 u18-20020a05640207d200b0052257f3fb40mr2359115edy.18.1690481773481; 
 Thu, 27 Jul 2023 11:16:13 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGnox+Wvn46NlHGYziOkor9tIX1aiRg/tqCZOe1tsoVrc5tNcQ5ZtHGpavYQKleBwOHtUFIEOPlOofqx0Hevjw=
X-Received: by 2002:a05:6402:7d2:b0:522:57f3:fb40 with SMTP id
 u18-20020a05640207d200b0052257f3fb40mr2359111edy.18.1690481773231; Thu, 27
 Jul 2023 11:16:13 -0700 (PDT)
MIME-Version: 1.0
From: Jonathan Brassow <jbrassow@redhat.com>
Date: Thu, 27 Jul 2023 13:16:02 -0500
Message-ID: <CAOP-y9EQ1BjyjUEbHZBGzZ88XN=2E9cnQ1CsZMZwDqKOsfVGfA@mail.gmail.com>
To: dm-devel@redhat.com
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] test message
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============0477909022643097496=="

--===============0477909022643097496==
Content-Type: multipart/alternative; boundary="00000000000097dd3b06017bf5e4"

--00000000000097dd3b06017bf5e4
Content-Type: text/plain; charset="UTF-8"

please ignore

 brassow

--00000000000097dd3b06017bf5e4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">please ignore<div><br></div><div>=C2=A0brassow</div><div><=
br></div></div>

--00000000000097dd3b06017bf5e4--

--===============0477909022643097496==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============0477909022643097496==--

