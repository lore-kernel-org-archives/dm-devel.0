Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40A2C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 20:38:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 53AA461267
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 20:38:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 53AA461267
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-WNtzauoQNFeMvc3G2oorVw-1; Thu, 11 Nov 2021 15:38:45 -0500
X-MC-Unique: WNtzauoQNFeMvc3G2oorVw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C8801922960;
	Thu, 11 Nov 2021 20:38:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C69E16784A;
	Thu, 11 Nov 2021 20:38:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9FD604E9F4;
	Thu, 11 Nov 2021 20:38:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABKccUP007505 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 15:38:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1E9C3404727C; Thu, 11 Nov 2021 20:38:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19E964047279
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 20:38:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02FCC801212
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 20:38:38 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-118-kytXlNuKOVm6uX8fKwrM2A-1;
	Thu, 11 Nov 2021 15:38:36 -0500
X-MC-Unique: kytXlNuKOVm6uX8fKwrM2A-1
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2050.outbound.protection.outlook.com [104.47.2.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-15-Ut4g8ZJGPMuixJgshr-Z9Q-1; Thu, 11 Nov 2021 21:38:33 +0100
X-MC-Unique: Ut4g8ZJGPMuixJgshr-Z9Q-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB6473.eurprd04.prod.outlook.com (2603:10a6:10:106::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Thu, 11 Nov 2021 20:38:33 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 20:38:33 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v3 7/9] libmultipath: deprecate file and directory config
	options
Thread-Index: AQHX1y2J0ZeDeFaMWEOC2/wDa8Pgj6v+ydMA
Date: Thu, 11 Nov 2021 20:38:33 +0000
Message-ID: <2eb254e1b1393a75dc486bda8527e79e66ce3ac4.camel@suse.com>
References: <1636656832-26062-1-git-send-email-bmarzins@redhat.com>
	<1636656832-26062-8-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636656832-26062-8-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc01c3c0-e533-42d1-eb99-08d9a5533a78
x-ms-traffictypediagnostic: DB8PR04MB6473:
x-microsoft-antispam-prvs: <DB8PR04MB6473F01E5515EC5BD321B4FFFC949@DB8PR04MB6473.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: jqLUyNvzG19nWBJBd/tnWLBHT6cNUOWjkA/GhZIGRFWv/SQpjMhU2hPcTOllzQnIm759beRUEjRjmDlMWyAdw0nsZV/0z/ZjB7ackviK+QUYU4EUeLW3CKetYj2MXeB+QjaftcDO8eH8kLoH9At2KZutp1/1HRsJS8YnqBxHbmfJ4DAt2Lj1tdVlExDmpkQMGUOQ4e76Jagrc524qvDRyfZN16yOSN+pzU4ozEYQq8lwnZUpq/JvbS3clc9rxqUXKf5ZhuXPjZnIxgasqEiHFNqZHaN7k2yYigPAzacqaVaQAnvlDBlgYmMQceYZmypvfkz6eOEzSOAq+VvA7T/QZlMNTOSA7xX2fHTYOTZB0WyeYU3+Q9HdqPAMlSkBCjDVkhSWqgfcpfx4uTDEyV6D3ixnT2hUMoKpbCebHzSqUfn6SmD9+kAjvtMsqbYFLsdstp1AE3t1evzOL01s15nN2SgZweKwHPc79mFriu7wZUWriHSerbs7Ti4Pp2uf3jY87hL++uy5mX2mLU1KKPQK/1AzfT4Y2eTnMWHcXIQ9ND/HHbMsSdcO0OZPvUOOM6OuyBkfeQnhwxN06MoBI/2Ab8qraGoycYj2Nzwg6EQIktWEaam1w5F/OIX78x0dPSs0Y6AJQYmS8PFCMPirUHBKJRmRJPaVi8NLZ7o580Ej78woo5WcqQyD9S4opWahfnts5MQHDzURMwztyay9CGKz8Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(508600001)(38100700002)(66476007)(66446008)(86362001)(4744005)(64756008)(38070700005)(122000001)(6486002)(36756003)(66556008)(110136005)(76116006)(186003)(66946007)(2906002)(4326008)(91956017)(4001150100001)(316002)(8676002)(5660300002)(2616005)(26005)(44832011)(71200400001)(6506007)(6512007)(8936002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?rFOqbHDxmQtAx3rZPYxRnV+Q6OHkqLg1hp+eAK7MfzWd6RAsdI6BRQgex?=
	=?iso-8859-15?Q?ywTobNdnKvee95KlHOsQ4RRLyn/oNKiRFx0gI5lHgZbFRPiShCSZqUYRJ?=
	=?iso-8859-15?Q?n6x5sNnkhukFqz2QjkzH52zyiiizAVr/WRg6d62UCU+A1Z0oUIk8glzNw?=
	=?iso-8859-15?Q?kQvBs98vU3svyc3R/CCvYgyc/E7ZsEQ9M6/XATWFQjiV/p2Ch9am+QlIJ?=
	=?iso-8859-15?Q?HlCEUCMBgFSmUUn9/EKmO6fErcp/BCI6J5cL/ajCH3SwmLoTAPKFvFsql?=
	=?iso-8859-15?Q?NbuUIAW95bfxuo9y+YR4n1UDmSRbh40xfv/oLXEpTeZ+SsWNyWh9p5i/m?=
	=?iso-8859-15?Q?wDG+/TFA4NoFoV9W/5TN14E1d27Kx+RVSuLrA4+3gFObfhuQ7+8pMHTzF?=
	=?iso-8859-15?Q?QvM9IvOxK7U4ScZwdFumSpWkP0joiNgzlCP++ksiS+vVnbLnyBt7Bc3W2?=
	=?iso-8859-15?Q?zo6aGKeKTKr3r+N+Tr9hlEh2uBMgU7fiPnNp7yjbRnFIx/oh2Bt14j/Gu?=
	=?iso-8859-15?Q?evppg/fN1oB6lulXNm+tZWRoox4HlsFqjX5UWPQaI5Uv/covKt4IIcQp4?=
	=?iso-8859-15?Q?AvuDTsIbkDShI2kBohwjhT6BhDvgSdk739oMQ4UkeDAxrd5/+eHs5s1KS?=
	=?iso-8859-15?Q?cP4vhckzrrEavTi90X64zqSbGONJ4nDcTYO/sFRdht8T13lS6p5KdXgT5?=
	=?iso-8859-15?Q?1PMYcCyXGtYqTnm9fCPOyxRPEKiPtJ3Pplbcpm4CS5fEbj1vR/6SKAE1v?=
	=?iso-8859-15?Q?Tfx6ahK2EG+qCvk4URyFyWAnf5u1t2AnFG7zTI9xVJ8EcP/ag4Ypxwy1C?=
	=?iso-8859-15?Q?lxBxZoJcr883EnUxycSUlDRiOnawZUcLE/7PtIm6b0HObmBI5qjfrnPiA?=
	=?iso-8859-15?Q?Kqeq/yRlRkZxoigTtPo0WpS3TSe5k0E9G/AKfSh1ueHeFDHCojdDcQdqp?=
	=?iso-8859-15?Q?Y/hzSqp92XQfMcQxsPH7HPsALOqncNbKtInp+A0YgcqDDehBuwBp0Ak9k?=
	=?iso-8859-15?Q?J2ELRJzO9gLjMqqGW514mx/CqGA+kkgByjHipDbg5Y6Bxt/2YJg1x14Od?=
	=?iso-8859-15?Q?7qWCKQRErkxWkWud/34rqg5x+JJ4tNj2TAu5O6A8lBSI3UYNWyg0Hec6s?=
	=?iso-8859-15?Q?ZeRxfPFGEYkEQDw/9SuS3k+MLZ84w+iYXnc2yVc+6XlYJMASWm7+L9gVR?=
	=?iso-8859-15?Q?Vm0pk6wSAxrIRbd6FKp/ojPvt12WkLu8RhQMH7hI6RQ43XunWqv+8uR01?=
	=?iso-8859-15?Q?3duZ9yeoI5qjW3D9tFY43nypmkMRhVNMrSGPcLMnziJ95IkpbPh2OvaG3?=
	=?iso-8859-15?Q?Rf5PyC+Q8PQ/zgBxvXC5b7K97II4Kvozt3Yc1bRfQlbaVekFIjuENOoOw?=
	=?iso-8859-15?Q?MwbPqEVJbDviG9VKqB494AeDuDkRmuz0SiRYZ381WMvz1pCcMDLLTHl5a?=
	=?iso-8859-15?Q?BOZcojEkLKI3LgBTlGCmLS/4juc2NboIf3Lf6aXbbKeIygDJnyaIqJmUO?=
	=?iso-8859-15?Q?swKbZt82Wiw2hDjI20nf5K48b8iSIwlQBeBaLLVe2I/WCc/qHERw/qnNB?=
	=?iso-8859-15?Q?wVw7OP+RWCEUczMVlpNPwczhS0Kdb7LukiQwg+CSzTsuJcsoVnia/yt9S?=
	=?iso-8859-15?Q?NB6vEzbLuZFlnpPORMpMIYu3SxcI668fVpfmFq8n3dwhQs/Qtbxs2PobT?=
	=?iso-8859-15?Q?ExPV5tyEG4huR/QK7LQwhfRDU7L4cPEwKw++amwqCppUu/A=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc01c3c0-e533-42d1-eb99-08d9a5533a78
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 20:38:33.0608 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YJ8ObnNzExl7clUC5uBNrk46kR+OywjvK5Ub3qMBjdvvbajgPYXvXBPihUM/py5mk3yTRXUV/9RONry803dKyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6473
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ABKccUP007505
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 7/9] libmultipath: deprecate file and
 directory config options
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <98FD7B0CB385D84A834D882F033EC68F@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2021-11-11 at 12:53 -0600, Benjamin Marzinski wrote:
> Having multipath able to select pathnames for the files and directories
> it needs causes unnecessary maintainer headaches. Mark these as
> deprecated, but still support them for now.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

