Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F47C433E6
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 416B364DD9
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 416B364DD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-hThl2V-bNbm8rz14tLsegg-1; Thu, 28 Jan 2021 03:39:42 -0500
X-MC-Unique: hThl2V-bNbm8rz14tLsegg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D05A873019;
	Thu, 28 Jan 2021 08:39:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E0B185C1BB;
	Thu, 28 Jan 2021 08:39:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B4E161809CB2;
	Thu, 28 Jan 2021 08:39:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S8XQRN014633 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 03:33:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2D6AD2026D13; Thu, 28 Jan 2021 08:33:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 275F02026D76
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 08:33:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D42B18A01A0
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 08:33:23 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-507-RL3DGv83Py6T2FosAN71Sg-1; Thu, 28 Jan 2021 03:33:17 -0500
X-MC-Unique: RL3DGv83Py6T2FosAN71Sg-1
IronPort-SDR: w5opH1owjt5Lo+2wpqvthrCHUfi3DzYxGCpnBQreSkEDUDsMf7F+YFx55pLwTaPP9PNR7ejXkA
	iSR+m2lKwVNewOcICTKInfjZrlB0rasI/uRstfJhqvklCDneuwpV+AyeRN1UtTQsWi3p0wOZ5p
	NtRp9nobCYtjluwC9rgqlMTVRAr3YTDKNFwq0JnYGNhlwe8uciFKMFMA+HSlphgfBPZi2864Hg
	oUXTFClDbTYFMBIWbqyOYRv8WpvASVVAA6SmH+8ZEWqZyIRKACecwbZpVnZ0jn0vwCMZb72oFn
	ZMw=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
	d="scan'208,217";a="158525643"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO
	NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 16:33:11 +0800
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
	DM5PR04MB1114.namprd04.prod.outlook.com (2603:10b6:3:9f::23) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.3805.16; Thu, 28 Jan 2021 08:33:10 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::9a1:f2ba:2679:8188]) by DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::9a1:f2ba:2679:8188%7]) with mapi id 15.20.3784.017;
	Thu, 28 Jan 2021 08:33:10 +0000
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
Date: Thu, 28 Jan 2021 08:33:10 +0000
Message-ID: <DM6PR04MB4972DA86892CF4531440064F86BA9@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-3-chaitanya.kulkarni@wdc.com>
	<BL0PR04MB6514C554B4AC96866BC1B16FE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2600:8802:270c:4b00:19c6:a569:8749:44eb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9a8ff653-42c3-4245-3988-08d8c367584f
x-ms-traffictypediagnostic: DM5PR04MB1114:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB11144737CBFDE03CEF1D3EC586BA9@DM5PR04MB1114.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: kMypPZceh+2LiXoJK6HAF/Mvvx/nRb7ddeyIpnUOIbQmzFTn+t5Fb2FNOx2brBDzL3ceIIzRqZvXSr9yFNRJb6Jt6ljoD6KahTKwanFIrVeo+9f+TDCCTdTGsjuzFCDC6n+a8FjKgtHGTyApkW4a7qX3ALnGKGc9dMw6Om3yXszVlUkqAg71X20EoI3WR+TOYnSTqWyz5JIPU9p1aQVww7Fe20/qO275Tv4+WmtAaxsS506bwLr5Soe3MM5lK0OHDh4lXUETDdMZvk2Y1QOKPaWx1K/8BG5bj6akyLlhjLMRTATRHNz6SX/oW36Xy8MnVZVK++JhNEmSn7xil85tLcCDIxXzyv+xBR6yHPec+SnmCtQfkQZqZfqsQa7W0Kn+vQjAh05vEdAs0GhB2hzNR6mEhq1HQxRypifmaFt8CfEsLljfxvD+UJRqBk121MAlNz1Ax6uIOsO39YK+f9hEfttoZ9B2SJZCB8pFsjoehQ2mBinBCPHciN1OJ9w+jcBksJFh5xFe5GHa0BhAOzJyaI7NL8B/ERQm+X+J6vufnkNWQX9zATWHD8Ucigzu3zcjJcdYmuEYDB2uJUJojhIiAw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB4972.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(66446008)(64756008)(66556008)(66476007)(6506007)(7696005)(66946007)(86362001)(53546011)(91956017)(71200400001)(52536014)(316002)(186003)(110136005)(54906003)(478600001)(5660300002)(76116006)(83380400001)(4326008)(7406005)(7366002)(8676002)(9686003)(33656002)(55016002)(8936002)(921005)(7416002)(2906002)(21314003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?xqka1YqAc8OncUZNb1YXUwhqHK/eF4Lo+YM0LSHJ1qf4N1T99Bc9lWHSeYCl?=
	=?us-ascii?Q?SCo76AOHOnEUr2CUMHjV053qZzZ+5ZwKDOmfxSo6K0us2Abj0KAoLRUIv7hg?=
	=?us-ascii?Q?fnaI9A9D408BKXzJKazWJKFRaZ+s08Y8sqYsgCAvdOiREC/GLkdT02EGJ5ey?=
	=?us-ascii?Q?hFBNWmDp7YX6PDnM3sUp96whJ5dnE3cRMMNuwbHZOZqKl+Db/IeEPgCJIQrz?=
	=?us-ascii?Q?UtzQ6ono3DOdNyPi1WrRGER/H32jrfnfF9NbxG0+tlQFgGpcuqte4x7f6Yyl?=
	=?us-ascii?Q?jTNMiqGi4XKvzebjZjWTxAh2LRPpwHtLHeKw/714dU/maJAlHfnzbVCNdjuP?=
	=?us-ascii?Q?OSoe1xKP3XaqPgu1Yfc3RgMBAouxIRf1dt1hGErTTxNtQz54C/c1TsoB6zK1?=
	=?us-ascii?Q?f86Yrchwjm5ZTT8u1x9yMOboBlS7GysEQ5T09h3SU6pl3s6fK5Gwsfc1PCJL?=
	=?us-ascii?Q?2c8SrFdnUqWvT7AoKku49psckyEWJsg3K0sbP9PAlxkhjBULEikI5OO2W67P?=
	=?us-ascii?Q?aGWSqcJUpdm4QgW6L+d9otk8nWNBSHPLLi2yuHnZwtHjvftJUn4oA6I+uX4e?=
	=?us-ascii?Q?nq4FM/GwjQwCIiyWSxBKJ9OgOS9113/mUrjQRwQCz8TWCCttmjNaT/r+ejZa?=
	=?us-ascii?Q?fbJc+891eNzAoNopE6QQ52i5XQ7DFDLze+or1cHQVeE6um+MUCV7Wm79LMsX?=
	=?us-ascii?Q?BTp9fTJx2Fvv1ioqo5tSY9YvYMgzyPcYiM9N74QRH+4Q/0Qg8O0Ljw6hr9X+?=
	=?us-ascii?Q?Y7MBshaB7mE3bgzmNhOmuE3b+pII/z1dUvkHv/SV4jlSTFo+7KBEHeeQOLHX?=
	=?us-ascii?Q?rQOBhg6FEY2FcrrY8OAKFcNy1u/ZepECMgtIDFbM/FdB818orpDZC+PopInp?=
	=?us-ascii?Q?y+8xmWmFnWfBg15+ORfTbA5Ks+gvD27IXwdv6b/A+TiGVrOzagDRTe4GkykA?=
	=?us-ascii?Q?8gzrBPld8UqVOKzKZOC2Dp7Agcqp4lT2oAghGyBx0W8dPeaBThcEZd2RLwNh?=
	=?us-ascii?Q?g0mr8Ur4PsREEO+TkTDuvNfrEh11rPnjiYg5mQOGU6Udb6Qq0EgwM2bQTpq3?=
	=?us-ascii?Q?SOFPR1e24fGr7nK9U8mc2PB061KPTrocfDNsPGLP+9d9PaAph6TbpIVKrfac?=
	=?us-ascii?Q?/Qp2RRGFHlZ0MOZFYXbe9e+8R5qppJrO9g=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a8ff653-42c3-4245-3988-08d8c367584f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 08:33:10.2362 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dz2+Oxz9XKbNcpnvWyeE8eQh4KnSN/HxVdT+CQaW5KvsDWxz+iwddbJSAveGS+LwCg0aJ57VleZkk66eKETHO8rC54eAkH9nzYazDbuCagU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1114
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============1327333103615178580=="

--===============1327333103615178580==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DM6PR04MB4972DA86892CF4531440064F86BA9DM6PR04MB4972namp_"

--_000_DM6PR04MB4972DA86892CF4531440064F86BA9DM6PR04MB4972namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On 1/27/21 11:21 PM, Damien Le Moal wrote:

On 2021/01/28 16:12, Chaitanya Kulkarni wrote:


Introduce bio_new() helper and use it in blk-lib.c to allocate and
initialize various non-optional or semi-optional members of the bio
along with bio allocation done with bio_alloc(). Here we also calmp the
max_bvecs for bio with BIO_MAX_PAGES before we pass to bio_alloc().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com><mailto:chait=
anya.kulkarni@wdc.com>
---
 block/blk-lib.c     |  6 +-----
 include/linux/bio.h | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index fb486a0bdb58..ec29415f00dd 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -14,17 +14,13 @@ struct bio *blk_next_bio(struct bio *bio, struct block_=
device *bdev,
                        sector_t sect, unsigned op, unsigned opf,
                        unsigned int nr_pages, gfp_t gfp)
 {
-       struct bio *new =3D bio_alloc(gfp, nr_pages);
+       struct bio *new =3D bio_new(bdev, sect, op, opf, gfp, nr_pages);

        if (bio) {
                bio_chain(bio, new);
                submit_bio(bio);
        }

-       new->bi_iter.bi_sector =3D sect;
-       bio_set_dev(new, bdev);
-       bio_set_op_attrs(new, op, opf);
-
        return new;
 }

diff --git a/include/linux/bio.h b/include/linux/bio.h
index c74857cf1252..2a09ba100546 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -826,5 +826,30 @@ static inline void bio_set_polled(struct bio *bio, str=
uct kiocb *kiocb)
        if (!is_sync_kiocb(kiocb))
                bio->bi_opf |=3D REQ_NOWAIT;
 }
+/**
+ * bio_new -   allcate and initialize new bio
+ * @bdev:      blockdev to issue discard for
+ * @sector:    start sector
+ * @op:                REQ_OP_XXX from enum req_opf
+ * @op_flags:  REQ_XXX from enum req_flag_bits
+ * @max_bvecs: maximum bvec to be allocated for this bio
+ * @gfp_mask:  memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Allocates, initializes common members, and returns a new bio.
+ */
+static inline struct bio *bio_new(struct block_device *bdev, sector_t sect=
or,
+                                 unsigned int op, unsigned int op_flags,
+                                 unsigned int max_bvecs, gfp_t gfp_mask)
+{
+       unsigned nr_bvec =3D clamp_t(unsigned int, max_bvecs, 0, BIO_MAX_PA=
GES);
+       struct bio *bio =3D bio_alloc(gfp_mask, nr_bvec);


I think that depending on the gfp_mask passed, bio can be NULL. So this sho=
uld
be checked.


true, I'll add that check.




+
+       bio_set_dev(bio, bdev);
+       bio->bi_iter.bi_sector =3D sector;
+       bio_set_op_attrs(bio, op, op_flags);


This function is obsolete. Open code this.


true, will do.




+
+       return bio;
+}

 #endif /* __LINUX_BIO_H */



Thanks for the comments Damien.

--_000_DM6PR04MB4972DA86892CF4531440064F86BA9DM6PR04MB4972namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body>
<div class=3D"moz-cite-prefix">On 1/27/21 11:21 PM, Damien Le Moal wrote:<b=
r>
</div>
<blockquote type=3D"cite" cite=3D"mid:BL0PR04MB6514C554B4AC96866BC1B16FE7BA=
9@BL0PR04MB6514.namprd04.prod.outlook.com">
<pre class=3D"moz-quote-pre" wrap=3D"">On 2021/01/28 16:12, Chaitanya Kulka=
rni wrote:=0A</pre>
<blockquote type=3D"cite" style=3D"color: #007cff;">
<pre class=3D"moz-quote-pre" wrap=3D"">Introduce bio_new() helper and use i=
t in blk-lib.c to allocate and=0Ainitialize various non-optional or semi-op=
tional members of the bio=0Aalong with bio allocation done with bio_alloc()=
. Here we also calmp the=0Amax_bvecs for bio with BIO_MAX_PAGES before we p=
ass to bio_alloc().=0A=0ASigned-off-by: Chaitanya Kulkarni <a class=3D"moz-=
txt-link-rfc2396E" href=3D"mailto:chaitanya.kulkarni@wdc.com" moz-do-not-se=
nd=3D"true">&lt;chaitanya.kulkarni@wdc.com&gt;</a>=0A---=0A block/blk-lib.c=
     |  6 +-----=0A include/linux/bio.h | 25 +++++++++++++++++++++++++=0A 2=
 files changed, 26 insertions(+), 5 deletions(-)=0A=0Adiff --git a/block/bl=
k-lib.c b/block/blk-lib.c=0Aindex fb486a0bdb58..ec29415f00dd 100644=0A--- a=
/block/blk-lib.c=0A+++ b/block/blk-lib.c=0A@@ -14,17 +14,13 @@ struct bio *=
blk_next_bio(struct bio *bio, struct block_device *bdev,=0A =09=09=09sector=
_t sect, unsigned op, unsigned opf,=0A =09=09=09unsigned int nr_pages, gfp_=
t gfp)=0A {=0A-=09struct bio *new =3D bio_alloc(gfp, nr_pages);=0A+=09struc=
t bio *new =3D bio_new(bdev, sect, op, opf, gfp, nr_pages);=0A=20=0A =09if =
(bio) {=0A =09=09bio_chain(bio, new);=0A =09=09submit_bio(bio);=0A =09}=0A=
=20=0A-=09new-&gt;bi_iter.bi_sector =3D sect;=0A-=09bio_set_dev(new, bdev);=
=0A-=09bio_set_op_attrs(new, op, opf);=0A-=0A =09return new;=0A }=0A=20=0Ad=
iff --git a/include/linux/bio.h b/include/linux/bio.h=0Aindex c74857cf1252.=
.2a09ba100546 100644=0A--- a/include/linux/bio.h=0A+++ b/include/linux/bio.=
h=0A@@ -826,5 +826,30 @@ static inline void bio_set_polled(struct bio *bio,=
 struct kiocb *kiocb)=0A =09if (!is_sync_kiocb(kiocb))=0A =09=09bio-&gt;bi_=
opf |=3D REQ_NOWAIT;=0A }=0A+/**=0A+ * bio_new -=09allcate and initialize n=
ew bio=0A+ * @bdev:=09blockdev to issue discard for=0A+ * @sector:=09start =
sector=0A+ * @op:=09=09REQ_OP_XXX from enum req_opf=0A+ * @op_flags:=09REQ_=
XXX from enum req_flag_bits=0A+ * @max_bvecs:=09maximum bvec to be allocate=
d for this bio=0A+ * @gfp_mask:=09memory allocation flags (for bio_alloc)=
=0A+ *=0A+ * Description:=0A+ *    Allocates, initializes common members, a=
nd returns a new bio.=0A+ */=0A+static inline struct bio *bio_new(struct bl=
ock_device *bdev, sector_t sector,=0A+=09=09=09=09  unsigned int op, unsign=
ed int op_flags,=0A+=09=09=09=09  unsigned int max_bvecs, gfp_t gfp_mask)=
=0A+{=0A+=09unsigned nr_bvec =3D clamp_t(unsigned int, max_bvecs, 0, BIO_MA=
X_PAGES);=0A+=09struct bio *bio =3D bio_alloc(gfp_mask, nr_bvec);=0A</pre>
</blockquote>
<pre class=3D"moz-quote-pre" wrap=3D"">I think that depending on the gfp_ma=
sk passed, bio can be NULL. So this should=0Abe checked.=0A</pre>
</blockquote>
true, I'll add that check.<br>
<blockquote type=3D"cite" cite=3D"mid:BL0PR04MB6514C554B4AC96866BC1B16FE7BA=
9@BL0PR04MB6514.namprd04.prod.outlook.com">
<pre class=3D"moz-quote-pre" wrap=3D"">=0A</pre>
<blockquote type=3D"cite" style=3D"color: #007cff;">
<pre class=3D"moz-quote-pre" wrap=3D"">+=0A+=09bio_set_dev(bio, bdev);=0A+=
=09bio-&gt;bi_iter.bi_sector =3D sector;=0A+=09bio_set_op_attrs(bio, op, op=
_flags);=0A</pre>
</blockquote>
<pre class=3D"moz-quote-pre" wrap=3D"">This function is obsolete. Open code=
 this.=0A</pre>
</blockquote>
true, will do.<br>
<blockquote type=3D"cite" cite=3D"mid:BL0PR04MB6514C554B4AC96866BC1B16FE7BA=
9@BL0PR04MB6514.namprd04.prod.outlook.com">
<pre class=3D"moz-quote-pre" wrap=3D"">=0A</pre>
<blockquote type=3D"cite" style=3D"color: #007cff;">
<pre class=3D"moz-quote-pre" wrap=3D"">+=0A+=09return bio;=0A+}=0A=20=0A #e=
ndif /* __LINUX_BIO_H */=0A=0A</pre>
</blockquote>
</blockquote>
<p>Thanks for the comments Damien.<br>
</p>
</body>
</html>

--_000_DM6PR04MB4972DA86892CF4531440064F86BA9DM6PR04MB4972namp_--

--===============1327333103615178580==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============1327333103615178580==--

