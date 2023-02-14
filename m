Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F9C6C64ED9
	for <dm-devel@archiver.kernel.org>; Wed, 15 Feb 2023 09:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676453630;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eirPZqSPjFM/h1/eLkYYswoQE9IFs3YDC22gG6Z6YHs=;
	b=fOBQ2ekcMJKvBkpwiDiJqyn6abP4ZJvR1nx4zlnp05uKPEsH2NqsBjiZAWB3hyId1YHMd+
	zsjiZznpjg98x5qy7M1FIOgngR487GVsJruS09XdH+rN7lVYFJjcE9ijXZIKLcDw1/uZzW
	ew0J2aV89pKKOBrtNuO7ajyvCZQKrrE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-zRIfM9cFMCG9sCWaulNmUQ-1; Wed, 15 Feb 2023 04:33:45 -0500
X-MC-Unique: zRIfM9cFMCG9sCWaulNmUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B2993848C36;
	Wed, 15 Feb 2023 09:33:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B944518EC2;
	Wed, 15 Feb 2023 09:33:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7C8711946588;
	Wed, 15 Feb 2023 09:33:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E8D51946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Feb 2023 16:08:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6E9E01121319; Tue, 14 Feb 2023 16:08:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 66CA91121318
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 16:08:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44ABC800050
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 16:08:51 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12olkn2012.outbound.protection.outlook.com [40.92.23.12]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-9XnHCl_fNIC1AWhvb7GjQw-1; Tue, 14 Feb 2023 11:08:48 -0500
X-MC-Unique: 9XnHCl_fNIC1AWhvb7GjQw-1
Received: from IA1PR20MB5743.namprd20.prod.outlook.com (2603:10b6:208:421::7)
 by CY8PR20MB5548.namprd20.prod.outlook.com (2603:10b6:930:53::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 16:08:46 +0000
Received: from IA1PR20MB5743.namprd20.prod.outlook.com
 ([fe80::e93b:346c:d538:6083]) by IA1PR20MB5743.namprd20.prod.outlook.com
 ([fe80::e93b:346c:d538:6083%8]) with mapi id 15.20.6086.023; Tue, 14 Feb 2023
 16:08:46 +0000
From: Ganapathi Kamath <hgkamath@hotmail.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: On allowing remounting the partition containing dm-mapped boot
 disk as read-write
Thread-Index: AQHZQFqncS6Q3itxfEmMM91VE97WIQ==
Date: Tue, 14 Feb 2023 16:08:46 +0000
Message-ID: <IA1PR20MB5743F5A364EB9E02890364F7DAA29@IA1PR20MB5743.namprd20.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-tmn: [zU3G8oHlxHXlVzHc0G49E+nigSEHEm8N]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR20MB5743:EE_|CY8PR20MB5548:EE_
x-ms-office365-filtering-correlation-id: e9100c9c-9114-4d90-e658-08db0ea5c0a6
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GEKRMkskEXfzHEVz26BgV5Dk3GgNcNfJj/jwZOVsB2/pFYfrEWgCdUASSCdM7j1chaSHspDT0TNYgLScbq0ApG4NT/dtO6LVvHKclWBTfRajzRmyoR/2z4Zngozb4E8lKVx5Gue0LvtLDr0LYrxwvDJr9b1VYM41LdUtjVBpqrifEYLbaHxYsFzrms3HnKgo2M1tN1xWomz16qnaA5zfXrwRwVjY6FxcqirgCuix0NmfeyhQeiRIwl3y5tehS6c602jXl1XKsH9xmV2n9OaifHIdKpOBHHzr6dXJMjfZ6uAgyM7kAaj0WJTZCcq6wALHn6NJ2Wh9DbX2+PK2SzzCz9NG4HN3vDIVFPJuA5P01r/kw4NF0TMbETJbKg4cfAN5gq5XoaBs/35UfdnC5tREzWIezKI5/bPAH+naSL1+ICHHunNkKdnO7mgWOIwVICKN8ix2CPcXhGoD+29rLLiO9nh9PTLjuJ66i++nf4t855YqhAkCeX417ppdSEmkHRHzbkGgnBWiOvYMSlJ5tbZR/xo86fz9Y1iZF7/b7J1HwYbhV6yUgHR+AyvIF615K3DZr120QZ5omefRitEOm4X3jA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?EDNbA/fsurPre+XNhb09pMIk35BHPKGWop/Egd+E5vfblcq9QLvbqMTOgv?=
 =?iso-8859-1?Q?IOLAPij9ElxSe/W5Q8f+uhXD0XvvGIYfkdWZ6/fBgirClLTJW7ipKaeG2s?=
 =?iso-8859-1?Q?Jolbv4ZARP8OJ/MZPTx7vZIUgi5GHAe3r0Q+6Un2CAb2UqXah14lGK+XAV?=
 =?iso-8859-1?Q?nS8jfxeqF3QGqyuJDdnko8z65pVbs+SWHNjf0fXouJy0b+2qKioPjkDdRx?=
 =?iso-8859-1?Q?gxdqp4OLfS670VuiEdEO9d0dlhTrWRFLwlm3aFDuR3M4JZDH9ENHzl1xjj?=
 =?iso-8859-1?Q?LrTUtT/hdvDk6YcDqV2fJqggJAitVKBFMd+Qbr70lUyUCtcvWM3M+7T/ON?=
 =?iso-8859-1?Q?rK5Lf8XiAD1T1ERK2iCCgPwkZQAlTk1OjzUXIVqFBS4XetJUWqco38F3C5?=
 =?iso-8859-1?Q?j2k0gDXi2bV5q8xntXhoM8AGHdbKsP7ZmtPYEW3T8z5FgVQPPUY/AZ2Siq?=
 =?iso-8859-1?Q?q2Zxcw/nBLoLK7uVETOZPI4DUI1yUNs+0JPAf6nra9P1YkEGZ3u/Tet3MM?=
 =?iso-8859-1?Q?K9Tnhj/GFjexJr1/iQVU9Oe54GVrRZAjd7vZl2qIpBcIYRdib78KWV9mak?=
 =?iso-8859-1?Q?Bt/1KYT0y4mlQtlxfYx5J6teeKOxLa/NnJqTfIy/O/BOtKUKFHkflTf9Hi?=
 =?iso-8859-1?Q?hzwJcYXIox8V/e/X+nQ9HEFM16V4FaFBgq8DEIBv5WszINazhA16cqitbs?=
 =?iso-8859-1?Q?mgvXkVA+3Q51YKZqI2VYQjyX/v7N2M79QPOTdzL3zl0EBN/YrNqPcXfDN2?=
 =?iso-8859-1?Q?WgUGCQzKfYunfNyXuvqrCTyGcCboDNZ2N/fHF0H/T4dEiYUtMt+H9Tn/PC?=
 =?iso-8859-1?Q?xCNkEDTjoMDVujlQWe6Xg2rxPIbfcIjYJpB+ha4eI591UIgBMtvJHB2BnU?=
 =?iso-8859-1?Q?+W4YAJsl8Dcxu1/l10DS1C3j8X+pLOKGAJVB+sbYwQQ9H9asHWH7FwT91a?=
 =?iso-8859-1?Q?6J1129kZooi5H0X+bzgFVNXLghRktWT0Ou9xXJPfF79q0kar/Ws+jGCFE5?=
 =?iso-8859-1?Q?YVFblFT9epTknx4bZp72L3LWv/qI+KuDCAIHLH6+TfgFFn2am9xGcM1J58?=
 =?iso-8859-1?Q?F/g2aeTSUPogZWsaaLBkfhOROJpiStSwBuD1tb46wVEhEyoJ5TP/U5T1jM?=
 =?iso-8859-1?Q?sTIykQcFXNpVhG/kKDjqIYgwg5V/+abBhM+22ctax86GE1p/Pp/f0B11OT?=
 =?iso-8859-1?Q?9oRK/rkrSlSDm+Lqdmt7JNWaSebADqCBbogHlUMYmIlAfKmt3xrd3xgYjR?=
 =?iso-8859-1?Q?X5W5xRBbOZWzVcwwt/WFnHCJngA5592PRVd3WKZc3CN1XbP8QJCcs7ebiu?=
 =?iso-8859-1?Q?GIZO?=
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-9803a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR20MB5743.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: e9100c9c-9114-4d90-e658-08db0ea5c0a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 16:08:46.7300 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR20MB5548
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Wed, 15 Feb 2023 09:33:38 +0000
Subject: [dm-devel] On allowing remounting the partition containing
 dm-mapped boot disk as read-write
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I am just an ordinary user of Linux and ventoy .
Q)
https://github.com/ventoy/Ventoy/issues/2234 
Is what I have suggested here, meaningful?
Is there contra-indications to not do it or an alternative suggestions?
thoughts?

Ventoy, a GPL software, uses a small kernel patch to achieve a small remountability feature.
It seemed to me, that patching the kernel per distribution is sub-optimal.
I couldn't find a previous relevant discussion on this on dm-devel, but it seems like a requirement would've been well known and this would have already been discussed. What does the actually patch do?

Thx
-Gana

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

