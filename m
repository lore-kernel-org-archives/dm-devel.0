Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4B98C43334
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jul 2022 08:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657613737;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/CkqYzOvMF8cJv9tOi4xZe0s1bQtf3CIl3tMKCyEN4U=;
	b=dcF1yq5Cpf2VECpQ+ZKij0gJgaAv+ba4+jiJGFq5AkWHVzd/uyhQmr3hiCmJ3w3N5f11rj
	M2kDYpKSHzz6kxIHIiPP+IboSPRxIaptULivTIbh36fRUeV6NjlgGOCAqTb3LSd6fGzT3L
	E2QGxjdXPipLAUAJJTD3TORCySI6bjQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-hYFIdDXIPYCDBQq74H9CVw-1; Tue, 12 Jul 2022 04:15:34 -0400
X-MC-Unique: hYFIdDXIPYCDBQq74H9CVw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0190F823F0C;
	Tue, 12 Jul 2022 08:15:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A703B4050067;
	Tue, 12 Jul 2022 08:15:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7E092194705E;
	Tue, 12 Jul 2022 08:15:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EF35B194706B
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Jul 2022 10:04:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E180414152E2; Fri,  8 Jul 2022 10:04:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DC03614152E1
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 10:04:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD02529DD9BC
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 10:04:53 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-9dTDrDclNayGudQeQojO_Q-1; Fri, 08 Jul 2022 06:04:52 -0400
X-MC-Unique: 9dTDrDclNayGudQeQojO_Q-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2689TABU000383;
 Fri, 8 Jul 2022 10:03:44 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubyfbtq-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 08 Jul 2022 10:03:43 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2)
 with SMTP id 268A1thI017973; Fri, 8 Jul 2022 10:03:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id
 3h4ud9qcwg-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 08 Jul 2022 10:03:41 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB4924.namprd10.prod.outlook.com
 (2603:10b6:610:ca::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Fri, 8 Jul
 2022 10:03:37 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 10:03:37 +0000
Date: Fri, 8 Jul 2022 13:02:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Guenter Roeck <linux@roeck-us.net>
Message-ID: <20220708100219.GJ2338@kadam>
References: <62c683a2.g1VSVt6BrQC6ZzOz%lkp@intel.com>
 <YsaUgfPbOg7WuBuB@kroah.com>
 <20220707140258.GA3492673@roeck-us.net>
In-Reply-To: <20220707140258.GA3492673@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0050.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::10)
 To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60888dca-74ab-415d-c312-08da60c91fbd
X-MS-TrafficTypeDiagnostic: CH0PR10MB4924:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: QpeUnUA80G+bljAIjcJUjdGQmN5uY1eFjfrdzbA17ZIS3uabFZv6Hj1kGve2Lkd6ukSIrwiau9r0ovgbwx+dZEkKmEv6+vXYk4KZAt/MIhaL91UGE+paD/7pDhxzw4BYYVzzpcTlpWSU2EifziKfjy7zSFc7TnpneOwuqT8aeevBVsak78DiURzZSmtUYh/Qt36gA5/ksmagoLtxfOrwnwiX4glTSsn8t5yf7q4IzdByoZMhq0/OHP2LZ5gMTFtZ6UHjHdMMXGvblMy4nwFFyDxr86OS56TwXu8Un5G4D4DsBq8RB57WhWGKUtSyUbZZbVRFVkXmco1NenhtSk86OVpxyYHEtK55FxQsoFvpcV9t5yQLp1tE1ssb1OlZae0sqORl49xAPisMT7jN1cFGRywkbs4jxpVhNo8QYdWoQ3VACsB1KUJ93fDES9dLhmgaIFwDWA8dmP2LXuL1Pd+DFJJTLkU2NgkpHh5jR/cu2c2jTU6PpCMhJIrwzdDt8sfkR6UcBI76NJL0PW+PVyYni0a7Pe3rbeU1PW70RjKKv2/VmnwT8TE08KBGeDQFp1AHEmMbpH2SgzlQWxMvwgGWtM/6/xUqkCQd/CwrTTQo63A1MOH6B7syzqHOaHclI2HJeLiaHI3iu+zlJxnG2+klM626OprekeiAtpkpRWukWRhFT8PONEEVRTQsT2XM6vCyFIqckzuC+ioRgs4tOx6NIenPb/oTrABzGoY+mHsNaR1Q2HerdVNbOlkOvYEcJhoSs2/qCEmiEqL11HGPPZoOhtWl90u/pVoJWO8OqO1Cy/1JYLe4uJbmE6i1YFG6PeLI
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MWHPR1001MB2365.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(7916004)(376002)(346002)(136003)(39860400002)(396003)(366004)(33716001)(33656002)(478600001)(41300700001)(44832011)(52116002)(6486002)(38100700002)(6506007)(316002)(54906003)(6666004)(4744005)(38350700002)(6916009)(2906002)(86362001)(66556008)(6512007)(66946007)(8676002)(7336002)(7366002)(7416002)(7406005)(26005)(9686003)(5660300002)(66476007)(186003)(4326008)(1076003)(83380400001)(8936002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uG7EisZU53uo3Eyn1rAkH1Zp7prdDVjLvtewrji3nHaInhwwPqKJd8IS9Ml6?=
 =?us-ascii?Q?cCMDRE9xZtRy2ixvN9HtQCxQ6wyVdCMjht4JEfcGvVBGnhiqaHo4dtqdZQNj?=
 =?us-ascii?Q?TGMY5D1FDrgRGu1ZqSXbxw6awVGysMa0+MX66gOjQV085NsMve2O4eyl5F5y?=
 =?us-ascii?Q?1R/1hXNMky/piEnyu/AV2u9cPc8QXEEh5K/YB5xHM0lnOA68c0zycKWASuhL?=
 =?us-ascii?Q?Kla+gf2FV2JSVMUu/Ri/D4jFuSeza/bxZHWLcnm2ZsVWcrf0/LgByhqRjtSp?=
 =?us-ascii?Q?is7aqVU5aytLlmIcj33/i5SfhSOL6wtmqbxmSOEOtAVcsEJtIXON2a0hsur6?=
 =?us-ascii?Q?hsWV1BvYk4AATAbHUOntCKDw5fmW1Zb7JOZVwY9IVuxyRJroXe+t96bJLXrI?=
 =?us-ascii?Q?MssjNzxXj4Jypus/6TmDDUIrYr/PohLpQ7G33Mmk20Wl8iVHL8gXU0umskty?=
 =?us-ascii?Q?O4Hi9SohVBBFpOOh6t4TgJ/w2hGioWQ3sldG+lmRcJwb3j0MzuvquWbIKe1R?=
 =?us-ascii?Q?gnxXwQFlT03ge3rnLtt4I5eXee2ZugYaT8hbKKltmH00UW2rot4ogdsXX2iI?=
 =?us-ascii?Q?DNsESB9w2oxovD/ZQf1hpR0G4CNtCUS0CYB5QKnSBDpXPeXkQpoHeFzSSfjR?=
 =?us-ascii?Q?wLuWIMCwND+t3ovztoAdWN/UQtE5mMC0kkUBUToTTjIvLciDMD0PSNB6BJUe?=
 =?us-ascii?Q?w0PR0q9LRd1D/jkiavRKpLKgXzeczspq+Psu7R01u1srIE/QHzUUjYVl5f9a?=
 =?us-ascii?Q?L02x85oqudSEWTubWsX6ss1WfTqA+8NqL5ENwQjoi9UEoTolcwA7e2XUcwAO?=
 =?us-ascii?Q?ic9ZTDSAl8/AsX+2l6+qsgzLGODxDFe3K1ko9b4kwkQxpr9NU9z8O/MWDlAK?=
 =?us-ascii?Q?Dnlvq31Zf740z3fuyX3wN9p5/ha59mVpxZF+xjtVxT7DoDfkostGyBOBfUce?=
 =?us-ascii?Q?e6fdpEx92+LmFi1lzmVO4Ia+ECDiem6tXYEmQXIyfxx3Lw0RUCChVAujKWLo?=
 =?us-ascii?Q?oUy4+s0iF6iSny0nF8zOLNHqJzxvFEexDubf1ILb/3btBYa9NgUS5BOaIoA9?=
 =?us-ascii?Q?WqJ1H2aDG9Kic8ymHAc4FFqNBtuTucRoBG6Ms8LMqLNF0Vza4OaikcRksmX4?=
 =?us-ascii?Q?rgBMlDqx5pO3KFCTenU+qbHOBovKp6H6HnXn/7m/aF3l+ZqmdwuG77shGwxJ?=
 =?us-ascii?Q?u+KGV063dyQ+dCgsyvudHwbxefjBFDbkHK/Ybw0NmKX2mYGuv7jbzKnp7JDc?=
 =?us-ascii?Q?AF5HmXDQhKXZbO2HxUKsXY8vRrxFZhmbIJJMirc8HFwPS3gAzjzb+szX+vF7?=
 =?us-ascii?Q?xOUKc56091EkjOl6fcqQEf5AMF6UjW4HOZCLHO1S/4o81dPO+oVZQykyHGNa?=
 =?us-ascii?Q?fevSECWId0k6CwanCU7579YdUXJJMBRkComEJNrTAoR4lhftqLiI0U3rDdrj?=
 =?us-ascii?Q?Del01xUlm7N66LbqNEPYOHt8Vj9P+Nd4ahXQKeqyeKRQ+d5V2/xM7j6eGiim?=
 =?us-ascii?Q?CELTFADnEsTdWjQiE8bsPhByqbhH87XWEemEF1ulwsM6DII28FAYU+uBiySC?=
 =?us-ascii?Q?89eQCwECLDAfd9gxbLFLH7xJjKAclbo03RJxaMbLiExaPJ39HgBBQBjVroGH?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60888dca-74ab-415d-c312-08da60c91fbd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 10:03:37.5131 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xmfxxd2ImvCkN86fhSrHry1xr1wVpvkQCd/kvXC28R2/OhB8G8NrxAgoSiTGxSTnG4h/h/BFA9rqzl+lMJyKXtKr24bFre3OPhNr8wLciI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4924
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517, 18.0.883
 definitions=2022-07-08_08:2022-06-28,
 2022-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207080036
X-Proofpoint-GUID: Ew-Ts5aNqfwze6JmTbUyOisAm9IQ4z0u
X-Proofpoint-ORIG-GUID: Ew-Ts5aNqfwze6JmTbUyOisAm9IQ4z0u
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Tue, 12 Jul 2022 08:15:28 +0000
Subject: Re: [dm-devel] [linux-next:master] BUILD REGRESSION
 088b9c375534d905a4d337c78db3b3bfbb52c4a0
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
Cc: nvdimm@lists.linux.dev, legousb-devel@lists.sourceforge.net,
 dri-devel@lists.freedesktop.org, linux-sctp@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com, linux-samsung-soc@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-pm@vger.kernel.org,
 usbb2k-api-dev@nongnu.org, linux-omap@vger.kernel.org,
 megaraidlinux.pdl@broadcom.com, Greg KH <gregkh@linuxfoundation.org>,
 linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux-perf-users@vger.kernel.org, netfilter-devel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-wpan@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-parport@lists.infradead.org,
 linux-doc@vger.kernel.org, samba-technical@lists.samba.org,
 linux-cxl@vger.kernel.org, virtualization@lists.linux-foundation.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org, dev@openvswitch.org,
 linux-cifs@vger.kernel.org, kernel test robot <lkp@intel.com>,
 linux-clk@vger.kernel.org, linux-rockchip@lists.infradead.org,
 iommu@lists.linux.dev, coreteam@netfilter.org, linux-media@vger.kernel.org,
 linux-watchdog@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, greybus-dev@lists.linaro.org,
 linux-amlogic@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-iio@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-fpga@vger.kernel.org, alsa-devel@alsa-project.org,
 linux-mtd@lists.infradead.org, cgroups@vger.kernel.org,
 linux-phy@lists.infradead.org, sound-open-firmware@alsa-project.org,
 linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
 amd-gfx@lists.freedesktop.org, isdn4linux@listserv.isdn4linux.de,
 linux-input@vger.kernel.org, linux-ext4@vger.kernel.org,
 ath11k@lists.infradead.org, mjpeg-users@lists.sourceforge.net,
 openipmi-developer@lists.sourceforge.net, linux-hwmon@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-mmc@vger.kernel.org, iommu@lists.linux-foundation.org,
 keyrings@vger.kernel.org, patches@opensource.cirrus.com, kvm@vger.kernel.org,
 damon@lists.linux.dev, linux-mm@kvack.org,
 accessrunner-general@lists.sourceforge.net,
 linux1394-devel@lists.sourceforge.net, linux-leds@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-x25@vger.kernel.org, dccp@vger.kernel.org,
 intel-wired-lan@lists.osuosl.org, linux-serial@vger.kernel.org,
 devicetree@vger.kernel.org, linux-nfc@lists.01.org,
 osmocom-net-gprs@lists.osmocom.org, apparmor@lists.ubuntu.com,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-tegra@vger.kernel.org,
 linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 ntb@lists.linux.dev, tipc-discussion@lists.sourceforge.net,
 linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jul 07, 2022 at 07:02:58AM -0700, Guenter Roeck wrote:
> and the NULL
> dereferences in the binder driver are at the very least suspicious.

The NULL dereferences in binder are just nonsense Sparse annotations.
They don't affect runtime.

drivers/android/binder.c:1481:19-23: ERROR: from is NULL but dereferenced.
drivers/android/binder.c:2920:29-33: ERROR: target_thread is NULL but dereferenced.
drivers/android/binder.c:353:25-35: ERROR: node -> proc is NULL but dereferenced.
drivers/android/binder.c:4888:16-20: ERROR: t is NULL but dereferenced.

regards,
dan carpenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

