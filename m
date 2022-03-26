Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A53FC433F5
	for <dm-devel@archiver.kernel.org>; Sat, 26 Mar 2022 06:32:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-TM6fWrZ7PBOtQ3CmW33B4w-1; Sat, 26 Mar 2022 02:32:19 -0400
X-MC-Unique: TM6fWrZ7PBOtQ3CmW33B4w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4078B101B44C;
	Sat, 26 Mar 2022 06:32:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 88540112132C;
	Sat, 26 Mar 2022 06:32:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5125419451F2;
	Sat, 26 Mar 2022 06:32:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ABD0219451EC
 for <dm-devel@listman.corp.redhat.com>; Sat, 26 Mar 2022 06:32:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 89F1E142B94D; Sat, 26 Mar 2022 06:32:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 84DC31457F1B
 for <dm-devel@redhat.com>; Sat, 26 Mar 2022 06:32:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 667EC803524
 for <dm-devel@redhat.com>; Sat, 26 Mar 2022 06:32:13 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-gt2dcFbRMGGgpiBha-NOGg-1; Sat, 26 Mar 2022 02:32:09 -0400
X-MC-Unique: gt2dcFbRMGGgpiBha-NOGg-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22Q1uSdS004721; 
 Sat, 26 Mar 2022 06:31:40 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
 by mx0b-00069f02.pphosted.com with ESMTP id 3f1sm2864j-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 26 Mar 2022 06:31:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
 by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22Q6Hfsd165703;
 Sat, 26 Mar 2022 06:31:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
 by aserp3020.oracle.com with ESMTP id 3f1tmy87j8-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Sat, 26 Mar 2022 06:31:38 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by DM6PR10MB2618.namprd10.prod.outlook.com (2603:10b6:5:ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Sat, 26 Mar
 2022 06:31:36 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::2092:8e36:64c0:a336%7]) with mapi id 15.20.5102.017; Sat, 26 Mar 2022
 06:31:36 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v6 4/6] dax: add DAX_RECOVERY flag and .recovery_write
 dev_pgmap_ops
Thread-Index: AQHYO1qr0XYuk2dPyEaDqgStF1AJhKzLIC0AgADrq4CAAG/9AIAEw72A
Date: Sat, 26 Mar 2022 06:31:36 +0000
Message-ID: <a904fae9-68ce-6035-8aa2-5d43a3882d79@oracle.com>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-5-jane.chu@oracle.com>
 <YjmQdJdOWUr2IYIP@infradead.org>
 <3dabd58b-70f2-12af-419f-a7dfc07fbb1c@oracle.com>
 <Yjq0FspfsLrN/mrx@infradead.org>
In-Reply-To: <Yjq0FspfsLrN/mrx@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a414cb8a-5c54-441e-911e-08da0ef2471f
x-ms-traffictypediagnostic: DM6PR10MB2618:EE_
x-microsoft-antispam-prvs: <DM6PR10MB26184AED5534BAF5E4AC5AA1F31B9@DM6PR10MB2618.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: PW2FJJ4XTr7zI5m+q7uHkmcO/7rzRmw/DK1fyH7eTfrF4GxgdAuYehDtxdnTk+AAnSayt2PM7L5eyXBpzXrH4V4zZaNn6HFCD8zwOABTwt2nXJAWW/4gnkCjpmiUjTKoou5cSfIseI+kOTBxOc3YB0seCYh7kXyvVmqoVGXFCq9MBORiK2fNdSOfV5th03eE2h6kcqIjiYBfH79QbPRU8Wavn5s7UuN7dCb92L4XiFkpd7sLU8tIgxOy7N2uWH+eR5/ooeRBfjn2YRZetZj07/eA52ou5He5wrI9FXlHYVGG65//i5C76bWrYlC4C7PiNVvWbUdfERqFIpps78RGt9HVloBLXUt653POtakMuySs/AwKFMjryYyvv1oZL7V9wFDlPdCiNHLykBYFMS4RY+lfimKxwlKxHWYf4i8m/MwVBIMeZq1NS9TyiBUL/46SAPX1r8BDn8/b2lmjESPhvUyoENZlEGM69iZFJG0li4WpKijMlv0ejAFrHVGynFmZUBlpo8+wcIzN58borCopQKvslH7TcmLlA9GCgzqCcbN28EjZKI4Zzb4N4qilFjnozBwOw5ZLA85WNJew34ydnPEdrvMs2ji525H5fsFFcnDkRuLIhV2ge6pqlRta8Gfr7ikf1ZNgDclFVSEqneWP+dnt/OOFMgaqTWMYi/Sz37iLCmSSf0ahZSyA7dkRxWhZlAtxYlwvO6569OimNmSWIPSdPz+fKt2qtcEMqminNxzXcp7xerxAt5Ykmk3dB0hEbaMj2C1oMaIRxhaFmHLJNoPrk5eV4+lwUvpKhV+uUF/6YzEdZMGXYF3Nnq//mixPtR23evT9s2y7UwSeZ7ou8ciG9UYDdPLxch9xkH05P48WagmpO7H+X44AtqSwokUo
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66556008)(66446008)(66946007)(64756008)(66476007)(4326008)(8676002)(6486002)(91956017)(83380400001)(186003)(44832011)(6506007)(26005)(508600001)(86362001)(6512007)(2906002)(53546011)(31696002)(2616005)(76116006)(5660300002)(8936002)(38100700002)(6916009)(54906003)(966005)(7416002)(122000001)(36756003)(71200400001)(316002)(31686004)(38070700005)(142923001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TEZ4bUxUckJxN2g0YkNPdEVqZlBRbEJOTzErcm5Mc2tyd1UvcXpjWHFCT0Rq?=
 =?utf-8?B?VnBId3FZY21BSTVsT0NXbVpKcUc5aUU4TFptbGMybU1QSEhjcWt5MzU4YmpR?=
 =?utf-8?B?UGZTdnBtMjQzTXE5cldXWDArVHlsTEdRSWVvZ20zeWxuRzJvRS8xQXhNNTM0?=
 =?utf-8?B?SkFjTDNDRzVhNHZFNmg5YmtGZGIrUE5JMnpWNlhDajNxZmJ1U0NTM3hqTlhU?=
 =?utf-8?B?YVRrTnJ1YkxCT2puSWprOXlBZVkzMGF4ZWFESXU4UFYyY3N3ZWw5WnFmbTRW?=
 =?utf-8?B?M1NwZ3ZleWk2K2dZRW5zdDhaZWZvZk5BWWsramlBQU94MDJ2MGtneFhsMklu?=
 =?utf-8?B?TXpxMGRrMHR2MTVoeVU5Y0ZlS2xGc2JrdDIrQ3NDQkFWSjZxMzg5aWdSRWx6?=
 =?utf-8?B?eEF2bys3dGlhUDl1R2tDK281UzgvcjQ4a1BCVkJWL0RtK1V0NW91TDZKTVRn?=
 =?utf-8?B?b3VwYWVlMUQ2blMwZjczeGM4VnBiL1ZnazNxRzAzdVRVV0hNaU8vWkJ2dW8w?=
 =?utf-8?B?b3JSVGdQbFArTnNtVDNXcTY2aS8zZ3VDMlN1VE85NGdFamJqdzMxMmd3VVFi?=
 =?utf-8?B?Z1BScG45aTZNS1BISWc1eHVWQklxOGJEWll4K1BNWjF6WHlWU0VWazE5Yyti?=
 =?utf-8?B?aEovMXpIc1JpQ3FacGhMWmthbldtUEEvcGRGRzNvMG4vYUVPa3ZUam5NOU9x?=
 =?utf-8?B?MjN3NnlPRytDYk5sTGNxZU1OMlRUSnROOWZINDNXQ3FlemNrT2daZVZxQ1JO?=
 =?utf-8?B?TTlUWUwzVTB1VXJDVHd5R3ZMRVRsU2RrNVhPNEdhdDJic0VTcU52MXM2d2wz?=
 =?utf-8?B?YzBnT1o3aXJCWmZpSFB1OG1pWjNLZ3hxWDUxRGxLdHkvd1pnbUI3cWR4WUFP?=
 =?utf-8?B?UVJGRkVhMVlzVjBOY2M3amUwZnkvV1VPaG9LUS82b0lIYWhuQ00vQXNGaDFu?=
 =?utf-8?B?TjZ5Z05yaWtaQVNsTERpdmd2VTVxRmhWalBLK2VCaHM0ZFo4cW9tTGQyN3I1?=
 =?utf-8?B?M0pzRitvSWhBd0JRRCswd0xhczRjNThIZ0ZuRldQNVBmWW41dXdLaHVCTUd6?=
 =?utf-8?B?Q0haRWZ5c0RYVDIvVjVpcHhCSnBhVisrSFlUQzZhdnVCMmlnZEF3K0RZNVJV?=
 =?utf-8?B?Y1psbW43NVh6c1R2dVpvN2dNazh4dDJqT2ZRZ1owejFCOFo5aTgwTnF6UlZn?=
 =?utf-8?B?TDFVT0poTnpuL3ZrWi9UQ2FXaVduRkR1QXdpZDZqbWxiaXlQTjlYeW01U1NI?=
 =?utf-8?B?TXdvUjE0NUgrREozUHlMUThQSDQ5UmIwQ3RHdnVjQmVHSlIxdHdRcCtLNS9q?=
 =?utf-8?B?SVM1RFdQNGVUN1hjNDF1cEdWRis4TVYzeDRWL040NTJvN2lxanVDQzh6ZkJZ?=
 =?utf-8?B?UWlVTWlseVZEeWYzNmYxVWJrSC9yNjdFanYrVE51N1pqRThVR3A0TmlFbXc2?=
 =?utf-8?B?bHFyVitHQmdkUUtpaDc5RXpJTXVjRDZaQ3doOGZjVWZLUHRyc29aWHFlQVVH?=
 =?utf-8?B?VVQ2SXFVUFpjTUE0NEw1SUlhRSs5eFpHK2doSGZSeE5qb2VPVkZvWUhQUGRB?=
 =?utf-8?B?ZzlmSWhjc0E2QnFZUmt6ZFR5WE00bktSTXQvU01SRkNEazUxSllUaGUxTEUw?=
 =?utf-8?B?c0t5dVFYSEZSS1dFZGw1U291SGVBRXIvd0xDMXJycEVXZ1NBU0xpM0NZZUxq?=
 =?utf-8?B?cGlmVUFGWlNITmxKRVZjY0dzODJnVVdHK2NWWEVrMDlmVllPTFhidGdadkMx?=
 =?utf-8?B?dzZNa2JGWTR5ZkVXLzZLRzNIVHlnTC9sRjltMnk5MzZCUlpMQ3RtcmpMR0dS?=
 =?utf-8?B?cXJlUTYrd3I4VjRHYzcrak94eEhqUFVnSmFENDNVRHZ0cHhvcHQzYTVlUFNR?=
 =?utf-8?B?TVNvRlVFTUtnQnhHMUh3VlNiNmdkczlvd1ozdWV1Rk9nM1ZDQ1FwRFYya0Rq?=
 =?utf-8?B?YWdNZTlIL2pKNWNaUXR6VVYreTdLOTdkQTVaWkNPLzQvY0VVNHZnRHl2V3ho?=
 =?utf-8?B?TWNQY0VoaTlPRElKdnlyL01CT29ZZUMzVFNJNXc3cFZKOTNmL1RWKzkzRWJH?=
 =?utf-8?B?empWUThzRjQrcm9OY0toL1BZb3RxLzREOU9yaWpjUktYQlFWd1hmbjRZODg4?=
 =?utf-8?B?bUVNSk42NjJtczltNW1kYXV0OFZaeHJDTFZ6cytoU0xHRjRIejkrZFFscUhK?=
 =?utf-8?B?bnRtWXduc2QxYnNkcmxhNFJ1U0NmZlBCNm5jSDlkY3pKVkdOV0J3YWRaMFFr?=
 =?utf-8?B?UEJKT0tYNkoxbmtoQW92b1I0ZXhETkJDSUhGNktBWG1OcGw3ekRiNVppQjhV?=
 =?utf-8?Q?If1mlzs3xLp3c53c0z?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a414cb8a-5c54-441e-911e-08da0ef2471f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2022 06:31:36.3379 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pd6FBlwWV0I3snWcZw9TqjJ2U8GOLVniKFJlKxbPw5Rm6J9gfoxltvSzYutVUoUx5o21Db46l957TsejMwQYGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2618
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10297
 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 malwarescore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203260040
X-Proofpoint-ORIG-GUID: bMEH5HttZkKQc6uQJlmMP5bciMKjeW90
X-Proofpoint-GUID: bMEH5HttZkKQc6uQJlmMP5bciMKjeW90
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v6 4/6] dax: add DAX_RECOVERY flag and
 .recovery_write dev_pgmap_ops
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
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "vgoyal@redhat.com" <vgoyal@redhat.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <029A55B7B30600478DC6D8E5DF8DB447@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/22/2022 10:45 PM, Christoph Hellwig wrote:
> On Tue, Mar 22, 2022 at 11:05:09PM +0000, Jane Chu wrote:
>>> This DAX_RECOVERY doesn't actually seem to be used anywhere here or
>>> in the subsequent patches.  Did I miss something?
>>
>> dax_iomap_iter() uses the flag in the same patch,
>> +               if ((map_len == -EIO) && (iov_iter_rw(iter) == WRITE)) {
>> +                       flags |= DAX_RECOVERY;
>> +                       map_len = dax_direct_access(dax_dev, pgoff, nrpg,
>> +                                               flags, &kaddr, NULL);
> 
> Yes, it passes it on to dax_direct_access, and dax_direct_access passes
> it onto ->direct_access.  But nothing in this series actually checks
> for it as far as I can tell.
> 
>>>> Also introduce a new dev_pagemap_ops .recovery_write function.
>>>> The function is applicable to FSDAX device only. The device
>>>> page backend driver provides .recovery_write function if the
>>>> device has underlying mechanism to clear the uncorrectable
>>>> errors on the fly.
>>>
>>> Why is this not in struct dax_operations?
>>
>> Per Dan's comments to the v5 series, adding .recovery_write to
>> dax_operations causes a number of trivial dm targets changes.
>> Dan suggested that adding .recovery_write to pagemap_ops could
>> cut short the logistics of figuring out whether the driver backing
>> up a page is indeed capable of clearing poison. Please see
>> https://lkml.org/lkml/2022/2/4/31
> 
> But at least in this series there is  1:1 association between the
> pgmap and the dax_device so that scheme won't work.   It would
> have to lookup the pgmap based on the return physical address from
> dax_direct_access.  Which sounds more complicated than just adding
> the (annoying) boilerplate code to DM.
> 

Getting dax_direct_access to return pfn seems straight forward,
what do you think of below change?

--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -195,10 +195,10 @@ int dax_zero_page_range(struct dax_device 
*dax_dev, pgoff_t pgoff,
  }
  EXPORT_SYMBOL_GPL(dax_zero_page_range);

-size_t dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
+size_t dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff, 
pfn_t pfn,
                 void *addr, size_t bytes, struct iov_iter *iter)
  {
-       struct dev_pagemap *pgmap = dax_dev->pgmap;
+       struct dev_pagemap *pgmap = get_dev_pagemap(pfn_t_to_pfn(pfn), 
NULL);

         if (!pgmap || !pgmap->ops->recovery_write)
                 return -EIO;


--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1243,6 +1243,7 @@ static loff_t dax_iomap_iter(const struct 
iomap_iter *iomi,
                 int flags, recov;
                 void *kaddr;
                 long nrpg;
+               pfn_t pfn;

                 if (fatal_signal_pending(current)) {
                         ret = -EINTR;
@@ -1257,7 +1258,7 @@ static loff_t dax_iomap_iter(const struct 
iomap_iter *iomi,
                 if ((map_len == -EIO) && (iov_iter_rw(iter) == WRITE)) {
                         flags |= DAX_RECOVERY;
                         map_len = dax_direct_access(dax_dev, pgoff, nrpg,
-                                               flags, &kaddr, NULL);
+                                               flags, &kaddr, &pfn);
                         if (map_len > 0)
                                 recov++;
                 }
@@ -1273,7 +1274,7 @@ static loff_t dax_iomap_iter(const struct 
iomap_iter *iomi,
                         map_len = end - pos;

                 if (recov)
-                       xfer = dax_recovery_write(dax_dev, pgoff, kaddr,
+                       xfer = dax_recovery_write(dax_dev, pgoff, pfn, 
kaddr,
                                         map_len, iter);
                 else if (iov_iter_rw(iter) == WRITE)
                         xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,


thanks!
-jane
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

