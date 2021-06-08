Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E5DC47082
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:24:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE71A61380
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:24:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE71A61380
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-s2nWuzbgNZuvcV2ALkD3zQ-1; Tue, 08 Jun 2021 14:24:29 -0400
X-MC-Unique: s2nWuzbgNZuvcV2ALkD3zQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 043808049CC;
	Tue,  8 Jun 2021 18:24:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B8F0310016F8;
	Tue,  8 Jun 2021 18:24:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5218244A59;
	Tue,  8 Jun 2021 18:24:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158ILsNR031461 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 14:21:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9B968103F27E; Tue,  8 Jun 2021 18:21:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93C53114B2F4
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:21:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3622F182506C
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:21:48 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-382-tBLKWqq_Npe4xK-A2giKDg-1; Tue, 08 Jun 2021 14:21:43 -0400
X-MC-Unique: tBLKWqq_Npe4xK-A2giKDg-1
IronPort-SDR: D0EOo9vo6Sf64foQ1iOLke0jmUi3EfgYvZK2+CznZ2dbOowV2PHZNwrPl43u7kzR7Krn5/H1yo
	LepnCSxNl8Z2ER5ULftVyPBEEKdfruKa8cKCuMfJok722P7Hj95/WO6JFepaewqk5xINQ5zO3v
	K9bYnk8kRecxezDV1PddaypfNg0bBXtcU/CeO7awg9bC83v10ahPaB4mHq8kNQF9rfuXfOwMpf
	t5z/AqIixd7OrvkXBOYDGogI9SyIwg39aiE60NAWXvPzFWvhsiyGd2a68A0cBDcCO+GsOBjqUI
	tSc=
X-IronPort-AV: E=Sophos;i="5.83,259,1616428800"; d="scan'208";a="282616841"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
	by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2021 02:21:41 +0800
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
	DM6PR04MB4587.namprd04.prod.outlook.com (2603:10b6:5:2c::28) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4195.20; Tue, 8 Jun 2021 18:21:40 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f]) by DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f%7]) with mapi id 15.20.4195.030;
	Tue, 8 Jun 2021 18:21:40 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 05/16] bvec: add memcpy_{from,to}_bvec and memzero_bvec
	helper
Thread-Index: AQHXXIBV9T5WIt1S2Uab8yp3MsdRyw==
Date: Tue, 8 Jun 2021 18:21:40 +0000
Message-ID: <DM6PR04MB497275ADBEE4B142232A130E86379@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-6-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b7c664e-3f6d-4280-901f-08d92aaa42ff
x-ms-traffictypediagnostic: DM6PR04MB4587:
x-microsoft-antispam-prvs: <DM6PR04MB458743C046E044061DD55D5586379@DM6PR04MB4587.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:404
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2LwhJ1dkneYYuTX5r6b7umT2DO2BH+Mqbg0qGPCGr0t/4MK26uw8SLK5jj3VhR+BI7CVoxCtFoSAYAw7+RRz4LVjemWWB63e2vrfvnvm7CroIrXcKdQh3wXh5iu1LX+G3clE7xai7Wn565MHM+YdnbuQ73cO6cTqb1OT+6AAHPcj+BPjWK9fdRvpt2yB8C7kA0OeARnmoH3gV+GKiVEOa3us5Neb7fGewaO0DB7jzGfkgEXkB6CHmRA/98I7AgJsksybRODeV+2A7Ny9ASjSGjG2WrXm9ETRhuZIheE75fIcpR7nUdQRlD0l2rveDPfmg18endw6rFulgf4YlhExbBYxw9H33lAQslC1OuveKZ1pV2KD473j3672l7H8br59QQ77j+qcHDMxmXfykNzAqSN0FC9hTVijWtg9/+JQVWflANzTLP/b4lFM1zLP+7V5gqUb7mtkcw1byTXfxJc7YrFTs1NCPLjhZ3vjmIwHYb8FbckBnUEuU7v396Xa1Ti65lcwCdbcxazQhD1Ogoasb7CXVh91sUPygS9dtXiN8/NpBQNJQTglcXvWOZXV1EWuTZc0Tbg5hTIinLdqqHObKf0yr5GunStR/UFm6o5Qv28=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB4972.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(26005)(54906003)(186003)(86362001)(4326008)(110136005)(6506007)(8936002)(66556008)(52536014)(66446008)(66946007)(53546011)(7696005)(71200400001)(9686003)(64756008)(33656002)(55016002)(316002)(7416002)(91956017)(122000001)(76116006)(558084003)(5660300002)(38100700002)(2906002)(8676002)(478600001)(66476007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0V5fxzwjnqTJ9LlohUc79NiL/d13as4ZcMTX5FdlloDgnSvjNI1liWVpwUC+?=
	=?us-ascii?Q?k2AMIkZN6+0EDos+paTrEo5QIea/KfohNdxHDFttu6L2Kd3Np50Srae/LCfx?=
	=?us-ascii?Q?oOnm/Ighqo0GNRa4PBq5AnAzQPWRHPSF0IrZCrHQ2FaqYy6sB7EPy+zqsmlN?=
	=?us-ascii?Q?ov8XS6AA/DkquDdZ+rIwKkWgERGhS/W1rAZm6KYAsoSRJglk09+4eu62tEEi?=
	=?us-ascii?Q?JK/iJAf4lNjStGiCuyBHclQyPT/tP8VPzRCvShHaxtKbfpaf9pxh+cfE9WAM?=
	=?us-ascii?Q?ALoZpSj4p+m2FMnHB4Q44eYO647fHjhbFiVik9V988JXreDiZ0xfIEFuR7Sr?=
	=?us-ascii?Q?cbuT/U+M25ULVQsywu6RUZLLOxoUktNdJGlHbuOtipsN+gWkRm0dE3QPTJ1K?=
	=?us-ascii?Q?24BeHjBw287iaf9FLrlcJhfOgtC/v0sjAsCiI/oT+QcSBWWFCmx+uqXGNlY9?=
	=?us-ascii?Q?rknNps6lBrJ+xkYY+IWBNEYVkuilXwvUNUrmeYBt9YjBS9i6bJB2D4wYOpE4?=
	=?us-ascii?Q?aq9lUJ1EvL2hTbp+hrIBoBRyPsZqMNctqW+P69UbLgIYZlU9HlXS4qa8inRT?=
	=?us-ascii?Q?HwUfno1nR0SLkZBLIJ6vO7unC8fq8Z1OzSItXNdHYbVXmoVAdU5T2ZQd1KA2?=
	=?us-ascii?Q?K846R5hn3WGkNKx3nEpgAGpmdbkOzpC51Q5Z1vgtTVVkxZuy1fRO6PvupUfk?=
	=?us-ascii?Q?ZJCtBQ8IZ7DcFbiUKJdr3IUMXiNPAnldRcl9yMrk57k8oKXrDbRhOTrBkcTd?=
	=?us-ascii?Q?ROpefMAP0GNQc80qKMAhN1CwdWwMD/sabu13wpEs+vY7Qye+818WjOu0BxvT?=
	=?us-ascii?Q?mVOkXnWWfSXjgbJMq5s1h+t4BniyS0FRcEpbbGhxi7wXJkxQZdeAUX1ZCYZ/?=
	=?us-ascii?Q?H0B/kmI7NA2usrkcHLsIgRcD6exGgm79BwaAsTF3q/n/FWP7E7ox+o9gyPvV?=
	=?us-ascii?Q?BdOeuocIgnMkinBnt3odSNH+M5/c5YaBYWzL0pQ4KGvx8wQK3h4AVk+MIwtT?=
	=?us-ascii?Q?P5cqcUggdwKSoc0i/ckA0wuXYW6+3AVi34t4JRSrKyyK1CsMk7/GXODIQdZz?=
	=?us-ascii?Q?uPoqskkPVn9IFWTe+C8E1x4VMz7EdR485p4FhKBGpJGZfya+3Vkuycw82zyk?=
	=?us-ascii?Q?LKYaAKbNArkcH1pW9oEnATmwtj4o/H51XJStcslRignHnoW5Ffs/bsdD1Ot4?=
	=?us-ascii?Q?8oA0uQ0ntYtYY6F1S+Il/7bn5NmM0o5CpgG7joi6b0aOVV8fTIoT4Rtu5nkg?=
	=?us-ascii?Q?YMiM2vfUgIIgIRZqBcdjNMHQ5epxN+SoPBFz2SwlUWHOt3uIdy3TGstqZzUV?=
	=?us-ascii?Q?uElufMxsSx1CQW+d5oG4mt9C?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7c664e-3f6d-4280-901f-08d92aaa42ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 18:21:40.4648 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CEHBPI53GFZGoZKQIAmINWn74moJ5tth10uMP6xReaQTZDdz0qaMiehkBnZBDrqsXmdsXpbKHNKkjEyYtFHCW2cugW4NnZW3Y15qVZo68U8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4587
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 158ILsNR031461
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
Subject: Re: [dm-devel] [PATCH 05/16] bvec: add memcpy_{from,
 to}_bvec and memzero_bvec helper
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/8/21 09:07, Christoph Hellwig wrote:
> Add helpers to perform common memory operation on a bvec.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

