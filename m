Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B82EFC64ED8
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 07:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677481442;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KYv0kh7J9KkJ2B7B6F1/cxNlefqrn/wuw3iSqVwg3LI=;
	b=XkbhgKYXpzl+Z6Eyw6s47zpIHsZ6VP7gjLXCwGzl68NCPa91Lj033yyOIW3Edht5+upthp
	fVKA+lRGYd34REQjTm0f4LPYBPJAX9SApR6XDytDKxAEYLh5z1fLveDIhPgLqBu+gfjoEJ
	ib00SQHX6X1IwgKF4gn99zAtDYbIsWQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-cwZtw-IWNxmC-5rVGLg9yw-1; Mon, 27 Feb 2023 02:03:41 -0500
X-MC-Unique: cwZtw-IWNxmC-5rVGLg9yw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B986F1C0434F;
	Mon, 27 Feb 2023 07:03:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A674A492B12;
	Mon, 27 Feb 2023 07:03:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6E60B1946594;
	Mon, 27 Feb 2023 07:03:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DA45919465B3
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Feb 2023 17:47:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 979D52026D3E; Fri, 24 Feb 2023 17:47:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E5AF2026D4B
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B491800B23
 for <dm-devel@redhat.com>; Fri, 24 Feb 2023 17:47:31 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-e2i8a4Q5Nq2x1kjPBvyt6Q-1; Fri, 24 Feb 2023 12:47:29 -0500
X-MC-Unique: e2i8a4Q5Nq2x1kjPBvyt6Q-1
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31OHhqUA003285; Fri, 24 Feb 2023 17:45:16 GMT
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com
 (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpqcntj6-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:15 +0000
Received: from pps.filterd
 (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31OH1Ks5026136; Fri, 24 Feb 2023 17:45:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
 by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id
 3ntn49sdsv-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 24 Feb 2023 17:45:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:12 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri, 24 Feb 2023 11:44:49 -0600
Message-Id: <20230224174502.321490-6-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
X-ClientProxiedBy: DM5PR07CA0054.namprd07.prod.outlook.com
 (2603:10b6:4:ad::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 48dc6dce-adf0-4f56-8abc-08db168ee168
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: /QJBAY3ca3Wb/gMYgG91v3+8DhEwR3MpVtLP+Jvzz4dIEWVoEY9QSIZtJwHXE008FAFQnSUe0ztkj3Hsb2yY+yYwRVIkubZOMqd4tRM1P135k2JbfsTOue9hVzo2TtEtjtRMN344Rk6KW+k0YTOit9uDQjl81odPOA/zuTfs9Iwjpx8kWHbCWPW06ktLgCRqIfSwBriLNMH1dApgukQFC0aRU1XLIk+pYi/wTqrPb58mGV+/lb67vhlEN+LxjGn9WRqCE/30HjTRTyUoD3WwZkjdLu3bGyBK7YZ1su7MS/s6TfQKJi+C0XNdNLiYDMHdDJKxx9CGmxv86T4Cdv74O5ajm0rfCp+lOJHqCiOWANHpTjni27MIDezrvRR1B4RwbmQc2bE4HsBmohZXF7iVLmp6k9UCkbAmTeU1CfAXrCL5gyOjcAAy8c75tIeplJOeyk/GUoUlsfihdwKr7OPS+ue+KJwS2aVgnI0H3MHQ80IgLEeV0koJMiAl3sGB9W6mOQoPIW+B44XVPBlxdk5/XXUthdLGDiSaifNDbsi3WOnioyR4FFKLRav7DHvEIuy0wFp0oKn0Bzy5rnYLPDpJ4tT2poPraLUKY9RXDvZFPQuWD57yYDFwYf4KH1iKoDYk3725EtoGkiN7P8iCz35u8c6dNaResSf8mvLE+oH2/7bB5aKZ7yQcH09lqxwTv3LD
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM5PR10MB1466.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xBhjmged5d/y0k2gjyrsRQES9Ks0ij51FI74O6kyJPSu9LA25t+UJOE4/H/L?=
 =?us-ascii?Q?qyziIPJgLU2AmDPee43smMOybqfoS5RBKmwuJiTUc3/Yi+UllBW2brWcfWCf?=
 =?us-ascii?Q?LNr+Mdc8n6JeEr8RrP0WxvjZnSFLPIosp3zVQjRpxWxcTWtAxBtMgnW3yD9O?=
 =?us-ascii?Q?YhznkwPNHZxQm0lmAo56oRFs8joJH7Uh9s3wiCa4S5Whh7EhRuNZbjZ9k6qc?=
 =?us-ascii?Q?LTShpNd7jxXEvSt8zWS1tD8jQlJz0s5Vt2zdqSTdKMwoDoP2x2NzPac9fWTP?=
 =?us-ascii?Q?9VZW5r/v9l2/1WugdkDZqjroQalSFIZbZK5tFmzCELPW5v070IDLSvHnzMnj?=
 =?us-ascii?Q?+ovD5DfqsGZXZgx4yJbcQSxa0ZKoUOMV227Hrk5Kn6Q3yv4CQ5M+lQYSVok3?=
 =?us-ascii?Q?ZBJYjp2sGbq/TT12AQOJlIWWfjXCVhM9DQ5mfxSf+YaDkFtXxIX1qUvMQEbT?=
 =?us-ascii?Q?T5tDdm5oaFIDdl4WM9XRAs7y11SUEFaNuB0lMqxdcMHtAspXcbF0T+YeOy77?=
 =?us-ascii?Q?skIBedDBW2XRXk2NtVqRNZudsS4Qy1crqyGnIInJz1ntl4rXIawP8okEH8UC?=
 =?us-ascii?Q?D264MjUzEoXBmDNhBeCRe5wHXP3vE+NlOR1AXx+0jSYdRdNojp6sZngejic/?=
 =?us-ascii?Q?rSsvlW8mVdOHRccbg4fR9elrrWa0ET9AmKHfginiH8gxWLf6g6Tc+D1q/Ay5?=
 =?us-ascii?Q?pF/GqcYnt60agQRilC/FUmyr5S5s125iE20aJm5UeaNTtHM7YuEIGOF5lMV8?=
 =?us-ascii?Q?cr5lpimexyAUh5rajEiRW2dQWUKGvOh/2XtRYeXTrwyT7P4TNjXY6hejgNHZ?=
 =?us-ascii?Q?KDeVFQGOefehKQKyIKlCtJVg/ts3ibF4y/UNkwzmoYMOvTBh8UF+MtWFugAT?=
 =?us-ascii?Q?VchKsqedH9MO9nqgvIqvOId7I8mlR3twDiKpsL0v0+grba2aVWldF8MtOpXl?=
 =?us-ascii?Q?swGMc/5UQfXwZm14aV5IROqaj7c988WJ1Tu4A0zKh42ZEaLxAjk8Ma7Nzk5C?=
 =?us-ascii?Q?MVhWYiBWRmdDNE8Z3sWXhknB2g+aIAi4sr626OPj+k74Mwd+9IIRBqJeLmE8?=
 =?us-ascii?Q?zvinLovWoZnfrZ63sX6nTGaa85sSYvNzE83DoEsWl/p2mg5rSrLDnMRjBSHs?=
 =?us-ascii?Q?nVBMckqoN3wbn1U8h5U1rEj4KkHDDbV+dm/Ht4g+Lyij36CHcns7wVKrUgdZ?=
 =?us-ascii?Q?YRqNsu8LtfRP8zj12fqSCmnpug4JeZL1+5amxWBBe5GsfjdwwHf+wGrrpGKa?=
 =?us-ascii?Q?n3wp/e8ZmG86yGpjqLN+qiMmGt2T0lqPXYvXhqTDaOaR1BzFHfe5aJ8gavqx?=
 =?us-ascii?Q?GhKk+39LYkkD4RDea0N1vBYKuKrAL2ObehBqserjlOImEIw8s2TadiNCKTud?=
 =?us-ascii?Q?SZ1AGYFAPum3d8Wh68ZKKDqeqtT+QW891JfZkrzZEVg07H/7NhzbpKmh6vEF?=
 =?us-ascii?Q?ADJxFTSfAGZ3HT/VYFb+kKVNKm3+On7hsmUcteqsG+Bxi6C5V/pngyS6DW+c?=
 =?us-ascii?Q?6xL6/A6ZWWvllHsnxEojjmepDBV/vrd0jNS9bCJT0uhdPPUo0ZA3MJloGAOE?=
 =?us-ascii?Q?G4ISrPclr8l6Xsl5jeHYN8xkvgQdCO7RJTD4UwhSw1oarooT6ohQtZqnNL+a?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?RLWMwTIrO5e9K8MyipkV60DTMw68sO7VxegmeDjIn6ZlMuizM6EADKN+dRxc?=
 =?us-ascii?Q?j15/RMsjIKkj1QapRvM5/2k9Im+LsbcMtu7De1jGtg/4HI9xxBB3VuMhurky?=
 =?us-ascii?Q?X8laB+EOzDl83cbBpEwNpX2vjF1+nqqXYsGhs3BcyWvdCLZFy0+gp2DbHkiT?=
 =?us-ascii?Q?CIXd6c26LTene7YwdRbBJXFbiJOUn7ilFawdKO5+vE92mCW3LChS2+y/2A2S?=
 =?us-ascii?Q?fUbwQjtSRTmlKw4zF9LaNlWHM/pGttJsKltKJnRlfHaJsHiUt/OseHhHRvF/?=
 =?us-ascii?Q?2coZOoe0PHHXPCNZ93HwJLaJb6wSJq9J4u7YHGyoAM+pv98ZVD1+Qf4eFX/+?=
 =?us-ascii?Q?RGHk+5rp8vajYM2WguF1pNCsWqFicg8rUd3mRVI2jz+2LAOs+LVw5ibntfzQ?=
 =?us-ascii?Q?UZx1ehOHXIEpcaaRU90JeXgQdZ/2o6vB53vPH9V0GIQcIPtI+0/WAJBBkvsC?=
 =?us-ascii?Q?GLckuq4M4cPYluJef0bi8irDC7Y02AaFPrAecFXSSMJ7RUsrj8ge/D7S4PIr?=
 =?us-ascii?Q?s+7fy2MtDJyYcVZEWRh1/AhAKeFXHGqWAU8LBBJzKO7QNeyyH1BFXmCPgPk7?=
 =?us-ascii?Q?m8kuKv7tV20Q3tcijRB7CVgX82oYTiYWLudG+mvdflzBf7fJrQ86PvKwPokk?=
 =?us-ascii?Q?jUcO4dG99Rv3tz3lFoKG8daTsj5V/MEU8XPV3IcreKWXjpPBghUMDbawoI2e?=
 =?us-ascii?Q?NRl1cjAiu8yucf4aj1RbkXLskeJca3pRsaamrrTYziD4vnPogxJjEd/BW3m0?=
 =?us-ascii?Q?vR8RGW/oG8OzHOLN6fcog6oA6DbF6x9/iV7mJo4gHB+bumdKVBEpWhkTHL/W?=
 =?us-ascii?Q?KMLKSVrvZ/lT/Dl4ej9Xm7KAtOyBLe3X4fOT0pIpNoTJ44hmpQA83xNiSHjT?=
 =?us-ascii?Q?NJAayU475j3OQsXtZnThv/X7xzxaNdYy/675gjBHO+5ArIIZ4FWhc43GcENt?=
 =?us-ascii?Q?vV31U9DNsUylCEzqM2Lhog248/IPrjDRB3BYeyIBuj+X3DGd6tWAId68uaRQ?=
 =?us-ascii?Q?RWYQubK9VXa45U7SeBOYink9Ng=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48dc6dce-adf0-4f56-8abc-08db168ee168
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:12.7511 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bfNHVr9W7qXCfMTjTdbcYFqjONEHGBNgGCVDYl+PZwiERJ9J41B6ySI+V1oNCxzO7BU9CTEHWZnBO2+hBSIILQ2XgsaPxOWeuaHRAyEWYa8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240139
X-Proofpoint-GUID: lHT8WFdqIYSvC_OHP0m0jy4Y9zmzVweq
X-Proofpoint-ORIG-GUID: lHT8WFdqIYSvC_OHP0m0jy4Y9zmzVweq
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 27 Feb 2023 07:03:30 +0000
Subject: [dm-devel] [PATCH v4 05/18] scsi: Add support for block PR read
 keys/reservation
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
Cc: Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This adds support in sd.c for the block PR read keys and read reservation
callouts, so upper layers like LIO can get the PR info that's been setup
using the existing pr callouts and return it to initiators.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c            | 91 ++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_block_pr.h | 20 ++++++++
 include/scsi/scsi_proto.h    |  5 ++
 3 files changed, 116 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a801ef393c38..dc5a058cc686 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1724,6 +1724,95 @@ static int sd_scsi_to_pr_err(struct scsi_sense_hdr *sshdr, int result)
 	}
 }
 
+static int sd_pr_in_command(struct block_device *bdev, u8 sa,
+			    unsigned char *data, int data_len)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_sense_hdr sshdr;
+	u8 cmd[10] = { PERSISTENT_RESERVE_IN, sa };
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
+	int result;
+
+	put_unaligned_be16(data_len, &cmd[7]);
+
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, data, data_len,
+				   SD_TIMEOUT, sdkp->max_retries, &exec_args);
+	if (scsi_status_is_check_condition(result) &&
+	    scsi_sense_valid(&sshdr)) {
+		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
+		scsi_print_sense_hdr(sdev, NULL, &sshdr);
+	}
+
+	if (result <= 0)
+		return result;
+
+	return sd_scsi_to_pr_err(&sshdr, result);
+}
+
+static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info)
+{
+	int result, i, data_offset, num_copy_keys;
+	u32 num_keys = keys_info->num_keys;
+	int data_len = num_keys * 8 + 8;
+	u8 *data;
+
+	data = kzalloc(data_len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	result = sd_pr_in_command(bdev, READ_KEYS, data, data_len);
+	if (result)
+		goto free_data;
+
+	keys_info->generation = get_unaligned_be32(&data[0]);
+	keys_info->num_keys = get_unaligned_be32(&data[4]) / 8;
+
+	data_offset = 8;
+	num_copy_keys = min(num_keys, keys_info->num_keys);
+
+	for (i = 0; i < num_copy_keys; i++) {
+		keys_info->keys[i] = get_unaligned_be64(&data[data_offset]);
+		data_offset += 8;
+	}
+
+free_data:
+	kfree(data);
+	return result;
+}
+
+static int sd_pr_read_reservation(struct block_device *bdev,
+				  struct pr_held_reservation *rsv)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdev = sdkp->device;
+	u8 data[24] = { };
+	int result, len;
+
+	result = sd_pr_in_command(bdev, READ_RESERVATION, data, sizeof(data));
+	if (result)
+		return result;
+
+	len = get_unaligned_be32(&data[4]);
+	if (!len)
+		return 0;
+
+	/* Make sure we have at least the key and type */
+	if (len < 14) {
+		sdev_printk(KERN_INFO, sdev,
+			    "READ RESERVATION failed due to short return buffer of %d bytes\n",
+			    len);
+		return -EINVAL;
+	}
+
+	rsv->generation = get_unaligned_be32(&data[0]);
+	rsv->key = get_unaligned_be64(&data[8]);
+	rsv->type = scsi_pr_type_to_block(data[21] & 0x0f);
+	return 0;
+}
+
 static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 			     u64 sa_key, enum scsi_pr_type type, u8 flags)
 {
@@ -1805,6 +1894,8 @@ static const struct pr_ops sd_pr_ops = {
 	.pr_release	= sd_pr_release,
 	.pr_preempt	= sd_pr_preempt,
 	.pr_clear	= sd_pr_clear,
+	.pr_read_keys	= sd_pr_read_keys,
+	.pr_read_reservation = sd_pr_read_reservation,
 };
 
 static void scsi_disk_free_disk(struct gendisk *disk)
diff --git a/include/scsi/scsi_block_pr.h b/include/scsi/scsi_block_pr.h
index 44766d7a81d8..9695cda4e9ce 100644
--- a/include/scsi/scsi_block_pr.h
+++ b/include/scsi/scsi_block_pr.h
@@ -33,4 +33,24 @@ static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
 	return 0;
 }
 
+static inline enum pr_type scsi_pr_type_to_block(enum scsi_pr_type type)
+{
+	switch (type) {
+	case SCSI_PR_WRITE_EXCLUSIVE:
+		return PR_WRITE_EXCLUSIVE;
+	case SCSI_PR_EXCLUSIVE_ACCESS:
+		return PR_EXCLUSIVE_ACCESS;
+	case SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	}
+
+	return 0;
+}
+
 #endif
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index fbe5bdfe4d6e..07d65c1f59db 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -151,6 +151,11 @@
 #define ZO_FINISH_ZONE	      0x02
 #define ZO_OPEN_ZONE	      0x03
 #define ZO_RESET_WRITE_POINTER 0x04
+/* values for PR in service action */
+#define READ_KEYS             0x00
+#define READ_RESERVATION      0x01
+#define REPORT_CAPABILITES    0x02
+#define READ_FULL_STATUS      0x03
 /* values for variable length command */
 #define XDREAD_32	      0x03
 #define XDWRITE_32	      0x04
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

