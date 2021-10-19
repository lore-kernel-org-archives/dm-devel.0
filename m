Return-Path: <SRS0=V8Hk=PH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242F6C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 19 Oct 2021 02:54:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 80E3F60F02
	for <dm-devel@archiver.kernel.org>; Tue, 19 Oct 2021 02:54:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 80E3F60F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-9kFUxTR4OAisBL-U2UUPgg-1; Mon, 18 Oct 2021 22:54:48 -0400
X-MC-Unique: 9kFUxTR4OAisBL-U2UUPgg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C6EC1006AA2;
	Tue, 19 Oct 2021 02:54:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B91A197FC;
	Tue, 19 Oct 2021 02:54:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B62F71806D03;
	Tue, 19 Oct 2021 02:54:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19J2rbpj028263 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Oct 2021 22:53:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7BFBE21565E5; Tue, 19 Oct 2021 02:53:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 75C3A2156601
	for <dm-devel@redhat.com>; Tue, 19 Oct 2021 02:53:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A32FA800B28
	for <dm-devel@redhat.com>; Tue, 19 Oct 2021 02:53:34 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-148-rJ8QhFISNQmI4vDTQ2-ZFg-1; Mon, 18 Oct 2021 22:53:33 -0400
X-MC-Unique: rJ8QhFISNQmI4vDTQ2-ZFg-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19J2SWJl007657; Tue, 19 Oct 2021 02:52:51 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3brnmf7xwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Oct 2021 02:52:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19J2VUj8014130;
	Tue, 19 Oct 2021 02:52:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by userp3030.oracle.com with ESMTP id 3bqkuwgp15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Oct 2021 02:52:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16;
	Tue, 19 Oct 2021 02:52:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::a457:48f2:991f:c349]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018;
	Tue, 19 Oct 2021 02:52:47 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pms1d8w4.fsf@ca-mkp.ca.oracle.com>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
	<20211015233028.2167651-2-mcgrof@kernel.org>
	<yq1bl3ofjo5.fsf@ca-mkp.ca.oracle.com>
	<YW3ZuQv1qpIXkd5b@bombadil.infradead.org>
Date: Mon, 18 Oct 2021 22:52:44 -0400
In-Reply-To: <YW3ZuQv1qpIXkd5b@bombadil.infradead.org> (Luis Chamberlain's
	message of "Mon, 18 Oct 2021 13:31:53 -0700")
X-ClientProxiedBy: BL0PR02CA0117.namprd02.prod.outlook.com
	(2603:10b6:208:35::22) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.18) by
	BL0PR02CA0117.namprd02.prod.outlook.com (2603:10b6:208:35::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15
	via Frontend Transport; Tue, 19 Oct 2021 02:52:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f71b47af-e5d2-4a46-cf55-08d992ab8837
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5612CBB25690C25EED7375268EBD9@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: jGRqMuGIFJtch3sQkmWNIo3DxaSILxOgnlM6Yyr2SchOySNj8nd2dFjZeggnQrQHnf0pJTUT/ocWogUWcOcA4QXGGPCO3d3fnVvljJLK1gcuYugYQiQmpUF8gqYhyaOBJ5q3PMa5L0aNAjQ8A6UM1cytzeEK91RBVo4Lezz/KDiq9Y/nL6b8BF335UGkR6okyTJ8lxJJ5tAeYK29z4Akz6h0MWBETdXf8YUQ8zp97wk9fpQhb6x0mOoxMitCDiiuMnBvtbdFz1Zwjl3IpCMM3A/37OMVxqtyQZ+vZ/IaiAmcf7hSq41yfaswC1WkTSp5LNhaRc4rKYCU3MFaKqjwtphIYR8UPTHDjTDV0jr3xr+9F8OTWK13cvQtCRs9QItpJnbcZ/c2aqmTZe0tgeGe6d2Ky3/Lz3qNfmTLP/gaWzSZMcD7LSNlyreE9XibY65mtsWnwErdvICIPMiNZCcIODLa2bh/KsEC46hnHwazOSdGPg70JW3CMNLnYnG/sgAlTknfCp9kHKjn07jvqVLWiIHldwVKzL3fOzNdjPScVtOEo1HBH2oV59zMJakyVyfit54YaTpDwntYdO0MnslQiSGhOmLBe/JywHT9mFL5nxEWAzATsXFCgUMH2olk61DCAQ+L0SbLkWVaODezLLDPgf4npsnKRElr9/9Fur5tzsXH0UE58ao/mGzxY/IbjevFnmtc7pXnMN3TGhT8c5xr5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(6666004)(7406005)(4326008)(7416002)(558084003)(8936002)(956004)(6916009)(316002)(2906002)(7696005)(86362001)(26005)(38350700002)(38100700002)(54906003)(186003)(55016002)(8676002)(66556008)(66476007)(66946007)(5660300002)(36916002)(52116002)(508600001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?meZ11y0UqDFMVR8LwY48iHN+B2ZAJ2DS7unaUAOmJQU7p1kC0uyKI0gpGOCz?=
	=?us-ascii?Q?gsgck0SSO1gEbziQu1uWrl+Himk4wJGBH1OY5hPheMyjTgbcoiSwKIGoK58Q?=
	=?us-ascii?Q?x4Bv0cLGCehVSC+FPwGO/sQZhb3mArHLehb88qPj57a4uk77Wu5MUI6UOM0F?=
	=?us-ascii?Q?0O7P6FALq9Wp9spgA6Nf4BzthgZsQKy1YTY1Q6b3UQqimzDL64HCKL6AvAgI?=
	=?us-ascii?Q?6eVQxKFxCTXIo/DTUPICOdRi9Tx3XVbBj+OeteYg/WwZJS8PN0Rs3Da8kluO?=
	=?us-ascii?Q?4tgJJcW8fSsHbf4nlAgsD0C696KyfwXD1uKEIs++OmQTWohWQ0kKqnwtjXnt?=
	=?us-ascii?Q?N4XFQZ1lIz2ICesiP0tu/vAxBDRm9cQzx+IDvWzUbozEyZnFVVMPAl4DPAOc?=
	=?us-ascii?Q?oqH4LFRf5T6HvrJ5Iw11Ra+Y1s299n7SG8HMBRUOPy8Q07KvKwWiNmiq+9hR?=
	=?us-ascii?Q?Sdcy1uURx6A1AHnMX7mGvmFMzyPok+M+SJFXNZ6DZ+aM8AgBETwXp+/9KZis?=
	=?us-ascii?Q?NqfkW+rbNXztE9MSFsVZXXpvcxOcs6RPhqhN2soaW4FpkKde4RXxNbRVp30T?=
	=?us-ascii?Q?pWlreM7OGFjoWA0LvBuhsqbB9m7D3QQ1FddMY+QbVXGIaUP+AdPfRfmbBVEl?=
	=?us-ascii?Q?yOWq6iWvEk2vY2/zCYERhU7jeHFHoo6LKlCj+vWWr+TM0yTvYlip/UIMz4ND?=
	=?us-ascii?Q?+OR7uwDPTTidJLmDMZd3+MJf+QHKL3IeYG80KLmdmixaaZUF6Xyg62Al3Dql?=
	=?us-ascii?Q?xCflg7F087vsKPR/C889V5dOBDhbA9NKie3gyMjdXA72rJ9xtIjNBiEP9KlZ?=
	=?us-ascii?Q?QwxL/xXzxokdkA4f0C0yyJtN9XpxnHM2zeRuUbNecKIbP+S4A6WQmZ+quRuZ?=
	=?us-ascii?Q?0qz41NwM+aOvEduibJ8N74tbbKYRvRpvi1cIA1GD/LOL3bcIg45du1F1TnL8?=
	=?us-ascii?Q?SRGkAEhM48ZgaSWxbGQ/1hOQRXBtHvVF5oUpFCV5C8wMiH2uXx4kSVKllMdK?=
	=?us-ascii?Q?geoX2J9XkEkkJeHyyvU+hDP51lRTtLuE7nc2WdGn/4mqQ6bC1MJPB6uILkpi?=
	=?us-ascii?Q?kNSAvUFkprFOlioF134mXjvjEE8+tHxYjwi8WXig9QCAZJZQmcFp04tBhC6z?=
	=?us-ascii?Q?zx1QbiUN7GphDTDan1y9GrPioq4KJn7u6v6Z660EZfYqv0X2m3pGIJSiI4W5?=
	=?us-ascii?Q?P/Jn9yK41w+maH1Aab+AbY6URwpqQZXJEbTEHP4/DNN8u3413jzEXsLlOL2i?=
	=?us-ascii?Q?/dCFFzl0tenq7PK/3GMPK83gHPWsvRGAcxvcBBahfbks7TmgtnYueW0N1Htq?=
	=?us-ascii?Q?hbVqXAGYSkZLXKtP6Jl1ehtN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f71b47af-e5d2-4a46-cf55-08d992ab8837
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 02:52:47.5144 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hxwuuPShKyKXOVCuyR2GEPaEFztujWky8m0/kKzFB0dIBmxOllLsoIqtc8AkZQ5sw3Tbo/+nRP1sD53gpaCIctKMLHtP0WEm8WEs0NXOia4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	suspectscore=0
	malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110190013
X-Proofpoint-GUID: iauxcMEjFutpKRN5OBYZcn6MHISXq-QI
X-Proofpoint-ORIG-GUID: iauxcMEjFutpKRN5OBYZcn6MHISXq-QI
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: ulf.hansson@linaro.org, vigneshr@ti.com, snitzer@redhat.com,
	linux-m68k@vger.kernel.org, dm-devel@redhat.com,
	haris.iqbal@ionos.com, miquel.raynal@bootlin.com,
	krisman@collabora.com, Christoph Hellwig <hch@lst.de>,
	agk@redhat.com, anton.ivanov@cambridgegreys.com,
	sstabellini@kernel.org, linux-scsi@vger.kernel.org,
	richard@nod.at, kent.overstreet@gmail.com, geert@linux-m68k.org,
	xen-devel@lists.xenproject.org, jinpu.wang@ionos.com,
	jdike@addtoit.com, jgross@suse.com, johannes.berg@intel.com,
	jejb@linux.ibm.com, linux-um@lists.infradead.org, colyli@suse.de,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	boris.ostrovsky@oracle.com, axboe@kernel.dk,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org, thehajime@gmail.com, tj@kernel.org,
	linux-mtd@lists.infradead.org, chris.obbard@collabora.com,
	zhuyifei1999@gmail.com, roger.pau@citrix.com
Subject: Re: [dm-devel] [PATCH 1/9] scsi/sd: add error handling support for
	add_disk()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Luis,

> Thanks, would you like Jens to pick this up and the other scsi/sr patch
> or are you taking it through your tree?

Didn't think I had the relevant add_disk() patch in my baseline tree but
it turns out I do. So I queued them up.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

