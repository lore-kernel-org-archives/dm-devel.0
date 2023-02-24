Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E64FC7EE37
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481427;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aNEoNbfeqBEUtrZDAJ/E5KmwKP43DSJSePrSr0pio5o=;
	b=WEe9fXqcRj3wGXC1kSYQxOQXc/jbuGVNoUQOllZhMBtKtI32tCtpPLO0PHkQ9XFx2Idey3
	KFGxWQE042hTlecP8yVUokwNvVymWHC7ms6zv0B+zW2OwOrGRKUdeZ2I/+QqxWqDPWO7uL
	MGCbwBQVQZYVJJTzgwHBjgfVD3azNfA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-236vEeIXMZmwXTZXHCvexQ-1; Mon, 27 Feb 2023 02:03:44 -0500
X-MC-Unique: 236vEeIXMZmwXTZXHCvexQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99C8A3C16EB0;
	Mon, 27 Feb 2023 07:03:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 86B6A1415117;
	Mon, 27 Feb 2023 07:03:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7AE361946594;
	Mon, 27 Feb 2023 07:03:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F2A4B19465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 17:47:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E52782026D38; Fri, 24 Feb 2023 17:47:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DBD452026D4B
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA3E318E0043
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:58 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-DSTSoAjSOQyTJ2ZyU7JbPg-1; Fri, 24 Feb 2023 12:47:48 -0500
X-MC-Unique: DSTSoAjSOQyTJ2ZyU7JbPg-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHiTVG003601; Fri, 24 Feb 2023 17:45:27 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn90wq30-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:27 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OHR44N031555; Fri, 24 Feb 2023 17:45:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3ntn49wk09-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:24 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:57 -0600
Message-Id: <20230224174502.321490-14-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM6PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:5:40::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: cabcc001-d3f4-48da-3f10-08db168ee818
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: m9wPIKF66Xf0rHJ9+4eOBTAUfctm9nxvEjLAdzBBkasBgb1Uz/e5a1ciTe94q10aSqlUgy+m+QqkEQUHvsz05eTLvj+/JEwDkEiXysoYMeMAi3aRZWyS1Rf0E0QbjNOlLHVAEO15WRlvdeNj9Vni90Mslm0Zg35zH96FHOPodT9/OqP/7HSHj5NlbZlEXVtYZxsCsjXY86VAxaBJcrl1gwjwWgf5ywavLArq0qt9b8ITRBG4x5+uxl6FLC5zwIJhkUhh/Ua/harURL2fqPdnAYl6zWcBSwpKq52zzf97MkWR8bO8ijZVl87NyxjGopwivSxHnBp8Ld5iSNuP5ywv8BPz7q7y986YwvjRyr36O0344EaVNvn7AGZymZx34BaxBHOPZ1kdCOX70M6ueJQfmozPQzVcDTEsiBkZvz7aTyUT0XDEb027M0SplpcHMTCvepmOQkRMakUi8WoLJJP+yMrTrTKcRnSMWGB3bEXaaKTmOvr/ZU6uoNu7laKSLra6g74SlHSfyEcrr/UOKiztL3eKfH17f7va411nvZdqpk0LplVLnYPn5pK3THgDjGMMa9SR9Gw+KXZ3CSsdEAdbmJOZp65WKJs0rSqizjlMisLZctNRBja5UjgYW0oFmdXF4sF2PkJiKx78QX0aHgg3LPEc7xGvQO0QhnTBb38aUATKgvUeCNCMnj5QHEqpsQg1
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LbUMPj6Z0QNeMBFbnub126v3Dmh3G8gCEeW2+keIDZhwsBJ+QTHfP+HvXjIq?=
 =?us-ascii?Q?FjBiWUbRT5wHV9nb2qxG3hNloMkQ7YjhU5rGi28EF3lXgG2KY+EqymawNrH8?=
 =?us-ascii?Q?Lb1b6H4JEK06KmufmIxrrOeIzqXb4BzPE/rhXZP6BkR+uQVZdB9rgRwlAsgN?=
 =?us-ascii?Q?UW71Foie9qAB6B2Qj0TRZb5vXr0P8eJ4xXjqlP+wpP00hvHe025pA44wRxSr?=
 =?us-ascii?Q?/aFwFut9oltC3e+3DdBLY8AOTVRaZ32JCo/cmp8RYYHO/Q+SuchSp5zhYONO?=
 =?us-ascii?Q?t2n5g6s7rPEjlBVBJQzvC6uMGHGVFhfxKuF/NVVu7G0HVCiiooufCysZIE8I?=
 =?us-ascii?Q?7wl0JJ86Jhn6E3c7GNnYeOHiA0fqSwm5UKtmmMfPOdBbu8lwANpQHGUK5+Ga?=
 =?us-ascii?Q?zvAWITNWKG9V16hSg5oSGVqtjGvCIIJh9m2olobKqUiO9M4JIYMwDNGyutp6?=
 =?us-ascii?Q?meXwtiCpyPNatb0RWlAsRMssTmgVXJQndz+oliL80jqHpT+rGpx0fQfitzNj?=
 =?us-ascii?Q?BMatQ19bzC35pYfXBMvXDPUoONM8EvdqUJWE8Vdib7NX/BbqBqAOQNALdrln?=
 =?us-ascii?Q?eJM2Yw6Sj0/abeb0nTVHVa4Ypwuw5pA5a5AxA0kSMIv8EYmR51KGcsIkzmBo?=
 =?us-ascii?Q?pB3s5PfEuqdun6la7R4V/z2AmEP4kDGT4lbdCIw/ZDn2NmMTW2LT/LkHzERL?=
 =?us-ascii?Q?EWjCogwWskWU7TWLTP/M256UHooszXBvwSGTcR3Lu0RCQ/UR9n/9B8yHR2Zs?=
 =?us-ascii?Q?DRWVb9MYH3yxPIawaGMMSqiXRic+3l/qQysLtOiIrV/Rm1LNEJqgKtWk5vsz?=
 =?us-ascii?Q?PLq/DvFzR7G2FeconkBUbJoo3g6QKO2jnX+Ro32KOwpb4u79neaVLcMPin9m?=
 =?us-ascii?Q?5T5apvVtiaeyle1ug3jCC/e8h99K7JsuUE9U9QAlhbwEavy7E5ItM7XT147m?=
 =?us-ascii?Q?nHH91/cSUnBcySTY3/cstqK3f3Ih7QaBee8caU7iZI99ZHthfc+cjklflUVG?=
 =?us-ascii?Q?AumaCUj+j1pfU8xKFjwmvVwkT1/hzx8EkQgsFhkz5XfCkSfy7xktrtkWUwZw?=
 =?us-ascii?Q?VKjTPQEbLPu2RKnHXvj/rWwngprgWgDFZChSOMZpLVuGZl4U4IIdfjCZ4Gxu?=
 =?us-ascii?Q?1yD0X0A9+K12qrC/R6IlLGoJANHzJeXOEvtp0WQn2byK3G133dXJMjyBMXoR?=
 =?us-ascii?Q?lVYIBxESEXZOVUmWiokrCLJ2+CxDwea/nSDZ+pF8t8ucz4L5o1JBcsbuT/1c?=
 =?us-ascii?Q?Km99aHUsIUzVKJdE/mhl1/Gh4AJ3QILCuFP+jMyXFD4ftFbr39z0CFqHPvPI?=
 =?us-ascii?Q?dxcuItt1Jj9+KvIwV9F1rorsdLjI7f05QK+JtBM4MQrtmx4dtrdz8EsB6NqT?=
 =?us-ascii?Q?lHYrWomC6rEeXW/YplVHXNAWLPVhdJi/Uw5Ktx8mWYCY+pruYBFmxG7+1hCv?=
 =?us-ascii?Q?sc3jMMsQwxveswUikR4UOhE+nY3/StOMLvanTtXqBkPqoPqjpzc1lMz+swye?=
 =?us-ascii?Q?ZZSwyEW8mmlwLzRKJIbmm5rb4+himMvficAA5QEm8TobXB1uQGyrXVJfJXhI?=
 =?us-ascii?Q?ZE6Wy4u2K/rSXUICuJpWHzjXIIWKSPBZ41g2WYrUYvoOlcWn7hdRXepfVPfE?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?gN5CMWq1aLNKQgDEvK7wVFjZ3OoIDHgP53AW4FIiknK0LG1b8qnMnEFgzjIK?=
 =?us-ascii?Q?UNR+tnWJtihqvNJL4hXlgdxN6UDMabfkcTfIIdjBXM3r4+498Y6eHb6K4+Y2?=
 =?us-ascii?Q?651rR33vuUkQ1k2ter0RgTIKvJDOzkaUHBZIymN9xZhhsJbs0dV0qOO9jzB3?=
 =?us-ascii?Q?d2sUUlgpV60SE0raJAbeQu/OJ/QuHbbQ4ky91SbqDP7UpQubf8tlJmG81TZT?=
 =?us-ascii?Q?OINp6Z0xwqCOQFrhV23FO4BWagubQbg5AQ7CHlTxkaskTILOq1f7h+UTrEBW?=
 =?us-ascii?Q?Fc0tfwbsFB62CVUrLNdXyvUcyyrseeJF3ufgable340wFqLNDBoaT0f5yipX?=
 =?us-ascii?Q?pMBIQjECs11a0c3sRYFic495JmQ6bV1ymbjdahbqxJ+9kJBtNXkS7dW1aLxW?=
 =?us-ascii?Q?SHljhJyGvCSGYfEsgCFI9L0CjoXl8JUoXNWc42b/b1u6Od0vLhhFvbt127ij?=
 =?us-ascii?Q?qJ0caWAN4uv20TrpynMkyyaTAmlv2PV1up/TkUNZgzbpj4N0lzda/O/95jdY?=
 =?us-ascii?Q?qHs1bNA7GpSGU+iiLnNrznEDTVDfJrdP1s3bhmN4QsGZPMcVnroifbAes8w4?=
 =?us-ascii?Q?BMKV2J792t7rdcF2JLTEmKpJJ/cOqO7inaiAJI8gdtn1rc1wW2cF9JCjCBaA?=
 =?us-ascii?Q?7o3H0F/nIcPUyIS2q1W70UFDQVbc701+J9jkwgdOWmy6izawY4yZIATAPBzx?=
 =?us-ascii?Q?dEv67CS7cMeebIoKaG8sOyQrpuED5Ww1AmMDtdbJFjEWnTE7QkumaP3FHSPV?=
 =?us-ascii?Q?zskKLnxkAFyODhE2pZxM1iPV7YD6LLccvP3CHvgY2IAlJX3GJHnk7nUiicZV?=
 =?us-ascii?Q?1oA9+BQUp+u/zeETtIscKDV+Q0c5kgLZgDeshadEAqQvI4zwYmpnTioplHgb?=
 =?us-ascii?Q?rRZ6wGzJuN7tx2q6crlGrAfEDaulqG5RZ4ti4H0DvHjBc8T2gN1vIw9IHDGd?=
 =?us-ascii?Q?SxOHF5l9IQ7xNk2pK1c0yXgg+F0u24FGa9jx4JTwEID+Wde1/EgrI1X6lFkW?=
 =?us-ascii?Q?jgwcYViqXS0sBlB6ZRe8FQB91A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cabcc001-d3f4-48da-3f10-08db168ee818
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:23.9845 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LPa7xjucB+Jyqwfem21k53F74fcyKGvBZv+OvcbmejM2j0iHsMMgNIXDVrmgZxaf8Xexamob5hEtao7TpeU00Qlm6kfiwiRjhXpOKdznWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240139
X-Proofpoint-ORIG-GUID: 3BZ8eTH0i8nSaezocJUIlIZSZG-PMWWr
X-Proofpoint-GUID: 3BZ8eTH0i8nSaezocJUIlIZSZG-PMWWr
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 13/18] nvme: Add pr_ops read_reservation
 support
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch adds support for the pr_ops read_reservation callout by
calling the NVMe Reservation Report helper. It then parses that info to
detect if there is a reservation and if there is then convert the
returned info to a pr_ops pr_held_reservation struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/pr.c | 81 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 66086369dbce..cadf61dc60c3 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -26,6 +26,26 @@ static enum nvme_pr_type nvme_pr_type_from_blk(enum pr_type type)
 	return 0;
 }
 
+static enum pr_type block_pr_type_from_nvme(enum nvme_pr_type type)
+{
+	switch (type) {
+	case NVME_PR_WRITE_EXCLUSIVE:
+		return PR_WRITE_EXCLUSIVE;
+	case NVME_PR_EXCLUSIVE_ACCESS:
+		return PR_EXCLUSIVE_ACCESS;
+	case NVME_PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case NVME_PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case NVME_PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return NVME_PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	}
+
+	return 0;
+}
+
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 		struct nvme_command *c, void *data, unsigned int data_len)
 {
@@ -215,6 +235,66 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	return ret;
 }
 
+static int nvme_pr_read_reservation(struct block_device *bdev,
+		struct pr_held_reservation *resv)
+{
+	struct nvme_reservation_status tmp_rs, *rs;
+	int ret, i, num_regs;
+	u32 rs_len;
+	bool eds;
+
+get_num_regs:
+	/*
+	 * Get the number of registrations so we know how big to allocate
+	 * the response buffer.
+	 */
+	ret = nvme_pr_resv_report(bdev, &tmp_rs, sizeof(tmp_rs), &eds);
+	if (ret)
+		return ret;
+
+	num_regs = get_unaligned_le16(&tmp_rs.regctl);
+	if (!num_regs) {
+		resv->generation = le32_to_cpu(tmp_rs.gen);
+		return 0;
+	}
+
+	rs_len = sizeof(*rs) +
+			num_regs * sizeof(struct nvme_registered_ctrl_ext);
+	rs = kzalloc(rs_len, GFP_KERNEL);
+	if (!rs)
+		return -ENOMEM;
+
+	ret = nvme_pr_resv_report(bdev, rs, rs_len, &eds);
+	if (ret)
+		goto free_rs;
+
+	if (num_regs != get_unaligned_le16(&rs->regctl)) {
+		kfree(rs);
+		goto get_num_regs;
+	}
+
+	resv->generation = le32_to_cpu(rs->gen);
+	resv->type = block_pr_type_from_nvme(rs->rtype);
+
+	for (i = 0; i < num_regs; i++) {
+		if (eds) {
+			if (rs->regctl_eds[i].rcsts) {
+				resv->key = le64_to_cpu(rs->regctl_eds[i].rkey);
+				break;
+			}
+		} else {
+			if (rs->regctl_ds[i].rcsts) {
+				resv->key = le64_to_cpu(rs->regctl_ds[i].rkey);
+				break;
+			}
+		}
+	}
+
+free_rs:
+	kfree(rs);
+	return ret;
+}
+
 const struct pr_ops nvme_pr_ops = {
 	.pr_register	= nvme_pr_register,
 	.pr_reserve	= nvme_pr_reserve,
@@ -222,4 +302,5 @@ const struct pr_ops nvme_pr_ops = {
 	.pr_preempt	= nvme_pr_preempt,
 	.pr_clear	= nvme_pr_clear,
 	.pr_read_keys	= nvme_pr_read_keys,
+	.pr_read_reservation = nvme_pr_read_reservation,
 };
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

