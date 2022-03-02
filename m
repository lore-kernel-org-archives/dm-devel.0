Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47344C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Mar 2022 00:08:42 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-TiAtDnLaNOymVaHDmqh2Ow-1; Tue, 01 Mar 2022 19:08:37 -0500
X-MC-Unique: TiAtDnLaNOymVaHDmqh2Ow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEC821091DA2;
	Wed,  2 Mar 2022 00:08:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE87278C12;
	Wed,  2 Mar 2022 00:08:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 17C9D1809C98;
	Wed,  2 Mar 2022 00:08:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 22207OSu007486 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 19:07:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1AF8753C6; Wed,  2 Mar 2022 00:07:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14B1653BB
	for <dm-devel@redhat.com>; Wed,  2 Mar 2022 00:07:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0ED12811E75
	for <dm-devel@redhat.com>; Wed,  2 Mar 2022 00:07:21 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-214-Pvq3_C-kMiSxmDOIq3RqhA-1; Tue, 01 Mar 2022 19:07:17 -0500
X-MC-Unique: Pvq3_C-kMiSxmDOIq3RqhA-1
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	221M4dmv010950; Wed, 2 Mar 2022 00:07:16 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3eh14bve2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Mar 2022 00:07:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22201QK4043650;
	Wed, 2 Mar 2022 00:07:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
	by userp3020.oracle.com with ESMTP id 3efdnnwcn8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Mar 2022 00:07:14 +0000
Received: from CO1PR10MB4641.namprd10.prod.outlook.com (2603:10b6:303:6d::5)
	by DM6PR10MB3738.namprd10.prod.outlook.com (2603:10b6:5:155::31) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25;
	Wed, 2 Mar 2022 00:07:11 +0000
Received: from CO1PR10MB4641.namprd10.prod.outlook.com
	([fe80::1985:35c0:1d7a:654b]) by
	CO1PR10MB4641.namprd10.prod.outlook.com
	([fe80::1985:35c0:1d7a:654b%9]) with mapi id 15.20.5038.014;
	Wed, 2 Mar 2022 00:07:11 +0000
From: Ritika Srivastava <ritika.srivastava@oracle.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH] kpartx: Add -P option for partition scanning
Thread-Index: AQHYKBnsJmIySWp7m0mbNAOxajLQBayfZjwAgACPNID//6fzAIAJ++2AgAEjTAA=
Date: Wed, 2 Mar 2022 00:07:11 +0000
Message-ID: <1C4A63A7-0ABB-4A26-9C4A-4BD4EA192B1A@oracle.com>
References: <1644612108-2445-1-git-send-email-ritika.srivastava@oracle.com>
	<20220222182732.GV24684@octiron.msp.redhat.com>
	<89458D66-751C-4FCC-8735-E94645EA9AD8@oracle.com>
	<20220222193143.GW24684@octiron.msp.redhat.com>
	<441B1763-CC1E-4283-BA94-F5FF856CE1AB@oracle.com>
	<20220228224435.GY24684@octiron.msp.redhat.com>
In-Reply-To: <20220228224435.GY24684@octiron.msp.redhat.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2b3b6ed-90a9-4c82-0bf2-08d9fbe099a5
x-ms-traffictypediagnostic: DM6PR10MB3738:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3738AF48E1CA8CA3BBAEC76B8F039@DM6PR10MB3738.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: o5XRU0MDRGrDwYXUs+I2pAzR2Tfrp0Nfg502+ffxE7d5DVEiZ88DOwm6agGa4bn6tbfouMMEQ1FEuKJWRiZIIRnoUQg8JzYa2hvla6mm90LTNnC8nSjsTfil1EE6+yj9DuCUtrcSxywB5KZW4YRQ5Q/ctQNx2v4aflpV3A7jX5Li+oAm5O+RvikuHWYcZdRwJhU+mczcETkPygjdpY29W5pirP1YFy6Q6Qaal+ZojvdQ6kIWvICpgfabWCA5MVqPbbeB3Q8jyk327iQXzUU9YK6mkNwY255FtXspreYFEhfRBNDW5zq20K5/aYqmbdKQWPZaUGstMHj1tcqeyw4CYkvqnyK7PtHEmuKF+OWBaSk5ZexztN6nJaU8F55bD05kB3oP5MSSdRwhWaQ2RbOVLtbqieoibKqM7ycdmPLhNlr1DfvoDb+2N7fL9NaRVr2hJ9l86iXdQw/ELd+Td+3sussNodobNKoARqQ0a+Jrhw7LOLy/+zO56oAl1BnrFU1Rf5ANUHso8G8xsLTaxmLKT8/1T9YLbBcNEU5r/7j2B5tpfof58+Wd3CtD+7m3eQk159+/hZSgcURXxllQkT/jGk7VYLuWFN9hS2yOTetcSBxq9qv8yuEEpyBcGK9rWaSOtUkYZEEeVy0ShFh0uwsEsIXR1JIItTvJs6B8k9avH0p8aCF3cp7FNuoTMdt5uVkS0jmPDmctEted8lpEPQZJFcaKOE5zIfKpRPE6zZN10lcR+D0y2Xaz+hRLUPiEk50I
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CO1PR10MB4641.namprd10.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(44832011)(33656002)(6916009)(508600001)(6506007)(2616005)(54906003)(53546011)(71200400001)(6486002)(91956017)(86362001)(64756008)(8676002)(66556008)(66446008)(66476007)(186003)(4326008)(66946007)(8936002)(2906002)(5660300002)(76116006)(83380400001)(122000001)(38100700002)(36756003)(316002)(6512007)(38070700005)(45980500001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qm43T200L1pWQkJZak8zYVUxVDZqK1p5VDh4cC94amJTbWo2ZFQ4dUtQTWpN?=
	=?utf-8?B?SU5aN3lKS0NaTnd2b1Y0NUdOdkY0b3J0WnI5Z09Jb2V4Rjl3cklDV0xTYjVH?=
	=?utf-8?B?TitxNmZqQWl0Q2NaMFdtT0VFRzh4clBqdHZ2K3pwN0txaXBaNkl4Q3dhczM1?=
	=?utf-8?B?aTVqYTBlSnRNN1NjMEVPT2ErSENhaSthamFoNHpmZWh5TTFuamxWZ2JNKzJi?=
	=?utf-8?B?RC9lRXQ1NzVObnZVUjY2aTVLWkZ0L0syM21rd3UvaW1TWTZQSlRqWE9adENW?=
	=?utf-8?B?aFRmanRLci9xRjZKNDBMV0UxbVVodXJadWgrODl3RGFFZE9LMnJiK2ZVSE9k?=
	=?utf-8?B?RXViQkpXcEpjNEZUM2U0ZkZwR01YM0M1bUJOeFdtOHpXcjhOWDhJd29iK3lM?=
	=?utf-8?B?STlDdHdEblFnWmJEbHNDemFmVm10Z0NGckJuNWZqZFlzdDQ4MVArYjRRWHVa?=
	=?utf-8?B?dWpJMmJ5VXV6RFJOSm5iOWZzcUE3OHVqZ3JEQmFiVlc1UTBEd3hQQVVqMWFP?=
	=?utf-8?B?T09KYXZ6M05GZTUwYnh4dnVVMnhPcE9xTHF2aDdSdEhYdUxPRE5FOHcrNmsy?=
	=?utf-8?B?bVNBS1E5bytzMzVHT2ZSbTlPT3RKUC9DajZzUnk3QzdGVDdTdlh1ZU85Qk44?=
	=?utf-8?B?UHpMYmdNbFpQOFlVZ2YvN0ZsU1lvWDRWVXpvS3pYR0tadlVkQ3ZxOVRlOXM1?=
	=?utf-8?B?a1V3REprWmQ5eXM0eGRvbDhxTFg3VHVjamYzRlQxR09ESlZGZDMvVVJERGxW?=
	=?utf-8?B?TzJYMStjTWp1RU1NYTFHenlHdmk1QkE1dEVMWUVkNkdWbU9tbXJ1SWtDL3VN?=
	=?utf-8?B?MjJkWStORjdHa29hTThjYkJvR2V6TDhaOE1yMDZIYjRwbG84YzdzU0xmNlBj?=
	=?utf-8?B?YTlzelZJTDBIYmVGUGZQM3FiUktBdVZ5TWJkRWFQMzBEM1lEYzd4eFRSRC9y?=
	=?utf-8?B?L1pBTnkza0UxWndPbm1nMGc4R0Z2aHdFUGRrakRJZHEzV2M0Ni9iY2xVRU5p?=
	=?utf-8?B?N1VBL0RYaGo1b2FSdGk5REJJdlROUCtHY3dVUEpEcU9NMC8yaktEazBZVlQ4?=
	=?utf-8?B?Z1VBWXhJcUllSTFkakN0NS9GdUZ1S3ZkT1A3ams4Vkc3SFdoZHFQSkZ2RDB1?=
	=?utf-8?B?TGVDNS9rR3NwYmhoMExrcG1vT1ZFa3lnSUNMaU94TmkzWWxFSHlKM2EzL3VV?=
	=?utf-8?B?TjNGRlQyREpsTm9Cd20vcUk2TDg2OWIrR0dVMTR5Q2NzMUtuNHB3T3pxdkNL?=
	=?utf-8?B?cG5SUzdXcGFTZEE5NWV4S0FDZGMvKzdzQldKM2ZyRUxpVmRYeGJoZVRia1hh?=
	=?utf-8?B?SS9odDVFLzJEK2Rmb2wwdC9ZMmFFUkNueVlGdnE1cmFSN2llRWpDSFk4bHV5?=
	=?utf-8?B?SGlpMFd6WGJIVjJ4RkphR1Exc0RqS21LZlozakxxdjcxRk81UXZLck5pRDdQ?=
	=?utf-8?B?MVJsc2UzVGFCTjVpSVlvRVIrZFgxSkJhZ3lFRGZINEwzYWJRVkFzV2NvZEky?=
	=?utf-8?B?STlDSWFBNXorb1RzZVdCdDRGeXJMVUQ4NTl4V05oVVMzT1NVTm1YbWJ1QUJu?=
	=?utf-8?B?MHJRWlBodzFQejlzZmFuN2RySFQ2ZnFvOGtqenZCVHNqaks3clMxLzJYYjZw?=
	=?utf-8?B?OHF2ZFZpZFlDbnNqUDZpOVh0WDR1b1JWUDl4OCtlWWwxa0ZZUjY4NHBOeE9Y?=
	=?utf-8?B?OXZyd3l2OFVnSHpIazQyV1p2YmNoM2gycnk2bG10d3hocTVaWUxxQWc4aXlL?=
	=?utf-8?B?eEd6VVlzQ29HcEo0cDY5MVN2NEk5VnRoekZlYlI4Z3VNRnJISElLZ1RGb0VO?=
	=?utf-8?B?TDMzUWI4eVUwSnpleEVZcmVCZXdNdlZwU2hmRU1oeTBxOVE3VXVaaDVXMEpC?=
	=?utf-8?B?Z2diTHBHeHYrT1FlT0NHK2twNEFhK1dhOW9uazhTV3poMnp2UHBYOVg1Mnps?=
	=?utf-8?B?OWZIM3dWVENJS3hGREFOSGtMVjdLeUtEdGZPS1VJcVBaclhUbW5MdDF6TXdy?=
	=?utf-8?B?d2kzdHY4azNKSXNSZ2l0VjY0UXp1c0Y5K0FmSzNBSVk1MktYQk1lSnd0SVdU?=
	=?utf-8?B?aDRJdENWbTV2VjdyTEs2cS9ta1dvSmNyaXYrbGVPSkFwNlhKdFVBdUNGckw3?=
	=?utf-8?B?WFZSZ1dXenZyaER4NGRrRHo5Y0ppVjQ2d29EWDJTc3BxczEra2ZzZElpSXlX?=
	=?utf-8?B?Y285T1hCS0szSHhVMGZHblJlMzlvSlpDTkFPMll3eDQzRXVuK0xvMkhKektR?=
	=?utf-8?B?dHF5R1dEeEJOcmExL0xHUThEdUJJRjlsTUZvOUhOYkg4cHJSTk5vSnhjblZB?=
	=?utf-8?Q?T6Qch+uF6AhOdh2SlB?=
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4641.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b3b6ed-90a9-4c82-0bf2-08d9fbe099a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 00:07:11.7506 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SISSSDpBt+U/CQbXCQblKNf5Pz8BkgUp90uRgRU536KFC1/Z6zL/9teGFLxqn4LifGiXERdI88D3+jsbbPvTYS/W51+yazm01Kkzx2lcPAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3738
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273
	signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	bulkscore=0
	adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2203010120
X-Proofpoint-GUID: fVGxZKLZtLCoXddu7V22mGJT6iJwUgVv
X-Proofpoint-ORIG-GUID: fVGxZKLZtLCoXddu7V22mGJT6iJwUgVv
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 22207OSu007486
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Martin Wilck <martin.wilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <4BF3B742912939429A27AA22A23A4ACA@namprd10.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/28/22, 2:44 PM, "Benjamin Marzinski" wrote:

    > So unless I'm missing something, we'd only really want this for removing
    > a kpartx device, in the case where somehow you have /dev/loopXpY
    > partitions without the LO_FLAGS_PARTSCAN flag set on the disk. That

That's correct. We only want this option so that once PARTSCAN flag is set, 
Kpartx -d can delete /dev/loopXpY.

    > seems like it shouldn't happen in the first place.  Obviously, you
    > showed that it can with parted.  But I would argue that this is a bug in
    > parted.  If parted is creating partitions, it should set
    > LO_FLAGS_PARTSCAN so the partition nodes get cleaned up.
    > I suppose kpartx could check if there are partition devices for the loop
    > device, and if so, it could set LO_FLAGS_PARTSCAN before doing the

Would removing all partition nodes (/dev/loop0pY) on kpartx -d be a better solution.?

    > remove. But setting it unilaterally would just cause it to create an
    > extra set of devices that would only serve to confuse people (and lvm).

-P should be used only when partition scan needs to be enabled - only on need basis.

    > Also, the actual partition /dev/loopXpY will always get removed. It's
    > just the devnode that stays around, and that won't confuse lvm. This

The example below shows that /dev/loop0p1 is not removed which is confusing the LVM.

    > isn't that odd for loop devices. The /dev/loopX devnodes will stay
    > around once you're done with them, regardless of whether you create the
    > loop device will kpartx or losetup.

That's correct.
But loop device when setup with losetup -P option does remove /dev/loopXpY on detach
Hoping to achieve the same functionality in kpartx.


    >> 
    >> // workaround - losetup -P
    >> # kpartx -a -v test.img                                                                             // First kpartx
    >> # ls -l /dev/loop0*
    >> brw-rw----. 1 root disk  7,   0 Feb 22 20:05 /dev/loop0
    >> 
    >> # parted -a none -s /dev/loop0 mkpart primary 64s 100000s
    >> # parted -a none -s /dev/loop0 set 1 lvm on
    >> # kpartx -d test.img  
    >> # ls -l /dev/loop0*
    >> brw-rw----. 1 root disk   7,   0 Feb 22 20:05 /dev/loop0
    >> brw-rw----. 1 root disk 259,   0 Feb 22 20:05 /dev/loop0p1
    >> 
    >> # kpartx -av test.img                                                                         //Second kpartx
    >> # ls -l /dev/mapper/loop0*
    >> lrwxrwxrwx. 1 root root       7 Feb 22 20:53 loop0p1 -> ../dm-2
    >> 
    >> # pvcreate /dev/mapper/loop0p1
    >> # pvscan
    >>   WARNING: Not using device /dev/loop0p1 for PV <UUID>
    >>   WARNING: PV <UUID> prefers device /dev/mapper/loop0p1 because device is in dm subsystem.

    > So this example shows exactly why I don't want both /dev/loopXpY and
    > /dev/mapper/loopXpY. Whenever we use your -P option we can run into
    > this situation, right?

In the above example, the first `kpartx -a` could benefit from `-P` option and would remove /dev/loop0p1 on kpartx -d.
This is to avoid having both /dev/loop0p1 and /dev/mapper/loop0p1.

The second `kpartx -a` does not need a partition scan and `-P` option should not be provided.
However, yes, you are right - if it is specified in this case, it would create both /dev/loop0p1 and /dev/mapper/loop0p1 
- which then would have to be deleted and recreated without the `-P` option.
Maybe a warning message here would help - something like `-P` option should be used only while creating new partitions. 

Thanks,
Ritika


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

