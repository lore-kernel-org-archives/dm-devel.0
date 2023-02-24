Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A48C64ED8
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481426;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iif0Xw9jBk/6t99lS3uleURBGeFXVlvXSr8gzPjS4rI=;
	b=VpS39ZdQYTKhs4c30Kp1FuyNmEoQg+/fTlxtFmrmezI3XABQ3ON5i0kP3sQVPEKtzjqBCK
	QNHlNbMpaLbdEODscASTxwJwqe6/Qb5lgvwgvD5uuokwGUpz4CoAh7/+rr/JaZPoZKCwDQ
	hNqQnB3OZy6lo9L/nP4hLx0eLBOnztA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-InkFWSCFMNCIRq5fPaNDbA-1; Mon, 27 Feb 2023 02:03:42 -0500
X-MC-Unique: InkFWSCFMNCIRq5fPaNDbA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 699B43C16EAC;
	Mon, 27 Feb 2023 07:03:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5716D1121319;
	Mon, 27 Feb 2023 07:03:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 30805194658D;
	Mon, 27 Feb 2023 07:03:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D839519465B2
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 17:47:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 97EF02026D3F; Fri, 24 Feb 2023 17:47:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FBBB2026D38
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D5183C025B2
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:31 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-bnC1VnDAPkW0rJZjb-FULQ-1; Fri, 24 Feb 2023 12:47:29 -0500
X-MC-Unique: bnC1VnDAPkW0rJZjb-FULQ-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHho7S007318; Fri, 24 Feb 2023 17:45:15 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn3dwpyq-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:15 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OH1Ks4026136; Fri, 24 Feb 2023 17:45:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3ntn49sdsv-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:11 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:48 -0600
Message-Id: <20230224174502.321490-5-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM5PR07CA0074.namprd07.prod.outlook.com
 (2603:10b6:4:ad::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 97f5b941-f128-4982-7267-08db168ee088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: De00KV3Jx9lCi3jxloEOX+DsmdvZO0VN5nzU5zfos12WXcQp9Z2M+erd6sBWfX7nuoH3vNKy2QRJuWKBK2ZfbwaGCRfd8NK6Hv6+8ug0GJPR/fKjeLuBCSRvLm6udvawVnXq2I2VFJeIUrh3CWgqVo/lOi0lY5dqZKBtg/rTMUmkQJ/Huqv1vbSM1rVj/TbyDWRpZXGZfmHfngfR6HqXj2aPlIClXTRRPlgBgD2U5KnbA8qsIKFJxjmgTMsZTtzMMrmpHXW7TMGsN5CXycIe/yxoFzDuRVblQD/GmcU8jLM+DBYdYL9hterPFLMUSkbNFRlP+Iehh9L7zSzx7py5uKguqMgPsC/TlXzJDrK0n12WnuEJlF0x3fTc+4+0z4TPSrLfJR7PHUiRKnwG3YMxjsP9iS0IwoW0odkyL6KT2aNl2pyLliWH7+UbIsKGRjzZNUvuVi5l/KysC1DOV8NcMi2HvBLa4bKZUdj3qMB0Vvkfk9WkbxPVOUYk0TbUyDQPnIb8AeJMaL4w+KkqdEgwPVqNdLMnwOweHj7jFHIS4kVTD9Rft/wn4wBrLDCgw27T5u4JXs0E5VVjmLA1/4rRUWExwpt+Hzk3AQOYibhlu9vzKWcs443Ji4/xHvdoigbgL2gWlT4Gd5u5aT7qYmBma7rEGh0wJ+Xu5RkDTEwhL3tDwTnxBdecWLlw0N7rT/m8
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/+NSSRf4lLbC2ZTdn3a9LbYgEOy4qxBnNdJgDko/lG5l8AeIHpVwd9POScmO?=
 =?us-ascii?Q?GkfFTQbVdVYY/ffNnSUpIASZzq/jCwxFoiTgURYLSHH2TPybjsIl/vuYAuEa?=
 =?us-ascii?Q?WX2pEdPAYbvkqiELGsRwHEw362twHfBw8F6G8aD8F565k8zrr40PJmDNQg9c?=
 =?us-ascii?Q?hTzSRoY4wVSXAYe8B7Q4WtHyaxsxS6P/PTOp1FcF/NGr5zHMKZyYTYwnO4Zm?=
 =?us-ascii?Q?OtD23cBpXDWK2oXdUoD95PAHfJ8wBb3xOj1jTftksRpZ4u3xkyeRN/V6tuNH?=
 =?us-ascii?Q?uK2N1M8Yci7n4DQFQGQs4aLnEEp0C6gmFS7/Djoe8A1KyBXqT2tw6tdcx1az?=
 =?us-ascii?Q?is5VPMMBkwp3WiE9S15y6Q1uSovJeDu4mHp1GNLy/R8GJlNqmQ1g1dHYqkSa?=
 =?us-ascii?Q?NgsRp0YLowbUOgjthKQ2+z7LNlMUWTnlIFuGjLUxgCLaKyGtpPWDRFqnIhML?=
 =?us-ascii?Q?jwhasvhs2uVrpOHzMbpIB/SvD56WIeY0s13TVn/B83P7qZfO6vZMqVRTkQuR?=
 =?us-ascii?Q?SDtOG8kbIHv2rrm6Ee0+4WchUmecoQEd3NlIcM4ehVlbCFO80igBMl6oBnYT?=
 =?us-ascii?Q?RXrBw3g+SUaPbJYYr/Iv4LS56iyfmv3dujHvBtixzSrDcB1W9MCF59NPYKCH?=
 =?us-ascii?Q?9Fxzq2moqjIMWUdxBPhbQ9FPpFJEKO8CY99q0umdFvnICGnPXW7+PpAWLaz4?=
 =?us-ascii?Q?98RLcjxNGzOU0GveLEiVvRLayC53/9+6XOgoLbpqdsVKaepNyIpck4WJ+fqP?=
 =?us-ascii?Q?AEw5nuP6pQl0iyn38MbBp69fvsWtGXXF7C5J2z4zIFiGUxT6NKeqNEvpJf4P?=
 =?us-ascii?Q?mv9Scd2fKiHYGWJ960zANdbX9MIaTCTkstUjKmiJoAB47VWHjrO74Zx1mn9P?=
 =?us-ascii?Q?390plT8ExWuW3DHCFgiMhnnVU/YRnMg7XdR5q88NCFG32aKLKORiT1raUz0z?=
 =?us-ascii?Q?+8Pb+HeYqyflfGoVKiKybeekb8ReGvv7eBP9Af0ZlSb++9aaYfzavq03NEwe?=
 =?us-ascii?Q?J9Bb4WPvs5jCwufoNq60xXgwlE0JzNdHLWUhj6f2cNYT7nWfZgCSgaL18pzO?=
 =?us-ascii?Q?13pkhfbxI+PfFZFEzEJIr5m1z6l0RhMhoiIlPlFjC1BN8nSy+7171nrUF1l2?=
 =?us-ascii?Q?x4gcWWBKj+7oMIhVGNguHJ1hnRQFQ82RNe0q7jiUOjR6n6kWR+3+l9N66NJu?=
 =?us-ascii?Q?oofzts/soAAPQNUXDutehfqpwnx8c+px3E/hb7PC7wxAj1UoAWomC2c8dqfS?=
 =?us-ascii?Q?vlEW0T6WxgqmPSMuGwtEuS1jF9ks4WZQA0fhZ3yYszXjXS/7IeIz9DIrgFIa?=
 =?us-ascii?Q?q6JisEYRBEAUeH6Je5M/AyhvoYS6JvRmPwzyQGbOz+wBGOgb+zSBXZjZaU89?=
 =?us-ascii?Q?CYkySyT1wHzfMORakMdTOaXM1/TMsd1Tf34NemMOB45d3E19FHe81wh3eYEX?=
 =?us-ascii?Q?BVUFHmxpwjEtbVeQZNvX5n5w5ENUNNObDhhP7Di8oHbu8k4k0eY5FhDzyz8P?=
 =?us-ascii?Q?jhH5pquprwwIoIdsnWL526FsCbYDn5wVoXuO/dexiMBE8hpgRgnKXP2hX+Jb?=
 =?us-ascii?Q?j1erXRfPjTXH6tMzOg7wFLkh6zYJreJvihqwUTAUFLIVMpn8RvhY63SByqZD?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?MUE2nx/SCjHro3UfZ+be8cggYyHggHM3BPalDG7rQMhvNx252STd1bvsvY79?=
 =?us-ascii?Q?gguRJspOFldxx/hqHbI1rabNcweQWvun3qNuCn+LutlddHcgX2uqrSOZq6GW?=
 =?us-ascii?Q?VmL69CT//TZiZJludypJsYdFtxf2oTxc+qWo/ONyAvgP5S39aGTjE9IK3xTa?=
 =?us-ascii?Q?+fwVGQwKAKt003PcmdGvBiDFEPPw1l3c5gnV3va+O+6qYuPuf6jnnF/xjYdf?=
 =?us-ascii?Q?CLUJcDhrsT0e7P2E3owDhO1Q5OfEZzNym0x+qQh6nAAoMTIlOpA7E1Jt+Amx?=
 =?us-ascii?Q?ll48JoqZjpLHGbklayjbr0KS3lfGFM2ZYZ2Ghd4e1j3M8bbqDjbTFPYGbcwD?=
 =?us-ascii?Q?c1S1nL822Zeyb/oRF3TlHNgm7Aq4CESgSKn4F7/KW55V/yHC/hsVVfAYge1y?=
 =?us-ascii?Q?KzF8QGErAWShyUKwKG/YAg97M1N8q5RiFEUbleV0/5KCU6JNemymmbG9tFKH?=
 =?us-ascii?Q?staXta4JAEBw0wUdfsiz4822iyvPzBIPEt/Qo0alxR4woLQvGwCidLNGgOrO?=
 =?us-ascii?Q?lAWCFx2y5fMs+j7xhh/CxiBEpaQ0lZ0iO2GFM2h/oH9i4tjpgC3HKpG1oV3i?=
 =?us-ascii?Q?NkuZwxxMjZ/dsm43sgbmg2xZaeUIxmEwqwoGKM4KiS4g1XUiOoLJPLCK6n9W?=
 =?us-ascii?Q?2bxngx4EbeQSt1qRAZ4+Rj7nAAGaguKs8mkLNeWROz9nCnBluFEob6hj8uKr?=
 =?us-ascii?Q?WrmiJMuDbxNm2hH3IlFqQ/ivOY7/ibnmvSlcdPgMSzrMoJ3gFxgzS2zwfpst?=
 =?us-ascii?Q?6u+FjbnWeIjmf7mCH+ppuhitpdA1pGhWHyOCSYOoxIsvSeBMZNvFmMOG4QYR?=
 =?us-ascii?Q?vmd9PpjNXEs61iTXao+tfVOnadF2WfMb87i90UCfqQd2wq1DSyy68Ivi1/AC?=
 =?us-ascii?Q?gN7e2eCzMPmYGB9SLjtLtIN5Nb++B1J6w2aA/t2ImVYcCc5G3RhFlv4xnCjo?=
 =?us-ascii?Q?+C+l3nraeAP2T7gvbvY5jeOYxfk14gPv6tSwuL4UUDwQYJb+Q99YVTMDQ1c+?=
 =?us-ascii?Q?LdIVyBjUcEw2J2t6mw3E+apT2Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97f5b941-f128-4982-7267-08db168ee088
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:11.2512 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hw152L5SF/DcxzPZPmWqRpVcXyWVfXIFsblqHy6CLNazdfuzdarqhRhME4Ma39czfO7dreDIDS8YBSLN9VenEWpb+TrH5N/PkkDpzQkhQaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240139
X-Proofpoint-GUID: Revfi4bH7flKqRkDYZt3j4rXl-vxaEjb
X-Proofpoint-ORIG-GUID: Revfi4bH7flKqRkDYZt3j4rXl-vxaEjb
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 04/18] scsi: Move sd_pr_type to header to share
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

LIO is going to want to do the same block to/from SCSI pr types as sd.c
so this moves the sd_pr_type helper to a new file. The next patch will
then also add a helper to go from the SCSI value to the block one for use
with PERSISTENT_RESERVE_IN commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c            | 33 ++++++++-------------------------
 include/scsi/scsi_block_pr.h | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 25 deletions(-)
 create mode 100644 include/scsi/scsi_block_pr.h

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 79377173f6a3..a801ef393c38 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -67,6 +67,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_block_pr.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -1693,26 +1694,6 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 	return ret;
 }
 
-static char sd_pr_type(enum pr_type type)
-{
-	switch (type) {
-	case PR_WRITE_EXCLUSIVE:
-		return 0x01;
-	case PR_EXCLUSIVE_ACCESS:
-		return 0x03;
-	case PR_WRITE_EXCLUSIVE_REG_ONLY:
-		return 0x05;
-	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
-		return 0x06;
-	case PR_WRITE_EXCLUSIVE_ALL_REGS:
-		return 0x07;
-	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
-		return 0x08;
-	default:
-		return 0;
-	}
-};
-
 static int sd_scsi_to_pr_err(struct scsi_sense_hdr *sshdr, int result)
 {
 	switch (host_byte(result)) {
@@ -1743,8 +1724,8 @@ static int sd_scsi_to_pr_err(struct scsi_sense_hdr *sshdr, int result)
 	}
 }
 
-static int sd_pr_out_command(struct block_device *bdev, u8 sa,
-		u64 key, u64 sa_key, u8 type, u8 flags)
+static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
+			     u64 sa_key, enum scsi_pr_type type, u8 flags)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
@@ -1796,19 +1777,21 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 {
 	if (flags)
 		return -EOPNOTSUPP;
-	return sd_pr_out_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x01, key, 0,
+				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	return sd_pr_out_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x02, key, 0,
+				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 		enum pr_type type, bool abort)
 {
 	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
-			     sd_pr_type(type), 0);
+				 block_pr_type_to_scsi(type), 0);
 }
 
 static int sd_pr_clear(struct block_device *bdev, u64 key)
diff --git a/include/scsi/scsi_block_pr.h b/include/scsi/scsi_block_pr.h
new file mode 100644
index 000000000000..44766d7a81d8
--- /dev/null
+++ b/include/scsi/scsi_block_pr.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_BLOCK_PR_H
+#define _SCSI_BLOCK_PR_H
+
+#include <uapi/linux/pr.h>
+
+enum scsi_pr_type {
+	SCSI_PR_WRITE_EXCLUSIVE			= 0x01,
+	SCSI_PR_EXCLUSIVE_ACCESS		= 0x03,
+	SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY	= 0x05,
+	SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY	= 0x06,
+	SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS	= 0x07,
+	SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS	= 0x08,
+};
+
+static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
+{
+	switch (type) {
+	case PR_WRITE_EXCLUSIVE:
+		return SCSI_PR_WRITE_EXCLUSIVE;
+	case PR_EXCLUSIVE_ACCESS:
+		return SCSI_PR_EXCLUSIVE_ACCESS;
+	case PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	}
+
+	return 0;
+}
+
+#endif
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

