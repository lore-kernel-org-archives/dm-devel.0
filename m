Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B12A8C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 09:35:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-T-XOwYMMNMGaqGGIvNgFyA-1; Tue, 22 Feb 2022 04:35:17 -0500
X-MC-Unique: T-XOwYMMNMGaqGGIvNgFyA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D2A21006AA5;
	Tue, 22 Feb 2022 09:35:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3735104328D;
	Tue, 22 Feb 2022 09:35:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D1D441809C98;
	Tue, 22 Feb 2022 09:35:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21M36DYl016957 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Feb 2022 22:06:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 69C725361CC; Tue, 22 Feb 2022 03:06:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 649C35361C7
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 03:06:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 456D5380670D
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 03:06:13 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1645499173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9VEJDljbWC7h9LRDUPENTna8Ct2PNC2+kmb2PL1XziQ=;
	b=oVi4jLhu0WmrNJcG0cueSFfXritAqmDQv2lANU7bykpX9Q+tx5DLlCHR/45xs32kwnYecc
	OmRLrLP6z9l2mVnE8ucNZ2WGWX5jdXjVdDW4lJFVvPuMoYrtMgAglvSSMGzdRvWgSYpckp
	v9oH65EJv41kXmcJ5OVTd9yI79NAClaWuSZ2Nhn/FtRDB+qVeNQOfWk/XjybzU69oKpxXy
	tAQyFJD+lWp3Wtv9tDlDA9d3InMAsgftglFhOLzmiWtpTlneNMWrrIWZnWp38httoehAtR
	h0JXZTbzsLeUQk5k6EK4w6FRuAzvkXhHUn2WMaavk2juZkKLXevryEN3XmP8hQ==
ARC-Seal: i=2; s=201903; d=dkim.mimecast.com; t=1645499173; a=rsa-sha256;
	cv=pass;
	b=PS+KJ6UGmPr6fwVFxPi75P1aAnWv5QFrxVtgPQD3tfZtraLUQ56UkBrxfe9zYtRNnhqORW
	ph4MXmaXwN8p9bFhWQKMUZxLhvYWAtwMGnyxm94lJL3y846E9Jw0Aq1apWfPuCERNBzK9E
	NFLHw2ylK5pk13TZOpDEFRyOw8Gdp63fuR73TYG/JZZyvxdGOODkWuCMJw1+RgyL85x/4g
	c2xGHWvwo73uQWzLe5WFoVjK4y1mAuIp0U2syvYyEtB5j4Rt1ZEFe4wACE3Ltz9Val00xP
	o8EsFLsBUBSC/egVJeSdeIILCNB760BncZ2wPeVSN0V+qxexr2Njgpi2hz50eg==
ARC-Authentication-Results: i=2; dkim=none (message not signed) header.d=none;
	dmarc=none action=none header.from=nxp.com
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05on2056.outbound.protection.outlook.com [40.107.22.56]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-438--22XRpp4PE2oy5siUgyfow-1; Mon, 21 Feb 2022 22:06:09 -0500
X-MC-Unique: -22XRpp4PE2oy5siUgyfow-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=YQjJDF3zXGLBiRHucNaFBi2B0TOQAY8luBBErijdu5vSRL/Yvg+YzeFWmyALjbSxe/lRKGc4argVEzr2haGKf48ixy9zzZPZnwB1B6a0gNPAYMlySMYFXPg12/GS5AblLt+MkKyS4YzS4NPU9HUIyH90z365HVUzHLbRxmbdnIO8uNuidlCtLY6dNX6ip2tm4mI/zj27pl4gwoeEVA6UkVJCi2465NmtvIRuTStKLAsH+KgN01So01rPG9ctmQ+XNO6tQpgY5FBH9nYOlZjfQ5QyzwTL+lpgoInDl8r8dWHzTkaS5vjnYV6Pk1aCCRe5Sbvwjlm9DrBs0oMHuS6D0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
	bh=9VEJDljbWC7h9LRDUPENTna8Ct2PNC2+kmb2PL1XziQ=;
	b=C2jAl9hDRCTWzT8g5+U3iyVHe4Fega0hVRhBf1hY7QZZ9XMRtocjwmbu/NjKjVGiohdvhvPE72zTdtoIycjX4G7thmblmZOgNBoDhD+JTmHkmNE/2jzBnCTn1wUrl2GAPImuEINFRhPEWXt7aajR3GyD8dFYVmfE0Sv4/e6K7XRcnJEY6amsU6Aat94t37uwckF9ZjsbQPttJSWPh7tZU1sOmEVOgfgdQWO2n0Sn3HNfm7m647kf+1wxUKpaLd3u5gMY9cY3oOpSLWBmRG+T0cmJ3WOABtArbO8m4GnxpEyKCp+A+1jU9KASZsgHfgQ9YlxjTIm36U0QBX+DVyL6eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com;
	dkim=pass header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2; 
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=9VEJDljbWC7h9LRDUPENTna8Ct2PNC2+kmb2PL1XziQ=;
	b=MvGk9Jl2pb3FZlR1nO3NoqjY+3zb+yCJtpl68z+VcyZJG9UTfDf4JxlLhMqjtFwWDvhWJqve64FFdxvqpkLAz+gM7/qZf7FRsdiYx6NLhK3zloNQcAUJc1RzcI427M4asRU1WYBwNhV7+hzQ63KZK9W2xDxgk99nTxNhWZiCbE8=
Received: from AM9PR04MB8113.eurprd04.prod.outlook.com (2603:10a6:20b:3e9::14)
	by AM8PR04MB7475.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27;
	Tue, 22 Feb 2022 03:06:07 +0000
Received: from AM9PR04MB8113.eurprd04.prod.outlook.com
	([fe80::1e2:8e48:841d:7ee4]) by AM9PR04MB8113.eurprd04.prod.outlook.com
	([fe80::1e2:8e48:841d:7ee4%9]) with mapi id 15.20.4995.017;
	Tue, 22 Feb 2022 03:06:07 +0000
From: Faqiang Zhu <faqiang.zhu@nxp.com>
To: Mike Snitzer <snitzer@redhat.com>, Paul Lawrence <paullawrence@google.com>,
	Eric Biggers <ebiggers@google.com>
Thread-Topic: [EXT] Re: a potential issue for bow_target after "dm: delay
	registering the gendisk" applied
Thread-Index: AQHYJ0IOofEY4C8Oj0alv0vZhqZWzaye4toQ
Date: Tue, 22 Feb 2022 03:06:07 +0000
Message-ID: <AM9PR04MB8113FB1BF5C310A43C3E7858ED3B9@AM9PR04MB8113.eurprd04.prod.outlook.com>
References: <AM9PR04MB811322427E328C435FE9489FED3A9@AM9PR04MB8113.eurprd04.prod.outlook.com>
	<YhPBAc9tnJ1iuPbM@redhat.com>
In-Reply-To: <YhPBAc9tnJ1iuPbM@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
	header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1256db9-8cda-4b30-af74-08d9f5b0451a
x-ms-traffictypediagnostic: AM8PR04MB7475:EE_
x-microsoft-antispam-prvs: <AM8PR04MB7475004837AAA6B6128A716BED3B9@AM8PR04MB7475.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k8fB1p3hXEK8GA4Dp8mqkcRFgQoGOpgtBTWJZoTBemlZqxlTIZC+GtjGnylPQ0VlgJBG+cNPTsM+RliNfzTzQQBv5VSzgZMcB8FPYRZpBTueW3U7N3j901850+PwRmZ+lBgrMbMFL7Wkhxxdt9iLFgVcT0G+XiA5LDVCrit0bjxAJfsyW4HNWfxgFUPL7T7AjYBapKh/DNwRdGMWLuYqjcKsBkK9lX3rtuBEELksNO+14U8rmm2iNG707Q0xkwRIeL3p/MhvtN0QCueLnqC3YeSMhxz1vd2DfriIDXrsUnkeOGz2TmL1qDZI3qTY646gT2YJTyB7qHT0QkS9asK4L0AShhqf/iydqFr/a+SChhncnQhKSpbCaASSbu7Puhq42tWiw8LdKBIy/uTf+Nbzv4YWEsJ5yFObU6pP/Jw5S2YkNaKx3ffulgpJik1ryg4GJPQrtoVdxnHUnKwbHBPqTXbnHZxKW9gR6THjrZ9ZZcAuR2J7tyMZSUW1qOK/x/PW69YwB3L803XAMtai3WSUmW10b2yZkWtsZHWxKm8bgP8TuO23XrZOlSsxvAytc0eRUTwBTHlY8Dg7qhdiQdoF+52Xx9otHIlHlpQLMLwu0tYQcQh5ey9PYurvd4FbihoRWEdtH7yN066IVpsEtoxee3mv3fDJlGpLe1XSM33LzJ4gFmbv2/gg9MJLRAtJEzf7F3L0DyuDew7tU3HrDuWtDQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:AM9PR04MB8113.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(9686003)(33656002)(64756008)(4326008)(5660300002)(508600001)(66946007)(66556008)(66476007)(66446008)(76116006)(6506007)(7696005)(110136005)(316002)(83380400001)(71200400001)(52536014)(44832011)(8676002)(186003)(8936002)(26005)(38100700002)(55016003)(2906002)(99936003)(122000001)(53546011)(54906003)(86362001)(38070700005);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Wld6RVFuZ0lTeEwxUWRWcG9lVlpQYXpqUk5SQmwwTnBWbk92UCtHcUJRWE1B?=
	=?gb2312?B?RjBVcC81VUZvZ2JYcFBXUlIyVkw0U2g2cVJud0tjeVdhL2l3QUkrU1dOYTAv?=
	=?gb2312?B?ZFRTVXUxWU9mZXpDbFArd3dyUHBCc0cyR2MyclVHaERPZFE1cXdKV1lKditp?=
	=?gb2312?B?VVNTZi83Qmt6T1BtZEJOV2ZpSHJPZEc4Sko4NnY1Z0FJYXpvVFBuNXVEUVUw?=
	=?gb2312?B?ZDlRRUdaRlNLZllxbndISndYYXRzRXZvbFdmOFJidG1IdEJLazVmVkR1a3lS?=
	=?gb2312?B?N1h6MndaQnJrQ1ZleGdyVTEySE8zNG9USHVGMkFKWVREUEthd0hnV2doTFRk?=
	=?gb2312?B?LzRQTmZiZ2hiZ3duUlUxb1BNZXlMQ1lRdGIwVEZ5cjluNERpb1EvWDRqVHB1?=
	=?gb2312?B?Q2U1Y2I2T0ZLVVVRL0JqSFZhK3VUbnJJbGgzcEI1ZWtvS1pVdnZZVWp1WkNM?=
	=?gb2312?B?QVZUc09DTGdRRzVmRlUwdFlYSTFVYVBrK3pjU21WMVZ5Q2U0TTBnUEtvL2Fi?=
	=?gb2312?B?U3pRWXhXMG05NitlczVFNXFUTGJyT0paeSsyVVY0QUFnTGJKRUVGZTM3dFhm?=
	=?gb2312?B?eXpubllPczJ5cDczOVFkdTIzM0s4NUlaZTNCdGdHYWh5M3hnRi94MFB4VFVD?=
	=?gb2312?B?MThHOVErNTcvZTR2Vy8raUVHOEJFa3dQRFE0ZktCNnlPUFVYYmJLUUtqWWk2?=
	=?gb2312?B?REtKSi9jTk02dU04KzFpSzRqblROR25aRGIwSG1teCt0QjJoOHNqOWg4WGJI?=
	=?gb2312?B?WDVWeHJZUGdhREgxLyt3VHZ0cW1jT1R3RkRPSFdob3ZoYUtpQ25pMGVCdnIv?=
	=?gb2312?B?QjRMcDFnWDBVVWRDemxYNU9FKzJybXdsSnNoenBIQ2E0cjM2N013Qlp3Njlk?=
	=?gb2312?B?QW9hcWlxWGxzL01CVStjZFk0NFg2OG9WV3dIVkJUdjlXbHlDMHRMd3gwN2pH?=
	=?gb2312?B?UzFqVFlaZElmWFVMNjJNY01OalliSGdheWRtVktpdGhEVzNHaFErN05QeE1z?=
	=?gb2312?B?cDRVdDR2M29VUS9mcWRZWTZJU1c0WjdZT2JkY29HVEZVUmZCWDFwS052NC84?=
	=?gb2312?B?RDExZFdIVktVRm15ejIvUFR0UlhMNmxySE5PQ1FnOHgrRE5CNGY2cVpTVzVx?=
	=?gb2312?B?eHdBSmpiMUlXU1FBclZrbkhBMDRYQzVLcXFNU1ZEK25kd08vc095SFBMMWRy?=
	=?gb2312?B?Y2Z6UVNrcFVkeHRVWURLZDlmRm9YQms0QlVaZ3BqTCsyaXIxZmdyV1FMcmJL?=
	=?gb2312?B?K2FxaGw4aHMvNlNiQXNhYU1rc2QrcmxmUnhabmUyUVYwMFYvNFJPajV2dk8y?=
	=?gb2312?B?YjlqWDNvd1JSZE5PQUdiZ01pYy9WU1RsTUpKSGZKeDh1OVBYVWlkaWZibTRq?=
	=?gb2312?B?cy9wb1Voa3FrcTgySktWekhzUW9UaGJQMStGYjI5UmZyK2RZMmM0S2Zzbzlk?=
	=?gb2312?B?dEFKRURWTlF1R1krTGwreWJYanppVnNCZDN3WmVYWWw5cTBWVy9lOW1YN083?=
	=?gb2312?B?NktaalFiL1hmc2dhcm92T2JhZmtVbEhQYkJzeVJNRHdwdmdpbE95RGswTW5Q?=
	=?gb2312?B?RXdVdnpQdk9GYkNlS2FoemVpTHRtTHpmcitJYjV4VkczMG5ydTRvVzMzK1JN?=
	=?gb2312?B?eklabXdOOVVsWjhUM3lLT2RaNlRPdjZyTWljSGpoQTkxditWU0dBTDZ2Z3RN?=
	=?gb2312?B?RDc4My80Ry9MQTgxWHNrbGtra3BiQzFxbEdycFQ5RWlvSk9wRFEwWUNFR2Ns?=
	=?gb2312?B?SzhuN3NIaTlVVHVCaCt2MnlqUGRPS25JTHhqZlJPR2t5YjE2MmR0ZGh1UzZK?=
	=?gb2312?B?WHFDdzB1MTRIRmRUdUE5TlhIWXlkaWI2cFFGNm9jNi9CZjh5dGRoeWREZEJC?=
	=?gb2312?B?Q1FyV1pSV0pTd1Z6WUM2VW1sL3BOUjN5TjFWblVMQnR6NVAvMWRXRmtKYUNE?=
	=?gb2312?B?Nk5DNVMyaDd6a2dkV0JCSk82N1lQUkE1bk5YYnhxM3hxdVN2aXM5cVp3TFgr?=
	=?gb2312?B?UzRxU05qSm9GclJTVUV6Wkt1K1RyTWtjSW1FQjJYK253aDNvRzYvcHdnZjRB?=
	=?gb2312?B?VHBobENyYnRoaThUSktYVEtTNWFtaXVHSUFxRCtsRzBTRGtieWJMaXpFNVho?=
	=?gb2312?B?dTF3MkpDTCtEWGFzZjA4UTBmWXd2L3ovNTliZVgyOWZNbXlYcmpnZGtoU3JT?=
	=?gb2312?Q?ynQK5ng3brmJoaMbf6YHdBQ=3D?=
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8113.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1256db9-8cda-4b30-af74-08d9f5b0451a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 03:06:07.1134 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aOZT2fvTC4RHDNkuUun34YqDlb/edMfwAvzARvcAjE55PbmSD5DBPPLCqHZZewifNPPLkY748juSzJf5WZ1+YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7475
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 22 Feb 2022 04:35:09 -0500
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [EXT] Re: a potential issue for bow_target after
 "dm: delay registering the gendisk" applied
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
Content-Type: multipart/mixed; boundary="===============8005094357221818350=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22

--===============8005094357221818350==
Content-Language: en-US
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_00BC_01D827DC.2E98E4D0"

------=_NextPart_000_00BC_01D827DC.2E98E4D0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable

Thank you. I just noticed that this is an out-of-tree module.

+ Paul Lawrence & Eric Biggers

Best Regards,
Zhu Faqiang.
-----Original Message-----
From: Mike Snitzer <snitzer@redhat.com>=20
Sent: 2022=C4=EA2=D4=C222=C8=D5 0:43
To: Faqiang Zhu <faqiang.zhu@nxp.com>
Cc: hch@lst.de; agk@redhat.com; dm-devel@redhat.com
Subject: [EXT] Re: a potential issue for bow_target after "dm: delay
registering the gendisk" applied

Caution: EXT Email

On Mon, Feb 21 2022 at  5:36P -0500,
Faqiang Zhu <faqiang.zhu@nxp.com> wrote:

> Hi Christoph,
>
>
>
> Recently when I use kernel5.15 with android, an issue related to
bow_target
> is found with below log:
>
>
>
> [    8.935429][    T1] kobject_add_internal failed for bow (error: -2
> parent: (null))
>
>
>
> The call trace to the preceding log is as below:
>
> dm_ctl_ioctl
>
>  -> ctl_ioctl
>
>    -> lookup_ioctl    // returns the table_load function pointer
>
>       table_load
>
>         -> populate_table
>
>              -> dm_table_add_target
>
>                   -> dm_bow_ctr
>
>                        -> kobject_init_and_add
>
>                             -> kobject_add_varg
>
>                                  -> kobject_add_internal
>
>
>
>
>
> Compared to kernel5.10, then I found it's related to below patch. The
> gendisk, it's not registered yet, its kobject is not in sysfs, so its
child
> "bow" kobject cannot be added to the kernel.
>
> commit 89f871af1b26d98d983cba7ed0e86effa45ba5f8
>
> Author: Christoph Hellwig  <mailto:hch@lst.de> hch@lst.de
>
> Date:   Wed Aug 4 11:41:46 2021 +0200
>
>
>
>     dm: delay registering the gendisk
>
>
>
>
>
> Is this an issue? if it is, is there any patch to fix it? if it is =
not,
then
> what is the right way to use the bow_target in userspace?
>

It is an issue for this out-of-tree dm-bow target.  Likely needs to be
fixed by adding a new DM target operation to 'struct target_type' that
would get called by DM core at end of dm_setup_md_queue().

Or dm-bow discontinues using sysfs for whatever and convert to using
DM messages (with .message) and exposing associated state via .status

Mike


------=_NextPart_000_00BC_01D827DC.2E98E4D0
Content-Type: application/pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

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
UCUyMEVudGVycHJpc2UlMjBDQSUyMDUsQ049TkxBTVNQS0kwMDA1LENOPUNEUCxDTj1QdWJsaWMl
MjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXdiaSxEQz1u
eHAsREM9Y29tP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFzcz1jUkxE
aXN0cmlidXRpb25Qb2ludIYvaHR0cDovL253dy5wa2kubnhwLmNvbS9jcmwvTlhQRW50ZXJwcmlz
ZUNBNS5jcmyGL2h0dHA6Ly93d3cucGtpLm54cC5jb20vY3JsL05YUEVudGVycHJpc2VDQTUuY3Js
MIIBEAYIKwYBBQUHAQEEggECMIH/MIG7BggrBgEFBQcwAoaBrmxkYXA6Ly8vQ049TlhQJTIwRW50
ZXJwcmlzZSUyMENBJTIwNSxDTj1BSUEsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2Vy
dmljZXMsQ049Q29uZmlndXJhdGlvbixEQz13YmksREM9bnhwLERDPWNvbT9jQUNlcnRpZmljYXRl
P2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTA/BggrBgEFBQcwAoYzaHR0
cDovL253dy5wa2kubnhwLmNvbS9jZXJ0cy9OWFAtRW50ZXJwcmlzZS1DQTUuY3J0MA0GCSqGSIb3
DQEBCwUAA4IBAQCI63pWTyQ8btasO1PYlKwpabJ02CXiSH/yXDi4DpJeXmdPjVkHu3sEP7SPi5PL
GtV402XycRVSaPgjEQMU/+1VCcjz5G7Sw9Vud2BoS0N4nRfqktgVDfFNrIeumRhx18SCO8iEuFXn
J2Rs1FPgihmYXRlym8gsPIcWQh3bEG2DBrWWAM6otlDHm5aWC5R+unihmSB2+govHeboLc4jCdNq
IJaLeOMQHrnHYjTeYU+weP/q5E6Oqxbue6lDfWgQ/MAzmfaUFtpe9umSg58ImA0iymD46Uy4Vgs4
X8jeKW4XDO65YU3FKITg3dtcZRUrJvyJIFT4VLGfRd6XKVP68Dw8MIIH7TCCBtWgAwIBAgITLQAG
gkzVif1KeC9VMQAAAAaCTDANBgkqhkiG9w0BAQsFADCBtjEcMBoGA1UEAwwTTlhQIEVudGVycHJp
c2UgQ0EgNTELMAkGA1UECwwCSVQxETAPBgNVBAoMCE5YUCBCLlYuMRIwEAYDVQQHDAlFaW5kaG92
ZW4xFjAUBgNVBAgMDU5vb3JkLUJyYWJhbnQxEzARBgoJkiaJk/IsZAEZFgN3YmkxEzARBgoJkiaJ
k/IsZAEZFgNueHAxEzARBgoJkiaJk/IsZAEZFgNjb20xCzAJBgNVBAYTAk5MMB4XDTIxMDkxNjEy
NTUyM1oXDTIzMDkxNjEyNTUyM1owgZoxEzARBgoJkiaJk/IsZAEZFgNjb20xEzARBgoJkiaJk/Is
ZAEZFgNueHAxEzARBgoJkiaJk/IsZAEZFgN3YmkxDDAKBgNVBAsTA05YUDELMAkGA1UECxMCQ04x
FjAUBgNVBAsTDU1hbmFnZWQgVXNlcnMxEzARBgNVBAsTCkRldmVsb3BlcnMxETAPBgNVBAMTCG54
ZjQ3NzAyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxT+NKcmpsnhvm2JkIRyJh9v6
cH8y0UeCezWs8B2IvDUTF6u5MGcZOzLkhb6zjQC5NNbaPkqgjaPN++MFDxyEgvjstxQj8OUnOFdq
wYLBaH9JTRQ+FjHXopMZvISA1cXfKFzwBId87ICIl61f0ua0SaWZ+JBfNV3DsBjAtWLr2ZqwymM2
VF1B1uw7/OyoemlvjWUIgZZpUAh7ThGcL9iVYGJIT57qQr+cUdUN4dyEQWhbuRJAAPAkHQd7RS+v
okWnKoCiz+y0JqsHGI3du6ZX5BhUO8D7u3Ork/3OYCCOEELWR46J3mQwiiz/Niot061OXoGmjdWw
S966kVRwSLhx5QIDAQABo4IEDDCCBAgwPAYJKwYBBAGCNxUHBC8wLQYlKwYBBAGCNxUIhYLAfoGO
9FWG7YU4guuZS5qSVj+F5opuhLXhfgIBZAIBOjATBgNVHSUEDDAKBggrBgEFBQcDBDAOBgNVHQ8B
Af8EBAMCBSAwDAYDVR0TAQH/BAIwADAbBgkrBgEEAYI3FQoEDjAMMAoGCCsGAQUFBwMEMIGUBgkq
hkiG9w0BCQ8EgYYwgYMwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBLTALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAEZMAsGCWCGSAFlAwQBAjALBglghkgBZQMEAQUwCgYIKoZIhvcNAwcwBwYFKw4DAgcw
DgYIKoZIhvcNAwICAgCAMA4GCCqGSIb3DQMEAgICADBDBgNVHREEPDA6oCMGCisGAQQBgjcUAgOg
FQwTZmFxaWFuZy56aHVAbnhwLmNvbYETZmFxaWFuZy56aHVAbnhwLmNvbTAdBgNVHQ4EFgQU/dIT
g1NFsoqVY/ahIm0ynsbfex8wHwYDVR0jBBgwFoAUWJVg7k5072Uiqr3tGakreo4XnQcwggFGBgNV
HR8EggE9MIIBOTCCATWgggExoIIBLYaByGxkYXA6Ly8vQ049TlhQJTIwRW50ZXJwcmlzZSUyMENB
JTIwNSxDTj1OTEFNU1BLSTAwMDUsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENO
PVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9d2JpLERDPW54cCxEQz1jb20/Y2VydGlmaWNh
dGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50hi9o
dHRwOi8vbnd3LnBraS5ueHAuY29tL2NybC9OWFBFbnRlcnByaXNlQ0E1LmNybIYvaHR0cDovL3d3
dy5wa2kubnhwLmNvbS9jcmwvTlhQRW50ZXJwcmlzZUNBNS5jcmwwggEQBggrBgEFBQcBAQSCAQIw
gf8wgbsGCCsGAQUFBzAChoGubGRhcDovLy9DTj1OWFAlMjBFbnRlcnByaXNlJTIwQ0ElMjA1LENO
PUFJQSxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0
aW9uLERDPXdiaSxEQz1ueHAsREM9Y29tP2NBQ2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1j
ZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MD8GCCsGAQUFBzAChjNodHRwOi8vbnd3LnBraS5ueHAuY29t
L2NlcnRzL05YUC1FbnRlcnByaXNlLUNBNS5jcnQwDQYJKoZIhvcNAQELBQADggEBAL4TkNpLfBfk
+PuEo2aUQhGf1wbUq0BZN3c6l+zxpQvwJpxa5Zg5X6VythiZWt+z3bKA6CrXdWCxq4ahLFTsO0Rd
WNzKPVRZxffqdeSeN/HQvfkC2RBLr9yj/QZVgXpl+DZx/ApYXAASI/BF3lJFbkiohsQLni+QUXIq
MnAPPvz7JJK4NDmraTyhqIPKd+mFBePu2iytTyy3A08U4mbS/ofp4UtyhE0LIFsJ0cHtQBHD3GjP
smig6mj/6mtYHy7blqDJtauK3qRt7mDmzmqD/bb5kEnvuL6UlN/0KhOHObZSwxbjZllzsvIXtHCA
nGJeNKEuT0EyjdDOAo3RaoHx5NQxggSzMIIErwIBATCBzjCBtjEcMBoGA1UEAwwTTlhQIEVudGVy
cHJpc2UgQ0EgNTELMAkGA1UECwwCSVQxETAPBgNVBAoMCE5YUCBCLlYuMRIwEAYDVQQHDAlFaW5k
aG92ZW4xFjAUBgNVBAgMDU5vb3JkLUJyYWJhbnQxEzARBgoJkiaJk/IsZAEZFgN3YmkxEzARBgoJ
kiaJk/IsZAEZFgNueHAxEzARBgoJkiaJk/IsZAEZFgNjb20xCzAJBgNVBAYTAk5MAhMtAAaCTT3G
fdZ3lO0DAAAABoJNMAkGBSsOAwIaBQCgggK5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIyMDIyMjAzMDYwM1owIwYJKoZIhvcNAQkEMRYEFHa+ZqK8e6XbEovEUqTb
qqasizorMIGTBgkqhkiG9w0BCQ8xgYUwgYIwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjAKBggq
hkiG9w0DBzALBglghkgBZQMEAQIwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsO
AwIaMAsGCWCGSAFlAwQCAzALBglghkgBZQMEAgIwCwYJYIZIAWUDBAIBMIHfBgkrBgEEAYI3EAQx
gdEwgc4wgbYxHDAaBgNVBAMME05YUCBFbnRlcnByaXNlIENBIDUxCzAJBgNVBAsMAklUMREwDwYD
VQQKDAhOWFAgQi5WLjESMBAGA1UEBwwJRWluZGhvdmVuMRYwFAYDVQQIDA1Ob29yZC1CcmFiYW50
MRMwEQYKCZImiZPyLGQBGRYDd2JpMRMwEQYKCZImiZPyLGQBGRYDbnhwMRMwEQYKCZImiZPyLGQB
GRYDY29tMQswCQYDVQQGEwJOTAITLQAGgkzVif1KeC9VMQAAAAaCTDCB4QYLKoZIhvcNAQkQAgsx
gdGggc4wgbYxHDAaBgNVBAMME05YUCBFbnRlcnByaXNlIENBIDUxCzAJBgNVBAsMAklUMREwDwYD
VQQKDAhOWFAgQi5WLjESMBAGA1UEBwwJRWluZGhvdmVuMRYwFAYDVQQIDA1Ob29yZC1CcmFiYW50
MRMwEQYKCZImiZPyLGQBGRYDd2JpMRMwEQYKCZImiZPyLGQBGRYDbnhwMRMwEQYKCZImiZPyLGQB
GRYDY29tMQswCQYDVQQGEwJOTAITLQAGgkzVif1KeC9VMQAAAAaCTDANBgkqhkiG9w0BAQEFAASC
AQBj2T7Uqn4yU9EhS0lFQzuRp5eJbph3WJ3GOFUwa3joa9GJ44hWXLeY+m+YWyT2sc/tfwrTAn55
YODopa9wIUQMxauujmN/5U4nm1F6sGSmBwiZgJk/C6B/5T+A0fObEE3KiFCfPj1K4n9jn5pKltk1
wVf1meuVNeO7pIF/+TUFXwB51FNtJfOebIjeQ8Ch2Vfo8zdTf5TnP1Tuc6fD8DFLOTDyzejMbZzP
ozMe9A1uyQq0RJxumHP/W2mHIADEmP/whqIlz1hrYdDwN3AsvcJZYVRI+zVY3yxDAcYwQwHZRa3K
GVmGO3G5pxyBt5VVV9KDkCbALNOIlLkzLgNfhgqOAAAAAAAA

------=_NextPart_000_00BC_01D827DC.2E98E4D0--


--===============8005094357221818350==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============8005094357221818350==--

