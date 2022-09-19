Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D85C2C54EE9
	for <dm-devel@archiver.kernel.org>; Mon, 19 Sep 2022 06:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663567866;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=rSr8r+wtLYcwb0trKHCKMdnPReVTM4Qz7LTN8H06/zk=;
	b=Xt9/fWM1GhIF2UO9lbrPyIhn3sMYzBybRaMttuSHzTen2cobD2BU2+u4VXL26Cj53UN6Gl
	7LR97ba20InKKUxWAq/KvVQS80+/BSOc3BpHkSDwW/8sC24o8ddlGzvPS5D+Alt4si22V3
	qoxiHoZuh22UvcmzODjh27r07lHS3Jw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-DzKG8_RlP6uIW5lo4GJuGw-1; Mon, 19 Sep 2022 02:11:02 -0400
X-MC-Unique: DzKG8_RlP6uIW5lo4GJuGw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D82E3C02191;
	Mon, 19 Sep 2022 06:11:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2058840C6EC2;
	Mon, 19 Sep 2022 06:11:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C81421946594;
	Mon, 19 Sep 2022 06:11:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CD2491946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 19 Sep 2022 06:10:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 632AE40C6EC3; Mon, 19 Sep 2022 06:10:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A58E40C6EC2
 for <dm-devel@redhat.com>; Mon, 19 Sep 2022 06:10:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A56985A583
 for <dm-devel@redhat.com>; Mon, 19 Sep 2022 06:10:59 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12olkn2045.outbound.protection.outlook.com [40.92.22.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-SFu57KRyMHe2mOZnSkOtkg-1; Mon, 19 Sep 2022 02:10:53 -0400
X-MC-Unique: SFu57KRyMHe2mOZnSkOtkg-1
Received: from BY5PR14MB3893.namprd14.prod.outlook.com (2603:10b6:a03:1dc::15)
 by PH8PR14MB5990.namprd14.prod.outlook.com (2603:10b6:510:22a::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17; Mon, 19 Sep
 2022 06:10:51 +0000
Received: from BY5PR14MB3893.namprd14.prod.outlook.com
 ([fe80::2163:6c06:f8a8:1d5d]) by BY5PR14MB3893.namprd14.prod.outlook.com
 ([fe80::2163:6c06:f8a8:1d5d%8]) with mapi id 15.20.5632.019; Mon, 19 Sep 2022
 06:10:51 +0000
From: "Pra.. Dew.." <linux_learner@outlook.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Thread-Topic: [dm-devel] dm-verity with GPT
Thread-Index: AQHYyt8ji7+F7zo1TEqoOzC6k0hz063k+BoAgAFOhio=
Date: Mon, 19 Sep 2022 06:10:51 +0000
Message-ID: <BY5PR14MB3893F484853A8B896555EE03864D9@BY5PR14MB3893.namprd14.prod.outlook.com>
References: <BY5PR14MB389354D6BB8D1161E57B3FEA864B9@BY5PR14MB3893.namprd14.prod.outlook.com>
 <alpine.LRH.2.02.2209180604190.19406@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2209180604190.19406@file01.intranet.prod.int.rdu2.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [Xp3j3JFKmfChSefLZOqGacLWyXBWbWQI]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR14MB3893:EE_|PH8PR14MB5990:EE_
x-ms-office365-filtering-correlation-id: 3b604451-5a30-4047-b69a-08da9a05b454
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 5ciSZU3EKGW0Xci8tFn8OFKN/4Y4B7WQYEuxq4J54VejRAxkn5wmlx0EcxUYLPa8Gd8lQO/zb0aGeaCKmCF6t5ZmJeL3DJDkwcpO7oOIcDTxdH45XmnVhv8o8kz7DSYPqYXNtLsNV3PMvQ8RQ+C1tSZRlB/OlgTEK6m9hh9JH2OfaKJGuVdfILMoZmr4K8u9SLg9ByraR7b4hivRr1cU9COvGwa36MdiQGlDIm8cPJYSxSk/xQHoCxa1oCqjGZqwoqqHHigVCbI+qKw7nS7NCzm1neOrLaGMDPteAfa3aRhMLgeEw6fkF+PtnOQ5trNc9VdVNAYdcKlu1pwA+tzV5vL+RPbD0xP5W96OiEnaXKDC+Mjb0SbxtmdNUggL7wfCygZpnBO4s7IzVEHW7jrDduzgcesb/WmfqIAaFHgEzJ4ubQqaRdH1sbRwq8YjPVBd61j8ON8LzX+Cb4KD4UNrfcxSTrJ2AcSRMaQBcJC8H0YIvxNzNbu8+2YjKqpUyE+bTytXA+yIUFAi6P3NxcvDgsuoBH8sm+ZWmT3DHqSceQqU9KyaVzVUNduQkrDvpA1NGvmtk7I4hGk8yhD3k2pz2CxaA0vbtvtBgRpAFvawEI/rmgu1NKY674ClPTUy9M/gtqgYffHSmjdv9Ca4riHcItutW2O0KVTrksvSY2AfJW+/NgtXBEalQMPFkUUFu2qk
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FtOCArufom9/YQjSvvJdkeoKOYK+GY2riqOrs76xGGSQjH+EbH2EK5Cbtgol?=
 =?us-ascii?Q?g7IarieAUp0cKqwMJK7wJvq2YEgwuHs7ywbngfcsuPnkjbAnV8lxzCD7VD1Q?=
 =?us-ascii?Q?SQHQD2tzJkZoud0xhiJCNYUzO+umZACJ0/pksvK5xcKn1q0n2p9BHTtWHqbK?=
 =?us-ascii?Q?G+nSg8ekUYTSPvpf/mToyCwXz8L7Qms7Fuf75fc6Vyw5Y0/YeeN2X+CPttr1?=
 =?us-ascii?Q?utmaD93aCznXXMtI+rtxIS8mrKIzm9HQO3igmgnlK/F9MgfLY883m1OjqyKI?=
 =?us-ascii?Q?etPEtxyYl9GSm/1Mtro+LI1BIcCoX9R68NXoLxnzZBa5t76J6ShZUtKZKvRZ?=
 =?us-ascii?Q?gir9KytQrvwrHsFoX8xmmBe0Wsysyg/CDEizElFkeue8fs5ASThWnCY2jmKR?=
 =?us-ascii?Q?/AOS795dCCh8YDKd9XDFh7Rf4RwlW49j9Y+IcBGhXtFZH9bX4T3L2GCoI8ev?=
 =?us-ascii?Q?ZRG5PIH0YFsXO0ptzVfPVVUrz6lx1pUgXIfrtJ919jlLqlHc/JShHA4lcihb?=
 =?us-ascii?Q?/R4u2Wwl/hpSItsRJDErkXlW1ultXoQ5suEFPfsXFQBBxmfU3eVTtRVQapfZ?=
 =?us-ascii?Q?NJayTaW3AtgHXAMuhwOnh6EhNwlD9cFlZ1IJ1b6shrPYDHcZo6N+aig+vfH1?=
 =?us-ascii?Q?G9T9uGfiqP27Xal2OcsdL/t/JdZDxKVgmC9Gl8TbKuBWCBt1iA/Cx5aIwxIU?=
 =?us-ascii?Q?BfJXM0so8u8LUBT8ZntZPhJvAkHizpQ6xUg5FG8EWqzYFHoIF7oEfnqFVHrI?=
 =?us-ascii?Q?EjTUMklVPm9QJqnAKV1Waf9zvNomTj4iJ3auSZSvyNk331WSll+oUcfzBmsq?=
 =?us-ascii?Q?Z3X2uBFBassyINQYdE6RlEOvuF9OelrcCZCn2Dn6gcCb17u/ybNtcqjpFVzS?=
 =?us-ascii?Q?DzVNzDiBVcjiiHQf6+LYk+w1uma87BPHBeQ6hfg3LpSGn+8Yzx6yzEWuW2gi?=
 =?us-ascii?Q?8JCyabcXsU7EqFNTeXfGfa9geBGr2o6WTbp0xPd1qqELALigM0JVWx55WC8u?=
 =?us-ascii?Q?rjtjH5ArGMbjFMu0pCETC8q75uGBmajOrXg5eNbbvhQ26tkZrzrVytCXhRj2?=
 =?us-ascii?Q?KmvnPf86PwtkfE08owJa4G/j1sKadX52oTluuRvqFZtr1jDRLcyV0r/7wVXS?=
 =?us-ascii?Q?v58NMSkNQjG9s7wG3L7/sHNPhahroXGWSLsB7B6+FiREJi4YAImhh/XlVc2q?=
 =?us-ascii?Q?B9WgshShQyPCpNToQ5x4x61arClQ72MG8tWpWxl2Lsfr5QUkhlqNagqm+YCr?=
 =?us-ascii?Q?3gzyg/bC4XBjhC0UZHVPgKRrMi2hs5MciACVYuk/rVMxA/50geeKoKfC6czp?=
 =?us-ascii?Q?Y6U=3D?=
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR14MB3893.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b604451-5a30-4047-b69a-08da9a05b454
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2022 06:10:51.7154 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR14MB5990
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] dm-verity with GPT
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: multipart/mixed; boundary="===============8215459739249327326=="

--===============8215459739249327326==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BY5PR14MB3893F484853A8B896555EE03864D9BY5PR14MB3893namp_"

--_000_BY5PR14MB3893F484853A8B896555EE03864D9BY5PR14MB3893namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thank you Mikulas. I just want to make sure I understand what you are sayin=
g. Currently we making a dm-linear, dm-verity, dm-linear target; if I under=
stand you right you are suggesting to make it a dm-veriy, dm-linear, dm-lin=
ear target? Of course the 2nd dm-linear target will have LBAs before dm-ver=
ity target. Did I get this right?


From: Mikulas Patocka<mailto:mpatocka@redhat.com>
Sent: Sunday, September 18, 2022 3:10 AM
To: Pra.. Dew..<mailto:linux_learner@outlook.com>
Cc: dm-devel@redhat.com<mailto:dm-devel@redhat.com>
Subject: Re: [dm-devel] dm-verity with GPT



On Sat, 17 Sep 2022, Pra.. Dew.. wrote:

>
> We have a scenario for a VM where a VM is running in the host Linux
> using KVM. We want to expose verity protected rootfs to the VM. This
> rootfs clearly needs to be RO. However, we also want to expose it as a
> GPT partition. In order to do this we are attaching two small files
> before and after the rootfs. The files use linear mapping and get mapped
> to the same /dev/mapper/XX device that has a verity partition. These two
> files contain the partition mappings (primary and backup) for GPT. From
> the VMs perspective, it sees one device (/dev/mapper/xx) as a GPT device
> with rootfs.
>
> The challenge we are getting into is that dm-verity kernel
> implementation explicitly prohibits mixing linear and verity mapping and
> forces the /dev/mapper/xx device to be RO and our needs are exactly the
> opposite.
>
> Has anyone seen this scenario before? Any suggestions?
>
> Thanks

Hi

I think that you can create dm-verity target, put dm-linear on the top of
it and insert that dm-linear into the table with the other two dm-linear
targets.

Would it work this way?

Mikulas


--_000_BY5PR14MB3893F484853A8B896555EE03864D9BY5PR14MB3893namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" xmlns:w=3D"urn:sc=
hemas-microsoft-com:office:word" xmlns:m=3D"http://schemas.microsoft.com/of=
fice/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
=09{font-family:"Cambria Math";
=09panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0in;
=09font-size:11.0pt;
=09font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:blue;
=09text-decoration:underline;}
.MsoChpDefault
=09{mso-style-type:export-only;}
@page WordSection1
=09{size:8.5in 11.0in;
=09margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
=09{page:WordSection1;}
--></style>
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"#954F72" style=3D"word-wrap:bre=
ak-word">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Thank you Mikulas. I just want to make sure I unders=
tand what you are saying. Currently we making a dm-linear, dm-verity, dm-li=
near target; if I understand you right you are suggesting to make it a dm-v=
eriy, dm-linear, dm-linear target?
 Of course the 2<sup>nd</sup> dm-linear target will have LBAs before dm-ver=
ity target. Did I get this right?</p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<div style=3D"mso-element:para-border-div;border:none;border-top:solid #E1E=
1E1 1.0pt;padding:3.0pt 0in 0in 0in">
<p class=3D"MsoNormal" style=3D"border:none;padding:0in"><b>From: </b><a hr=
ef=3D"mailto:mpatocka@redhat.com">Mikulas Patocka</a><br>
<b>Sent: </b>Sunday, September 18, 2022 3:10 AM<br>
<b>To: </b><a href=3D"mailto:linux_learner@outlook.com">Pra.. Dew..</a><br>
<b>Cc: </b><a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><b=
r>
<b>Subject: </b>Re: [dm-devel] dm-verity with GPT</p>
</div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"margin-bottom:12.0pt"><br>
<br>
On Sat, 17 Sep 2022, Pra.. Dew.. wrote:<br>
<br>
&gt; <br>
&gt; We have a scenario for a VM where a VM is running in the host Linux <b=
r>
&gt; using KVM. We want to expose verity protected rootfs to the VM. This <=
br>
&gt; rootfs clearly needs to be RO. However, we also want to expose it as a=
 <br>
&gt; GPT partition. In order to do this we are attaching two small files <b=
r>
&gt; before and after the rootfs. The files use linear mapping and get mapp=
ed <br>
&gt; to the same /dev/mapper/XX device that has a verity partition. These t=
wo <br>
&gt; files contain the partition mappings (primary and backup) for GPT. Fro=
m <br>
&gt; the VMs perspective, it sees one device (/dev/mapper/xx) as a GPT devi=
ce <br>
&gt; with rootfs.<br>
&gt; <br>
&gt; The challenge we are getting into is that dm-verity kernel <br>
&gt; implementation explicitly prohibits mixing linear and verity mapping a=
nd <br>
&gt; forces the /dev/mapper/xx device to be RO and our needs are exactly th=
e <br>
&gt; opposite.<br>
&gt; <br>
&gt; Has anyone seen this scenario before? Any suggestions?<br>
&gt; <br>
&gt; Thanks<br>
<br>
Hi<br>
<br>
I think that you can create dm-verity target, put dm-linear on the top of <=
br>
it and insert that dm-linear into the table with the other two dm-linear <b=
r>
targets.<br>
<br>
Would it work this way?<br>
<br>
Mikulas<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_BY5PR14MB3893F484853A8B896555EE03864D9BY5PR14MB3893namp_--

--===============8215459739249327326==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8215459739249327326==--

