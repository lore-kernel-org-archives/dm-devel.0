Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38B117723
	for <dm-devel@lists.linux.dev>; Mon,  6 Nov 2023 09:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ieZm3Gtj"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A65bh50019111;
	Mon, 6 Nov 2023 09:30:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=qcppdkim1;
 bh=FVxkSFMCJiOCwSxqbP99T7DjTq99auS3ZOYR9Ge5bs4=;
 b=ieZm3Gtjej0KJ/m0oFW2oe6bNic8R6s1HLeik1hn3AQRpYi1I8F/gnqJIy6BgIEGLeQW
 7lbefyMS4SGn+KI6zZE7hBr/bOqAqFknfoh+2nxF/ADyvWU2COAsqQCbSXCxd5PxXPrN
 0tXSRxRaNjKZlnVh3cmyJMZvM1bNs+4jmioGxzk3YMibHAUYz8dXnhlt3yNzsMOQcCFr
 6E8fPbjU1G9SaU/kcyL16Lq2/D/9sPjtOZNCAchoLRSGyvIVA+5cI+sgP/JHfKcyV443
 VQl3ueob2slUZb8AIOf1We40yxNHUiZSQ6CEavbN4m1cLQWKpCZgDUdlyhIb0jnJxarr Hg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3u5euyunxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 09:30:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3JxG1vsB/WLsT/x9NrUISd8P85WMq9jkWAp+YaAImzhTuCRbPS8mLdXWb3ve4CwHsHsZMH6ZFzuqSh2v2V+91RP7+6RBLHna46+sYjS8xyuCwSbqEx/CTAchZruM/6rWctMQqDLAh3ycpIqocURNdWgmETK6+cWjI6neOW4qLcD27kH+zIXYKExfrBfhdABjbHmVS3CeiqpRp9ZQa8gKFFrJS+/2azYuYl2GAYVPE0YGqHcUOZ3RN6NOwCmLAZa3kGwn7wCvzZh2BXarlXBayQXzDgKWEnJWK+nLf32Y9VXV0xpH+F0Rh5m8ZeqqT+2u0uztV+ihfM+8msaPuSfkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVxkSFMCJiOCwSxqbP99T7DjTq99auS3ZOYR9Ge5bs4=;
 b=G70dPinKo5Zc08KnWehwNSUTO4qhZqbsNI/U3IHSDZPeECZ9ox8NaUEBNdSoR60rpHEuQ92Az1Q3LjOtWFWH9gMl/oUQ8hDFVpU7qCljiaFLbAaMDTbwWOknJJdJ4W3BMdu9uyr5Jf/rgbuarqdkOEXqy9+aX6Vk8XmbUrSVrOwrRqiUqxr+YR4gDt4lv7EiLxhAdM/j95tgNy0myM8gXSlMEiwQ1urqSLSkVAw25wTJQZZOkNBOaVapOjiBtUvfkiElxgowHiK+WzVfxMfWHU0W6KIq2blpUWBJCBscCY2qX+/ut/WdhLyW3PDsiUiMU+kVH0MVDnA9mBAwpteBdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from PH0PR02MB8599.namprd02.prod.outlook.com (2603:10b6:510:10c::11)
 by DM8PR02MB8008.namprd02.prod.outlook.com (2603:10b6:8:19::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6954.28; Mon, 6 Nov 2023 09:30:00 +0000
Received: from PH0PR02MB8599.namprd02.prod.outlook.com
 ([fe80::9c9:bad9:53d:31ed]) by PH0PR02MB8599.namprd02.prod.outlook.com
 ([fe80::9c9:bad9:53d:31ed%2]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 09:30:00 +0000
From: "Aaditya Raj Barnwal (QUIC)" <quic_abarnwal@quicinc.com>
To: "agk@redhat.com" <agk@redhat.com>,
        "snitzer@kernel.org"
	<snitzer@kernel.org>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
CC: Akshay Rukmangad <arukmang@qti.qualcomm.com>
Subject: Patch : drivers/md/dm-verity-target.c 
Thread-Topic: Patch : drivers/md/dm-verity-target.c 
Thread-Index: AQHaEJI42aRUErHkGkOK2jZ/71Qvfg==
Date: Mon, 6 Nov 2023 09:30:00 +0000
Message-ID: 
 <PH0PR02MB859952FC76063896916AA05DF6AAA@PH0PR02MB8599.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB8599:EE_|DM8PR02MB8008:EE_
x-ms-office365-filtering-correlation-id: bc045123-3e15-4414-9ce8-08dbdeaaf2c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 +qi6Jng1eIOLvTeT5gVq5tPytdu74nMj+Yi/Twpg9fp7SP5QjBBoKHrjKBFXgYwf+Au0ao7W47NLOqfDB2KCIReZMlI0Zyr7TEGMYHUglPseEY08DLIf+KlYtePUHvtgDZaab1C/1UiV8Wx5OkvlKENGv5QQfTUyqqUQMtrNBEkmQI+SVfMi02tKRBWd5UWPUwWMvYTvh86/yj1CpSTUdfRpcpNYZ/s5YIzVlgVfdIZB0Qtv9KgXupeWSI3DItMBmK68JSDQ/Yp07su5xcS+YU6bCb6k4HBojG7lA1K35RmiHjmD0NNCUIr253mAZuZJXsXjOvjMQF2XY428SI/+83+KBMz/5701XHfcHISXJ75nXCAsNzf7iyEKDVczskmNUxMGMsWRlcpL1PJoaPGUS/x1Hfm2qXqa1nJGCo60xjKP/o1fj7c2UichWds3J6XZkj6OC20YkxjDZe9tCpIRlY1xFTJ1uyN+ZP00YwjUM0F0r93PTscpJGkCj0Rj+iASX4R2iF7VW+3bJNDNiMrnW2KkTphBlKPPzB+HdNXvR+q03Fk6YAlop5gj86nj0+qGB4GgnwCwolROstC+ikQBWQHAIQaIrg4ffd4UxsZnW5M=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB8599.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(366004)(136003)(376002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(4743002)(71200400001)(122000001)(99936003)(83380400001)(55016003)(6506007)(7696005)(9686003)(107886003)(26005)(478600001)(966005)(19627405001)(38100700002)(76116006)(8936002)(8676002)(64756008)(316002)(66946007)(66556008)(66476007)(66446008)(91956017)(110136005)(4326008)(5660300002)(86362001)(4744005)(2906002)(41300700001)(33656002)(52536014)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?INbO6pieM8uHOOLZuh8afqqUSZctgv9DUGyRY6exu/6uJkE15LzSvXKzMd?=
 =?iso-8859-1?Q?cT+TXjsZPRLkV9emRWbkyWLgZK1ahahWN1JHOmYOtfWYplNu68e+/AUes9?=
 =?iso-8859-1?Q?d9cO0cAYa25rkE4CNr+kKS23VwpmZqijhjlnuAqSQ3ZXjHJi1BtCR8UtrG?=
 =?iso-8859-1?Q?54oXGDxHy7Osi063PMWum15kgdRqTrbPkjDr6wi3UgqqDpCJouH5XtwR64?=
 =?iso-8859-1?Q?z9vAoKPWvlF5ruE7dkbg8FZIzRYyrFQTSdBOx8CDWLxMvJVDPQXDp5z3Vw?=
 =?iso-8859-1?Q?tVHTCKybJdPGucEi6Y4QWsPVPFrV4iOQyUWKN6RWXdT/Q1lG2bykcOgoS4?=
 =?iso-8859-1?Q?6P94QrFS+DWDTmtAzV28SRw7KwcVZcLpdrBAtgrwkFRFkcR5ikv+jiTL0/?=
 =?iso-8859-1?Q?2ARcUCOXW+Cus1Bt6PpHHGqxovj9lUeukGfJjxC2a8NGkBz2RtSuL+2fNI?=
 =?iso-8859-1?Q?Z+j9ZPAquXvkvyhQIsruKaIOI3OUGxcrrMjmFmWo716lwGJ8AJ6QeJqyXh?=
 =?iso-8859-1?Q?qxmrxdhnF765AW2sJ3rR3F8zFs3FoQxwnCWYnt4BgL6gfWZ4P3bkQmY8W3?=
 =?iso-8859-1?Q?4BIaFEE8/ul9/dkK98NkWj9L87e9R5qnsARFhWZB8MoK7/IouAryFEdYVO?=
 =?iso-8859-1?Q?i66UqZdYSEr3Z9Y10F2TjZMBNICGVlDudDxQ7cdHIewA16ymkBBBaIsPu1?=
 =?iso-8859-1?Q?VWik5aAvJZ2wLUf4fMo7aOKDK7g9ZuBxFjtG2uJz8Kz7YIlUcsw/TpK9wM?=
 =?iso-8859-1?Q?Wu59mcw5MoYQNsJs+/xuJwIf6acLYyPThg8ITD3fdZ80lVoUmqAqWOYC/D?=
 =?iso-8859-1?Q?10roytg1atr7lVsj6ehH5ujpBSzP6Q+ayzWJAAX5CnfBownLlE1S+Uls+k?=
 =?iso-8859-1?Q?1Wl1f5dekW8e7yFhfBDa6J8whje+EBEFy9wP2s8iJT95KIFLNkSM8HGAlq?=
 =?iso-8859-1?Q?tlYh1l9uRFjiZY2za73ImeDJyrmhuf2Y5KVGImPo2NmFEMko4PwJvMADM6?=
 =?iso-8859-1?Q?l+ayykRxgzEGQ6pBrbbwPqfWgBq2ni5of5RwIz9PB9cDmhcJWv12Hvh75F?=
 =?iso-8859-1?Q?DUbTnhGAhOJOa2nIsNxd5tMBBhGCWXbiGqRa+/EEDaNlm/0fP0k4nZnwf7?=
 =?iso-8859-1?Q?krDW4vTI+gB9XzQP4YESa2KxGrDYTjH3bA5hAHWA2/0PfqDaw3DYDght3g?=
 =?iso-8859-1?Q?fSdPxzxBtyPtzeSaokCMHLVo2l9Jkz2Qf4zTQZRkJM+xgY0zG8aG/0d/DK?=
 =?iso-8859-1?Q?nx46jpmwakXAoM5iDSvs9yOFsxG6DeIPoGQdMyBiDMYM4s7nbyh8Z9LfEA?=
 =?iso-8859-1?Q?VLW6/DvlN7s0FkB/pDsHUadEgt2AgamTM8c5ZKtuB6AWuVtt8Nzj5t0ykc?=
 =?iso-8859-1?Q?+vlwxu8VE5yX/gXlZPJA1gACKjHKFpV7FwlQHXoXYcoRYZw8xINfIYZg0A?=
 =?iso-8859-1?Q?Fk2hzXeelEVnZy41n0dZLtdzDmCo3Y+prK5H7L29Pp3BXmoR5Sre5vyWwe?=
 =?iso-8859-1?Q?RvuelvIWwh+TpSNSxCXmQiesLCbZkfq1TFprrtV0H6KhHRiuWiUSojb1Vv?=
 =?iso-8859-1?Q?o2jIXzDAoebafQNBex0QXS+dsBofGXNu/ByDFBvmh56iSmO8Mfx87q8Xit?=
 =?iso-8859-1?Q?h1Av9BNNj13HG2/mWdffPOlQNF3ibg1dob?=
Content-Type: multipart/mixed;
	boundary="_004_PH0PR02MB859952FC76063896916AA05DF6AAAPH0PR02MB8599namp_"
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jsc0ic+6/LnoVFe7gjnm3RCdKoZ7EdCkBc4fnC37ihRYx9JvV+7OQl9ArEIBbpjxkevlNtW3hu8stB2QsIMMF/PDOZMcU4foESwOuP9mealmjnqw0ZCrNcYPGRodnEkqVfD38BvHTo4VPwe2oMkpszeVYeZCom3VKNK+B3xUNB6LQcJQkOIX1qujQIH3foBR5P+C7igv1sWSY2ye1HxQm0NL+g2bOLpUx5UrNSDTmduBDLxqgKRwvvrxyVebFt0zagUdek9Wgj8LRdpI8vfooUP565lawpwv1jADrBBWC2UnQ6MPhCXQORTNzPKwrYkqagrIAsE7wUKCUWnbFtMdT/vBc+/KHCjTbXHnqA7Q/ej97F293uARSGJAuQ0dOfkYR9XEtfubqA2Xkh065xg5/JwTnGujoTVgxWTi9WcMI/7Eboy7rXMCZ03kyakzSSztJHqpj+JnDO7RyxoW3FuyBxfACF5fB/lvPk3llLgKtuXuKlxSIDqFVxqq5EbK3dOx766uQFZAU8X2nrVuRCg1oGRz420x8aXMrlloBsw2HT2jgSJRn+uT+TJhOuHmJMjonI1/yoxhqyxLof2YhGT4rF5gQxgjruADsPNOkuqeVMfUxVDRmjNJFwa7P7KT62oYEMGVAG5lFQtF/ENN5kdqsDVOlo7KPJPaK0GYWxdNsnpq6oA7KfBwCDUaDKPd4wGLrBUbtJBPvKJxWxiQVXFBwmQ6H6BxwEWbMgRYOadfdjpBP6+mc0L9E2dQdPG3qXEMKSu9m6Zp4bFjgfRICqALWSuVZScO9Y1FMMCnCjitG/xbUgao/A+uoc62uChsg3G4lnVUjwnrrPl31UTMIfWuvQ==
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB8599.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc045123-3e15-4414-9ce8-08dbdeaaf2c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2023 09:30:00.1816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bEvXIIVLC3rrALCzIsCiDj+x+JUzCdT73N+XD/+HPsMLM+5KQSnjIojVE7dv5+faGFUOGGwlU1LX6IT6zwnNQVU0ULLCUX1szfBxmTDHn9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB8008
X-Proofpoint-GUID: 987yKgqwfTnhcqanxzM2soFYtfd-sEJQ
X-Proofpoint-ORIG-GUID: 987yKgqwfTnhcqanxzM2soFYtfd-sEJQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_07,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxlogscore=487
 phishscore=0 mlxscore=0 priorityscore=1501 adultscore=0 clxscore=1011
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060081

--_004_PH0PR02MB859952FC76063896916AA05DF6AAAPH0PR02MB8599namp_
Content-Type: multipart/alternative;
	boundary="_000_PH0PR02MB859952FC76063896916AA05DF6AAAPH0PR02MB8599namp_"

--_000_PH0PR02MB859952FC76063896916AA05DF6AAAPH0PR02MB8599namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Developers,

I have attached the patch for file : drivers/md/dm-verity-target.c

Race condition with some eMMC devices where the early_probe
to dm-verity driver try to check access of data device
fails. As this error is going to impact the bootup and mount
of rootfs. As its impact bootup we make to wait for and
then do a bail-out .
adding the error which show the that dm-init already
ack "all device available " but dm-verity returned
error .
device-mapper: init: all devices available
device-mapper: table: 252:0: verity: Data device lookup failed
device-mapper: ioctl: error adding target to table

This patch is going to wait based on module parm if not passed it
will be 1sec max.

This patch is based on
https://lore.kernel.org/lkml/7442e695-654a-59c2-e3dd-710946e6cddd@seco.com/=
T/
which tries to do the same to dm-int level.


Thanks
Aaditya




--_000_PH0PR02MB859952FC76063896916AA05DF6AAAPH0PR02MB8599namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<span style=3D"font-family: Calibri, Helvetica, sans-serif;">Hi Developers,=
&nbsp;</span></div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<span style=3D"font-family: Calibri, Helvetica, sans-serif;"><br>
</span></div>
<div class=3D"elementToProof"><span style=3D"font-family: Calibri, Helvetic=
a, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);">I have attached the p=
atch for file : drivers/md/dm-verity-target.c</span></div>
<div class=3D"elementToProof"><span style=3D"font-family: Calibri, Helvetic=
a, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);"><br>
</span></div>
<div class=3D"elementToProof"><span style=3D"font-family: Calibri, Helvetic=
a, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);">Race condition with s=
ome eMMC devices where the early_probe</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">to dm-verity driver try to check access of dat=
a device</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">fails. As this error is going to impact the bo=
otup and mount</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">of rootfs. As its impact bootup we make to wai=
t for and</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">then do a bail-out .</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">adding the error which show the that dm-init a=
lready</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">ack &quot;all device available &quot; but dm-v=
erity returned</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">error .</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">device-mapper: init: all devices available</sp=
an></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">device-mapper: table: 252:0: verity: Data devi=
ce lookup failed</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">device-mapper: ioctl: error adding target to t=
able</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);"><br>
</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">This patch is going to wait based on module pa=
rm if not passed it</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">will be 1sec max.</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);"><br>
</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">This patch is based on</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">https://lore.kernel.org/lkml/7442e695-654a-59c=
2-e3dd-710946e6cddd@seco.com/T/</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);" class=3D"elementToProof">which tries to do the=
 same to dm-int level.</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);" class=3D"elementToProof"><br>
</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);" class=3D"elementToProof"><br>
</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);" class=3D"elementToProof">Thanks</span></div>
<div><span style=3D"font-family: Calibri, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);" class=3D"elementToProof">Aaditya<br>
<br>
</span></div>
<div class=3D"elementToProof"><span style=3D"font-family: Calibri, Helvetic=
a, sans-serif; font-size: 12pt; color: rgb(0, 0, 0);"><br>
</span></div>
<div class=3D"elementToProof"><span style=3D"font-family: Aptos, Aptos_Embe=
ddedFont, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 1=
2pt; color: rgb(0, 0, 0);"><br>
</span></div>
</body>
</html>

--_000_PH0PR02MB859952FC76063896916AA05DF6AAAPH0PR02MB8599namp_--

--_004_PH0PR02MB859952FC76063896916AA05DF6AAAPH0PR02MB8599namp_
Content-Type: application/octet-stream;
	name="0001-md-dm-verity-target-Wait-data-devices-giving-time-to.patch"
Content-Description: 
 0001-md-dm-verity-target-Wait-data-devices-giving-time-to.patch
Content-Disposition: attachment;
	filename="0001-md-dm-verity-target-Wait-data-devices-giving-time-to.patch";
	size=2750; creation-date="Mon, 06 Nov 2023 09:25:09 GMT";
	modification-date="Mon, 06 Nov 2023 09:26:04 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwMjIwYjFiMjQwZDYwYTk0MzNkYTVmNzJmNmMxMDllMDk4YWQxYmNmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBYWRpdHlhIFJhaiBCYXJud2FsIDxxdWljX2FiYXJud2FsQHF1
aWNpbmMuY29tPgpEYXRlOiBNb24sIDYgTm92IDIwMjMgMTQ6NDk6NDUgKzA1MzAKU3ViamVjdDog
W1BBVENIXSBtZDogZG0tdmVyaXR5LXRhcmdldDogV2FpdCBkYXRhIGRldmljZXMgZ2l2aW5nIHRp
bWUgdG8gcHJvYmUKIGFjawoKUmFjZSBjb25kaXRpb24gd2l0aCBzb21lIGRldmljZXMgd2hlcmUg
dGhlIGVhcmx5X3Byb2JlCnRvIGRtLXZlcml0eSBkcml2ZXIgdHJ5IHRvIGNoZWNrIGFjY2VzcyBv
ZiBkYXRhIGRldmljZQpmYWlscy4gQXMgdGhpcyBlcnJvciBpcyBnb2luZyB0byBpbXBhY3QgdGhl
IGJvb3R1cCBhbmQgbW91bnQKb2Ygcm9vdGZzLiAgQXMgaXRzIGltcGFjdCBib290dXAgIHdlIG1h
a2UgdG8gd2FpdCBmb3IgYW5kCnRoZW4gZG8gYSBiYWlsLW91dCAuCmFkZGluZyB0aGUgZXJyb3Ig
d2hpY2ggc2hvdyB0aGUgdGhhdCBkbS1pbml0IGFscmVhZHkKYWNrICJhbGwgZGV2aWNlIGF2YWls
YWJsZSAiIGJ1dCBkbS12ZXJpdHkgIHJldHVybmVkCmVycm9yIC4KIGRldmljZS1tYXBwZXI6IGlu
aXQ6IGFsbCBkZXZpY2VzIGF2YWlsYWJsZQogZGV2aWNlLW1hcHBlcjogdGFibGU6IDI1MjowOiB2
ZXJpdHk6IERhdGEgZGV2aWNlIGxvb2t1cCBmYWlsZWQKIGRldmljZS1tYXBwZXI6IGlvY3RsOiBl
cnJvciBhZGRpbmcgdGFyZ2V0IHRvIHRhYmxlCgpUaGlzIHBhdGNoIGlzIGJhc2VkIG9uCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvCjc0NDJlNjk1LTY1NGEtNTljMi1lM2RkLTcxMDk0NmU2
Y2RkZEBzZWNvLmNvbS9ULwoKd2hpY2ggdHJpZXMgdG8gZG8gdGhlIHNhbWUgdG8gZG0taW50IGxl
dmVsLgotLS0KIGRyaXZlcnMvbWQvZG0tdmVyaXR5LXRhcmdldC5jIHwgMTggKysrKysrKysrKysr
KysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXZlcml0eS10YXJnZXQuYyBiL2RyaXZlcnMvbWQv
ZG0tdmVyaXR5LXRhcmdldC5jCmluZGV4IDI2YWRjZmVhMDMwMi4uYmJlMDI3MTkwNDg3IDEwMDY0
NAotLS0gYS9kcml2ZXJzL21kL2RtLXZlcml0eS10YXJnZXQuYworKysgYi9kcml2ZXJzL21kL2Rt
LXZlcml0eS10YXJnZXQuYwpAQCAtMjIsNiArMjIsNyBAQAogI2luY2x1ZGUgPGxpbnV4L3NjYXR0
ZXJsaXN0Lmg+CiAjaW5jbHVkZSA8bGludXgvc3RyaW5nLmg+CiAjaW5jbHVkZSA8bGludXgvanVt
cF9sYWJlbC5oPgorI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+CiAKICNkZWZpbmUgRE1fTVNHX1BS
RUZJWAkJCSJ2ZXJpdHkiCiAKQEAgLTQyLDYgKzQzLDkgQEAKICNkZWZpbmUgRE1fVkVSSVRZX09Q
VFNfTUFYCQkoNCArIERNX1ZFUklUWV9PUFRTX0ZFQyArIFwKIAkJCQkJIERNX1ZFUklUWV9ST09U
X0hBU0hfVkVSSUZJQ0FUSU9OX09QVFMpCiAKKyNkZWZpbmUgRE1fREVGQVVMVF9NQVhfUFJPQkVf
REVMQVlfU0VDIDEKKyNkZWZpbmUgRE1fREVGQVVMVF9QUk9CRV9GQUNUT1IgNQorCiBzdGF0aWMg
dW5zaWduZWQgaW50IGRtX3Zlcml0eV9wcmVmZXRjaF9jbHVzdGVyID0gRE1fVkVSSVRZX0RFRkFV
TFRfUFJFRkVUQ0hfU0laRTsKIAogbW9kdWxlX3BhcmFtX25hbWVkKHByZWZldGNoX2NsdXN0ZXIs
IGRtX3Zlcml0eV9wcmVmZXRjaF9jbHVzdGVyLCB1aW50LCAwNjQ0KTsKQEAgLTExODMsNyArMTE4
Nyw3IEBAIHN0YXRpYyBpbnQgdmVyaXR5X2N0cihzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgdW5zaWdu
ZWQgaW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCXNlY3Rvcl90IGhhc2hfcG9zaXRpb247CiAJY2hh
ciBkdW1teTsKIAljaGFyICpyb290X2hhc2hfZGlnZXN0X3RvX3ZhbGlkYXRlOwotCisJaW50IGxv
b3BjbnRyID0gRE1fREVGQVVMVF9NQVhfUFJPQkVfREVMQVlfU0VDICogMTAwMCAvIERNX0RFRkFV
TFRfUFJPQkVfRkFDVE9SOwogCXYgPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgZG1fdmVyaXR5KSwg
R0ZQX0tFUk5FTCk7CiAJaWYgKCF2KSB7CiAJCXRpLT5lcnJvciA9ICJDYW5ub3QgYWxsb2NhdGUg
dmVyaXR5IHN0cnVjdHVyZSI7CkBAIC0xMjI1LDcgKzEyMjksMTcgQEAgc3RhdGljIGludCB2ZXJp
dHlfY3RyKHN0cnVjdCBkbV90YXJnZXQgKnRpLCB1bnNpZ25lZCBpbnQgYXJnYywgY2hhciAqKmFy
Z3YpCiAJfQogCXYtPnZlcnNpb24gPSBudW07CiAKLQlyID0gZG1fZ2V0X2RldmljZSh0aSwgYXJn
dlsxXSwgQkxLX09QRU5fUkVBRCwgJnYtPmRhdGFfZGV2KTsKKwkvKgorCSAqIFNvbWUgdGltZSB3
ZSBzZWUgcmFjZSBjb25kaXRpb24gb2YgZWFybHlfZGV2aWNlIHByb2JlIHRvCisJICogZG1fZ2V0
X2RldmljZSgpIGxlYWRpbmcgdG8gZmFpbHVyZSBsZWFkaW5nIHRvICBtb3VudAorCSAqIGZhaWx1
cmUgb2YgZGF0YSBkZXZpY2Ugc3BlY2FpYWxseSB3aGVuIGRhdGEgZGV2aWNlIGlzCisJICogZU1N
QyBkZXZpY2VzICh3aXRoIHJvb3RmcykKKwkgKi8KKworCXdoaWxlICgociA9IGRtX2dldF9kZXZp
Y2UodGksIGFyZ3ZbMV0sIEZNT0RFX1JFQUQsICZ2LT5kYXRhX2RldikpICYmIGxvb3BjbnRyKSB7
CisJCWxvb3BjbnRyLS07CisJCW1zbGVlcF9pbnRlcnJ1cHRpYmxlKDUpOworCX0KIAlpZiAocikg
ewogCQl0aS0+ZXJyb3IgPSAiRGF0YSBkZXZpY2UgbG9va3VwIGZhaWxlZCI7CiAJCWdvdG8gYmFk
OwotLSAKMi4xNy4xCgo=

--_004_PH0PR02MB859952FC76063896916AA05DF6AAAPH0PR02MB8599namp_--
