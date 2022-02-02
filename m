Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 748A9C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 21:32:03 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-A0RnxKypNCOJFauL4cPbAw-1; Wed, 02 Feb 2022 16:31:58 -0500
X-MC-Unique: A0RnxKypNCOJFauL4cPbAw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60587192CC41;
	Wed,  2 Feb 2022 21:31:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2361312E39;
	Wed,  2 Feb 2022 21:31:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E01761809CB8;
	Wed,  2 Feb 2022 21:31:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212LVqdt019613 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 16:31:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B12C840885BB; Wed,  2 Feb 2022 21:31:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC51340885AE
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 21:31:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90A7428ECA81
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 21:31:52 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-314-k19oRDjWO3CBDdXt6vriGA-1; Wed, 02 Feb 2022 16:31:48 -0500
X-MC-Unique: k19oRDjWO3CBDdXt6vriGA-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	212Kwoju024834; Wed, 2 Feb 2022 21:31:38 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3dxjatyh32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 21:31:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 212LVUXw127767;
	Wed, 2 Feb 2022 21:31:35 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by aserp3020.oracle.com with ESMTP id 3dvwd903aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Feb 2022 21:31:35 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
	by DM6PR10MB3435.namprd10.prod.outlook.com (2603:10b6:5:69::27) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20;
	Wed, 2 Feb 2022 21:31:33 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde]) by
	SJ0PR10MB4429.namprd10.prod.outlook.com
	([fe80::d034:a8db:9e32:acde%5]) with mapi id 15.20.4930.022;
	Wed, 2 Feb 2022 21:31:33 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v5 7/7] pmem: fix pmem_do_write() avoid writing to 'np'
	page
Thread-Index: AQHYFI6Q/lmHxWShk024TAEhoFquSKyASHuAgACG54A=
Date: Wed, 2 Feb 2022 21:31:33 +0000
Message-ID: <9a423d47-451b-6339-6cf7-a44c20425069@oracle.com>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-8-jane.chu@oracle.com>
	<YfqHC8zpPlyWhVkj@infradead.org>
In-Reply-To: <YfqHC8zpPlyWhVkj@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72981cad-5016-4515-929f-08d9e6936294
x-ms-traffictypediagnostic: DM6PR10MB3435:EE_
x-microsoft-antispam-prvs: <DM6PR10MB343537A67C58977470BFFB6CF3279@DM6PR10MB3435.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:486
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ulKSkPtdiD7tqNf+sGFuxv2e/GQkXJqEsD/jDZonMVWyTw1xDspmJ58sZEn6CXPVs5x1B1oMIvuI7h0KSILiZArL0/LVt25ZkEppRlDqhDqRftLL9ZeeRLGWHZ+vLHspUVXG7QcUFZChPHRZRWw+0KaB167XwGO3jLUoXA8sZxEx6mZtwMiakRwL+y9AN9STtncTt9WBvf43fYy9QXVWZyrJjVCkxs9SXCkeIYi9ZyeQYJCrhSuJD1GAWt4UBh5ziQxD6B0Qhdntx7U38LBV+MIlTDf3OW0yLju97VTA3cFbKyP/HEVtFMuLkgwU4+8fy9TD2i6kGlWtympK+yZagDTSqm78WCGc6/kjHxffqG9XJqE7YxXLB6eA9bOePhX7MJD220RYm4gSO6TcGgdfjmD5jbHC+mknKSlxTanTLa4hV6rd8rJeONztA6EjJ0q2ndBUAPD95qO5z/nMR0bmaZlc1qlfP7TCqzKzTffGCAyc2QYUg9a6pI6wNaLLQIbVZ7rijdsL1DnMcFD2NNj6bgYvKrkE72kzgVxaNlVo1ruB/oLkmNiNdiO7vDA1GrgvbNrI2iz11mes8XXu/YOhfpKNWCO9i44+90nbxBIKcDigiGAxKAO4f6wSUM3cfqqAIRUUHlfWP2aFmQlkToLuVY0pRfKgURTzFtt+Z6gH5ZCRmsP/pHtaFN7EOPx1P4ZSBR8GtqpndFIh+lyUhXLq3VB46LYnzMGesFtIAhUqUrYAZkMqYdm2nm6FzC581/1Rn1h8RJMPXRX3MMi/yNRkpg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(316002)(31686004)(64756008)(38100700002)(31696002)(76116006)(66556008)(66946007)(86362001)(54906003)(66446008)(508600001)(91956017)(66476007)(6486002)(4326008)(8936002)(8676002)(6916009)(83380400001)(5660300002)(44832011)(4744005)(6506007)(6512007)(36756003)(53546011)(2906002)(38070700005)(7416002)(26005)(186003)(71200400001)(122000001)(2616005)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFlFbUYwQk5yUGhGWU9IL0pZRW5HT1BBSmk1VHZaK0tVR0ZEZmprbkZHQS91?=
	=?utf-8?B?SVkyakpxbEtCNi9FaDlqV2Nyd1F2UGhJUWVCRzhQTXZyeVlmeUxqbHlzMnRO?=
	=?utf-8?B?anV3Q2c3V3FlZzNHSXFwSk4vR1BDOXNqeFVXdTc3OTZSZDhwenhWdGphWlFC?=
	=?utf-8?B?UmZXd2JSa2w5M1g4VEkyU0VvYXJGcDZiNDE1SUMyczZlUy9VVDdMQk5iMFFX?=
	=?utf-8?B?RzBxdHEzamZXc2t2ZlZ2aGphVkN6bTArcFpYcjlaQXJzK1dxWFNWT0dnc1cy?=
	=?utf-8?B?Qi9pWWFRb3ZjSlh5Z2s1QlBTeUpEN2RWamxPbWN4ZVVGdTd0NVVJWkx4NENw?=
	=?utf-8?B?OUdHdm9lM0NQSzdTZGE5UGtDdmd3cWdtcVRaMDNKdi9kNHZNWlgvMWkxTTF2?=
	=?utf-8?B?TklGY3VGUXI4bW1FekdkaUxrd1dMQXQ1L2pnc0gxaWFsVWw4SDd4ZnE2TXVw?=
	=?utf-8?B?clNwM2RyOUFwaG1hNGlVaGxiNUdqNlJ2QytpYktNQytFRUlQQU1ESDZWNHRy?=
	=?utf-8?B?bkNHRmhDdmlLYXFVd0tFTk1GbUhuRVp5Zm41Ym12K1BjY1A3bkJIK1hHR2FX?=
	=?utf-8?B?Z2w2b3lpSHBKS2tUNDhDUC9EYlNNdE9NTFRrcTB6YjFOWlJLTVVQRXh4V3RI?=
	=?utf-8?B?dnQxNU5UUWRXM1BpTWVBRndQVVhjYVczLzUxeUJvN1A1L1BYcTQ1WUlKcVpB?=
	=?utf-8?B?TEZYSGF3T1BtNCtNYjUwckJsWHd4NXFrZG40cE5kWmRTb2lvamFCTU9VYkx3?=
	=?utf-8?B?UzNFVEc4ZzZEMHNnL2p0VHFsdTZSRkNrcDVteG1vNnF1YkpOWXhhSDFaMzRP?=
	=?utf-8?B?aC9VMHQ2bDJzVzJKOERrYTZmRzNKU3g3U21ObkxqY2ppNVVHMEJHWSs4cXp1?=
	=?utf-8?B?dDlkL1BJa0JxOGFnZEFod3drdlBZUDd5SERtbGx2VGUrUk1oWVJKZjZURjRZ?=
	=?utf-8?B?SXl4dmUyNTRnWjdaWEpjNzMwQ0JCbnpWSk4yWjlaQWR2eGZrR3NuSWVZdFdC?=
	=?utf-8?B?T2JhUHpKUnV4MzZzM3BPZDkxQWI5bzJGVnNQbmNvUzRhb2t0cFp1UEtNZzZV?=
	=?utf-8?B?bDhoRWZJTTNHWVRxME9xajFvbFA1alVhT29JRGhGZU52TWx2UVEwQjNEVGl5?=
	=?utf-8?B?WmVYNm0ya3VIK2ZGMHNOSFpZTkI2NCtGa3BkSDlHV0VXbmhXVDM4U2F3MzN6?=
	=?utf-8?B?dzlBWU5UaFFHUWV1ZVprQkVaODkzbUdDSGFDaE9CQldZbkwvbEF5bWEwY2wz?=
	=?utf-8?B?amhONEVYY3YrWUZ4bFVsc3lnaGhBTHcrOFF3KytNZTZvNG1MWVhIbnZ1N0lZ?=
	=?utf-8?B?ZW5MMWxwVVZSVVVWSU1sN2dDS2oxck0xTGV2bjdla0NGQndEQitZengvZXYz?=
	=?utf-8?B?cnptU0Nzb2tKMjdTSUFoaWdsUm8weEVQTXRFYjlJU1BVbWNqd21tbE9XOGFw?=
	=?utf-8?B?K0NHczl2SEM4ZU1LTFl3TWRjN05IZVRDVFN2KzB5MTVsOERSdkJiQUNNQVAy?=
	=?utf-8?B?K2lselhNNkt2d1RPL3Zrb3RwTnNkZU50MFh0RW0xUkdiWU80VmlySmFRMzZi?=
	=?utf-8?B?cjB1emZNMEt1eWJwMjR0Qjg0TnRGM2FNNFRuTVIrQTVKMWczUG91bWxRM3dx?=
	=?utf-8?B?alE1MkZhdm5MZjRFbzZjSWJuSUpSRkxmNCszUGZGSDhUbnFtcmdheWp0T1ZX?=
	=?utf-8?B?djVPZ3lYUk1yV1lOdjg4N05rd2NnY2puN3RLeWJiN1Q4REtLb2dhWlk2NHNz?=
	=?utf-8?B?VnF2bHFmREdDQmt2T29vbm5MK2o3YWxGUW83d3pId1djTDBFZDQxMHZXcEZG?=
	=?utf-8?B?aGxMQVBZQmFnMnp1czhkQWh5azhlcXh2aDBQUURnbnBTWC9SWmJVYVg1dlRQ?=
	=?utf-8?B?bHl0MWNoMzY3aG1weDN0LzdGMEtSdEI2clJjVkI4Y2p1L09RRmhxK3BHd0I5?=
	=?utf-8?B?UlhudkNEM3NydXBrejBjYSs0NVBRR2ZpMFpIZTNkU3dtenRRMXJZWjNEdXdK?=
	=?utf-8?B?cG5UVG44SGxRbVo0SGtCY1JKN1BsQ2RyK0wwejZJQ0p6NlU2Rkh4dnp6UE1J?=
	=?utf-8?B?Z2Y3RnRvQlhncUFoTldHcXNxRittV2N6UURBTUlzL3p6MXFpaDJGRnYyeTB6?=
	=?utf-8?B?RHZlbzZINFBmdXgrYWh6TWl5OVlEd3EwU2l1VzkrS1gxTHcwWGtkL2dSYnYz?=
	=?utf-8?B?Q0E9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72981cad-5016-4515-929f-08d9e6936294
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 21:31:33.7183 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yE7iUva6FpeE7GmlJ5uOBabfaKIPLiMGgW92O7hdeNEsbsn1GxdbZ/PgW+rN+yqhVjHwNBI6PEx20ZBd6kpS0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3435
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10246
	signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	adultscore=0
	suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
	phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202020117
X-Proofpoint-GUID: edYPlANiHWhGuHOb_lcUDfDlmUpbfFfR
X-Proofpoint-ORIG-GUID: edYPlANiHWhGuHOb_lcUDfDlmUpbfFfR
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 212LVqdt019613
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
Subject: Re: [dm-devel] [PATCH v5 7/7] pmem: fix pmem_do_write() avoid
 writing to 'np' page
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
Content-ID: <2C6B0D0D7F377D46A374677B18E0B772@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/2/2022 5:28 AM, Christoph Hellwig wrote:
> On Fri, Jan 28, 2022 at 02:31:50PM -0700, Jane Chu wrote:
>> +	if (!bad_pmem) {
>>   		write_pmem(pmem_addr, page, page_off, len);
>> +	} else {
>> +		rc = pmem_clear_poison(pmem, pmem_off, len);
>> +		if (rc == BLK_STS_OK)
>> +			write_pmem(pmem_addr, page, page_off, len);
>> +		else
>> +			pr_warn("%s: failed to clear poison\n",
>> +				__func__);
> 
> This warning probably needs ratelimiting.

Will do, in case bad hardware is encountered, I can see lots of warnings.

> 
> Also this flow looks a little odd.  I'd redo the whole function with a
> clear bad_mem case:
> 
> 	if (unlikely(is_bad_pmem(&pmem->bb, sector, len))) {
> 		blk_status_t rc = pmem_clear_poison(pmem, pmem_off, len);
> 
> 		if (rc != BLK_STS_OK) {
> 			pr_warn("%s: failed to clear poison\n", __func__);
> 			return rc;
> 		}
> 	}
> 	flush_dcache_page(page);
> 	write_pmem(pmem_addr, page, page_off, len);
> 	return BLK_STS_OK;
> 
> 

This is much better, thanks for the suggestion!

-jane


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

