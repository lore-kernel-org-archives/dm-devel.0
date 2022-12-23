Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 385F7C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 23 Dec 2022 14:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671806868;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MT46TTi/76lMkKZ2dK/tpUdM+koBKEpDgyObutVl4Xc=;
	b=R4vYfcmPpxso0jOcuIlVJI1IEEEz36QrmQwT6AFxigVHLkP42zjiwzOXG+NX8VwL1R/qmF
	hpRe8vii4dFv/GYUcC1gD8qTNHygq7bOT8gcwoxU5F1QTsA5p4XpM0Ki+DvGh2JSZUYrci
	/lu4YgsNijnSFuyOq7PgyOCKFjWIIJA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-EgQgeuRJOHOSK8dOfLsxwg-1; Fri, 23 Dec 2022 09:47:44 -0500
X-MC-Unique: EgQgeuRJOHOSK8dOfLsxwg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA9FB3C01D88;
	Fri, 23 Dec 2022 14:47:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB5AEC15BA0;
	Fri, 23 Dec 2022 14:47:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9EEA319465B3;
	Fri, 23 Dec 2022 14:47:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A3EAA19465B1
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Dec 2022 14:47:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E987492C18; Fri, 23 Dec 2022 14:47:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 34F99492C14
 for <dm-devel@redhat.com>; Fri, 23 Dec 2022 14:47:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2B213C01E11
 for <dm-devel@redhat.com>; Fri, 23 Dec 2022 14:47:29 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-2q0joUgeN5ihuuaZXr9LLQ-1; Fri, 23 Dec 2022 09:47:25 -0500
X-MC-Unique: 2q0joUgeN5ihuuaZXr9LLQ-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 2BNEEKqk003391; Fri, 23 Dec 2022 14:47:12 GMT
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tr67ub-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 23 Dec 2022 14:47:11 +0000
Received: from pps.filterd
 (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 2BNDFEuK007699; Fri, 23 Dec 2022 14:47:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
 by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3mh47fnpfd-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 23 Dec 2022 14:47:10 +0000
Received: from CO1PR10MB4563.namprd10.prod.outlook.com (2603:10b6:303:92::6)
 by PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.13; Fri, 23 Dec
 2022 14:47:07 +0000
Received: from CO1PR10MB4563.namprd10.prod.outlook.com
 ([fe80::f79c:e911:4586:9371]) by CO1PR10MB4563.namprd10.prod.outlook.com
 ([fe80::f79c:e911:4586:9371%2]) with mapi id 15.20.5944.012; Fri, 23 Dec 2022
 14:47:06 +0000
From: Gulam Mohamed <gulam.mohamed@oracle.com>
To: Keith Busch <kbusch@kernel.org>
Thread-Topic: [PATCH for-6.2/block V3 2/2] block: Change the granularity of io
 ticks from ms to ns
Thread-Index: AQHZFPFuNnmU8fHcpkiSBSHlMBjHga54k/MAgAL7k+A=
Date: Fri, 23 Dec 2022 14:47:06 +0000
Message-ID: <CO1PR10MB4563F566452B9D3035A82EE298E99@CO1PR10MB4563.namprd10.prod.outlook.com>
References: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
 <20221221040506.1174644-2-gulam.mohamed@oracle.com>
 <Y6M9rJbw3ZMvOeDr@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <Y6M9rJbw3ZMvOeDr@kbusch-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR10MB4563:EE_|PH0PR10MB5795:EE_
x-ms-office365-filtering-correlation-id: c3ebebc7-35b1-4a4d-12ec-08dae4f49030
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: MR5rLI74UzT/b97umAQylBquKoEFyBi1UiaC6J9zbGLM02pWtaPIJ9Cf5Mqcz/905+qd1UL4TE0E3TmBd52oG5tUxbobvUx+YcevU1Hr9YT2jFiiBxSluO+Quzk/5R+R4aaLg2GGdqFFt8ZTNStdAF2yST5gf+3FR9Gh2HgmCBfiT8wLbl0l2iD+WFYGKRM9Lk7hor1bXZ/rzMeU3nIvtTFcdRqvlMagOWF9k97H1JdD9YoJWoTpBAI2IfukMIedx8ZcZ/IhFDLNV9JDRyLHkMmR6Q31gGq/bSfWE4A+gYRBAPZ9oquK8eDISe2lHt6Jx+drQBsXtFtgKeg0m0OvpEkrJcLNyn+J+21TCfqv2FlYPnI8rKG5nCh9ye+1i8faAe12sUVwxFT+fry6uRl3MKCEPwl2gBT6dCiWhuRsFGpnDcbvxkkOcbz6VcMhRabDDro68Hh5WCI2SEk4+/yZIcwjm7bdIfEoTR0jCuqISNq+7/R1b5yjwYMBbg7WqSctSpheCu2YOuNXY/3Kj/XwYoidMoCZVQzOZ7AVOOYJUYNDFSU71oc468K3Kthg8qitdKsT2zH6A3v+zvklVDfmZK8AW5/7cPlb/JpLHx1UMBOV7k2kTCZ6bbELhRnM7xmxEFmLI/hyJ9aqMXNjkJN9W3ktNef/dWkQIuCISuqJ7Tnb//VpAVIBB2h2z2Ls68oJ1rVi4pjHlg9eG4OB5QjG9Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:CO1PR10MB4563.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199015)(316002)(38070700005)(2906002)(54906003)(6916009)(44832011)(83380400001)(478600001)(53546011)(7696005)(6506007)(86362001)(55016003)(107886003)(9686003)(71200400001)(186003)(26005)(33656002)(52536014)(8936002)(38100700002)(41300700001)(5660300002)(76116006)(122000001)(66476007)(64756008)(66946007)(66556008)(7416002)(66446008)(4326008)(8676002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EW5Uo8B53+tpfuETDtluY5h7lhLKksJdv4OKn/KdEn31sEKnSHzCaOliZJ5z?=
 =?us-ascii?Q?GDaf+cxQbgbRKW0P4+YDTL2YO4RnBNBdnqqlLez54r8shU/MEfKVtJGwBhWv?=
 =?us-ascii?Q?SyZnWR1jlPNdwFpdeOs5HRii7n/eKiosLyKZMM2bGVytnkde22WjLpT7d2cw?=
 =?us-ascii?Q?IEdv3slZm/vHiB8bvcjBXFpUuuIhFmpKJiHgiIrCkW+NfIoNJOdKOdZ2DVgD?=
 =?us-ascii?Q?YqCGu7IHxNJ5zTUjtTUcFoRQrh/OwmMov/HpvECbahPuQU3poRpxauAa5uLr?=
 =?us-ascii?Q?9MDZ6neMMMo5RvpZlurNMImG3ZpMJEoxovY+w8kwtk67C/0b2AeP140R8t2n?=
 =?us-ascii?Q?ibvO54TRLnqD55Ih1GAZykwvQb23/XoA6t68PbOVfitUuGDFq1Gp58Wsmwjq?=
 =?us-ascii?Q?uC2ZIf1BC76uKWyqJvZoe7O0Yj2CMHJcDmwOhfhTO79GNT00uPda9or5Bxan?=
 =?us-ascii?Q?enTyCcUzfUwUC13/xkS6t2P44RD2snGV4+YKwgLVjA/DaubEgQq348/F8Jm6?=
 =?us-ascii?Q?N73OyYcKD9mEt/FGJRmgmrp3mGylN78FY6obG1/NE5FZOkdkJLubeMQkv4pF?=
 =?us-ascii?Q?+z+K6Q52TfEvRzP5fO4K2m2uOTz/jrplV7t0PlOqpt/CRU+EpN382XiqpBT9?=
 =?us-ascii?Q?Xl0lOSPqGzMQL2U+9XPBeUi7fcHh00szN4UcOfHbxCxhYGvOpMxPWMlFw4rh?=
 =?us-ascii?Q?zTGVh+OkffCb8UHrXxdsFQA8RsBwl2D++/KKB4V+kjJM+G6f0TPuArmIyeu+?=
 =?us-ascii?Q?pmIgQPCYwc4EANqrSo6VohlxDx0CSuj/Lxwr6wFd6G8oaNHGJkIdT7vVLRHg?=
 =?us-ascii?Q?KItKFjmgl3tekBbj/Ro3zsRrTijaFCuBcwB8tWEWugLjg6xiPZZbu34tGmvX?=
 =?us-ascii?Q?eAjtkiEk4nm8S+NbaKv0qtptfKLb9j6+ZdiOyh0UmdBV47N8ARvQF/0A3roa?=
 =?us-ascii?Q?i+tGYt6hmZ0UH8SCH26pyII4ErCmhkT1j/U4iyn8XC6FoW5mkwYo20MEtb23?=
 =?us-ascii?Q?Ld8sib2aD3Z4tKju41WAy/VYfC+lG0vtGr9mCDXCXnAyYWCyFP+Sci1Of+ji?=
 =?us-ascii?Q?T1yD43JkVIUFRQKEyaixTZnGJERAHx1PR5tGF3p+u8Oj1oGNzsjBAmmVZ0uS?=
 =?us-ascii?Q?lbR5LjBOWRQTRocZP1aVydF+18Q0RwDt/P9g45cMXZ1ehXtFUvx7PkihhJW7?=
 =?us-ascii?Q?FjW4neXn75fqG+jqZTj0PBJTEDIMD5cVar7lD/tbhwbpBoo/hX9CSFFd8A5H?=
 =?us-ascii?Q?u5REeZQmlSLavxm6LKEGaliXhWksUmN9ynJWoeYDdoJIyMcYDq3kjLHmgDR2?=
 =?us-ascii?Q?tzFKcpQpOsMk3INi58lDPD59JzUi9boGcKBxjh/QtDfWEiWUy+aaO2BA8AmM?=
 =?us-ascii?Q?i8D68HqKJx72yhM5Y9s322zflFY+IB1HC1WiPKI9e5AghTMIH6bXsmynXVON?=
 =?us-ascii?Q?smmZ7Wb9ySeWT6rJxHpb2PMZwZ/Dtg0nEMEJQVf/8yPjfxVe+KsWeUoRp4jp?=
 =?us-ascii?Q?L1LvAgEGOfzm9aKWlDXQxKj6Sep8RibMNVti6dHdV6B98eOpK6j1aEDArrrU?=
 =?us-ascii?Q?9mBmEWXmTtFF2P3oc8MeSnAYxRlwHnaMa0OwH5pY?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4563.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ebebc7-35b1-4a4d-12ec-08dae4f49030
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2022 14:47:06.8413 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cubjR2yZnnjMVb3TlKXHaQlyLPbKgL8H5kHLjCl0RUo9JnGqp62srFlYb2rx/fK+2WPxRg1tRJlwLOGe5WFsSWiFWSP5t3TosrIlMnA+61U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5795
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-23_06,2022-12-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212230124
X-Proofpoint-GUID: ezNCfCW5MSRLe2i75-RAc-Yvrd9fkFj-
X-Proofpoint-ORIG-GUID: ezNCfCW5MSRLe2i75-RAc-Yvrd9fkFj-
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH for-6.2/block V3 2/2] block: Change the
 granularity of io ticks from ms to ns
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
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 Shminderjit Singh <shminderjit.singh@oracle.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "song@kernel.org" <song@kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "minchan@kernel.org" <minchan@kernel.org>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 Konrad Wilk <konrad.wilk@oracle.com>, Joe Jin <joe.jin@oracle.com>,
 "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
 "ngupta@vflare.org" <ngupta@vflare.org>, "kch@nvidia.com" <kch@nvidia.com>,
 "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
 "snitzer@kernel.org" <snitzer@kernel.org>, "colyli@suse.de" <colyli@suse.de>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "axboe@kernel.dk" <axboe@kernel.dk>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 Martin Petersen <martin.petersen@oracle.com>,
 Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>,
 "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
 Junxiao Bi <junxiao.bi@oracle.com>,
 "christoph.boehmwalder@linbit.com" <christoph.boehmwalder@linbit.com>,
 "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Keith,

   Thanks for reviewing this request. Can you please see my inline comments?

Regards,
Gulam Mohamed.

-----Original Message-----
From: Keith Busch <kbusch@kernel.org> 
Sent: Wednesday, December 21, 2022 10:39 PM
To: Gulam Mohamed <gulam.mohamed@oracle.com>
Cc: linux-block@vger.kernel.org; axboe@kernel.dk; philipp.reisner@linbit.com; lars.ellenberg@linbit.com; christoph.boehmwalder@linbit.com; minchan@kernel.org; ngupta@vflare.org; senozhatsky@chromium.org; colyli@suse.de; kent.overstreet@gmail.com; agk@redhat.com; snitzer@kernel.org; dm-devel@redhat.com; song@kernel.org; dan.j.williams@intel.com; vishal.l.verma@intel.com; dave.jiang@intel.com; ira.weiny@intel.com; Junxiao Bi <junxiao.bi@oracle.com>; Martin Petersen <martin.petersen@oracle.com>; kch@nvidia.com; drbd-dev@lists.linbit.com; linux-kernel@vger.kernel.org; linux-bcache@vger.kernel.org; linux-raid@vger.kernel.org; nvdimm@lists.linux.dev; Konrad Wilk <konrad.wilk@oracle.com>; Joe Jin <joe.jin@oracle.com>; Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>; Shminderjit Singh <shminderjit.singh@oracle.com>
Subject: Re: [PATCH for-6.2/block V3 2/2] block: Change the granularity of io ticks from ms to ns

On Wed, Dec 21, 2022 at 04:05:06AM +0000, Gulam Mohamed wrote:
> +u64  blk_get_iostat_ticks(struct request_queue *q) {
> +       return (blk_queue_precise_io_stat(q) ? ktime_get_ns() : 
> +jiffies); } EXPORT_SYMBOL_GPL(blk_get_iostat_ticks);
> +
>  void update_io_ticks(struct block_device *part, u64 now, bool end)  {
>  	u64 stamp;
> @@ -968,20 +980,26 @@ EXPORT_SYMBOL(bdev_start_io_acct);
>  u64 bio_start_io_acct(struct bio *bio)  {
>  	return bdev_start_io_acct(bio->bi_bdev, bio_sectors(bio),
> -				  bio_op(bio), jiffies);
> +				  bio_op(bio),
> +				  blk_get_iostat_ticks(bio->bi_bdev->bd_queue));
>  }
>  EXPORT_SYMBOL_GPL(bio_start_io_acct);
>  
>  void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
>  		      u64 start_time)
>  {
> +	u64 now;
> +	u64 duration;
> +	struct request_queue *q = bdev_get_queue(bdev);
>  	const int sgrp = op_stat_group(op);
> -	u64 now = READ_ONCE(jiffies);
> -	u64 duration = (unsigned long)now -(unsigned long) start_time;
> +	now = blk_get_iostat_ticks(q);;

I don't think you can rely on the blk_queue_precise_io_stat() flag in the completion side. The user can toggle this with data in flight, which means the completion may use different tick units than the start. I think you'll need to add a flag to the request in the start accounting side to know which method to use for the completion.

[GULAM]: As per my understanding, this may work for a single request_queue implemetation. But this request based accounting, as per my understanding, may be an issue with the Multi-QUEUE as there is a separate queue for each CPU and the time-stamp being recorded for the block device is a global one. Also, the issue you mentioned about the start and end accounting may update the ticks in different 
units for the inflight IOs, may be just for a while. So, even if it works for MQ, I am trying to understand how much is it feasible to do this request-based change for an issue which may be there for just a moment?
So, can you please correct me if I am wrong and explore more on your suggestion so that I can understand properly?

> @@ -951,6 +951,7 @@ ssize_t part_stat_show(struct device *dev,
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	struct disk_stats stat;
>  	unsigned int inflight;
> +	u64 stat_ioticks;
>  
>  	if (queue_is_mq(q))
>  		inflight = blk_mq_in_flight(q, bdev); @@ -959,10 +960,13 @@ ssize_t 
> part_stat_show(struct device *dev,
>  
>  	if (inflight) {
>  		part_stat_lock();
> -		update_io_ticks(bdev, jiffies, true);
> +		update_io_ticks(bdev, blk_get_iostat_ticks(q), true);
>  		part_stat_unlock();
>  	}
>  	part_stat_read_all(bdev, &stat);
> +	stat_ioticks = (blk_queue_precise_io_stat(q) ?
> +				div_u64(stat.io_ticks, NSEC_PER_MSEC) :
> +				jiffies_to_msecs(stat.io_ticks));


With the user able to change the precision at will, I think these io_ticks need to have a consistent unit size. Mixing jiffies and nsecs is going to create garbage stats output. Could existing io_ticks using jiffies be converted to jiffies_to_nsecs() so that you only have one unit to consider?
[GULAM]: I am not sure if this will work as we just multiply with 1000000 to convert jiffies to nano-seconds.



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

