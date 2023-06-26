Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52152C04E69
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971633;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uQcAozqCL+8UbhuIJ0u8LZD1YXhFD9KBlH9FV0dIjks=;
	b=XvE87kKDdsOOqIHe5CIRRvph+C5j2cqtW/T5FEky/qvai8UCXA6xOT/7yTDFlndZ0/qdap
	FYwHZpajqPWcsMyh+2JIykJB/A9+umze0z+fyjDZGxacURdZiOLs1hhSoPuscL6KoICJMc
	TRnaQ7xcETgjVS04s0ziBRnEmsHX5pU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-7MfFV1k1PP-a3QqGE-wRMw-1; Mon, 10 Jul 2023 02:47:11 -0400
X-MC-Unique: 7MfFV1k1PP-a3QqGE-wRMw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CCC63815EE7;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7903B492B01;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 561241949748;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C4AEC1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 15:20:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AC1FF40C2071; Mon, 26 Jun 2023 15:20:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A49C640C2063
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 15:20:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BCDD3802263
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 15:20:02 +0000 (UTC)
Received: from mout.web.de (mout.web.de [212.227.15.14]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-357-jg9Jk_cOOpuiNIwq8xq5Tw-1; Mon,
 26 Jun 2023 11:20:00 -0400
X-MC-Unique: jg9Jk_cOOpuiNIwq8xq5Tw-1
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.83]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N01di-1ptP2L0xj4-00wxYP; Mon, 26
 Jun 2023 17:19:55 +0200
Message-ID: <70bb2301-6120-a374-6103-f8d1a4c68631@web.de>
Date: Mon, 26 Jun 2023 17:19:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: Dan Carpenter <dan.carpenter@linaro.org>
References: <20230624230950.2272-3-demi@invisiblethingslab.com>
 <3241078c-2318-fe1b-33cc-7c33db71b1a6@web.de> <ZJh73z2CsgHEJ4iv@itl-email>
 <e42e8115-6f75-447e-9955-ca4ad43ed406@kadam.mountain>
 <c1b84520-94d2-2c5c-6eed-2a0697c086a4@web.de>
 <79fdecc7-138f-476f-bc40-3603aac408ad@kadam.mountain>
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <79fdecc7-138f-476f-bc40-3603aac408ad@kadam.mountain>
X-Provags-ID: V03:K1:RvYo1RbYdvVSMn/vSNZFVdcN29J2r4+0g+y0MedYQjPfI4M8G4b
 oyg43fNQ2cEmhSbNOHj52OpJQavxVVX34ywY4DrmclkNO3pdXNCMYkH7RTb5tTh0itChEpl
 cqpfV7x7Nw+SjJ15y/R+4d+bnLFhFzktz+pGvmL8eh4EP+4XYblABqoaHbfZRUlcWJkAHrO
 73Y0r+BbJpxGGo0eyLa0g==
UI-OutboundReport: notjunk:1;M01:P0:NJWg+wZAZbw=;98/grzqENcdBtmMCAmkM5k3Zal1
 ZRJy9Cl1lUHivxASqJBWd/Umuxe8FhJHGDoCpcISKFl+qyMa/Pd/R+0LHRNoFC57e6SIeaDcS
 hQMDlMHPBmiW6Mh76+KfeLlnkGmYUOthIj4du7NsgSHlOmkN+3zizF/rCpJd5F0kmZnWlcwwK
 //iFLnWmdzyRml8L8reXt1o3nvXJsaxVcL67ede4vEuqXekvDIS+LOWpZ5yckJc3E5vdMoq6H
 kSD1g3cPcn9OPv0IQTcrGwWrNCYYCjeL4AmjFJIDjaPPrO32uMY5vhlHX79qk3BDZZ64HRYMF
 DKKhv6b2JS4GlpmsfcPXWpo0zNpB28EAvfAdX3mBW390CAk2hclQE7uL4mUVkRPpVxUNKSCSs
 tJbapUr6Q9Bti/jWHS1i15F8iF7xZnlQQNEAchmq81lg77KNzl0asyrI9BLVgE0hcaAQtUTEc
 Bb6kScGeVqkDni2flEeW4NI8OH57CkVTujVPOpU+ql1djRzdIcNf96/TuFpgMR6Xnwlkl/5gq
 4j4eALnoGdkq3cBh7lINn54S3b54ZPBbxl444LxKmM7YXIYrejU1+JAokJQCLGcYp7BdZi1qH
 SZk3JsBSZEwYh/Kdr8y+WCjrL9nocaJBLP0e7cYIDzCKomoR5dK+USFcnssF78H+g9zE83Zvc
 NdudN8XhNjuIFJsZ6t8UdkW23ClTNhhO3FhytFx11eIqUyIZ8boxaTSlUJUAZtLtwKi9GoB48
 sevzIoWZ35RADYZRw7Uewf2B0DvXrvevFfmJ9pkSyQe69j6RZytfVRawibKjCX4gFFAQuiOrS
 jGP/296FxtzmIeQTPxn66HBWbJYYKDj350sX6NsQBhA/TZPpEBy0sPYdw3SEjyefsKvPt3Eke
 vG/TJtZMuTb816Eu91RQZOR0o8CjVKr1u/Fw6sj7RXJD6VpX8vnE27Ddjg/qwAdrymRTIRiUU
 PDQ5DEV5q+/ug5nrwzcifvHjY1Q=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [v2 2/4] dm ioctl: Allow userspace to provide
 expected diskseq
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
Cc: kernel-janitors@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
 Demi Marie Obenour <demi@invisiblethingslab.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: web.de
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> The reason why Markus was banned was because he doesn't listen to feedback.

I tend to listen to some feedback.

We came along items which might look worthwhile for changes
in different ways.


> I've told him several times in the past week to stop bothering people

It seems that some contributors can cope better with recurring advices
also from known patch review processes.


> who are trying to work

Corresponding approaches will evolve further.


> but he is not going to listen.

I came to other conclusions for remaining communication difficulties.


> Meanwhile, I have seen Markus fix bugs so if he wanted to focus on
> fixing bugs he probably could.

The change acceptance is evolving, isn't it?
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/log/?qt=grep&q=Elfring

Regards,
Markus

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

