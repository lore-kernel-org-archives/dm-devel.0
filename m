Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B12D5C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 09:35:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-fGt16uSxNvGHnyO5PjAZ5Q-1; Tue, 22 Feb 2022 04:35:17 -0500
X-MC-Unique: fGt16uSxNvGHnyO5PjAZ5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51B2C51A9;
	Tue, 22 Feb 2022 09:35:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D284080DE2;
	Tue, 22 Feb 2022 09:35:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D202946F98;
	Tue, 22 Feb 2022 09:35:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21LAaPE3032467 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Feb 2022 05:36:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 352BB5361CC; Mon, 21 Feb 2022 10:36:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FA4D5361C0
	for <dm-devel@redhat.com>; Mon, 21 Feb 2022 10:36:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C6761C068C2
	for <dm-devel@redhat.com>; Mon, 21 Feb 2022 10:36:25 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1645439784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	dkim-signature; bh=QWTP7ZReC7xqzDTyAX+sBhXBi9wnjOy7p6BQR0uCJgc=;
	b=BlerMnC4fJNzvvDelAeER6gViG6JC5ttBgmalUjIxQ4OkoAEV642NHTrx1opUUEkVfXVij
	0kS8qgwooYL2QGTvbOEouJNNxYxInqFWtnZVIV/sIAZqI1dbOBC1umFFIzE1ZT5hr0jge1
	3z2M4DzNUnEwG5OG6+hSw/XAyRGvs5jMAKFhdrjutbpcMROgYGAbXPqUg8DRdqvY+8DbgT
	0vlG4+hzKSSvG57BPpCXw4ea5LrEPt8IuVHcVhQDcBRwrGC3Of0ADHQFNWl7rKVOYhDXUy
	cjfsDiYiivefrIeRXNVMqV7QGr918MeTnT7m9ocXtVVjtWmbtVMnswR15znqpg==
ARC-Seal: i=2; s=201903; d=dkim.mimecast.com; t=1645439784; a=rsa-sha256;
	cv=pass;
	b=I91Tnk3NMrV5yKAkGofeYeWYo9zgdgilth6lts2JA0HhZlSC/h+lFMVuLSvRO48zEbVcLw
	yO/52+V/MDV0AeKWk+8fKXmdR1DhVefhonzGrA6RrpGe6pLqd9veX2vN7MCdAuh/XDSgbo
	eX8YWNUFOq8TA4TPXzs8F+C986q+GP6rP4j8jzpeNlYfLLdB95B3G9vuDxyrfJGoWgd4Eq
	B+YO+ZI1OLO4zEoibaT9vdJdytAbczNhwQntL0tmkQ1kwG26X5UXH/dSzBKCGdWzEE/1ly
	ZgpQ70RQZz5mcq6/gChPLIiMMNNU4LniQYaZRRn97CPyU+a4G0VNJYN3wIzRKQ==
ARC-Authentication-Results: i=2; dkim=none (message not signed) header.d=none;
	dmarc=none action=none header.from=nxp.com
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05on2080.outbound.protection.outlook.com [40.107.20.80]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-675-uHGVAd9EOfirN0ixKcuGRw-1; Mon, 21 Feb 2022 05:36:22 -0500
X-MC-Unique: uHGVAd9EOfirN0ixKcuGRw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=bHbE4XIOL/3n0zSzMfihKhg3jimsfrdrWLWARVXBe3SN4g7oinHjCUQ4Q6t0X0unZnXEqx1V5OJIAJAwbJH+N8u+DjHWWp0lFOFP3NnFSLalm6NyJws9pKlzp8nEwM3VIFcprX+/jhPwEwA079w3gEU42C/I3xuII7vZtcvlM1xm6Vkrzs8SCkYfEyBCckjBgmihTMC6x0WKtTsBLdZtre/yqiI9Zvl5PEdOfFHpN/3UP+MvAJOBb8wfoW9sYAs9quMIbJMWl0yTbjkhZogQpg3dWwh3tvFiZZWuBg0NPdJ3npmRuKOviiKSSfMD3AJVZps8Kdn3fxXfs9lkuXThCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
	bh=QWTP7ZReC7xqzDTyAX+sBhXBi9wnjOy7p6BQR0uCJgc=;
	b=SHyaupixRfRabcAK20LpFRzaTAt8garqMtRNeHRFj2nCnZ/Y7C0uFNqdhZOEaNdTBNnIxgXnPzHxYdgoEe51HOvbakvJ+4XGhywq17g/LVGH/c1eQn95fo1w5/qrfvhFGJpjgioo++1MzaHDUbvFPhXW0rfJ0W+LrAkDUokBfKsjFH3FPukT+Rh7XhUPop5XuWs5eSNovuoG8p0gfWDADgKjHf4wdFpVy4767Tj7T2j8SnMkzihjdRf6gGORDxDi/sUsGe6X3DVQRqT1F1/gNDGQ9lETW1fcCIB9SmIXpgsL61vRtAKIZ7Eevl+MqPy3XxZ4K23h+muibyzgzREFBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com;
	dkim=pass header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2; 
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=QWTP7ZReC7xqzDTyAX+sBhXBi9wnjOy7p6BQR0uCJgc=;
	b=nP+mfP19svX6t6oU0TkWkp/D5/T89KtuxEvdBRqE/W5JyyEMMRLh6sCtHlkVrulVAvHi117cYnUap/h7Xmy8tuJifj94oqojTdd+/KU/ggrra9GtXwpZQPFbOo+wV0NkSS4U/HdhjywlhH2YL/U1aLM6BVK0K7bAqR8kJ2q55RQ=
Received: from AM9PR04MB8113.eurprd04.prod.outlook.com (2603:10a6:20b:3e9::14)
	by AM9PR04MB8228.eurprd04.prod.outlook.com (2603:10a6:20b:3e9::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27;
	Mon, 21 Feb 2022 10:36:19 +0000
Received: from AM9PR04MB8113.eurprd04.prod.outlook.com
	([fe80::1e2:8e48:841d:7ee4]) by AM9PR04MB8113.eurprd04.prod.outlook.com
	([fe80::1e2:8e48:841d:7ee4%9]) with mapi id 15.20.4995.017;
	Mon, 21 Feb 2022 10:36:19 +0000
From: Faqiang Zhu <faqiang.zhu@nxp.com>
To: "hch@lst.de" <hch@lst.de>
Thread-Topic: [regression] a potential issue for bow_target after "dm: delay
	registering the gendisk" applied
Thread-Index: AdgnCjLYgejH8iiWRoiHguKj/invmw==
Date: Mon, 21 Feb 2022 10:36:19 +0000
Message-ID: <AM9PR04MB811322427E328C435FE9489FED3A9@AM9PR04MB8113.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
	header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f151ba93-1db3-45a6-8e84-08d9f525ff7f
x-ms-traffictypediagnostic: AM9PR04MB8228:EE_
x-microsoft-antispam-prvs: <AM9PR04MB8228B735A85E58CB67171100ED3A9@AM9PR04MB8228.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Eky6xXNs9TnFWa+Z95W/ET4QzAFKqwtSOEkmjAVLg83/OUyaSTyTliYB903ULcVUrXsapA8iXB6YpOxsIEPftNoxYg+UiJNBD0HpCV5Q358YbJd0EnZ+CcIDNY0ZdVfvfnwJJmq20TvHeruXpAd/wmg6J1b8Ht23VQuSLTOOFPSwig0ra1af2b+t3BxZnimeorV5EizkKzJ7WX2juayNBTfg3DbsDY6Xm7ZBqc46TNmVSOwmnSvaOp6DHGB0M8X6C+ciAEJhbMxssJZ9mA4eWJLsnLX3oZMnjRGFFHz5+K73vkuuJx+cxvmX9YtUASGSwxWMjVdn7e/DP1ZZZzsjl/OYc5q6Ew5IK7pSg95Wvv+AyuRBgxcRvPDNMSoP4NOz3w36kYd8uvF/wMG1O9ufCk2OeWWyDXb18sz+sXOXkA4w6M7PXJVNEBLZan/Fd66gbqU1zQBWGA2WH+cI6NxScuU1ImjQMXRMIHYt/PRZ21894voyGbr5PWQz4T7fwkVMsYcJwH42djwi9+dnaCZY96wuCQShzuDogbOKbSuaOqKsCXGCE27rNNdeHRLznYbMmco4ZyuGfSz/pxeOVyEEzAUvdes+8GHxUs67qVeFUxJaXEMcmAjhbrGBjzZwOMDaQt6HklPRk5W+CAJ9224MGN/FwOwNvdQBcSQFxMcpnIoOkUtSLuByZrOINvzwDxbumBnB51hdCuVPKy9YUt9lbw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:AM9PR04MB8113.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(508600001)(9686003)(33656002)(54906003)(4744005)(86362001)(6916009)(2906002)(83380400001)(8936002)(99936003)(316002)(5660300002)(44832011)(66946007)(55016003)(66556008)(38100700002)(66446008)(66476007)(76116006)(8676002)(4326008)(6506007)(7696005)(186003)(26005)(38070700005)(64756008)(71200400001)(52536014)(122000001);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UfuAmhiiUHWOKQ4WtAtOWApBRozKQTLpimGWtuLNB5wqouzkeYbcgIqignEn?=
	=?us-ascii?Q?S/LckDKr0yLREiOILHLs1qq52+LxZN2ECdAgkJeIahg7hQdwqtubudPrSOBl?=
	=?us-ascii?Q?wo5/aQk1mVFOWiEWfNFNOntGElXCd8mSnjhGGPdi6DRsi6gRNCfFsPrsts5g?=
	=?us-ascii?Q?GydRGTYC697mhzD7AGpw09B8apWDFRVsfy59+ocFZeJxbFVSV4wLGrnPj+Gd?=
	=?us-ascii?Q?MQ9i8l4N/b7uiB85XiLWG0tZJc7mWJ4w2SXgtNESVzRgB3NCbj+zBfe4LiKf?=
	=?us-ascii?Q?qLm09EKAPUC79Unippk5aYGBiFBGEiStTcbHqgjFb0RZ80UmvQJThAbKFod9?=
	=?us-ascii?Q?RBFeW9g0M6TpBt99KezlAbK3+QgQrPjKbnaN4O2RXnRqT2UhQIXc7YSwgHXP?=
	=?us-ascii?Q?0YdCQVOdBmOjMiaf2mLQ6kTAxo3D7G+jy3vsr7OMdXqN964N3B1OzaI+Ezey?=
	=?us-ascii?Q?TCV+B9PZtubpr+p4RhofT1jw9Ux6Q+rqufksxBtNv1/UQVOg9G1Z8tL3Q3Vh?=
	=?us-ascii?Q?l4D/yp3Tgb4gRDXJy6VV60aA81lrT639GshyvWs6SWuF3QUuxw4PhlKWSX7e?=
	=?us-ascii?Q?TNduBujC/+kqd8q5mw6M6CBRBFbqbTS2ajhgL8vUnXffc5wWCCEe43T8t8SU?=
	=?us-ascii?Q?UWx2n6EHJ2+wpBAyIDSWEMZ8fDggJj+sTpIznDtLOGMxNIdQlj1ufHIttnQZ?=
	=?us-ascii?Q?hXBq3R3Yu9aB1mocXWd4HuDjbFsKR/FMqoo3ksAbgQI9Z5YEzPeuV0zCuF3e?=
	=?us-ascii?Q?jVtN1iSCDBwZhPTWefC8PqPaM812S95PWl0soV47PepCEUIS/5HwdY7xhzUw?=
	=?us-ascii?Q?KZVoH+gm2VyrOd7opgUJOdYtVKBxqJqD+VLBF+4hl912vCpL44Iz9RwxGuCv?=
	=?us-ascii?Q?QEuP6Vs4Vdnf1sIl0zlNxUROvkPT3rrfwnHiuQvkWCvDr+PnbjpCO2cTNDa8?=
	=?us-ascii?Q?s1Rldy93kmrIW47PeuRjyHIRIyUsf6d/OFUsNxTnSM48Pp6n0/tKkLR/XzKc?=
	=?us-ascii?Q?rtMBA7kz2zJ9mwgN25KVqx0L5b1fqc5kbC+AKPSR7oyBa7wnyu3ej1Tiz3O9?=
	=?us-ascii?Q?6S63vHTUhMfkkAdHlHX3vDk2OuRDigDjk4lzfPEKwQ38Bl4pjNCbY5YDyck7?=
	=?us-ascii?Q?5LKfxFQ2c/aJqW9MN+I8qi1dQOkvBT3vEe/bDAn0BOiEGODNwM1o1GohTxqO?=
	=?us-ascii?Q?bkrFFTvJa0CJIASiZ91FVKYhMn4xvfLPIIVmP6okG7XgjHKuQnQUEaiJBTSu?=
	=?us-ascii?Q?ir7O16uFo9i8iXk+XrY4Yf2QM0SsVK48FNtdCdn86yLMSI91BqrsNML5RxOC?=
	=?us-ascii?Q?2LYaaKDf51id89RpPD/RVYo6DzAIJy/XhhgHqRymZZtnyDnWSZf0d1u37H84?=
	=?us-ascii?Q?X/O2WzYpmXyDMLYwYNMfaLkbn2iCy5h9HbRDDpRgLQDsB7YOwPz7Ze0AmjNQ?=
	=?us-ascii?Q?Wepl/6ST6a+COH5YQV2I4vKdCIymcpgp89elMn4xdYG4DjBwqpLCibSgiAGT?=
	=?us-ascii?Q?bI3gaxEFgQmNhRYzTZacPl+S3GqtHavhqVsSJSdK9Z17G190ZhW95KvG9NI/?=
	=?us-ascii?Q?LFhJ7OVoAbwDvXa+AW2QMOvx65b0Ln1RMMrSQf2iyJwAN9jVPdzQ50UEJWnL?=
	=?us-ascii?Q?XA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8113.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f151ba93-1db3-45a6-8e84-08d9f525ff7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 10:36:19.7843 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P2BavuTCwDxR1AaXRv6++mStEOcGeRtkY6sVoxUmdKwgEusPp0AfR6V/hkzRZjUV8bXq17857B/GjMNNniO3sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8228
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 22 Feb 2022 04:35:09 -0500
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: [dm-devel] [regression] a potential issue for bow_target after "dm:
 delay registering the gendisk" applied
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
Content-Type: multipart/mixed; boundary="===============0471404713867487893=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

--===============0471404713867487893==
Content-Language: en-US
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_004A_01D82751.E8CA5CC0"

------=_NextPart_000_004A_01D82751.E8CA5CC0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_001_004B_01D82751.E8CA5CC0"


------=_NextPart_001_004B_01D82751.E8CA5CC0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Christoph,

 

Recently when I use kernel5.15 with android, an issue related to bow_target
is found with below log:

 

[    8.935429][    T1] kobject_add_internal failed for bow (error: -2
parent: (null))

 

The call trace to the preceding log is as below:

dm_ctl_ioctl

 -> ctl_ioctl

   -> lookup_ioctl    // returns the table_load function pointer

      table_load

        -> populate_table

             -> dm_table_add_target

                  -> dm_bow_ctr

                       -> kobject_init_and_add

                            -> kobject_add_varg

                                 -> kobject_add_internal

 

 

Compared to kernel5.10, then I found it's related to below patch. The
gendisk, it's not registered yet, its kobject is not in sysfs, so its child
"bow" kobject cannot be added to the kernel.

commit 89f871af1b26d98d983cba7ed0e86effa45ba5f8

Author: Christoph Hellwig  <mailto:hch@lst.de> hch@lst.de

Date:   Wed Aug 4 11:41:46 2021 +0200

 

    dm: delay registering the gendisk

 

 

Is this an issue? if it is, is there any patch to fix it? if it is not, then
what is the right way to use the bow_target in userspace?

 

 

Best Regards,

Zhu Faqiang.


------=_NextPart_001_004B_01D82751.E8CA5CC0
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><META =
HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 15 =
(filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:\7B49\7EBF;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
@font-face
	{font-family:"\@\7B49\7EBF";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:\7B49\7EBF;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:\7B49\7EBF;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
/* Page Definitions */
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:850798395;
	mso-list-type:hybrid;
	mso-list-template-ids:1325332844 -390415264 67698691 67698693 67698689 =
67698691 67698693 67698689 67698691 67698693;}
@list l0:level1
	{mso-level-start-at:0;
	mso-level-number-format:bullet;
	mso-level-text:\F0E8;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:65.4pt;
	text-indent:-18.0pt;
	font-family:Wingdings;
	mso-fareast-font-family:\7B49\7EBF;
	mso-bidi-font-family:"Times New Roman";}
@list l0:level2
	{mso-level-number-format:bullet;
	mso-level-text:\F06E;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:89.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l0:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F075;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:110.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l0:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F06C;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:131.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l0:level5
	{mso-level-number-format:bullet;
	mso-level-text:\F06E;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:152.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l0:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F075;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:173.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l0:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F06C;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:194.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l0:level8
	{mso-level-number-format:bullet;
	mso-level-text:\F06E;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:215.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l0:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F075;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:236.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l1
	{mso-list-id:959795914;
	mso-list-type:hybrid;
	mso-list-template-ids:-1813850522 -1622512534 67698691 67698693 =
67698689 67698691 67698693 67698689 67698691 67698693;}
@list l1:level1
	{mso-level-start-at:0;
	mso-level-number-format:bullet;
	mso-level-text:\F0E8;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:28.8pt;
	text-indent:-18.0pt;
	font-family:Wingdings;
	mso-fareast-font-family:\7B49\7EBF;
	mso-bidi-font-family:"Times New Roman";}
@list l1:level2
	{mso-level-number-format:bullet;
	mso-level-text:\F06E;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:52.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l1:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F075;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:73.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l1:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F06C;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:94.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l1:level5
	{mso-level-number-format:bullet;
	mso-level-text:\F06E;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:115.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l1:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F075;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:136.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l1:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F06C;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:157.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l1:level8
	{mso-level-number-format:bullet;
	mso-level-text:\F06E;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:178.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l1:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F075;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:199.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l2
	{mso-list-id:1387726826;
	mso-list-type:hybrid;
	mso-list-template-ids:-1580577376 2132063424 67698691 67698693 67698689 =
67698691 67698693 67698689 67698691 67698693;}
@list l2:level1
	{mso-level-start-at:0;
	mso-level-number-format:bullet;
	mso-level-text:\F0E8;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:65.4pt;
	text-indent:-18.0pt;
	font-family:Wingdings;
	mso-fareast-font-family:\7B49\7EBF;
	mso-bidi-font-family:"Times New Roman";}
@list l2:level2
	{mso-level-number-format:bullet;
	mso-level-text:\F06E;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:89.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l2:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F075;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:110.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l2:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F06C;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:131.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l2:level5
	{mso-level-number-format:bullet;
	mso-level-text:\F06E;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:152.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l2:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F075;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:173.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l2:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F06C;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:194.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l2:level8
	{mso-level-number-format:bullet;
	mso-level-text:\F06E;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:215.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l2:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F075;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:236.4pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l3
	{mso-list-id:2038657871;
	mso-list-type:hybrid;
	mso-list-template-ids:1370109690 -110723196 67698691 67698693 67698689 =
67698691 67698693 67698689 67698691 67698693;}
@list l3:level1
	{mso-level-start-at:0;
	mso-level-number-format:bullet;
	mso-level-text:\F0E8;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:28.8pt;
	text-indent:-18.0pt;
	font-family:Wingdings;
	mso-fareast-font-family:\7B49\7EBF;
	mso-bidi-font-family:"Times New Roman";}
@list l3:level2
	{mso-level-number-format:bullet;
	mso-level-text:\F06E;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:52.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l3:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F075;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:73.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l3:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F06C;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:94.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l3:level5
	{mso-level-number-format:bullet;
	mso-level-text:\F06E;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:115.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l3:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F075;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:136.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l3:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F06C;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:157.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l3:level8
	{mso-level-number-format:bullet;
	mso-level-text:\F06E;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:178.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
@list l3:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F075;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:199.8pt;
	text-indent:-21.0pt;
	font-family:Wingdings;}
ol
	{margin-bottom:0cm;}
ul
	{margin-bottom:0cm;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DZH-CN =
link=3D"#0563C1" vlink=3D"#954F72" =
style=3D'word-wrap:break-word;text-justify-trim:punctuation'><div =
class=3DWordSection1><p class=3DMsoNormal><span lang=3DEN-US>Hi =
Christoph,<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:10.5pt;mso-para-margin-left:1.0gd'><span =
lang=3DEN-US>Recently when I use kernel5.15 with android, an issue =
related to bow_target is found with below log:<o:p></o:p></span></p><p =
class=3DMsoNormal =
style=3D'margin-left:10.5pt;mso-para-margin-left:1.0gd'><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US =
style=3D'font-family:Consolas;color:#0070C0'>[&nbsp;&nbsp;&nbsp; =
8.935429][&nbsp;&nbsp;&nbsp; T1] kobject_add_internal failed for bow =
(error: -2 parent: (null))</span><span lang=3DEN-US =
style=3D'font-family:Consolas'><o:p></o:p></span></p><p =
class=3DMsoNormal =
style=3D'margin-left:10.5pt;mso-para-margin-left:1.0gd'><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:10.5pt;mso-para-margin-left:1.0gd'><span =
lang=3DEN-US>The call trace to the preceding log is as =
below:<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US =
style=3D'font-family:Consolas;color:#0070C0'>dm_ctl_ioctl<o:p></o:p></spa=
n></p><p class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US style=3D'font-family:Consolas;color:#0070C0'> &nbsp;-&gt; =
ctl_ioctl<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US style=3D'font-family:Consolas;color:#0070C0'> =
&nbsp;&nbsp;&nbsp;-&gt; lookup_ioctl&nbsp;&nbsp;&nbsp; // returns the =
table_load function pointer<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US style=3D'font-family:Consolas;color:#0070C0'> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;table_load<o:p></o:p></span></p><p =
class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US style=3D'font-family:Consolas;color:#0070C0'> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-&gt; =
populate_table<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US style=3D'font-family:Consolas;color:#0070C0'> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;-&gt; dm_table_add_target<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US style=3D'font-family:Consolas;color:#0070C0'> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-&gt; =
dm_bow_ctr<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US style=3D'font-family:Consolas;color:#0070C0'> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-&gt; =
kobject_init_and_add<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US style=3D'font-family:Consolas;color:#0070C0'> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;-&gt; kobject_add_varg<o:p></o:p></span></p><p =
class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US style=3D'font-family:Consolas;color:#0070C0'> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-&gt; =
kobject_add_internal<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:10.5pt;mso-para-margin-left:1.0gd'><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:10.5pt;mso-para-margin-left:1.0gd'><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:10.5pt;mso-para-margin-left:1.0gd'><span =
lang=3DEN-US>Compared to kernel5.10, then I found it&#8217;s related to =
below patch. The gendisk, it&#8217;s not registered yet, its kobject is =
not in sysfs, so its child &#8220;bow&#8221; kobject cannot be added to =
the kernel.<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US style=3D'font-family:Consolas;color:#0070C0'>commit =
89f871af1b26d98d983cba7ed0e86effa45ba5f8<o:p></o:p></span></p><p =
class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US style=3D'font-family:Consolas;color:#0070C0'>Author: =
Christoph Hellwig <a href=3D"mailto:hch@lst.de"><span =
style=3D'color:#0070C0'>hch@lst.de</span></a><o:p></o:p></span></p><p =
class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US =
style=3D'font-family:Consolas;color:#0070C0'>Date:&nbsp;&nbsp; Wed Aug 4 =
11:41:46 2021 +0200<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US =
style=3D'font-family:Consolas;color:#0070C0'><o:p>&nbsp;</o:p></span></p>=
<p class=3DMsoNormal =
style=3D'margin-left:21.0pt;mso-para-margin-left:2.0gd'><span =
lang=3DEN-US =
style=3D'font-family:Consolas;color:#0070C0'>&nbsp;&nbsp;&nbsp; dm: =
delay registering the gendisk<o:p></o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:10.5pt;mso-para-margin-left:1.0gd'><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:10.5pt;mso-para-margin-left:1.0gd'><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal =
style=3D'margin-left:10.5pt;mso-para-margin-left:1.0gd'><span =
lang=3DEN-US>Is this an issue? if it is, is there any patch to fix it? =
if it is not, then what is the right way to use the bow_target in =
userspace?<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Best Regards,<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-US>Zhu =
Faqiang.<o:p></o:p></span></p></div></body></html>
------=_NextPart_001_004B_01D82751.E8CA5CC0--

------=_NextPart_000_004A_01D82751.E8CA5CC0
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
KoZIhvcNAQkFMQ8XDTIyMDIyMTEwMzYxNVowIwYJKoZIhvcNAQkEMRYEFId4o8hBtlc3MWEJHbX3
IulWl8CUMIGTBgkqhkiG9w0BCQ8xgYUwgYIwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjAKBggq
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
AQBpLGXfekrUobLdJ+niw9BCMQKs91G6oD6tHVZOMm/LULM2UbTgIEwtmqy6votiAv4FMzUqNK+7
ycBKrkcALYpt7vKmajKcO68uv8bJyTOmTQqb5up/Jh4vOze5chmm0ZcZTPVx4ICFLZCltWBXAq+7
VYFlxci4DLOh6mSbwKcd/geF6XaxyfT7MiglMYCNbP8ZNxB/dPAYU/+kiyVshONJZYC3Rh4JTRb+
scc2hlMgN4wJiBVsxqaLMj7fq4UsEBcBfMaMbj58/cNyN8aDlC6bqAWtn4gSC+NaylNBpKjNfTRE
OYa+ggiNwVww8aSF4Ugf7uEDZ6bJLTLiJMOkwyU0AAAAAAAA

------=_NextPart_000_004A_01D82751.E8CA5CC0--


--===============0471404713867487893==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============0471404713867487893==--

