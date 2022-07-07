Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD40DCCA479
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657225803;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tAIf43QboHn48esXCOIxkQdc3dFhfcYX5HROH9kwZTQ=;
	b=CYsl4uWvaj/cVPiunJd2DiW39REkaWJcZz5K8OpksIXkorajNRQ7U8+eShlzx0ZjlsIeXI
	7QkOqHWFhRBdsa+SYJKylLv2Ye9hn1jRJNNW1FFWeEcMhKcStDs46T9Xymcdj4EhZVMvJt
	EAR2DltJPjDyBHwHUteK5y8zflKYRFU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-KhZ0TNcjOs-xxmzTlJxMuw-1; Thu, 07 Jul 2022 16:30:01 -0400
X-MC-Unique: KhZ0TNcjOs-xxmzTlJxMuw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 378621C1BD2B;
	Thu,  7 Jul 2022 20:29:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2DC25154E081;
	Thu,  7 Jul 2022 20:29:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 68B911947073;
	Thu,  7 Jul 2022 20:29:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A424C194706D
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Jul 2022 20:27:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 94D818287E; Thu,  7 Jul 2022 20:27:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FB2B906B6
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 20:27:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E1B73804510
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 20:27:34 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-Bf8cWoHXPc6-kUAScWKGPg-1; Thu, 07 Jul 2022 16:27:32 -0400
X-MC-Unique: Bf8cWoHXPc6-kUAScWKGPg-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCTH2026377;
 Thu, 7 Jul 2022 20:27:26 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubypbac-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Jul 2022 20:27:25 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 267K9vNi017175; Thu, 7 Jul 2022 20:27:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3h4udfs6ue-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 07 Jul 2022 20:27:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR1001MB2261.namprd10.prod.outlook.com (2603:10b6:910:41::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Thu, 7 Jul
 2022 20:27:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5395.020; Thu, 7 Jul 2022
 20:27:18 +0000
From: Mike Christie <michael.christie@oracle.com>
To: dm-devel@redhat.com, snitzer@redhat.com, hch@infradead.org
Date: Thu,  7 Jul 2022 15:27:08 -0500
Message-Id: <20220707202711.10836-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM6PR02CA0167.namprd02.prod.outlook.com
 (2603:10b6:5:332::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efec6113-f5e8-477f-a016-08da60571641
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2261:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: JKnQIDhW9bn0vAcxude0NUL7oBW/baEoDd5VYSmkFkIiWBGzky1zpCQ+OSdM8MNY5jG4UA4Hy1QrysOe4DR9CgJP3QpSNnYBlbRcurDTv5brNBh/UDPLI0AVLwIWpibO0flsCFyDVlr449FiiiMrbBhsmJenXKqS6p2vQuONPDV7QpgxWCivIrIkUGHKcFJMZK+xkJJQCJAGz/r5YmjMOceZ08ljtxjrEpaHLve8b8Krf4iDYRWngL/5IBr+inV2mMIa2L2da9nnJhWSFgmgbrsly+o/TiPFdl9KCQGx8xEtpMI1h8r4mhgW0r6NaPtjt7Z040bpj//3nrV13EsRJNdei/x47wr/HgwoYbw1+XM/Z6TdcQQCaeNcmGdmHzuFDhy9+xZpo3mXd9avyLmMEH8zwqgSjq9c+3ih/ji7XVYjOgNIq+wLmOdfqK7ribeQ6DUUBVA5wj5eEwMzYexLEeVWYmg1vdellmATwplqqKlISgkAr6hcDn7IJXVqFHE+/Ycz/UhC6SQxofHhKQM1QKj9dDRV1lPyLbgMKTqr5ZTB7uArxAjG6gKv+JvkQfEowYZgRskB48fdJ69iJFDzvjysqrhCvC15wWrZbq0fIU21mRigwqOlJQFeHXmr8oRChiTnJxgCWHZdp8vMuncSfW3Q6SwYcDJp5Vr3iA8WP5CMd/sS1AYCS5WpT4Grzl4YPkdycjw6v/RCnI9BgWETd8P55LLP1KUZ7kLfQ5StnMlQTBDq6msFO1ziraNtEu1N2o3n2TiUjGvRnvinR4Xgyh3/uCpEX2vMSWnlp9AbnUlOQqHWAY8xyGyJsQIPu/k3
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(136003)(376002)(396003)(346002)(366004)(39860400002)(83380400001)(8936002)(1076003)(2616005)(2906002)(36756003)(86362001)(5660300002)(6512007)(8676002)(66476007)(66556008)(66946007)(38350700002)(6666004)(6506007)(52116002)(478600001)(26005)(316002)(41300700001)(186003)(6486002)(38100700002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VfOnu+HoFqZn72Y4m3iuN4/ZCQcgcBfw30htczhs8vZquz1PfLBzxFk7x0RU?=
 =?us-ascii?Q?0ROpvGQGSrTxyjNSQ78eWY0DqAt3agwvZO0JXNEjgk31BekPdvE4U/lNMyeq?=
 =?us-ascii?Q?24RDcL+xpi2tpWyfDj8BBYFeCWuwZDZ3dOephX6ZFCRMk0MbVzy1/qqpuLBu?=
 =?us-ascii?Q?4IewD60ioqmS0WbkVd6bKBUwq/7cIq/ifLDDtqsGx4xf/2tXs+BACe2aV7Qa?=
 =?us-ascii?Q?b4mRrsYMoRAwL6axnbUV7mD5EtLEAtufBaBa+t6yC76G4DFQMxoEJKBAPcxF?=
 =?us-ascii?Q?whILAIWdw6m+8GXXflGrHvVcXpquKR/TBg7PR90seJbPNxyVj04J7bScgHus?=
 =?us-ascii?Q?eJkm1ki0wRB8/vw3rGVy0Bf/ix73iMPoVVZek2BjHKtjx539Er4VzeTnOvy9?=
 =?us-ascii?Q?HLrzy1WGWrhIVlj+212yE6ga8cQd9ZGfVG9INWYXsIKNgZDkiJM6k9RPmVUQ?=
 =?us-ascii?Q?OKtxfSKYtzzCAWJw5KvmbJDS8BJFZy/FvV4v16JilIuOyPatJAtopoXAKoa6?=
 =?us-ascii?Q?e/X701MImKXEfNkJCofG5x8VGhQmEhLilnQ78nvrvg1N7FEZOGdnaLR+uKSY?=
 =?us-ascii?Q?a9tuD1e/ijgnZB1uMzg8DmO1IAg8/cZ3NjryuoGTNeaQmwHrMt+COBv4nxnj?=
 =?us-ascii?Q?Tk8azS43qDtGnL8N0KxaMZjFOOWi58VS0msBcGBGrsbq1Ec2V7xVhSgtvtwA?=
 =?us-ascii?Q?dG6fLn7nLipGYBZVOgP9+qu+NQ2uxJcFoYn1Dl6OId/W2jxvsesI7FeTUZol?=
 =?us-ascii?Q?5v8IWQuEd9bNonB1OxdcqvOqX/qT/GsgCIj3j8ols1ulm+qiyKZcOXIPYzke?=
 =?us-ascii?Q?3qCQ+hgfbBDfavozC3YTyCTIFQQ95+mDJ3QKwg9iqleI+5Aj4qH5UhvuXVPl?=
 =?us-ascii?Q?danmAGGB/NdLw4O2OKaVakFYzL+NFYn3CTxNAeGfbHJ4Foltw6mu0t26jZeg?=
 =?us-ascii?Q?7ujptEby7QxtSRzH4q8HTLO/dQkR2VpdyrUJph0zdQGdV5S2TT/BLdj5JGTC?=
 =?us-ascii?Q?9pz3z9Aswzhav/AChy6wRYHtO5AwWLHlwmwM4T/sIPVyXCosfwtX3FY7NX2T?=
 =?us-ascii?Q?sgvCMqAZcUIrdh3VeytQ9mIMsaiH2gmBPSxovY2E1Dk8/W1GmFShZQNf0Hu6?=
 =?us-ascii?Q?jKZ3eAY7CDnzbwtGvleFKNXGYE6ezAtk0TlOxb/9c4ioz2SBl0yFsZd6isWW?=
 =?us-ascii?Q?b+llw2xIY7o0RyRrYWlJsblc53YQQLnbbyHVgSFkuXTlmH8u2UnMrk1FxRNr?=
 =?us-ascii?Q?IpCCyD0/h5aTeZreyFXpT4tCdBFSLCEdYA+UNAjBK3D0WFzbz0OBmQblXwcp?=
 =?us-ascii?Q?h1bjnOlrSzHW2ROqU6hmnXPqvXozLV2RwOHQGFY89JFWyMPciZngD0+iZF97?=
 =?us-ascii?Q?FQMVqp++YqsfT5q3rJaX8ULibWHb2JCX1t/vwgi9MsBPjdcH3pjkKGz5RDdm?=
 =?us-ascii?Q?MHnq8PNWbxniXPFJCheki41vjOXO8aea8pQCTHagYzCckkt2eEFRYZuv2jVK?=
 =?us-ascii?Q?KCzRFWkstypUnoLt9MeFXdNX8Yr9XtOUPsfadeCVSmC3p1lQD3DLB1cLxUxm?=
 =?us-ascii?Q?RRIpu/e5cWSAyTBViDPgNcXiUdloCh+xYiNw0pzOs8uLc3SrMsnWIRxpSkET?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efec6113-f5e8-477f-a016-08da60571641
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 20:27:17.9729 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3VrJ515Y1Kmo8+o92eXy57mL1cmk7sIW0z5UqJDA28KnrdxYK3SaPDN35ZQmA8F8SZzTVZ8aE6lGX/+24w3JCtbHf35JMZhZVIwI0HPKCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2261
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.883
 definitions=2022-07-07_17:2022-06-28,
 2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 suspectscore=0 spamscore=0
 malwarescore=0 mlxlogscore=795 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070081
X-Proofpoint-GUID: _f243KnE4Ny0nzjGs54wUObLUD34p0FT
X-Proofpoint-ORIG-GUID: _f243KnE4Ny0nzjGs54wUObLUD34p0FT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Thu, 07 Jul 2022 20:29:55 +0000
Subject: [dm-devel] [PATCH 0/3] dm pr_ops fixes
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The following patches were made over Linus's tree and fix a couple bugs
in the pr_ops code when a reservation type other than one of the All
Registrants types is used.

The current dm pr_ops code works well for All Registrants because any
registered path is the reservation holder. Commands like reserve and
release can go down any path and the behavior is the same. The problems
these patches fix is when only one path is the holder as is the case
for the other reservation types which is used by Window Failover Cluster
and Linux Cluster (tools like pacemaker + scsi/multipath_fence agents).
For example for Registrants Only the path that got the RESERVE command is
the reservation holder. The RELEASE must be sent down that path to release
the reservation.

With our current design we send down non-registration PR commands down
whatever path we are currenly using, and then later PR commands end
up on different paths. To continue the current design where dm's pr_ops
are just passing through requests, and to avoid adding PR state to dm
these patches modify pr_reserve/release to work similar to pr_register
where we loop over all paths or at least loop over all paths until we
find the path we are looking for.



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

