Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A47C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 01:01:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-D4OoBoCQPTeq3rY3PGtSLw-1; Wed, 13 Apr 2022 21:01:03 -0400
X-MC-Unique: D4OoBoCQPTeq3rY3PGtSLw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8509E1014A67;
	Thu, 14 Apr 2022 01:01:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 31BF51457F13;
	Thu, 14 Apr 2022 01:01:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E8A831940347;
	Thu, 14 Apr 2022 01:01:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 462F91940345
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 01:00:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2978A1457F23; Thu, 14 Apr 2022 01:00:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 241CC1457F13
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 01:00:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 045F6833969
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 01:00:59 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-JStr94d7P_2VXmSSR_ztTg-1; Wed, 13 Apr 2022 21:00:29 -0400
X-MC-Unique: JStr94d7P_2VXmSSR_ztTg-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DLIGjY001710; 
 Thu, 14 Apr 2022 01:00:10 GMT
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
 by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2kgcf-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 01:00:10 +0000
Received: from pps.filterd
 (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 23E0vSeI029757; Thu, 14 Apr 2022 01:00:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
 by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id
 3fb0k4xx1r-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 14 Apr 2022 01:00:09 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BY5PR10MB3890.namprd10.prod.outlook.com (2603:10b6:a03:1f5::24)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 01:00:05 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::1c44:15ca:b5c2:603e%8]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 01:00:05 +0000
From: Jane Chu <jane.chu@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Thread-Topic: [PATCH v7 1/6] x86/mm: fix comment
Thread-Index: AQHYSSYYGFAW2NTmbUWesvhenggRg6zsFCQAgAKPhIA=
Date: Thu, 14 Apr 2022 01:00:05 +0000
Message-ID: <e0f40cd6-29fd-412d-061d-d52b489e282f@oracle.com>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-2-jane.chu@oracle.com> <YlVMMmTbaTqipwM9@zn.tnic>
In-Reply-To: <YlVMMmTbaTqipwM9@zn.tnic>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93270fb4-93d6-4840-eb72-08da1db21d49
x-ms-traffictypediagnostic: BY5PR10MB3890:EE_
x-microsoft-antispam-prvs: <BY5PR10MB38900C855FA33FB705DBB74AF3EF9@BY5PR10MB3890.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: bKra7YdMCjejPGYlz8XU7yK8qVPAGKAIb6jMvDXWswtPpyqJ6LNkQctIjcuZUszY0RZrCjbrkdSDnhzxUkUWQbX3YGhyZP2jjL3UNenMw+eCCpaQBV0+xrtzak84ouWY1ay6UJ5IsCPAFYcGS5gp4guNdTb5cleJIS8CabCmg83jgsqvFSp/2CfX6AyvtTnrl9hPTravqdqK+ggEc6ZYP7MErifeN6Gt1zWXulYYe96tu1ZEvA1PPeuley4YMxa9fFH9cAqZnuVfbytzYgDCTC09mPVafOX1ch/xO1owS9qCoBFrhqSTy/ftdb5gQSHHSLhufec+u6NRLs6a26R7QsUKqU5POthVFZms8TfEnDs/mCelNoz9/aATCmx9azVtGIwy2eK1WRPrAMhy3vjoCQ5FU0LJnmsu+LTa39rwnNjeVjpgSC840NyilRdFy2N+/hAEltW3QfXj72yhgPiRoSvQSbh5HqOvY4lt4IZviYq9CZKwXWeZI7tMK1GxCKApztSpOMOlCBAxbEBrsUHHV0BiTZSv5dp6DdPmKd/MjgbtiTZthya/PDPjNbor5m61/eVn05jevQsLDTkxi1jhwXUo9wn6yv1ET44whgCoKndCgz29utejrg+tB+PBQMzbXXFyVi8g19xTHQED5nr2+10YaBvlmDNaOuCfSkBhvTiCOd2007o862MCCx6HF92K23qDmjUrG2apXdql5btubaRZbdFiCOrhB7enSRFdopy0BI7oEpk7lUOJ9jMavC12al0tRygHQ6BalufiQIcInQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR10MB4429.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(66446008)(2906002)(66946007)(64756008)(31686004)(71200400001)(66556008)(76116006)(8936002)(5660300002)(38100700002)(7416002)(38070700005)(44832011)(6916009)(86362001)(316002)(4326008)(31696002)(8676002)(54906003)(122000001)(66476007)(6486002)(186003)(26005)(6512007)(53546011)(6506007)(83380400001)(2616005)(36756003)(508600001)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjU1OG1Lb0Y4ZE5KU0RpQjZuUW5RZUtUZGtETDY1RHRueG5JSzlGL2NhWWl2?=
 =?utf-8?B?cURWU2NhQnFKQVMyVUJOQWptb0RZMHVESS8wL1VXWFVOeDc3UFFJUlIvaHcy?=
 =?utf-8?B?MU5nVmhCMzAyRUlZU2w5eGVPMCtyMWhrVHJ5bW93LzAwaXJVK3RsUnpGQXdO?=
 =?utf-8?B?Z2dxU0ZrdXI4T1RrZ241MHJHdTZ6SzhDWVhtd3ZGQzZUQ0R3SDdNQVFjOTlR?=
 =?utf-8?B?VW1qWmpZTGhXTTFtRUxvMTJnL3YzMDBjRkl1czREbzF2TDlDNDZoTmxZU1py?=
 =?utf-8?B?SlBVSE9pb3g1RkxsWlk0WUJwVDc3N0d3VTFmWllmQmFXNUU5dE0zMzdJTWlu?=
 =?utf-8?B?S0x3OS9OU2pzRVdaV090VGt5dWlicU15YytwbHJtR1lzOWhNUTRtdjJXb2g2?=
 =?utf-8?B?ZWJ0ZXFhTDh3S0NueWQ3cURJZ0ZPb1BqS3NjREhjWk5MREQzekdvR0lMaFJ2?=
 =?utf-8?B?REJUc2NDTWZaVmJ2Z1pEc25DQ0c3TFFFVGZGTXY2d3hZSU5PVXduUlFaV01J?=
 =?utf-8?B?aWhqbkY3cHd4UFQ5N3dmeEFYYTBxeVRrY3VPUVJjWk9mQXFnd2Q5dWk4bVJV?=
 =?utf-8?B?b0VjZnVpeDlaTjZxNHhNRFFnbnY5V3Y5Q2R3S1lEQXlad1Z0SWI4MDZ1RXNu?=
 =?utf-8?B?dXo0aFFXRlUxcnNOcEJpcjEvS2lIWmU4c1VOdFVPNktlUVdhMFpYU1Q1S29G?=
 =?utf-8?B?Z2x5dExSaFpnaTQxcUZhOUpPemQzbStqN3d2bGtsc2lmZ3Z6a1RaVzcvb3FF?=
 =?utf-8?B?L1FocjdsVlZvRGZhdm94SWhtS3VTV3ZkanhBTlFIa1YrQm5sN2p4VGZ1bk5s?=
 =?utf-8?B?WTdNdXo3aTlib3V5b3hiNTFZK3JIVmZEbHdzMXpKaU9kcjljUXZRcHVNci84?=
 =?utf-8?B?S083WDVwSnNJaUFhOEpLaGZkd3FIRGxBU20vcDdvSU43WS9PdkRoakIxTnJG?=
 =?utf-8?B?NkdseXM5anJpQWNMTk5HcGt4dHM4MU9OYVhzelZ1WFlld3lpT0l3cE9sVXlv?=
 =?utf-8?B?MUlQY0ZlUUtEOHhFOENOWDc0b2g2QmV2ZXNiUDZ2dzgydkk2SFQ0eWFpc2pH?=
 =?utf-8?B?TjJIMFlsc01pTi9CUXRpK3VCWVlXQ3YwSG42YXp4OVJGbE5LOFJwUlNyQnRO?=
 =?utf-8?B?V09LdXQvWXp4VFpMNXFYNGFLNnJxbjlsOExyNlRqbUkwUFRnNHpyTnRaRWRC?=
 =?utf-8?B?dFg4aUVUV2xiV3pKWit3ZjZJY0Y2NXp5QXBSbVEwQXVTOFJqcWxCTENldjQy?=
 =?utf-8?B?cytEMy9aaElUanB5Ky9SZ0toMWFoUjZNMGdRc0IrWkZUWEtLZjVGTG5CVjd5?=
 =?utf-8?B?eEM3SmtMZkFydkErWVNadjFsSklZakxQbjZ0OGZwME5XNGlBeHBESHpzUkJ0?=
 =?utf-8?B?cDVUYVBHL0hrdWhYRXFTdWNVUGdkMXkyZTMwWU5OMFh2ZHA5RzU0VUFJNDdZ?=
 =?utf-8?B?NEFnenBhYzdSdFpCZlJ6Rkg2Q1JqbnlYYVNaaTlFL3BWYVJzQmc1ZURvdVBV?=
 =?utf-8?B?TGFZMHBBbyszc0h5N1htYXpwM1Vib3ppZWpBUEJNT0dibGxaS1doU3hBQ08z?=
 =?utf-8?B?dDV6NWg0S2hCODJRK1h1Tyt3YVRYUDdkTzBzdEJ4ZXVrV0ZCR3BZcXMxWVhD?=
 =?utf-8?B?UHNwNE9BdjE1Z1F3ZHZsNXVHZ3pCREt0V3V5VW5LUWpPOHYyaXUzNm5GeEZJ?=
 =?utf-8?B?Ym1XK1F2MUZlQ294VmhyTk1mQXJoTUU2M3pZYVNnSjY3bW93cHg3ZlBodnAv?=
 =?utf-8?B?cktKckJSaXdnMWZ3TiswSTNmVVh6RUJRVms3a1hEK25OWUd5M1YvbVlwWi9T?=
 =?utf-8?B?TkJzY0tyWHJ0cjR0anBNUVRVUVBEQURxeWIxaXlJbkNRSFNiRXhlWTJNc01v?=
 =?utf-8?B?VDhrb2dxdWxwOWVBZmNJR0ZSemlsaUl3bEYwV1hZT0xwcFhYM0RIVThSVS8x?=
 =?utf-8?B?Mm9aVFpNVzkrcXpwNXY3R1lpWjFlSDJqUFFYWHI1NVdUTVk3Nkt4VThybkZL?=
 =?utf-8?B?SWZCMG5VWmtpUFJjMTcxVGV3SHY3ZElnY3h6ck1VSHVmS2RNd0ZTUzE0VUNE?=
 =?utf-8?B?SVB1ZHgrYnA3R1dGdXJQUGE5U1dtcnBjNlppN2NtV0tLUVhjRHlXR2FxMCtp?=
 =?utf-8?B?SW9sMzJldW1tbWJQMy95anF3Z1BjSHJnenZWemc0VE5kVGdqYnYvdnc0Q01M?=
 =?utf-8?B?V1RzOVRmam8ycVM3N0RsYXR2TXRKellMSmluS2JtS3dEZkg5MFplazMzR3NL?=
 =?utf-8?B?WkxmZVlhc1hveGJuOXJzT1Bad2dEMFpOMEs5L1JRa0xVT2hDMjFkR2M2dXFa?=
 =?utf-8?B?bHlxYVN1TWFYUldIN0czMlBKcVRabVZpV0pSY2Nncnd1TDdJajZ2dz09?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93270fb4-93d6-4840-eb72-08da1db21d49
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 01:00:05.8008 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QeKXrBvcAsPUA2MSzYelvMKy25jxNKYstAn+XIKl2qICeJyIU7fhqr9lFpNYyUBP0XfMBRnQuUGQRgnyXyFMfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3890
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486, 18.0.858
 definitions=2022-04-13_04:2022-04-13,
 2022-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0
 malwarescore=0 mlxlogscore=782 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140003
X-Proofpoint-ORIG-GUID: rQ0trxTQRjXB26Yhv9rKNSObzDp32m3g
X-Proofpoint-GUID: rQ0trxTQRjXB26Yhv9rKNSObzDp32m3g
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v7 1/6] x86/mm: fix comment
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A20886CCA0399C48A914D13C339EEDA1@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/12/2022 2:53 AM, Borislav Petkov wrote:
> On Tue, Apr 05, 2022 at 01:47:42PM -0600, Jane Chu wrote:
>> There is no _set_memory_prot internal helper, while coming across
>> the code, might as well fix the comment.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   arch/x86/mm/pat/set_memory.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
>> index abf5ed76e4b7..38af155aaba9 100644
>> --- a/arch/x86/mm/pat/set_memory.c
>> +++ b/arch/x86/mm/pat/set_memory.c
>> @@ -1816,7 +1816,7 @@ static inline int cpa_clear_pages_array(struct page **pages, int numpages,
>>   }
>>   
>>   /*
>> - * _set_memory_prot is an internal helper for callers that have been passed
>> + * __set_memory_prot is an internal helper for callers that have been passed
>>    * a pgprot_t value from upper layers and a reservation has already been taken.
>>    * If you want to set the pgprot to a specific page protocol, use the
>>    * set_memory_xx() functions.
>> -- 
> 
> This is such a trivial change so that having it as a separate patch is
> probably not needed - might as well merge it with patch 3...

This change used to be folded in the mce patch, but for that I received 
a review comment pointing out that the change is unrelated to the said 
patch and doesn't belong, hence I pulled it out to stand by itself.  :)

thanks!
-jane

> 
> Thx.
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

