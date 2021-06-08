Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A73C47082
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:17:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A6C8D61376
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:17:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6C8D61376
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-WYmOseRkNIS4rrWNZDsMKg-1; Tue, 08 Jun 2021 14:17:49 -0400
X-MC-Unique: WYmOseRkNIS4rrWNZDsMKg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1A67A40D6;
	Tue,  8 Jun 2021 18:17:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DF9D60CC9;
	Tue,  8 Jun 2021 18:17:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A749044A59;
	Tue,  8 Jun 2021 18:17:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158IHcuE031026 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 14:17:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 24E99208DDAA; Tue,  8 Jun 2021 18:17:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FDF2207AD3B
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:17:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4368A82A6C6
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:17:32 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-399-kkVUPH1nNWSUK0iHKOBoqw-1; Tue, 08 Jun 2021 14:17:29 -0400
X-MC-Unique: kkVUPH1nNWSUK0iHKOBoqw-1
IronPort-SDR: BzS6SJuUoXgk71uTJDIjDvtVlhSymqi5vTqGpIuIluZL3VpBo96wmsoIXEOxMZLa9mS68W1X9Y
	8o16lZGK6XEgQ0OlSjviuH2yMOtUPqr8VAF/9T6XnOiO/xgvsSZkygZWSql4AbVP3lxkLVSukd
	We9RhfZuWYClXeFSHmzaN30+7IylCEwcLeHaMQXeNxoahjjKNi2SOppsGcNY+fTPzgRiPxPUXS
	TRBLVCb2fZnOVkBBaivuh8b67dmr/yuz3+NzZhmqn35O3qcneiLBcMndATuUOQXNQ6uoJNYWQb
	Amo=
X-IronPort-AV: E=Sophos;i="5.83,259,1616428800"; d="scan'208";a="282615982"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
	by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2021 02:17:26 +0800
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
	DM6PR04MB6282.namprd04.prod.outlook.com (2603:10b6:5:1ec::16) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4219.20; Tue, 8 Jun 2021 18:17:25 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f]) by DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f%7]) with mapi id 15.20.4195.030;
	Tue, 8 Jun 2021 18:17:25 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 01/16] mm: use kmap_local_page in memzero_page
Thread-Index: AQHXXIBI2JSYXt6T1kCEOMTspmhp2A==
Date: Tue, 8 Jun 2021 18:17:25 +0000
Message-ID: <DM6PR04MB4972264CC608AB317399E61286379@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43dfdd29-9d11-4890-a2e6-08d92aa9ab01
x-ms-traffictypediagnostic: DM6PR04MB6282:
x-microsoft-antispam-prvs: <DM6PR04MB6282DAB984B76ED96C63DBFE86379@DM6PR04MB6282.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1775
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 6ruaS8I+RUu2n9DmKOGmjVOd6HxJmTpIB4YOG8Ji4gGielpJqXh40A3JPqQpCpXrCr3OHEQSNAVuM2lMgKe1oMx0zXlNieHd+DrUQfO0XhoQwJtdPMl8vC4M8dDVLILkL3yhE24R3jYGVPtWxnI2sepWzx1itbqrf9BcYu0KNQyoGV80OXJ2anz9yJI3uoYF0+xqsYq0QcxQVuoisRumKY9cGuc3ou30/Iw8IxkoArfsPfok9+BCT+bZFS0L8ZcsNoP7h5k6o6u3BD7leCMjz3OzaIINxDbAQC0TGQ9ccttJ6y1zDduX/sxgMXE/lWRrSG6PWeTJd/0X8wlSdTvK4FALfJQ9d9u29TBIJBZC3iNQD/OZwMzA+1EEEGk9EnnP0cS2CE7c8csDVbYQO2bogW5Jl2e1VqVF3oR6fK3VXUcAmJr0L8L8joLSxv3Jwgy5EmTP+AqYndZdsfPJ0VIJa7AJ9Kwdnr4OpB4L3o03WOZOQAYqO35pskrMfdbg5Lpjv8aH4/qc+HAyMqtXWGfaXMA/omSEjDaq/ypMzheriLCu6+dxOCsQPmCcBDIe/SiHYzAAxxdvrS31zsJlFU31/RF31sA35YjOG4viMFtVjBU=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB4972.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(366004)(39840400004)(136003)(346002)(376002)(66946007)(91956017)(76116006)(52536014)(7416002)(86362001)(558084003)(66556008)(33656002)(64756008)(54906003)(4326008)(66476007)(66446008)(38100700002)(5660300002)(316002)(110136005)(122000001)(6506007)(8936002)(9686003)(7696005)(55016002)(26005)(2906002)(478600001)(53546011)(8676002)(71200400001)(186003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KWu9ec+Btv+txWazbaPJ60igZinu79R1gzfg4g+t1hdCEIwwkjPMDWpaS8o3?=
	=?us-ascii?Q?waD0W5/nnjhvkxBYNen1UrZTljvjUzi/mGzon6traq4UuCngSwdEwjQ1si9E?=
	=?us-ascii?Q?PXhjpKzuJtyQ7c86DU1zgMufCwgvnnjdQJq9/CcYWUMymgchQGV4laDLT0N7?=
	=?us-ascii?Q?IkGQ7iwoIdULJBE871RfmKHomfKpWtgUfHGf4t1uHWmvPcHcSjdwdpM9fpUh?=
	=?us-ascii?Q?uz8l39qH6gpXYXeVcv5zt/GEhOioT1+pAQda23hlNlmrrbr4hp2ZMAk/zm7E?=
	=?us-ascii?Q?xAXtHKf3iBIbcEVIsNdL3TKfq4iQLKoRdM0YSz6hWkW5apT0viLaaouCRaxh?=
	=?us-ascii?Q?yh9HoxOWWJNcdWixg7EtR72L0o/UhMNuvGxePCJaRLltQO6kaokANBavthjb?=
	=?us-ascii?Q?fxNo2rimmBHo4uhHKjkzyrImQie5i1XwOcG/xvr3yG7MxeHZ1H0cLJOM8DNb?=
	=?us-ascii?Q?UVBsHVNOHauDx57kpg3J4A7wg5nejASM0RV/+lMsHM5EJp47+tAXAkju6esr?=
	=?us-ascii?Q?e6VanfyOCDCm5ta4MxWwyhrfGORhen5cANFz3rXXIRIpm9eZ4GAQDaS5KcYS?=
	=?us-ascii?Q?JvIFc5X3HcJmqG6+5r6o0WQpZTLOXQHmBWkKVhlnRc6SLaXHnOND4olh0XLg?=
	=?us-ascii?Q?VRhH2IfTdWLkAKEGZ3NA5TEW0AL3eZUh32HFMS2YQH+BSlJMenTNgDzFh3qw?=
	=?us-ascii?Q?Ve3BOZ6R0gUBlgNpzxjQyXJYw7SndvLxIemc84WT09pZV1E5fMwZEhEJEyz+?=
	=?us-ascii?Q?VJCJv8/KDYneWgHQI5AJOvbkPprxNPpZTfbPJzHSIVukbpg1AwgmbNFUcrss?=
	=?us-ascii?Q?2AEJwq6AzxrNJUI8w+1mXhw3V30u4opwe/059eLHkpS1Qq6v6Rpj+PFjWzfs?=
	=?us-ascii?Q?Ehjlt4sqk3HqNcKdjyY/TAKSXDS0SeggLRDCtwy8YGC0JdGtWlMmES7Z3S3g?=
	=?us-ascii?Q?sRz8k6H7uoWel+sZanGdnI7ODgnsix14kMeKy4Ya+yq2PtjHRRcwHevwnDzI?=
	=?us-ascii?Q?YxnRVflMOKIszEkpVYSpD12l7ZzpYH1gMbY6OqemS+F6kAY+EGAX5IUAl6te?=
	=?us-ascii?Q?rGfdUleJ6qLjcQSJ/FsJiKVUUUcI/U4OtbYMIRcxdEbs0U35u1W0JD2hqALP?=
	=?us-ascii?Q?0HNl7C0vujnCKO6OiBKccHs8iwpSkbZIALxJ/qvbQTqVgGtvwwbV4+BXpAUm?=
	=?us-ascii?Q?JeBRUcY2j/rqdnte0ppfDjOuWjpe6GuEYAoez/VmKP8/P8zLo1mAD288A32F?=
	=?us-ascii?Q?zZeIrSS9tOuf50BhMkDPQXj7kD9ezEEADin+qkxAOXtBoPp5lXNn4ArVpadP?=
	=?us-ascii?Q?r07+8XZWMICbON1JhAg3TUcm?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43dfdd29-9d11-4890-a2e6-08d92aa9ab01
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 18:17:25.4237 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qAbO1QtoyijiRZ3KzjzmMBpSQJCTsiRuFkfAALgqjMzccajpDKEYvTLXNOH2bkqe2gO2SasHapjav/XGW9traQb2ZjE301Xf/XHRmKJeRF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6282
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 158IHcuE031026
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
Subject: Re: [dm-devel] [PATCH 01/16] mm: use kmap_local_page in memzero_page
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/8/21 09:06, Christoph Hellwig wrote:
> No need for kmap_atomic here.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>






--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

