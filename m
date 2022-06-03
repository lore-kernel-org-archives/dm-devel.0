Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA6B7C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  6 Jun 2022 06:47:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-ek8zC3C5Msq0dzJqJD4CEQ-1; Mon, 06 Jun 2022 02:46:22 -0400
X-MC-Unique: ek8zC3C5Msq0dzJqJD4CEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52C2C101A54E;
	Mon,  6 Jun 2022 06:46:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F99E2166B2A;
	Mon,  6 Jun 2022 06:46:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E662319451F0;
	Mon,  6 Jun 2022 06:46:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 66C851947040
 for <dm-devel@listman.corp.redhat.com>; Fri,  3 Jun 2022 08:29:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 42C2B1410F37; Fri,  3 Jun 2022 08:29:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DC411410F36
 for <dm-devel@redhat.com>; Fri,  3 Jun 2022 08:29:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5C00101AA46
 for <dm-devel@redhat.com>; Fri,  3 Jun 2022 08:29:46 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-5y5Lpo3rPuiZkqrBtY7oSg-1; Fri, 03 Jun 2022 04:29:45 -0400
X-MC-Unique: 5y5Lpo3rPuiZkqrBtY7oSg-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2533AiJV010186;
 Fri, 3 Jun 2022 06:55:52 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc4xv7sv-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 03 Jun 2022 06:55:52 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 2536oNhc025389; Fri, 3 Jun 2022 06:55:51 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3gc8p5nyqv-3
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 03 Jun 2022 06:55:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2789.namprd10.prod.outlook.com (2603:10b6:a03:82::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.19; Fri, 3 Jun 2022 06:55:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 06:55:49 +0000
From: Mike Christie <michael.christie@oracle.com>
To: linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 hch@lst.de, axboe@kernel.dk, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org
Date: Fri,  3 Jun 2022 01:55:29 -0500
Message-Id: <20220603065536.5641-5-michael.christie@oracle.com>
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
References: <20220603065536.5641-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM5PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:3:c0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3834d5f-bc5a-49ad-b456-08da452e176a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB27890E40C191E304E02CBE70F1A19@BYAPR10MB2789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: TTw0BtoMvlrTbC/la2h4ZsZYxenE1okmCjtLrorXweFslk+QJTA3vMutGuMSjS021tkaOhiWt9vwUWgFYGgeS2scUb9bczd9A+iSii4TbBdM/5SL4U5p++V+FjyB4R5AMypzF47HmtF4uHxCLf89a6/aw23naioyGKpIS7Jpc3zL/ibZB36Y+RsUlv1IX1eSFacmIgi72QtLhB1hKlVrgEYgar+/hCKK4Jr80cUipw8SHJMQmlPtr92YffdMesTXoMyk/apsDPYm0A9e6EVRsdRGMlUUHRL0ocAmxJ29k9Utm+8j93sWjAgm/9Y3C3CiRMQ7seJnAHb8bpn2iALCHyhDFe9k0M8SjaeEXukIFTFJQnhakhj3fC1yuC/88CN4KB+CV/mCWbkuPIEBQ/ytoQ4EQ8JVKjo/x9nCHYSGGskIBUdF8ytPL34WCEUwrypwToCgkNKzw5JKOZdeQtLhAYNweLdQv0R8UeMmH/H2UrLHl/yuEsFx7N8FQbNxgO0k/HNvIuczm/PxNaLuFDgelw4heZxlwrEgXq9neUJx2c9zdJv+9Lcn7DBL6A1lz9X27J9RSM90s6fXxLK0l6W1jcKXiyIrvB663dy6hZ+1Sf3RuJGsrjxzWFoDRg81ysJkGe7jOvux1RutObF2dnrOEDs3hozeq3X+yHvlEHsu/iowsxNZtB14A1e9AseE6IzX8/Fbt3xbKp0v4La+SPAPLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66946007)(8676002)(38350700002)(38100700002)(66476007)(4326008)(66556008)(86362001)(83380400001)(36756003)(8936002)(107886003)(6486002)(2616005)(316002)(5660300002)(1076003)(6512007)(26005)(2906002)(6506007)(52116002)(186003)(6666004)(508600001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q7B+2KzXDdKVaa7mfc2pF9DubtoSL1H2ql7Uv5IUza3lSjNOEA5xw5n/XXiN?=
 =?us-ascii?Q?5D7amh/5blIHTXIc+PIL+aP1BChN2cyvZunCOCuwna4dFJZlcu2yWOav6mNe?=
 =?us-ascii?Q?G3OUcWZv3M9Vj18fncf7qPunJ138rZMUBAmcQdjF+4N3F2edP52BwX/FH6m4?=
 =?us-ascii?Q?c/Ao4qcalgC51PksYRgFVd7qhjjkIB5ZOmYvdiKLVrJRQuTmRT2C1TdRfCso?=
 =?us-ascii?Q?0gGXYXsME2Z+QhXeeWE1pYa+FkDPLMnYdnCxDk08WOaUjdYJtzKP4kkEQB7U?=
 =?us-ascii?Q?2uXXMOiAoBIx7UIepsOOD3WmXAtL6XdgpUynMAhjmAaWzFFTjHZOmQzg8Ckl?=
 =?us-ascii?Q?ss65oHRl/MEkjLQHLMbYYKSW8Ee5kK3wfQHx1syaFn6Pswap7vPgKsvHcb5C?=
 =?us-ascii?Q?ryBcF+ACpxvtzpjT/7KIxg1Sj1S/wqcLQc2SXK+CFhu8TYvxvKkd05t296W+?=
 =?us-ascii?Q?PBS2Pss5m5Xdjd4/M5jLwxLoX0mTgdgX4q2UOahWFUIpFjcFk3JQ5+fn0Muf?=
 =?us-ascii?Q?T9AP0N8Epe6Utd60Rix4SWjeA0BM+wFL1U49dREl8mOpXmmLc8AscK8vAZeX?=
 =?us-ascii?Q?RJykHQqDyVQ5KrJ9OFyX+Rt985CGRIuagTZTqBHWV/hWs5az0s34kEu9CyS/?=
 =?us-ascii?Q?e7R8VkzMZOdIEswOWRP8oUtdN48Qoir4eDatX+L4zVHTfcJpoqlKe4lXs4zo?=
 =?us-ascii?Q?v5WO4JLGVBjLMWBeTk2HbAY+1Jo5HpT57zvw1CvL0sZTiWNteddIdipy2Lb7?=
 =?us-ascii?Q?QT0FC2OQBE0n+cgez/nqZJbytllei9NYyIl41vDnyQjlJNkqWG7ZCajSJXM+?=
 =?us-ascii?Q?YWQk6J8kA3Tw/iFDeeAKfGYyeBNmlvkcVcPZ4EKaUtJJUcNet4BxTRPK7ghA?=
 =?us-ascii?Q?5qFWRV4b9TRJULIfoQYxO6wy64GR6qbvRjx1pvZzWRrVNUqz1s7xjtGHCfnG?=
 =?us-ascii?Q?IpHAo5Swjf5Ox8LOpKoAjAYIjHi4DTPRFOHrQ3aeFueRIk7vdieGBWvddDe0?=
 =?us-ascii?Q?xCnRBMIHC4sKJ83FJHfM7j1Kc0woCt4/ex1w4syDgah8p9h+DVgYwK4SU/IK?=
 =?us-ascii?Q?1D9l5OMX75vEHmKKKKw7Kq95xzJys0mX9e1wruAT5meZ1m+mjqVQkNr9h894?=
 =?us-ascii?Q?px2A20u6qE5QdpqPxqcLeS+K2ZBEGB3ZOZ9/kipNKvtzHNn4t1GANzXZpvN4?=
 =?us-ascii?Q?qJ4YqvWlx7aFrbzCZNMOcc9k2tZVjPoLp7zwfN+L3SVjgyIDF7Zucw3j/NW2?=
 =?us-ascii?Q?AGwpNHDCoc8gbzv6eGUFFJm7Q06oVZg5qGVsoG/q9l8Kwqi0Bpp9W2OqIcYx?=
 =?us-ascii?Q?jEQrs+oAPlF72xnuSK6tMQQS7Y1pW0qH38yHgkV69I2OVO0OMi1nFVNlF12a?=
 =?us-ascii?Q?ewAKvaeC6fwIIAU9pgCGbK08STiLE541OEXBQBjku7byrFl4sWx1+XGdpLhn?=
 =?us-ascii?Q?wF0Ie3JjOpaOxn0dqVaZAyv1HFGaxLfg7QZSJdXLUiH76HLBMX99BU1vD0S1?=
 =?us-ascii?Q?A3r9+8InjFihqzlIBAbBF4EjVyfeXpoonEWvlRhxOR3Eze5cDaQm3eArHhfp?=
 =?us-ascii?Q?DpXc8e2cyxVcrASfuErcZiDbKF+qGeAwkr3CGHyRhDDSIDor3es3cHyKmVHX?=
 =?us-ascii?Q?Pi03xo2cdD3v8f5itos95hXM2qTqPp+6lSR5S96Ua9I+WpUBh703eOoZQys2?=
 =?us-ascii?Q?SKwGIKUB0kEGMgyWlQTaS+qXzb+ysQ4vSXbV+sIHmRk8/IPRoIznZcsQt9c+?=
 =?us-ascii?Q?2op0p2fmkoVerBcNQ408RK3RxIsJ8ks=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3834d5f-bc5a-49ad-b456-08da452e176a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 06:55:49.1746 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zv8EKqhi/AIaEwusXmn78d7CFPIPxuQA+PDKCFggltSppARlwUai73pDUzFKsTcZc05UQGyRSUvuzwEsMoAsBRoRHqLtm4mnx5z8nn5yads=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.874
 definitions=2022-06-03_02:2022-06-02,
 2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030029
X-Proofpoint-GUID: 55Clha1AkpeCod82uKrc2wirAmUI9ZKb
X-Proofpoint-ORIG-GUID: 55Clha1AkpeCod82uKrc2wirAmUI9ZKb
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Mon, 06 Jun 2022 06:46:17 +0000
Subject: [dm-devel] [PATCH 04/11] block: Add PR callouts for read keys and
 reservation
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add callouts for reading keys and reservations.

Note: This only initially adds the struct definitions in the kernel as I'm
not sure if we wanted to export the interface to userspace yet. We may
want to refine internally for LIO and when we can enable it for NVMe then
add the finished interface to userspace.

The latter is not done, because NVMe's report reservation command is
similar to SCSI's read full status where they return a remote and local
ID as well as the key/reservation info. However, a lot of SCSI devices
don't do remote/local ID parts correctly. It seems that read full status
might not be used very often so does not get a lot of testing.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/linux/pr.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/pr.h b/include/linux/pr.h
index 94ceec713afe..21a8eb8b34b5 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -4,6 +4,18 @@
 
 #include <uapi/linux/pr.h>
 
+struct pr_keys {
+	u32	generation;
+	u32	num_keys;
+	u64	keys[];
+};
+
+struct pr_held_reservation {
+	u64	key;
+	u32	type;
+	u32	generation;
+};
+
 struct pr_ops {
 	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
 			u32 flags);
@@ -14,6 +26,10 @@ struct pr_ops {
 	int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
 			enum pr_type type, bool abort);
 	int (*pr_clear)(struct block_device *bdev, u64 key);
+	int (*pr_read_keys)(struct block_device *bdev,
+			    struct pr_keys *keys_info, int keys_info_len);
+	int (*pr_read_reservation)(struct block_device *bdev,
+				   struct pr_held_reservation *rsv);
 };
 
 #endif /* LINUX_PR_H */
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

