Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43374C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 22:21:30 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-Veyc3AIbMRexNzoNqa_WJg-1; Tue, 22 Feb 2022 17:21:25 -0500
X-MC-Unique: Veyc3AIbMRexNzoNqa_WJg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7925A1006AA6;
	Tue, 22 Feb 2022 22:21:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73B974CECB;
	Tue, 22 Feb 2022 22:21:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A150946F9A;
	Tue, 22 Feb 2022 22:21:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21MMGg66009901 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 17:16:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8D95F400C849; Tue, 22 Feb 2022 22:16:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 886AC40D2962
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 22:16:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B4D4805F46
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 22:16:42 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-594-fftwlOPaMCGWFowZsKBXjw-1; Tue, 22 Feb 2022 17:16:40 -0500
X-MC-Unique: fftwlOPaMCGWFowZsKBXjw-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21MJOBv2028053; Tue, 22 Feb 2022 22:16:38 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cjgwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Feb 2022 22:16:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21MMGTsR016458;
	Tue, 22 Feb 2022 22:16:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by aserp3020.oracle.com with ESMTP id 3eb481mum7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Feb 2022 22:16:36 +0000
Received: from SJ0PR10MB4654.namprd10.prod.outlook.com (2603:10b6:a03:2d2::16)
	by BLAPR10MB5169.namprd10.prod.outlook.com (2603:10b6:208:331::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21;
	Tue, 22 Feb 2022 22:16:35 +0000
Received: from SJ0PR10MB4654.namprd10.prod.outlook.com
	([fe80::f81a:f3f8:6f54:fbbd]) by
	SJ0PR10MB4654.namprd10.prod.outlook.com
	([fe80::f81a:f3f8:6f54:fbbd%7]) with mapi id 15.20.4995.027;
	Tue, 22 Feb 2022 22:16:35 +0000
From: Ritika Srivastava <ritika.srivastava@oracle.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH] kpartx: Add -P option for partition scanning
Thread-Index: AQHYKBnsJmIySWp7m0mbNAOxajLQBayfZjwAgACPNID//6fzAA==
Date: Tue, 22 Feb 2022 22:16:35 +0000
Message-ID: <441B1763-CC1E-4283-BA94-F5FF856CE1AB@oracle.com>
References: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
	<20220222182732.GV24684@octiron.msp.redhat.com>
	<89458D66-751C-4FCC-8735-E94645EA9AD8@oracle.com>
	<20220222193143.GW24684@octiron.msp.redhat.com>
In-Reply-To: <20220222193143.GW24684@octiron.msp.redhat.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe634194-8c3a-4038-81db-08d9f650fd0a
x-ms-traffictypediagnostic: BLAPR10MB5169:EE_
x-microsoft-antispam-prvs: <BLAPR10MB5169DEBA85C2983B072117808F3B9@BLAPR10MB5169.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: AykiIDYDYSbJRC49LScV9bySkdKjFMoI/tDcpRQUDHSWTBe1g0MuTDpI9YPZV6lxqpl40Dhaf6Q2mTnYCP8ht+r3FP7ScVMuuS9t5MiSRrKkMaW79BTsot0pyyqPGuQSKyGdjdQ738Z6hrKJZyS5g6mTtJ6Jd3e3htfrjmJzQVpxxdQymv9QY4bJcRVt4EtwJaabi0cMle/95F87UwnHDsMIT5hReAZaQksohKfHeFYtS5y51hzn2moKt3l13ZWg4HBZCvmRvYdfaLGUK2Q/ZsQOwqWcF3ixN/uAaEasgy4NrPxy6uA1W3IOkKog2cSCC04mDQzFPxRJkBduFGTJn49HP/X/xqPUTRwizYZMpvRdDAf+qIhQA7gb9tV43/5nzzmGGZsaob4wi2Q6/M8VdEpPb892eDL2spaxQm7UTM7VykzcaxrrcaPtv61uNYYfiey98WFQB8Y/kDgsJhIzXIQXIwrlQFCHQdD8FS+or5CLoUjFssGE8Lc9ZoUK/5lK55KpyCwZW8VzNPu9jWlgQVyKJ+p6ukc2/asRKxwZ79nNCoUwvOtGbLS6QHTHcWtfVsLaHIbcwZvROR/+r/wi9V41lOtgDSavNjGMg0vH4L7TYzLRSt5OFttsXy+Ohp13/7sePIodW3IyM8bqp5kCQeJrGvzRQODmI3YZ4Z8kJM3WEroYq2PwlOfQz82YeaEj4UGQJK/HWDigU7CbuP7p1UN9urv5xkUy6WNErZUZGmo4Y/Cr5LZaP+tihO1ltSmp
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4654.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(66556008)(66946007)(66476007)(8676002)(4326008)(66446008)(64756008)(316002)(91956017)(450100002)(33656002)(76116006)(508600001)(186003)(6486002)(44832011)(36756003)(6506007)(83380400001)(38070700005)(2906002)(6512007)(53546011)(2616005)(5660300002)(38100700002)(6916009)(86362001)(71200400001)(8936002)(122000001)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTJwMm44OHp6Zzh6Q1RMbHJWOE1tQlFoRHhNNi90WGpsNWRSbU9qRXNKS1l4?=
	=?utf-8?B?OU1SYjlQRHhTS21JaEVnREhLR05nSWZZZXhPV0RSNlNqZE5sR3poZ1dSZjk4?=
	=?utf-8?B?WDNDYVhXdzVwRzVZUGlSOWRmTVZjeHQyM2ltRjM3cTNJUWhib0dqaUk4UmpK?=
	=?utf-8?B?dXBmdUtCR1pRTkhjUXdEdk95SHBLeU5kajNjQ2ZzTllyaklEaHJWRDg2aGRX?=
	=?utf-8?B?d2puRzRjZC8zRzdwc0I1ejZnamk2eTI4ZkhCSXk5NHdMWnZFWENJUTd0dDR4?=
	=?utf-8?B?TmRkRFREUXFtdWlUbWdtSEgyV3d5WWVDWjQ3OU9sL2ZZcVVnSVBDQ0RDY1lw?=
	=?utf-8?B?ejJSbk9ZN0E3d241RVliZE1oVUE4ZUx4Mi9RdVpiYi9kK2RiMjNEZXhaVzkv?=
	=?utf-8?B?UkJaN01lNCtCdHNCcXRncEQ1eW1rUTQ3M2V0MFYrMERrcmMxSmpvWVpua05H?=
	=?utf-8?B?WUgzQlNNTWNCTkMwYklQMVc4Uk81V2VBYmVXZ0tyNWw0ckFwemp5ekJxSmts?=
	=?utf-8?B?MXBaLy9hcTJlNjlWVHZ1czhsczgvdDlFcW1JWlBmeVVUalRhLy80UWVQMnZW?=
	=?utf-8?B?eVJDMWFqN3JFVHMyTVd4VGpxZk93ZlJobWoxWG5IaXJMa0l0R2VjV0R6VnNh?=
	=?utf-8?B?eWMwaXZZL05uUFlNTzJjYkZpSzR4K3F5VWV0bnFuQXRnVVRRb2pkTVNrNWN0?=
	=?utf-8?B?QitxZktjdSs4R1JYSFpINjNhZ1hSdnFETUNDSkExaTVlOVZsa3BuTzlPOGdD?=
	=?utf-8?B?emdPN1BWOFJFejdZQStPaTZnem9aZ2xteGliQXpYelZtcUdKT25XVDdaOEZ3?=
	=?utf-8?B?SzJ2aDZoeEpKZ2FhaFB4Z0dnVHphMFNPVERKK2cwRUl0cUx1QWdyekNCMHB2?=
	=?utf-8?B?dTNHQlFvOXJOTGhWbTlCQ0pUVkM3Zkg5NzBFbDVhajF3azBaN1AzZHpWaVZM?=
	=?utf-8?B?dUtTYWtSTjVPVHhZSkMzODlpNWZiNDBiT1YvVjY4NUsvTkJzYnNRZlRsWWJH?=
	=?utf-8?B?T1IvOWtMbStVUlhnODdMVDNuR2FUcHZqV1hsbmhQQ0dOU2o2bnc2aUFDUFRm?=
	=?utf-8?B?QWhxU0VUcFFSOGsyeVMxdkNxTnRVa0N2bmxhUjRtK2t5Nm1kUE1YSGE5VmRU?=
	=?utf-8?B?VWJ0eUd1YVZDVTBWTXRnZGNKRG11c0NRY1dXZzUxN2dkMXB0NWVzQSsyc1ZZ?=
	=?utf-8?B?L3dIbmdEOGdGd2FkQW9FVzRuZ0E5SWdPUzFnWWxvaHlzM29INTBLaTlXenIy?=
	=?utf-8?B?SHp3WThDNVRyYkhBYXovNUlobjhDN21Rd1BvWDhLWXcrd0dKTERBRzZNc2cv?=
	=?utf-8?B?d2JMNUJMaDJTM3JqK1FUdG1Nd2pzbzJ3bWlSSDR2MHlaTmtOanhETXQ3QURP?=
	=?utf-8?B?OENYekw3SGVGQkRzZndvTHdjZHNqTExQOU51ZUl4dWlQb3ltcEduT29EaDZv?=
	=?utf-8?B?SFhCTlFJeVU5VHZDbDd6TjI1SzVtNUpnODNreU9rWTZvd2dzVWpDSDlDLzB4?=
	=?utf-8?B?QjQyTEZPalJ4U0JxRW0rcW5RSEJSdWplRmxhRktNTFBYOVgrYWpjejJTWFVw?=
	=?utf-8?B?QmlTa2ZrNXpjQnVlRDhGaGVWU3hLWEVybXdFUmtNcjc2eFlSMG0rREM3Y0JV?=
	=?utf-8?B?Q3BMUm40RlkvVTdjM3N2RTVMZ3VUZ1g1cmxld28ydXRmaFRXaEp6M2J0RFJI?=
	=?utf-8?B?K2pEY3ptS3gyK1R3K3VmY2xWNDZBMFRIQTZBU0NQVHBnd0hMVVhlL2pwWjVy?=
	=?utf-8?B?NklUakNKUk9zZUI0MjBBNXM4a3h0emN6OXphQUt2SVhnbEFqS01LMG02bWFF?=
	=?utf-8?B?aFRPTXJFZ3p5cGR1N1NGbzJxZHhJNzJDcC90SjEyWWdmaEtvSDhHb1pzOUpK?=
	=?utf-8?B?VEZvd0Q3aWd6MDhsdSsyTlpZejZUUFAwRGVMbEZUa0xxb3crUjBtSUFaclhU?=
	=?utf-8?B?K2pmS3QwQkZmTEg1cmo4SnR2VEFTaVRYbWdqTytOQ2RRaEM5azBWK3A3U2pz?=
	=?utf-8?B?WE5aeUxNekdSTkdHUU1LZ0RMeUZhQStQVW40U0RqOW1DaEoyRjZPNTdRRC9a?=
	=?utf-8?B?Z0h0YjNHZGJJd2hQejc1RkxvaTcwS3BMZ1gzTDdwTWRiMVVXUGViYUhoSUhE?=
	=?utf-8?B?R2RZQk1Gc2JMVWtZK3lZZWNzR3JmVkJ4dmUrMFlrTkdhT0QxcHhQbzIxZEU2?=
	=?utf-8?B?dXVwTzQ3bUtWa1R6Y1pWbEZtQ0RmK3B6emVwYTVqWjZTTGx0dmhUZmR4ZXcw?=
	=?utf-8?B?NFRQV3VEQWpyemt2OUQ1LzlVVDBUVWJRRFlsdVBGK1ZCL3ZJekdXZ01tdWRU?=
	=?utf-8?Q?gMf1JnHaNN6EXmZ6BP?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4654.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe634194-8c3a-4038-81db-08d9f650fd0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 22:16:35.1995 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tjNcN9vTYo84cu9F60rtCoyOMCzBmohk3MdfyBIShSucvv0Zi3Uvog+lslaV6BjL7BHFH522m1mdEJlJwNoAF6aGG8t/GQmKMRDJav52Qx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5169
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266
	signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	malwarescore=0
	mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202220137
X-Proofpoint-ORIG-GUID: tXBMWjngKwcxHR2seFormUZsKg_Oa1RW
X-Proofpoint-GUID: tXBMWjngKwcxHR2seFormUZsKg_Oa1RW
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21MMGg66009901
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] kpartx: Add -P option for partition scanning
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
Content-ID: <3BB60F3234122347845E67688DA0067D@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Ben,

Thank you for reviewing this.

On 2/22/22, 11:32 AM, "Benjamin Marzinski" wrote:

   > And I'm trying to figure out why you want to create /dev/loop0p1 if you
   > already have /dev/mapper/loop0p1?  The ability of kpartx to create
   > partitioned loop devices predates the existance "kpartx -P". So perhaps
   > the better question is, why do you want to run

   > # kpartx -av test.img

   > instead of just running

   > # loasetup -fP test.img

   > They both get you partition devices, and you don't need both of them.
   > Or do you, for some reason I don't understand?

My previous update may not have been clear regarding the supporting use case behind this patch.
It highlighted what the -P option would add to kpartx.

The idea is to avoid having both /dev/loop0p1 and /dev/mapper/loop0p1 and support the following use case - 
After detaching via kpartx -d, /dev/loop0p1 is still present which on subsequent kpartx -a operation results in both /dev/loop0p1 and /dev/mapper/loop0p1 being present.

Yes, you are right, workaround could be to use losetup -P the first time around when creating the loop device.
Though, having this functionality within kpartx would be nice since kpartx is also used extensively.

// workaround - losetup -P
# kpartx -a -v test.img
# ls -l /dev/loop0*
brw-rw----. 1 root disk  7,   0 Feb 22 20:05 /dev/loop0

# parted -a none -s /dev/loop0 mkpart primary 64s 100000s
# parted -a none -s /dev/loop0 set 1 lvm on
# kpartx -d test.img  
# ls -l /dev/loop0*
brw-rw----. 1 root disk   7,   0 Feb 22 20:05 /dev/loop0
brw-rw----. 1 root disk 259,   0 Feb 22 20:05 /dev/loop0p1

# kpartx -av test.img
# ls -l /dev/mapper/loop0*
lrwxrwxrwx. 1 root root       7 Feb 22 20:53 loop0p1 -> ../dm-2

# pvcreate /dev/mapper/loop0p1
# pvscan
  WARNING: Not using device /dev/loop0p1 for PV <UUID>.
  WARNING: PV <UUID> prefers device /dev/mapper/loop0p1 because device is in dm subsystem.
--                
Thanks,
Ritika



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

