Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5FC1CCA473
	for <dm-devel@archiver.kernel.org>; Fri,  3 Jun 2022 07:18:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-_o-u4fdcOLyoPdJBqnRBOg-1; Fri, 03 Jun 2022 03:18:02 -0400
X-MC-Unique: _o-u4fdcOLyoPdJBqnRBOg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 243933C10155;
	Fri,  3 Jun 2022 07:18:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1097C1410DDB;
	Fri,  3 Jun 2022 07:18:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A17991947051;
	Fri,  3 Jun 2022 07:17:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 13D3A1947040
 for <dm-devel@listman.corp.redhat.com>; Fri,  3 Jun 2022 06:58:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D7202403371; Fri,  3 Jun 2022 06:58:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D20FA492C3B
 for <dm-devel@redhat.com>; Fri,  3 Jun 2022 06:58:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B676529ABA18
 for <dm-devel@redhat.com>; Fri,  3 Jun 2022 06:58:10 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-E404Wy-PMieQaQkFBjOZNw-1; Fri, 03 Jun 2022 02:58:08 -0400
X-MC-Unique: E404Wy-PMieQaQkFBjOZNw-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2535ehw4004306;
 Fri, 3 Jun 2022 06:56:02 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gf08e1990-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 03 Jun 2022 06:56:02 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 2536oJc3001837; Fri, 3 Jun 2022 06:56:01 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3gc8hyxp4e-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 03 Jun 2022 06:56:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2789.namprd10.prod.outlook.com (2603:10b6:a03:82::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.19; Fri, 3 Jun 2022 06:55:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 06:55:53 +0000
From: Mike Christie <michael.christie@oracle.com>
To: linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 hch@lst.de, axboe@kernel.dk, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org
Date: Fri,  3 Jun 2022 01:55:34 -0500
Message-Id: <20220603065536.5641-10-michael.christie@oracle.com>
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
References: <20220603065536.5641-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM5PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:3:c0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e8d97fd-1afa-4bb2-e6de-08da452e1a35
X-MS-TrafficTypeDiagnostic: BYAPR10MB2789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2789E4EBF2122B58EA9795CCF1A19@BYAPR10MB2789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: aqkmLGh9hWMHx2Z5REmDpEPFab6u+AQcFa46AeRivwJ+vu5al5rhQuyptNBx9wM/0wUk7K0hzimWDi1qFIMTd4gCBF7fDu6Sq4gajNDrj/LC9QILMmaapunZtiwjkvDiHNl0aN9ZwhIdRQ6MYKRuQOus0OTAyl/1y4JMb8tIW59hPtg6J/EnDSLInoCbJg5QTIte3oqL8WsOArvX1pWPE9dfrb/HOgddKQDRAQ9yU7zG1ueFbYx7J0+Ue6iLEoShFcrIwVoHx0TLUlbQ4QjI7P12NBmcqeSHIyHekb5TagtTDflW+0fyeyFQ7142TA8DlbmeIq0xpcKB3oSAPe56qZDpZ7Vsi8Y+OEqm9K3s7o6f5BwNN3EpS1o0P1a1TooLPgpsBVPAxbDwJukCfndnVGPMd9Z99E1Q/yp5NPGt4WKnqoI8fDo6d4alDbdZ5Od0bjAsbXJsC/mqrUNLabkQP9i7FuhUiyvi7cXQpeM0y0LfUS9/V0VpZ+KK7IdWR0LzBXqN04Z9jglBvJ0L+yA0DXeBJ2tRAC00ZeQ8DP3VmHCozxO4CNcctHGp+EIA0ZGDYi9Xk9PcBUbHJHvsakno06a8HMVBB3NhqbgljCEOqamjwMQxmWDWcjO4HW58Y+2EbJjVjgfNZkW+O1/foVMUGyi1eVnhDiBR7mjdoxaxLv8hu03LbHriDqDpLb02VTZ32WfmZP7Xy0d1AyavVOLvMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66946007)(8676002)(38350700002)(38100700002)(66476007)(4326008)(66556008)(86362001)(83380400001)(36756003)(8936002)(107886003)(6486002)(2616005)(316002)(5660300002)(1076003)(6512007)(26005)(2906002)(6506007)(52116002)(186003)(6666004)(508600001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r1NEaBwDYtDElM9m+5zo5xYYy6sOSDR0rI2L+9aFCHeQJQDeFWfBFK4NPiF5?=
 =?us-ascii?Q?bA/kc4yibS1dy4KIteKrkwluV6g5uTWgwSn7BySK0on7AuIV/S9cYXNRJns+?=
 =?us-ascii?Q?ChzKpzfQJdO13QD2eBRa+rEkjLMZMwzinS/ucTFSukPKNGVjKNlnPBRjG26n?=
 =?us-ascii?Q?6Y/yv8MNW6jzr3Sz1Kj/1V/RNtt7H185RvSNrA6wRVhJ3MeUp+YBPJrcykaV?=
 =?us-ascii?Q?QMhAJGFoVk5XW7nPdWvWQVIY0ltHoGcHOKVw9CoIJhGw/bro2Fe5L6d/egDn?=
 =?us-ascii?Q?OjIDAfrpX01PxjhQtAdpCBL1ROOStzcc9paJCRbYltt/WoS5iFKA+b9beQLj?=
 =?us-ascii?Q?MybwYo9V5vxy/d0OjX02/a4AV7wCyUJ9JdDJfFsL0l4REPcepyaafv0B8z0M?=
 =?us-ascii?Q?eUwS29+RDSBc5ofmpXB4YgUIay1VevMJSGmp9nRySdJ+I8IaA4Is3HKkFkmr?=
 =?us-ascii?Q?JVRYDICIbOst0VhjDUgyImtlefLlRHkFLZ0bfYTFnJIwbWayOlKZL9i8ytUK?=
 =?us-ascii?Q?trhiJCWzGWWf6T0eQATATslfy0zjCKfHqmguldqB43wdpoM5anDCA9IIAk43?=
 =?us-ascii?Q?AhaSHMD2IkcELGDAzqMa62lkslhNXYF+nP3H/8B6znqTuw6veokeHsSSQ7r1?=
 =?us-ascii?Q?p9HoMtxceLI3ktgMgyliqLOHrp2rut6sphLZa3lgKXoPYaU93HQ43FOIrr/2?=
 =?us-ascii?Q?ZgYXV9qPzWpgKUmND1YcrMtn5exp5gqQPUVo9H2JCaZlXGRjk0/znf9hQL/n?=
 =?us-ascii?Q?ok5HVhKzA3EAI84mmsWqmUVXj6N3kq6a41g0MRtBnYx3/Vt2Idn1eFp4jyg5?=
 =?us-ascii?Q?gvQtpXn0f42KPY0z8HE3pEAmI2v6t6hSfa3QW/IMu2mVksv0vuZ03p4xiB+J?=
 =?us-ascii?Q?CTpbDabpuiAQA9mqfimy3oESMhtvd6+kMWAphgsBeFfI9VG5mtY9yY6/KH5M?=
 =?us-ascii?Q?1gbpQ4xGe1aKfCmFSK9lAI+KntcaNO+j+XZ6fbPczffN9zEcV9ubsLhcesdC?=
 =?us-ascii?Q?JaPSdRkhhS2GLYh5nZfkrSnPQjhzW4Jv9qJWGVaNyGiKprGrJXMjQ/xmEIoo?=
 =?us-ascii?Q?QnEg2cUG5/OAqlqOKrHnkUuTjrfjUBZ7Fpw4ynUqYSMa5jUUdbBe7d3MbQUM?=
 =?us-ascii?Q?p5InANQQjH4/kEF/2Mpy/9PoqFMiu4YQnB/8wgolvHt1ICCTZ7lU6QVAjDWl?=
 =?us-ascii?Q?1deWU7xpeQVhVUi1e+dGZ4OQP6zfzDsvFUg9WjotLCI1LnDGzvkXC4086cvR?=
 =?us-ascii?Q?VvgoghrUZhts5dNoBDYEIWYyM+xMXCGKWZoUsyRkicd+Xrs4O2crqEB9pZaA?=
 =?us-ascii?Q?hQqHvty6fVNZWztZdY5CK49PZl0xV7RgxA6ZCQUpgr+v3Y3VUXRL/toiG5ag?=
 =?us-ascii?Q?zst9jpyE4j+Oh2+9HOGXIiD+38NFKMQ5NoZgxjRdutWcwEtN8WH8XxN5/GJ8?=
 =?us-ascii?Q?5GM55Yq+L/uE8hYQJD5mveMKevXUj9c1W/Vvm7VawULBabbMunpfbfeyv+Sw?=
 =?us-ascii?Q?2EoG+47fiIfWl9tyTiNKd6+naScA/JYF09LGWX+LjGomUALT5b4EOjKR7nkn?=
 =?us-ascii?Q?BVI/X1788SH+m6+DiLeyvZnnDnLOB4W0X/dul+fV1prbMsMsZh8PlUk8TAXL?=
 =?us-ascii?Q?1kPicpHMyT17If6x+7Hliua59X5DU21SZt+5qsu6NnkXVg7SZzTBcdoD6jHG?=
 =?us-ascii?Q?M7D+5YuvBBBZMt8hVgeua0pYKkXMFgGTedSnX+uZZxjWqtf1gc2pXF4NHlYc?=
 =?us-ascii?Q?7arcKGMWK2PEejulX7IYA+iEI2dSkkA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e8d97fd-1afa-4bb2-e6de-08da452e1a35
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 06:55:53.8461 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SKB7cKR+b8LCcmthW93AyPOVyXceKJKAE0Zq2nPCc5JXSFh5flKstyk586SRrRx0VMUIwAA1PQIKBgrAWnxY44t7zT8qhh8ZbTFH6JBKXbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.874
 definitions=2022-06-03_02:2022-06-02,
 2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206030029
X-Proofpoint-GUID: zePY__pdhFrPldtr_SkdHA9SM-9WUb88
X-Proofpoint-ORIG-GUID: zePY__pdhFrPldtr_SkdHA9SM-9WUb88
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Fri, 03 Jun 2022 07:17:56 +0000
Subject: [dm-devel] [PATCH 09/11] block,
 nvme: Add error for reservation conflicts.
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

BLK_STS_NEXUS is used for nvme/scsi reservation conflicts and also
general nexus failures. For the pr_ops use we want to know if an IO failed
for specifically a reservation conflict so we can report that error upwards
to a VM. This patch adds a new error code for this case and converts nvme.
The next patch converts scsi because it's a little more complicated.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 block/blk-core.c          | 1 +
 drivers/nvme/host/core.c  | 2 +-
 include/linux/blk_types.h | 4 ++++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bc0506772152..3908ac4a70b6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -171,6 +171,7 @@ static const struct {
 	/* zone device specific errors */
 	[BLK_STS_ZONE_OPEN_RESOURCE]	= { -ETOOMANYREFS, "open zones exceeded" },
 	[BLK_STS_ZONE_ACTIVE_RESOURCE]	= { -EOVERFLOW, "active zones exceeded" },
+	[BLK_STS_RSV_CONFLICT]	= { -EBADE,	"resevation conflict" },
 
 	/* everything else not covered above: */
 	[BLK_STS_IOERR]		= { -EIO,	"I/O" },
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e1846d04817f..9b77d8eb480c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -268,7 +268,7 @@ static blk_status_t nvme_error_status(u16 status)
 	case NVME_SC_INVALID_PI:
 		return BLK_STS_PROTECTION;
 	case NVME_SC_RESERVATION_CONFLICT:
-		return BLK_STS_NEXUS;
+		return BLK_STS_RSV_CONFLICT;
 	case NVME_SC_HOST_PATH_ERROR:
 		return BLK_STS_TRANSPORT;
 	case NVME_SC_ZONE_TOO_MANY_ACTIVE:
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 1973ef9bd40f..927d9d30e1df 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -162,6 +162,9 @@ typedef u16 blk_short_t;
  */
 #define BLK_STS_OFFLINE		((__force blk_status_t)17)
 
+/* NVMe/SCSI reservation conflict. */
+#define BLK_STS_RSV_CONFLICT	((__force blk_status_t)18)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
@@ -183,6 +186,7 @@ static inline bool blk_path_error(blk_status_t error)
 	case BLK_STS_NEXUS:
 	case BLK_STS_MEDIUM:
 	case BLK_STS_PROTECTION:
+	case BLK_STS_RSV_CONFLICT:
 		return false;
 	}
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

