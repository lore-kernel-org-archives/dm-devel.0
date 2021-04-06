Return-Path: <SRS0=HU+X=JD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA119C433B4
	for <dm-devel@archiver.kernel.org>; Tue,  6 Apr 2021 05:40:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0F7C3613AD
	for <dm-devel@archiver.kernel.org>; Tue,  6 Apr 2021 05:40:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F7C3613AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-B_TWn0R-OFO6nO7509oysQ-1; Tue, 06 Apr 2021 01:40:48 -0400
X-MC-Unique: B_TWn0R-OFO6nO7509oysQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DC26108BD08;
	Tue,  6 Apr 2021 05:40:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC5A76787D;
	Tue,  6 Apr 2021 05:40:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6B6ED1809C83;
	Tue,  6 Apr 2021 05:40:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1365ZNxx026723 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 6 Apr 2021 01:35:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 732711002972; Tue,  6 Apr 2021 05:35:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D47E1111450
	for <dm-devel@redhat.com>; Tue,  6 Apr 2021 05:35:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8640285A5AA
	for <dm-devel@redhat.com>; Tue,  6 Apr 2021 05:35:20 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-113-nFhMR8oaO2OY20-j8GLfNQ-1; Tue, 06 Apr 2021 01:35:16 -0400
X-MC-Unique: nFhMR8oaO2OY20-j8GLfNQ-1
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1364eaU0061403; Tue, 6 Apr 2021 04:47:23 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 37qfuxbbmx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Apr 2021 04:47:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1364f0um037740; Tue, 6 Apr 2021 04:47:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
	by userp3020.oracle.com with ESMTP id 37q2ptrd9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Apr 2021 04:47:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
	by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28;
	Tue, 6 Apr 2021 04:47:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::dc39:c9fa:7365:8c8e]) by
	PH0PR10MB4759.namprd10.prod.outlook.com
	([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.032;
	Tue, 6 Apr 2021 04:47:20 +0000
To: Martin Wilck <martin.wilck@suse.com>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
Date: Tue, 06 Apr 2021 00:47:17 -0400
In-Reply-To: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com> (Martin
	Wilck's message of "Mon, 29 Mar 2021 09:58:49 +0000")
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0701CA0020.namprd07.prod.outlook.com
	(2603:10b6:803:28::30) To PH0PR10MB4759.namprd10.prod.outlook.com
	(2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by
	SN4PR0701CA0020.namprd07.prod.outlook.com
	(2603:10b6:803:28::30) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.3999.27 via Frontend Transport;
	Tue, 6 Apr 2021 04:47:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d128db98-ce30-4e0b-1703-08d8f8b71026
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45027DC13CC0C854932048AF8E769@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: jGOmVYGwuo04DnuiIHZpZgLOouiZ3Wvuk2XY248Y1IqaboxzoBXaTFS4adBIJOrhXtAvK1m04tWuDFg5uAQbEcINNsdnazRS+W5KKDMKtsxVNl0WNQn51QezF8a7n2DdYEK9Sp7Y7Ofqfa58zbFOEFF8xR/fj9usv9c1nrq1gJ46bO7gPRr7VqjLDieIpP3dYLawff4YS5WRq6UjHt4oMWXjP4oPslsvq0+jaFV7XmmYV9yK1t2+vqc4DbUrg27zFWGiDLu2IFq7o5qBF5JttDqFb95tjQuuNzaocTRSlJOxuxH4kISTYLaPBNQ06qgLvbRc9OhZWaXglACgsT2rVtEQBQBoW+nxJ5gzDqEiLjrwndrqF/lI1/3GCWiMAbIKHwL28TgFkq1k7t0TydswJDQx0eEMjk8XIWVWxNNcD9FFaORDYuKV5fRN3WRqPyEezk2gqWNckz+F2SD1DwOXt3+SGfIfHKzlhNOApSfDD8byrlPkVULWRUIcA+OITUj7eJUL5luVHDpnw3y/MDzsrBSOcOwPyelEoHCGiPCgYwRPoHGMKU990DHWbMfci/q0wBSHdRu6MUHoKs47uMXNZIh2B2uPQmWuH0mDN8F4xRvaDHtFsnbU9l4XfV8jkpC4VYhtY2KSTCxnt58yCpFdmicmfWWPW8krSxDLMnkdhw+kVbhyOqHnS3J+4QagbnBe
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR10MB4759.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(136003)(376002)(39860400002)(346002)(396003)(38350700001)(186003)(8936002)(26005)(16526019)(478600001)(66476007)(66946007)(6666004)(83380400001)(86362001)(66556008)(956004)(7696005)(52116002)(2906002)(54906003)(36916002)(316002)(38100700001)(6916009)(8676002)(5660300002)(55016002)(4326008);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4NvH6nrB4aEZIGV+V4p6ZIQ3e9IAJMknmWpWckJRoJlUdcxXJ2oQcj3v9sGY?=
	=?us-ascii?Q?rMgIL+T1d9ZB54Pr5AzdWDRMBYvbhe/l1Lwqp4BrtwHdJbb/3aKxe0Bl1bk6?=
	=?us-ascii?Q?uqb3/kclycRp0iVYBzVHilFMw/L0q01lWJJPjBF+rT0/E/a6UoKPcNArIS/L?=
	=?us-ascii?Q?WwRYRMd1++/V0cEk+nIV3HpOtxHsLVL+LoK7yI6hEZKPbybd5kPxDXJS4lrh?=
	=?us-ascii?Q?+A4Ib6m0DGZmDbAmXvfCsqzXvJ+M+27amoQ4BvGjno3j/VfiqcM8D40AnCKl?=
	=?us-ascii?Q?aiOflhk0K7DnGziRKLkxVjaMwxfvl9QzVhWUxX3Dzve7q9ojfjfTdf1c92lw?=
	=?us-ascii?Q?QqYXbJXG2DMiINt5M6iuzYjNHWSAFSJJu0iN0eTsMNn8SABUdnwzgJd4jUQM?=
	=?us-ascii?Q?b3LxDmfJPksaopntqYx3YUw0eTxL6Q7QmMqPyB8Vr5sTUziQnvV0aNONg1Mh?=
	=?us-ascii?Q?7o4Q3i20KJQXDZTtJTIv5dKzDkq94JXn7rBHFfm29wQZ0Kj3GFOalrae4iPw?=
	=?us-ascii?Q?su0j8PNT/+Gv/WKaV7t0A4OcQu1Qy1ImcMo7YkwfXi/f/+JwkCW1CjFFsV91?=
	=?us-ascii?Q?3ryit4odJfchJKVAB3TBPdj0Z79iBWxO9N5c/kMsGfJZT5bSgNDNN5cAKERg?=
	=?us-ascii?Q?rxCocQu4hV0Oj/w8Ng8ocUu8VqhY4UNA0tEEBiG8rjl1SkKMTocwIS27SMuI?=
	=?us-ascii?Q?cEcdhb8m7vzZsgNP3cM5cKdiur01+ybYwfBJHaQ/nPB8Hxq8ulcEFzdxP5LX?=
	=?us-ascii?Q?+2uYXh9C9HUq8aTQwWshYUQML1/ayettpn6pzQj6SiGE/mHReIJj5ukr4SBd?=
	=?us-ascii?Q?3PdGiRl3TSgvcZiFvUp3FmGRJ/Gnl98zBlaZ9VIIlk6jhU9Vmy36NlJ5uTyf?=
	=?us-ascii?Q?ABcUn7xrS/yytNSmfP6P0/JApFdXsZobwRDOnlrHTziCkSxOTnd3ode4jw51?=
	=?us-ascii?Q?+VfuZoqXzbJMZrcSJls43fTwWCxnZn+Jo+jMq/qngZi1q9h+rOAWOzTmT5KM?=
	=?us-ascii?Q?amT26pC10Suc9CZi4s0FJJRrRVp+3LhxBOxQxTxkrHo05JekU9+uluAx/eRj?=
	=?us-ascii?Q?fW7HDD30WuxNiaY4NEOXwsIXK8YnsuxTWJFnCiYUY23F5EIk+zJ1MxeDT53/?=
	=?us-ascii?Q?ZLmgHO602GZRM1dQ/MplTIJV18vN4fEK9idhYcidg6OM+0mL3E3RaPbn8SPF?=
	=?us-ascii?Q?qBQOitu9wA6qpja7yzhE8Dq95PN0RiHjhvoNewLApdq36zl3l5qeyBNL3mV7?=
	=?us-ascii?Q?drCuUoNmC5J24+cTKtp1uBTcd1T4YrVVIVdhJqVQq7tsVLPOHGxD0ooWAMYY?=
	=?us-ascii?Q?FlPQSNiCDxP8CCkq7hMeahjX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d128db98-ce30-4e0b-1703-08d8f8b71026
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 04:47:20.7994 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fz3cvtuLsz9OwBtStBgo1trFn952jijuz/HysbS0SPiOS00ghgwXYl7v2lLnGZI2xnh86SIZnAAUtrPGBE2Nm92UshQVo+a/vw2mkMH/vDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	suspectscore=0
	malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
	mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104030000 definitions=main-2104060029
X-Proofpoint-GUID: bJ8vv5zmdageLP5oEEXj_ofLUj3-YnUM
X-Proofpoint-ORIG-GUID: bJ8vv5zmdageLP5oEEXj_ofLUj3-YnUM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011
	malwarescore=0
	suspectscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
	mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
	lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104030000 definitions=main-2104060029
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
Cc: Hannes Reinecke <hare@suse.com>,
	"jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"dgilbert@interlog.com" <dgilbert@interlog.com>,
	"systemd-devel@lists.freedesktop.org"
	<systemd-devel@lists.freedesktop.org>, "hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] RFC: one more time: SCSI device identification
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


Martin,

> The kernel's preference for type 8 designators (see below) is in
> contrast with the established user space algorithms, which determine
> SCSI WWIDs on productive systems in practice. User space can try to
> adapt to the kernel logic, but it will necessarily be a slow and
> painful path if we want to avoid breaking user setups.

I was concerned when you changed the kernel prioritization a while back
and I still don't think that we should tweak that code any further.

If the kernel picks one ID over another, that should be for the kernel's
use. Letting the kernel decide which ID is best for userland is not a
good approach.

So while I originally liked the idea of exposing a transport and
protocol agnostic wwid for each block device, I think that all the
descriptors and ID formats available in both SCSI and NVMe have shown
that that approach is fraught with peril.

Descriptors that provide "good uniqueness" on one device may be a
completely sub-optimal choice for another (zero-padded values, full of
spaces, vendors getting things wrong in general).

So I think my inclination would be to leave the current wwid as-is to
avoid the risk of breaking things. And then export all ID descriptors
reported in sysfs. Even though vpd83 is already exported in its
entirety, I don't have any particular concerns about the individual
values being exported separately. That makes many userland things so
much easier. And I think the kernel is in a good position to disseminate
information reported by the hardware.

This puts the prioritization entirely in the distro/udev/scripting
domain. Taking the kernel out of the picture will make migration
easier. And it allows a user to pick their descriptor of choice should a
device report something completely unusable in type 8.

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

