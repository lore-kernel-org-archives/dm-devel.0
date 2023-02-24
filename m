Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA94C7EE32
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481421;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cCpi1BVF6SNmdKSHLaMBDcR/Ee92KYV6f/52DgtxsMY=;
	b=bFJh/TjHErDiajVQsp/IcPOFVZ/on+2dPCUZqaL+Nt7Zmu1EnIdLExKmKofa70vELi4Te9
	o+eFGEI3iYoJCGkBqrScULTVYrX0Wz+fHF+INYT2hYt+yEtRWVPVvN55R91ySBaxuYjVRh
	4HxSdDjx0jYKN+f7cxWQaGbynyWc1ag=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-MNNhoQw6P2a2YjmDEh-mjg-1; Mon, 27 Feb 2023 02:03:37 -0500
X-MC-Unique: MNNhoQw6P2a2YjmDEh-mjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EEED38149A1;
	Mon, 27 Feb 2023 07:03:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A20D2026D4B;
	Mon, 27 Feb 2023 07:03:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7D32A1946A4F;
	Mon, 27 Feb 2023 07:03:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B145419465B1
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 17:47:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 896A2492B08; Fri, 24 Feb 2023 17:47:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 80FE4492B07
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CAB78588E7
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:52 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-z1OCcGcGMM66yOIuhvy0Ig-1; Fri, 24 Feb 2023 12:47:50 -0500
X-MC-Unique: z1OCcGcGMM66yOIuhvy0Ig-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHho7T007318; Fri, 24 Feb 2023 17:45:23 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn3dwpyx-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:22 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OHJGXX031548; Fri, 24 Feb 2023 17:45:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3ntn49wjuh-4
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:20 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:54 -0600
Message-Id: <20230224174502.321490-11-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DS7PR03CA0326.namprd03.prod.outlook.com
 (2603:10b6:8:2b::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 211feb96-6bf0-416d-16b9-08db168ee5dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: VRy4eALglemKT+6kf/0fpJ9ZJKX2ucgSW258QMBa2C2xXjrl5QEBh6OMqGC3SSpsKolwD/O+25GsrP+M/LHRbz0J6QQA71vX2oAUh4XcsrAdlUMlGr3Rk9FjWsTgLmzosws5U1YmRIIndG4tazQuUcURKy2yAvZON0NAqBMPQ717e/yVxQ/5jfGh+GkzBt1yY/XOHm7PdZYu5VjLMtUbidAUYwqkRJuK6x7FAVdypvXondUwcLvuYeCWMzSosv4aBjHTX4N5rmhoczNtcf3QYNqXGEevMHieeMb+W08Ecms4HPWSwEoyI+P2KEG7hz3k1xbPyWKrvMKT9ktv+fFi8nC0tySlqyAlyc9IOZCS5J2eyrjCxqWQWrNpYuXtwABuFUrsPOOXLcLu9PVXR8KgxWCxP3cmEQqeeXPh3vg8Yoz2zMKpwJnZ8drQylkRXiiL8gLvnYt0A/X2+lHPHhqvtUU+JoXyUixMEEc1c3kW7lZeHSA5BdRyy6xRzkfx1afwhNKcKYtfBsgVLsEKVXEQrY7J2u0r6/54HBC8rqqr0lffGEHM8mt1g0r0jYchUYqLT7j6H/NeYJ11lzuZMhmjbBlQJguyANAjd7/xI+sS3Qb8OL5ynVIiuAl7Z72BbE225f53JC8xlEawl7BxOa6tkhlBdu1kLhAHSPOTGHjYIcYOZ43dvFq4yjGnq8ERhNM3
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4K+Y95CKTM2MAsg/ZEU1jxOeC7miBfY5a2FkEtr44nYHt5capRu0qVs5i1s4?=
 =?us-ascii?Q?IdEqPuKj4r0IJlhO3fvFj/n0RjL/ioYgZaHKxDPTE6DDik0AlpZA9oozA/q1?=
 =?us-ascii?Q?ryTtdlNAD5KYnjXI82kAWrsOU5UYfxl7upUo0Zay9ubmkQz06+fwfDRglP1f?=
 =?us-ascii?Q?/gojRB8JpMeG6LqZWmoZSRnHDVDx1YcqjnSWnzvYHFwYXuubmRd5ekDSWc47?=
 =?us-ascii?Q?GB8HHzdOrWtRDyOBVisJWzJzHiLBs9g8pM5Fy7fq7FvWPTHJdpfvz1Z+iL1V?=
 =?us-ascii?Q?pgjUvGnc+EMrNV+s9tg9ybECxjJuENyc4SjeopWb4BpABGZHiihD2jimDIqz?=
 =?us-ascii?Q?UOEk7Ge1h0yZSgEdtVJr/biE0GrkXTSYr9sgEyOVVctYBDYdVsil4xu7F2TH?=
 =?us-ascii?Q?U+dx6mAV31+/ttz1w4BpuIBwbkBH5yOtNMNJwG6QfC1di7NpamQyEEHkubv2?=
 =?us-ascii?Q?uR9i9HKdBC1OQGGG0n1MGzptNP2PeL8Z+/NTrIUnTUzhCcTsNmZYydtUNQKi?=
 =?us-ascii?Q?sma72KKRPetXYlh7cKgO7kajuewAF8BGUG+QdxyfFBilN4U2lWlBz1ax1Fkw?=
 =?us-ascii?Q?myCJC1Y9UpMNlkOTLFbQdQ1xqI8n3DyojxdsHS8ZlIqDo13ESwNFPY6LxHkR?=
 =?us-ascii?Q?hTkiRQJfkeV4g188oRaPEW6g4dzFXJfxHyOlo7n37MxlDZU7imkZAIMgQcWp?=
 =?us-ascii?Q?Z45UA4uffCsoJlnoVe8bsI55ujojHpMJTdWcYElTXuTUwcsNIgI69re9ytYy?=
 =?us-ascii?Q?PUbT96AFFt/St2VW4CHqVAa4Z9QElzwcAOoGZhU/8XXFvF+AU6ITXL2b+gMW?=
 =?us-ascii?Q?XnoNGZTr5xwwB0UV7yF7XtdpGDSOnWSFAkkr9NtvUaMoLUrWzFtcuTJDVQDE?=
 =?us-ascii?Q?ajeaptqH54W3QI1zG3K7fTrPuU5XHRxzdPQ2F/3Q4uIirLAbX/IUYFObLFqV?=
 =?us-ascii?Q?ErYsSh2V2Jworzr6ZjtbldAdKbpNUZz7DSyJaFCeuPmgQ3dVy8MjholOsml8?=
 =?us-ascii?Q?tsKoOUOxOOUVQICnyK9X7MhpyQJsBs/dz75Gc/rI7o3axyO1/zKVu258vIB2?=
 =?us-ascii?Q?mCuYACyRQOMXpvkKrifvqaJ0/wvy5LO35BhhKvuIBwHfzjSfFOwpDG12pphn?=
 =?us-ascii?Q?JVgVibDVIl4MHpK5OCo78woy8szeJvHDoUz3OfQnSkflPYQNxC84GXxwKEsN?=
 =?us-ascii?Q?H2aZ36PhRW4jHsRUKzLholqAJcE9WQxpIV/63LkMvRQisTLIldM4BqYpznXo?=
 =?us-ascii?Q?Q8oiefQFuJpkRBCfxAaOJUkRZhc5J1t9ChnsB72oEll8+7KvTT+mNZnApbH9?=
 =?us-ascii?Q?riPVTtXBN/9qxpQ8KhkyGo44/dj+NK/Nq4SCON4tQM865TwNTarqXis6/cnK?=
 =?us-ascii?Q?0RSy0NtvL0HdvPt58rXTNQzMZP2EkmE0bNPrNgAqJfrvgE9u77ntVNRkN1Ac?=
 =?us-ascii?Q?+MW4VzCvx8eCMv73HTi7sgMzb7kZ3vbIxtSdJ+jPCcmxNfV339rCE335a94Q?=
 =?us-ascii?Q?dL8TfRKFOyrSsnBFMV+JKI9of8RexkMrIKjGaEIi1+njCkj+8salHwTJ0V6h?=
 =?us-ascii?Q?QdofyGXrqhe2eTHMQnPeYndlN+Lb+C3pp2mRNCB9bUrWdGGB2Uq7A52vAjfS?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?05bckQf/lFxZbuU7GTt4XIZgcQhexaLhQcGGaZtHHHMOV87GBFXjvnUIGvtw?=
 =?us-ascii?Q?rlG6fvk5vWj+r/vf8SISgghtxX9d5pEOHtZbHEsOJGk89VzXPaskq+aPpxPw?=
 =?us-ascii?Q?8SVi+LMypmANYYqg6IY7o1GJLsB5s48V4v6YUJWl7v+AwzwL88fTbDufila1?=
 =?us-ascii?Q?N6pGr+Wzq+qw8z3CETdXyyJWodOa2kfJtv8G2chZtj+ciguWDJlyrj0kuLuI?=
 =?us-ascii?Q?m26uIwBysZqzVNJ7MKaER868oqXbU9UaUqmbHYOB5X9X1BL3o11s/CUsf8NW?=
 =?us-ascii?Q?JUYcbDW07Ax7qyG5/OOwQ6bwMJC796eoO91krR9d/rGBXY34eSjvrH58yBWR?=
 =?us-ascii?Q?0ts/bootqCvxKlz/H51d12SUlTr1RFajUGTRk2n/CBhs9/CQiVwibzBbM5/F?=
 =?us-ascii?Q?SXiKBYimqaAwK1YBKGLYDDdBjTgyUn1dkmbfCzz+HCY86Vngf80t4/eTv3tn?=
 =?us-ascii?Q?Ltjc7mqd+lP687B8cHpTD14P/TibtrH1IeMrsvl7U7jeqJPO+ZSqBgo0IJdo?=
 =?us-ascii?Q?2I0pDnmV5REByyG0NZi//mhVMxfC82FyDPinp9Ej1tD9pvXtYC2MzrC7DFc9?=
 =?us-ascii?Q?IpWNOUEuA+UAh6xBi6ZlLTQKkCywuil4cZh0L8Pfd6jMWmBneFVX/Wn/YptR?=
 =?us-ascii?Q?galCVeSRm5mWo5Nu04cxiUYzKWceGhJkX1hNH5e2D7Nr5TcBSx6DrfJ2Wk8p?=
 =?us-ascii?Q?vBADoI6FjxkaulhI4BUVw9XvJhbhohaDKMktBb5gtAeX8Fwa5amtZIaKCOq7?=
 =?us-ascii?Q?EiWlLaF9Dm0EhQWYD0lZyCAH4YO6S+2B2WwI9BR6SjGoMW/f8n/TynoF3vFC?=
 =?us-ascii?Q?/wDbSfP/GsYPBxggbDzzN5Xx2DAOUP5YQF/nPyaQg3BuXebUm5loYMdItwMw?=
 =?us-ascii?Q?cY+DQ+7rxLW/fTvuLzuDQuyyDWoWK9Nli75x5NXO/s8cnfgBpKX2KL30T8jA?=
 =?us-ascii?Q?uN9Q0eC/As1qPdD15h1ycKqCV61iATbNVukEQMZVkhWUN0FFwO3vnJ7ePNSX?=
 =?us-ascii?Q?hsIkTMiHsH9b0Fas/HrQ97Z65A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 211feb96-6bf0-416d-16b9-08db168ee5dc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:20.2036 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PZExdwekgjO2sO7eALSWdlhC91w1Usnzm8+VuiomCZLb3f5Lw6l0dKuej7tclLTCx6iw/izvlOpqmNMbaYezTe+zHqQHrNOYZ9yi9Au9frw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240139
X-Proofpoint-GUID: Irxz52Esgb89BfOIaa9Bftvy9oduZNAF
X-Proofpoint-ORIG-GUID: Irxz52Esgb89BfOIaa9Bftvy9oduZNAF
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 10/18] nvme: Add helper to send pr command
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
Cc: Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Move the code that checks for multipath support and sends the pr command
to a new helper so it can be used by the reservation report support added
in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/pr.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 26ad25f7280b..7a1d93da4970 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -27,7 +27,7 @@ static char nvme_pr_type(enum pr_type type)
 }
 
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, u8 *data, unsigned int data_len)
+		struct nvme_command *c, void *data, unsigned int data_len)
 {
 	struct nvme_ns_head *head = bdev->bd_disk->private_data;
 	int srcu_idx = srcu_read_lock(&head->srcu);
@@ -43,7 +43,7 @@ static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 }
 
 static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
-		u8 *data, unsigned int data_len)
+		void *data, unsigned int data_len)
 {
 	c->common.nsid = cpu_to_le32(ns->head->ns_id);
 	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
@@ -71,6 +71,17 @@ static int nvme_sc_to_pr_err(int nvme_sc)
 	}
 }
 
+static int nvme_send_pr_command(struct block_device *bdev,
+		struct nvme_command *c, void *data, unsigned int data_len)
+{
+	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
+	    bdev->bd_disk->fops == &nvme_ns_head_ops)
+		return nvme_send_ns_head_pr_command(bdev, c, data, data_len);
+	else
+		return nvme_send_ns_pr_command(bdev->bd_disk->private_data, c,
+					       data, data_len);
+}
+
 static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 				u64 key, u64 sa_key, u8 op)
 {
@@ -84,13 +95,7 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 	c.common.opcode = op;
 	c.common.cdw10 = cpu_to_le32(cdw10);
 
-	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
-	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		ret = nvme_send_ns_head_pr_command(bdev, &c, data,
-						   sizeof(data));
-	else
-		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
-					      data, sizeof(data));
+	ret = nvme_send_pr_command(bdev, &c, data, sizeof(data));
 	if (ret < 0)
 		return ret;
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

