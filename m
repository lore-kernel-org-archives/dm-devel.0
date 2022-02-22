Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AEF8C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 20:44:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-83ikOv_uNieioz3ujcko0w-1; Tue, 22 Feb 2022 15:43:59 -0500
X-MC-Unique: 83ikOv_uNieioz3ujcko0w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 524711006AA6;
	Tue, 22 Feb 2022 20:43:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 457F599D1;
	Tue, 22 Feb 2022 20:43:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3B74B1809C98;
	Tue, 22 Feb 2022 20:43:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21MKhldw002700 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 15:43:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7EB737AC7; Tue, 22 Feb 2022 20:43:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 789D879DC
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 20:43:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76AA080B707
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 20:43:41 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-241-7dvJt9pPMC6GY7RV7225KA-1; Tue, 22 Feb 2022 15:43:39 -0500
X-MC-Unique: 7dvJt9pPMC6GY7RV7225KA-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21MHwug5018150; Tue, 22 Feb 2022 18:59:14 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ecvar1sdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Feb 2022 18:59:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21MIuRf9074906;
	Tue, 22 Feb 2022 18:59:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by aserp3020.oracle.com with ESMTP id 3eb481d6f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Feb 2022 18:59:12 +0000
Received: from SJ0PR10MB4654.namprd10.prod.outlook.com (2603:10b6:a03:2d2::16)
	by DM6PR10MB3322.namprd10.prod.outlook.com (2603:10b6:5:1ac::19) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24;
	Tue, 22 Feb 2022 18:59:10 +0000
Received: from SJ0PR10MB4654.namprd10.prod.outlook.com
	([fe80::f81a:f3f8:6f54:fbbd]) by
	SJ0PR10MB4654.namprd10.prod.outlook.com
	([fe80::f81a:f3f8:6f54:fbbd%7]) with mapi id 15.20.4995.027;
	Tue, 22 Feb 2022 18:59:10 +0000
From: Ritika Srivastava <ritika.srivastava@oracle.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH] kpartx: Add -P option for partition scanning
Thread-Index: AQHYKBnsJmIySWp7m0mbNAOxajLQBayfZjwA
Date: Tue, 22 Feb 2022 18:59:10 +0000
Message-ID: <89458D66-751C-4FCC-8735-E94645EA9AD8@oracle.com>
References: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
	<20220222182732.GV24684@octiron.msp.redhat.com>
In-Reply-To: <20220222182732.GV24684@octiron.msp.redhat.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 495daafa-8b5e-4a43-28f2-08d9f635692c
x-ms-traffictypediagnostic: DM6PR10MB3322:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3322D56F61AF1FB69ADC3CDC8F3B9@DM6PR10MB3322.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: VovQpIcoFMjRU5xr+gQtLJJGCKjmRnQVnuUTTaerjGgcMkW12vr8PBalksth5I6A4QmZjt+tW2pGRWLekrCmZAHQkkQ5PknQRY3WCb8oh1Q8WpYXNtG6/x/YoeLGkKijFqMK3LLr0CSrVfNJ4xfI4abJJU1tsQWQxvyWq0bfjTAeiInnvkn2WG/H0cj6vqgf0JThs1Gw/vm2IfVCmYwj78m4iiF6XdQyDdji8WSLQagPhz4mGJThyBzW68IU/Pm7/r8Mo3x/vzAT4H4zqBPwx4PHU3c2G++S8HxRdvpCWpThE29ILEmWoXREJnKHH8TJr6fik4q/rBzNKdtbbCzqBPyuHcjahXfX2ymhip/hBs+CzdDgkcVkJoIP+DxAIKoPnf827AU/kAi9E/Ghp2RynBLW4Jm26A2+skGluO/byIoIfPiv/D4l7YcLQGh+1sgvQc5IaQfZRPgxGYfV78H7SQT7zqZ7q+2FEZVEm3ExwS9iJAKVDYestGfptc7sVoM9JpyM2RSwZL4EzeiAyAPYR17GbkY+vvMrumC9OlyHE+Jt9yBfVOkMHKa6KUML9L8UCoijPsGU/wnfgCpwN6jgKa/kOwRv74wueo+xYXNxxYHsP9/FdPA3hkLAIbxj2OTBaz7F7tjAZ7rNocmqM7A/XoNNYcLmSwmvn77sdBhgLpTPF3J4PqzPh/DJmepjauyzLeAnlE+eOmIJZPESpkFMPwzcFVFsb40g9suXMvKeDf+uG0whB8Wl0vVNH1CtD8XO
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SJ0PR10MB4654.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(4326008)(38100700002)(38070700005)(83380400001)(8936002)(36756003)(44832011)(5660300002)(2906002)(33656002)(2616005)(53546011)(6506007)(6486002)(186003)(66946007)(76116006)(6512007)(66556008)(122000001)(450100002)(86362001)(508600001)(66446008)(316002)(64756008)(66476007)(71200400001)(8676002)(6916009)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejhLNzY0dFN6WU1WNDhtdTl4ZUpPYmpFcitQK1o5OVFCUHRiSWpmcG5TRFl6?=
	=?utf-8?B?QkRobzdaNUtKWUwzVWxsYlBhTFJzMk5YNS9tQnpJOXJlZW9TODBUbTFaUXR1?=
	=?utf-8?B?KzFXeDlNWktDR2lKeFFaL3dLaVlFYjRQLzJKVXVyMkRZQ2JFUmNxY2I2NXdZ?=
	=?utf-8?B?c01xN3A1dmVVSWNhTkRYSFF2WlRIREViOGM4cVJRRksxODBDZmxtSmNDcGxU?=
	=?utf-8?B?SU9Ud0Z5cCtiUUZ1T1p2SzVQU3FuNEdpNW9HcVgzTndRcEkxYituWnlxSDBz?=
	=?utf-8?B?SHFSMCsyL1VXcmdqbmN1NFlOQ05TUmFVdE1zVFRnTFR4WmZBK0hyNjZIUXNG?=
	=?utf-8?B?TDcwR1FOZVM1M0tSVTA3c28rMVBXY2JHVzlBUVMxWXppSjF1VSttdU5QUWZ3?=
	=?utf-8?B?OEp5engydmhYeUF4OU1NWnk3bXQzKytIV1FhTmYzcm1HMGtsN0d6WEZpb1Ur?=
	=?utf-8?B?NWlFanNERFpMM1daMVFieFlCdE1QNTE3QlV6QmtYdi9VdXhCUUJVSVFVRE9p?=
	=?utf-8?B?YVlGVDArMnhvMEF0eXEvREJoUTdqdVh6V3dzYzRxVW9Kc0VWT3VsNkJrcGN4?=
	=?utf-8?B?SzdnL0J0eFBlb2hlY3NyUDZqL3I5L1NNWW4yYXp4VEVSNHhTdTUrbEs1OXI5?=
	=?utf-8?B?alhXNGxHQzFqOTh2QVlMMkFqS3M4d3gyMGtSWGgzSGdGelA2YnQrc2hJaG04?=
	=?utf-8?B?NEVYTzVONk80TlVOZC9TTEJub1Qvc25oZ01KeUNBNkdLV1VnV0kzbWR4VUFi?=
	=?utf-8?B?N1RtV1NTQm9xRlp0OWQyU1R0dTB5N3pCTnFkQnFPcE5BLzM2bTNURkRlU0w2?=
	=?utf-8?B?ODc1azk4WXd3cGdvWFEvN2hoUzlSSGRROVNiV1VCS2tYOXlLeENvSEhmNUxM?=
	=?utf-8?B?Rnc1Rk1VNkovR0FCU295em92K3VBdG9kN3hDT28rdXZaQXpsT25pZ0xmMTg4?=
	=?utf-8?B?aTFkck9Gc0t5ZEZQenRvMHZOSmVSOE1MK2lDWmRpbHRNLzFxVXFLVUZtR2Zi?=
	=?utf-8?B?NlhmNTdtWnEwN2t6enp2VHd2Rml4RjNGK0g0SGJBdFZsN0x6YTZzZXphZ1VB?=
	=?utf-8?B?Yml4N1hzcVZQM0dqUDhTQkVSTDJ4R3A0czYzSGxkL2hWeWFCdGQ0eGE0UlFP?=
	=?utf-8?B?TU53aXhVREZ4cVpBNGl2bFpYdS9idjhwR0lnYUk5N2NlM21pZmJ1NzJVelg2?=
	=?utf-8?B?a29QT21tNHVpeFJpWVJ4STIrUTNzZ0ZuMUtvWUFoaDVhM2xkRkk1NnBxT0Ry?=
	=?utf-8?B?L1V2eXRUMFd2ajZxV3VQenFJOTJZb01UbU9lSlJudWU3UFYyRHdwTXcvYkFW?=
	=?utf-8?B?ZlRaSmIyZVRtU0UrQWMzdFNrQnFhRk9uN1lveUNCWXU3ditjNVNmQURnb21k?=
	=?utf-8?B?bTJhWmNCRlJUUFJZYTF3UFEwcEk1VmdiN2FuanJRR0hwbHQ4ZlQ0SDJ5bmR4?=
	=?utf-8?B?OWs2V0sveEdvRnArUVhHa3ZvOU51NUJ5dVRBMURvMGNDa2RKQXpGbUMwL2xF?=
	=?utf-8?B?a09JZEVneXFzb3I2Rlc1RVhSK3NPTFQvZlVEUVdNMUVzMHV3WjVWclRaUEh6?=
	=?utf-8?B?SldtM3RUTG1seGNLMkZVeldFaGZublhOblJ3SUtGcTZCYXMvYWtrOW9KQlUz?=
	=?utf-8?B?aDN5Sy9lSkRrYzk2OFFnSkpZOG9QMUt0c202RHAxUGhZNkQwTEpQZFRTVWo0?=
	=?utf-8?B?WHowUm4waGs4blN5c050WjBaR0Q1UjRWVUtTQU0zcVFmbC9SbHVLaG5EOEN3?=
	=?utf-8?B?TUFtTFdWYjYzZjBMaFQvV0NiNUdqRzJqcC9tcTZ6disrbnFWVWpObHFSQkVZ?=
	=?utf-8?B?N0VUV2RrNmlSV253elRaQ29BNkQyTW93M2JKOGZ6MEFWV2JZdUxTdUJLWldT?=
	=?utf-8?B?S1d1S2Vib1IxZEplTnY2KzN1Y1BxUDFnSmdJSjd2a3MxOGVPNDZhVGVURksw?=
	=?utf-8?B?ODVFSFMrTzRSZzJIb3ZBMWIwNVhVakFER05pazFhZUttKzZJeDQ0US9zeDFa?=
	=?utf-8?B?bEJWdkdYZS9YUFFWamVNVEdUZG9Gbnd5N3RXTVI2bGN5N1J2QUVvMzdBY3V2?=
	=?utf-8?B?Unl4UEFrNS96djRxMDFQVUpxNlFZYi9XS0trdVBCOStEU2pRbXlCUW1iekJC?=
	=?utf-8?B?NHNrYktyUlVCeWpmd0VObElBUUZodTJFRWJOQjRpNDZPakZ0MlREOGQ1YVAv?=
	=?utf-8?B?aTB5a1g0QVFsWHpoSnUwdDdhWmU2OVVrY2lkZHQvVHI3UzJCaUVtZmJzSEw1?=
	=?utf-8?B?RG1QaC9aSGlQNXlicnJET3NnSFlvZjU2OWhZR20wVUQxWmJFWmNFOWc4S1lt?=
	=?utf-8?Q?LK23nvn6gU9plepjAo?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4654.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 495daafa-8b5e-4a43-28f2-08d9f635692c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 18:59:10.6743 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VQEz/TybIbzbZUoZ6MZLJFGcQO76s4LPXjxmkyCBJcnux/wtrKnQPBKGu858XQc5bTOKma7U59iF40ds9gCjJTPElrz//7BA2bUEElb77Ic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266
	signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	malwarescore=0
	mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202220116
X-Proofpoint-GUID: 4TIpvuwSZEpJuHLX6kDr51JPNConeEo8
X-Proofpoint-ORIG-GUID: 4TIpvuwSZEpJuHLX6kDr51JPNConeEo8
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21MKhldw002700
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <AD686926ED261F4E9EA2A671F24A9B43@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/22/22, 10:28 AM, "Benjamin Marzinski" wrote:

    On Fri, Feb 11, 2022 at 12:41:48PM -0800, Ritika Srivastava wrote:
    >> Add -P, partition scanning option to kpartx which would set
    >> LO_FLAGS_PARTSCAN flag during loop device creation.
    >> This option is same as losetup -P option.

    >I'm confused here. What's the benefit of doing this? Doesn't this create
    >partition devices, just like kpartx would?

This enables partition scanning for loop devices created via kpartx.
When enabled, LO_FLAGS_PARTSCAN flag will be set during loop creation via kpartx -a.
On detach (kpartx -d), any partitions (/dev/loopXpY) would also be removed.
It has similar use cases as losetup -P option.

Currently, kpartx does not create partition loop devices (/dev/loopXpY)  via kpartx -a

Example:
1. Current behavior: kpartx -a does not create /dev/loop0p1

# kpartx -av test.img
add map loop0p1 (252:0): 0 99937 linear /dev/loop0 64

(Notice below: /dev/loop0p1 NOT created)
# ls -l /dev/loop0*
brw-rw----. 1 root disk  7,   0 Jan 14 20:46 /dev/loop0 

2. IF -P IS USED to create loop device, /dev/loop0p1 IS created.

# kpartx -av -P test.img
add map loop0p1 (252:0): 0 99937 linear /dev/loop0 64

(Notice below: /dev/loop0p1 IS created)
# ls -l /dev/loop0*
brw-rw----. 1 root disk   7,   0 Jan 14 20:50 /dev/loop0
brw-rw----. 1 root disk 259,   0 Jan 14 20:50 /dev/loop0p1


Similar behavior can also be observed during detach
1. Current Behavior:  kpartx -d does NOT delete partitions

# kpartx -a -v test.img
# parted -a none -s /dev/loop0 mkpart primary 64s 100000s

# ls -l /dev/loop0*
brw-rw----. 1 root disk   7,   0 Jan 14 20:54 /dev/loop0
brw-rw----. 1 root disk 259,   0 Jan 14 20:54 /dev/loop0p1

# kpartx -d test.img
loop deleted : /dev/loop0

(Notice: /dev/loop0p1 NOT deleted)
# ls -l /dev/loop0*
brw-rw----. 1 root disk   7,   0 Jan 14 20:54 /dev/loop0
brw-rw----. 1 root disk 259,   0 Jan 14 20:54 /dev/loop0p1

2. IF -P IS added while creating loop, kpartx -d DOES delete loop0p1

# kpartx -a -v -P test.img
# parted -a none -s /dev/loop0 mkpart primary 64s 100000s

# ls -l /dev/loop0*
brw-rw----. 1 root disk   7,   0 Jan 14 20:46 /dev/loop0
brw-rw----. 1 root disk 259,   0 Jan 14 20:46 /dev/loop0p1

# kpartx -d test.img
loop deleted : /dev/loop0

(Notice: /dev/loop0p1 IS deleted)
# ls -l /dev/loop0*
brw-rw----. 1 root disk  7,   0 Jan 14 20:46 /dev/loop0

Thanks,
Ritika




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

