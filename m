Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92788135A65
	for <dm-devel@lists.linux.dev>; Fri, 16 Feb 2024 20:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708114408; cv=fail; b=n6nkYBKVDDS9A0UvyrqVhTDcXwjKX2rfYjhuvx34K+KD26NQOIm8h0GlEgzq7/FpNveWJYBO19OcBLtelcCkPmLK5VBuCFnVCZLXJs++g/p0bG+GDms1ggpYu+59hngAuLY1Iyy1XfZLlEq4xBPP2JTaF+odGsd1uSJlDQbrH94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708114408; c=relaxed/simple;
	bh=Wy8j+RQAXgdvKT1w9Aunoa2sjLQO84P1A25mSorwKfg=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=U7IJM3JRxyQ4PJhw9NSO1H7S9N2VkrawJByc3Hed6Jm+EFeoNu1g6NSmMlChBm8RwnCzxAvqknvDyWecIwimcWsUHJ9/CjLPRlBksnp0KE6CYogsuy90wJWoofDzyEr5U9R33dYJIo9Cx5t2VVTwnjjZS+GYzKZbQZk/Q2dY1cY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=YN+MtNNm; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="YN+MtNNm"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 41GDmUCV008553;
	Fri, 16 Feb 2024 12:13:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=UJ/WcqfNTbR4AMP9BbSrSg2cyu/RKd7eXFW33W+crZo=;
 b=YN+MtNNmxAPJ9FGYABk3WE6XBthPJKZv3KHrgTfcCzT21rLkNhl+dDoFCksE7CMzQ0gw
 cQVx4QqZglmKjPLwvTgV5b5DZMIxfAyHx9PgFDGgCwBNui+KJhuhsDZKI2JGDOE2vG6b
 zQlBgcTlF1x4ptfR24XjXeF/loY3Jmn7alkEUI+zmaWdbn5m+N4xMqj8bfpQwsd0KF6F
 jDvbFFe0Edy0yFOLCnPrwJiPCZEq1Nybpd7BPie9Ks5IHoXstnFLxf8Lsjby9wAvEf2N
 pHJLRpLZb3H7ouX11C/vISSi3dG7d1HcHpQelzV6T7GNIsYv8+j1z5hK8rIJdJqFJYgl Mw== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by m0001303.ppops.net (PPS) with ESMTPS id 3w9dk13gte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Feb 2024 12:13:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0zmL5tjtzOx2RCuu+B0k+GPzzzGxemlXwYtmxzrSu4nAAOgrFAwWFk9fyEX9GCQsjOl/McB1XSgT3xJKvDpJ/D/4gqwiIxZxSiG5af9uLCSHKrZCCcg9P0SMCaK69el65IETAbx1MsNowUtxi/NhZR5s4RdP2JrwJUJ/3IweTIllvSZTcJPI4DC13djYBBPel/0SeHEr+06c/TINl5a6Xc65Z/nknBXkscTFVYZ+tUz2xMFKmZRk+OQVv47f90QyxCIg3s9YlDbN0PUx18jemaL2GblDaKJJTIyQmaWL1d0nQ4Xk/MXOatDdTQlzlrppaETzyWmCX+/QAq0qKbXWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbbgRxf0H9UbSLxinXwH9X0ZpaiRIsuQOXcvgIRKVag=;
 b=i/QafhletqI/0Ut2lqNx2CHwHTfu7mZjx9B2rM2zUYCGuOwBuwPjf9Mipp/MJDE3bgP1L23O0ytCr6sOZpt/i3s6vT+755JalrjOMeKSKKyZPJ2ubFuG88/ABGG+6dbDvuHgKzuqmQJVtQrXQHdkMsycQNA++IXhmW1eGs5NWf/fhjzNUw4qlkDiYDlbQEeKvMqQ/cZ7+fRxWo9VUxdv+wNhQuqkDw0WphPqkktCi4uTFHyeLA8SUN22Ml74TnXklNOhKdDt+m6iBqtPGd+Hg8Dv8lqyBoRaxYVzFAakUXDrNRLaT0GHofpHPb6MDZjoHPrTMzye3KTpv0SFFVnJlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA3PR15MB6193.namprd15.prod.outlook.com (2603:10b6:806:2fe::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.32; Fri, 16 Feb
 2024 20:13:01 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d467:8e49:f5a8:c0e5]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d467:8e49:f5a8:c0e5%7]) with mapi id 15.20.7292.029; Fri, 16 Feb 2024
 20:13:01 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>,
        "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
CC: Mikulas Patocka <mpatocka@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
        Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>,
        Xiao Ni
	<xni@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>
Subject: [GIT PULL] md-6.8 20240216
Thread-Topic: [GIT PULL] md-6.8 20240216
Thread-Index: AQHaYRSKLjjk8tNMqkue0aPjhpdPXw==
Date: Fri, 16 Feb 2024 20:13:01 +0000
Message-ID: <2D753D1A-F9A6-4196-88A3-91C7596C17DD@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA3PR15MB6193:EE_
x-ms-office365-filtering-correlation-id: c1aa9327-315e-4e84-edd7-08dc2f2bad59
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 BNtBPTkag6OmodqzKh/60zp2f+WKiTDts//B/9XTo1w2vJGS81WKPdylNGIo0eB2QFlNq22bJ7fPktAGuNx2J6Sf1UsrHOObI5UdcI9vd87n3eXve56eWW1iPKclelhznGZHFo8Q6UdR67qUp8cv3bEpt0uqFqYYuJ/cJn9CbvnjgMyLFIupwkq4cLOMQ+B1+nUf/kPSTvGWrCLXQhg74znmQ/1QlLiOjhPGOFXqZFUU0tx55AeUriYjDcNxuStXX9bIaZb2SQGwmrDj1KtVHryOH5UDL5yX+FGlAKCRXw0Yy+3MIt9PU2yEKxJkYyyEZdA/XbZaVIsBblgIaAFa2s0jK3g793YH6KwFF/keNPb1T3fbEs12YEELHGrIfq14hOrEBaAYXHBGUD8xTiO/tw2QFO0QP6GleoWZIY6tOpnvhA2d3pprIUapAe/IAxkHpLcVUZ1J7mqV/M60zyVg7HEMc0Lv/m7LKwlqOOsqNAydLNGrBxjuabt+Z361P41BhhOZ03NvE4l6bYwBpoO+FwZ8wjUUTXpi3mhIY+aQB/0Q9Vmx/7L6Fgo0piawOba5ME3D6KvaG7UnF0OApDAHRRqyFJBhPBQdUvBlAEX0gtM=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(396003)(39860400002)(366004)(230273577357003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(71200400001)(41300700001)(4326008)(2906002)(8676002)(8936002)(64756008)(66476007)(66556008)(66446008)(5660300002)(66946007)(76116006)(38070700009)(110136005)(9686003)(6506007)(966005)(6486002)(6512007)(316002)(54906003)(478600001)(86362001)(36756003)(122000001)(83380400001)(38100700002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?uvq1QDQU1Gc/+CidC2/IKvFrzzWF+a8nuvZ8Y3sHClDNCuQJNcq+o7xJjUWe?=
 =?us-ascii?Q?7PhLT9Rj239SjNl4w3Vace/14KW2Mp0PWhiNpVuYJN/v9Qt5+5wTQeHOa+On?=
 =?us-ascii?Q?/M2YMOpOOX5y/dF8/oEWb4KBhxwcMmE2fqd+xZEPp8rZ0NqOkjEL4oQiBROx?=
 =?us-ascii?Q?DVYcxu5BR+Y+axj4b/JDNS4GNaKIYEFwERwAUEAKb8e7eM5xSl7IXSRSS3KI?=
 =?us-ascii?Q?4o31Ng2DWNh5Pmku6zOIfEV+iN0mfDayNwDMma/HwqpxpVQM22fdA6cs9c5h?=
 =?us-ascii?Q?/4+ee9UddulmDciiK2Lfud0209gjdNFKjnTTXRDLh4w6eA4gYZ5WpEf04ISC?=
 =?us-ascii?Q?KWUt6obT+1oYnrfUixTG9bWESFPuvse3r0XoAdNl36KOSrHeSdCpe79e2Ekn?=
 =?us-ascii?Q?+QwClIWnd4GscDQ1IKKC1n49k+ElxruolFLOXHDYlu176hWO0zR+FRvkcTYG?=
 =?us-ascii?Q?vsrNnhS+kFZ/92STd1Ls4+YVZBkXN5/PPcHHlC2lbsH6iWgC/U2YfQnhzU5n?=
 =?us-ascii?Q?cFpHOm2KQoxI5FsamT36lfF5Is0BX4b6MuLxtyCkUDaY66GUN4Eel0DhHkVb?=
 =?us-ascii?Q?kfXTvCoNBehcvsXt3sHtQ3ImG0Z9boqOzF19K0K820f/MwpaPnh5nUf2l5Sz?=
 =?us-ascii?Q?ZkKdDQ9kMO7ZwMg5gfo0jGsLnA/Si5b5P569G0qr37KiFlI84qau1VvFztHE?=
 =?us-ascii?Q?fiS3QN/pqf6qUaju/v9vETJIC32lY63O3mIHlMf9jgPDEH0WAXt9XoExIkBe?=
 =?us-ascii?Q?k99cc0Q9fbq171/ciXYyXW0KR9ReYIjt9RQAmaBJbr4THg1N7jlmFoIOfRb4?=
 =?us-ascii?Q?MelzNSvEj7smPYOKEg/fp9sULUNIPXOvHCHCLY3J6caF4xRM+nKh5yeOUrju?=
 =?us-ascii?Q?bQsaAnYKzIEPuWz6uPzng2ZkDhb3nfL45EevR/kEOK99bPybJ+7IBF6jpPv2?=
 =?us-ascii?Q?HsmBZLZbRTtr0H/2F82z1dii53se4QShkAesTbc/bui3nsIdKlnhFKAy2oJv?=
 =?us-ascii?Q?jQPHciLD3PU7xFttltvG6A0tb4kqdKUatAT/3xGSA0ymAMSPojucQPHnQ1u+?=
 =?us-ascii?Q?FHE1VQCYFByUbASZln21ZGfK6QZzRQOX1fMsBIFqoXe6Jn/VphLuua+WRFWU?=
 =?us-ascii?Q?QW4TXHWqMTv2GnO1qHizAyyxHoZ583SW6/p5PfOU0DcgDawfHmN2W4xxbQqE?=
 =?us-ascii?Q?poPMA21lvyIdyc3p4vtp/vCH6vjgGwQKhNTGVF1HrclaFbobKgMzE0j71ZvL?=
 =?us-ascii?Q?CK6xUBficEn8mt4ENH96QXI2RiLufxIZs05i7A6HF+Z805aBehbPbdpT7OYS?=
 =?us-ascii?Q?FZgnKf6D/95akTld/YYMk+sz6xwyZ3lWHbsouk+hzOjoE/zH5dIiSgH4mulK?=
 =?us-ascii?Q?udbdmn14gqFIoMYTMej9woreP0rSxP7zmZlLPYl+02RjR85q6UsE1a0yA8AZ?=
 =?us-ascii?Q?zQXu23dpmpQ69gu/rS3XL6YP6G51Pa0dr7dEKS7BK97YOaTpQMtqclXBXeRU?=
 =?us-ascii?Q?wA+US9xALpJGVsHm7KTC+hDZ+Hb3Wl0Vtc5o4IZYsq+j0VYe0N3ulbepg4eu?=
 =?us-ascii?Q?YoyX2lpC+iBhzooKwOkF4YpwPiupEZ7bcSS3k7S468npKITkrbyvW3dw1vOJ?=
 =?us-ascii?Q?VVpeFbjzcVSMWpMilPle52g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <64FB98B6C616674EBA2FD3CEFB4F7FC0@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1aa9327-315e-4e84-edd7-08dc2f2bad59
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2024 20:13:01.8077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yoUgs+L/pw8ts+Aob56cGYXxMfuEEJy8VE72T4B9DANna4DJl0+8f1hZrjD/tcBnDYuRfR+97YImASg2qVlsDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR15MB6193
X-Proofpoint-ORIG-GUID: c9SMW0Ud_KmiFEDgXDEBeysUTAc_F6dg
X-Proofpoint-GUID: c9SMW0Ud_KmiFEDgXDEBeysUTAc_F6dg
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-16_19,2024-02-16_01,2023-05-22_02

Hi Jens,=20

Please consider pulling the following fixes for md-6.8 on top of your=20
block-6.8 branch. The major changes in this set are:

1. Fix issues reported for dm-raid [1], by Yu Kuai. Please note that=20
   this PR only contains the first half of the set [2]. We still need=20
   more fixes in dm and md code (the rest of the set, or alternative
   fixes).
2. Fix active_io leak, by Yu Kuai. The fix was posted in the same set=20
   [2]. But it actually fixes a separate issue [3].=20=20

I still hope to ship another fix for 6.8, which is discussed in [4], and=20
fixes bugzilla report [5]. For this fix, I would like to get review/ack
from Yu Kuai and Li Nan. We will get this one queued ASAP.=20

Thanks,
Song

[1] https://lore.kernel.org/linux-raid/e5e8afe2-e9a8-49a2-5ab0-958d4065c55e=
@redhat.com/
[2] https://lore.kernel.org/linux-raid/20240201092559.910982-1-yukuai1@huaw=
eicloud.com/
[3] https://lore.kernel.org/linux-raid/20240130172524.0000417b@linux.intel.=
com/
    Note that this specific email is talking about a different issue=20
    than the rest of the thread.=20
[4] https://lore.kernel.org/linux-raid/20240207092756.2087888-1-linan666@hu=
aweicloud.com/
[5] https://bugzilla.kernel.org/show_bug.cgi?id=3D218459=20



The following changes since commit 9f3fe29d77ef4e7f7cb5c4c8c59f6dc373e57e78:

  md: fix a suspicious RCU usage warning (2024-01-24 22:58:00 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.8-2=
0240216

for you to fetch changes up to 9e46c70e829bddc24e04f963471e9983a11598b7:

  md: Don't suspend the array for interrupted reshape (2024-02-15 14:17:27 =
-0800)

----------------------------------------------------------------
Yu Kuai (6):
      md: Fix missing release of 'active_io' for flush
      md: Don't ignore suspended array in md_check_recovery()
      md: Don't ignore read-only array in md_check_recovery()
      md: Make sure md_do_sync() will set MD_RECOVERY_DONE
      md: Don't register sync_thread for reshape directly
      md: Don't suspend the array for interrupted reshape

 drivers/md/md.c     | 70 ++++++++++++++++++++++++++++++++++++++++++++-----=
---------------------
 drivers/md/raid10.c | 16 ++--------------
 drivers/md/raid5.c  | 29 ++---------------------------
 3 files changed, 48 insertions(+), 67 deletions(-)

