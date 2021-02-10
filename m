Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981C1C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:38:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 09C6064D9F
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:38:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09C6064D9F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-7FRP4ST9PLaR2E6sXRmoPw-1; Wed, 17 Feb 2021 10:38:50 -0500
X-MC-Unique: 7FRP4ST9PLaR2E6sXRmoPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CB60192D785;
	Wed, 17 Feb 2021 15:38:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EA525D9D2;
	Wed, 17 Feb 2021 15:38:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4DC6418095CB;
	Wed, 17 Feb 2021 15:38:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11AI9kuT027104 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 13:09:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D9C0310F8E04; Wed, 10 Feb 2021 18:09:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3D9710F8E01
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 18:09:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 613D58115B1
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 18:09:44 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-423-cTXds5sHMYKNi-juCGkanA-1; Wed, 10 Feb 2021 13:09:39 -0500
X-MC-Unique: cTXds5sHMYKNi-juCGkanA-1
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	11AI7cxQ084687; Wed, 10 Feb 2021 13:09:37 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 36mkpj9maq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 10 Feb 2021 13:09:37 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11AI81lb086848;
	Wed, 10 Feb 2021 13:09:37 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 36mkpj9m9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 10 Feb 2021 13:09:37 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	11AI6nZP028431; Wed, 10 Feb 2021 18:09:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com
	(d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma03ams.nl.ibm.com with ESMTP id 36m1m2s71v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 10 Feb 2021 18:09:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com
	(b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 11AI9WLI65798536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Wed, 10 Feb 2021 18:09:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A4ADDA405B;
	Wed, 10 Feb 2021 18:09:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FE07A4054;
	Wed, 10 Feb 2021 18:09:32 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.50.245])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
	Wed, 10 Feb 2021 18:09:32 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
	(envelope-from <bblock@linux.ibm.com>)
	id 1l9tvg-002EQE-0a; Wed, 10 Feb 2021 19:09:32 +0100
Date: Wed, 10 Feb 2021 19:09:31 +0100
From: Benjamin Block <bblock@linux.ibm.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <YCQhW4uHx4j+xXmL@t480-pf1aa2c2.linux.ibm.com>
References: <1612847967-8813-1-git-send-email-bmarzins@redhat.com>
	<1612847967-8813-3-git-send-email-bmarzins@redhat.com>
	<e8131e361f84ef1caee140183a26c9f60b172f24.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <e8131e361f84ef1caee140183a26c9f60b172f24.camel@suse.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369, 18.0.737
	definitions=2021-02-10_06:2021-02-10,
	2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	phishscore=0 impostorscore=0
	mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 clxscore=1011
	bulkscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102100161
X-MIME-Autoconverted: from 8bit to quoted-printable by
	mx0a-001b2d01.pphosted.com id 11AI7cxQ084687
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11AI9kuT027104
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:30:42 -0500
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>
Subject: Re: [dm-devel] [PATCH 2/2] multipathd: add recheck_wwid_time option
 to verify the path wwid
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 10:19:45PM +0000, Martin Wilck wrote:
> On Mon, 2021-02-08 at 23:19 -0600, Benjamin Marzinski wrote:
> > There are cases where the wwid of a path changes due to LUN remapping
> > without triggering uevent for the changed path. Multipathd has no
> > method
> > for trying to catch these cases, and corruption has resulted because
> > of
> > it.
> >=20
> > In order to have a better chance at catching these cases, multipath
> > now
> > has a recheck_wwid_time option, which can either be set to "off" or a
> > number of seconds. If a path is failed for equal to or greater than
> > the
> > configured number of seconds, multipathd will recheck its wwid before
> > restoring it, when the path checker sees that it has come back up.
>=20
> Can't the WWID change also happen without the path going offline, or
> at least without being offline long enough that multipathd would
> notice?
>=20
> >  If
> > multipathd notices that a path's wwid has changed it will remove and
> > re-add the path, just like the existing wwid checking code for change
> > events does.=A0 In cases where the no uevent occurs, both the udev
> > database entry and sysfs will have the old wwid, so the only way to
> > get
> > a current wwid is to ask the device directly.=A0
>=20
> sysfs is wrong too, really? In that case I fear triggering an uevent
> won't fix the situation. You need to force the kernel to rescan the
> device, otherwise udev will fetch the WWID from sysfs again, which
> still has the wrong ID... or what am I missing here?
>=20
> > > Currently multipath only
> > has code to directly get the wwid for scsi devices, so this option
> > only
> > effects scsi devices. Also, since it's possible the the udev wwid
> > won't
> > match the wwid from get_vpd_sgio(), if multipathd doesn't initially
> > see
> > the two values matching for a device, it will disable this option for
> > that device.
> >=20
> > If recheck_wwid_time is not turned off, multipathd will also
> > automatically recheck the wwid whenever an existing path gets a add
> > event, or is manually re-added with cli_add_path().
> >=20
> > Co-developed-by: Chongyun Wu <wucy11@chinatelecom.cn>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> I am uncertain about this.
>=20
> We get one more configuration option that defaults to off and that only
> the truly inaugurated will understand and use. And even those will not
> know how to set the recheck time. Should it be 1s, 10, or 100? We
> already have too many of these options in multipath-tools. We shy away
> from giving users reasonable defaults, with the result that most people
> won't bother.
>=20
> I generally don't understand what the UP/DOWN state has to do with
> this. If the WWID can change without any events seen by either the
> kernel or user space, why would the path go down and up again? And even
> if so, why would it matter how long the device remained down?
>=20
> But foremost, do we really have to try to deal with configuration
> mistakes as blatant as this? What if a user sets the same WWID for
> different devices, or re-uses the same WWID on different storage
> servers? I already hesitated about the code I added myself for catching
> user errors in the WWIDs file, but this seems even more far-fetched.
>=20
> Please convince me.
>=20
> This said, I'd like to understand why there are no events in these
> cases. I'd have thought we'd at least get a UNIT ATTENTION (REPORTED
> LUNS DATA HAS CHANGED), which would have caused a uevent.=A0If there was
> no UNIT ATTENTION, I'd blame the storage side.=A0

Yeah, just for reference, I saw this happening in practice when
something with the LU mapping changed on IBM storage - IIRC I saw it
with capacity changes. You end up in this code in the kernel:
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/drivers/scsi/scsi_error.c?id=3D92bf22614b21a2706f4993b278017e437f7785b3#n4=
16

And from there you ought to get an uevent for the sdev.

The WWID in sysfs might still be wrong though AFAIK. The kernel seems to
ignore the UA after it delivered the uevent.

>=20
> Maybe we need to monitor scsi_device uevents.
>=20
> Technical remarks below.
>=20
>=20

--=20
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Sys=
tems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/pri=
vacy
Vorsitz. AufsR.: Gregor Pillen         /        Gesch=E4ftsf=FChrung: Dirk =
Wittkopp
Sitz der Gesellschaft: B=F6blingen / Registergericht: AmtsG Stuttgart, HRB =
243294


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

