Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE3BC47082
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:27:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5308061375
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5308061375
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-qE3KnpF5PmuPN5d8OTDoFg-1; Tue, 08 Jun 2021 14:26:59 -0400
X-MC-Unique: qE3KnpF5PmuPN5d8OTDoFg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6BA76D5DF;
	Tue,  8 Jun 2021 18:26:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 807BD5D72F;
	Tue,  8 Jun 2021 18:26:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 303E044A59;
	Tue,  8 Jun 2021 18:26:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158IQqlT000556 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 14:26:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3F22F100912A; Tue,  8 Jun 2021 18:26:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 398A2103F276
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:26:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 000E8100DE78
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:26:48 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-422-RyfyutzDNCehf4Z-M4o5lg-1; Tue, 08 Jun 2021 14:26:46 -0400
X-MC-Unique: RyfyutzDNCehf4Z-M4o5lg-1
IronPort-SDR: MgdrN/n4VN9XcO/12eSiZOqpJuUtdxyuhoETkqenQngafsZRmj2VksIx6449F8xxFE8ORmIr50
	ULqGoRhvjzKLl5l3Qukq/3hiIri4cI/9HeRUDMTQdY3CbpChJ3zLFUF8QY76A8BN4RsoYYnuNv
	uouxKjCQW0vOXAzpCOpUJdT4/En0dIzBy4h11HBB+2Lo6uItQPeH5O2COWjYl6jchpMMhgD59K
	sW57JQS40AovUoO9vn4t9czQjtYezUw0eh73iqWdnNd4vZKmiRWKCg0PPa6f1+l5KbtCKzKTi4
	FlM=
X-IronPort-AV: E=Sophos;i="5.83,259,1616428800"; d="scan'208";a="282617504"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO
	NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
	by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2021 02:26:44 +0800
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
	DM6PR04MB6985.namprd04.prod.outlook.com (2603:10b6:5:244::19) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4195.25; Tue, 8 Jun 2021 18:26:43 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f]) by DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f%7]) with mapi id 15.20.4195.030;
	Tue, 8 Jun 2021 18:26:43 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 13/16] block: use memcpy_from_bvec in
	bio_copy_kern_endio_read
Thread-Index: AQHXXICXL+hXOI9ud0+HHe7YcVMXyQ==
Date: Tue, 8 Jun 2021 18:26:43 +0000
Message-ID: <DM6PR04MB497233791A3AC31473747A6486379@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-14-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7598f6be-66d2-4267-2bcf-08d92aaaf78a
x-ms-traffictypediagnostic: DM6PR04MB6985:
x-microsoft-antispam-prvs: <DM6PR04MB69857E617DE6CF0F91EA7A3086379@DM6PR04MB6985.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:972
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: UqeL8ruPKP5mrGsqFQx0hu4uWEudRopcMlI2MjLI8beyUV2yM0BsJCvR+70DZkhxUyY6QchdClbz7WM+BxdTfYZp/sAU2jb2V/0BxQutd4Z/3DcU1vsiNL+KA0JyyOHxsOX9n/DGtyDQwB7fcxodZRbm3JZ+hiNHK2BuFUIa4D5l22LxdB/wB6QUqHcsBjUr1DkEmwJ8DlPcJKgFhFRR+lz4oaHPu+sWr4/sqbd6v0CTO5aOwdhTSajavw2rHSy898q1eynfJUot6aAHUW6jPTWMXXoPkMhUfIpHu+OLlr6d2TX0uv2GtcyAhImI+2qxiLkHR74FONWZbxcNkZhDIpuBCAxB1oXWsqNzWptJFpCaV8+XLsVdF835QZpKL5sf+XNOKZmS1jIvOppowOXUOSeorZ1gyPLUpsCZBJYukXdETKNvhCMvJhQMnu4lVnolZINeHKwUyBIgd9Gg2rUUAhrBAPF3wUWH+XdEZcl0bIYmE9hROC2OLpo82GqsxbpnhSt7KUwJFphSGi/fml/p0bZv9wpJzAWvJ8h16DIRo1LV0EfL78H9m0zBd8cB7mmRoeEvEWaIinloLS93lZz87g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB4972.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(38100700002)(122000001)(5660300002)(9686003)(316002)(7416002)(186003)(4326008)(66476007)(91956017)(55016002)(66446008)(558084003)(64756008)(52536014)(478600001)(54906003)(66556008)(110136005)(53546011)(26005)(71200400001)(66946007)(86362001)(33656002)(8936002)(76116006)(8676002)(7696005)(6506007)(2906002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4d6t/H0C1J7T08fFTJtfiLHJ8FXxyBRadbmBZQdDE7lEg+5gIlnvS+NEOTbN?=
	=?us-ascii?Q?7ql4nGMoFwLXAzUNX6kBp4GAfMZTEpoPDouIMxnjpUSWA6e5E4AI/6HaRGa5?=
	=?us-ascii?Q?zgv9dVIsdFv6/PwwHxtesfekgJdjcO5kSk8VHCAF8WZ6phbicGeBpP804lal?=
	=?us-ascii?Q?F6q12U4zFmithELhpQroIgsO5GebpkZ4dI/dJNvmC6Ch92jDMVOB7SCS6lDn?=
	=?us-ascii?Q?C9+FONAdoJJi3S8o1HHoF+eMu2F940ca4u2bvw4LqN1qBjR8AH/LOOJoF1Zb?=
	=?us-ascii?Q?cPemMPZzhwwOvQqenEMjMkydqF954yX1sFCOw4e2uGJvRZx1m9inYscLuKMy?=
	=?us-ascii?Q?03M8n5nUNJ6vbYgdBootbZz9TmZIYXzujNUiWtd9XfjQm+/YmBLc7auo0U7/?=
	=?us-ascii?Q?pCJsZigvZT73tad6thSqY6L+Xi3p9bVC4qZkBN1Lo+zn6Ja5wI1ZI3D3di0s?=
	=?us-ascii?Q?CHlxEHq+Vsj3ZNSBQjnQ326o8QXF6D14UB/UQXmTu7Of6cyNHuLo0ILfgflu?=
	=?us-ascii?Q?BBoSbIJY+Sj6i4rH0jt0c3nMoLgCN3WuGiFjURrlViwTu+EY9+HKCdZhjS/B?=
	=?us-ascii?Q?g3ZG30QNKcEbJvzkYkFZurVw5Nnovimg167CPCDK13VrKn+dEypYpd5eJzot?=
	=?us-ascii?Q?+v+JPkbOJztjOn3sV/x1F0gMUGz2D5HUHETEViyHOV67aiZVUl0mzGF7DxYW?=
	=?us-ascii?Q?FZyGmPDVtctdyp6ZbzY1tKgCd8+0U45x+Rj8wv1l3ClCOSuAJWvOE3nsfY7q?=
	=?us-ascii?Q?BKzyNBCNy0TyG64gfujY43KP4qYja3RFybr3q1bQt3WnIQbvV3xScYnwfWYA?=
	=?us-ascii?Q?9TyeTXeSkglKEGy0kS3EZ/VYhbg8pyLZ+PIkcuI0UOK05u3VzZwZAbcwnWzd?=
	=?us-ascii?Q?pXjTvDP4C2nXLbzo2jBDFY3IS+86iWP9rH5k7BljFAmIWMXJPCT1Ji71l9Kx?=
	=?us-ascii?Q?y/VcBGVdS6I2ZfF867F7lXL+FMeRzfmfij1IzPVSwVnZ76WRRE0KyIcCeCXi?=
	=?us-ascii?Q?Ala9vH748sGci52r/a4lGi6Q1BIUtK4012j1tZttV6/KbgIoOQvt11b/uwXI?=
	=?us-ascii?Q?H4leATUY+fzrWxE41CjjOGLQtMAWOLzeewiFyXrgvpbtl0j+C6W4GRWoKtay?=
	=?us-ascii?Q?uCIr10TEs+mJKoueqx4xuGkyuyjRhdwv/+bNqZsNeTKyuiPp+JEV99T0PMRM?=
	=?us-ascii?Q?RVWi2edMIPcURl3kGyg+TlMsrkwVeGeHIz6GIjQUU7NvO+X7M14subh3BwaH?=
	=?us-ascii?Q?65FeXTQnczKv1yMlLZo9ySfciObvMDGnlaq2OYsDnC+arZcJJwnHiXanXGKB?=
	=?us-ascii?Q?Tj+jRTTZJkjrJCNzIOzgZw46?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7598f6be-66d2-4267-2bcf-08d92aaaf78a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 18:26:43.3521 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pWkE2rApkEXLlDjnRSuOKRlnpQAi0sgnOy2G3AuTbZU7BH/prbb1hbgUdpf8It9+mUWfEv9M8O6poBEA/YvA53b0qYWInRXQtmPkam0coqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6985
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 158IQqlT000556
X-loop: dm-devel@redhat.com
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>, Ira Weiny <ira.weiny@intel.com>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 13/16] block: use memcpy_from_bvec in
 bio_copy_kern_endio_read
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

On 6/8/21 09:09, Christoph Hellwig wrote:
> Use memcpy_from_bvec instead of open coding the logic.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

