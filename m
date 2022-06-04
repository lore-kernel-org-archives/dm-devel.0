Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C42FC43334
	for <dm-devel@archiver.kernel.org>; Mon,  6 Jun 2022 06:46:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-OBtvvfMLMTy5jbj9rXHgMw-1; Mon, 06 Jun 2022 02:46:24 -0400
X-MC-Unique: OBtvvfMLMTy5jbj9rXHgMw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29E2A8061E0;
	Mon,  6 Jun 2022 06:46:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 15420492C3B;
	Mon,  6 Jun 2022 06:46:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C12519452D2;
	Mon,  6 Jun 2022 06:46:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E7A0C1947052
 for <dm-devel@listman.corp.redhat.com>; Sat,  4 Jun 2022 17:14:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D1CBBC27E97; Sat,  4 Jun 2022 17:14:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CB9FFC27E92
 for <dm-devel@redhat.com>; Sat,  4 Jun 2022 17:14:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD400811E75
 for <dm-devel@redhat.com>; Sat,  4 Jun 2022 17:14:12 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-M1jOI8fiOuaSjYJ3R4M8hw-1; Sat, 04 Jun 2022 13:14:10 -0400
X-MC-Unique: M1jOI8fiOuaSjYJ3R4M8hw-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 254EdH6H018560;
 Sat, 4 Jun 2022 17:13:56 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gg91102w3-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 04 Jun 2022 17:13:56 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 254H5mr1003190; Sat, 4 Jun 2022 17:13:54 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com
 (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3gfwu0a7p3-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 04 Jun 2022 17:13:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN6PR10MB1490.namprd10.prod.outlook.com (2603:10b6:404:45::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12; Sat, 4 Jun 2022 17:13:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5314.017; Sat, 4 Jun 2022
 17:13:53 +0000
Message-ID: <6cc818cf-fac4-d485-ea9d-0b8597f24a33@oracle.com>
Date: Sat, 4 Jun 2022 12:13:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
To: Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-10-michael.christie@oracle.com>
 <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com>
 <fdd77f3b-691a-a9bf-b31f-0aa845e68e59@suse.de>
From: michael.christie@oracle.com
In-Reply-To: <fdd77f3b-691a-a9bf-b31f-0aa845e68e59@suse.de>
X-ClientProxiedBy: DM5PR15CA0032.namprd15.prod.outlook.com
 (2603:10b6:4:4b::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8ea4fbd-c255-442e-eeaf-08da464d9980
X-MS-TrafficTypeDiagnostic: BN6PR10MB1490:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB149049E44CA82546832C5356F1A09@BN6PR10MB1490.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: fXBdX0IdrhHM7Gl9k8/vz3cXQbKAtZgzw+tBuL7s8PgcVnNPwrA/7M2Gply20ZcJx5j49eFdoMiBejiarzHwLhaQ3/NxxS/8L7wI1tg06DrdN34W7v0YB3o7doijXxYq3T4LMce89RGijjk7rzMc0AB7KXHt20minInQjhbWXGk01qW4nX29K+VoIPez3Vf7ZBGVpQXQExs78ah99VqXX9Of+8vPqKT9iro8AmyDVl37qtBo+FchNOpkEqDxQ5/jCfKF8ySLuvSePFighGP9dkN28DQ5/OuIEG6TFiNPh8VGmlzpnvToeQ8uIsXYprwJAV9Tx9ww5bxBRQmD7U+VOGhvYvLwCUd1mi7/nhHv8td8InjQm00M+2C0kiH8vo/pPTXiH2xiEzplYaIbjyg+lSWev0J9LT9R1D62KSfUSp46VlzZAPcbJQW4fmWCWceWXhskm5GjamhyG4oSywekL7MHgNK394Uj/Rc5X/JFVtfO48AXFINNxr+HGY5bCtsetki/0l3H4cEHYKbId8n+OyoqMulEZKqsSut4nwk7nsWjSN2bA4YJGzVIhBngFQ8br8d9svl++YnwZYh0ugtnBoucLGV/Efv4imfOpglQYTlS122bH4+/JxM9vGgi/PaY6LAJ3toVGAbcGZsf/m4NtuTImrGU7K5flT1opJvbMldp7k0bSLuQAllig+4wu2sDySe+XrNVQPMvETjX9WZkEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(31686004)(110136005)(508600001)(6506007)(38100700002)(6486002)(8936002)(53546011)(86362001)(31696002)(186003)(66476007)(66946007)(66556008)(2616005)(7416002)(9686003)(6512007)(26005)(36756003)(2906002)(8676002)(4326008)(83380400001)(5660300002)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0hjUHJHRm9RL2dESVRwK1ZQRlh0RExqT0JiYXhzd1RCSHdlaTJrVXNxYy95?=
 =?utf-8?B?cFFzdGVmUDBkdThuUW84aFJCWTNjZVFZYmJBU2JKYUh3bDVIbVdZbXh0N09s?=
 =?utf-8?B?Vi9TTnYwVzJ1SFF6M1UrNSsvbjRVVkZKazFOUytCVS8wdkpXZXBjYVcyNnZ3?=
 =?utf-8?B?ZFF1Uk5Da3R2dkQva3J5NWNxdEtPUXpCcTNWRHN1Wk0rdlkxU3hkR3RCUVVv?=
 =?utf-8?B?ZWtSRmhKOUZvb2JHeVQ5N3QzY0FLOElkak1Sc215em5wRlZLdktJVXdQTW9R?=
 =?utf-8?B?ZG94Tyt2eVdRK3pqZDgwQjdjRFBUaWVQVzVZNVI4YlhNRGFrcjF0OGxXRWNt?=
 =?utf-8?B?YUpzVHQrTVZIVHBSazc1MnpaMlJ0aFhEd0ZJcXZJQjJVVEVnTExhUStkeVJo?=
 =?utf-8?B?OHB6RkNQd2R1ckRIRnFYK1Y5eUhUb1BIdG9ERHdIUTVVMzhsVDl3K3BieE95?=
 =?utf-8?B?clh3SVFKQnB5TmpSQXEzcmlPLzFHUkVldk5ISkZMeVlJV1FPeDRrVWM1eHJH?=
 =?utf-8?B?WERPWUlic2Y1LzFTbmZJZlIwaFBjZGhrSGVlRU5uL2xuWEEvK0JhVEMvcU4y?=
 =?utf-8?B?R1p2VnBCT3NXZXJDQ3ZucGo0eElQUzJibzFDc2JobTVXaU0wTGw0eWt6Z3p5?=
 =?utf-8?B?ckgyQ1RadEp1bWh3ZG1kYW1Rd3l1RFBSdU5Fa3BkOG9WeEErMDJVby9Ndkh5?=
 =?utf-8?B?WXRxZWthZlZKdTU2UmllRU5Cd1BqNVkvMnVuYVhjcy81N2lQTUtxR2d3N09p?=
 =?utf-8?B?Y0wvbGhBQzIvMHdINithZTBpdUhMQVZiUzRhdjJWQUVpV1MrcER2M20vNDlk?=
 =?utf-8?B?TE1uZDd1c0JiVkROZ3lTMFdmUUdFSm5rNmpHN0ZhUWVsdGdmRi9SV1BTanhS?=
 =?utf-8?B?WndhU3dwTzdENXNyV2JNMVBUNWdjczVkbGFza2grT2lMa1pVTXRMKzFMZ2kz?=
 =?utf-8?B?bkVOanBsUVBzYTRObmtWTzkxQkhNMFR6K09xK1JlZ0FWb1IxUUdvT0QrSkRi?=
 =?utf-8?B?L1NjYkY5azV5ZlZ4OTZUYzF4M3J4djhRMlU4cnB3UStlMFdwSEZ6WWVnbEc1?=
 =?utf-8?B?a1VQd2dqck43UE50aVkrbkZDN2NDSDFvVEpTMkxEaHI3eWlyeU95enk0TS9K?=
 =?utf-8?B?dkpiY05WREkrUFU5Mks1bTB6WFgzdlp2b3VNQUtNZHRzTnpCcHo3UE5GNGlW?=
 =?utf-8?B?M2ZReis4eTNpQ29SR2UvakJrVEc0T2NkbG4vZmRqMXVoRjI4TGJNUVJTUElS?=
 =?utf-8?B?cEpIcmpCaGMyTFZQZlVGNFNEbHVESS95YnFCS0ZLelVoVS9GZ1k4V05jK1dN?=
 =?utf-8?B?SnVYQ0lvZ29pUkNEL2dKMmI0ZG1qVndLZE1BUmFmZnJLNVZnZTlJN2hLR3o2?=
 =?utf-8?B?S3hQbVI5VFYwMmI0ZzdTZCsyeUp2Kzk4OGNyOENTNC9HUG9PZHg1Z3RJOFMx?=
 =?utf-8?B?NmZwemg2ait1NE4ycVlqTUxnTXQxb21pa2dMVnV5aTAyZ0RmWXI2NzJHOWJq?=
 =?utf-8?B?SlkwSW50eEdMV2paelN1YWdwUDRNS1JiNUZxQXV0b1d4N2tLZVV0TXpEZGhx?=
 =?utf-8?B?akU4b0s3SVFudDc0N1NrSzFjMnNCcW02Q1dCREMzeTRSR1VzelpjZ3UyZ29w?=
 =?utf-8?B?VzR5Mmp0NTZGc0lOU01GWm4wYUNncGdveHJWMTJmYkJrajJ4MjlqNnlIMmpt?=
 =?utf-8?B?WFRCK0tZSXF5bVFBWndjcFZtY1BvZnFyZElrcnRrSFRJbkR6OTZ3eU9OMEtX?=
 =?utf-8?B?NEZqTzMzU0w0Y0Q3Q21jKzkvQlk5RllPb2tqRVJIbHVtZkdkb3dyVzBSWXMy?=
 =?utf-8?B?ZitsOUhVZ2wydzNnejVqZG9tbG85dERPdGZBOVRVZ3htdjJDS1V4QUdIZDJC?=
 =?utf-8?B?empKV3l3VHN2YkJuK3FhQnJxZm1PaHdCMUFoK1VjY2ZyZlExc0JralI1QVIz?=
 =?utf-8?B?RkxBMlJVQis5dDF4N2NzM1FnWFhwVy90SEcvQ01GMUNsb0lNeGtJQlE3bnoz?=
 =?utf-8?B?RWdNMGRkcktWTlFrMEpNTCtLVTR2RVhRRWpVVDlXZ0Q0ajQxSWQ1SDRmcjlO?=
 =?utf-8?B?cEJWRTlNbXZDdzZ1OWF1bVNGR0pESFdOaUNGSjQvQThtWmVPTXBpOE95eUtv?=
 =?utf-8?B?N2R6dUFDOVJtL1N1QlVFOXJ0NXRSVGFUbXo5OEFNOGFvQnRuaUZsODJJcDNO?=
 =?utf-8?B?L0xJay9kWVdEZ25vbXlWK1hMZEU0SVNSWnpGSzI4Wm9aaUtwd09DM0VISUFM?=
 =?utf-8?B?OXRxTzRKZ2kwcGdIU0VsRitUMkNVejUzbjBpRC9TZW9yNkhYMlUzYkhZSWdv?=
 =?utf-8?B?a1RhME9zcmRITTE5K0ZXdEpLRkFjMTVJZXlBNHRubDRuUUVxeklXcDlmRGRk?=
 =?utf-8?Q?SDLkDqruHthegFis=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ea4fbd-c255-442e-eeaf-08da464d9980
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 17:13:53.0636 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xENnlroWGAjOlGhBsIllWyUApEOYd+5eojd3SPy+CzpUmazKO1QENX0P539l+puf4QxARViFChNTdkxwVwX2ArWoyswshTnl+NhXflDMXjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1490
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.874
 definitions=2022-06-04_05:2022-06-02,
 2022-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206040079
X-Proofpoint-GUID: tn1Uek3G3aCdUTW-p35R3ezy-c2VKsG9
X-Proofpoint-ORIG-GUID: tn1Uek3G3aCdUTW-p35R3ezy-c2VKsG9
X-MIME-Autoconverted: from 8bit to quoted-printable by
 mx0b-00069f02.pphosted.com id 254EdH6H018560
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Mon, 06 Jun 2022 06:46:17 +0000
Subject: Re: [dm-devel] [PATCH 09/11] block,
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
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com, snitzer@kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNi80LzIyIDI6MzggQU0sIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKPiBPbiA2LzMvMjIgMjE6
NDUsIEtlaXRoIEJ1c2NoIHdyb3RlOgo+PiBPbiBGcmksIEp1biAwMywgMjAyMiBhdCAwMTo1NToz
NEFNIC0wNTAwLCBNaWtlIENocmlzdGllIHdyb3RlOgo+Pj4gQEAgLTE3MSw2ICsxNzEsNyBAQCBz
dGF0aWMgY29uc3Qgc3RydWN0IHsKPj4+IMKgwqDCoMKgwqAgLyogem9uZSBkZXZpY2Ugc3BlY2lm
aWMgZXJyb3JzICovCj4+PiDCoMKgwqDCoMKgIFtCTEtfU1RTX1pPTkVfT1BFTl9SRVNPVVJDRV3C
oMKgwqAgPSB7IC1FVE9PTUFOWVJFRlMsICJvcGVuIHpvbmVzIGV4Y2VlZGVkIiB9LAo+Pj4gwqDC
oMKgwqDCoCBbQkxLX1NUU19aT05FX0FDVElWRV9SRVNPVVJDRV3CoMKgwqAgPSB7IC1FT1ZFUkZM
T1csICJhY3RpdmUgem9uZXMgZXhjZWVkZWQiIH0sCj4+PiArwqDCoMKgIFtCTEtfU1RTX1JTVl9D
T05GTElDVF3CoMKgwqAgPSB7IC1FQkFERSzCoMKgwqAgInJlc2V2YXRpb24gY29uZmxpY3QiIH0s
Cj4+Cj4+IFlvdSBtaXNzcGVsbGVkICJyZXNlcnZhdGlvbiIuIDopCj4+Cj4+IEFuZCBzaW5jZSB5
b3Ugd2FudCBhIGRpZmZlcmVudCBlcnJvciwgd2h5IHJldXNlIEVCQURFIGZvciB0aGUgZXJybm8/
IFRoYXQgaXMKPj4gYWxyZWFkeSB1c2VkIGZvciBCTEtfU1RTX05FWFVTIHRoYXQgeW91J3JlIHRy
eWluZyB0byBkaWZmZXJlbnRpYXRlIGZyb20sIHJpZ2h0Pwo+PiBBdCBsZWFzdCBmb3IgbnZtZSwg
dGhpcyBlcnJvciBjb2RlIGlzIHJldHVybmVkIHdoZW4gdGhlIGhvc3QgbGFja3Mgc3VmZmljaWVu
dAo+PiByaWdodHMsIHNvIHNvbWV0aGluZyBsaWtlIEVBQ0NFU1MgbWlnaHQgbWFrZSBzZW5zZS4K
Pj4KPj4gTG9va3MgZ29vZCBvdGhlcndpc2UuCj4gCj4gV2VsbGwgLi4uIEJMS19TVFNfTkVYVVMg
X2lzXyB0aGUgcmVzZXJ2YXRpb24gZXJyb3IuCgpJIHdhcyBub3Qgc3VyZSBvZiB4ZW4vdmlydGlv
IHNjc2kgdXNlcyBvZiBCTEtfU1RTX05FWFVTL0RJRF9ORVhVU19GQUlMVVJFLgpUaGUgdmlydGlv
IHNwZWMncyBkZXNjcmlwdGlvbiBmb3IgVklSVElPX1NDU0lfU19ORVhVU19GQUlMVVJFOgoKICAg
IGlmIHRoZSBuZXh1cyBpcyBzdWZmZXJpbmcgYSBmYWlsdXJlIGJ1dCByZXRyeWluZyBvbiBvdGhl
ciBwYXRocyBtaWdodAogICAgeWllbGQgYSBkaWZmZXJlbnQgcmVzdWx0LiAKCmxvb2tzIGxpa2Ug
dGhlIGRlc2NyaXB0aW9uIGZvciBESURfTkVYVVNfRkFJTFVSRSBpbiBzY3NpX3N0YXR1cy5oLgpU
byBtZSB0aGUgdGhlIGRlc2NyaXB0aW9uIHNvdW5kZWQgZ2VuZXJpYyB3aGVyZSBpdCBjb3VsZCB1
c2VkIGZvcgpvdGhlciBlcnJvcnMgbGlrZSB0aGUgZW5kcG9pbnQvcG9ydCBmb3IgdGhlIElfVCBp
cyByZW1vdmVkLgoKSG93ZXZlciwgdGhlIHFlbXUgY29kZSBvbmx5IHVzZXMgVklSVElPX1NDU0lf
U19ORVhVU19GQUlMVVJFIGZvcgpyZXNlcnZhdGlvbiBjb25mbGljdHMuIElmIHdlIGFyZSBzYXlp
bmcgdGhhdCBpcyBhbHdheXMgdGhlIGNhc2UgaW4Kb3RoZXIgdmlydCBpbXBsZW1lbnRhdGlvbnMs
IEkgZG9uJ3QgZXZlbiBuZWVkIHRoaXMgcGF0Y2ggOikgYW5kIHdlCmNhbiBkbyB3aGF0IHlvdSBy
ZXF1ZXN0ZWQgYW5kIGRvIG1vcmUgb2YgYSByZW5hbWUuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsCg==

