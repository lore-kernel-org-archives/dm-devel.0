Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD0CC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 21 Jan 2022 01:34:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-INakndKYMMu8BReKQ-7fUg-1; Thu, 20 Jan 2022 20:34:52 -0500
X-MC-Unique: INakndKYMMu8BReKQ-7fUg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4852E1898290;
	Fri, 21 Jan 2022 01:34:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FB435F4EE;
	Fri, 21 Jan 2022 01:34:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BCA5E1809CB9;
	Fri, 21 Jan 2022 01:34:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20L1YaiD029842 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 Jan 2022 20:34:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6E8DFC080AF; Fri, 21 Jan 2022 01:34:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 686A0C080AD
	for <dm-devel@redhat.com>; Fri, 21 Jan 2022 01:34:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09EB3185A79C
	for <dm-devel@redhat.com>; Fri, 21 Jan 2022 01:34:36 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-385-7j3aBRuuNwOmcGb3-1qQWA-1; Thu, 20 Jan 2022 20:34:32 -0500
X-MC-Unique: 7j3aBRuuNwOmcGb3-1qQWA-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	20L04fBZ009111; Fri, 21 Jan 2022 01:33:53 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dqhykr3g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jan 2022 01:33:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L1Gf5q149490;
	Fri, 21 Jan 2022 01:33:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
	(mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by userp3030.oracle.com with ESMTP id 3dqj0v44jr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jan 2022 01:33:43 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by BYAPR10MB3416.namprd10.prod.outlook.com (2603:10b6:a03:156::32)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10;
	Fri, 21 Jan 2022 01:33:41 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%4]) with mapi id 15.20.4909.010;
	Fri, 21 Jan 2022 01:33:40 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v3 0/7] DAX poison recovery
Thread-Index: AQHYBx1mMl0+u9/A1ECT4doipsHhkaxruVyAgAEGPwA=
Date: Fri, 21 Jan 2022 01:33:40 +0000
Message-ID: <4e8c454f-ae48-d4a2-27c4-be6ee89fc9b3@oracle.com>
References: <20220111185930.2601421-1-jane.chu@oracle.com>
	<Yekxd1/MboidZo4C@infradead.org>
In-Reply-To: <Yekxd1/MboidZo4C@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62ab09f6-df77-4abd-5e7a-08d9dc7e0dfd
x-ms-traffictypediagnostic: BYAPR10MB3416:EE_
x-microsoft-antispam-prvs: <BYAPR10MB3416AA7C00553D76E27A8136F35B9@BYAPR10MB3416.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4kptKr1ZfYX9tXEGhl2khI/TcDWHyNaaFZpIZsMyV4j7Yknww/V8IH8yhXk3Aujk8lANL++BIuLOv5fQwwdyi0G1O41qtX9OV7H6YS9HzN46C1YXji5k/wMr31NuhaxKgAfShRsvm71MsCnTYqXOUUjswACccI38TwLDUJSjpGgLdYxwtWfvYFckgA7mOL0AXBenrfSn3v641ItSQ2Mk8YeEfy/IGy1zEWZEoR3KPYMABCiweW3ETXk9Mx7N4HDz8Vne30+Wk15mKwT0VcgIqN6f/8b1qLhHYl9eme/1YVuEaPdd6Gm8C1mjfMiK6OTphuMr5c3AGrVIuvTaxicK+drm2yMlQrO9AEEzCgCbZJsMZPxf8ih/Sw2GijT3flgNROL53DxIqvYIhmilNSAHWNX4GkLOeYFKS4tAfAxQQqz6busjDbM85UgRJzgCGVqQk+fCWW45IJiBd11IH8nVRl6ZevenLi8r4BKmKHZxr+FYbGgR5h0hDPEoFj/yqy8LRo0DP+m4J7bH2zdJCB1OaxskTnrG/cGT0ZGg648YuVN5/CtGVELrIda9n+WoAdUQ8CClrZ4bsA1QhaXYzmQDkvbRRa/i9jaIfa29v7h+92bn4m2CIXY7tPSJtNjBszRzHGV2PoYkO3DujqcFSPZIn/7gH3dl0pZ4179TUSqRHAnUMLiG2eURGG40i7vJyEazfelOC0egx7EmFdYrzqTR63Y5caGXXtsMi7IRyfIdycEaVXhU0NoeWtcfYFOoPlSDtByqCmc173ZGHTqGn096cA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(38100700002)(122000001)(66946007)(38070700005)(7416002)(66446008)(66476007)(66556008)(31686004)(64756008)(91956017)(76116006)(83380400001)(4326008)(54906003)(8936002)(6486002)(53546011)(26005)(6512007)(71200400001)(44832011)(508600001)(186003)(86362001)(6506007)(2906002)(6916009)(8676002)(2616005)(36756003)(4744005)(31696002)(316002)(5660300002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1llWEdiL2lhMUtjdlQveHNnRU9ua0pFdWVtakk2OFVCT1NEYXV3U1JWUk9t?=
	=?utf-8?B?dTgzTTJPTTZDOWhtSHdRSW1EWTNSV3dkMGI2TjJJOG1VNmo2dzF2QjhBOGE4?=
	=?utf-8?B?WSswNk4xWG1Ncmp6VTlOck5SQk5XYUlEeFhlc0F4cXpLMmV4V3N2VC84eTUv?=
	=?utf-8?B?RTBNdHdSVXBRSHZ1cXhnc1U0OUJDQ3NQZFBIMWFSbnJXbFRZYy9sNmk3Z09U?=
	=?utf-8?B?WXhjWlF0T2c0WE5FN2hKWE1vSHowVGNWSmIzVmtJblA1VitpOUdtR2ZUQnNu?=
	=?utf-8?B?bjM2YWZ6ZkkycGZaeGxSeXhVSGFJYU1MSEIvK095MmFhTDBadDlUUHhMWUo1?=
	=?utf-8?B?YUp5VGNwWWdEUDNpbXltazNKTVl4T1VnV3NVRExMNWF4WW5EWUtvM0dtSzJs?=
	=?utf-8?B?ckVjRHc4WWdlV0t6L0k2VzJaRjNwWDFCcThvOGo4d2wzTTArMkp3cG9IRTFv?=
	=?utf-8?B?MmxJcjR4dVZGNy8yNXU4TzJYVVZlK3E3RUVDVm9iS3VLbExUUW9aUU1SS3dI?=
	=?utf-8?B?OWFnbWxSK0FHNm5Cb2t2ZXlFSElQZGxDZWNHMytnTlUwYVM4N0VVNUw1c05i?=
	=?utf-8?B?MnJESVcwaEZwOEtDMkMvN2cxNGM1N3h0UmsvZFRsMVhJeWovcG5odm8rMy9D?=
	=?utf-8?B?NTFtV0RsTzNSYy9VVVFHM1N6bmk0emNRQU5ud1B4VXFuek9pMmljQXBIWDhB?=
	=?utf-8?B?Y3c0RlNEc08wNEpud3kxTUhZRmdTdDdlZWZqZUNCd0xOTGhpeGNBdkVpVFJX?=
	=?utf-8?B?Z0ROTHBTb1ZwbW5jRjg3ekRkVWpTRnYwcDF2WnJSQjZOVVkyYmJBQU1tNStl?=
	=?utf-8?B?SHhsS1ZnMzFQZHA4aElNVURrVVNKc2Z3ZnFaWEVqZTh6N0lXbXIyclNkZjdr?=
	=?utf-8?B?ODNqUDdIdnRWT0lla0pjZ0MzRnJpYTZ5WU1Fb3hLNkZZUlhrYnBzT2h6VWIy?=
	=?utf-8?B?U09NeWViNU4rMmcvUzB6Qm5EbHVVWUZQVmlSN1hwalNJOXd1UWwyeGc5Ynox?=
	=?utf-8?B?cVRwLzNYYnc1eU5Qd2YvSFFGRFY2Y0dXYjBwZGczb0xnZHJNM0ptT0E1VmVS?=
	=?utf-8?B?VWU4bXVRT3RnTkxLSVZDWWxSZ0ozdWVJZDRDSjBzVi90VWR2RitnSHg5U3hM?=
	=?utf-8?B?dGxGZXdXelBvT25tY0Q1K0JxYlpmenJiSlU1WlRYTUw1bGtqOWlJZVRCcTU2?=
	=?utf-8?B?VE91UXFnU0VtblRrVkZIRndWd3ovbU82RnJtMVYwSmxLZnVUeFlURmw3bEhD?=
	=?utf-8?B?VTQzM0t4eXBBOXRSd2VSV0ovNFRhaHJSUHUxc0RET2I0dktMN1hhYStUVkxS?=
	=?utf-8?B?VzNBWEdUMWpYRUVGem5xTEhRSUd6U1hwUlNzNzJNeElpdXM5bkZvc2haN3ZX?=
	=?utf-8?B?L1UxSjk0Z0d1VmtuUWE2N3p1eEFkR0hXYUpsa2xOMnpTbWRXSkFhRHVtZWli?=
	=?utf-8?B?ZDc2QSt3TFB4bFVJVWkxM0hzeFdjTnVRM1VxcTF6UlFROXJTY3dTRWU4NGs3?=
	=?utf-8?B?TVB5dFN5WUgrYkVNMS9tYlpqanZpZmNkb3E2VTRadVk5bFl1ZE1LMzZadnZw?=
	=?utf-8?B?b0hVL1Mvb0F1aEpKM1ZRMjJOcmh4OWZZVkJhS0tIZ2prTzk0TFl5OVhOM01H?=
	=?utf-8?B?TFB2VGp6d2JZUjNQUEkyMDRsUjFGU3VrbnU2R2RQY1dZbHpUK3hDcHpzMXVJ?=
	=?utf-8?B?K1p4NWtJVkZlRzl6SnJKSVlDK2p6M2VIM25kdEFSMXhtMGZFQnZoQzl3M09z?=
	=?utf-8?B?ZmpEVTV3ZFMzS1RWZEFwakRBRjZYZHRod3BpeDFZaWJpMTVIOVUzRVZaWDB2?=
	=?utf-8?B?UzBVeFBSaG5oK2NURG12Njdvd0IzMTR6aWJtZDlZcjJOWFB5NXd5RmwrUnpQ?=
	=?utf-8?B?aGpoNWxVRDYrcW81TlZkcUcxT1M1bzhBS09Iby9weGlKeVlkM1d4cDRQK0No?=
	=?utf-8?B?WFpjNWRZbzNqOWVkdWFiQStjSkxCRnZZNHhqR0RZVzlSMTFSUHFwbEFZRXl1?=
	=?utf-8?B?QXBUWEZmOVlNUWFXZ2RxbWw4cXpnS3pvaStSWjE3Vk5ubXQ1ejl1QkFZK1Iz?=
	=?utf-8?B?bnFzelQ3TzRzL2dqZXp3dnEwY0U4cG9iaHd6dEl5OXM2UGhSZEV2SUc3WDhJ?=
	=?utf-8?B?aFluMEJ5Vkk3OVFaZy8vRW9YYjFySHJGYWswSE9mdTJQMU9CQVZpQ214OGR2?=
	=?utf-8?B?cXc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ab09f6-df77-4abd-5e7a-08d9dc7e0dfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2022 01:33:40.7865 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7S1G3nsvht63tEJ+rDdBjJSIu6MuN4vcoNL9tF6yNnuUnaRpqAWkkOeRuSVVHT5RhV9j6pDbh7FIqzo7mdfWeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3416
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	mlxscore=0 suspectscore=0
	spamscore=0 mlxlogscore=689 bulkscore=0 malwarescore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2201210007
X-Proofpoint-ORIG-GUID: -MARQZfwuS1E-4RihTH0MQuHZMQwDv4P
X-Proofpoint-GUID: -MARQZfwuS1E-4RihTH0MQuHZMQwDv4P
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20L1YaiD029842
X-loop: dm-devel@redhat.com
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
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 0/7] DAX poison recovery
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <396EEA0745EEFD478E3B0075A7BC352C@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/20/2022 1:55 AM, Christoph Hellwig wrote:
> On Tue, Jan 11, 2022 at 11:59:23AM -0700, Jane Chu wrote:
>> In v3, dax recovery code path is independent of that of
>> normal write. Competing dax recovery threads are serialized,
>> racing read threads are guaranteed not overlapping with the
>> recovery process.
>>
>> In this phase, the recovery granularity is page, future patch
>> will explore recovery in finer granularity.
> 
> What tree is this against? I can't apply it to either 5.16 or Linus'
> current tree.

It was based on your 'dax-block-cleanup' branch a while back.

thanks,
-jane


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

