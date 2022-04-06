Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 240B7C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Apr 2022 17:34:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-97Qkj47IMAaQZCCBzvkbfg-1; Wed, 06 Apr 2022 13:34:35 -0400
X-MC-Unique: 97Qkj47IMAaQZCCBzvkbfg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2819811E9B;
	Wed,  6 Apr 2022 17:34:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8B243145BA45;
	Wed,  6 Apr 2022 17:34:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 72238194034C;
	Wed,  6 Apr 2022 17:34:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 740A81949762
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 17:34:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4557D41617E; Wed,  6 Apr 2022 17:34:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FFFF416177
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 17:34:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B79741C01EA8
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 17:34:27 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-HowL1SHLN06mfmtGi-AOyQ-1; Wed, 06 Apr 2022 13:34:16 -0400
X-MC-Unique: HowL1SHLN06mfmtGi-AOyQ-1
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236HPHCC024447; 
 Wed, 6 Apr 2022 17:33:58 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1t9sps-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 06 Apr 2022 17:33:57 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 236HFYDb039625; Wed, 6 Apr 2022 17:33:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3f97tsbw9w-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 06 Apr 2022 17:33:56 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by MWHPR1001MB2142.namprd10.prod.outlook.com (2603:10b6:301:2c::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 17:33:54 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 17:33:54 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v7 6/6] pmem: implement pmem_recovery_write()
Thread-Index: AQHYSSYi+xuR0MG2lky15yeHiEHmQaziWhwAgADMj4A=
Date: Wed, 6 Apr 2022 17:33:54 +0000
Message-ID: <8f9a33bc-f4ae-0cc7-3db6-a516f246ed14@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-7-jane.chu@oracle.com>
 <Yk0jaC9rHwwoEV11@infradead.org>
In-Reply-To: <Yk0jaC9rHwwoEV11@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 142e4883-27ba-49de-5e95-08da17f39f54
x-ms-traffictypediagnostic: MWHPR1001MB2142:EE_
x-microsoft-antispam-prvs: <MWHPR1001MB2142F46C1FC45C6276E227C0F3E79@MWHPR1001MB2142.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: UhBdfaY58mKEJm/gpEEhCMykC6QJWYybXkmDWpRpWSuMKTzUVd8DlIV8d07cypbcxFmrvWulh3Rz25lAUbIX893gxymkv0WssYl7RDCtHMytzJI42w90zOEi1/j/hCu7ZUy5etlY3KVE38pNd8Ba7Pm8C8+cuVBxT/SbBGW+sZHNwMDa8IBCa6PNHSAVwJyxFH/56uExCE7Y2SLJOHLNrF3KhwMG0lCvzxPrQccp37cYTYItic3S9Aeyw94QXORRvnOF4h61oLMqRAZS2rPvCfcYdmmiKPI9vdIv4ivktCNe8IOl5MbtC18n9XF7gZiACUxQchVxoD5AtpaJLFDbXPlX5BvTBn0G3mS6Scy80JApZBgfdQFFq5VyhSAMncyfteoe53CPjkc+8uVrcjm/RQqyqEINJCZGFcquxUFiF/bpW/H5nOCi46HsFyOj69QyPiHC/BzcYJwuCxj7gNA8WHKZrl3iSQX7ZNfW0U9fRWTz9XxAoR+T9higy62DczuxMd/6AcZyxR8Gy651RoVLuPjLC59E2sUKqmvL2SJDV/IM8eZm1pRFvvune6qfzHLbmS+yXeO/5QmghSjFxJN4apl0sswZmZsP23zwCaqZ7JWyfrZarTTUVtr0LSJZUX9Bsu2vn58lMoA8wUVfCauShATPMTaOI1/oz57nE4JfnchaZEx3PkPKE2nNg6z8HY6bFiVhnr9OgNCNMSpAPLMHqaxQEuRsDqgFb7msysXE/YJHmrOrvzWd6ikzRmZ8qZOhECYFP+1AB/9e5bpxt6OuHA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8676002)(66946007)(64756008)(4326008)(186003)(76116006)(26005)(66476007)(66446008)(66556008)(31696002)(2616005)(2906002)(4744005)(38100700002)(122000001)(5660300002)(86362001)(7416002)(44832011)(83380400001)(316002)(8936002)(31686004)(508600001)(38070700005)(6512007)(71200400001)(6506007)(53546011)(6916009)(54906003)(6486002)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzhrUHhGTW01SFlUQ0t1REl2d05GS0F1V0JxeXh0bUNSajVYRjFzcmtWUkFN?=
 =?utf-8?B?amdHMXZlMmgrYmdlalRSalNleTErSWtGSVVpa2k3bnp3elZYMG13TEpUZnV6?=
 =?utf-8?B?SmRuamRHL2JMK3h5OFRsam9wUTBibHN3N2NFZXhDMmdGeHZiNXIyYjlJV3Uv?=
 =?utf-8?B?WEFBbTJpbml2eWV1VXgxdWdJS3IraEdkcnZFNk5HVWFHdzloRWRnYTdKQ1Qv?=
 =?utf-8?B?SDFhNUl2TTN0dUxWUjFVaWg3dUJZQ0VYL0F6TkwwSGZNM1YyTHlESU1ib0Vi?=
 =?utf-8?B?SGhHSG4wb0NPQUo5NlFoVVZuNXBBaXc2YmNJNDRTb2g5dkpIUHhWSVlsc25V?=
 =?utf-8?B?OXlMcU01QjdPM3JqY28rN0dqakQzUnhhQ0RSUUNhcG9DeTNxR1pIT3N5TmRK?=
 =?utf-8?B?ZWZqbENtazJHOGpBVHBWZ3JWbEhPVzRaRGlBRloxalpKT0lWOHBJbVROOFRv?=
 =?utf-8?B?V2hYM09NTE8xaXpLaDlibGtNckJHQTM0NkxOOFhuWUxRei9zMXViTWZrNzVJ?=
 =?utf-8?B?TWxBT3hoRS9xb1ltM2JpcW92RURNWkdLd2R1dzRBRy9tbVhwdEpCVlFORStm?=
 =?utf-8?B?OVFhTUkwbFE0Vm5xRU1NK2FKVnl4cTBubXlwQng3c2p1cjVIUTZLZVpuQ0Er?=
 =?utf-8?B?dHJDcmpTSnA4THlmdVl4UjlXYVBGTGJiSE96dElZeC90WUpna3A5RTdQVjJP?=
 =?utf-8?B?Z1RRc0g2RzJZbVNFNjRoSHkweGRZaERGSEVjRS9vZ1ZkdU1PS0NKU0R4Vy8z?=
 =?utf-8?B?eEdHQnQzRGorVll6TTZKZExtREhBQ3BZajJyKzJzenBoU01hSnNycUlMbWw2?=
 =?utf-8?B?ZkpickpIRlpOMHJOeGRVc3VjTzQ4SnR5bjBadUtaWFI2eS9FUytzdmdpTEdP?=
 =?utf-8?B?Y290NExXSWJuUVJ0YlNFd1JZTVVXWDBLMEpSeGpGNFZ1VzExNjJKSW1ybFhX?=
 =?utf-8?B?MS92aDEwTVQzU1RCZ3BOaWtsVVB1RzdGS2ZQUzlQVWJrNXR6K2dyUWdEQ1dt?=
 =?utf-8?B?MTBIbVI0bngwMUtUZ2I3aWE3NUNLUEtZMmQrc2JiMGZUTlM0N053d1lMcVpH?=
 =?utf-8?B?MVRpVkxNRnkzYnZvSDhSdnA0bmVNVzhmeGR1c0lEd3NxRDhaUlVvK2tvWHk5?=
 =?utf-8?B?RnZVQVVvTGRwZkRRRityVmM0WEp0UFVUVGxpNVRmRUdOWUhZaDZtSk43QUJU?=
 =?utf-8?B?MDRsSEFjU1Z2UnlDdk5YQkR3TFJqZ1d6bVVCcVdLcHd3WlhNS05sTU1rV2x5?=
 =?utf-8?B?SmlUMWI1djFGcGViWFlmMkJ2NTN2eEd0Q3VjUjVoZFRINm5CeExmOWVkQk45?=
 =?utf-8?B?eEJDVjEwY0p4ODJzdi9BT1BJU08waWd5c1JmTnUrYnZnQzRNclI5WG1pNEVh?=
 =?utf-8?B?eWUvQU9nK0NLMmtpUmZZRjNjMEk4ZFA0ZTZEODJJdDlHaEgwa3JEbHJXaVM0?=
 =?utf-8?B?Nkg5QzA1NG5aV284THl4MDBqY2JQTEV0anMvWFI2bGs5Z3VCNXFMd1ptR0NB?=
 =?utf-8?B?YmRqalVTVW5LaVhjdndyRUxXZlV3RmNza29QcVVzSTVrU253S2U3Um9UYXky?=
 =?utf-8?B?V2VtOFVrU2pWSVBxVjVtZnFXbHRRSjM0NmsxQXM0bFl2REZUZW4wcjFaSk9z?=
 =?utf-8?B?NE1vUERhSUxkL3ppVFFFMkhRNExhVGtpZG4wSEgvVDV4eDdtck16ZFRnaWNh?=
 =?utf-8?B?bkJGbVhlS3Zmay9VV1pnbTFzVWNQRVZGSVNodURENy95MHBlRW42VkkzMzdF?=
 =?utf-8?B?RnZqVDE5b1plNE1Memg0QjFsdUxMMGRndURZaXhzdnB4YU5DWlBhZ0I5UGkx?=
 =?utf-8?B?OGkrM20xZktLMGx5K282UXlZUDNrcGZlKzRGVDFINDhOTjNjbHhRZWpiY2JK?=
 =?utf-8?B?SnZmaExaSUlBTzd6OFN4QnRxTFMxOE9mREh0WjlKMk5xd0xRdVQzUXVUMm1w?=
 =?utf-8?B?QVlTcVlLdUFpS3NpK05XcHoyMmNXQjVBZ3RBaHByT0J4SXcyUzNBOWdKOTA2?=
 =?utf-8?B?NU41ZW9rT28zRTgzb2NTNkFHb3Ywbmd4d1IvVy9LRUx1TTVlVEYzUE40M2Fx?=
 =?utf-8?B?VFJPTE5YaFNGaUNIVHJFRGhvdmtjMTBDTTVkUFR5bUpxN0MycnJVTW5UZW1o?=
 =?utf-8?B?WDVYZ0J5MnVnUCtXZERhWUVybm9wSEliUXk0UlVibE1rMWF2NTdPbmlZenJD?=
 =?utf-8?B?UHU5VTNqSGI1ZGxZT3pSc0MzRUMvRGVZODQybkxCSWc0ZFRFaG9YNCtkb2hp?=
 =?utf-8?B?KzNpSWswSkRaeW5vZ1lIUmlMVU4rdDdYRm1ydkhQbW80TDhzbGRkWVRkOGZF?=
 =?utf-8?Q?WhawQW51WoVArU5VVs?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142e4883-27ba-49de-5e95-08da17f39f54
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 17:33:54.2695 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b9faPc+9OAuXAlVDq95ApMSupLNNW7qBFDHXfmacA0BLZLKauEDfVokfKqlwede39942nwh+SmHV4aAfCR/HKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2142
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425, 18.0.850
 definitions=2022-04-06_09:2022-04-06,
 2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=826
 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060086
X-Proofpoint-ORIG-GUID: EsFOo11MhzS3hjK_aVyPsNAgRbzyT249
X-Proofpoint-GUID: EsFOo11MhzS3hjK_aVyPsNAgRbzyT249
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v7 6/6] pmem: implement pmem_recovery_write()
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
 "djwong@kernel.org" <djwong@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "david@fromorbit.com" <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "vgoyal@redhat.com" <vgoyal@redhat.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <E76FF98E74FBF54DB967651B7B9E17D7@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/5/2022 10:21 PM, Christoph Hellwig wrote:
> On Tue, Apr 05, 2022 at 01:47:47PM -0600, Jane Chu wrote:
>> +	off = (unsigned long)addr & ~PAGE_MASK;
> 
> offset_inpage()
> 
>> +	if (off || !(PAGE_ALIGNED(bytes))) {
> 
> No need for the inner braces.
> 
>> +	mutex_lock(&pmem->recovery_lock);
>> +	pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
>> +	cleared = __pmem_clear_poison(pmem, pmem_off, len);
>> +	if (cleared > 0 && cleared < len) {
>> +		dev_warn(dev, "poison cleared only %ld out of %lu\n",
>> +			cleared, len);
>> +		mutex_unlock(&pmem->recovery_lock);
>> +		return 0;
>> +	} else if (cleared < 0) {
> 
> No need for an else after a return.


Agreed, will reflect your comments in next rev.

thanks!
-jane
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

