Return-Path: <SRS0=5JG1=FD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D22C3E8C5
	for <dm-devel@archiver.kernel.org>; Sun, 29 Nov 2020 21:14:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D433F2078D
	for <dm-devel@archiver.kernel.org>; Sun, 29 Nov 2020 21:14:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D433F2078D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-BOiFgPTQNfOtpH3DO9o07Q-1; Sun, 29 Nov 2020 16:14:50 -0500
X-MC-Unique: BOiFgPTQNfOtpH3DO9o07Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DC4B879516;
	Sun, 29 Nov 2020 21:14:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B5ADF271B1;
	Sun, 29 Nov 2020 21:14:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EDE3F4BB7B;
	Sun, 29 Nov 2020 21:14:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ATLEdrU018962 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 29 Nov 2020 16:14:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CDBD79E64; Sun, 29 Nov 2020 21:14:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C74969D47F
	for <dm-devel@redhat.com>; Sun, 29 Nov 2020 21:14:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 584F88007DF
	for <dm-devel@redhat.com>; Sun, 29 Nov 2020 21:14:37 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-62-LtHh_YzKOJGg6UDJFPaV2g-1; Sun, 29 Nov 2020 16:14:32 -0500
X-MC-Unique: LtHh_YzKOJGg6UDJFPaV2g-1
IronPort-SDR: QPMWfJwqOi+qHGPsHvAs+N+CXHYfGPyK6FhUcFtW9J2wY66ThM15PQpozopHR+sPl23Pg/t12g
	jYflHF2Oj5C6WuA2yY+MUgJhxIJmGp8e6BigoDG7YKEHsKAlEgg/jRPHmipGTQykWVb70sK0U9
	OgsHhOUVCznlM5plObUeheI0kyYddZVTwpl3W4RAP8Q3PUztg3/owmaXnJX1qv8KjwTDrZHyZj
	8phJDXHbJg/uKgyZHmxyU2j97oMMQ4IoD1+A0DessIFx+lMPcm2aIrT2dR9gqw9W1beEbuMJPn
	hjo=
X-IronPort-AV: E=Sophos;i="5.78,379,1599494400"; d="scan'208";a="158225416"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
	by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2020 05:13:26 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB6021.namprd04.prod.outlook.com (2603:10b6:a03:e6::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25;
	Sun, 29 Nov 2020 21:13:22 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::99ae:ab95:7c27:99e4]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3611.031;
	Sun, 29 Nov 2020 21:13:21 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 3/4] nvme: allow revalidate to set a namespace read-only
Thread-Index: AQHWxnyPNSwY+7eHi0eeVdR+L+5epA==
Date: Sun, 29 Nov 2020 21:13:21 +0000
Message-ID: <BYAPR04MB4965E58F8445FB072BA752F786F60@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201129181926.897775-1-hch@lst.de>
	<20201129181926.897775-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 43fc7c48-38c7-41e9-f5ce-08d894ab9a17
x-ms-traffictypediagnostic: BYAPR04MB6021:
x-microsoft-antispam-prvs: <BYAPR04MB60214E1D27DD0DAD0D6F2D2186F60@BYAPR04MB6021.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:792
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: QbQeLyB4L+lXr0eGLFppAXEbdwVu++5FZzVUsNcdOtBWDu6r8xZBWEzRKfira2836sKRu83C+oV0fA6kryLy5Jl3o55aX/v7Wd5gfceGobVgypGUXAmINBpyoC/xoQEl6lOsxtABBJ5sWOPGFaeC8fePaCCdcKDWjnI3Epi8thlUng6kdo86I1rSHKf+y0xoe3J+WY2jEtzJVANE7gPzp9s0V1Ivr0qrvbAyItUjJkvqCp7245K5wGsiHw9OT2WhC8KQppu0JikNWPLme74t3olB+qXw4rQg2KWWIu/M8HVcLPSgh7shRjAAG5zw2KPzpwfKTvpKEtPtF6hMpMnSEw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(7696005)(53546011)(2906002)(186003)(8936002)(54906003)(26005)(66556008)(110136005)(71200400001)(6506007)(5660300002)(4744005)(478600001)(7416002)(86362001)(83380400001)(55016002)(52536014)(8676002)(9686003)(66946007)(76116006)(64756008)(33656002)(66446008)(66476007)(4326008)(316002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?y0voHwWuXgCFoVkgEEWyzvUYdiS9grJG/Fy7RmYZRtK34TJ1YZ0H5sx6+C+e?=
	=?us-ascii?Q?IryFz42iXHRBrAv2yLkLQGXTdo4eeH1HBVNRJj7nZilqbzpQcKKWi79e9qC8?=
	=?us-ascii?Q?ftJ4zFj6cxaIWRz/e9eS+35VOn8VoeFmJrZHaF+qlMC2vk0B7uMnVlI/wns+?=
	=?us-ascii?Q?neqrlPMVCa/JCwQhTpbt8MJQ/vX0PqEN1A/Bfc8BEkf4WymHuYfnqS+8sBt3?=
	=?us-ascii?Q?KRx04oevE0thij02QvGMXQDCMvVVz64fRF0IH1qJRNZc+M3Xwgu8RbJNoNtK?=
	=?us-ascii?Q?/ENEcOjI1UqyWH4PzFskbt6sGO30a2QlWuvwmoiQ2UzLNcP1sY/CAid9FpBO?=
	=?us-ascii?Q?JRmWEcGlN/dnm9X9KpjC42bP0MYZTHcctfsk4KREnF+eihZOSfQYDJQFzZrm?=
	=?us-ascii?Q?1bqpnLodfe3RcTOyr0olY187vU0MoXepz1LsyBguv0kqnghLH66oODFIxSFa?=
	=?us-ascii?Q?YGMstJ5sivItKlHyVUVzf7nGPFE/Qi2r53Bc2YwTXmRVSxGXXTy5Esf41zq/?=
	=?us-ascii?Q?0z3xCE4rdDMLLI8SSjerk6hJCK+wJNPcPht7reOwsbTwpYCBkrat87qGLWd7?=
	=?us-ascii?Q?nslFRVVQSMsEkuGRJ+bZ0mnMzsTlz15Dv//atiA1HqFZ7QgpGG16beEGs6+y?=
	=?us-ascii?Q?QjWbMQYQB8pVZy8ua7rGdoDO4fp3ZlRuPiPP8JQbUgcZWvhNFmfjt0fghqN5?=
	=?us-ascii?Q?y6QBpUdL1I6TOH/SodeyEyJjLQ+/dT2soDneIu4e0KBKIl7r/XfOOJRStdLB?=
	=?us-ascii?Q?CudgghLZkLqADDvQyvYFLQl+kqTMtGgrjQyyDudguoCBnrt2Xr8st0K7CMQz?=
	=?us-ascii?Q?z4ZLj9BkvWBm570VX0kheCC87HmFfg4OoBjo70ilg7BKGsI7QvvHVozmRgaN?=
	=?us-ascii?Q?LCNMGcWC3DdpM+n7zqwYpbRU6RfFWx9UB1UxqYgYf5dZKRmrG4xm2rmHUrvc?=
	=?us-ascii?Q?rpJ9N9+Ef2AVh7hTPd+F+AJ56khIVGzzPTzGif3fbvVCzI5r8WgfN3yJdto2?=
	=?us-ascii?Q?tXd1?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43fc7c48-38c7-41e9-f5ce-08d894ab9a17
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2020 21:13:21.6286 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L2HTxwqmyST5ic5euC4qzK15XcgbxMr15XHpHuS7QhbTBHs+vK61cX9neYsEMhdlNlkuyuTHjdLX7vvDDhaJMrl1yyqYWdNpktadydlr14k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB6021
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0ATLEdrU018962
X-loop: dm-devel@redhat.com
Cc: Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>,
	Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 3/4] nvme: allow revalidate to set a
	namespace read-only
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/29/20 10:22, Christoph Hellwig wrote:
> Unconditionally call set_disk_ro now that it only updates the hardware
> state.  This allows to properly set up the Linux devices read-only when
> the controller turns a previously writable namespace read-only.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

