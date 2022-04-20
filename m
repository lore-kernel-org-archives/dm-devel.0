Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEB2C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 20 Apr 2022 17:02:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398--U7Ist2hMsywm-Tw2Wh-8g-1; Wed, 20 Apr 2022 13:01:59 -0400
X-MC-Unique: -U7Ist2hMsywm-Tw2Wh-8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B70F29AB3FA;
	Wed, 20 Apr 2022 17:01:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D94512166B44;
	Wed, 20 Apr 2022 17:01:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 928C11949763;
	Wed, 20 Apr 2022 17:01:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A90F919451EC
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Apr 2022 17:01:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98D60572335; Wed, 20 Apr 2022 17:01:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 93CD2572332
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 17:01:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 746EC900763
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 17:01:53 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-lxgRz57ROhanOBCVMMMYJA-1; Wed, 20 Apr 2022 13:01:47 -0400
X-MC-Unique: lxgRz57ROhanOBCVMMMYJA-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KFGbnC024754; 
 Wed, 20 Apr 2022 17:01:19 GMT
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9hfd5-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 20 Apr 2022 17:01:19 +0000
Received: from pps.filterd
 (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23KH0iDA001476; Wed, 20 Apr 2022 17:01:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
 by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3ffm87thmq-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 20 Apr 2022 17:01:18 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by DM5PR10MB1449.namprd10.prod.outlook.com (2603:10b6:3:11::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 17:01:15 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5164.025; Wed, 20 Apr 2022
 17:01:15 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Thread-Topic: [PATCH v8 7/7] pmem: implement pmem_recovery_write()
Thread-Index: AQHYVFsWAZKeTRs39kii18Q/afzGwqz4Vm+AgACxWIA=
Date: Wed, 20 Apr 2022 17:01:15 +0000
Message-ID: <d48f9641-30e3-f459-2376-386c28a69026@oracle.com>
References: <20220420020435.90326-1-jane.chu@oracle.com>
 <20220420020435.90326-8-jane.chu@oracle.com>
 <CAPcyv4gs2rEs71c6Lmtk1La2g3POhzBrppLvM0pkGxx+QZ3SbA@mail.gmail.com>
In-Reply-To: <CAPcyv4gs2rEs71c6Lmtk1La2g3POhzBrppLvM0pkGxx+QZ3SbA@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b46f31b-33cc-40ed-b6e6-08da22ef61c0
x-ms-traffictypediagnostic: DM5PR10MB1449:EE_
x-microsoft-antispam-prvs: <DM5PR10MB14492279C619ECD4DCCCDD57F3F59@DM5PR10MB1449.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: wXLUefivyfvapuo1wDpmghojRrKZ+80hxgolOAzeACGG/ip9s7CDRTeMCkjc1XgSc3fl2QYG4OLU7X1GJIUGjKR2UEMySRFVJIuzH2dwIwveXIzMCcYWYM6cqFXrokKXsDBVWDG5qq60P3kPfG27145j4GYXfHcq/ga8QA0UE68AkNgAxUqfwZN8yE7xKWcrAp41dRi2SAQRWrR/jGtKI6N2OAD1JKKkID/NgJVlfmKdTyc9xMEKbrRnHawDc8QGrw6SVilXpVAi03uJLeajr+bAicZAG2MUWjbg2LdFcOErJLiHDNdT+ED3vgeH9qoA5hQl0rFWHIPRsb3KvQRpfIwvOzA5CpyAvUp5ii4I786zZ1Hfsc8kouhe5mxElH1vHgEgy+VjqrL0F/5/Mj8iFJNLDuH6TDxpmUyDXhgC0B5usa1LJwGeDRZlpoYjNciZP/Jk8lwz1eHAShD0ecSSTcwSwMlbs3bzOKFuMj5EJcYRzkb4av0Vs1Zr4Klcivuk2NVw77BxFTUdU6+G10GaeeSVxRKe5fjPyJaLXRbs2y4r/6zCa22EySI28a1q3qtSrCEJ0qRha6rrJgYPBDzZjW7D4BYblJeedOoxNFR9wC3r5/+JiSVYAXGEC6leTOL5esGWOc0xrE537QK/KyQGLJQOeXBf+K2Up10BZ+EFgU2TWUfWP/tun2OCqcF4ivvQfwoAKOoJNSmqZ8TVKK39ZQ4u+Cc+KDjovUvNq0qeSfjK0T+hMLoasZ732SpLK9iVjO7UrnPD3Ewqcul1PkrgZA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(2906002)(8936002)(8676002)(26005)(66556008)(6512007)(6486002)(508600001)(71200400001)(6506007)(7416002)(44832011)(5660300002)(31686004)(53546011)(38070700005)(4326008)(83380400001)(54906003)(66946007)(86362001)(2616005)(38100700002)(76116006)(66446008)(122000001)(64756008)(66476007)(186003)(36756003)(6916009)(31696002)(316002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDZaTmRrYUZNNmNvODhrT25sTUdiR3kyZ1hwTmVkZ3hEeTEwRWovRVV5VHJw?=
 =?utf-8?B?cjhWUWtablVvT1pYVDBlWW8xckV5by92Vk1BMWZyMlZJMzI5dnF5TkNwSUts?=
 =?utf-8?B?VUROMHZvUmsxdXFTM3VJQnFQMHFXQzR3eEhJazhDK3plSWlXRnRyYU9tZC91?=
 =?utf-8?B?SThlRW95Znk5WXFBTlU3Q2lERjNlcHhxTklucXBmUHZ5eDU3S21IaXg1amtD?=
 =?utf-8?B?TTIzVVFYY3ZCeDdMMGVWYUdSYWQ3d2dWWjlxNXlIbS9Qa0NqLzhIVFN0RjM2?=
 =?utf-8?B?NXM5WURtdzI5YitaY0JtcWx2WDBRa0VBRDd2RTVSeXBESkcvQmtManF0UGl3?=
 =?utf-8?B?REJGRE1Cd2VVQkd2cHlKV09FOERuUWpJV3ZGcW5XdUpqWWNSRmR3UVRYRjZV?=
 =?utf-8?B?L3JvYy8xZHBGSVE4MkczN09uSXQ1M01zaDlHY05ZaUE3Yy94eW5xWFhoQTV6?=
 =?utf-8?B?ak9mY3Y1WERLRnExNXFyMEdDdllZSjAzTTZsWGl3VEZpM2lGL2FOcVlGcHBn?=
 =?utf-8?B?dUlqNkxaQ2N4REdDQXJkVngwcFN6Vnp6ZlJFOVZvR1dXYjIzVXlFNGgreDBW?=
 =?utf-8?B?L0Z4M2FYbE1UQnBrR3R4alFDVU5pZG9JV21BT25UdFhLdVNYalc4OHdVRU9p?=
 =?utf-8?B?Y1REOGd0cmkyVGtWUUZacG9ha0JlYmhMY3FSVW9LTk9GL2oxY0pvZmVGMWls?=
 =?utf-8?B?cHNiOWIvUzFIL1IrRHhwUnQ3ZlZOT0o2aGFVc2d6RDl5cGN3Q2hQQWJEVmlS?=
 =?utf-8?B?V1B6TjFrK2s4SkFOOW5zZEZBcDVwWjlNelZYOVpCQlc5bmxDdWdaZkV6S21S?=
 =?utf-8?B?ODJEZ0Rnbm9hc05XSFZjVzdmWk5OWTZNK3pWUTZTdzR2SDJjNFBuUm1rQVNB?=
 =?utf-8?B?aHNMTVVyMHo4NC8zYS9SVEZXd056dlJhODhMcElPYlJsTU1qRG9FYUg2Qmlv?=
 =?utf-8?B?SWdRZEhaSXEwdTFRUnl4VHgrZ3VVV1VPaU0xRDI2a1dKeWdWQXN2SXQ0YkhT?=
 =?utf-8?B?eHRpckUyWDhocHYyUnNNaEgzQmNqbmh0K3lzajltaWxsYmRFZFA5aVFjVDFR?=
 =?utf-8?B?WlkrMDZWQUZDeCtlMG5Manl1THJScWNheW1mcERma2NiLzU4T2FoTlVEYjFh?=
 =?utf-8?B?eW9lODJycWphQnNWOG8yb3drKzZwMXlNOXBTMXI4cmRvS09YdG5laXhSSFZ0?=
 =?utf-8?B?TXU0eVFXM3ZOd0t0a2tWdzVkci9IdElpU1Y5cHdta2dRdzhBU0pZUkpFZWg1?=
 =?utf-8?B?Rm84eEk5cFRWL1Y5cW9VbGxpRWIyNy9iWThHM2hQZDFqWXp3TGU2TlpEdlJY?=
 =?utf-8?B?QW1xMlh2NkgxU3RWNzg5dmZIRTZveCtmSFMweUljYlM2Y1Z5TkJXY1lwaEg5?=
 =?utf-8?B?SkxPVDBXN09aK2dlZUJqb3l2N1RCa1RjSWlSUzVGYXhrTXQxSGN6a29RRzJo?=
 =?utf-8?B?MUJZTThtMUtzMjRialVGTGtaVHdpZ1FIczZtMnFoZWh0Q3NJR2FreEdLUEVk?=
 =?utf-8?B?YXEwK28xWGhMUGVENWxZRXNUWm1kTXdVRFREaEQ3QktaOTU4aUFLek8yS0Nn?=
 =?utf-8?B?LzNta0h3UnJHUDBNZHlESUdzcjlJUGZ6RjloeUdIbUFFdkF0Snd5UkRxZ01K?=
 =?utf-8?B?VENwUHNuc1M4SkNxcFMzQlpoL1grOEYreGYyVHJqQ3p6bWNRdXFyeEJwaGIr?=
 =?utf-8?B?eWF5TWRxMyszYzkvQ2Q0STlQRUpjcktEVDNWSWtFQVZhZUs2bDhpMXllYVJJ?=
 =?utf-8?B?ZTlkOUsvckxENlpxT0txck9wQ0FHOXQ1cnBYZjNnWFdaUkREbWhJVGFlNDcr?=
 =?utf-8?B?MHdWRTBPNUJVU2FWZ2Z0aVA3ZDhHM0MrbkE3S2JjRHI0M3ZuMDVYSnRkSmFj?=
 =?utf-8?B?NG9KaEVIUmJyQmJCdzg4b0hVVDdaaFVZVm1yQ081VldXQkFSUnBwUmVmR2xU?=
 =?utf-8?B?TmM1OUZnWmJvTXlJMWE1QWJYZ2Z2d0dYSkVEUEV5TTk2SGt5cG1oOE5mcEkr?=
 =?utf-8?B?RmU5Z212UTBVaForajhXRjFHMUEyV29vRnRYVXJNWldobnV2MmNJSGJDaFQ4?=
 =?utf-8?B?eWkwTUpoM01OMlFpKytMaTJQeEZZaEpwb1NablY1cDlTOU8xV2Z3WHl2MFQw?=
 =?utf-8?B?OGgvZisxaDJHZU1vaVAwQW1uZlhObk54cGlFM1RQME9RSWVHcEdWdFhBRG9R?=
 =?utf-8?B?d3NyNVdpZVNEVnN5SGROeWNkU3BkSk1jYkF4Wk5vL1dPcDFkV3dYVlFrcTZn?=
 =?utf-8?B?cmU1aUN5V0hoRGZWK2xFa25TU1NBV3N6YThWRGFIRFNwMllWbmNIMHozNVhH?=
 =?utf-8?Q?LGvsBK6B/r6LgTqHX2?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b46f31b-33cc-40ed-b6e6-08da22ef61c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 17:01:15.7956 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RmZDuNl7dHpknNpLPiGuHzTORROm03UgKZxn9kBSEOEz0H0gY2TsVc7O0obSQYOsOmN4tZ5PC8WElwK2qPqHvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1449
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-20_05:2022-04-20,
 2022-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200101
X-Proofpoint-ORIG-GUID: axAxM4DSqQ34Hu1wgtw90YIdC7Etb7CI
X-Proofpoint-GUID: axAxM4DSqQ34Hu1wgtw90YIdC7Etb7CI
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v8 7/7] pmem: implement pmem_recovery_write()
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
 Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 "Darrick J.
 Wong" <djwong@kernel.org>, X86 ML <x86@kernel.org>, david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 Dave Hansen <dave.hansen@intel.com>,
 device-mapper development <dm-devel@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1C3675DD9B85124BB65409D954E2533D@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/19/2022 11:26 PM, Dan Williams wrote:
> On Tue, Apr 19, 2022 at 7:06 PM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> The recovery write thread started out as a normal pwrite thread and
>> when the filesystem was told about potential media error in the
>> range, filesystem turns the normal pwrite to a dax_recovery_write.
>>
>> The recovery write consists of clearing media poison, clearing page
>> HWPoison bit, reenable page-wide read-write permission, flush the
>> caches and finally write.  A competing pread thread will be held
>> off during the recovery process since data read back might not be
>> valid, and this is achieved by clearing the badblock records after
>> the recovery write is complete. Competing recovery write threads
>> are serialized by pmem device level .recovery_lock.
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   drivers/nvdimm/pmem.c | 56 ++++++++++++++++++++++++++++++++++++++++++-
>>   drivers/nvdimm/pmem.h |  1 +
>>   2 files changed, 56 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index c3772304d417..134f8909eb65 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -332,10 +332,63 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
>>          return __pmem_direct_access(pmem, pgoff, nr_pages, mode, kaddr, pfn);
>>   }
>>
>> +/*
>> + * The recovery write thread started out as a normal pwrite thread and
>> + * when the filesystem was told about potential media error in the
>> + * range, filesystem turns the normal pwrite to a dax_recovery_write.
>> + *
>> + * The recovery write consists of clearing media poison, clearing page
>> + * HWPoison bit, reenable page-wide read-write permission, flush the
>> + * caches and finally write.  A competing pread thread will be held
>> + * off during the recovery process since data read back might not be
>> + * valid, and this is achieved by clearing the badblock records after
>> + * the recovery write is complete. Competing recovery write threads
>> + * are serialized by pmem device level .recovery_lock.
>> + */
>>   static size_t pmem_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
>>                  void *addr, size_t bytes, struct iov_iter *i)
>>   {
>> -       return 0;
>> +       struct pmem_device *pmem = dax_get_private(dax_dev);
>> +       size_t olen, len, off;
>> +       phys_addr_t pmem_off;
>> +       struct device *dev = pmem->bb.dev;
>> +       long cleared;
>> +
>> +       off = offset_in_page(addr);
>> +       len = PFN_PHYS(PFN_UP(off + bytes));
>> +       if (!is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) >> SECTOR_SHIFT, len))
>> +               return _copy_from_iter_flushcache(addr, bytes, i);
>> +
>> +       /*
>> +        * Not page-aligned range cannot be recovered. This should not
>> +        * happen unless something else went wrong.
>> +        */
>> +       if (off || !PAGE_ALIGNED(bytes)) {
>> +               dev_warn(dev, "Found poison, but addr(%p) or bytes(%#lx) not page aligned\n",
>> +                       addr, bytes);
> 
> If this warn stays:
> 
> s/dev_warn/dev_warn_ratelimited/
> 
> The kernel prints hashed addresses for %p, so I'm not sure printing
> @addr is useful or @bytes because there is nothing actionable that can
> be done with that information in the log. @pgoff is probably the only
> variable worth printing (after converting to bytes or sectors) as that
> might be able to be reverse mapped back to the impacted data.

The intention with printing @addr and @bytes is to show the 
mis-alignment. In the past when UC- was set on poisoned dax page, 
returning less than a page being written would cause dax_iomap_iter to 
produce next iteration with @addr and @bytes not-page-aligned.  Although 
UC- doesn't apply here, I thought it might still be worth while to watch 
for similar scenario.  Also that's why @pgoff isn't helpful.

How about s/dev_warn/dev_dbg/ ?

> 
>> +               return 0;
>> +       }
>> +
>> +       mutex_lock(&pmem->recovery_lock);
>> +       pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
>> +       cleared = __pmem_clear_poison(pmem, pmem_off, len);
>> +       if (cleared > 0 && cleared < len) {
>> +               dev_warn(dev, "poison cleared only %ld out of %lu bytes\n",
>> +                       cleared, len);
> 
> This looks like dev_dbg() to me, or at minimum the same
> dev_warn_ratelimited() print as the one above to just indicate a write
> to the device at the given offset failed.

Will s/dev_warn/dev_dbg/

> 
>> +               mutex_unlock(&pmem->recovery_lock);
>> +               return 0;
>> +       }
>> +       if (cleared < 0) {
>> +               dev_warn(dev, "poison clear failed: %ld\n", cleared);
> 
> Same feedback here, these should probably all map to the identical
> error exit ratelimited print.

Will s/dev_warn/dev_dbg/

> 
>> +               mutex_unlock(&pmem->recovery_lock);
> 
> It occurs to me that all callers of this are arriving through the
> fsdax iomap ops and all of these callers take an exclusive lock to
> prevent simultaneous access to the inode. If recovery_write() is only
> used through that path then this lock is redundant. Simultaneous reads
> are protected by the fact that the badblocks are cleared last. I think
> this can wait to add the lock when / if a non-fsdax access path
> arrives for dax_recovery_write(), and even then it should probably
> enforce the single writer exclusion guarantee of the fsdax path.
> 

Indeed, the caller dax_iomap_rw has already held the writer lock.

Will remove .recovery_lock for now.

BTW, how are the other patches look to you?

Thanks!
-jane

>> +               return 0;
>> +       }
>> +
>> +       olen = _copy_from_iter_flushcache(addr, bytes, i);
>> +       pmem_clear_bb(pmem, to_sect(pmem, pmem_off), cleared >> SECTOR_SHIFT);
>> +
>> +       mutex_unlock(&pmem->recovery_lock);
>> +       return olen;
>>   }
>>
>>   static const struct dax_operations pmem_dax_ops = {
>> @@ -525,6 +578,7 @@ static int pmem_attach_disk(struct device *dev,
>>          if (rc)
>>                  goto out_cleanup_dax;
>>          dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
>> +       mutex_init(&pmem->recovery_lock);
>>          pmem->dax_dev = dax_dev;
>>
>>          rc = device_add_disk(dev, disk, pmem_attribute_groups);
>> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
>> index 392b0b38acb9..91e40f5e3c0e 100644
>> --- a/drivers/nvdimm/pmem.h
>> +++ b/drivers/nvdimm/pmem.h
>> @@ -27,6 +27,7 @@ struct pmem_device {
>>          struct dax_device       *dax_dev;
>>          struct gendisk          *disk;
>>          struct dev_pagemap      pgmap;
>> +       struct mutex            recovery_lock;
>>   };
>>
>>   long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>> --
>> 2.18.4
>>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

