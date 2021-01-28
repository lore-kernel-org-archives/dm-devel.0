Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684AAC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:40:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C3FC964DD1
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:40:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3FC964DD1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-4i0aRm3lPVyzSgMhzA573A-1; Thu, 28 Jan 2021 03:39:32 -0500
X-MC-Unique: 4i0aRm3lPVyzSgMhzA573A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FC98100F342;
	Thu, 28 Jan 2021 08:39:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CAA860C67;
	Thu, 28 Jan 2021 08:39:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0F0721809CAD;
	Thu, 28 Jan 2021 08:39:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S8YlSQ014710 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 03:34:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 287B010EB2B6; Thu, 28 Jan 2021 08:34:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 227C010EB2BC
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 08:34:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2942B800157
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 08:34:44 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-248-FVxw55cBMEKW1R8w__bv7g-1; Thu, 28 Jan 2021 03:34:37 -0500
X-MC-Unique: FVxw55cBMEKW1R8w__bv7g-1
IronPort-SDR: QuIdPdzLWuhuVH3zjdD3FSgUzpNWdsPRMeYPxHo/0XlU4gVdQh2z/JddOGT9zQzwJLAD3iEAw2
	XibjOAFwAmoyB+Xzg6Na+1VuTsd1VJYRN6tTumqolKHZ0kQ3maRvNlomfA4o+BH7wbVVPYgnef
	/7RTlzymEiHhNfp8L2thUSxmBr3rzg7BfJnLPhYBxqUqF1PTFSHFODMyUc2VJA+ywkm3jXO/F+
	qe+y7iCxi9ett70HempLYAo0heBe3/D90+erIC6XtBPzNpmXzFaZJUHMHM4enMLUtK8tpzwwZ4
	LkY=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
	d="scan'208,217";a="158525790"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO
	NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 16:34:32 +0800
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
	DM5PR04MB1114.namprd04.prod.outlook.com (2603:10b6:3:9f::23) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.3805.16; Thu, 28 Jan 2021 08:34:29 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::9a1:f2ba:2679:8188]) by DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::9a1:f2ba:2679:8188%7]) with mapi id 15.20.3784.017;
	Thu, 28 Jan 2021 08:34:28 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@tron.linbit.com>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
	"jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, "linux-nilfs@vger.kernel.org"
	<linux-nilfs@vger.kernel.org>, "ocfs2-devel@oss.oracle.com"
	<ocfs2-devel@oss.oracle.com>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Thread-Topic: [RFC PATCH 02/34] block: introduce and use bio_new
Thread-Index: AQHW9UTnc64/mAmIvESrRLPcPpiQkQ==
Date: Thu, 28 Jan 2021 08:34:28 +0000
Message-ID: <DM6PR04MB497297B2D0CB8DF8894EB65386BA9@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-3-chaitanya.kulkarni@wdc.com>
	<BL0PR04MB6514C554B4AC96866BC1B16FE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
	<BL0PR04MB6514DBA7EDB8EC87A1C20871E7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2600:8802:270c:4b00:19c6:a569:8749:44eb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 978d65e2-3d4e-4c21-5cef-08d8c3678717
x-ms-traffictypediagnostic: DM5PR04MB1114:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB111464693CD23FB80E8B2D0A86BA9@DM5PR04MB1114.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: YtVNe3W2+2aLfLtfSA9OA8bKUS5EuzRymacqrPW/HhxrlcagogsgxPJ4goHocMHcrquFy4WsNzAC2zIwBruP7m7IthnSUmI5j3ISeaVxrWXx2BpOL73T4TMVJwjiKmju8hK7SQF+6OBKeWerelHJue84qxCD6Evq8BaVTHK2Pfn/zfawC6Qh5cnudJHua7/EdJc19wtAiBub96zdzBOP7SeckBw9Jl7fVZ+mg8flDzG4r0b04OYAsc+EgKacZG79AoYvz2T16vnB0SuzaVCN1fNoMTyCpgYbZfcb+25HhL6G9ZYVTGUzGOajGvpXL9dQa+tl5271dRn1SX2i591F783+g43zsz305DdvUPuXBOeLw7XLQKVwQqynq4uMJA4aPlVezpZUpys/AzSvT8//eLVyMBabHolU07RKciw3m7k75mUvrqE0xH7qxJF5SKiCIp1iwFsy7HF7y8DDM9zV6Rx1kWZz5AnEF2pBy5Ys/mDNV+4IrwglV3wakeM2PvEQk5LTMQgSo3XZAKL3QLtaSubQYBccSwho6T1wUjcwH/zzNTMI+9ViNSj4Hb17niq6
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB4972.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(66446008)(64756008)(66556008)(66476007)(4744005)(6506007)(7696005)(66946007)(86362001)(53546011)(91956017)(71200400001)(52536014)(316002)(186003)(110136005)(54906003)(478600001)(5660300002)(76116006)(4326008)(7406005)(7366002)(8676002)(9686003)(33656002)(55016002)(8936002)(921005)(7416002)(2906002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nSjkiLq41zm0esQ8DDVUjPRPdmiq+ZbmIlsnbqCwt1NtPaq0Vnw9tw0jJg2z?=
	=?us-ascii?Q?sDiU1HrP5BNUewiGy7sSTKtzaRWQZmzLbmjIYOgi7G+hupKaF8E24yQG8xn1?=
	=?us-ascii?Q?DFjccCYAV99t3fBvOrTsjES76919/Xf8YtTEL+6a9ZOC5QDvcE9Gvxd/xCaB?=
	=?us-ascii?Q?449uYM+bvQf8Vc6BRr4MHFXnuCXpnus2QkiddynyW859h+oOKwzcRj6Tt3qI?=
	=?us-ascii?Q?Zg2LJcr09KqEm0m4wWFf38Qa7m+JEeOjzaPq4TwXRwE99Ei/lHt/a4fCnhqH?=
	=?us-ascii?Q?8UgH9ri9g7pOHQTt6LLLZGVJlJq/xcFZxrBjTlxF4jsA3nk1N5BjpA6qrKFL?=
	=?us-ascii?Q?UH1o+UnIXgEKjLmHZEeQpqoBtq9ECmvnZJVxZ+/SZzS5bTVuEzIlGDm09zJk?=
	=?us-ascii?Q?VEtFy/O2l3quwBuf77r7M9pXg6w9sOJlR2DPC/aNvaMIIXM6t2d/Jxi+9aSW?=
	=?us-ascii?Q?i0uXTLcUWasH1YKRz8lzyvN9Mn2H6NUZk9eTsYWF5M0MKXo1141VOsq9rRrZ?=
	=?us-ascii?Q?IiUQrevuIeKABqnVn5dchwrO9SIt3xOqUQro5zAhfUuJ4m4OUIDq/WOaSmL2?=
	=?us-ascii?Q?nP1F0s+wGYZEy4w1yWNxUfHPJBsvTX9ViL1pjc/acoijwp6xxZjfmMgfOzWN?=
	=?us-ascii?Q?GHNVTjeRb+RX9uwUaXx9i177L7BI/SO3I5VJDR/DrWjfmR+l3mhfiODJ4pQC?=
	=?us-ascii?Q?XlB6yc/qxrmEn0bX522NFPhx+N4DzELTAfjANe3PDLm/n+aWbn32UKJLBXLt?=
	=?us-ascii?Q?EL4q5dCcVULTCrY4hs68lfH5fcB/UGMGRF/bDzUtmuKV66HUPNAJjKYwpvXf?=
	=?us-ascii?Q?zpIaVz5LqP27oMNzNIggx4lbjBN0r1179K+qQgHRclk/Ttt/qp30A00PRAW0?=
	=?us-ascii?Q?ycXqqUT6drdcQGugzQKIgPw+qWPMEJrgjFW9Sg7svB+RX+nfmDQiPerIOfw5?=
	=?us-ascii?Q?/sFIiJJW56LxNwun204iaP5BaSIG9L13YCkMqxR6P83M074jeVhA13fahQ1v?=
	=?us-ascii?Q?xeVmeBlVEGZzup2Uj/AFOjuupztWNoZITAUDhRbuJ/EwGqXzxeGRYtyfqPfh?=
	=?us-ascii?Q?+Vc+amKk2etB3zRKzD3W3vzUVwIvorFhC/vkg6MB9LkptasEmLn4eahh5iJD?=
	=?us-ascii?Q?Gx/VTA3cjut4iiwSlAUhlMnxsnxfIvMpbg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 978d65e2-3d4e-4c21-5cef-08d8c3678717
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 08:34:28.7664 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Xam546gszbEFO8oYDat64TQDlpIs22yxwb+LuFp88Uvtlt+RJdak/GCQfIXADtruGdwXVfdDrsBSMftWAQsbepic9n+7nRZHvVV+mryu7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1114
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 28 Jan 2021 03:38:55 -0500
Cc: "shaggy@kernel.org" <shaggy@kernel.org>,
	"sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>, "tiwai@suse.de" <tiwai@suse.de>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"gustavoars@kernel.org" <gustavoars@kernel.org>,
	"joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>,
	"pavel@ucw.cz" <pavel@ucw.cz>,
	"alex.shi@linux.alibaba.com" <alex.shi@linux.alibaba.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"mark@fasheh.com" <mark@fasheh.com>, "osandov@fb.com" <osandov@fb.com>,
	"ebiggers@kernel.org" <ebiggers@kernel.org>,
	"ngupta@vflare.org" <ngupta@vflare.org>,
	"len.brown@intel.com" <len.brown@intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
	"jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "jth@kernel.org" <jth@kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"rjw@rjwysocki.net" <rjw@rjwysocki.net>,
	"philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
	"minchan@kernel.org" <minchan@kernel.org>, "tj@kernel.org" <tj@kernel.org>,
	"lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
	"roger.pau@citrix.com" <roger.pau@citrix.com>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"jlbec@evilplan.org" <jlbec@evilplan.org>
Subject: Re: [dm-devel] [RFC PATCH 02/34] block: introduce and use bio_new
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============8216132979304074521=="

--===============8216132979304074521==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DM6PR04MB497297B2D0CB8DF8894EB65386BA9DM6PR04MB4972namp_"

--_000_DM6PR04MB497297B2D0CB8DF8894EB65386BA9DM6PR04MB4972namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On 1/27/21 11:27 PM, Damien Le Moal wrote:

+
+       bio_set_dev(bio, bdev);
+       bio->bi_iter.bi_sector =3D sector;
+       bio_set_op_attrs(bio, op, op_flags);


This function is obsolete. Open code this.


And that also mean that you could remove one argument to bio_new(): combine=
 op
and op_flags into "unsigned int opf"



I did that initially but kept it separate for RFC, that is much easier than=
 having

an extra arg, will change it in V1.

--_000_DM6PR04MB497297B2D0CB8DF8894EB65386BA9DM6PR04MB4972namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body>
<div class=3D"moz-cite-prefix">On 1/27/21 11:27 PM, Damien Le Moal wrote:<b=
r>
</div>
<blockquote type=3D"cite" cite=3D"mid:BL0PR04MB6514DBA7EDB8EC87A1C20871E7BA=
9@BL0PR04MB6514.namprd04.prod.outlook.com">
<blockquote type=3D"cite" style=3D"color: #007cff;">
<blockquote type=3D"cite" style=3D"color: #007cff;">
<pre class=3D"moz-quote-pre" wrap=3D"">+=0A+=09bio_set_dev(bio, bdev);=0A+=
=09bio-&gt;bi_iter.bi_sector =3D sector;=0A+=09bio_set_op_attrs(bio, op, op=
_flags);=0A</pre>
</blockquote>
<pre class=3D"moz-quote-pre" wrap=3D"">This function is obsolete. Open code=
 this.=0A</pre>
</blockquote>
<pre class=3D"moz-quote-pre" wrap=3D"">And that also mean that you could re=
move one argument to bio_new(): combine op=0Aand op_flags into &quot;unsign=
ed int opf&quot;=0A=0A</pre>
</blockquote>
<p><font face=3D"monospace">I did that initially but kept it separate for R=
FC, that is much easier than having</font></p>
<p><font face=3D"monospace">an extra arg, will change it in V1.</font><br>
</p>
</body>
</html>

--_000_DM6PR04MB497297B2D0CB8DF8894EB65386BA9DM6PR04MB4972namp_--

--===============8216132979304074521==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============8216132979304074521==--

