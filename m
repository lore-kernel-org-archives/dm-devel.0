From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: how to change/query  current path_checker
Date: Mon, 26 Nov 2007 15:21:46 -0500
Message-ID: <1D80D4F6D179BD4D869FE807A5BF8336018C6A0C@EXCNYSM0A1AN.nysemail.nyenet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

Running SLES9 and multipath-tools-0.4.5-0.28.

I want to change path_checker from tur to readsector0 and have updated
my multipath.conf file to specify readsector0.

1) Will /sbin/multipathd -k"reconfigure" make multipathd re-read the
multipath.conf and start using readsector0?
(man page for multipathd is very skimpy at this level.)

2) Is there a way to display which path_checker is actually being used?
multipath -v3 seems to report the current contents of multipath.conf for
path_checker and not what path_checker it's using: it reports whatever I
just set path_checker to in the file.
--------------------------------------------------------
This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.
