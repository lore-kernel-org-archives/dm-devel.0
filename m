Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2FB3D6E
	for <dm-devel@lists.linux.dev>; Wed, 15 Nov 2023 07:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="leDturxB"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AF5LhbV027011;
	Wed, 15 Nov 2023 07:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=qcppdkim1;
 bh=cutriXTLTOVffQ7QsDoVYKOxZHhwnuH7znd46lucShU=;
 b=leDturxB93v934NS7iHQsyQM/jWQUAY8jBaNLwt+2gubsEoY89eIa0Ja5CFSXzhsooD/
 J2S1o62Aib/yzo91+kufo41kZAx6u8gnrhScE+kg8a+RjE8xZevOeDfEbBUXN5uSWNoV
 BfNcse2XAhnEMCnfi0KpJvbREbdF2JXR8FKDRi06l228J49Fdooa1epZsTHYTSbs4IaO
 7iE12ws72JriS7U8Uf4HMthO+AGI5grgLzAJWk6lTmaR+GZPhNJCM9J3spGvzVPzj6Cl
 MVFbssOH0NhnChzmsyJ7xrxfBiA6xcvC0cakdf2ZESe6Dwmvm77LTEMEX3A+YzYeIJHC KQ== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ucfka96xx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Nov 2023 07:00:16 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3AF70FVK008679
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Nov 2023 07:00:15 GMT
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Tue, 14 Nov 2023 23:00:14 -0800
Received: from nalasex01b.na.qualcomm.com ([fe80::48ce:7e89:ddbd:f50d]) by
 nalasex01b.na.qualcomm.com ([fe80::48ce:7e89:ddbd:f50d%12]) with mapi id
 15.02.1118.039; Tue, 14 Nov 2023 23:00:14 -0800
From: "Aaditya Raj Barnwal (QUIC)" <quic_abarnwal@quicinc.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
        "Aaditya Raj Barnwal (QUIC)"
	<quic_abarnwal@quicinc.com>
CC: "agk@redhat.com" <agk@redhat.com>,
        "snitzer@kernel.org"
	<snitzer@kernel.org>,
        "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
        Ravi Kumar Siddojigari <rsiddoji@qti.qualcomm.com>
Subject: RE: Patch : drivers/md/dm-verity-target.c
Thread-Topic: Patch : drivers/md/dm-verity-target.c
Thread-Index: AQHaEJij4apZxMxWj0m63DynSJD8B7BtpggAgAAPDQCABc26sIAG8j4AgAESJQA=
Date: Wed, 15 Nov 2023 07:00:13 +0000
Message-ID: <dafc402fea3748aeb02efea4c6fd87b2@quicinc.com>
References: <PH0PR02MB859952FC76063896916AA05DF6AAA@PH0PR02MB8599.namprd02.prod.outlook.com>
 <e371659-f86f-e711-ceb6-db9f0fd2e70@redhat.com>
 <PH0PR02MB859987618E8647439950A053F6AAA@PH0PR02MB8599.namprd02.prod.outlook.com>
 <559787b2-9b87-4ce-d5d9-6e16f22bc44@redhat.com>
 <1e9615ee3bf84ab7a3023152e3b94284@quicinc.com>
 <f66b2e7c-294b-60f8-7bd0-a4dff496fb4@redhat.com>
In-Reply-To: <f66b2e7c-294b-60f8-7bd0-a4dff496fb4@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.228.86]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 5sAEGDkY6ZfO-pdwh2a23Wt8JpJXag-5
X-Proofpoint-GUID: 5sAEGDkY6ZfO-pdwh2a23Wt8JpJXag-5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-15_05,2023-11-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 spamscore=0 bulkscore=0
 phishscore=0 mlxscore=0 mlxlogscore=983 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311150052

Sorry if that statement confused you ,  It was debugging print=20
that was added to check if the tight while loop has ended or not.
=20
Code : dm-init.c=20
dm_init_init()
=20
	wait_for_device_probe();
	for (i =3D 0; i < ARRAY_SIZE(waitfor); i++) {
		if (waitfor[i]) {
			dev_t dev;
=20
			DMERR("waiting for device %s ...", waitfor[i]);
			while ((dev=3D  name_to_dev_t(waitfor[i]) !=3D0))
				fsleep(5000);
		}
=20
	DMERR("exiting after %s ",waitfor[i]);  <<<<<<<<<<<here it was added=20
	}
=20
	if (waitfor[0])
		DMINFO("all devices available");
=20
	list_for_each_entry(dev, &devices, list) {
		if (dm_early_create(&dev->dmi, dev->table,
				    dev->target_args_array))
			break;
	}

-----Original Message-----
From: Mikulas Patocka <mpatocka@redhat.com>=20
Sent: Tuesday, November 14, 2023 8:07 PM
To: Aaditya Raj Barnwal (QUIC) <quic_abarnwal@quicinc.com>
Cc: agk@redhat.com; snitzer@kernel.org; dm-devel@lists.linux.dev; Ravi Kuma=
r Siddojigari <rsiddoji@qti.qualcomm.com>
Subject: RE: Patch : drivers/md/dm-verity-target.c

WARNING: This email originated from outside of Qualcomm. Please be wary of =
any links or attachments, and do not enable macros.

On Fri, 10 Nov 2023, Aaditya Raj Barnwal (QUIC) wrote:

> Hi @Mikulas
> Sorry for my late reply
> I was not clear on the ask assuming it to be device configuration , pleas=
e see below points for your query.
>
>  *  Only eMMC chip  Micron product name (S0J35A)  PNM 48(width) CID =20
> value 8GB: 53304A333541h
>  *  Linux version 5.15.104 compiled for  Arm64 (armv8+ )

I did these commands:

$ git checkout v5.15.104
$ grep -r 'exiting after' *

and grep didn't find anything. But your log shows an 'exiting after'
message. So, where does this message 'device-mapper: init:  exiting after'
come from? Are you using clean v5.15.104 or did you patch the kernel with s=
ome external patch?

Mikulas


>  *  with sdhci enabled and sdcard support for auto detect
>
> Please let me know if you have any concerns.
>
> Thanks
> Aaditya
>
> -----Original Message-----
> From: Mikulas Patocka <mpatocka@redhat.com>
> Sent: Monday, November 6, 2023 5:25 PM
> To: Aaditya Raj Barnwal <abarnwal@qti.qualcomm.com>
> Cc: Aaditya Raj Barnwal (QUIC) <quic_abarnwal@quicinc.com>;=20
> agk@redhat.com; snitzer@kernel.org; dm-devel@lists.linux.dev; Akshay=20
> Rukmangad <arukmang@qti.qualcomm.com>
> Subject: Re: Patch : drivers/md/dm-verity-target.c
>
> WARNING: This email originated from outside of Qualcomm. Please be wary o=
f any links or attachments, and do not enable macros.
>
> On Mon, 6 Nov 2023, Aaditya Raj Barnwal wrote:
>
> > thanks for  reply ,
> >
> > yes we already have
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/c
> > om mit/?id=3D035641b01e72af4f6c6cf22a4bdb5d7dfc4e8e8e
> > and kernel cmdline is with wait for /dev/dm-0 where i could make out=20
> > from the logs it was able to get /dev/dm-0 but still failed to get=20
> > the data-devices adding the logs below
> >
> >=A0=A0=A0 9.785204][=A0=A0=A0 T9] mmc0: CQHCI version 5.10 [=A0=A0=A0 9.=
826746][=A0=A0=A0 T9]
> > mmc0: SDHCI controller on 8804000.sdhci [8804000.sdhci] using ADMA =20
> >64-bit [=A0=A0=A0 9.835559][=A0=A0=A0 T9] sdhci_msm 8804000.sdhci: mmc0:=
 CQE init:
> > success [=A0=A0=A0 9.842578][=A0=A0=A0 T1] device-mapper: init: waiting=
 for device /dev/dm-0 ...
>
> You should wait for /dev/mmcblk0 here, not for /dev/dm-0.
>
> > [=A0=A0=A0 9.849605][=A0=A0=A0 T1] device-mapper: init:  exiting after =
=20
> > /dev/dm-0 <<<<<got  dev/dm-0
>
> Where does this 'exiting after' message come from? I grepped the kernel f=
or it and didn't find it.
>
> > [=A0=A0=A0 9.856689][=A0=A0=A0 T1] device-mapper: init: all devices ava=
ilable [=20
> > 9.863061][=A0=A0=A0 T1] device-mapper: table: 252:0: verity: Data devic=
e=20
> > lookup failed [=A0=A0=A0 9.870868][=A0=A0=A0 T1] device-mapper: ioctl: =
error=20
> > adding target to table [=A0=A0=A0 9.895539][=A0=A0 T37] platform regula=
tory.0:
> > Direct firmware load for regulatory.db failed with error -2 [=20
> > 9.898825][=A0=A0=A0 T1] gcc-sdxpinn 80000.clock-controller: sync-state =
[=20
> > 9.905125][=A0=A0 T37] cfg80211: failed to load regulatory.db [=A0=A0=A0=
 9.911731][=A0=A0=A0 T1] ALSA device list:
> > [=A0=A0=A0 9.920911][=A0=A0=A0 T1]=A0=A0 No soundcards found.
> > [=A0=A0=A0 9.925133][=A0=A0=A0 T1] TAP version 14 [=A0=A0=A0 9.928642][=
=A0=A0=A0 T1] 1..0 [=A0=A0=A0=20
> > 9.931645][=A0=A0=A0 T1] md: Waiting for all devices to be available bef=
ore=20
> > autodetect [=A0=A0=A0 9.931829][=A0=A0 T85] mmc0: Command Queue Engine =
enabled=20
> > [=A0=A0=A0 9.939343][=A0=A0=A0 T1] md: If you don't use raid, use=20
> > raid=3Dnoautodetect [=A0=A0=A0 9.944631][=A0=A0 T85] mmc0: new HS400 MM=
C card at=20
> > address 0001 [=A0=A0=A0 9.951158][=A0=A0=A0 T1] md: Autodetecting RAID =
arrays.
> > [=A0=A0=A0 9.957520][=A0=A0 T85] mmcblk0: mmc0:0001 S0J35A 7.28 GiB [=20
> > 9.961908][=A0=A0=A0 T1] md: autorun ...
> > [=A0=A0=A0 9.961912][=A0=A0=A0 T1] md: ... autorun DONE.
> > [=A0=A0=A0 9.970173][=A0=A0 T85]=A0 mmcblk0: p1 p2 p3 p4 p5 p6 p7 p8 p9=
 p10 p11
> > p12 p13 p14 p15 p16 p17 p18 p19 p20 p21 p22 p23 p24 p25 p26 p27 p28
> > p29 p30 p31 p32 p33 p34 p35 p36
> > p37 p38 p39 p40 p41 p42 p43 p44 p45 p46 [=A0=A0=A0 9.971004][=A0=A0=A0 =
T1]=20
> > Waiting for root device /dev/dm-0...
> > [=A0=A0=A0 9.979384][=A0=A0 T85] mmcblk0boot0: mmc0:0001 S0J35A 31.5 Mi=
B [=20
> > 10.005842][=A0=A0 T85] mmcblk0boot1: mmc0:0001 S0J35A 31.5 MiB [=20
> > 10.012536][=A0=A0 T85] mmcblk0rpmb: mmc0:0001 S0J35A 4.00 MiB, chardev
> > (500:0) [=A0=A0 10.901495][=A0=A0 T85] msm-dwc3 a600000.ssusb: DWC3 in =
low=20
> > power mode << no rootfs and no further bootup  blocked at this point=20
> > same as the above path >>
>
> I see that you also use md - please describe the full storage stack that =
you use.
>
> Mikulas
>
>
>
