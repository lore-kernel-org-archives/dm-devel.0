Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 951D3C4361A
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 06:22:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C54412253D
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 06:22:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C54412253D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-hlmTqz-_NGWAK5ZG3lzhow-1; Fri, 04 Dec 2020 01:22:26 -0500
X-MC-Unique: hlmTqz-_NGWAK5ZG3lzhow-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3D568049C2;
	Fri,  4 Dec 2020 06:22:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E283D10021AA;
	Fri,  4 Dec 2020 06:22:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D52754A7C6;
	Fri,  4 Dec 2020 06:22:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B46MFnX032053 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Dec 2020 01:22:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 59EBD10D18E9; Fri,  4 Dec 2020 06:22:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 54BD110D18DA
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 06:22:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0ED3D858EEC
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 06:22:13 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-226-XhwufZPKO6W6c5k2CYlRZA-1; Fri, 04 Dec 2020 01:22:10 -0500
X-MC-Unique: XhwufZPKO6W6c5k2CYlRZA-1
IronPort-SDR: /+vJRcbLvsnRAOv6IG4cxrL5HN4jCo8tB0pEOjYs5ni68PAnBDVhTHl1sVvTerJykLBvaGCEhj
	KYmkq3DKYkEEE7mHMO7T4w+SiS+SAoTu68IdYiEGkdmSZNQ05+uSFmWD9txnJlZf8RfbIa7S48
	5M2fgY7tFPl+w/6AEy/2BDKMN+inNMa66faHWdrSWBGsWYHUp0vBaLECIjfcHY9/0T4SrEx5BZ
	IoLtoyE3jZAbLxos8T0AhE9RLUsXNORbba3StaE2PzI36GVG8/2EsRfoWytXO3EPSpB5fcD4qm
	6Nw=
X-IronPort-AV: E=Sophos;i="5.78,391,1599494400"; d="scan'208";a="154376306"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO
	NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
	by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2020 14:22:08 +0800
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
	by CH2PR04MB7128.namprd04.prod.outlook.com (2603:10b6:610:9a::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22;
	Fri, 4 Dec 2020 06:22:07 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a]) by
	CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a%7]) with mapi id 15.20.3589.022;
	Fri, 4 Dec 2020 06:22:07 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>,
	"hare@suse.de" <hare@suse.de>
Thread-Topic: [dm-devel] [PATCH v2] block: use gcd() to fix chunk_sectors
	limit stacking
Thread-Index: AQHWygXKM2E833wJPEuohYVBv9PQMA==
Date: Fri, 4 Dec 2020 06:22:06 +0000
Message-ID: <CH2PR04MB6522DFFD1EE89C45EF0C0BBBE7F10@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20201130171805.77712-1-snitzer@redhat.com>
	<20201201160709.31748-1-snitzer@redhat.com>
	<20201203032608.GD540033@T590> <20201203143359.GA29261@redhat.com>
	<20201203162738.GA3404013@dhcp-10-100-145-180.wdc.com>
	<20201204014535.GC661914@T590> <20201204021108.GB32150@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:5458:21bf:70ee:2847]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2c61421d-29a0-4349-9d9c-08d8981cecb1
x-ms-traffictypediagnostic: CH2PR04MB7128:
x-microsoft-antispam-prvs: <CH2PR04MB71288991235F00C4552A35F0E7F10@CH2PR04MB7128.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: JQOKYBb1YzGx0zCPrYkWAGG6TMow1CDJRCBJz2NuKNg64/71/SxNAgoSB2xKK+CLCoog7cgAw9z167Gjp2nx5wlxLTfYYS7TnzUrvMMrwsMOw++yed4fDWKMs7me3sZWOlTiPfQ+4O+qx+yg1vQn8Q0VfBXWU2U4XBGpY+H+kaDSO5/hIrLDibGW8aWBmv5e58B+Jg2QiV27TSW9RSwxf8hGr+yjJpsQp/waY/sKSjcp1vwfUAONqTWu8EcbgLc4uwTo/a4rNvhulOrvCcoMgjY9CccdsI5XWI379/7nWM0Xd14TSE5ldFODA3ULpCdk
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CH2PR04MB6522.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(66946007)(33656002)(8936002)(76116006)(52536014)(8676002)(5660300002)(71200400001)(83380400001)(91956017)(86362001)(66446008)(66556008)(4326008)(66476007)(478600001)(2906002)(316002)(110136005)(53546011)(7696005)(64756008)(54906003)(186003)(7416002)(9686003)(6506007)(55016002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GeYj0AM6B3v34KyNm4uDuJo1WzBKC3h5qrku9Eo6HRdBu6W3YmQT0ivTnxjk?=
	=?us-ascii?Q?y0rx4fBWA2KHircq+qBdgoV94hEgWzUmoiAEzY1+hojir5Q7SXWHM8zjYq31?=
	=?us-ascii?Q?MYi5KRecNwmYNnQ40Du+XbgvjjPXwDQOJfvim+DomWiMCYF9e/OzIxeGcC3u?=
	=?us-ascii?Q?K8rcSVrt3d/eyHAXuNKfv7CzbjR+QB4tL2pqqFz5NH/yCHcD1/tLCZIC4oU6?=
	=?us-ascii?Q?eaCYWi+oTaxgrP3Y0LTweDuq7pxKPcvzV3e6G6de2u+AbCou0Qr3PYjUHPEb?=
	=?us-ascii?Q?yM242yXrs3LUjfAraxUh9/OjFkyYg7HVZAWggpxHvEHFn/5Kr9lxpB67UM5R?=
	=?us-ascii?Q?/9bHwoTJ9ncbfzmiCiWtvNlLOguLZ65fBTvaXhhUwAnpVw8DRz3oHyvYZGYj?=
	=?us-ascii?Q?ZNzdfjowwOOhWl5y3NKTymliQ9CjR039FxZGomcen440/lHWZIrsy4ws9VUB?=
	=?us-ascii?Q?rFedCug+I5JPDtHYvjENbfPdN2GEUpxu/sm6R1JIE7bwwsn60jP4b37Uz73i?=
	=?us-ascii?Q?6HR3seufkDUB/xAzUPa93cwTtueVCgQRs+vl/oM4J4cXrocfFY3ADgUaR9E9?=
	=?us-ascii?Q?jp3w+kKYpWiaafLFBmOYwCAlmSP6ApdGXyd6E9bxF5ERj7dogDZI6eOo4rjw?=
	=?us-ascii?Q?oeGQIV1424yzHwCNX+DC88deoTyh8HSWfq0EJvTU2fJiqtVkB4RMnVByzDuS?=
	=?us-ascii?Q?W/CrzG2u9f+Kyyr+0bp7LFQSx1lZ1U5mENLCmiTaAq9tM9PytlF3j1av7kIS?=
	=?us-ascii?Q?F8Xp8I5FnsTXEqxr6+xGqqFKtZHf6aE45ohw0cNIBhq3c6/eNxOrfX4S/ziP?=
	=?us-ascii?Q?s65DJg3x01P97WDDeoSPHtu1NwRd34o6f7McviKRgLCFO+b+B490G36B8c/Y?=
	=?us-ascii?Q?t1X/Mr486Bx+qx7jqhV4suV04Ij6eRi692FEnu6z5VGOe03W3Opg+qLQ67gS?=
	=?us-ascii?Q?KlwKZpfh5K4rVz1/3EWVc0GUiR+FTz3OQpQyzgEw9D0Vc8E9eHARmqx7z3Tp?=
	=?us-ascii?Q?WczD/fm7/kXpLYWUbLx+YTYtlsaa5t7hj2xeMjWTzxcURENFCsbh9N1yYioi?=
	=?us-ascii?Q?6wwmTh8Z?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c61421d-29a0-4349-9d9c-08d8981cecb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 06:22:06.8941 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: phjGCEX7aVnr5uXnNwHTQEHnnrMggPPkJMaOgCb66MZtA1FRLjMr2Knwn66zbbRcZekObxbQQnT/lQSu39vyKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7128
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B46MFnX032053
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"jdorminy@redhat.com" <jdorminy@redhat.com>,
	"bjohnsto@redhat.com" <bjohnsto@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [dm-devel] [PATCH v2] block: use gcd() to fix chunk_sectors
 limit stacking
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2020/12/04 11:11, Mike Snitzer wrote:
> On Thu, Dec 03 2020 at  8:45pm -0500,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
>> On Thu, Dec 03, 2020 at 08:27:38AM -0800, Keith Busch wrote:
>>> On Thu, Dec 03, 2020 at 09:33:59AM -0500, Mike Snitzer wrote:
>>>> On Wed, Dec 02 2020 at 10:26pm -0500,
>>>> Ming Lei <ming.lei@redhat.com> wrote:
>>>>
>>>>> I understand it isn't related with correctness, because the underlying
>>>>> queue can split by its own chunk_sectors limit further. So is the issue
>>>>> too many further-splitting on queue with chunk_sectors 8? then CPU
>>>>> utilization is increased? Or other issue?
>>>>
>>>> No, this is all about correctness.
>>>>
>>>> Seems you're confining the definition of the possible stacking so that
>>>> the top-level device isn't allowed to have its own hard requirements on
>>>> IO sizes it sends to its internal implementation.  Just because the
>>>> underlying device can split further doesn't mean that the top-level
>>>> virtual driver can service larger IO sizes (not if the chunk_sectors
>>>> stacking throws away the hint the virtual driver provided because it
>>>> used lcm_not_zero).
>>>
>>> I may be missing something obvious here, but if the lower layers split
>>> to their desired boundary already, why does this limit need to stack?
>>> Won't it also work if each layer sets their desired chunk_sectors
>>> without considering their lower layers? The commit that initially
>>> stacked chunk_sectors doesn't provide any explanation.
>>
>> There could be several reasons:
>>
>> 1) some limits have to be stacking, such as logical block size, because
>> lower layering may not handle un-aligned IO
>>
>> 2) performance reason, if every limits are stacked on topmost layer, in
>> theory IO just needs to be splitted in top layer, and not need to be
>> splitted further from all lower layer at all. But there should be exceptions
>> in unusual case, such as, lowering queue's limit changed after the stacking
>> limits are setup.
>>
>> 3) history reason, bio splitting is much younger than stacking queue
>> limits.
>>
>> Maybe others?
> 
> Hannes didn't actually justify why he added chunk_sectors to
> blk_stack_limits:
> 
> commit 987b3b26eb7b19960160505faf9b2f50ae77e14d
> Author: Hannes Reinecke <hare@suse.de>
> Date:   Tue Oct 18 15:40:31 2016 +0900
> 
>     block: update chunk_sectors in blk_stack_limits()
> 
>     Signed-off-by: Hannes Reinecke <hare@suse.com>
>     Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
>     Reviewed-by: Christoph Hellwig <hch@lst.de>
>     Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
>     Reviewed-by: Shaun Tancheff <shaun.tancheff@seagate.com>
>     Tested-by: Shaun Tancheff <shaun.tancheff@seagate.com>
>     Signed-off-by: Jens Axboe <axboe@fb.com>
> 
> Likely felt it needed for zoned or NVMe devices.. dunno.

For zoned drives, chunk_sectors indicates the zone size so the stacking
propagates that value to the upper layer, if said layer is also zoned. If it is
not zoned (e.g. dm-zoned device), chunk_sectors can actually be 0: it would be
the responsibility of that layer to not issue BIO that cross zone boundaries to
the lower zoned layer. Since all of this depends on the upper layer zoned model,
removing the stacking of chunk_sectors would be fine, as long as the target
initialization code sets it based on the drive model being exposed. E.g.:
* dm-linear on zoned dev will be zoned with the same zone size
* dm-zoned on zoned dev is not zoned, so chunk_sectors can be 0
* dm-linear on RAID volume can have chunk_sectors set to the underlying volume
chunk_sectors (stripe size), if dm-linear is aligned to stripes.
* etc.

> But given how we now have a model where block core, or DM core, will
> split as needed I don't think normalizing chunk_sectors (to the degree
> full use of blk_stack_limits does) and than using it as basis for
> splitting makes a lot of sense.

For zoned dev, I agree. DM-core can set chunk_sectors for the DM device based on
its zone model for DM driver that supports zones (dm-linear, dm-flakey and
dm-zoned).

-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

