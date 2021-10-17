Return-Path: <SRS0=LZZ/=PF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95ACAC433EF
	for <dm-devel@archiver.kernel.org>; Sun, 17 Oct 2021 02:52:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1BEC860F02
	for <dm-devel@archiver.kernel.org>; Sun, 17 Oct 2021 02:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1BEC860F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-gUCzU8pVOWq_YMw7CeeJ1Q-1; Sat, 16 Oct 2021 22:52:49 -0400
X-MC-Unique: gUCzU8pVOWq_YMw7CeeJ1Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2183806689;
	Sun, 17 Oct 2021 02:52:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E4F25C1C5;
	Sun, 17 Oct 2021 02:52:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 836B81800B9E;
	Sun, 17 Oct 2021 02:52:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19H2qYFF026149 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 16 Oct 2021 22:52:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5024D400E410; Sun, 17 Oct 2021 02:52:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AAB240D1B98
	for <dm-devel@redhat.com>; Sun, 17 Oct 2021 02:52:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DB14185A7A4
	for <dm-devel@redhat.com>; Sun, 17 Oct 2021 02:52:34 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-182-TBJAKeXgNPmX4M12vflnYA-1; Sat, 16 Oct 2021 22:52:32 -0400
X-MC-Unique: TBJAKeXgNPmX4M12vflnYA-1
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19H00NsD011778; Sun, 17 Oct 2021 02:51:54 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bqqm49r8a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 17 Oct 2021 02:51:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2owIY152011;
	Sun, 17 Oct 2021 02:51:53 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
	by aserp3020.oracle.com with ESMTP id 3bqpj28sfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 17 Oct 2021 02:51:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by PH0PR10MB5530.namprd10.prod.outlook.com (2603:10b6:510:10c::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16;
	Sun, 17 Oct 2021 02:51:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::a457:48f2:991f:c349]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018;
	Sun, 17 Oct 2021 02:51:51 +0000
To: Luis Chamberlain <mcgrof@kernel.org>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bl3ofjo5.fsf@ca-mkp.ca.oracle.com>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
	<20211015233028.2167651-2-mcgrof@kernel.org>
Date: Sat, 16 Oct 2021 22:51:48 -0400
In-Reply-To: <20211015233028.2167651-2-mcgrof@kernel.org> (Luis Chamberlain's
	message of "Fri, 15 Oct 2021 16:30:20 -0700")
X-ClientProxiedBy: SJ0PR03CA0105.namprd03.prod.outlook.com
	(2603:10b6:a03:333::20) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by
	SJ0PR03CA0105.namprd03.prod.outlook.com (2603:10b6:a03:333::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16
	via Frontend Transport; Sun, 17 Oct 2021 02:51:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87750c7a-62d2-4af9-7bce-08d9911911c6
X-MS-TrafficTypeDiagnostic: PH0PR10MB5530:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55306D7AD1B871FDE590A8488EBB9@PH0PR10MB5530.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: T+3QZh9zDXqbMpdWQQ/r85NOc5Ti89JpwExfWWPeOwMUQTWQzPmsvCr5wfJECIO/PO0Zma+QD5T33Op2EB5Qt0qbsEjMFbUp81rTL0WzJ9EUm+kdIZ6AqkNbbxlXFj/U+Yrjb8NBGn2jckdXFwJSIUvxHMFDuqdNfSQv2ppXc1zeNR6EsIsmJgmIU8uORpHOdThJLSKwp0OYoGbKtfuJEBCLoYbqath8C+BKd5cfrqoA8U/gbJPZbbhKO+2ZhJGeh2peLmMZmNbcjaQJqWY/8/Xx2lb3ZgJm8Ncgh4flggLaqAkTuknwiL8BkFKMaaltI5zYiUKb2oFpb29J+1MOmVcYQe+Y4iejXTuDgEHtpPlXMDX3ru6ayRTf/eX5DM4UgSBqN3gi66NcVUnx+7T2seNETumb6ZunepJdKQypSIJCHcj17Folhds9kKowKStACbc18fjqyeAQybYIV9YwNUSWakn3m+kUm5d7ympfQK2b3UmkBdFs4WcyTv8Ep1aeFCx5L95H4MbYPWH0zHZUAWZw9VsxC8N3rX6YFKBDOPF54bzNB9GkwSMQtCe96R4aRDVRZ3vnxjOSX5SS4m4TGP9wpLsLM2tfWis6k0YrXkg/axCUgF7e0W2J26kcHq0hG9rzcVCpI13HTnmN8eNJM9EZnVLKtfBy6CNDWMvcrebdqbH5RdVsh5Ph4Q7h22xKyx0n/53HZGfVZ6nn4FvU0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(86362001)(4326008)(7416002)(2906002)(7406005)(8936002)(186003)(55016002)(508600001)(8676002)(38100700002)(66946007)(4744005)(26005)(7696005)(956004)(38350700002)(36916002)(6916009)(66556008)(66476007)(5660300002)(316002)(52116002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kbOcSvfAD3n8+/pgfNz4afbOzyk+4imAhPOnJpxkTf3ax8Y/1yToD7VQRkGd?=
	=?us-ascii?Q?qhE5G0NdN+zo2pCC9drM2JygrIoNPpoGovRXweaL2EbCA+De+5sdUcsyBZLd?=
	=?us-ascii?Q?jGHa1OqM4GlvLOtRjaYnnWidD3dBmlQumSh75LqqxVJ5UzSTiQqT+6YahZ5J?=
	=?us-ascii?Q?s/xvH33hDO84KdfO7DzT3JTAGoy7CA3Mia2s7GaOTGHd6AM6kGrBZrzX6KvR?=
	=?us-ascii?Q?MK6FtmfbbKape0swwjU6zXKnz4cBXifUakFq5qBvyymgGuo2eE+JJhzFoepf?=
	=?us-ascii?Q?+UmBpauR6B3q4kxogOriPhddWPLD2FiaL14AALtkRz5ths4GzWNsX0ye/2qC?=
	=?us-ascii?Q?gXsFs/z4d4tFR+E2PoWzaA3HkYbhXUSMUpuJ92GG7Hu0kzORz8UzMocu7MHm?=
	=?us-ascii?Q?0TxdEHtx0OpawTqM/wnBqIuSR4ClbvjGtQOv0B5nxiSSEffX8qcQp+e4qcAw?=
	=?us-ascii?Q?cLDUc6ZiLsYNeBjxxn9gZuoCaLRhbM8tcB+sGb+F3/5TGUd2q34h13YvVfIR?=
	=?us-ascii?Q?mFbzww1kiMt4kYtP619iZWrxN61cjjvnf5eJmjRjJUAhknFSmdFSZghfv4nN?=
	=?us-ascii?Q?Nh8tRig/u0wBGdqDw6NW0hpMxdTI0aPxUjGd1Fzjk8KdiDBzw1wB1oWTdOdW?=
	=?us-ascii?Q?5QoymXHRsRqottz1LAfEj1bqLQ4rKTF+A0iZLAgvKLFOTWA6oGhxWYBBRlTl?=
	=?us-ascii?Q?S1hR/x9rX2464fWOjw85GhE/H8/9bSwvAn96DxbaZDfO+uRQ/2kjHNxS4OLG?=
	=?us-ascii?Q?jnTIcXdbj43Rw3nKlFdDljTUHINRmhJUh/5yWTYC51BKORAV3UDzLU0wg+8Q?=
	=?us-ascii?Q?UVysoJld9Rjhw0sNA0uvROVtP0EJN/EdCef49o37CvkhfWTc2p1NbRUMRSjB?=
	=?us-ascii?Q?RDCV0SKTbSQ3bigKGD3B9wVouZfAXwcPldL6VXN4GYp+JSkCXRYlRmmub5bf?=
	=?us-ascii?Q?46VvObEgIjvWfUV93OzqOnTJvzGSRvZqeVNtq+xdCCIsi8+uQJfK/+1uT4j3?=
	=?us-ascii?Q?w8Vgv4G0vFoppxrjOdclGUnYDgVcONfeq6Xu4BcIWaUeGt5rOxkjx5QDx7vJ?=
	=?us-ascii?Q?HAK71BnywH+40DJvxrAYaE40klq/ZriRMX62RH5465m7szhs2eFx28akDjT8?=
	=?us-ascii?Q?DCWfQJKgSkEj0pVwbMCP/VtAocPU3L5tWsrYraWZCAS/xJD8eRkVSl52D1BB?=
	=?us-ascii?Q?slBcB2cYui7HayYCicaLOW8kMX/sOpnjOEP398XqMbm0RaBqL9xNXfx9s+LN?=
	=?us-ascii?Q?EPzGZ74dw3eACDizqTMgy0x0QjEErlUxq3bB0xSNUikrj4gP7hyWr/LxgTtI?=
	=?us-ascii?Q?soND5s1uxdkkWCoBILN0KFSJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87750c7a-62d2-4af9-7bce-08d9911911c6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:51:50.9440 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/ypriX/ATAIn+9bdvbRDsWuRS9rBK0O+rHMXxZXH5WW0+QSxhlFYmySwH5NeyKvdSQZMEIdkTc6cHUDMazsQtp0X7jo2SzeiQhTTssOTog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5530
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	spamscore=0 adultscore=0
	malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001 definitions=main-2110170019
X-Proofpoint-GUID: u-f9w0o21UbNSEkBxlEUvTP3SOw8xORs
X-Proofpoint-ORIG-GUID: u-f9w0o21UbNSEkBxlEUvTP3SOw8xORs
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
	thehajime@gmail.com, tj@kernel.org,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Luis,

> We never checked for errors on add_disk() as this function returned
> void. Now that this is fixed, use the shiny new error handling.
>
> As with the error handling for device_add() we follow the same logic
> and just put the device so that cleanup is done via the
> scsi_disk_release().

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

