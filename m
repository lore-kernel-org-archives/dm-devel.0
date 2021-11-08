Return-Path: <SRS0=u3eZ=P3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD045C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 21:01:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DEE2619E2
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 21:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4DEE2619E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-2CGf9ml2O9KPhaPlse-w-Q-1; Mon, 08 Nov 2021 16:00:59 -0500
X-MC-Unique: 2CGf9ml2O9KPhaPlse-w-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62B8D1006AA0;
	Mon,  8 Nov 2021 21:00:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EE6F5FC25;
	Mon,  8 Nov 2021 21:00:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6CB2B4A703;
	Mon,  8 Nov 2021 21:00:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A8L0nPL027149 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Nov 2021 16:00:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E85D740CFD0C; Mon,  8 Nov 2021 21:00:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E184E400DEF8
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 21:00:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0E3485A5BD
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 21:00:48 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-275-B1lxAB83OQ-4mLm6-vDoiw-1; Mon, 08 Nov 2021 16:00:45 -0500
X-MC-Unique: B1lxAB83OQ-4mLm6-vDoiw-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	1A8JxrYv020128; Mon, 8 Nov 2021 21:00:35 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c6t705vx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Nov 2021 21:00:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A8KqEFV117699;
	Mon, 8 Nov 2021 21:00:30 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by aserp3020.oracle.com with ESMTP id 3c5hh2kwae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Nov 2021 21:00:30 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by SJ0PR10MB5568.namprd10.prod.outlook.com (2603:10b6:a03:3d8::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10;
	Mon, 8 Nov 2021 21:00:27 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::418c:dfe4:f3ee:feaa%6]) with mapi id 15.20.4669.016;
	Mon, 8 Nov 2021 21:00:27 +0000
From: Jane Chu <jane.chu@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Thread-Topic: [PATCH v2 2/2] dax,pmem: Implement pmem based dax data recovery
Thread-Index: AQHX0qwHA1irfgJJPUKt0/SD8Ofb86v1wA+AgARh6IA=
Date: Mon, 8 Nov 2021 21:00:27 +0000
Message-ID: <400cb29d-4354-054e-9a3d-15cb57342340@oracle.com>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-3-jane.chu@oracle.com>
	<20211106020459.GL2237511@magnolia>
In-Reply-To: <20211106020459.GL2237511@magnolia>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6e5e55a-2a71-4db1-159d-08d9a2facab3
x-ms-traffictypediagnostic: SJ0PR10MB5568:
x-microsoft-antispam-prvs: <SJ0PR10MB55683544B8DDA8FC989CADD9F3919@SJ0PR10MB5568.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: dkcar1Nw5D/5+6CZ68NZrULIbfGImE9aO/g4nUGloS89ClbwPhnJlEzil89uDrENHgd52UCa9VIU4ia0Tq/DrhYJqmaEPpnK8Dflj1TwdmBocEeR9D9aD4m1jZM+2rDAAA2xH4mZyJgprE3Gl/qk7Ag5ce/IVrAbZqPk0H3YB5k/3CxnhfqwOoVbB2/8GUotf4waqQYexNV0Rv/dKC5UMZifdH08cJZ8AUIt0qD8TRCD3JaIxr7W7sry+NSCbKA0AcUSaxevFRPzCPrGvnCOFxw6jxkiIkuOOP2nLW1KsZMdNteXheyMLE33BvA5K3n76Vq0Q3LO8we/Mq5r/8iPD2mohGRcPDXc7dlkVJ2mr8BRj0XM66JCb5r26mcX98VzjQ7jx/hzOJGnXGUkwaUggMhqoIfDouiuOd7F6L/lWC3NXpm+QPpQZJs+I4+/fKqomr6oZKf5dZULkZcjSFaRc9ZpNDfxuDznewIhEanKJWrNiUjAMUpy84ZvMtNL95mLKr0Yis11AuhfJAK8oFafN7VuqcWKjUj0k8zKdqWLCOMpWZ9Ker2aaoYuwv/sV/6vftbs69+byRJBDQ7meC1OmFpAcmLb4uvQtvAzA2VSmifVUQE3g/FOxbXU3hmIc8tavgr+2+klRicJt7nah/vr1BvWDryVPkmKru5d9wrninuiip/B/UgYmbORzSz4sAmVMhKBTEtuFbpLXe7oIlnlIzSRFjVEZ4y0RRmdG5WtdUWrC1ITI8sOiDtyww0ljSVzjJ1w+BqZHNwkcePKWSCURLuer1qZH300sZlkixIEijM=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8676002)(83380400001)(86362001)(186003)(6512007)(7416002)(91956017)(66446008)(66556008)(64756008)(38070700005)(2906002)(31696002)(5660300002)(316002)(66946007)(8936002)(4326008)(122000001)(31686004)(38100700002)(76116006)(66476007)(54906003)(6486002)(53546011)(36756003)(44832011)(508600001)(6916009)(71200400001)(6506007)(2616005)(43740500002)(45980500001)(309714004);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkcrWmNlU2xmcHNwcFVzUlhYU20zWm5iVngvS2RXYSt3dUxxMVRXWDBCSGRt?=
	=?utf-8?B?eTZJS2xKY1MxSWoxU0ZtZk82T3lpWlRXdDRZc1o3NGUvL1V3ZXRGbzlrVFRw?=
	=?utf-8?B?Y2RiS3RQamZuTklPQXR4NXIvNGxvUDd1YXNlWnhJY2NtSW44WUlvVllmUDNT?=
	=?utf-8?B?ZmFaYjRxUUxabEZiemZEU1cxamk5L3UrZmpHSStTREkvbkl2MldCMGlyWGV3?=
	=?utf-8?B?TitpV2xRYWJqeUdoS1ExOVhob05kQ3I0NmFOWW9zT2RXYnlFR2pJaFBNL3U4?=
	=?utf-8?B?N2FqZ3FPdG1NNDZQV3ZtRnRseEFWRENVNTd2R29TcjBHRE41OHc1bFhIUW9U?=
	=?utf-8?B?cGFlbmYyYTNiK0pDSituNlQxVVJRRkl1VWR1SUt0aVB6aUZ2UkFVbFB1OUh5?=
	=?utf-8?B?YVFxWkxxYlFEbkZnQXNRaVpSK29ZQzVMWTh4eVpDa2xDQUVPNDg0MXhtd3Fu?=
	=?utf-8?B?QnZ3ZS8ySzIwU2xKMm5xQkRld1VUd0x2YnFXV25RLytvQWl4MGIxV3RqZlhs?=
	=?utf-8?B?Yk1GMzE4aFdYcHNvZHhITE4xSlZHNmduaEdyVWV3NnlOTVphVTZSQ0FkT213?=
	=?utf-8?B?a0k3amlQbHpVK00rZDlMRXkvUGVHNjlIdGhOVWtHM1hXTFVJcGlHMmRWVzFD?=
	=?utf-8?B?ZXU2QVNjazhzeXlEK2tnR0hNdTNkT29WczVLbjJmRmtkOG11UDNBVEdvN1Ex?=
	=?utf-8?B?QVFpNXFjQzZ6SllsWEZCaEVaOUJWa2QreUpnSEJiZHMyQ3BPOHJadE1XVjJk?=
	=?utf-8?B?T0x3cy9zOGFoSThVV011QTNhaGljRzhmSmMvV1hmMUpqZTVPZjNqRzJIQ3Bi?=
	=?utf-8?B?dDJzdzhuaXh4WmYwbk9QL3VlV3RoelNmT3V6NnF1RnAyRVlWTmZtcmRYRkJp?=
	=?utf-8?B?K3NjbWlyMm5JU3Z6dFNNY1lxV1o0UWJ5Uk92NXM0cFFXTzNhQkg4OWxQUlNX?=
	=?utf-8?B?a0ExVHRRaGErbHhRSkd1MzVEaTVwdEpCcHV6YW8raTg0L2hVMkx0Z1h3Z2o4?=
	=?utf-8?B?Q2pUUG1ETExxWHdZZTZNYlEvTGRDWWJCMEx5SmJXV2hnRVpQZkhxV0dsOTI4?=
	=?utf-8?B?cm9EMFJjWWhyMEE5eDBWc1ZqSGV5QlJuSkNUTHA1K1pSNThsbS9EVS9QRjdK?=
	=?utf-8?B?MUJyUGs0QXpUSEcxYURUU1pObFlFYVZNM0o2TmxUSjVyamhjU2FBQTVQTFFo?=
	=?utf-8?B?Nkw1eXFqM2JjK09HdjAxMjlBbVNWb0VZdWhQZkc4bmh2Ylpac1VLK1RzWitN?=
	=?utf-8?B?RmdiUVdQZXlGYkFBZE9rc05pWlRSeW5CclVhOFpTeDNvbFlUZHI0QXB2OXFH?=
	=?utf-8?B?SjREZGVacElxMjB0UHY1RG5tOEdWL3B3Sk1PaDdodEJ1ZFNRZnpRY0tZcExn?=
	=?utf-8?B?dVgweE1lank0NTZHSnk4VEVSTUljektGenV2R3IyUTZJWlNDWjU2aE9qbFM1?=
	=?utf-8?B?Q3RyaXo0bjRkRWpIRys2Tzk4amIvcHlvcVVzMmhtWjRKeWM5NkVZajF0eFha?=
	=?utf-8?B?MVRib2RVamllbDZ3UHk2bjh1ZVNUSjErVzFkVzd3bW5oSm9sR2l2RFZBUzYr?=
	=?utf-8?B?VXdYWUY1SkpkYkF0TDlFQkE1QmpEVnFSUFUrZXptYmp2RmV0dG4xZE5XSmNY?=
	=?utf-8?B?M1RNME5nUWl4RDdzUEpISjVrSC9uU1RRTlA4UXk5eWZ0WWFyR1FuOEVjemVp?=
	=?utf-8?B?NFBnclRKU3pRQk1QWUZxcnRraCtNZGozSVpVQ2NOTjBld1c0b0d0Z08rS2dM?=
	=?utf-8?B?clFsSWt4MWZ5bjR6ZmNrSHhSeHBGeVlyVy9wQlI4M25aYXk1U3g0aU1mSGR0?=
	=?utf-8?B?RkJ2STVvU3VvaElmcTNQT0FFMVlzM2RaSk9LUTJlVmk5K3hTQXpqVmp1U2x5?=
	=?utf-8?B?WGtkVzlvdEpSQTI3cWowL0poWGxGbXYxZ0xmMlJMMGgzei9RSnp2bDV6cGFy?=
	=?utf-8?B?QWZkSUlZSWtKenA4T1RHblhnbHUxZXNtODlQZFdqZ0RUdFZpdXY3a083VUUv?=
	=?utf-8?B?SGMyNnV3U2tzUFF5Q1dCN080WEg2SW9FNUd5V3FKcUxZNStjL3hValo5SzlU?=
	=?utf-8?B?OC8vWVJrNWV1R1BOYUxibjhWUHp4TTdVM3ZGT3JsN2ZtbnB1YUZzNmgrZ2RQ?=
	=?utf-8?B?aDNhcGJzZEZ2MFlBc1FFSTE0UDRKSk1Oa0JtckI3Nm4zamRjcVJXVzhoVG15?=
	=?utf-8?Q?EZNOHs6Hyx7kVpGkCoJYZVL8vyi25e7ZtzBxKy4E8HSl?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e5e55a-2a71-4db1-159d-08d9a2facab3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 21:00:27.5077 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3x9c8KvXTgSjLiESDgYqwBOL0YwhuhYLQAsXzBVSrhFvTh9AQTXbThx4Z6ATa9m2bm5NRwSnzww705QegVaU3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5568
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	bulkscore=0 mlxscore=0
	malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000 definitions=main-2111080123
X-Proofpoint-GUID: McGJYmpb_3F7avUiLMPAOzmuWkSWLqC2
X-Proofpoint-ORIG-GUID: McGJYmpb_3F7avUiLMPAOzmuWkSWLqC2
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A8L0nPL027149
X-loop: dm-devel@redhat.com
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 2/2] dax,
	pmem: Implement pmem based dax data recovery
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <4A9AA737C8863A4D948D359C635A5B75@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/5/2021 7:04 PM, Darrick J. Wong wrote:
<snip>
>> @@ -303,20 +303,85 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
>>   }
>>   
>>   /*
>> - * Use the 'no check' versions of copy_from_iter_flushcache() and
>> - * copy_mc_to_iter() to bypass HARDENED_USERCOPY overhead. Bounds
>> - * checking, both file offset and device offset, is handled by
>> - * dax_iomap_actor()
>> + * Even though the 'no check' versions of copy_from_iter_flushcache()
>> + * and copy_mc_to_iter() are used to bypass HARDENED_USERCOPY overhead,
>> + * 'read'/'write' aren't always safe when poison is consumed. They happen
>> + * to be safe because the 'read'/'write' range has been guaranteed
>> + * be free of poison(s) by a prior call to dax_direct_access() on the
>> + * caller stack.
>> + * But on a data recovery code path, the 'read'/'write' range is expected
>> + * to contain poison(s), and so poison(s) is explicit checked, such that
>> + * 'read' can fetch data from clean page(s) up till the first poison is
>> + * encountered, and 'write' requires the range be page aligned in order
>> + * to restore the poisoned page's memory type back to "rw" after clearing
>> + * the poison(s).
>> + * In the event of poison related failure, (size_t) -EIO is returned and
>> + * caller may check the return value after casting it to (ssize_t).
>> + *
>> + * TODO: add support for CPUs that support MOVDIR64B instruction for
>> + * faster poison clearing, and possibly smaller error blast radius.
> 
> I get that it's still early days yet for whatever pmem stuff is going on
> for 5.17, but I feel like this ought to be a separate function called by
> pmem_copy_from_iter, with this huge comment attached to that recovery
> function.

Thanks, will refactor both functions.

> 
>>    */
>>   static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>>   		void *addr, size_t bytes, struct iov_iter *i, int mode)
>>   {
>> +	phys_addr_t pmem_off;
>> +	size_t len, lead_off;
>> +	struct pmem_device *pmem = dax_get_private(dax_dev);
>> +	struct device *dev = pmem->bb.dev;
>> +
>> +	if (unlikely(mode == DAX_OP_RECOVERY)) {
>> +		lead_off = (unsigned long)addr & ~PAGE_MASK;
>> +		len = PFN_PHYS(PFN_UP(lead_off + bytes));
>> +		if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
>> +			if (lead_off || !(PAGE_ALIGNED(bytes))) {
>> +				dev_warn(dev, "Found poison, but addr(%p) and/or bytes(%#lx) not page aligned\n",
>> +					addr, bytes);
>> +				return (size_t) -EIO;
>> +			}
>> +			pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
>> +			if (pmem_clear_poison(pmem, pmem_off, bytes) !=
>> +						BLK_STS_OK)
>> +				return (size_t) -EIO;
> 
> Looks reasonable enough to me, though you might want to restructure this
> to reduce the amount of indent.

Agreed.

> 
> FWIW I dislike how is_bad_pmem mixes units (sector_t vs. bytes), that
> was seriously confusing.  But I guess that's a weird quirk of the
> badblocks API and .... ugh.
> 
> (I dunno, can we at least clean up the nvdimm parts and some day replace
> the badblocks backend with something that can handle more than 16
> records?  interval_tree is more than up to that task, I know, I use it
> for xfs online fsck...)

Let me look into this and get back to you.

> 
>> +		}
>> +	}
>> +
>>   	return _copy_from_iter_flushcache(addr, bytes, i);
>>   }
>>   
>>   static size_t pmem_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>>   		void *addr, size_t bytes, struct iov_iter *i, int mode)
>>   {
>> +	int num_bad;
>> +	size_t len, lead_off;
>> +	unsigned long bad_pfn;
>> +	bool bad_pmem = false;
>> +	size_t adj_len = bytes;
>> +	sector_t sector, first_bad;
>> +	struct pmem_device *pmem = dax_get_private(dax_dev);
>> +	struct device *dev = pmem->bb.dev;
>> +
>> +	if (unlikely(mode == DAX_OP_RECOVERY)) {
>> +		sector = PFN_PHYS(pgoff) / 512;
>> +		lead_off = (unsigned long)addr & ~PAGE_MASK;
>> +		len = PFN_PHYS(PFN_UP(lead_off + bytes));
>> +		if (pmem->bb.count)
>> +			bad_pmem = !!badblocks_check(&pmem->bb, sector,
>> +					len / 512, &first_bad, &num_bad);
>> +		if (bad_pmem) {
>> +			bad_pfn = PHYS_PFN(first_bad * 512);
>> +			if (bad_pfn == pgoff) {
>> +				dev_warn(dev, "Found poison in page: pgoff(%#lx)\n",
>> +					pgoff);
>> +				return -EIO;
>> +			}
>> +			adj_len = PFN_PHYS(bad_pfn - pgoff) - lead_off;
>> +			dev_WARN_ONCE(dev, (adj_len > bytes),
>> +					"out-of-range first_bad?");
>> +		}
>> +		if (adj_len == 0)
>> +			return (size_t) -EIO;
> 
> Uh, are we supposed to adjust bytes here or something?

Because we're trying to read as much data as possible...
What is your concern here?

thanks!
-jane

> 
> --D
> 
>> +	}
>> +
>>   	return _copy_mc_to_iter(addr, bytes, i);
>>   }
>>   



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

