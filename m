From: Patrick Caulfield <pcaulfie@redhat.com>
Subject: Fwd: [Next problem with multipath-tools]
Date: Mon, 14 Feb 2005 14:50:26 +0000
Message-ID: <20050214145026.GB13778@tykepenguin.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline

 
-- 

patrick

--WhfpMioaduB5tiZL
Content-Type: message/rfc822
Content-Disposition: inline

Return-path: <Marek.Uher@t-mobile.cz>
Envelope-to: patrick@localhost
Delivery-date: Mon, 14 Feb 2005 14:47:08 +0000
Received: from fentible ([127.0.0.1] helo=localhost)
	by fentible.pjc.net with esmtp (Exim 4.44) id 1D0hVE-0004Ni-9Z
	for patrick@localhost; Mon, 14 Feb 2005 14:47:08 +0000
Received: from pop.ntlworld.com [62.253.162.50]
	by localhost with POP3 (fetchmail-6.2.5)
	for patrick@localhost (single-drop);
	Mon, 14 Feb 2005 14:47:08 +0000 (GMT)
Received: from aamta01-winn.mailhost.ntl.com ([212.250.162.8])
	by mta10-winn.mailhost.ntl.com with ESMTP id
	<20050214144704.MOBH20856.mta10-winn.mailhost.ntl.com@aamta01-winn.mailhost.ntl.com>
	for <tykepenguin@ntlworld.com>; Mon, 14 Feb 2005 14:47:04 +0000
Received: from master.debian.org ([146.82.138.7])
	by aamta01-winn.mailhost.ntl.com with ESMTP id
	<20050214144704.LBFP15415.aamta01-winn.mailhost.ntl.com@master.debian.org>
	for <tykepenguin@ntlworld.com>; Mon, 14 Feb 2005 14:47:04 +0000
Received: from mailhub1.t-mobile.cz [62.141.0.149]
	by master.debian.org with esmtp (Exim 3.35 1 (Debian))
	id 1D0hV7-0007cu-00; Mon, 14 Feb 2005 08:47:02 -0600
Received: from mailhub1 (localhost [127.0.0.1])
	by mailhub10027 (Postfix) with SMTP id 207942000147
	for <patrick@debian.org>; Mon, 14 Feb 2005 15:49:56 +0100 (CET)
Received: from rdmksp29.rdm.cz (unknown [10.247.141.226])
	by mailhub10025 (Postfix) with ESMTP id 08B842000093
	for <patrick@debian.org>; Mon, 14 Feb 2005 15:49:56 +0100 (CET)
Received: from rdmksp29.rdm.cz ([10.247.141.246]) by rdmksp29.rdm.cz with
	Microsoft SMTPSVC(5.0.2195.6713); Mon, 14 Feb 2005 15:47:00 +0100
Received: from SRVRE02.rdm.cz ([10.245.32.5]) by rdmksp29.rdm.cz with
	Microsoft SMTPSVC(5.0.2195.6713); Mon, 14 Feb 2005 15:46:59 +0100
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1441
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Subject: Next problem with multipath-tools
Date: Mon, 14 Feb 2005 15:47:01 +0100
Importance: normal
Priority: normal
Message-ID: <D18A13F01D850B409793C6C3FA5E0389012EEF24@SRVRE02.rdm.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Next problem with multipath-tools
Thread-Index: AcUSpAlDLH8ZL35qEdmtwwAMKUF1MA==
From: <Marek.Uher@t-mobile.cz>
To: <patrick@debian.org>
X-OriginalArrivalTime: 14 Feb 2005 14:46:59.0975 (UTC)
	FILETIME=[09E33970:01C512A4]
X-Spam-Checker-Version: SpamAssassin 3.0.2 (2004-11-16) on fentible.pjc.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.3 tests=AWL,BAYES_00,NO_REAL_NAME
	autolearn=no version=3.0.2


	Hello Patrick,

I installed the new version of libsysfs1 which fixed problem in location =
of=20
libsysfs in /lib (instead in /usr/lib). But I think that this bug fix =
didn't
solve problem with multipath-tools. After reboot multipathd is able to =
start
correctly when server is coming up. Unfortunately if /var is located on
separate volume and is mounted at startup sequence after multipathd =
start, the
new mounted file system will overlay directory structure (located in =
/var -
i.e. /var/run and /var/cache/multipathd) for multipathd and daemon will =
stay
nonfunctional. Multipathd is running but do nothing from this moment. It =
is
necessary to restart multipathd after mounting of /var file system. I =
have no
idea how to solve this problem (maybe it is necessary to modify =
multipathd to
store information elsewhere than in /var - i.e. somewhere on root =
partition or
in ram disk).

Regards,

Marek
 --
Ing. Marek Uher
Linux System Specialist
Technology Division
T-Mobile Czech Republic a.s.
Tomickova 2144/1
149 00 Praha 4
Czech Republic
Mobile:	(+420) 603 400 728
Office:	(+420) 603 607 128
Fax:		(+420) 603 600 796
E-mail:	marek.uher@t-mobile.cz
Web:		http://www.t-mobile.cz/
=20


---------- Disclaimer ----------
K tomuto e-mailu je p=F8ipojeno prohl=E1=B9en=ED, jeho=BE pln=E9 =
zn=ECn=ED je dostupn=E9 na adrese http://www.t-mobile.cz/disclaimer
A disclaimer is attached to this e-mail, the full version of which is =
available at http://www.t-mobile.cz/disclaimer



--WhfpMioaduB5tiZL
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--WhfpMioaduB5tiZL--
