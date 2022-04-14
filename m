Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA402C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 11:17:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-HW8jk7lBNzKE-B_TWNZ-6g-1; Thu, 14 Apr 2022 07:17:29 -0400
X-MC-Unique: HW8jk7lBNzKE-B_TWNZ-6g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F8B31C05AEF;
	Thu, 14 Apr 2022 11:17:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 040F37774;
	Thu, 14 Apr 2022 11:17:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9CCA8194034E;
	Thu, 14 Apr 2022 11:17:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F30FC1940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 08:35:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CD6B69D7B; Thu, 14 Apr 2022 08:35:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C929F9D4C
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 08:35:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E36F6833969
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 08:35:47 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-xhV2oqnCNxaG0I16Dsaj9A-1; Thu, 14 Apr 2022 04:35:46 -0400
X-MC-Unique: xhV2oqnCNxaG0I16Dsaj9A-1
X-IronPort-AV: E=Sophos;i="5.90,259,1643644800"; d="scan'208";a="198794001"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO
 NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
 by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2022 16:34:42 +0800
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BL0PR04MB5043.namprd04.prod.outlook.com (2603:10b6:208:53::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.29; Thu, 14 Apr 2022 08:34:36 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2839:2ab4:7871:416e]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2839:2ab4:7871:416e%6]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 08:34:36 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Mike Snitzer <snitzer@kernel.org>, "dm-devel@redhat.com"
 <dm-devel@redhat.com>
Thread-Topic: [bug report] BUG for REQ_OP_WRITE_ZEROES to dm-zoned
Thread-Index: AQHYT9p5h91e/KJ/UkicsYxGr2oaZw==
Date: Thu, 14 Apr 2022 08:34:36 +0000
Message-ID: <20220414083436.pweunapygdtuzwaf@shindev>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b91946d-f177-489d-ca14-08da1df19bf4
x-ms-traffictypediagnostic: BL0PR04MB5043:EE_
x-microsoft-antispam-prvs: <BL0PR04MB5043F41E5F61398B8FC6E4F2EDEF9@BL0PR04MB5043.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: EPHliW7pp5K2Kd+04LBV4PG7G7REvf2uReoPtYT2DWjAi1AQqLULxXygYuhE6OuBPVJ6SUXYzb8M/PqXsmQZLJmfd4alytPldC1yuFhVS1TJTmiLWnxOxdp7pMWn/iz1NQihX8V7x0sNFLGe+ujL+xhEImvWErGys6Z+BP3IKIAgBe8o+5BDatALHZxAYFIb4IO4c/11Cm+g+vrvMiw6boT60oYSc5+CTLjELKD1OajYeiAN7vXRLc1RcXqz6EPaHiQuhY40+eNrk1XIBE3bQ4QE5oKc4scKgYHKS4gyHxipaGvYwoquglNwL9r5IQfbJf/u6K3ioNE5Nq60fAbM2RnQkpeLxFIVRfXPpxIyexekPfvfr1lEVbaTtWUuYHrj1lTQDKLQsCGI/W+Za8B6S/GfaXhrvNT667grk+RkSG11K5bIeZurVgM6OXaqO6qbliUidyCzlb8CvwJQYtl8rCxIgKhm8S9VOZCLQs2+67YoeGlVWiR5cT2MF9y81b81kbMikRj1+dY/DQgeAQOsrtNcF6tf4pzD5wp+JWRQ9e41SKJvARkp3eAttmbbjD60gKjermz4OUBUevYfe/bm5DYOfb9z1wACxQtmypAqfXotLIginJiYLjFVL3LLGiXkHOPBDt+ufjgRxWUZmYIgE2datHXB0OkpZM7+3kYAlqdMysY7mlAZZtdwy0DmyNjgPgUhbIRhYb+Ojba9L++VbQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR04MB8037.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(7916004)(366004)(6486002)(122000001)(9686003)(6512007)(2906002)(8936002)(3716004)(33716001)(6506007)(5660300002)(82960400001)(83380400001)(44832011)(186003)(66446008)(4326008)(508600001)(64756008)(8676002)(66556008)(66476007)(38100700002)(110136005)(38070700005)(1076003)(71200400001)(86362001)(76116006)(66946007)(91956017)(316002)(26005);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gmz5ySl59jkk4LbvMrK+2HranPlQ3g1X2GAHy7IW/lVGEyEXs9hqRYAi/ZN8?=
 =?us-ascii?Q?AZu1uDpsFSqnzh4GDWJvRKvr9nSAQoP2UpXEUncYQOy/MiVenX2j7n6+aGgD?=
 =?us-ascii?Q?kmo2Xu8tFxG6AlXF5LsepUdaBESr2nGu/ZtkEwqBsg7K+wsQ3t4Z8DbOmUou?=
 =?us-ascii?Q?jfGxBLtLg1hIoNhzoa31OPeo4NTHcXVHJ0AIPM8H58EqQ9ACtDzp5FOvtDBx?=
 =?us-ascii?Q?J/VMMZkVqDNuQ8v7bwpQiJXPW+lFM9vCzODO31+iFtGI9j3/vtxb2OB2oK7r?=
 =?us-ascii?Q?Ve9AVkVUteXh5JR7hpeNKtipZ5AHohek4TPjvQ3lhCbZ489prxvGQNMTsfxZ?=
 =?us-ascii?Q?GebD1mlW5NjgISupC1E4eWutlO1uqhDNXNxqEO2K5RgdZRQHKZu9u8xRtIKI?=
 =?us-ascii?Q?Vr3JGnEIbFdWn6MpGUiS46vIBislzxOb7PCRVLTwb5V2qLCAgLc+F+R6j3IL?=
 =?us-ascii?Q?tfpPaZ9msRH18uO+McdqzBowRRIR+m1gbTSVigTphYW7CMDKPq35YERae4ke?=
 =?us-ascii?Q?N2eVgSEMqTAC+/9v0efExEZ0U/QALrlE2IwpJOSFWjLNKorjYo4fdrT9YhH0?=
 =?us-ascii?Q?xXQ7KtSgeARwOdpvnbXPt/9S5ywA/7a5DpqkyuHeDO+DgjYqfv4JRllePPFZ?=
 =?us-ascii?Q?d9KBSAWvkJDnC5fLmfqqIgKqJms4kh0SN9PhE6mxVKf/oNKERIJM0RtKNJM0?=
 =?us-ascii?Q?QIP8MAUJs0YnJs6i3YglSntxBITUaRigWm59iUOFEqaD2xCniz6/aaDzLeOw?=
 =?us-ascii?Q?5bwwHuQycopD8SdcopcEgGF/UdxlOhnPqjgnvGiZhV6el/47tdF7b5jj+Xsq?=
 =?us-ascii?Q?/tBlfnkVFh+fMJkR7Is+etKHyNZWZlTBsDQk52kOh32XvY+TlsdkWhszn8EG?=
 =?us-ascii?Q?iZqv10pCGKSnQjqaoRAakT+XcZhsWb9KMYTLdCkZ2h1+x1qeve6XKfho34iH?=
 =?us-ascii?Q?NiWkoHGN2QhgxBUj3yBPBb26A/CMTUiFHd55xpQoZ+jGH091Rf/VJ7NPigZV?=
 =?us-ascii?Q?QKbLXvcjnGruL1XOuyeZCR49c46ejU2ORIixx3VuIXZCyvcO7RpTX+xfqCvh?=
 =?us-ascii?Q?8pLwhbZ54ekb5y+VWfYEZALYmnapmyZpTTwEXYluum9IuUwY6/Vf5aHtCq+N?=
 =?us-ascii?Q?0yJCqJgAU6GfKsWEUO3pdyKLm1PjPAhukqYpWY0wxNRDOwjxlHzWCjuVqD1t?=
 =?us-ascii?Q?s/IG+SupXVDt3ioHSHVtO0zReWETX2f4i2A62coTr51byWgTEMidV/0Gu6qb?=
 =?us-ascii?Q?7BA94tHCEinTAGhG0EuLIUJ9z2MbsuN8wUrk1lC/3Qm238212W/wK4yuoBkI?=
 =?us-ascii?Q?j7Pw05tLniSRobf5IpHzkWGPLmd43Yefg6PlO66TsQu7G8F1LLiq7B7L57wo?=
 =?us-ascii?Q?GfiFHttR1A3R/aFMhOfYIn6FGEO5vpES4h5TqqZ57cO9/obPUuCmNJPK3AwL?=
 =?us-ascii?Q?rDOVl0XxR32fK4NnGZYf0JnfV904n++d5eDYlkoqnw68bnylD74QCbrWmFis?=
 =?us-ascii?Q?EI7Fpam1q9BUv2Vd8OK6jkN+uukuF7uDovUgBRJCPOdOe1+iqR5DxwQDgmAO?=
 =?us-ascii?Q?xmLKrcqVoUWYgWVCGcIo7iNNLmGajjabV0UP2SaxaGZBTbb+6BwEWDfsf9Wo?=
 =?us-ascii?Q?h6kmNfipzaug4nJD0wCCI8RWveyuc/wQK5AO0n5O47bPZjGvx5I73P/Ni+Aq?=
 =?us-ascii?Q?DwAlkx1u/PM2RcRozKD8ivocvzfPBMoMbB0+4DZhRZja8fcqdlcberAXLQuH?=
 =?us-ascii?Q?Z1AxeqMr0/sBQ6MzNQIogmu5EXSsMUyaGdtDqQ03a2yJHb9pDRC6?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b91946d-f177-489d-ca14-08da1df19bf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 08:34:36.6243 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K0FCzVVVwcoibIy4xmklOQa6FtrIJUuWoJyhu2c6d+RlT7HpHejhX1xxG/I7KMEGT7ku1zz8kH6PYQVHIOqPIovC6nbaRfc8UjKhmE1PK1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5043
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Thu, 14 Apr 2022 11:17:24 +0000
Subject: [dm-devel] [bug report] BUG for REQ_OP_WRITE_ZEROES to dm-zoned
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2BB24309023D7B4BB928983CB4FCFF02@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Mike,

Let me share a BUG I observed with v5.18-rcX and ask comments for the fix.

BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO)) in dm_accept_partial_bio()
was triggered for dm-zoned. It happens when a bio with REQ_OP_WRITE_ZEROES and
sector range which goes across zone boundaries of the zoned devices that
dm-zoned maps. For such bios, dm-zoned calls dm_accept_partial_bio() to trim the
bio to fit in a zone. And dm core sets the flag DM_TIO_IS_DUPLICATE_BIO to the
tio of the bio.

    The BUG_ON symptom can be recreated with command as follows:

    # xfs_io -C "fzero 4096 $((512 * $(</sys/block/sdf/queue/chunk_sectors)))" /dev/dm-0

    In this command, /dev/dm-0 is the dm-zoned device. /dev/sdf is the zoned
    block device. Its zone size is obtained from sysfs chunk_sectors attribute.

The trigger commit is e6fc9f62ce6e ("dm: flag clones created by
__send_duplicate_bios") which introduced the new flag (it was named
is_duplicated_bio, and following commit renamed it to DM_TIO_IS_DUPLICATE_BIO).
I understand that the flag is set to the bios cloned in __send_duplicate_bios()
to guard tio->len_ptr shared among the cloned bios from updates in
dm_accept_partial_bio().

One point I can not understand is that the flag is set even when
__send_duplicate_bios() clones only single bio. I think bio is not duplicated in
this case, and there is no need to guard tio->len_ptr. Dm-zoned sets 1 to
ti->num_write_zeroes_bios (and ti->num_discard_bios), then I think
__send_duplicate_bios() always clones single bio for dm-zoned. I tried
following patch below, which removes the flag set for the single bio clone case.

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f2397546b93f..d886c57e49ed 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1363,7 +1363,6 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
                break;
        case 1:
                clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
-               dm_tio_set_flag(clone_to_tio(clone), DM_TIO_IS_DUPLICATE_BIO);
                __map_bio(clone);
                break;
        default:

With this patch, the BUG is no longer triggered. Is this a right fix approach?
It looks for me the DM_TIO_IS_DUPLICATE_BIO check is too tight and I think we
can relax it for the single clone case.

If I miss anything and the len_ptr guard by DM_TIO_IS_DUPLICATE_BIO is required
even for the single bio clone case, I will think about dm-zoned change to avoid
dm_accept_partial_bio() call, which will need bio split within dm-zoned.

-- 
Best Regards,
Shin'ichiro Kawasaki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

