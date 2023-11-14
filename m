Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEE211718
	for <dm-devel@lists.linux.dev>; Tue, 14 Nov 2023 07:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="CWkjzQ7B"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE5TCVA008993;
	Tue, 14 Nov 2023 07:23:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=qcppdkim1;
 bh=ZCQ9zsGMAGJrppwK9mS92jbkgvHcqWN2RJurbsTh2iY=;
 b=CWkjzQ7BY+CwMmwPgCumTCcPUBAUntAcDjDWIptEdjR0HL0Uufnl7kPcqt6zieztAyTO
 2Omi1hYSIfun6CfefT9W5HOZXC/5xUt/vpXOPbtkS+jgjR+uPbc61R7ZUWBVc74vjiKW
 fowWpsuDhOFOrl58UmTTsb7e2UK0+kLNEya6ztNmx/DIdOoE0MZ9QlkhzNq6wUPRWvwy
 n0Sh1R+ylz8x5Hcleoa3CwnE7YecVhoAoHEVmXKoSsvc2EwyG6jjZlS1ZQsUNBa3Kisx
 u2sud90srwU5kJpK8F1h2D6bGnlPmg94z0xH2J8iEOyapc+mH+IObApuZvL6HaX8uTq0 3w== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ubge826j1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Nov 2023 07:23:17 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3AE7NFTU028874
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Nov 2023 07:23:15 GMT
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Mon, 13 Nov 2023 23:23:15 -0800
Received: from nalasex01b.na.qualcomm.com ([fe80::48ce:7e89:ddbd:f50d]) by
 nalasex01b.na.qualcomm.com ([fe80::48ce:7e89:ddbd:f50d%12]) with mapi id
 15.02.1118.039; Mon, 13 Nov 2023 23:23:15 -0800
From: "Aaditya Raj Barnwal (QUIC)" <quic_abarnwal@quicinc.com>
To: Mikulas Patocka <mpatocka@redhat.com>
CC: "Aaditya Raj Barnwal (QUIC)" <quic_abarnwal@quicinc.com>,
        "agk@redhat.com"
	<agk@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: RE: Patch : drivers/md/dm-verity-target.c
Thread-Topic: Patch : drivers/md/dm-verity-target.c
Thread-Index: AQHaEJij4apZxMxWj0m63DynSJD8B7BtpggAgAAPDQCADEZRUA==
Date: Tue, 14 Nov 2023 07:23:15 +0000
Message-ID: <8e49ca6528864c3fb8d82fbe9e5aebd5@quicinc.com>
References: <PH0PR02MB859952FC76063896916AA05DF6AAA@PH0PR02MB8599.namprd02.prod.outlook.com>
 <e371659-f86f-e711-ceb6-db9f0fd2e70@redhat.com>
 <PH0PR02MB859987618E8647439950A053F6AAA@PH0PR02MB8599.namprd02.prod.outlook.com>
 <559787b2-9b87-4ce-d5d9-6e16f22bc44@redhat.com>
In-Reply-To: <559787b2-9b87-4ce-d5d9-6e16f22bc44@redhat.com>
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
X-Proofpoint-ORIG-GUID: HPhxVjJh3nCa3_n_rY3S16TFr7z2lTTB
X-Proofpoint-GUID: HPhxVjJh3nCa3_n_rY3S16TFr7z2lTTB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_05,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1011 mlxlogscore=928
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140056

Hi =20
Sorry for my late reply=20
I was not clear on the ask assuming it to be device configuration , please =
see below points for your query.

.	Only eMMC chip  Micron product name (S0J35A)  PNM 48(width) CID  value 8G=
B: 53304A333541h
.	Linux version 5.15.104 compiled for  Arm64 (armv8+ )
.	with sdhci enabled and sdcard support for auto detect

Please let me know if you have any concerns.

Thanks
Aaditya


-----Original Message-----
From: Mikulas Patocka <mpatocka@redhat.com>=20
Sent: Monday, November 6, 2023 5:25 PM
To: Aaditya Raj Barnwal <abarnwal@qti.qualcomm.com>
Cc: Aaditya Raj Barnwal (QUIC) <quic_abarnwal@quicinc.com>; agk@redhat.com;=
 snitzer@kernel.org; dm-devel@lists.linux.dev; Akshay Rukmangad <arukmang@q=
ti.qualcomm.com>
Subject: Re: Patch : drivers/md/dm-verity-target.c

WARNING: This email originated from outside of Qualcomm. Please be wary of =
any links or attachments, and do not enable macros.

On Mon, 6 Nov 2023, Aaditya Raj Barnwal wrote:

> thanks for  reply ,
>
> yes we already have
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/com
> mit/?id=3D035641b01e72af4f6c6cf22a4bdb5d7dfc4e8e8e
> and kernel cmdline is with wait for /dev/dm-0 where i could make out=20
> from the logs it was able to get /dev/dm-0 but still failed to get the=20
> data-devices adding the logs below
>
>    9.785204][=A0=A0=A0 T9] mmc0: CQHCI version 5.10 [=A0=A0=A0 9.826746][=
=A0=A0=A0 T9]=20
> mmc0: SDHCI controller on 8804000.sdhci [8804000.sdhci] using ADMA=20
> 64-bit [=A0=A0=A0 9.835559][=A0=A0=A0 T9] sdhci_msm 8804000.sdhci: mmc0: =
CQE init:=20
> success [=A0=A0=A0 9.842578][=A0=A0=A0 T1] device-mapper: init: waiting f=
or device /dev/dm-0 ...

You should wait for /dev/mmcblk0 here, not for /dev/dm-0.

> [=A0=A0=A0 9.849605][=A0=A0=A0 T1] device-mapper: init:  exiting after  /=
dev/dm-0 =20
> <<<<<got  dev/dm-0

Where does this 'exiting after' message come from? I grepped the kernel for=
 it and didn't find it.

> [=A0=A0=A0 9.856689][=A0=A0=A0 T1] device-mapper: init: all devices avail=
able [=A0=A0=A0=20
> 9.863061][=A0=A0=A0 T1] device-mapper: table: 252:0: verity: Data device=
=20
> lookup failed [=A0=A0=A0 9.870868][=A0=A0=A0 T1] device-mapper: ioctl: er=
ror=20
> adding target to table [=A0=A0=A0 9.895539][=A0=A0 T37] platform regulato=
ry.0:=20
> Direct firmware load for regulatory.db failed with error -2 [=A0=A0=A0=20
> 9.898825][=A0=A0=A0 T1] gcc-sdxpinn 80000.clock-controller: sync-state [=
=A0=A0=A0=20
> 9.905125][=A0=A0 T37] cfg80211: failed to load regulatory.db [=A0=A0=A0 9=
.911731][=A0=A0=A0 T1] ALSA device list:
> [=A0=A0=A0 9.920911][=A0=A0=A0 T1]=A0=A0 No soundcards found.
> [=A0=A0=A0 9.925133][=A0=A0=A0 T1] TAP version 14
> [=A0=A0=A0 9.928642][=A0=A0=A0 T1] 1..0
> [=A0=A0=A0 9.931645][=A0=A0=A0 T1] md: Waiting for all devices to be avai=
lable=20
> before autodetect [=A0=A0=A0 9.931829][=A0=A0 T85] mmc0: Command Queue En=
gine=20
> enabled [=A0=A0=A0 9.939343][=A0=A0=A0 T1] md: If you don't use raid, use=
=20
> raid=3Dnoautodetect [=A0=A0=A0 9.944631][=A0=A0 T85] mmc0: new HS400 MMC =
card at=20
> address 0001 [=A0=A0=A0 9.951158][=A0=A0=A0 T1] md: Autodetecting RAID ar=
rays.
> [=A0=A0=A0 9.957520][=A0=A0 T85] mmcblk0: mmc0:0001 S0J35A 7.28 GiB [=A0=
=A0=A0=20
> 9.961908][=A0=A0=A0 T1] md: autorun ...
> [=A0=A0=A0 9.961912][=A0=A0=A0 T1] md: ... autorun DONE.
> [=A0=A0=A0 9.970173][=A0=A0 T85]=A0 mmcblk0: p1 p2 p3 p4 p5 p6 p7 p8 p9 p=
10 p11=20
> p12 p13 p14 p15 p16 p17 p18 p19 p20 p21 p22 p23 p24 p25 p26 p27 p28=20
> p29 p30 p31 p32 p33 p34 p35 p36
> p37 p38 p39 p40 p41 p42 p43 p44 p45 p46 [=A0=A0=A0 9.971004][=A0=A0=A0 T1=
] Waiting=20
> for root device /dev/dm-0...
> [=A0=A0=A0 9.979384][=A0=A0 T85] mmcblk0boot0: mmc0:0001 S0J35A 31.5 MiB =
[=A0=A0=20
> 10.005842][=A0=A0 T85] mmcblk0boot1: mmc0:0001 S0J35A 31.5 MiB [=A0=A0=20
> 10.012536][=A0=A0 T85] mmcblk0rpmb: mmc0:0001 S0J35A 4.00 MiB, chardev=20
> (500:0) [=A0=A0 10.901495][=A0=A0 T85] msm-dwc3 a600000.ssusb: DWC3 in lo=
w=20
> power mode << no rootfs and no further bootup  blocked at this point=20
> same as the above path >>

I see that you also use md - please describe the full storage stack that yo=
u use.

Mikulas
