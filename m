Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D327FC433ED
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 07:36:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3DB9161153
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 07:36:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DB9161153
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-nptQAWOdN0GSSj-gH_1Spw-1; Fri, 16 Apr 2021 03:36:24 -0400
X-MC-Unique: nptQAWOdN0GSSj-gH_1Spw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD8588189C6;
	Fri, 16 Apr 2021 07:36:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9723562690;
	Fri, 16 Apr 2021 07:36:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 393821806D0F;
	Fri, 16 Apr 2021 07:36:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13G7WtIY022256 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 03:32:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8DD95FED2B; Fri, 16 Apr 2021 07:32:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 872FDFED2A
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 07:32:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B7B185A5AA
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 07:32:53 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-450-2xsUnLidMoq9SiOA_WInZQ-1; Fri, 16 Apr 2021 03:32:51 -0400
X-MC-Unique: 2xsUnLidMoq9SiOA_WInZQ-1
IronPort-SDR: FAKrQDSf36ag+RfeQod415beWzFfpxvtEq63gc8V1iKXt4jRdA2mCyNfqEFH94Pc7c1qeC1oOO
	xN5/eObe+iErzWyGFdIxNX4DILqsW65iM8Td4N+ay4LBxLk4Q9WGUZVQql4QgZQfoIl3V8hzgL
	jSZ7Lx2pkxq+gZt4rj+bRTvxDS+tQ3YAHa+R/ee89vKYE6bOO+Vbvwo74KTL7pJc9IWVARnsQq
	XoAVWqMzFXpoSVv3ymxUTJ+t3V35MvK2Jycu0payzjEYExv4OCIqx6w5vbDRTvZZ1NQE+AToqU
	K88=
X-IronPort-AV: E=Sophos;i="5.82,226,1613404800"; d="scan'208";a="165620708"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO
	NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
	by ob1.hgst.iphmx.com with ESMTP; 16 Apr 2021 15:30:35 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6415.namprd04.prod.outlook.com (2603:10b6:208:1a4::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16;
	Fri, 16 Apr 2021 07:30:24 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78%3]) with mapi id 15.20.4042.016;
	Fri, 16 Apr 2021 07:30:24 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@lst.de>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
	Petersen" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik
	<josef@toxicpanda.com>
Thread-Topic: [PATCH 2/4] dm crypt: Fix zoned block device support
Thread-Index: AQHXMm1hiOyme3G/H0G7ONrrey5MQg==
Date: Fri, 16 Apr 2021 07:30:24 +0000
Message-ID: <BL0PR04MB6514908FACBF6A34D8A085C9E74C9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210416030528.757513-1-damien.lemoal@wdc.com>
	<20210416030528.757513-3-damien.lemoal@wdc.com>
	<PH0PR04MB74165367AACA8F3D9F7B023A9B4C9@PH0PR04MB7416.namprd04.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:c420:851d:e64f:2199]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42bbae3b-f10d-4685-2664-08d900a97fcd
x-ms-traffictypediagnostic: MN2PR04MB6415:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB64151808F3F2350F284D5D0BE74C9@MN2PR04MB6415.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: P18iKaewacv+Wa048lgjHjpiyEoKrS3dPIanCi20jjc4sv9RN2/XgIk535GD+lZdOdmcZBhwyyHvbtw8HFVc5dZP1OnOIYgHWf+bghw5ClrYGUaT0VBuwkis2UkeRZ5F4LN7BXmiq+Vt2bj15OWgYD+/I6ntz+akpF/Ui6cgDoYrT0EX6J9XUeZaL/UKPTTMRWm7fEFo1QAlxHdtxdXFDPec2A50pNthjHOWzidaIq2yAAfHyY8HsDX5sgMc2nCDi66nTbsTzSNard4F4fEioY3TFtTb53v/19VMce7o2feU0580R2CB5TjTLdP3xsgkp5m530lA8etvHjYGutrq4xr7pTRYR3C1yYLMJkvR8Vrzfm9qY4MlooQye3ryMynoZY8lYDmfJVW6M01JYeqnoKSzAKfqDhC0+mAQdHiqgn9cZNYxDYVcFVEy1TFz3Hij+0UaK1AN56WNLl4FKA+c0hBj/L9O0S9bHi9BsrBGJTUkHtSdn6E74PymzR7ujJIOv2qpqIUdwzpa5pAtAHi+EKN+SK/YnCgcZrXXv4X5HRCG0GOMGOPuyvi3L49DkUD4T8U5zGLsg5HGdQ/v+f2OcsBVmHXQHAbCRR079eU+z1PcuIGZ4jQsxmKzQQcm4No5NOT28TFwT6yc2DvwCAP3ew==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(7416002)(8676002)(478600001)(66946007)(55016002)(2906002)(122000001)(921005)(316002)(186003)(9686003)(110136005)(8936002)(54906003)(66556008)(86362001)(38100700002)(76116006)(66446008)(91956017)(33656002)(52536014)(4326008)(6506007)(7696005)(5660300002)(71200400001)(66476007)(64756008)(53546011);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8L67xb8/47Ji1HC8CpbkiVcAmN9mGBIwwEkWDnVuRyIVf8io+YDRKNJrbpjI?=
	=?us-ascii?Q?ILqC5rNE9glZBV2tUnMDJupaSTdlJ+zywtnQrLhXQr9NwGG6X3B3jqfpV2N7?=
	=?us-ascii?Q?8BIvzT9zF7Td+s9rA1FLstFIUvpFV6kDiJ7wc6gWOBp/c8/g4TZnDGxjl6PZ?=
	=?us-ascii?Q?B9so6HyM0N6DDRDC0nFS3fcCcl2vf1gwbxlCp4SzDudJPh3GbQY1SAMYt1o6?=
	=?us-ascii?Q?dHas6AzSOvcG+AKfgHVX3CHCsjyLaBLQ32vxH6V8H3AlEB8HcXDyqll5OuZg?=
	=?us-ascii?Q?cCUOQuJYjskvkL41/foTEjh8lBC1dM581rsOKGFoKYYIsCu3y5D25xPJc5IS?=
	=?us-ascii?Q?m/holDsu07ZFRlGHHwWxFeNALm7xH+hvE6AfajkCi3Hdp98zUx5n/xYSN/0z?=
	=?us-ascii?Q?Cy+OAAXWXLpahmBoU01cR3eUqigzYqdGZMqEBUeRNfH4aVHdQ2kCybkxNUcG?=
	=?us-ascii?Q?hezu2XADOQKJ/MlslIBAf3uQXXg1j4zNMy/lmhqLuL9McH+ls6Ujnml/jUhw?=
	=?us-ascii?Q?ErOeb9iPiDowMa47inFb1mCFsf2W5lRsE1GHlUG3EjMiJ+ct/AnDtGPLoadS?=
	=?us-ascii?Q?OjXVMgse8q/iOzFCoo7lN5HLhjnmg41Lwx8Y+ArAotyvwpw+d2/YtyCu0wht?=
	=?us-ascii?Q?tWJSECJnb2Cs5TfYDdsPsewvjekwtljbCCqlMthZiFJuVOh6HBF+UVqDq+39?=
	=?us-ascii?Q?OBwBRhStQLHkEhwPl9FtUKNxnripgL4G7yJ20afOycgnMhMzVsK7dMft4CNZ?=
	=?us-ascii?Q?6qjahg7wWjdtCwYNu8H+mAWCY0gl9UUcLuw+dyWoXzCJwKGBCerFU12S52xz?=
	=?us-ascii?Q?slj9RhCR2QngN5ipnqV2pNkoN1tAhkmMAi4LS5v3jGC98cyhVCQF6SwZNjLe?=
	=?us-ascii?Q?kiHEtCDj1ZVp6BA0tq0j3jgOZ2wFLu4B+nX7fgKNM4NEvh2ZJ5OztoSlIHVM?=
	=?us-ascii?Q?0H+Jo+Aj9xpfYrDUeTB10Oli9b+drvfumBAG9e3y6Q2hVWTeK6b2oiIi8/X2?=
	=?us-ascii?Q?0HZqOWV8iZHP1MTVVDCwN/Zl/+kD2kiObILvqYZ7FR8MtY/KptgDyQ/ii6M4?=
	=?us-ascii?Q?Hq7zS1xMqiY0BPX48T4yGlEJL7mVwkW3K+cHCw2DPApUzI9DBSVdi2VtzuSX?=
	=?us-ascii?Q?xhfchVQKilReovZzv/Jy5ppUaw7C4VsjrzYPI+cLbQBT0+LBU2YtdJD8QXFg?=
	=?us-ascii?Q?u0AArXt8ykybRJlLoUr4+GSs3TMcVUG0LWRH+WS6pz6bEfrFfWGb7RXTleT/?=
	=?us-ascii?Q?sSO76qh07m5n6BNKS38+jwOkqBd6nzm+DvKKH1MPnlrEWm5pfrncQoavdUha?=
	=?us-ascii?Q?O0HS7jdsi5L4XRnoXNzDnXQhHd1AULIVbhvllGbJ+55mqaKVFLOG9eGqgBRo?=
	=?us-ascii?Q?HNYcBAU0cNKelmIUwiadFopj2wrw1QphCSSQB5FWNmB8vhSdng=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42bbae3b-f10d-4685-2664-08d900a97fcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2021 07:30:24.2025 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eTPsBRoy3VXyjOKoQmWqeek45ohboElu8YdvmwxtejOsvB66/jyz2nZWeDcfdGUYJOvUlPCV34A7dWRPNk83Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6415
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13G7WtIY022256
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [dm-devel] [PATCH 2/4] dm crypt: Fix zoned block device support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/04/16 16:13, Johannes Thumshirn wrote:
> On 16/04/2021 05:05, Damien Le Moal wrote:
> 
> [...]
> 
>> +	CRYPT_IV_NO_SECTORS,		/* IV calculation does not use sectors */
> 
> [...]
> 
>> -	if (ivmode == NULL)
>> +	if (ivmode == NULL) {
>>  		cc->iv_gen_ops = NULL;
>> -	else if (strcmp(ivmode, "plain") == 0)
>> +		set_bit(CRYPT_IV_NO_SECTORS, &cc->cipher_flags);
>> +	} else if (strcmp(ivmode, "plain") == 0)
> 
> [...]
> 
>> +		if (!test_bit(CRYPT_IV_NO_SECTORS, &cc->cipher_flags)) {
>> +			DMWARN("Zone append is not supported with sector-based IV cyphers");
>> +			ti->zone_append_not_supported = true;
>> +		}
> 
> I think this negation is hard to follow, at least I had a hard time
> reviewing it.
> 
> Wouldn't it make more sense to use CRYPT_IV_USE_SECTORS, set the bit
> for algorithms that use sectors as IV (like plain64) and then do a 
> normal

There are only 2 IV modes that do not use sectors. null and random. All others
do. Hence the "NO_SECTORS" choice. That is the exception rather than the norm,
the flag indicates that.

> 
> 	if (test_bit(CRYPT_IV_USE_SECTORS, &cc->cipher_flags)) {
> 		DMWARN("Zone append is not supported with sector-based IV cyphers");
> 		ti->zone_append_not_supported = true;
> 	}
> 
> i.e. without the double negation?

Yes. I agree, it is more readable. But adds more lines for the same result. I
could add a small boolean helper to make the "!test_bit(CRYPT_IV_NO_SECTORS,
&cc->cipher_flags)" easier to understand.


> 
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

