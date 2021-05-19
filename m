Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CAEC4360C
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 07:49:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A49F060FDC
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 07:49:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A49F060FDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-TIAE_0r7NHGHHkH77ZYkjw-1; Wed, 19 May 2021 03:49:29 -0400
X-MC-Unique: TIAE_0r7NHGHHkH77ZYkjw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44A65107ACF9;
	Wed, 19 May 2021 07:49:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BD45687C7;
	Wed, 19 May 2021 07:49:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AA95D55347;
	Wed, 19 May 2021 07:49:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J7nKm7023539 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 May 2021 03:49:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 62194103403; Wed, 19 May 2021 07:49:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BF02103401
	for <dm-devel@redhat.com>; Wed, 19 May 2021 07:49:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3CBB80D0E3
	for <dm-devel@redhat.com>; Wed, 19 May 2021 07:49:16 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-16-YY-YftK6NB-f_r-TBb8xAw-1; Wed, 19 May 2021 03:49:12 -0400
X-MC-Unique: YY-YftK6NB-f_r-TBb8xAw-1
IronPort-SDR: U1V/dFF6sdnYgBnpsXIlnt5xr5HEOU0aMn7xR2i44W0nii6LiUCSE147rg73vkDi7eQIsB+gjd
	M1hd97QUG7zJyc3CXLvHym+sCPO3hYhdAm4/cuvNmnljgILnqDcT6FzLYiatKvnWE2+DcCOH36
	zxPNU6E6n6t/lZpoaGEApnAMhfg4LdhoPpcjeFKW+8b/OAQLCWwOo5Y519ComF0SeLQMKmoapY
	1RXZEbXZODu0oucjtApae/AgWNMw+C4cUx8edlPqymCWm2+YDbKLDEil55+67F/JmCoECjMaFo
	yJw=
X-IronPort-AV: E=Sophos;i="5.82,312,1613404800"; d="scan'208";a="167979349"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 15:49:11 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7142.namprd04.prod.outlook.com (2603:10b6:510:c::7) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Wed, 19 May 2021 07:49:10 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4129.033;
	Wed, 19 May 2021 07:49:10 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH 07/11] dm: Introduce dm_report_zones()
Thread-Index: AQHXTFp3R26QKya2S0yqO6KcCDwllQ==
Date: Wed, 19 May 2021 07:49:09 +0000
Message-ID: <PH0PR04MB7416A5E5DE88C39F66FCD3689B2B9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
	<20210519025529.707897-8-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:152f:cc01:95b:718f:422f:1ec2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b28d42bf-d97e-4f7a-65b9-08d91a9a9676
x-ms-traffictypediagnostic: PH0PR04MB7142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7142961E3359957127DD67659B2B9@PH0PR04MB7142.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: plvZ3txuHTUQjS1UVz/B8+bz3YM3qB8PzA0RDoYHUw0Fm75V7O5er7p395C3oQU4KiM7vv2vlowXn6QiWSkAq6mu8p4/4qoQwzIs3qJKX4ZoVXQftjZLttJ0oGKyIeENKMdda5UWMNoGh5IGIy7grrww/Py4K3fbMTl6jfufaFa4AZRxScjh6ac6bHLo+QBUZRUMY8Us/YlFfDJ6Pju/NxbiTo4u8tOhS3LGI5kk0BIKVSwRuWxnfHkpnVhLRlHHUtHRWbO69Z8FSCnadAftZo8S/TCwBtaDMu64UUa7RrKl+5vbwv6JlhfpDNZAj3qBlIiKmtBSqAdQXz7XcQDZ9dedwNx9MhxdSEBfCTqbahW2bEgfCj0Y9IHsTh1qz8FvoKJfuvaEHhyW4ctDRQnuVdyZ/wAdenb+o9el76xcw4r2V/FY/nPqF2f7haa5/pl3ujNhCK9XThpnhVPOBbBYZrwVW+rEbyCGVDNm/K5oCIriJk76CBNW8Bj5gYiws3tZaV9lZiAxkxz1hKhL6ZrUonxn87M1z0QBwhzOEY+9grOzX4uiHh0G6fshGNd6QgDdKaWeUJTR6uzEyPBrYC1oCwHWL4IrXEI4x2N1ZBLPFqA=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(396003)(39850400004)(136003)(346002)(366004)(122000001)(8936002)(19618925003)(558084003)(52536014)(38100700002)(6506007)(110136005)(8676002)(86362001)(316002)(71200400001)(33656002)(478600001)(55016002)(7696005)(2906002)(9686003)(4270600006)(5660300002)(66476007)(66556008)(76116006)(186003)(66946007)(66446008)(64756008)(91956017);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zGSMPtd3ubFiVD/WZrnc5vKu0Ln5oVlTa2RZSCKExNPnQscPfXztRr3M6z1W?=
	=?us-ascii?Q?ykfHP62rpyDSHQZGTx8algotT7/GzBtk7kaKNHHmcM+qRueFs/l2YPVOixES?=
	=?us-ascii?Q?vTRY4Bnw8Op+mcqhrS2knv+3xlCq0ikRLkzLzXvFEchdN1O/PmZOMNJfrzfu?=
	=?us-ascii?Q?USZCjuIg3tz+SmviJoO0bZ6bnJHVpu9/+2xzk5Vo4CmuSaciuWWYH4hZJjY4?=
	=?us-ascii?Q?Yn5wa6M3rfmWnxWW58VNRltoIjbddEm7FLhXJwNrxpCLQgd/3wSyD7rlLisY?=
	=?us-ascii?Q?Hk1fKe0cw4HuhaWIFJjwBLLTcxCeusgaBtyELMXeE8kxn7sMODDe0rm4Jq8R?=
	=?us-ascii?Q?Eqle/uGrGjDJv/XyYjFjwYyTK8CJzjFEGVxktLZ1tpCcRagI0t0+lVt+QQXg?=
	=?us-ascii?Q?npJcf2Pe4sSlx7V/QlGC52ocd+qPQunpfkGBw3FgzE+XsT1jK2vScmTX9TjM?=
	=?us-ascii?Q?/9OI250cs9bZ61e70wVD33+MS1waUF4bU+V5mHszjzjlN//uiiySb/UaoAEk?=
	=?us-ascii?Q?61bpPT/b7kANH5QlxuHyuxJwLrdJflQSNr+W0QeXa6V2ONA0x7Yon1VVgMKB?=
	=?us-ascii?Q?r5hWty2agy9Tq63Yp4Rmea8AVKI2tUirxi+VnTMlkSZq5o0RzwNbDH0Kecnp?=
	=?us-ascii?Q?G5ADXGOGjp6IHVu63+dKzYd2igkVMOlZiX3wC396ecc0KfV5gsQwK87yt2r0?=
	=?us-ascii?Q?NjBYsCeW7uQw5IbGYH8UKRWU6RYUJDxLdTFs7cFeNqEgPBxM0XYKFbEPXexB?=
	=?us-ascii?Q?6a5+Ot08woZ/O5t0M4hM4ztlXRLJ3VnL5TUvsaPK3ngS5bhhuZwJ6WYyUap1?=
	=?us-ascii?Q?GrsiQz0E51sVoPcOYhdq0OVo1mGZgzZEXM8ebVELtdNAxU4FAXyCmh7ZbNs6?=
	=?us-ascii?Q?dEPr1DkAzQPaUirFYO2LPjJNiu2upIYpZUJ9xhm2R+v8lqjk87UgtmZgh43p?=
	=?us-ascii?Q?GKbTWyj7RbH7/3oBc33M6lcmZjPy+so1S6jbL/OQEcH58yLwgn9EAC09HLNA?=
	=?us-ascii?Q?CNXmXk/LmwdR+x/8lhJEFWiC8r7YhGKuCiVucwEORnQW/adrLb+HyQPNLwAZ?=
	=?us-ascii?Q?Wyh3xLHKyfIjkfOyChgcWxpdCTsYk0GhJkQT2MWhLfIfuSSS/fuehoOyKlCw?=
	=?us-ascii?Q?D/t3PY5DwM2zYTOYUkF6Jj8YXCaD2MJBQTInXe/QABkcPceVRAZtdFkkQffE?=
	=?us-ascii?Q?uull7sa2TcBp2VJ6HQWXow88OR/9n7HHXZ/D1UiX8NGw6+pESGgaTyO0VDfq?=
	=?us-ascii?Q?nKYE3RdzVTRka89CURFs2sKJi4fnbhMt9V1PY2VRup2iQ1YZZ9j5rYhpvNLK?=
	=?us-ascii?Q?bX5p6RylxmStfV8nf7PuoI+dlfpFV9Y00/WrEVNUZNcH5M4uT4KFmyY50016?=
	=?us-ascii?Q?h6ps2O8WH58+1UNo98VFd1CKAeeO9a582C+C+er7L0Lc3KvKlQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b28d42bf-d97e-4f7a-65b9-08d91a9a9676
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 07:49:09.9510 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: adWBpLN89lq68FQscI6ARgZrQwb7Szfs+wWZtZOjzOdH+Wu3wKjUXvastZGs6JQtMrfAz/d8jmwudE61gqSI4FrNYNhbseCi/moJhiVuZDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7142
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14J7nKm7023539
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 07/11] dm: Introduce dm_report_zones()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

