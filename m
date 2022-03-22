Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58AACC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 23:48:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-wY6kX87TOSCaALPoduRr_A-1; Tue, 22 Mar 2022 19:48:37 -0400
X-MC-Unique: wY6kX87TOSCaALPoduRr_A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42D6F1044560;
	Tue, 22 Mar 2022 23:48:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E00943E8E2;
	Tue, 22 Mar 2022 23:48:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D58DD1940340;
	Tue, 22 Mar 2022 23:48:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A10131949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 23:48:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5CB461400C2F; Tue, 22 Mar 2022 23:48:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 578AC1400E70
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 23:48:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37AC3800882
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 23:48:34 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-_ysN8s5qO_ife_mXdWSZxQ-1; Tue, 22 Mar 2022 19:48:30 -0400
X-MC-Unique: _ysN8s5qO_ife_mXdWSZxQ-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MKxe95019567; 
 Tue, 22 Mar 2022 23:48:16 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ew72aft08-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 22 Mar 2022 23:48:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
 by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22MNjUxt050840;
 Tue, 22 Mar 2022 23:48:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
 by userp3020.oracle.com with ESMTP id 3exawhwsw4-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 22 Mar 2022 23:48:14 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BN7PR10MB2514.namprd10.prod.outlook.com (2603:10b6:406:bd::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Tue, 22 Mar
 2022 23:48:12 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336%7]) with mapi id 15.20.5102.016; Tue, 22 Mar 2022
 23:48:12 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Thread-Topic: [PATCH v6 2/6] x86/mce: relocate set{clear}_mce_nospec()
 functions
Thread-Index: AQHYO1ql070j1sj5n0uvCqd0wwFVgKzMBTgAgAASpoA=
Date: Tue, 22 Mar 2022 23:48:12 +0000
Message-ID: <1e3f07b6-921a-d901-f9bf-96a9628ba1e7@oracle.com>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-3-jane.chu@oracle.com> <YjpQlmGCFFQueHS1@zn.tnic>
In-Reply-To: <YjpQlmGCFFQueHS1@zn.tnic>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3472d944-1ccd-4ff2-6df2-08da0c5e6cf9
x-ms-traffictypediagnostic: BN7PR10MB2514:EE_
x-microsoft-antispam-prvs: <BN7PR10MB251419C3D85E71D18A5AEEC4F3179@BN7PR10MB2514.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: M1ZDwHo1eu1ypKTnj/dO4oApbjyX0ukpEJKyYx7I0EQv5LZs4wo3PNi7Jf3ysZsmt7Uka8qaoFiHI6kwfUrHKrwZPw5OS+56k9YWgd3exHNVlY8sUi2Sds3fPsrcKoXsxj7GTna6C//w5WmCXWR6aA9BrjcPTiL491pj8FRPo0T4FtuACJw5HGb6qOTqu5l4QpF6X1+Gc8e9hyW0n1aEbHqdqHB2jM+Ta7cdpvxYDBjwD4u7I/JCzqna7vyk3oG6MuVuDgRUrApMwi9OPd+cxKZZZD5WVRA4TtyDOSFRmDAM5l3NZ/notufPouVgdyMisZt3RGWvqpZfXYMY0AX29TNy9krf/1ZM/xCZMk8vXSp4kaW88/SUXSkokeKNxDiQmr6d7Drvnb/YlAD2qCCNCj9xfew3cclaOFacMFgCzoXgOV7blS0CoRqc0g+qwG/cIlOZ7TXkFLO20R7bbtYlvTgrhJ/6B/jcqPSyzZQy3WA+hh+2aHlLlkWwG5rmZ0LbWYigRzClQNW0RmCsF9gTCFIjvxwU8BuV+H+PpbvU5O0dYm2er5Fh0+kRJ0RhQKwctsKifwtTUpWqUO1c8BFuAkh6s74ayM5zLy1VFbOVN1oAMyaX3prCu+AbgSbkCUX/WrUQ+vSY+jI7GSShfT2U+9tJd2OBZLyI9BaREp2E6zx3ZRfyc/ZfZcH5srbtkeVcsRL30jDn7NuFDEvnqAW9VutmrapN/etLbYss5QhJmBZ9c1cBoDbKwYqUJP/CthHE78JOa4V2qtNKQF0w2hmFQw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(26005)(6506007)(6916009)(186003)(54906003)(2616005)(6512007)(6486002)(71200400001)(36756003)(31686004)(66946007)(66556008)(76116006)(4326008)(66446008)(66476007)(8676002)(53546011)(64756008)(91956017)(508600001)(38070700005)(5660300002)(122000001)(31696002)(86362001)(7416002)(4744005)(44832011)(8936002)(316002)(83380400001)(38100700002)(2906002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUJuSlRNRDNNVlE1VEJjendLWTR3RmZqTjJ5S3dhM2JYL21jQndZV1cvM2da?=
 =?utf-8?B?M1Z0clNKOTU1YXEyR0dXK1RSQVQxd0ROVEhTRmNWYTF1dDc5c2ticW9hSHVi?=
 =?utf-8?B?aENuenFjOGhEamVMWmlQdlZWaWRCTDlIT3NhMlRyclJlbTZlVTQrV3B6bmRX?=
 =?utf-8?B?VGFJM1dmMmd2bFJzZkY2anNsZjRhZ3RsellIMXA0S2NZWHBuRkhGbG5CM2NB?=
 =?utf-8?B?b0d1TDRFR1E4c2VHV0h0TWY2MXE1N1JDWWx3ZlVQbzh3ZXMyU1haZy8ySXRY?=
 =?utf-8?B?ZGI3OUxoNDg5aXd2VWxFZG5pTUFXbU5sMnJhZWMzU0FUWFczMGtST1lEbVhF?=
 =?utf-8?B?cXdSVkNMN0NWMk5TdkNKNS9sSUlMeHVmaGJxa2lIMGpRQWdRTWwwQ3BZUGdS?=
 =?utf-8?B?TVJNZThtdnBsNGJQRjRhMEkrU1pNdVJDWjRYNENFZE5LNlJMUkN5d2ZDZXRq?=
 =?utf-8?B?a2xLUUhPeGdBQW1JdTlxbTBtTk5iYTB5WnFZbXRFRnZ4YzltMjlGK0tSY0Y0?=
 =?utf-8?B?aHR5NkZoN21JZ0ptK3Z6bDVsZ1R5Z1Y1d2dCMGhTS2dCRFJLeWdIeTMvQ3ht?=
 =?utf-8?B?YlJjNGIwUTNTY0psMWpVVHU0TXVCek8zaDRUeVN5L0luSzN4WGw4NmJpQ3la?=
 =?utf-8?B?UlpyQ2JWMHEvcmUrVFJmVy9teVJyZmRWVG43TmM3R1hCSHlpT2R3RzFMb012?=
 =?utf-8?B?YXRtV1NheXBPa2ZNOUxZNUVpYXIyMW1hMmx2R2J1YnhIakxoWEMxT2FkZkZt?=
 =?utf-8?B?MjY5b0hGUy9nNFVoM3IxeHpMQUxPb3BSamJJZCtoQUtwUmI1YmNOTHUySGJo?=
 =?utf-8?B?enUzOEtFdVNleVZYZTR0R0MrNXVCcm82Y1ViM0ViallYTUtUeENDclF2N1BR?=
 =?utf-8?B?RFhFT2t4MzlQaU1QakpoZHNoYnVyTjdhRUJGZ3pjWTZtRzF3RnRNYjZkSk4r?=
 =?utf-8?B?SkVMMGdWNXIydGt1VS9OcmtnNTdEMnhzcGo0NWRHTG1xcVNoejBwdHV2VWhL?=
 =?utf-8?B?dmFVa04xcFlUMXVaYlJTNFBxd0lkRDJWT2FaWGI5a0Zlb0RJQW4vTzBwL0xp?=
 =?utf-8?B?MndLMGRRSU1nN3RZSktsejNPZ0drMEVyV296ZFVRaWJ1NkNtNllwWTJHOU5u?=
 =?utf-8?B?cWVObENrWDN6NmZsZkVRQlhGeE91SWRQTmVUY3NhSkFESnBYWk54a01xeWI4?=
 =?utf-8?B?YXo4OGx5YWQzSTJyOWFvNUsrWktJZ3BobGp5d29qeC9zQ0I1SGF3S1JKcVZH?=
 =?utf-8?B?c0RmdlYwK0RnN1BKM0p1MURoN0hpU2hRQXJSQyt3SEtMSUZhWUMwOUlQbjg3?=
 =?utf-8?B?WktpWTVadW10NFI3cHpkbGVEMEZIeHpiTHM2aWNRa0JSejFTbTdRVi9maGx5?=
 =?utf-8?B?bGlheWN1UE5aa01iZWtFdWwxTE8wd0thaTBaOVJSU1FVZURoUDhsT25UQlJC?=
 =?utf-8?B?M2RvWWVZMlVrdFNTQVk0SVJWZmtGNFFzaHdMWGRvckZKL21qdFdkbkFiRUtn?=
 =?utf-8?B?Yk1lbG1KejRuWE5iZmp5QkxZRG5ESldPTG5Hcys5S0drcTNId01EZW1CTkZB?=
 =?utf-8?B?enQxb2g4VjZVUE5EaWNobG4wdXdqc2o2M0xHcjNIUnJkU3VyVjIwSSttajVo?=
 =?utf-8?B?bVhZd3oyNFJEZ2RpbWd6NzdHd2s3aGErdyt4SGdqTXpZVXJPWGxMdDdSVHlZ?=
 =?utf-8?B?ZUhlekhhRFM4cTBoL3hKKzhxUzJEaForMDd0SlAvbDh6WWVFWU5oZmxxMlRQ?=
 =?utf-8?B?NGlrNmd2dWw5Vk1DL1VuOU5hM25OTWt5Z3p5d0kzUENDYWZ4MGFXUXNVWEcw?=
 =?utf-8?B?MHJ5eFhlSUd4bERXSWdpUTNQNytvaCtBenhCeUxQZVYxUm9aT0lQRktsa3lN?=
 =?utf-8?B?WVFSaytSZjlsQjFXOHBhMkdYa3praUE1YmNjU0crRnBUNmpVMkl1SHFOR2F4?=
 =?utf-8?Q?MsNem2RglR/0RMabeZYvokYx4Jb5bWuc?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3472d944-1ccd-4ff2-6df2-08da0c5e6cf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 23:48:12.0779 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5VBmDgSaWsdtdRkxlDbDx9dDXGK46i2ofW0ei3flrcJWKetnu19288tMyEqO5w9KZGNbv/eSgYzlVLieF4mqKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10294
 signatures=694350
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0
 mlxlogscore=891 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220119
X-Proofpoint-GUID: wu0cdQmiCMZRB22hIRjakTZajdUVw11K
X-Proofpoint-ORIG-GUID: wu0cdQmiCMZRB22hIRjakTZajdUVw11K
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v6 2/6] x86/mce: relocate
 set{clear}_mce_nospec() functions
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
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "snitzer@redhat.com" <snitzer@redhat.com>,
 "djwong@kernel.org" <djwong@kernel.org>,
 "david@fromorbit.com" <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "hch@infradead.org" <hch@infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "vgoyal@redhat.com" <vgoyal@redhat.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D475B32BDF336B40A1E65B545A6751DA@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/22/2022 3:41 PM, Borislav Petkov wrote:
> On Sat, Mar 19, 2022 at 12:28:29AM -0600, Jane Chu wrote:
>> Relocate the twin mce functions to arch/x86/mm/pat/set_memory.c
>> file where they belong.
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   arch/x86/include/asm/set_memory.h | 52 -------------------------------
>>   arch/x86/mm/pat/set_memory.c      | 48 ++++++++++++++++++++++++++++
>>   include/linux/set_memory.h        |  9 +++---
>>   3 files changed, 53 insertions(+), 56 deletions(-)
> 
> For the future, please use get_maintainers.pl so that you know who to Cc
> on patches. In this particular case, patches touching arch/x86/ should
> Cc x86@kernel.org

Sure, thank you!

-jane

> 
> Thx.
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

