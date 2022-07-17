Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CF13CCA480
	for <dm-devel@archiver.kernel.org>; Sun, 17 Jul 2022 22:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658097946;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RCkSCvTF1yrQzeIdNlJ6r2p3UMxk/sRR5cNxlPA0yDQ=;
	b=Xd80fvxaNnqxkn8r41K5FXhEIAOXdqsgcH67pKfI0D0u9irJ8qgBE4lQIZ4CucOZT9TNh9
	K13hFE5nQkqBk2kPGaFcof0pDTNs363VlPZwMzpgY9otH8ki6dZakmHnnvzVoIcZh06VqQ
	+HnZrvriE8mz9iwwx1PXy8utd3Ejdm0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-Fw65xUPEM0evl6VmCS1HEw-1; Sun, 17 Jul 2022 18:45:43 -0400
X-MC-Unique: Fw65xUPEM0evl6VmCS1HEw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF4F03804533;
	Sun, 17 Jul 2022 22:45:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 83E93C15D67;
	Sun, 17 Jul 2022 22:45:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 441DD194704A;
	Sun, 17 Jul 2022 22:45:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5D5841947041
 for <dm-devel@listman.corp.redhat.com>; Sun, 17 Jul 2022 22:45:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4F830C15D67; Sun, 17 Jul 2022 22:45:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A882C2811A
 for <dm-devel@redhat.com>; Sun, 17 Jul 2022 22:45:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D176185A7B2
 for <dm-devel@redhat.com>; Sun, 17 Jul 2022 22:45:37 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-dt1zvv3CPd2-vHFxpJXLXw-1; Sun, 17 Jul 2022 18:45:34 -0400
X-MC-Unique: dt1zvv3CPd2-vHFxpJXLXw-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26H94DCG018524;
 Sun, 17 Jul 2022 22:45:25 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbnvt9uq9-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 17 Jul 2022 22:45:24 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 26HJc6rX004037; Sun, 17 Jul 2022 22:45:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3hc1k3bras-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sun, 17 Jul 2022 22:45:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4137.namprd10.prod.outlook.com (2603:10b6:5:217::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.19; Sun, 17 Jul 2022 22:45:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5438.023; Sun, 17 Jul 2022
 22:45:16 +0000
From: Mike Christie <michael.christie@oracle.com>
To: dm-devel@redhat.com, snitzer@redhat.com, hch@infradead.org
Date: Sun, 17 Jul 2022 17:45:04 -0500
Message-Id: <20220717224508.10404-1-michael.christie@oracle.com>
X-ClientProxiedBy: CH0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:610:76::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 897f9d2a-e189-4321-9a1f-08da68460494
X-MS-TrafficTypeDiagnostic: DM6PR10MB4137:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: r1W5Ze0er0korvLlTKm9irfqKHP9y53eQrfJ6m7YcjogTdSBGk/Es4mnCJnN+vtLsVb2L0bGfJGhcOdxxMxWDJoAhEZSaUi7JP569wh3UM3j0+WRrIWJn9WOLTtz58mrjymlnrWelKb1UoQDXRv4bwfXfKeUZUYpEgUI7r/umLq675lDaJAocBYqaGuD8GvDnT7cWPB3wkkzKpo8MSVQ2B7Urfx/BWY/Kpk6kGmiNNrxV+Svq80ynmTtVLUD+CH5CfBYHMDtZZRWMTkDOGeE4spbnwi+CnvbWzpvwxhBRv08+kusG4XdoIdCYjg7lOJ64pIB4+iihpgO3/mjBi1V8sRRFuUmm/J/Yt8LzBIlXnqVnbA1T3CX2oVqwTMiZQG1Ir53AaprJQFR8zLxqd9H8oSoiFB+sc1hDWtkz0sXm1fViBKxEXr9KtTKg4Cf2BE6p39pMUuqa/72YiPxBYUyAdlD/86J+iphjnrbP6aKagSshe1ds+DZX8NlhzXuhuzjl5oIQPoXVlIjWg/HsFOpnVKCw5iQnYIYTMGaXROy2+eKycOOhDCdyzUKO3+vsbx+PFrAr1nPiT4mIXZwZiGb8mcAKU5N7iznYFVDSpuq+VwVIJTDfwoCYK2uU4Og3VhxvoYN0q7xnnHtJ34MxWoHvgZPPEzNWpY9mbFgO0cFQGpCYcgQ4z+skcD3ocESz6aZm4bNL3hhSQQzVh3Tgff8/Yb8ObPEkw9eITEbV9B93m+i9gtmfMQ3hZtNk2oJ6nvHHxiNxX5+u5N2JCmtQHbvDwbLS3hOYhXd+TMNnQA8KCPW5B+HB2HF1+w+zyfXG18d
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(376002)(136003)(346002)(39860400002)(366004)(316002)(36756003)(2616005)(6512007)(38350700002)(26005)(38100700002)(1076003)(186003)(83380400001)(6666004)(8676002)(66946007)(5660300002)(8936002)(2906002)(41300700001)(52116002)(66476007)(86362001)(6506007)(66556008)(478600001)(6486002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K8M8W/A7ojRT9xH+Qo0KcMlWeBgZM3LYD1ehpYTi+WXteHIJkSkmZ2ubsn32?=
 =?us-ascii?Q?8yTxBU8DBPRCp8veD09fm5BJexG76U5YKhMynDCgunW0hg5YNUvNnCqm4cjY?=
 =?us-ascii?Q?OonipW/STgYnsxJnSstvhq1NiA2FxDNFRxUKxnTSiAlUqKiAFhtMTdIpzp/H?=
 =?us-ascii?Q?uydDxUa9XXvUPlxU7i7CVpSmpS/vYuIks9FliDIi+HDVutIKldyt1FTgZDRv?=
 =?us-ascii?Q?gSL24Dr1eP9OPs11xls1sxK/rECBXYLMkFQYiStiiYCUPNRt5ZENcRgq+2bv?=
 =?us-ascii?Q?vNIb2sqJOw6kAEP305iRkIrnPWCNWkFYCD31GOH8ZKY3HW6dxuWZeDkoxd+T?=
 =?us-ascii?Q?7MquNpw/kjeiJE/1W5yLFhjXIlyrbHuK/duE4/hALnqOKRI9HfOCIjA0T4tH?=
 =?us-ascii?Q?yDvJW92eGCI/w1dkLx94Fu2h4oE5oa7VEx2kftFbbeMZqTXbeB2AceQDHIYj?=
 =?us-ascii?Q?16rSkZsRQHn1PSBicUEBfKKcl4Ce1S4EGX6gX5lqhYRrfLX0pqDD3YaNGBHC?=
 =?us-ascii?Q?lwAfL3g75NwBJPduiBbN/MvdIOJf1amUFMdKJYy1+9rVvs+MNNrydO8djtpI?=
 =?us-ascii?Q?BJwr/SE0ZNIlWfRtJq2vUIRS8ZU3Xmy3Z75HgZbsFopcdw5t2Pf4hh9RMn0K?=
 =?us-ascii?Q?1aNRL1S5ecCaXkNbvnUFeAnb/wK6U6gLYk7uirfVDCdVB4YI4FXuyeoh7fB1?=
 =?us-ascii?Q?7LkzGEGpnKpUBjKMoGN+SyLp3VjY3qIOlBXJjZRvg1dtIW4rs+2/hw08Yf7d?=
 =?us-ascii?Q?H0lbVyA3JrACmGfiRBd+7CqPqVryZrv7e5wCI6uQpOVJTG6aZUzCQ+Yw6p3L?=
 =?us-ascii?Q?2zWgVmNnu+ge0nbPLa6g28lGcZ+tmcYTjvCH1NWD3DT0An6K9Erc4VnzM4C9?=
 =?us-ascii?Q?ekElRkK2lR+Lg/oC1z0MdWpsEE+P7p+NZMxPuO3kfAajG0zS1+0mFXMZ9CFd?=
 =?us-ascii?Q?dMeIdR1QK3gj5R6dnJc4AwtvI6KS1d+D/gPy5mI3Ql2M+KoAZGivrSfUfIl3?=
 =?us-ascii?Q?rsvHymJfNzY6H0saBRNrNlLgVL1DRzsGcCf4Z+2z/EvPQdcHltxGNlhrP1Sz?=
 =?us-ascii?Q?YHNttYeK244OqRVEcldMuRKljgOsGq525feGI8ZG3NF5ACRsvQ14HUrKvMmp?=
 =?us-ascii?Q?Of5ObZ1wSPjD4rdQnBzheA+krkODKsv3KJJZs1Rd2u265FStkDiBmDdAa1OS?=
 =?us-ascii?Q?BbjSotMhGIbNfFoj1/VkTGiVkIrU29zJpdxQr6bozvIt7SZPaen/ZvNCVyIv?=
 =?us-ascii?Q?JK8arpvjdJW8XUTQ3bZGBcK60dPPkxN4Ctjj3TKstbcx0ahcUELdyAY7eJCb?=
 =?us-ascii?Q?4sncELSHI3HfCwhogNZn/N5ceOW94Poa2h+16sI/8LHvdtOX0PPPb+ABWc0Q?=
 =?us-ascii?Q?24ddu/v+X7jHjnwwbZDlchKQcoDNUZn+bGOIP26kU6yQ5oQFh1avi3ReUff1?=
 =?us-ascii?Q?L+LDss1LfETGgFJvGz9FASajT2NFeF8wx3QWpSB3fASRm36vhwZfvT32s6lw?=
 =?us-ascii?Q?ClBLYcaaVBgoi6u+aQvLQwcfBgVsLpUl+ys7qPDRGJ3qy3reeZirhUjxU0RT?=
 =?us-ascii?Q?i/YLSXipO33bXtObbtpBTjWewry5pRIs5tp/8EUTuJtcz87QnvN5RSnY60sL?=
 =?us-ascii?Q?Vw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 897f9d2a-e189-4321-9a1f-08da68460494
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 22:45:16.1755 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: klAiYsKt/XkWZ1Tk3lpMGqZidHLhi4rM2xMzly9Ygzzf73zNhz3eIZTfhscfRNmBPpjJCNGoG3vjndjtSes7grqUNviBEBLL7ddU8bpg10E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-17_16,2022-07-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0
 mlxlogscore=832 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207170108
X-Proofpoint-GUID: bX_RjblgL2SKTee6DdhsQ_wUpG-KCKjQ
X-Proofpoint-ORIG-GUID: bX_RjblgL2SKTee6DdhsQ_wUpG-KCKjQ
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v2 0/4] dm pr_ops fixes
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The following patches were made over Linus's tree and fix a couple bugs
in the pr_ops code when a reservation type other than one of the All
Registrants types is used. They were tested with the Windows failover
cluster verification tests and libiscsi's PGR tests.

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

v2:
- Added info about testing.
- Added patch for pr_preempt.



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

