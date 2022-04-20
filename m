Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0406C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 20 Apr 2022 02:05:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-ifExpfy5Mq-h8vp7ZH2-2A-1; Tue, 19 Apr 2022 22:05:45 -0400
X-MC-Unique: ifExpfy5Mq-h8vp7ZH2-2A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F5BE3C02B8A;
	Wed, 20 Apr 2022 02:05:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5B62A40CF8F0;
	Wed, 20 Apr 2022 02:05:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EF73B1947BBF;
	Wed, 20 Apr 2022 02:05:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 878F419452D2
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Apr 2022 02:05:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 704C446A391; Wed, 20 Apr 2022 02:05:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AD59550876
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 02:05:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BC59185A7A4
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 02:05:41 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-T-diziiTNZ24bsDjYbxB6A-1; Tue, 19 Apr 2022 22:05:39 -0400
X-MC-Unique: T-diziiTNZ24bsDjYbxB6A-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JLCeP8009092; 
 Wed, 20 Apr 2022 02:05:13 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ffmk2qn05-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 20 Apr 2022 02:05:13 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23K20YCE038232; Wed, 20 Apr 2022 02:05:12 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3ffm88mv8s-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 20 Apr 2022 02:05:12 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by SJ0PR10MB4557.namprd10.prod.outlook.com (2603:10b6:a03:2d4::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 02:05:10 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5164.025; Wed, 20 Apr 2022
 02:05:10 +0000
From: Jane Chu <jane.chu@oracle.com>
To: dan.j.williams@intel.com, bp@alien8.de, hch@infradead.org,
 dave.hansen@intel.com, peterz@infradead.org, luto@kernel.org,
 david@fromorbit.com, djwong@kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org
Date: Tue, 19 Apr 2022 20:04:32 -0600
Message-Id: <20220420020435.90326-5-jane.chu@oracle.com>
In-Reply-To: <20220420020435.90326-1-jane.chu@oracle.com>
References: <20220420020435.90326-1-jane.chu@oracle.com>
X-ClientProxiedBy: SN1PR12CA0112.namprd12.prod.outlook.com
 (2603:10b6:802:21::47) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54b08d3e-43cb-4513-61f1-08da227232e5
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4557:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45576341A8BC0C5BE6EAB01EF3F59@SJ0PR10MB4557.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Dg+I+T1FWyAButV9+ARd1gWI9EUORIkfR67SRr8UnXegRviwsk5Bsa8CVeBp9udZoX7gU+h2fz9KzcbebZsvxj+8Yu9A31us9vsqg3vYU5J5D5d3KAS8Y/MnCOBU7gE/Nu7SR6SvlIah0oGpvg/TQf4kBvMaIuHhv8uctcb4fKNVmXtfZ1GgbORRrpph5ZsAi7oFDOFOsGd/gXTFMvDRcHzo2UMcR7uHbXXo7dQ6s3dpF7DHBqPvtMwycCY00xwSqlRyTVqt6ffreoWURkPqojFRMQSL+rf8qgM5Mj+7QVDZ7Nv9gp1/nGQb/8i0hOEPRNxJHMEozG/zy3j9ACJylHnYcx1zOj5wigDYQ7RsUAbxD8oDKB2vXM4u6jgeZhjsSneqMoeiNKaShF+lLgFvcBCgEvVUt84FQdubUo84KeVLIrnkqr/KF3zcysClFwQ+zXrf0phjtdX+vBCN1FIAGPsYUYRenDJL76BGDHcb+wQYWNaVX57FZfXC0e1ILXbCsgyT42P7MKqqlwxlk539JgG52ssqZr8KljSUCmLV96i3Iw0owlEzWi9tazaOwNmqHQ3dho9QB6Km85PlBosSmeVCTVWarkfH+H/cba2jQ8Bq2GFNmVuhm0Db90HSVpQpi+pv7xc1+X5WoBLgBKJs3kHv3DrYY9sGhEqqCXGHmM+dlIM0loQhMb0Be+mUo9F/
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66476007)(5660300002)(83380400001)(86362001)(4326008)(66556008)(316002)(2906002)(508600001)(1076003)(36756003)(66946007)(186003)(30864003)(44832011)(6486002)(6512007)(8676002)(2616005)(921005)(7416002)(6666004)(52116002)(38100700002)(6506007)(8936002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2m7zhvMNrT7eP8wEiNNxpTw7Wferh8jMqhmJcl7lWluxZPjlJeigSw9n9QqC?=
 =?us-ascii?Q?kcfcCcgB0ndR7HxqNvcWDZqRFw52qdRNWDlmEj496B1FmgXylf+HUFeJQ3c3?=
 =?us-ascii?Q?i9WUCt97Cz57PxkPSqg9svqUHsokEqY82H2liLw+Ctrv/FwYDOM/4GitnIIg?=
 =?us-ascii?Q?GjZa0lElf7e7y5ZDC9BRlY66/ZB3nsvEMQIcF9Q4zqgftMjq26fu8ZHyaxow?=
 =?us-ascii?Q?V+gtVS9/K91JAmjl4BMMIzck1pyaE7lnuI6SU17bxDA1XkQjo3mW5PMjqblA?=
 =?us-ascii?Q?GBFF23tIJUgy/8LS/B7yF7kwcZukSCIeXGJ7O9gXTGUddqu5FcAlpW5S+nPz?=
 =?us-ascii?Q?4T4R8p8BxXyYfF0F+jgpI4bvLpYE984Xkq9CczuC20bw6LSOFuZzqglqc6zW?=
 =?us-ascii?Q?tpr5ciEhSYv9GG1dx/RNsBqmebpJ3v5wC4s4qLdI/jbD7ucfDcJL8pWQ4KOF?=
 =?us-ascii?Q?nsoqmT4enA3UUGuOAcFs3hA7hcB7q2fl2p7dqLF1+8JGOBZnvScbJalP6tyG?=
 =?us-ascii?Q?xTx0QSxiQ0jllTSR5eWc93PvOEUKexw6E8UMexq5PxibgG1rG6rLxSq3bZMF?=
 =?us-ascii?Q?hL+koRDyOwRorSMlkCHtFkOMjGaggovIyTF1132zbp3lOICJ+yIJkLIqcaOR?=
 =?us-ascii?Q?Zp3JXN+s6NGGxvZsWo4dJzr4HjMd9cgrMFnCBJMQBGfhwnZ5LyHyHfZguE7Q?=
 =?us-ascii?Q?tAUQmczdzYKY4zYyn2QV2v3bbD+opY8xYFt9BAs28/SG6MyKbZjIjR56aPti?=
 =?us-ascii?Q?y9rXPKbbtfqmnnepKbFU/oqxZ81zCFQKdGFz+iLZW0UNg1GEZJf3N//fud2G?=
 =?us-ascii?Q?D63vEAANlMCjcJYhHBxtt/iewM1zx/2FtWpnx1Qf39fwSM3GoYnA39hv4HdZ?=
 =?us-ascii?Q?LIN1QWJ23pwrTi/RKC4xcIvUX2JpzQom5yCG0GhGhrwZ/hMkWUsIP2vpmakE?=
 =?us-ascii?Q?vTOH31PitakOdoU0SOvqWJUXWgtWzKQi7bEA/v1JQLBhjA6fR5mGsikD4UH/?=
 =?us-ascii?Q?SeRo2PoZsKuYcuJyeeg3RP6/AtyxlgJNvluj3HacHVKlZdrdHRuswb5QV8W4?=
 =?us-ascii?Q?aKLqM+rQ4QXEXozY+cLM8p0ggFAb4QESR6H6ngiTFbRj3A9aAmMjtb95bMoU?=
 =?us-ascii?Q?/WuW5pmsIbi5iz03/c/9X+BQnVghcAvmTl19Qdm99+JQmjon36HlbuHP7Rd/?=
 =?us-ascii?Q?oTY6xULMy8DJKR0jjzuYbp3yVHm0V8n9p7fJzvVNbjPeG2BnK0c9lr+k6QXS?=
 =?us-ascii?Q?zLpee/rhpi3grH23sV871NrSUwS+W6ogxupGL/JXcRv3n/++ug0fcGMUes6R?=
 =?us-ascii?Q?tNSeHIdqM/y9LZ1YkH2zqJvhp9cGdjG2YQKZ3F+25BHCbT1Xgeaxb9X4+b//?=
 =?us-ascii?Q?e37Zop5yd5MszjWMWEEJXuu3DrbSV2cOkKRI14zhRrupTp0IClu4K0j+JzPz?=
 =?us-ascii?Q?BXhZeVrN/yXU7gfKzQZvFftAmwAaIoebwGFm7Cr9Au3nH4B6upZXKFvqXk72?=
 =?us-ascii?Q?maVTfJb7KnhkWgym2FrMsHFAyuEFn8tDF0DaadtegnrVtqZQrQY8aUU+uDBX?=
 =?us-ascii?Q?fBBtJMxYoBZVZ15eVz0kclHutmCVW+NF4E9oPUyp7nsUk1XtUp8ozqsqongF?=
 =?us-ascii?Q?0WNbILnXQ0EJvcqg1cXLA+EaKO3iWYtBFk+jc5Gz0jI3HKAb1WbVPbXiZdPy?=
 =?us-ascii?Q?XDhtqrELmY0wMXJzUTwoINUD8gTrh3VFLNZgV3S+4nzEtrbcvX/c3pl1X1iV?=
 =?us-ascii?Q?3LUik5QZe/FCzkXfll+5JMH/xvexR4c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b08d3e-43cb-4513-61f1-08da227232e5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 02:05:10.3418 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5f1Mp9Q0X9eZBkehQM2afmzz0JAPC99KpgsynhtU2tU/RbI4a1lkcHL4VxqqoKVSUxUFcTrBjlvgHKGS3kF+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4557
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-19_08:2022-04-15,
 2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200008
X-Proofpoint-GUID: fgI-42kzrRmCNNgqRKGsacU-6nQp35Si
X-Proofpoint-ORIG-GUID: fgI-42kzrRmCNNgqRKGsacU-6nQp35Si
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v8 4/7] dax: introduce DAX_RECOVERY_WRITE dax
 access mode
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
Cc: dave.jiang@intel.com, snitzer@redhat.com, vishal.l.verma@intel.com,
 willy@infradead.org, dm-devel@redhat.com, vgoyal@redhat.com,
 ira.weiny@intel.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Up till now, dax_direct_access() is used implicitly for normal
access, but for the purpose of recovery write, dax range with
poison is requested.  To make the interface clear, introduce
	enum dax_access_mode {
		DAX_ACCESS,
		DAX_RECOVERY_WRITE,
	}
where DAX_ACCESS is used for normal dax access, and
DAX_RECOVERY_WRITE is used for dax recovery write.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 drivers/dax/super.c             |  5 ++--
 drivers/md/dm-linear.c          |  5 ++--
 drivers/md/dm-log-writes.c      |  5 ++--
 drivers/md/dm-stripe.c          |  5 ++--
 drivers/md/dm-target.c          |  4 ++-
 drivers/md/dm-writecache.c      |  7 +++---
 drivers/md/dm.c                 |  5 ++--
 drivers/nvdimm/pmem.c           | 44 +++++++++++++++++++++++++--------
 drivers/nvdimm/pmem.h           |  5 +++-
 drivers/s390/block/dcssblk.c    |  9 ++++---
 fs/dax.c                        |  9 ++++---
 fs/fuse/dax.c                   |  4 +--
 include/linux/dax.h             |  9 +++++--
 include/linux/device-mapper.h   |  4 ++-
 tools/testing/nvdimm/pmem-dax.c |  3 ++-
 15 files changed, 85 insertions(+), 38 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 0211e6f7b47a..5405eb553430 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -117,6 +117,7 @@ enum dax_device_flags {
  * @dax_dev: a dax_device instance representing the logical memory range
  * @pgoff: offset in pages from the start of the device to translate
  * @nr_pages: number of consecutive pages caller can handle relative to @pfn
+ * @mode: indicator on normal access or recovery write
  * @kaddr: output parameter that returns a virtual address mapping of pfn
  * @pfn: output parameter that returns an absolute pfn translation of @pgoff
  *
@@ -124,7 +125,7 @@ enum dax_device_flags {
  * pages accessible at the device relative @pgoff.
  */
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
-		void **kaddr, pfn_t *pfn)
+		enum dax_access_mode mode, void **kaddr, pfn_t *pfn)
 {
 	long avail;
 
@@ -138,7 +139,7 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 		return -EINVAL;
 
 	avail = dax_dev->ops->direct_access(dax_dev, pgoff, nr_pages,
-			kaddr, pfn);
+			mode, kaddr, pfn);
 	if (!avail)
 		return -ERANGE;
 	return min(avail, nr_pages);
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 76b486e4d2be..13e263299c9c 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -172,11 +172,12 @@ static struct dax_device *linear_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
 }
 
 static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
+		long nr_pages, enum dax_access_mode mode, void **kaddr,
+		pfn_t *pfn)
 {
 	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
 
-	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
+	return dax_direct_access(dax_dev, pgoff, nr_pages, mode, kaddr, pfn);
 }
 
 static int linear_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index c9d036d6bb2e..06bdbed65eb1 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -889,11 +889,12 @@ static struct dax_device *log_writes_dax_pgoff(struct dm_target *ti,
 }
 
 static long log_writes_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
-					 long nr_pages, void **kaddr, pfn_t *pfn)
+		long nr_pages, enum dax_access_mode mode, void **kaddr,
+		pfn_t *pfn)
 {
 	struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
 
-	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
+	return dax_direct_access(dax_dev, pgoff, nr_pages, mode, kaddr, pfn);
 }
 
 static int log_writes_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index c81d331d1afe..77d72900e997 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -315,11 +315,12 @@ static struct dax_device *stripe_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
 }
 
 static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
+		long nr_pages, enum dax_access_mode mode, void **kaddr,
+		pfn_t *pfn)
 {
 	struct dax_device *dax_dev = stripe_dax_pgoff(ti, &pgoff);
 
-	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
+	return dax_direct_access(dax_dev, pgoff, nr_pages, mode, kaddr, pfn);
 }
 
 static int stripe_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 64dd0b34fcf4..8cd5184e62f0 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/kmod.h>
 #include <linux/bio.h>
+#include <linux/dax.h>
 
 #define DM_MSG_PREFIX "target"
 
@@ -142,7 +143,8 @@ static void io_err_release_clone_rq(struct request *clone,
 }
 
 static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
+		long nr_pages, enum dax_access_mode mode, void **kaddr,
+		pfn_t *pfn)
 {
 	return -EIO;
 }
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 5630b470ba42..d74c5a7a0ab4 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -286,7 +286,8 @@ static int persistent_memory_claim(struct dm_writecache *wc)
 
 	id = dax_read_lock();
 
-	da = dax_direct_access(wc->ssd_dev->dax_dev, offset, p, &wc->memory_map, &pfn);
+	da = dax_direct_access(wc->ssd_dev->dax_dev, offset, p, DAX_ACCESS,
+			&wc->memory_map, &pfn);
 	if (da < 0) {
 		wc->memory_map = NULL;
 		r = da;
@@ -308,8 +309,8 @@ static int persistent_memory_claim(struct dm_writecache *wc)
 		i = 0;
 		do {
 			long daa;
-			daa = dax_direct_access(wc->ssd_dev->dax_dev, offset + i, p - i,
-						NULL, &pfn);
+			daa = dax_direct_access(wc->ssd_dev->dax_dev, offset + i,
+					p - i, DAX_ACCESS, NULL, &pfn);
 			if (daa <= 0) {
 				r = daa ? daa : -EINVAL;
 				goto err3;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3c5fad7c4ee6..8258676a352f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1093,7 +1093,8 @@ static struct dm_target *dm_dax_get_live_target(struct mapped_device *md,
 }
 
 static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
-				 long nr_pages, void **kaddr, pfn_t *pfn)
+		long nr_pages, enum dax_access_mode mode, void **kaddr,
+		pfn_t *pfn)
 {
 	struct mapped_device *md = dax_get_private(dax_dev);
 	sector_t sector = pgoff * PAGE_SECTORS;
@@ -1111,7 +1112,7 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	if (len < 1)
 		goto out;
 	nr_pages = min(len, nr_pages);
-	ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
+	ret = ti->type->direct_access(ti, pgoff, nr_pages, mode, kaddr, pfn);
 
  out:
 	dm_put_live_table(md, srcu_idx);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 4aa17132a557..c77b7cf19639 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -239,24 +239,47 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 
 /* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
 __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
+		long nr_pages, enum dax_access_mode mode, void **kaddr,
+		pfn_t *pfn)
 {
 	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
-
-	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
-					PFN_PHYS(nr_pages))))
-		return -EIO;
+	sector_t sector = PFN_PHYS(pgoff) >> SECTOR_SHIFT;
+	unsigned int num = PFN_PHYS(nr_pages) >> SECTOR_SHIFT;
+	struct badblocks *bb = &pmem->bb;
+	sector_t first_bad;
+	int num_bad;
 
 	if (kaddr)
 		*kaddr = pmem->virt_addr + offset;
 	if (pfn)
 		*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
+	if (bb->count &&
+		badblocks_check(bb, sector, num, &first_bad, &num_bad)) {
+		long actual_nr;
+
+		if (mode != DAX_RECOVERY_WRITE)
+			return -EIO;
+
+		/*
+		 * Set the recovery stride is set to kernel page size because
+		 * the underlying driver and firmware clear poison functions
+		 * don't appear to handle large chunk(such as 2MiB) reliably.
+		 */
+		actual_nr = PHYS_PFN(
+			PAGE_ALIGN((first_bad - sector) << SECTOR_SHIFT));
+		dev_dbg(pmem->bb.dev, "start sector(%llu), nr_pages(%ld), first_bad(%llu), actual_nr(%ld)\n",
+				sector, nr_pages, first_bad, actual_nr);
+		if (actual_nr)
+			return actual_nr;
+		return 1;
+	}
+
 	/*
-	 * If badblocks are present, limit known good range to the
-	 * requested range.
+	 * If badblocks are present but not in the range, limit known good range
+	 * to the requested range.
 	 */
-	if (unlikely(pmem->bb.count))
+	if (bb->count)
 		return nr_pages;
 	return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
 }
@@ -278,11 +301,12 @@ static int pmem_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
 }
 
 static long pmem_dax_direct_access(struct dax_device *dax_dev,
-		pgoff_t pgoff, long nr_pages, void **kaddr, pfn_t *pfn)
+		pgoff_t pgoff, long nr_pages, enum dax_access_mode mode,
+		void **kaddr, pfn_t *pfn)
 {
 	struct pmem_device *pmem = dax_get_private(dax_dev);
 
-	return __pmem_direct_access(pmem, pgoff, nr_pages, kaddr, pfn);
+	return __pmem_direct_access(pmem, pgoff, nr_pages, mode, kaddr, pfn);
 }
 
 static const struct dax_operations pmem_dax_ops = {
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 1f51a2361429..392b0b38acb9 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -8,6 +8,8 @@
 #include <linux/pfn_t.h>
 #include <linux/fs.h>
 
+enum dax_access_mode;
+
 /* this definition is in it's own header for tools/testing/nvdimm to consume */
 struct pmem_device {
 	/* One contiguous memory region per device */
@@ -28,7 +30,8 @@ struct pmem_device {
 };
 
 long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn);
+		long nr_pages, enum dax_access_mode mode, void **kaddr,
+		pfn_t *pfn);
 
 #ifdef CONFIG_MEMORY_FAILURE
 static inline bool test_and_clear_pmem_poison(struct page *page)
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index d614843caf6c..8d0d0eaa3059 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -32,7 +32,8 @@ static int dcssblk_open(struct block_device *bdev, fmode_t mode);
 static void dcssblk_release(struct gendisk *disk, fmode_t mode);
 static void dcssblk_submit_bio(struct bio *bio);
 static long dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn);
+		long nr_pages, enum dax_access_mode mode, void **kaddr,
+		pfn_t *pfn);
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -50,7 +51,8 @@ static int dcssblk_dax_zero_page_range(struct dax_device *dax_dev,
 	long rc;
 	void *kaddr;
 
-	rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
+	rc = dax_direct_access(dax_dev, pgoff, nr_pages, DAX_ACCESS,
+			&kaddr, NULL);
 	if (rc < 0)
 		return rc;
 	memset(kaddr, 0, nr_pages << PAGE_SHIFT);
@@ -927,7 +929,8 @@ __dcssblk_direct_access(struct dcssblk_dev_info *dev_info, pgoff_t pgoff,
 
 static long
 dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
+		long nr_pages, enum dax_access_mode mode, void **kaddr,
+		pfn_t *pfn)
 {
 	struct dcssblk_dev_info *dev_info = dax_get_private(dax_dev);
 
diff --git a/fs/dax.c b/fs/dax.c
index 67a08a32fccb..ef3103107104 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -721,7 +721,8 @@ static int copy_cow_page_dax(struct vm_fault *vmf, const struct iomap_iter *iter
 	int id;
 
 	id = dax_read_lock();
-	rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
+	rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, DAX_ACCESS,
+				&kaddr, NULL);
 	if (rc < 0) {
 		dax_read_unlock(id);
 		return rc;
@@ -1013,7 +1014,7 @@ static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
 
 	id = dax_read_lock();
 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
-				   NULL, pfnp);
+				   DAX_ACCESS, NULL, pfnp);
 	if (length < 0) {
 		rc = length;
 		goto out;
@@ -1122,7 +1123,7 @@ static int dax_memzero(struct dax_device *dax_dev, pgoff_t pgoff,
 	void *kaddr;
 	long ret;
 
-	ret = dax_direct_access(dax_dev, pgoff, 1, &kaddr, NULL);
+	ret = dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS, &kaddr, NULL);
 	if (ret > 0) {
 		memset(kaddr + offset, 0, size);
 		dax_flush(dax_dev, kaddr + offset, size);
@@ -1247,7 +1248,7 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 		}
 
 		map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
-				&kaddr, NULL);
+				DAX_ACCESS, &kaddr, NULL);
 		if (map_len < 0) {
 			ret = map_len;
 			break;
diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
index d7d3a7f06862..10eb50cbf398 100644
--- a/fs/fuse/dax.c
+++ b/fs/fuse/dax.c
@@ -1241,8 +1241,8 @@ static int fuse_dax_mem_range_init(struct fuse_conn_dax *fcd)
 	INIT_DELAYED_WORK(&fcd->free_work, fuse_dax_free_mem_worker);
 
 	id = dax_read_lock();
-	nr_pages = dax_direct_access(fcd->dev, 0, PHYS_PFN(dax_size), NULL,
-				     NULL);
+	nr_pages = dax_direct_access(fcd->dev, 0, PHYS_PFN(dax_size),
+			DAX_ACCESS, NULL, NULL);
 	dax_read_unlock(id);
 	if (nr_pages < 0) {
 		pr_debug("dax_direct_access() returned %ld\n", nr_pages);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 9fc5f99a0ae2..3f1339bce3c0 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -14,6 +14,11 @@ struct iomap_ops;
 struct iomap_iter;
 struct iomap;
 
+enum dax_access_mode {
+	DAX_ACCESS,
+	DAX_RECOVERY_WRITE,
+};
+
 struct dax_operations {
 	/*
 	 * direct_access: translate a device-relative
@@ -21,7 +26,7 @@ struct dax_operations {
 	 * number of pages available for DAX at that pfn.
 	 */
 	long (*direct_access)(struct dax_device *, pgoff_t, long,
-			void **, pfn_t *);
+			enum dax_access_mode, void **, pfn_t *);
 	/*
 	 * Validate whether this device is usable as an fsdax backing
 	 * device.
@@ -178,7 +183,7 @@ static inline void dax_read_unlock(int id)
 bool dax_alive(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
-		void **kaddr, pfn_t *pfn);
+		enum dax_access_mode mode, void **kaddr, pfn_t *pfn);
 size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t bytes, struct iov_iter *i);
 size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index c2a3758c4aaa..acdedda0d12b 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -20,6 +20,7 @@ struct dm_table;
 struct dm_report_zones_args;
 struct mapped_device;
 struct bio_vec;
+enum dax_access_mode;
 
 /*
  * Type of table, mapped_device's mempool and request_queue
@@ -146,7 +147,8 @@ typedef int (*dm_busy_fn) (struct dm_target *ti);
  * >= 0 : the number of bytes accessible at the address
  */
 typedef long (*dm_dax_direct_access_fn) (struct dm_target *ti, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn);
+		long nr_pages, enum dax_access_mode node, void **kaddr,
+		pfn_t *pfn);
 typedef int (*dm_dax_zero_page_range_fn)(struct dm_target *ti, pgoff_t pgoff,
 		size_t nr_pages);
 
diff --git a/tools/testing/nvdimm/pmem-dax.c b/tools/testing/nvdimm/pmem-dax.c
index af19c85558e7..dcc328eba811 100644
--- a/tools/testing/nvdimm/pmem-dax.c
+++ b/tools/testing/nvdimm/pmem-dax.c
@@ -8,7 +8,8 @@
 #include <nd.h>
 
 long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
+		long nr_pages, enum dax_access_mode mode, void **kaddr,
+		pfn_t *pfn)
 {
 	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
 
-- 
2.18.4

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

