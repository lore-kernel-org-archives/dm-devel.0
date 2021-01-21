Return-Path: <SRS0=L0Bp=GY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EEEC433E6
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jan 2021 08:25:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0615A2399A
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jan 2021 08:25:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0615A2399A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-ad6u9tLsOQygBYvuTy-rlw-1; Thu, 21 Jan 2021 03:25:28 -0500
X-MC-Unique: ad6u9tLsOQygBYvuTy-rlw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60A58180A09B;
	Thu, 21 Jan 2021 08:25:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7786A620DE;
	Thu, 21 Jan 2021 08:25:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DFE37180954D;
	Thu, 21 Jan 2021 08:25:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10L8NV6b003025 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Jan 2021 03:23:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B715C2026D16; Thu, 21 Jan 2021 08:23:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AFC452026D15
	for <dm-devel@redhat.com>; Thu, 21 Jan 2021 08:23:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68881187504F
	for <dm-devel@redhat.com>; Thu, 21 Jan 2021 08:23:29 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-477-cTtj2C6zNQ-frRy7rcZYtA-1; Thu, 21 Jan 2021 03:23:24 -0500
X-MC-Unique: cTtj2C6zNQ-frRy7rcZYtA-1
IronPort-SDR: nopY/1/vZtTbFd6l0+IpzksjZWV827taoYGdI6nTCvXcD+NT6atg+8pFyCQqv+c16JkaXOoL0D
	KZ4ZA1yIKpkpX5wZeHBX/9xKxHqY0oEbQqAoXtVeOlDWitYpkamuITHncU/F4of0v0+vfTCvA1
	8qvStsDmXY9OCQe7EPLXrsBBarKmqoRU5iWs00KcZ6PkYEsEa49IMfyV+qwhw4SkboXxG08Km6
	tzg8JeOoO/gZkor8VHecJdk53+ftE6lSIRjTitLfOZZNK7atzziYHzHo7RWXAh9orbProOBDgX
	qkU=
X-IronPort-AV: E=Sophos;i="5.79,363,1602518400"; d="scan'208";a="261948044"
Received: from mail-bn8nam11lp2175.outbound.protection.outlook.com (HELO
	NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.175])
	by ob1.hgst.iphmx.com with ESMTP; 21 Jan 2021 16:43:06 +0800
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
	DM5PR04MB1035.namprd04.prod.outlook.com (2603:10b6:4:3e::17) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.3784.11; Thu, 21 Jan 2021 08:23:20 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::9a1:f2ba:2679:8188]) by DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::9a1:f2ba:2679:8188%7]) with mapi id 15.20.3763.010;
	Thu, 21 Jan 2021 08:23:20 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Julian Calaby <julian.calaby@gmail.com>
Thread-Topic: [RFC PATCH 00/37] block: introduce bio_init_fields()
Thread-Index: AQHW7iDfXiv5iuHOl0mGSxMcJ7OwhA==
Date: Thu, 21 Jan 2021 08:23:20 +0000
Message-ID: <DM6PR04MB4972029B58F81B22033E31F386A10@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
	<CAGRGNgWLspr6M1COgX9cuDDgYdiXvQQjWQb7XYLsmFpfMYt0sA@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2600:1700:31ee:290:6c3f:2942:f9ba:e594]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1b399c6d-302c-405d-7f89-08d8bde5cfd2
x-ms-traffictypediagnostic: DM5PR04MB1035:
x-microsoft-antispam-prvs: <DM5PR04MB103558D7CAA67BC277FBE0E586A19@DM5PR04MB1035.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: luBm2A9fQFDbAs+wwf5UQLQqGI+U9qrY9qOoLl278vLFEhZYF8PCPE1mzg6Tt00oqorUoJZeH6SroLCiDqfwK9XrIA5LmEasW9gV2WFpREOKVrf0vl5YIGT/uz5MOZLMc95bMXi+Hw5BHRva63Z5/1PuoE1WocRTm129bzScDkldj9CvFwvFGhDH9Et4QKMXUX+IciSSEzf5XTQnwBQ4Ce56JAClngNy5hTRHQCC5L4OmkCPDAyuCVPr/ljXo1Jgx+wBya1uqegcbpFR6wk99WVD4J4hLzl4XOz2eSJuA7hIeWxB1OEAXp8WrdWox86N/lXoRtgzme1lqsuaDmQHfwv/fCM9Q/yzofM2yqu2Jy068UIlRYCsj/6zdaLjN0gxaku4C3m0vY9X1srG/ZD+9g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB4972.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(316002)(52536014)(6916009)(186003)(54906003)(5660300002)(76116006)(9686003)(55016002)(8936002)(71200400001)(83380400001)(4326008)(53546011)(7416002)(7696005)(8676002)(66476007)(91956017)(478600001)(33656002)(66946007)(64756008)(66556008)(86362001)(2906002)(66446008)(6506007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?iASZoPJYzsgBoHOG0e4uj4eYwMJzI7AYx9ibXkU8WlIY/45eI5Lozn9IMLqg?=
	=?us-ascii?Q?K1fUjrE61rIj9pVmoTN18nQMr+gvGY4G6wJ+Ny4pZYARx/NQUcSJcxlwZktO?=
	=?us-ascii?Q?bHqvL2+WTuwKfq2jk97rHh4iKZQYlGKj9o5IFGIIiC6E0WKGXNOAogExeiH7?=
	=?us-ascii?Q?tO53jk+LmhpLuLYm0OVz3gHZc25lTvqogVwbwvUqG3rX45XT/251vlSLhLDN?=
	=?us-ascii?Q?BiAaGVE7uBNDX6Lo7JJvKKpz+6vrvuvatx4hhONQ7MN7a+Zn8FxjYQrE2SUa?=
	=?us-ascii?Q?uH7RyUQL1jRl4VoRuKHUwCaNA0ebTkVOQKvC2VmJ6rJqt2gYMsgZjF2sAvYF?=
	=?us-ascii?Q?ZwtuZCJhEJsAawETHIlGBaxry0pr7057QSOs8vA7S+uAfyiqeL3YEqc6ejxT?=
	=?us-ascii?Q?RixON+06jvKRSioN7m1wLJ0XqsMUTEiwAu81zEEefyjFa/50E45jN0Pifbq2?=
	=?us-ascii?Q?YQIZxBpt2Hqxx1KKyTlN2pXg4IQbafIQchs+7TVmwY/vsp9tQR7uEafp0BDS?=
	=?us-ascii?Q?bu5T812yyckpVYAeXogWT4zDgQOCOO47FhLaIz3EFn6kvRW51FFMDKyBoiir?=
	=?us-ascii?Q?wXwhkX75FSf1Qw4pnCXK4hYvl2cDv1YYOEYl1WdmIjJ5O2HNpEWKeTvOxwCX?=
	=?us-ascii?Q?6grVS6+rBLLWAffAcMo7a016G35j79LX7hwn96/LgR3wCcwVNSh6y48Rw/g5?=
	=?us-ascii?Q?buriD3gNHqhP6WETZHEu3zlHI7zs9yJmY9x9tAS7fU8E1W8RjXRnFv3rsLTV?=
	=?us-ascii?Q?mGTcmEpB3F0x56xPLqIzECmw12+8LqLQ8UDlGJuGXusb8MbbIGileZPhB+uM?=
	=?us-ascii?Q?eYZwo7QTxj15lHNkB6nFsDURRPPebs3b77L/3uwexEDpxECQDVj7jI8ssHcj?=
	=?us-ascii?Q?+WRw7u4eTJ3rUDPixBZPxm7sdD54H8NacygfAoLOu7DQVosWaIjmoJMeqwei?=
	=?us-ascii?Q?UQpipq7k3iuDVr8GZd3RD+7YB2iiiLLxt9SAooJrWAExIIw2daPBw3LpDI2I?=
	=?us-ascii?Q?v+AxiMYRd5DaVrZHEoGe1XFXE53nsSzE545xeS/B8kIzqSQ6QWmjCxUgzTIz?=
	=?us-ascii?Q?RlRAUztqVUa3QAZZjmDwWD85Sb5txeijXEhtYjBST9cPs9YLaZg6pekySFU5?=
	=?us-ascii?Q?eMN2lhUlrZ6V1wO6BG46/XYS7R06vKBnUA=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b399c6d-302c-405d-7f89-08d8bde5cfd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2021 08:23:20.3555 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q/0OYkC/ek5ytB2UVtDM2si2ySo1pVi+WyQqr0ClrR0sMEWiGpRaV17E+ClET0fPiMj8qHuKJIGPJIy3pAz1DySUTHtG+BdCm5OrLj07ghM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1035
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10L8NV6b003025
X-loop: dm-devel@redhat.com
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>,
	"cluster-devel@redhat.com" <cluster-devel@redhat.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Linux SCSI List <linux-scsi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@tron.linbit.com>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 00/37] block: introduce bio_init_fields()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/20/21 7:01 PM, Julian Calaby wrote:
> Hi Chaitanya,
>
> On Tue, Jan 19, 2021 at 5:01 PM Chaitanya Kulkarni
> <chaitanya.kulkarni@wdc.com> wrote:
>> Hi,
>>
>> This is a *compile only RFC* which adds a generic helper to initialize
>> the various fields of the bio that is repeated all the places in
>> file-systems, block layer, and drivers.
>>
>> The new helper allows callers to initialize various members such as
>> bdev, sector, private, end io callback, io priority, and write hints.
>>
>> The objective of this RFC is to only start a discussion, this it not
>> completely tested at all.
>> Following diff shows code level benefits of this helper :-
>>  38 files changed, 124 insertions(+), 236 deletions(-)
> On a more abstract note, I don't think this diffstat is actually
> illustrating the benefits of this as much as you think it is.
>
> Yeah, we've reduced the code by 112 lines, but that's barely half the
> curn here. It looks, from the diffstat, that you've effectively
> reduced 2 lines into 1. That isn't much of a saving.
>
> Thanks,
The diff stat is not the only measure since every component fs/driver
has a different style and nested call it just to show the effect.
Thanks for your comment, we have decided to go with the bio_new approach.





--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

