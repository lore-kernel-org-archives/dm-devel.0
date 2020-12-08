Return-Path: <SRS0=ZVdP=FM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D23C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 12:42:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6DFAE23A52
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 12:42:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DFAE23A52
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-pHwSpEjTPRKSEyia8ZnO0A-1; Tue, 08 Dec 2020 07:42:35 -0500
X-MC-Unique: pHwSpEjTPRKSEyia8ZnO0A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58940858180;
	Tue,  8 Dec 2020 12:42:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 224AC5D6D5;
	Tue,  8 Dec 2020 12:42:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 74842180954D;
	Tue,  8 Dec 2020 12:42:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B8CgOMT012145 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 07:42:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 48838946AA; Tue,  8 Dec 2020 12:42:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 41352946A0
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 12:42:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B563B185A7BC
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 12:42:21 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-183-K9W6MkSjOEeH1VleDh7Pow-1; Tue, 08 Dec 2020 07:42:19 -0500
X-MC-Unique: K9W6MkSjOEeH1VleDh7Pow-1
IronPort-SDR: mjitjmbcx3V/XXhRIGPD3YtoFwPa5sHZM5lfwa8siKK1Iwf6f1dolPd7b2Wa185lm1GTlSnYXh
	HCDNwDjG9xQnqQQafntoMA5T3pw8cHV+kPKO2t2F82znSrIipMfcsQdc/agZcdETh/vvBkAOpH
	5tqQpgViQkSXpip6PeNLH4jq1Gdr6oGXT1mGOkn5y167+bjy+BKvHr7KPwoM3Bz6MRLwqTbwIV
	rzgx9eMFi5NJfSjWzKUT8DSqdO1ORLSNkAyAOE228bkBBNbAR2ZTQ3HvitkdkMOT3oRroE+7/l
	ZdE=
X-IronPort-AV: E=Sophos;i="5.78,402,1599494400"; d="scan'208";a="264839600"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO
	NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
	by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 20:41:13 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4688.namprd04.prod.outlook.com
	(2603:10b6:805:ab::10) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17;
	Tue, 8 Dec 2020 12:41:13 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%6]) with mapi id 15.20.3589.038;
	Tue, 8 Dec 2020 12:41:13 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
Thread-Topic: [PATCH 4/6] block: propagate BLKROSET on the whole device to all
	partitions
Thread-Index: AQHWzJwqypaea6Vyp0+8epdHcF8jHA==
Date: Tue, 8 Dec 2020 12:41:12 +0000
Message-ID: <SN4PR0401MB35980E0D76B523779FA25E379BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201207131918.2252553-1-hch@lst.de>
	<20201207131918.2252553-5-hch@lst.de>
	<yq1y2i8x42d.fsf@ca-mkp.ca.oracle.com>
	<20201208092545.GA13901@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c17cdc9c-941b-42dc-7682-08d89b768c01
x-ms-traffictypediagnostic: SN6PR04MB4688:
x-microsoft-antispam-prvs: <SN6PR04MB46889091982F32F8BCC9221B9BCD0@SN6PR04MB4688.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:597
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Sl1nd1RqO+u4dwevOYOXgPucUsisq5LU+zWfuZVF9NDLbSxxnHN7MbtJE46SOc1toidLcyZMJ1zdyBzNjlGdFL7V6Dov3296TSIkK/bsl44xVfuE9LJkQ3V2KTQ5XGq6LkA9oRNaN0wQwdk7HdirpAKSQoUR1vkmblhkix7kURuKgjXqaJf1SxksszuR7ss99KJAVCMZ9uK3noZNFFcnWcGQXDJgnC8lEExO4gCsEATyO/fhGfCo/sOkUVUM25MwyPYY8wRpgiJ7cT3P0RjK77UxsvqhgmB3zCfX9DeTobbDhpj2YWrPwLa+YEOEe1iq
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(346002)(136003)(376002)(186003)(6506007)(53546011)(5660300002)(66556008)(7416002)(54906003)(4326008)(110136005)(26005)(86362001)(8936002)(66446008)(91956017)(66946007)(66476007)(64756008)(71200400001)(76116006)(7696005)(2906002)(52536014)(508600001)(8676002)(9686003)(55016002)(33656002)(4744005);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?jw3ecY5btQkRWBUVLOfRe4sY45sdRPxGSBJ9sCyp9LS/iJZ4bBHsRZYIIpfI?=
	=?us-ascii?Q?m+xmlWd5NhCaw/qgkzEXSP/RaQnyL3BqZnrqq7kdY97bYC/O3fQKOJ6wnpwK?=
	=?us-ascii?Q?uSdjNSnTnjTjiwRt8becBZpDG7aQ7yqD9Uo6eplpHOWQuXzLgrAq76Nnz4GD?=
	=?us-ascii?Q?1ahxxKB7tqqv9tsbj/zbvMdQGODUZG7lPKon6b2rdVGBYJ16SIyzV2NN7w3W?=
	=?us-ascii?Q?Ol72SEYgSxszty9vr4M2m24Mzorfbla88PzcLTq2a08XK68Cng9GmjDPa1xv?=
	=?us-ascii?Q?/Qpkag3COYkNUZrnysjEGy24l5PCpsujPayP+Zq8Ar079yMMy6hSBTyUvG0k?=
	=?us-ascii?Q?3JdoBjH4cFBOhdPfjuzKxCEZTQ/b7QPw4/cj8CBT7QY44alZXvcOZ/Ju3YyW?=
	=?us-ascii?Q?YpE0c09tmT22Y50Oakj0QbIjM1yEaEicJ0P8Z9kMrGmO4HDmPtf+rHfb8ljk?=
	=?us-ascii?Q?w8VE5ybHh+Fv0m16lOVTMkfqt6WLUlleiLmAJVdSjlS9ZhGtP1LQ4dcS310F?=
	=?us-ascii?Q?vEDUyZhyvDSJuOD20K7S8+4gyF7n4VW1B6EXd9f4NyImMUThTcRgTIYXf/Wo?=
	=?us-ascii?Q?R8jMWnzvLxbLLO/MOyfLPPJDLgJxA3EXEtgD6d853uIEvPCnogRagnjVw7mC?=
	=?us-ascii?Q?3npbCsxM7duReOFViV11Etw5xOD8l6V7kxU6PJhQz1gLkC4ZQdH4/UnGhfvK?=
	=?us-ascii?Q?fP5bEEy3vglh4JLRcr6zCHPdWnOHgCU8S3PHKs3Ibn4HQn4nLG4mODAYrIFG?=
	=?us-ascii?Q?Jp0dYkrAvXiT3NY1hw1/8PzOsoTJxcdEVAMPykPolFhgNxXeNwl7V3Sy32CH?=
	=?us-ascii?Q?HYxhozrDYnKFkXZmEEai8xFtiKAFSdFeD++QYv/Nf9ITEF3qX60PfDm1bi0M?=
	=?us-ascii?Q?jYiwXljswgyFEMIFkAITJgI3eNwjdWA2OlQ3L6uLrUPh6SGY7/zZeMbp3ZU6?=
	=?us-ascii?Q?IUbbBaMHhwW1/P4lsLfI2QkXYCYvvr3pm2djwbm3hvtPpdJbcVVXT1vXdog8?=
	=?us-ascii?Q?Ynmh?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c17cdc9c-941b-42dc-7682-08d89b768c01
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 12:41:12.9168 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j7XJCytn1pku3szi0/+ynqgTLy+5dkysgKKkDl1J9xh6QOz6rN9WVxvn1jYWUKUCZUejZVFw78KLr/yUXYwkKqdAzXlrrzlI/VkZ4MUnRFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4688
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B8CgOMT012145
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Sagi, Grimberg <sagi@grimberg.me>,
	Mike Snitzer <snitzer@redhat.com>, Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 4/6] block: propagate BLKROSET on the whole
 device to all partitions
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 08/12/2020 10:28, Christoph Hellwig wrote:
> On Tue, Dec 08, 2020 at 12:27:41AM -0500, Martin K. Petersen wrote:
>>
>> Christoph,
>>
>>> The existing behavior is inconsistent in the sense that doing:
>>>
>>> permits writes. But:
>>>
>>> <something triggers revalidate>
>>>
>>> doesn't.
>>>
>>> And a subsequent:
>>
>> Looks like the command line pieces got zapped from the commit
>> description.
> 
> Yeah.  It seems like git commit just removed them after I pasted them,
> weird.
> 

Might be because of a leading #, happened to me as well in the past. Just
add a single space on the start of the line and git commit is happy.



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

