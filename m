Return-Path: <SRS0=qgW3=JQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4939FC433ED
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 07:10:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BC5766101D
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 07:10:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC5766101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-XTAkw7B0PECeEwDpejF7rQ-1; Mon, 19 Apr 2021 03:10:09 -0400
X-MC-Unique: XTAkw7B0PECeEwDpejF7rQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C9316D582;
	Mon, 19 Apr 2021 07:10:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D9B5A5D9C0;
	Mon, 19 Apr 2021 07:10:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4091344A58;
	Mon, 19 Apr 2021 07:10:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13J79vp9016194 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Apr 2021 03:09:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B5CAB206355C; Mon, 19 Apr 2021 07:09:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF40B206355E
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 07:09:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 053A0185A7B5
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 07:09:55 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-543-SCdV-NtAOw-LH8r2yvF6Sw-1; Mon, 19 Apr 2021 03:09:53 -0400
X-MC-Unique: SCdV-NtAOw-LH8r2yvF6Sw-1
IronPort-SDR: +xuvU/rtfcRuqU0OMBeFA1nirGvFQs9iZ0YZH2uLQ58eOHdeFyRzaAbwT4z+KxnJRWK5TN19tt
	g+vJW7/aLRONu3a6SQYePLwj17gYm2lDQ7HzAY9xTrqldXq7/22hfy6JvK+LhF4ngGh9OhdoEX
	K38M1MWt+WExIPn0B144+gMDwkyp6kwzmJ7ZJ7H3r6soVgyaTdfvXWxk4axaThviJt2fzsKkjJ
	mSiI2MQOqFnILIAbrfy/ePa0gklmqRPTQDfPurhi5SzOIeF6yZWL0lD0he3SoXmHdO/6MU5ipq
	F8Y=
X-IronPort-AV: E=Sophos;i="5.82,233,1613404800"; d="scan'208";a="165419531"
Received: from mail-co1nam04lp2057.outbound.protection.outlook.com (HELO
	NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.57])
	by ob1.hgst.iphmx.com with ESMTP; 19 Apr 2021 15:08:48 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6976.namprd04.prod.outlook.com (2603:10b6:208:1e7::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18;
	Mon, 19 Apr 2021 07:08:47 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78%3]) with mapi id 15.20.4042.024;
	Mon, 19 Apr 2021 07:08:46 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH v2 3/3] zonefs: fix synchronous write to sequential zone
	files
Thread-Index: AQHXMzIUD8ZVvai2c0OhPeRaKpo++w==
Date: Mon, 19 Apr 2021 07:08:46 +0000
Message-ID: <BL0PR04MB651477B7ECC57FA61E1C99EFE7499@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210417023323.852530-1-damien.lemoal@wdc.com>
	<20210417023323.852530-4-damien.lemoal@wdc.com>
	<20210419064529.GA19041@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:a0c9:53b3:13f2:51e7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f86fe9a9-8d30-4847-382a-08d90301f9b2
x-ms-traffictypediagnostic: MN2PR04MB6976:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6976D230A4AB487D3A6C0957E7499@MN2PR04MB6976.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: TG8uOKdGnE/bFcg0zYj0ZBG5vXINOG62B834mCCMhPSgvNJGkSlOdeCa+JmH2V2vOI5l127p+8U9FB91zH6xhdHp2jQwYBf16hu+KC9ERSV8r1drLElveV/mRWApBIeFDQ5gX0OeIN8rvB5zjh3KcwaBhQRzwwnvoefV0xHLK6YV9vDPaHkPZEJ092bijb5te2+0hiREEfIryueQI4kfYjUU4PaniTe3Hxwb0x/8PzJbFGgqSgybnuRvHipBVfmseSs59AZKibYrou+Ys8SQG/kVA5ZQ0UM+oBL9l4yl1ZZG6e7l2U+9rn73T9pJQ4ST4caOcm42k8eX5SdpqetjN/YflzauWYUHEexerbFl9LgrwmHcqKTO4GPqXZkK2YTLRiVYW3HgrtNEfgyFda5vtm0/nVYthvzOxhCtZeBAfmklc/e66Ccqmy4gNthUNm952uYUGjnlG6qEvngD6fVwkbhrOS5bkyREfGNnz4PkwrsOE+ehpSJ+KHjXR1Vs4res4w8TxUoTCVu4FIDJs+5dkmp4FRdE+J4iZll51fi/W7jsm7DphBwkmK1msJC7kx6N7KgAqERqXDxYp6Ji97dMym3XCIYZEUE83IoXRX6Mr4g=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(53546011)(38100700002)(6506007)(9686003)(66556008)(316002)(83380400001)(5660300002)(54906003)(8676002)(76116006)(52536014)(8936002)(122000001)(33656002)(2906002)(86362001)(7696005)(91956017)(55016002)(66476007)(6916009)(478600001)(71200400001)(4326008)(66446008)(66946007)(64756008)(186003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?NNJReNrZ64/P0Ymvust1WCgx0Fz1BJVMgaaA3e7mXlW7sKVL9IXfm6uplBpv?=
	=?us-ascii?Q?/gUOb/9hHw9Daxer3d/il6PvJwZ324pmeWkE2ohelx7wsquqrrV3cH00fhWH?=
	=?us-ascii?Q?G9MOFhc6iQoouWW3ZWJjs0c+PqjkN2VMRY/5GfwA8em0Jik7OdMnulGSGIka?=
	=?us-ascii?Q?c06LCmPCIxMZKkS08bB91MKnrpilhQeOPmJBMURmREHxeBpJN2z8o8l7wO9Y?=
	=?us-ascii?Q?9bdqm+39N4pE4FFVHSHgHVbzM93WJrNp6ZsoeIgNGSVT9AqxRIydKIoqDmOl?=
	=?us-ascii?Q?I03VsjtL4O3HDLMrTpZjJ+2edTWM83k8btoikuww4vm+IJK/v55GKht+fMZI?=
	=?us-ascii?Q?hxwV3Sdlk1B3OTARZ05+3KTjeGtgRYmnoYzEIZiB/4hFCgmYEKabX5O5v09z?=
	=?us-ascii?Q?nKowxAAQopdmbqyKMQq2h4nA9+EPaOwzKOxUoExd4o1PqDmOewH13n5xZELO?=
	=?us-ascii?Q?yRM3Y+xjLpmIFNHmaGx0tqKw1IGthSYi1K+7ZaV27KqLUFrBepk5Msuzozty?=
	=?us-ascii?Q?/kJdgDVZM3nKEADXe826X1tw6SPeal4MN9AVWFEkje53s3P87C+sNXh5rjFh?=
	=?us-ascii?Q?jK2L5nNenNbk6emrBHeSNmyVqsRAJHAPqbdEEPya12Gz9M7wcwhwryKehH8S?=
	=?us-ascii?Q?ujreeB7QXMq3klbCfhLxYsH8uYocnmrNPV2NrfNq7a34cnm2jE5xLw/B14nW?=
	=?us-ascii?Q?dwCPMPoOQdeeVpB1aWP65LTb4WsAwYWbciEKDNE9MrkMBcOboPycbQZvEiTL?=
	=?us-ascii?Q?0L4sj84JsKjR/2euHaSWY3mXt1Lql0dKEdWH9JO8ddixb3cp3EbifxSvwQwC?=
	=?us-ascii?Q?NE8Ls3L7zllvwpzE6Rp9JgB76wlXrPIuK/RLp9OF1mByBHlJcKe5tFDGlCGY?=
	=?us-ascii?Q?ggONgx/3sWfUuKFbouW/Ms6Ewj+SS8tTqibfWla7OIRRXTVaiZv6jDTZGHDY?=
	=?us-ascii?Q?kQe48fMUftLg6R7Jn++oYCsVDTpddWjog3yrOJShzTHzcNzIgePDTC2MBJc6?=
	=?us-ascii?Q?HS4CCdV217mH5rYej+pFvAac3EkcxrYT29CDv6BEnT2nLDfdG0uVT2dnnCEB?=
	=?us-ascii?Q?E9jmP75SY85O7C+tkvydwEwtoYT3VvWqOVsHmagXBDoxKuxorxd45H+UqnFI?=
	=?us-ascii?Q?eUCvlczVpbHqH7NhZTyGUCA5cx+4/GnnfgBjuajHkDL247W2cYK/vfJqUYaB?=
	=?us-ascii?Q?nxUXGxAdh4JVoQAnrlwEIn8w3QESu5eVfbMlrGynEmMHQJqhAywT5kQx93oo?=
	=?us-ascii?Q?LfwxIQMFGhJMyXKVWNgDrDwNg+HU64f72CeR8ypQitc3GjBu+pyOhpA1EPdT?=
	=?us-ascii?Q?UXgyhfq5LFI/8hFS1QEkUcH5baqwrLAz1wO5FyotWeGDTDh/vir2M0XNW03A?=
	=?us-ascii?Q?aogbmcSNqJT3icy5xBCB4Fqo4ldFcJbPSdmPZRQogDxcpE96vw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f86fe9a9-8d30-4847-382a-08d90301f9b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 07:08:46.6492 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZxOqbGjYdWlED7Z3fluNIboWDAovZsMaVBEbORsesaYcZw9kItpBUTsjUjlva+A40t9vitWdEcRlMM/1y8tK9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6976
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13J79vp9016194
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "Martin K .
	Petersen" <martin.petersen@oracle.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH v2 3/3] zonefs: fix synchronous write to
 sequential zone files
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/04/19 15:45, Christoph Hellwig wrote:
> On Sat, Apr 17, 2021 at 11:33:23AM +0900, Damien Le Moal wrote:
>> Synchronous writes to sequential zone files cannot use zone append
>> operations if the underlying zoned device queue limit
>> max_zone_append_sectors is 0, indicating that the device does not
>> support this operation. In this case, fall back to using regular write
>> operations.
> 
> Zone append is a mandatory feature of the zoned device API.

Yes, I am well aware of that. All physical zoned devices and null blk do support
zone append, but the logical device created by dm-crypt is out. And we cannot
simply disable zone support in dm-crypt as there are use cases out there in the
field that I am aware of, in SMR space.

So this series is a compromise: preserve dm-crypt zone support for SMR (no one
uses the zone append emulation yet, as far as I know) by disabling zone append.

For zonefs, we can:
1) refuse to mount if ZA is disabled, same as btrfs
2) Do as I did in the patch, fallback to regular writes since that is easy to do
(zonefs file size tracks the WP position already).

I chose option (2) to allow for SMR+dm-crypt to still work with zonefs.


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

