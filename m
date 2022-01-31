Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9139EC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jan 2022 11:50:58 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-Dk_ztmMgOICxS3DaBdvqkQ-1; Mon, 31 Jan 2022 06:50:53 -0500
X-MC-Unique: Dk_ztmMgOICxS3DaBdvqkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF662344B4;
	Mon, 31 Jan 2022 11:50:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 240DD752DB;
	Mon, 31 Jan 2022 11:50:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7AB394BB7C;
	Mon, 31 Jan 2022 11:50:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20VBoePB022615 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 31 Jan 2022 06:50:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4313BC07F46; Mon, 31 Jan 2022 11:50:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E737C159F6
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 11:50:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FA0B3C01D83
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 11:50:40 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-179-f9XowrX1MZaXWPoThENhcA-1; Mon, 31 Jan 2022 06:50:36 -0500
X-MC-Unique: f9XowrX1MZaXWPoThENhcA-1
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; d="scan'208";a="191798219"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO
	NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
	by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:49:28 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by MN2PR04MB5504.namprd04.prod.outlook.com (2603:10b6:208:df::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15;
	Mon, 31 Jan 2022 11:49:28 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::8d9e:d733:bca6:bc0f]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022;
	Mon, 31 Jan 2022 11:49:28 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: "chaitanyak@nvidia.com" <chaitanyak@nvidia.com>,
	"a.manzanares@samsung.com" <a.manzanares@samsung.com>
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHYE018isCsN3oz40OdcqzMcXhV7qx5YsQAgAOn04A=
Date: Mon, 31 Jan 2022 11:49:28 +0000
Message-ID: <69241add19fddd4168c9f2ae15fd08e8e701f8ec.camel@wdc.com>
References: <CGME20220127071544uscas1p2f70f4d2509f3ebd574b7ed746d3fa551@uscas1p2.samsung.com>
	<f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220128195956.GA287797@bgt-140510-bm01>
In-Reply-To: <20220128195956.GA287797@bgt-140510-bm01>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0ff18da-5e0f-4426-bea0-08d9e4afbc83
x-ms-traffictypediagnostic: MN2PR04MB5504:EE_
x-microsoft-antispam-prvs: <MN2PR04MB5504CDC48A827E32C76F7C279B259@MN2PR04MB5504.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: LIHDYYF+rdDLpnzdS3fsShR8EgtehxgMmccET5xwjGkfXw10zRKpHKcG7/PB6BTG2EJOOQhDyopvZtkpSZhYDprldCjAk2/T0WS1oJ6+3nnEcao5O/J8OR2eLP7oiAe3G85LMq1fh7tBE5/790Q5pz/zOOKyKZLWniBwK0U+suTtbbimXoKwSnT7TiVfSDIk81xgiJUhitV7peqIh9+NdSHvmFeMSnu4AEBUxJ12vijRId8uebu7LcucwjSKXNhk8VHugUnbHflKZtF5WECXt246UTQZS10S8pJf7qmmVkZk2lT5oHDmC7xHTpdSLOX+0L14ndiZk1Mh87E9dKGoO1xwqrNhn/fA+0GF+nmDOKVPjbpuEJkzxTYy8sYMwN059Deu3HDYIWsHQMMiCFfz46Dkf+eaSMo3G6tN6DUUmJc8CXHIxyVKWPLtbr17TjZuIRKsbbk+7BvQFyz4Bo2KyYxni0yapwvJ0nKZ4MNscRcKzBq0GuuBeHCsiNrh229ABPBW4UmfA9EBE4HpXJiLYdPLlz82b4J+60o9WuJvaXRswouhm4t/CMwRCWEjptJgfbMNF38NlHssC6RctwqAUvQwB0VMIe6vPu6Hd2QuyE5r76YGYiR7Bbi9y4QiWBpSAN6EaHlE++EFtou+mLZSNrSrmqYL+DZFyofZtdSInsTcQiYxalJ0SG1/9RVqu70u2ex8TKc8see22WduPRs1CQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(82960400001)(38070700005)(2906002)(4744005)(122000001)(6506007)(6512007)(7416002)(316002)(71200400001)(6486002)(54906003)(508600001)(26005)(8676002)(4326008)(8936002)(64756008)(110136005)(186003)(2616005)(66946007)(66556008)(66446008)(66476007)(91956017)(76116006)(86362001)(36756003)(20210929001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ck9DL1Q4WHpGbjNGSnAyVG1qWmJtU0MwQzdZbWY1VWtYS2hQcVh3R0pGRkNn?=
	=?utf-8?B?eFFaQjRQZDhidGtMb0lHK0h0Y0ZWMmxoK3g0cTQyRCtjNnk3cCtCL1RIRFBh?=
	=?utf-8?B?N3BLaE1zWVp1TnFkS0QwZUVPMjVVRkw1OFBqSkZTZm1SWjROaSsrNGRYdWE5?=
	=?utf-8?B?Yy9XT2tLL1VIakJYWW5NeUp6WTVSVVJuRm9RbU0yQXV5endUMGhveXVQVEVn?=
	=?utf-8?B?dkxIWVBLdzQzTDh4MzBLSDV4Skp4MmVuZ2tTQTkrUnBFdzdOeEYzSkpQYysx?=
	=?utf-8?B?RWRxdlY2NFhQeGw0TGVlcit5SUtORWtIUTc4NXNhVWsvNW5ySlpxUFQ2ZWE2?=
	=?utf-8?B?RytzTmVFWklsVjE0dnl4OFF1SjJPQ3dZN0diMVNsOEQ2dGx0RjJ4Z3RaUW00?=
	=?utf-8?B?SGEwd0lxSEdFdTNob0RhN2ZJeEdRZWpaUTVOV055ZmJaaHJRUjNnVVJHdkZO?=
	=?utf-8?B?YVJEYndSRzcvdDJIL2dtejV4L0hReG45aUJUS3hFZENNb05iMVFMMlJxS1pq?=
	=?utf-8?B?OXZVTllRZCtpMlpxcEFjUkZydmxkU3dyb1czSUE2MFM0SmViRkNvcXgwU3BT?=
	=?utf-8?B?OUZZOVgvRlFrR3VDQS9ienlwbnJOY3grcFFpOWE4a0wwUEkyNTFlaWtRMlJZ?=
	=?utf-8?B?TEtCVFpnUDJkeWM5VGxYQm92VzBGRktKZTVraVhyTmdSa2lYeUcvMnl5M3Ri?=
	=?utf-8?B?NVNOM1JvZGh6cVpUQkhNT0JUYmtjSkRPNU5XdzZjckZEaWRhV1R6NlJWN083?=
	=?utf-8?B?aGZJeDQyMXpPbFhLRXgvUE1mRUFhQUNBMzVOZXNIcWpETGgrOVZ2dEwwSUw3?=
	=?utf-8?B?VFpKL0VVblFmb29sTWRzcWhCd2owYVlzSWFQeDk0eUFTbEJ4bGxZTVRQR2J1?=
	=?utf-8?B?bFZqTGdOMkZ4dVYxdE9GTHNCUktNMTllS3YzK2kwQkgzZVY0U1N0TEYyWVo4?=
	=?utf-8?B?Mll4R3hKM1dQbHJkRFRISHNXNW96WFlhTkNYclIxKzVKYjJkaHdwY3l1bldh?=
	=?utf-8?B?SnhiMjlHU3BIVnBQZ2tqVVJKUVpMSWFweUVaQVcwTkZLRFd6MU5EV1RVeVRQ?=
	=?utf-8?B?SXZ3a3FyVGJsWTk0NXM2am54enorUXllZlg4ZWZ5L01FYS9Ra2N6SFBwRU1F?=
	=?utf-8?B?V3AzTHYyTHVPZFFpa2JLSkF5TEpDV3JiYnJVUm0zNU1nYkRYN2NPazhqTTZu?=
	=?utf-8?B?NGZ0WmtBMHRCQVhJek9NSjAxZlRZNHJ2UUZUdFBPbDNQNlQ4N1dnTjBsWHly?=
	=?utf-8?B?ODM0UnZYRHhMeE04Mk1GdkhtYThOL002dU1WbHVzRklNNjYzbnh6cmZIOUZk?=
	=?utf-8?B?eTZ6L0xRcWVnTEFYY3VvblFqUkZ6ZEkvcE5yNDA4cG1aS0lKb21VdTREV0Fk?=
	=?utf-8?B?alFMdnlVQ1dVanM0RFAreXR3RHJjSkgwcGJRTlluYm1Od2R0WWo0OFVOVkNO?=
	=?utf-8?B?eG1LZnkrbkw1eTVSSlh1b3RaYnpkNi9CNkQ4TVRncFFjK1JwOXF5K2hDeWVO?=
	=?utf-8?B?bUd0QVF0ZzY2VHRUTi9ickpjRElLVGl3eUtydnJnb2wrcXZqSkpkaGFVaHR1?=
	=?utf-8?B?RTV6NmxjL2owc243aVB3RnBWSUpIaHRLdmNkUnk2dlVvWjFMK2ZEMFVrYVFr?=
	=?utf-8?B?VTU1UDhGYmQ0S09TeU9OM3NybDBnMkk5QmZzSmpQaGtvZVE3TTB2Q2JpcGY4?=
	=?utf-8?B?TFVXenlQWEdVQ29NYTMweDhUa0R0YnVvUnRXZm9XT2oyUkYrTk11d3VUZ28z?=
	=?utf-8?B?K2piZkJ2d2trTmRlSWlJZWRKZWl5THNXYm1Na1pWOUxQRzQ2K0IvTDNkWW94?=
	=?utf-8?B?WlV2RDRRMjZkRDVUV25oYTE3bHRyTkZIZ2pjTnZXVWgxWEZzNzZxTVlPUFhO?=
	=?utf-8?B?OWtwcjNabmh4aTA2VjYrQUxCeGVmUUZORTVTbmVGUFNLNmlON0c0cXE5eVVO?=
	=?utf-8?B?MGg3MVVORDF2dXFSNFJNTTNSUytxeGtjbkhrT0RTNDlJaGppRWozT1JvbDdr?=
	=?utf-8?B?V3BvbWM0WGtpcHEwRGhYb1dwNkNWTmhWRE5sajNUaDUrM2JrbzlnSmV0ZGxk?=
	=?utf-8?B?cEdrbUdpeitueGhOMHZOOCtSNDhMUGNmOE54aS9Cd3BkRzdkT2hOVm9aanpK?=
	=?utf-8?B?MVVBWmhrL3loS2RvbWhZU1dmTWF0MXhKTUlGVVlOSy9Xdkw0Vkk4SkZMNnh6?=
	=?utf-8?B?ZjVIRXBza05aNTRXY0p6VDU5ck1SUVZ1aDFyaUdiLzNrZVo2TWdWWVowQnVm?=
	=?utf-8?Q?BNkE+4TTJlJrTLcYn3CpgRGlhf+kfX5XldD+DuTuyU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0ff18da-5e0f-4426-bea0-08d9e4afbc83
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:49:28.0609 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eg0MHbXRUbhC34ECSqEe+qbDjTEN2Kb4i+M/iL9UFSUdsctihkRTWzOqS8rYLdrCNSIjGilxGTYji48QtMnffMWmD9T5IOugqEKmUKn/PVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5504
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20VBoePB022615
X-loop: dm-devel@redhat.com
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"hch@lst.de" <hch@lst.de>, "msnitzer@redhat.com" <msnitzer@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"osandov@fb.com" <osandov@fb.com>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>, "jack@suse.com" <jack@suse.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
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
Content-ID: <CD1311B6D0A3A44CB966E8F883FADF5F@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 2022-01-28 at 19:59 +0000, Adam Manzanares wrote:
> On Thu, Jan 27, 2022 at 07:14:13AM +0000, Chaitanya Kulkarni wrote:
> > 
> > * Current state of the work :-
> > -------------------------------------------------------------------
> > ----
> > 
> > With [3] being hard to handle arbitrary DM/MD stacking without
> > splitting the command in two, one for copying IN and one for
> > copying
> > OUT. Which is then demonstrated by the [4] why [3] it is not a
> > suitable
> > candidate. Also, with [4] there is an unresolved problem with the
> > two-command approach about how to handle changes to the DM layout
> > between an IN and OUT operations.
> > 
> > We have conducted a call with interested people late last year
> > since 
> > lack of LSFMMM and we would like to share the details with broader
> > community members.
> 
> Was on that call and I am interested in joining this discussion.

Same for me :)




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

