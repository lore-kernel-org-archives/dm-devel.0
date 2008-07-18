From: "Daniel Keisling" <daniel.keisling@austin.ppdi.com>
Subject: Temporarily squelching multipathd errors
Date: Fri, 18 Jul 2008 13:48:01 -0500
Message-ID: <65F9ACC78BD8304BAAEB817634C62D4C0607FA9E@AUSMAIL01.americas.ppdi.local>
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

Greetings,
=20
I perform SAN-based snapshots on OCFS2 and ext3 filesystems under
dm-multipath.  Before I snapshot the filesystem, I unmount and delete
the previous night's snapshot LUNs.  Doing so causes (correctly)
multipathd to output the following errors:
=20
<snip>
...
Jul 14 03:16:02 ausracdbd01 multipathd: mpath19: remaining active paths:
7
Jul 14 03:16:02 ausracdbd01 multipathd: sdci: tur checker reports path
is down
Jul 14 03:16:02 ausracdbd01 kernel: device-mapper: multipath: Failing
path 69:80.
Jul 14 03:16:02 ausracdbd01 multipathd: sdco: tur checker reports path
is down
....
</snip>
=20
During this snapshot time, I would like to temporarily turn off the
verbosity of multipathd.  Is this possible?  It's mostly an annoyance
factor for me because our nightly centralized syslog scan picks up words
like 'fail' and generates a report to the system administrators (which
we then have to ignore for these messages).
=20
TIA,

Daniel
=20

______________________________________________________________________
This email transmission and any documents, files or previous email
messages attached to it may contain information that is confidential or
legally privileged. If you are not the intended recipient or a person
responsible for delivering this transmission to the intended recipient,
you are hereby notified that you must not read this transmission and
that any disclosure, copying, printing, distribution or use of this
transmission is strictly prohibited. If you have received this transmissi=
on
in error, please immediately notify the sender by telephone or return ema=
il
and delete the original transmission and its attachments without reading
or saving in any manner.
