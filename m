Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A9B8C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 22 Apr 2022 03:47:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-hQfNq5FANqG_qWWZrFeDjg-1; Thu, 21 Apr 2022 23:47:23 -0400
X-MC-Unique: hQfNq5FANqG_qWWZrFeDjg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BD0129AA383;
	Fri, 22 Apr 2022 03:47:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AFA3B40CF918;
	Fri, 22 Apr 2022 03:47:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7A7CB1940350;
	Fri, 22 Apr 2022 03:47:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1A54B194034C
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Apr 2022 03:47:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E8888111E3F2; Fri, 22 Apr 2022 03:47:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE65C111E3FA
 for <dm-devel@redhat.com>; Fri, 22 Apr 2022 03:47:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEDAE185A79C
 for <dm-devel@redhat.com>; Fri, 22 Apr 2022 03:47:14 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-4pxcleXFPlyH7GV6v9y8mA-1; Thu, 21 Apr 2022 23:47:12 -0400
X-MC-Unique: 4pxcleXFPlyH7GV6v9y8mA-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23M3XAI6019231; 
 Fri, 22 Apr 2022 03:46:28 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com with ESMTP id 3ffmk2wn9b-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 22 Apr 2022 03:46:28 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23M3juxD022059; Fri, 22 Apr 2022 03:46:27 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com
 (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3ffm8cwjns-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 22 Apr 2022 03:46:27 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by MW5PR10MB5762.namprd10.prod.outlook.com (2603:10b6:303:19b::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 03:46:25 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 03:46:25 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v8 2/7] x86/mce: relocate set{clear}_mce_nospec()
 functions
Thread-Index: AQHYVFsMTxI9AQ9xzUq0YXeGDp841az575QAgAFeyoA=
Date: Fri, 22 Apr 2022 03:46:25 +0000
Message-ID: <537982f4-db3c-6c74-6b54-46afe6fa646a@oracle.com>
References: <20220420020435.90326-1-jane.chu@oracle.com>
 <20220420020435.90326-3-jane.chu@oracle.com> <YmD+zgFf9Vih52gZ@infradead.org>
In-Reply-To: <YmD+zgFf9Vih52gZ@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e3396ef-2368-4e24-4144-08da2412ad11
x-ms-traffictypediagnostic: MW5PR10MB5762:EE_
x-microsoft-antispam-prvs: <MW5PR10MB5762A32576665CF6226BF43BF3F79@MW5PR10MB5762.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3C67ZpYC505g5X422Z4iQb4WfVpq3V8Af48etTYcVCwlsu7hnIQSKIVDXRcoftIB0K78WLvmwSRpAuxsM2fo1jzK35JZigSgFQ+xjQALft1xM9Pyo+gfZBB1BotG68mkQ/9wwW2x7K7L4IKeTfBe1BENy4dp6BOwAYJswt+aLKnGA+dfaoCWp0ByZTRO834FVs9kQSlhoyTbsVKoJZcw2auXIGjDs5RIfAD+yq7yyQzAcFRhtgiRe2vvx5OKCRsbXi7AvDLt9cGMXKgEEdf+/nlSfOmOn2ZKe2hD5NbLckPbSuDdqjuJ2fuQZxpWysfRsDwClXUm1zp+n78EPRP1MvSSbGs+inAMpifgh64YTw8TExGk8EleQiJPCHpV0fpzaNCTjo9pSFKPUHyYeNs01wUSJEVfTIAXsF4LfEqOx8rddtMN5LHBwE6+P3U64wPK1nQtxnwxlXmEgTtOslzIw+DYzXDPNwbzEDbQtHWstRJ99v0YH8ABnq/8ZUFVvKEvlTSkHrcUvsKDmipZBzQXtoS1koXG5YxfM1pCTaWmdRhD/jBTNnWEGpVMaY3Ef8pMCbshWfbtlcOGZIuV6B4vwQjerhzQlBe+eUP5C+/ZYqnhuREOOyVSWvPhhou1PGMqShYJUECR5evNKMUsyKpF3C3KbQcCDYnC8puxgMRxttZ3FvDNYx3klscqeUmlasoE2Q4LCcK06qbY8JWgOmgD4kORTsL/TvmBeWlDDym8TIHXogOGtHbmiH3Qr04MG5cw93S2QbmL5A8tGvSFf3VyFA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(2616005)(26005)(6512007)(316002)(558084003)(31696002)(6486002)(38100700002)(38070700005)(4326008)(508600001)(71200400001)(5660300002)(7416002)(64756008)(66446008)(8936002)(66946007)(76116006)(122000001)(6916009)(86362001)(186003)(66476007)(66556008)(2906002)(31686004)(53546011)(6506007)(8676002)(44832011)(36756003)(54906003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3lzZ0RTYnJCY1p5TWE3MSs5dEZ1OTJqSkcrSis2aTZCSFZuTHBiaitWaWll?=
 =?utf-8?B?MGJLRFI3djBPbG1YSGxza0hqVE1jMzZ3ZHZtanV2eThadjBUYzZKM0hHWXlo?=
 =?utf-8?B?aUphSkEwNG9mSWRqTXh2bXgxSjlDNFlSRDM2cExnKzJVSnppNFBSS2oxc29q?=
 =?utf-8?B?dHVEOU45VStMcWUzL2FxRlNnTnMzZjh1UGxXZ0NLaEhvNy9NdXJtOW1XUU9L?=
 =?utf-8?B?VnBIajU3RTVLRStxQnJsQjg2OURjd1JhcHhiWUtSMkxIVGZPZk9hU1o4RThO?=
 =?utf-8?B?emhxNWZvTGRaRXljL1p1U0lsMHdBdkp0SWlrV1EvSXpicGYzZmJEbjM5dXFl?=
 =?utf-8?B?S05vb2twZzlWRm1ZamN3TVU5WWI0QlZUSXBGSWN0Mjc2RVFOdHkvNjVrS2h0?=
 =?utf-8?B?R1k4c3YxQlVqYTNwNlA0bmZJT0hqdlVUYW1HMXh3WVhVTXpUd3ZpdzVsRGZ5?=
 =?utf-8?B?RXJrUlplT1BDSkQ2OWlSWEJIaVZNMDJSRHUzTU5STUJIdlZXVzVRL0hNOWNB?=
 =?utf-8?B?c3ZaT2RYNjdsNHZlRURwdEkrSE9lNGgwbXpZMER4N1JabjJsOXg2ckVIQzVW?=
 =?utf-8?B?OXRCdmZKUmdmQVdnYjRSRWVNd0ZWYXBwSHhFdXlCZ1RKRnVlN0JRUDc1WURm?=
 =?utf-8?B?UmJpVmJUS0krWHJBY1ZxWTJVaGIyb0VTc0dUUHNtbHgvdkI5cHhsWEJBNVJW?=
 =?utf-8?B?d3NiMzBmZVRsdEdEd1pCOURUQ1doVTJ3N2xjWUhMbFkzelFvRkdQZU1Ba2py?=
 =?utf-8?B?VEoyRlltOUcrbjFLckZpblFiR2pRSlJLNGtlMlFidWdzNkF4UFI4bnlnWlJs?=
 =?utf-8?B?MkpjN3pKWlg2NCtiQVNFdlpZNEkrTS82TDNOdlhIc2oxeTUweDFNbkRZcUE2?=
 =?utf-8?B?N0VjYjRUY2dqUG1wUmhUMjdsbWNuYVBwVnFCVlgxZmpsYTlvK3dyMVNjZW00?=
 =?utf-8?B?UmVxdVJURXR1cktWRWpEUnlicWxGV1hEVGJRTmhkay9RTkRCdW01d2lDYmlL?=
 =?utf-8?B?VUpWbkRybEM5LzRKeTU3SjFoQTRadGIwNmhBcE5YdStRc0NteTJONkJ3cFJ2?=
 =?utf-8?B?V1RmS1J2Q095aWl4dkI0aFBQR0xyUWRYNlhVV0NKMU5Bb1NoUTd3b1MwQjk2?=
 =?utf-8?B?enplbjlZbXppaExwdEpidXE4OGNhWFdGZHhLZHA2ZWRFMHN4RVI0NVNGa25n?=
 =?utf-8?B?N2plakJpaE40bmRpOXIzeC9yc2xYTER4SjdEZy8rdGd1M3Y1aVVZOEZUR3ZL?=
 =?utf-8?B?cHdocnV5b0NTZjZqbmlYdGxQRFNCaWNmd0hRVDd1bzNZMG1yZTJBRVlzUi9U?=
 =?utf-8?B?Ny83STRPcndFeFVwZytjNlVsbmMvVitxcE96amJwS2c0Y1paOWo4SE5Nb3No?=
 =?utf-8?B?dGI0cGE1WGhzUEJSWURJNnMvc2R4aDhXZnJ6bGQxMDdjYWVWQ3ZiY1ZMVTIx?=
 =?utf-8?B?ZnRDK0cwSUIzWjBGaDh0RlVjTmpRR3RyWi8ybjE2V3FqbTZWbVFSWVRvek5F?=
 =?utf-8?B?eTI1YW50S1I2Vk5aQkUvQlFOTmZQeURDWnd5M1RlYk84WnROSE5rcW1QeDNn?=
 =?utf-8?B?RzdNdUdSK2hLRUw4bnp6NitDNnY0ZFVlc2pUTDZ1cGFaSStyejlBaUhlL2dF?=
 =?utf-8?B?aFVlcWlrNENmWU5kN3IzcVRWRnJZYzZzUnFYVmNDUzlqeTAvZjhJMDdZVGhK?=
 =?utf-8?B?U0JlMTgzeUdrUmxNRUlGSmNQcEQ5S0p0Y3llaEYvR2ZIOXh1MTBrb3pTeDlJ?=
 =?utf-8?B?c1BRZTdlWmRXNG44ZGxMemdsbEhqZC8xdTljbkxOSlAvc0NzcmpiK0RuejNh?=
 =?utf-8?B?ZlVEZUhnalZic0U4WDJEOWQyVlFpYThUTk1lMXp2c2haeWNacnJqbnFFbmc0?=
 =?utf-8?B?bWFVSkNyMXkxVmJWNnJTazgxbVp4WGVUOU5mbHlLUWZpbllCTEI3VENpM0Ji?=
 =?utf-8?B?cWd4WS9JSTQxVW5Ya3hqekZ2VVY1aGkxSVJBemdKK3BjMEZMZkM4N3dmbDYy?=
 =?utf-8?B?ME1wTWNIb21iaS93ZW5nVUY0YnJlQ2hQZnlPRHp0SDRTWjNaWU1wdGwrZ0NU?=
 =?utf-8?B?VUY0dkFzU2UzdVYwN2w4dzBhSk1aYlV6ZlUzY1hRSk5MMVM4eU9mNVIxTFZV?=
 =?utf-8?B?cnZDK0xlRVN3SWRzTU1ENyswZFpscm1ncktuZStpMHVSRUdVdHlrOHJNNWtu?=
 =?utf-8?B?UnRDWEw3VWtmVUlWK2llMmZUbjlQRUl6ZGRpRnkrb3pvNklPUlRFRVRJZ0VY?=
 =?utf-8?B?b1ZPWjNTU21QSVRxREIydEI1Tm9jSkM5eUlJdk5VTzFydmVXQld1eVNHZFdq?=
 =?utf-8?Q?bdVCg5xWEYh8wATldi?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e3396ef-2368-4e24-4144-08da2412ad11
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2022 03:46:25.7009 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6h6RFleDfVF89pzqyih9NL28EVdvf8PmDz9EYpKDgBUzWR5nySVoc+ANAXshblMC/L4s24bOmQa0evH1AKo8pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5762
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-22_01:2022-04-21,
 2022-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=952 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204220013
X-Proofpoint-GUID: DWBvvnkkwzlHdaghAY-DJnceejjMFrFJ
X-Proofpoint-ORIG-GUID: DWBvvnkkwzlHdaghAY-DJnceejjMFrFJ
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v8 2/7] x86/mce: relocate
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
 "peterz@infradead.org" <peterz@infradead.org>,
 "djwong@kernel.org" <djwong@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "david@fromorbit.com" <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "dave.hansen@intel.com" <dave.hansen@intel.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "vgoyal@redhat.com" <vgoyal@redhat.com>, "luto@kernel.org" <luto@kernel.org>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A92246354449324C97570806B3B41942@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/20/2022 11:50 PM, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!
-jane
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

