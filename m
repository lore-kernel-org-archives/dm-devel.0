Return-Path: <SRS0=ugf6=NW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5948AC43214
	for <dm-devel@archiver.kernel.org>; Tue, 31 Aug 2021 07:25:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DE4C661008
	for <dm-devel@archiver.kernel.org>; Tue, 31 Aug 2021 07:25:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DE4C661008
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-vtc4ttoaOFGNq63VJ6C3cA-1; Tue, 31 Aug 2021 03:25:56 -0400
X-MC-Unique: vtc4ttoaOFGNq63VJ6C3cA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 798F6760C8;
	Tue, 31 Aug 2021 07:25:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 60B1617AC5;
	Tue, 31 Aug 2021 07:25:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E8A3D181A0F7;
	Tue, 31 Aug 2021 07:25:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17UGw3LJ017140 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Aug 2021 12:58:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A260621568B9; Mon, 30 Aug 2021 16:58:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B5BD200AD1B
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 16:58:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D00018A01AC
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 16:58:00 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-336-xQzQmcV8Omi2767PZPLg_g-1; Mon, 30 Aug 2021 12:57:57 -0400
X-MC-Unique: xQzQmcV8Omi2767PZPLg_g-1
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17UGrx15151124
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 12:57:56 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com
	[159.122.73.70])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3as21da99f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT)
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 12:57:56 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17UGvZZM004339
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 16:57:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com
	(d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma01fra.de.ibm.com with ESMTP id 3aqcs8n9qk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT)
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 16:57:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
	[9.149.105.61])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 17UGvoHq48103884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Mon, 30 Aug 2021 16:57:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A324F11C054;
	Mon, 30 Aug 2021 16:57:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 74B5D11C04C;
	Mon, 30 Aug 2021 16:57:50 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com (unknown
	[9.145.24.100])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 30 Aug 2021 16:57:50 +0000 (GMT)
To: dm-devel@redhat.com
References: <20210825222413.2822-1-xose.vazquez@gmail.com>
	<6123dd27bfaa10641c45d0477516e068bc7c8ecb.camel@suse.com>
From: Steffen Maier <maier@linux.ibm.com>
Message-ID: <79e2975b-bc19-27fb-a11c-90145ea07e02@linux.ibm.com>
Date: Mon, 30 Aug 2021 18:57:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <6123dd27bfaa10641c45d0477516e068bc7c8ecb.camel@suse.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mvHAZDUBJ770X3NMjYVOZD3EmZdJVBkY
X-Proofpoint-ORIG-GUID: mvHAZDUBJ770X3NMjYVOZD3EmZdJVBkY
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.790
	definitions=2021-08-30_05:2021-08-30,
	2021-08-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	suspectscore=0 phishscore=0
	lowpriorityscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
	priorityscore=1501 spamscore=0 adultscore=0 mlxscore=0 clxscore=1011
	bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108300113
X-MIME-Autoconverted: from 8bit to quoted-printable by
	mx0a-001b2d01.pphosted.com id 17UGrx15151124
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17UGw3LJ017140
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 31 Aug 2021 03:25:15 -0400
Cc: Benjamin Block <bblock@linux.ibm.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: update no_path_retry value
 for IBM/2145
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"

On 8/26/21 8:47 AM, Martin Wilck wrote:
> On Thu, 2021-08-26 at 00:24 +0200, Xose Vazquez Perez wrote:
>> Based on current configs:
>> https://www.ibm.com/docs/en/flashsystem-9x00/8.4.x?topic=3Dsystem-settin=
gs-linux-hosts
>>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Benjamin Marzinski <bmarzins@redhat.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: DM-DEVEL ML <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>  =A0libmultipath/hwtable.c | 2 +-
>>  =A01 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>> index 2a896440..58554cbb 100644
>> --- a/libmultipath/hwtable.c
>> +++ b/libmultipath/hwtable.c
>> @@ -662,7 +662,7 @@ static struct hwentry default_hw[] =3D {
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Storwize family / SA=
N Volume Controller / Flex
>> System V7000 / FlashSystem V840/V9000/9100 */
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=
=A0=A0 =3D "IBM",
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D "^2145",
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.no_path_retry =3D NO_PATH=
_RETRY_QUEUE,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.no_path_retry =3D 5,
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=
=A0 =3D GROUP_BY_PRIO,
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgfailback=A0=A0=A0 =
=3D -FAILBACK_IMMEDIATE,
>>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.prio_name=A0=A0=A0=A0 =
=3D PRIO_ALUA,
>=20
> Ref: https://github.com/opensvc/multipath-tools/issues/6
>=20
> The question is on which basis IBM came up with this recommendation.
> 5 (aka 25s) is a rather low value. Some users may encounter unpleasant
> surprises if we change the default this way, as it used to be infinite
> before.
>=20
> Using 5, the IBS 2145 would have the 2nd-lowest default in hwtable.c
> after Dell PowerStore (3). Symmetrix has 6; all other arrays default to
> 10 or higher, many default to "queue".
>=20
> Observing that the above is the documentation for the *Flashsystem*
> 9200,  I consider it likely that the value ".no_path_retry =3D 5" would
> apply to flash-based IBM storage products, but not to the older
> products such as the V7000, which unfortunately use the same device ID.
>=20
> It'd be helpful if someone from IBM could jump in here...
>=20
> Pondering the pros and cons, I vote for keeping the current defaults
> for now.

+1

I think this depends on host and workload requirements and maybe other thin=
gs.=20
There might not be one simple answer.

FWIW, from a zfcp point of view:=20
https://public.dhe.ibm.com/software/dw/linux390/lvc/zFCP_Best_Practices-BB-=
Webcast_201805.pdf#page=3D19
Distributed/parallel file systems with shared volumes might have their own=
=20
requirement.
YMMV

We also have our opinion on dev_loss_tmo and fast_io_fail_tmo, but that's a=
=20
different story=20
[https://public.dhe.ibm.com/software/dw/linux390/lvc/zFCP_Best_Practices-BB=
-Webcast_201805.pdf#page=3D18].

--=20
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

