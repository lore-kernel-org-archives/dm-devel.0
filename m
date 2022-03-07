Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11D84C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 11:39:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-8O1S4PIEN8CYlCzZkTl0TQ-1; Mon, 07 Mar 2022 06:39:39 -0500
X-MC-Unique: 8O1S4PIEN8CYlCzZkTl0TQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CCA08027FA;
	Mon,  7 Mar 2022 11:39:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 65AED400C849;
	Mon,  7 Mar 2022 11:39:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0A5441931BE9;
	Mon,  7 Mar 2022 11:39:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 51CCE1931BDD
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 11:39:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 20D16580583; Mon,  7 Mar 2022 11:39:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BC1E57ECDB
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 11:39:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF0841C04B62
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 11:39:34 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-aR_qj8L2PyKPqssgUKGj-w-1; Mon, 07 Mar 2022 06:39:33 -0500
X-MC-Unique: aR_qj8L2PyKPqssgUKGj-w-1
X-IronPort-AV: E=Sophos;i="5.90,162,1643644800"; d="scan'208";a="298794695"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO
 NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
 by ob1.hgst.iphmx.com with ESMTP; 07 Mar 2022 19:38:29 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MN2PR04MB6704.namprd04.prod.outlook.com (2603:10b6:208:1e0::8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 11:38:27 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6%4]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 11:38:27 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: remove bio_devname
Thread-Index: AQHYL/HalM3iIVsQ8E6UDIHJpvJNVw==
Date: Mon, 7 Mar 2022 11:38:27 +0000
Message-ID: <PH0PR04MB7416EF31E50382108FEDE5689B089@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220304180105.409765-1-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8760ae9d-6d76-4b8a-ba18-08da002efef2
x-ms-traffictypediagnostic: MN2PR04MB6704:EE_
x-microsoft-antispam-prvs: <MN2PR04MB670421855839CFDCB304AFB89B089@MN2PR04MB6704.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: tZ9451MKGvwAEYMNMy2TaOlFVkODzGnlFk+ACk6F5HfWVFOdC7nmirwIS89ue/50+mnSzDukwB4xHXXsTMLXvXE7uIP39I51SSLZkhEFLQ7lMOlnOhT2Tgq3gGveN+Zpe8yzJjtsv4jQqzersCpifma5nRP8SXEZD3ely69gpjkNnmZy+zMEpycSl7IzxVhqeX+WldMeiE/XoSWwi1irrRuqFD2IwVkxQk1+3bUTruWVr9WWmR5jMYeFOzAekoZflGAkfG5uK+wU8/CKXaLu15tHhk/s8IYQcoA4KnF3SEJ4rWCR1yZA4xsvdrgnRcoAj+uI3eCck2kt50FWof7NU3y4ipd6/0zWU7ZIkQV0tcUf5oWiBWzMKkS8zIUWv3iRpooq9J2rpR5LgvIkMeD93DbRtviMAEVXa3hjP+pw8ykJMukzx3pNGNRp/FDs/1gt60caAwTV8VSaD37GfPvj5GvOBZRTw74SsIaUxHbGNtdEEI2oZAjukgNnJu01Gc37iXEHBkxMWfZfxzDUNatUia5YHzURubQqaUJ8A/MP7k4s5cRS1zU0JCE+2WBxV6uCLk6m/1+rcbfAOkEBjreC6PZ21FODzcQgfhsHS03KnhQ4j0ytYGGFYwdrKFsc1a/BEBdTpJqMVr0J2l48hmUW5JVdByY59TJQfAhQmD7QzoQVSWblJU7OapPvIOLQqOMTx0/c7yVrQyCYMY9ONKbCzg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(54906003)(55016003)(83380400001)(186003)(86362001)(110136005)(33656002)(71200400001)(5660300002)(316002)(4744005)(8936002)(52536014)(91956017)(64756008)(2906002)(8676002)(508600001)(4326008)(122000001)(76116006)(66446008)(66476007)(38070700005)(66946007)(66556008)(38100700002)(9686003)(6506007)(7696005)(53546011)(7116003)(82960400001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+rgAAS0dW1bhRVsud7VuPgFVuAAMTxlHbl8awey/Otxr8Oq3UnTdxORYw1Mv?=
 =?us-ascii?Q?VyudxyjDpeQCZtP1TOCYsiGhFTrcMoAYyUR4zlbIAiHA076J2lQJvPYDnQA1?=
 =?us-ascii?Q?J/VixKhBg7YQmHVWiO45b0q4RjT4tnmR8cxhzMhA28umy9d97Re+b1vn3G7p?=
 =?us-ascii?Q?b1GWC9ftJGfvkoCxFnYv341A0gmcXD3V+1yHASNIr/IyfmKN6W7pZ4KLybM1?=
 =?us-ascii?Q?JwpXdUqlPhX7iiOiJPCWfFl1IJ3eRIfauoZufwrFXRp9EIejOBLvcHvV7kqT?=
 =?us-ascii?Q?PaglLPJsHDiv05FGDWXweKLrlf5BtqCM2MRu5Hl/2ml9lpNUV6TXwXsg6SC3?=
 =?us-ascii?Q?pbQLyvX88rB6NuPbD0J49hpcMs2qvcuSWhM8zuNN5Dc7O60RWWm1v78QsMhA?=
 =?us-ascii?Q?TreazZLW6l6VbvYrtEsWvQNVu8han5R9qOzYblBNiO6kbq6RyeWCkcDeZYqp?=
 =?us-ascii?Q?NsPyHiym+BbrWHAr4s7q0WIhXEiYxnOLZdBB20gVVmB16+loIR3vNBxPUy1V?=
 =?us-ascii?Q?tk40DILzatJyd/6eLpUKBrzTqkZ82qPdNd46km6ny6LOwhqABEK3UE2msvfZ?=
 =?us-ascii?Q?9vMOsgCvU3/7Vq7i9+5QCHA1cVY7Fga6fJtWeAKTAfirznQWzGl0F06Yd3kn?=
 =?us-ascii?Q?Pt8hfGZ07BbfZeCZjFiT3T/Ndg2QkeL/a8QTSR1ZPwAleFGtUT3c0SiU0dcX?=
 =?us-ascii?Q?+5L/swNTcVlszJyIg/GpE1X+G7D5k3dW/ukCpetI958lt5PJ3CKIMspwOGen?=
 =?us-ascii?Q?1oloTBI5eAMlvwzAf+20AgIDuvwW9E8bic/xRzFDU9zteVaxvVNO6L1KfLTP?=
 =?us-ascii?Q?c8kuxVP8BZIeWxzkStDwEoHdvwg1p5jb7zQGFGBxTmYa8Xnm7zRY67lvuyNd?=
 =?us-ascii?Q?VFhPghqd9skJO4w+585QE67CnSBbOvnO5PoTl7RGFl7gilKH7kPspcV8IqHj?=
 =?us-ascii?Q?75Tw7SQ4B9urkgZlAm9Qmkk5BcX5s/Gw51LVO3SSSBDsgKpxuQkNzROfq2t0?=
 =?us-ascii?Q?BrROZ2k74ojSUQXVPci/xAMn73DIQ8AnnbyfTwxyhAJIb0cjAqoQC1Pf3gV3?=
 =?us-ascii?Q?3NB64QmWDJAuR2KJ/SrnsphJN32FQNqlgiMeuKP53HByItPzPY9Mhiag5Lxd?=
 =?us-ascii?Q?h7acYeVlu8e4uOUqJK7kglO7yn0DYIv0R+hVHfBWdaId00HH0oO/4F3W9XuQ?=
 =?us-ascii?Q?EHX4v6a8qS4ErASPOfm7bE73DH+maWf6TWiK1oCJYawLMR1JHEi1msluklyD?=
 =?us-ascii?Q?V7Ya6UlHAF5vQx78lEU1mnjIZCm9MtSCPRAFjIdsn1sTKAbuPNNMMPb2kwzI?=
 =?us-ascii?Q?qE3T6KkuBfBnaLtHpzk2VeDVSpETxnrZ+l95bo2XQW7m94+cH2gaTZb2viiM?=
 =?us-ascii?Q?k7PYfvBrwOB4xweKQCFCsnNQGodqjPy/qFcnPEFXVRy3My8PKzIl2FhRX/Y9?=
 =?us-ascii?Q?4RViFd1PuehvieKhiNGZ3k+eoecBmHE8gWe/cz6+zbKMdyYm3iAPTbjSIALf?=
 =?us-ascii?Q?LBSryrdSZtGhzXSEAIszaVNQ7mHHD+pwPHSqWfky02cFoIrKmwTlaYOiBq2O?=
 =?us-ascii?Q?P+iNOqxcaeCwUTNFpxOCk3Q8H0NCuXViM9z5zUn1n/Qkvk1+xxMfcoehzicM?=
 =?us-ascii?Q?HJzHJZrHTZsQrNf8dASkcC4LCYJif9PxRK/KqhRxNA7HNcgh2bNay21Gp3Y/?=
 =?us-ascii?Q?qIDO7u1PYItfAr0k4UhArNWnqVilSZRlCejEe3Fzu4AvKG8ymUzUeZ/3o1dj?=
 =?us-ascii?Q?cg7B89GIIq2s9gdK/yoPInSwD4SVMpY=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8760ae9d-6d76-4b8a-ba18-08da002efef2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 11:38:27.0600 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vMvFTy65qTq4xL1Tv6aN0V6gjKHLhMMg+CwdyzVQJEB3t5aAFTY9q4EBsWnDvoJu2tRzYsAmvfhGS19CxQba9jsDOW6ngd8CuoDqWJugHtQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6704
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] remove bio_devname
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
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 Theodore Ts'o <tytso@mit.edu>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 04/03/2022 19:01, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series removes the bio_devname helper and just switches all users
> to use the %pg format string directly.
> 
> Diffstat
>  block/bio.c               |    6 ------
>  block/blk-core.c          |   25 +++++++------------------
>  drivers/block/pktcdvd.c   |    9 +--------
>  drivers/md/dm-crypt.c     |   10 ++++------
>  drivers/md/dm-integrity.c |    5 ++---
>  drivers/md/md-multipath.c |    9 ++++-----
>  drivers/md/raid1.c        |    5 ++---
>  drivers/md/raid5-ppl.c    |   13 ++++---------
>  fs/ext4/page-io.c         |    5 ++---
>  include/linux/bio.h       |    2 --
>  10 files changed, 26 insertions(+), 63 deletions(-)
> 

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

