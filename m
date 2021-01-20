Return-Path: <SRS0=zaPp=GX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC1FC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 20 Jan 2021 03:28:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8FB49207CF
	for <dm-devel@archiver.kernel.org>; Wed, 20 Jan 2021 03:28:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FB49207CF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-eavdwQZyNDOG5FDYHFs3WA-1; Tue, 19 Jan 2021 22:28:23 -0500
X-MC-Unique: eavdwQZyNDOG5FDYHFs3WA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B01D800D55;
	Wed, 20 Jan 2021 03:28:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AAECC10013BD;
	Wed, 20 Jan 2021 03:28:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8B9D5180954D;
	Wed, 20 Jan 2021 03:28:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10K3SCf8006907 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 22:28:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0E6721134CB0; Wed, 20 Jan 2021 03:28:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08CA11134CAD
	for <dm-devel@redhat.com>; Wed, 20 Jan 2021 03:28:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64341800183
	for <dm-devel@redhat.com>; Wed, 20 Jan 2021 03:28:09 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-593-1XRqnMYgMguN9LWkkg4EYg-1; Tue, 19 Jan 2021 22:28:06 -0500
X-MC-Unique: 1XRqnMYgMguN9LWkkg4EYg-1
IronPort-SDR: 5+xZGKwR+vWn59Bhi8mkKXqNz/iW4w9Vnu9yAMcqM7RBpWTonEGmyTXdWeHqap0mKuHzjPub3F
	kgz6zEPhIoanstfyptbr7W4g57Bpiof0QZAMtTOoXa/rDvjPmSz0nab0wpZJcAry9GnAZ8+qcC
	M3b7Rsuhp8LY8AgjbdN8oEFWgMWeg2ZnqeOsT8yp/K2it2xvQgYSpT/y5b9E/hAldiyfDW2Px3
	/9Iq5djCd2PWE28ff0fVjFhEynFv3+Q3c6J+cJMdUYE1InGosCicYxFZO8mhm4eSrukifCaTdo
	RGI=
X-IronPort-AV: E=Sophos;i="5.79,360,1602518400"; d="scan'208";a="157859380"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
	by ob1.hgst.iphmx.com with ESMTP; 20 Jan 2021 11:27:58 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB4872.namprd04.prod.outlook.com (2603:10b6:a03:42::27)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11;
	Wed, 20 Jan 2021 03:27:55 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::716c:4e0c:c6d1:298a]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::716c:4e0c:c6d1:298a%6]) with mapi id 15.20.3742.012;
	Wed, 20 Jan 2021 03:27:55 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@tron.linbit.com>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"cluster-devel@redhat.com" <cluster-devel@redhat.com>
Thread-Topic: [RFC PATCH 00/37] block: introduce bio_init_fields()
Thread-Index: AQHW7iDfXiv5iuHOl0mGSxMcJ7OwhA==
Date: Wed, 20 Jan 2021 03:27:55 +0000
Message-ID: <BYAPR04MB49652C7B57396757FF064C6686A20@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a5b4c018-b955-4aff-42d9-08d8bcf3608a
x-ms-traffictypediagnostic: BYAPR04MB4872:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB48725C6EE06AE9513255BA5C86A29@BYAPR04MB4872.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: lqw/FI7V3h3I7N6LUDiMWfhW2chPZ0fK5VoXZLC7RQTD04IRNr4lXPyMYMfMUREUCjhqbsEYNkR0i0ntiSZcIAZqmjdF57HMmj47+NooF42/0RPaWT26C5YZdfVo75rKokHq9PHjl7dxwLYdYsGdDfeeSENfAfCuDQ6aQWFFVFPiLrgilW2mfde9/lHnT4hAxNphtCZIW+V5C2Py1PVUDiHlYPv2SPmmXl7/djmz9Qbq0Nki1YnQIwziZVTKalwz+WddcgkSnLau7w5rNtFQH859+NQBj6hCuAnSQuBzU1mThUFpsvhXA0yfEbPr+mL40U7l2JqTnG571BQR+R+aM9sPYuQHp0BOzVNjTSR8vodGszQKXWhtLuuwquyO8nXZQjgc+4qjPKcH0W2oDvW51k7EwOI1xZ5LXvKta7v96r3le8A9o3BLdb2CfPmvgpU1Oft1BbJlI4NLPQmkxMqn6sK7khwZMWz9cxpawhQGe8pg2Ierz/Nis188soVv0v/o3jfWHv0lnergYaYQYoLOwQpy9PedA2SAlM0R2GY7OBp1nP3el2JC9YrwDPIXhkfu
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(83380400001)(8676002)(921005)(7416002)(64756008)(66446008)(54906003)(53546011)(7696005)(6506007)(71200400001)(86362001)(52536014)(2906002)(5660300002)(478600001)(76116006)(66556008)(66946007)(7406005)(33656002)(66476007)(110136005)(8936002)(316002)(186003)(4744005)(55016002)(26005)(9686003)(4326008);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CYeIwzL7+LDwBcGUtwWpgfGZXas4/+HyoB5dQvzgRXUwabx1wNppES5QTFxT?=
	=?us-ascii?Q?kMs/MvxFLYVZI5XqHFhuJeOq9onZPVWZNgeM1d1TVfokEb23W8IjRI9/kJQ8?=
	=?us-ascii?Q?njDQexyJ0VEFzXOM2fBaNuy8G56NIO9iILmStR8rTXkc+GN1VWuYWqmyqz1p?=
	=?us-ascii?Q?M8UvAerZCHQTENnAamWt49x4NLAfr9FFpZfux/lxafxQafyaTIS3nxDmer6n?=
	=?us-ascii?Q?8JRBu5PudXaoLVCIX5TFxJ9BHaj5MvpPcwnMe9yBtbXqD1lRlqEUUHnvhwfK?=
	=?us-ascii?Q?UIftvmnTQROjFbfkJXhZccpAoL/aq5AS0W+TYV2JB6qHUFtSaFLOv3m+7JSZ?=
	=?us-ascii?Q?KB9qT49sztiW8OklmFBypBXzxVxH+sFpG6dedI3pzoiKl+1l+yv8lx+IHIc0?=
	=?us-ascii?Q?bnPJo+pPjByH83zID56ASid+n3EMXQ+AQvu66L3G8/pfCvGGrwcnjiN+wYuE?=
	=?us-ascii?Q?jgn5p46CJnUPI8fVsBvsOPPQvD6RahqlpOCKp6O2gNqlabFChMaHTa/HtLeg?=
	=?us-ascii?Q?XaXE4rLcbgkaSWEuoLPG8GlN6LNp18Xjm2RS/25dq8vNTwk1NzTSmsv6RRZc?=
	=?us-ascii?Q?IhQ78OnwWHRVLF+ZyQ9faxQPYis+oX25aE/PAdTk/AV3kke9/XNbjlyjz6sQ?=
	=?us-ascii?Q?KIglOzm3XKue4E4mZ/Oc+2YadCcFDjxtp0hf2tyIs9TJL1r/GKvdcThyYVBL?=
	=?us-ascii?Q?wRV66Eex1KUdgrzLeEjXT1fMhAelxL2Wq+SWqiZp6VmrBxF5LExsi7A+978r?=
	=?us-ascii?Q?TGNkHEzmUVLuoOEUMQ5T44Jv1898R9lxeWj4JeItOojNBXT3Tq4OcRsZELf6?=
	=?us-ascii?Q?R1dvqhysFLFxXmuVei/nYnRFepqrdE1rAIghfvG53HAVCMokkzIzD53g+VJu?=
	=?us-ascii?Q?kM1xatRvJtNTqOB350/tIRKqR8GtrILKDN38GJ3VpbZ6v0ZDSUF2VCgTSLt7?=
	=?us-ascii?Q?l91pWwrHQtmycz370urFgVYRNv18k5jQ1qOlRwMHa2D1aKdGKoCKPFMikA/F?=
	=?us-ascii?Q?ocZw?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b4c018-b955-4aff-42d9-08d8bcf3608a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 03:27:55.2569 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6GChSPAwRaJR+pnJ/NXEbGatSLvEkK5o5I/huExAKkTALRKQxBWJkWD8S6meD32zVWEaMR/TBIKWTtYqKFHLrIZporw6ZI089anAFL9wihk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4872
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10K3SCf8006907
X-loop: dm-devel@redhat.com
Cc: "shaggy@kernel.org" <shaggy@kernel.org>,
	"jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"gustavo@embeddedor.com" <gustavo@embeddedor.com>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"darrick.wong@oracle.com" <darrick.wong@oracle.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"efremov@linux.com" <efremov@linux.com>, "colyli@suse.de" <colyli@suse.de>,
	"tj@kernel.org" <tj@kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"agruenba@redhat.com" <agruenba@redhat.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	Moal <Damien.LeMoal@wdc.com>, "tytso@mit.edu" <tytso@mit.edu>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"song@kernel.org" <song@kernel.org>, Damien,
	"philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
	"jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
	"rpeterso@redhat.com" <rpeterso@redhat.com>,
	"lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
	"jth@kernel.org" <jth@kernel.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/18/21 21:06, Chaitanya Kulkarni wrote:
> Hi,
>
> This is a *compile only RFC* which adds a generic helper to initialize
> the various fields of the bio that is repeated all the places in
> file-systems, block layer, and drivers.
>
> The new helper allows callers to initialize various members such as
> bdev, sector, private, end io callback, io priority, and write hints.
>
> The objective of this RFC is to only start a discussion, this it not 
> completely tested at all.                                                                                                            
> Following diff shows code level benefits of this helper :-
>  38 files changed, 124 insertions(+), 236 deletions(-)
>
> -ck
Thanks for replying Mike, Josef and Christoph.

I'll move forward with Christoph's suggestion and get rid of
optional parameters which is making this API hard to use.



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

