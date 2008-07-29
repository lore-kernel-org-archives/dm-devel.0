From: "Daniel Keisling" <daniel.keisling@austin.ppdi.com>
Subject: RE: multipathd sometimes not reinstating paths
Date: Tue, 29 Jul 2008 09:40:04 -0500
Message-ID: <65F9ACC78BD8304BAAEB817634C62D4C0617C8FD@AUSMAIL01.americas.ppdi.local>
References: <200807291435.57935.tore@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <200807291435.57935.tore@linpro.no>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


I have tested failing paths by removing SAN controllers from the
specific zone in my switch config.

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Tore Anderson
Sent: Tuesday, July 29, 2008 7:36 AM
To: dm-devel@redhat.com
Subject: [dm-devel] multipathd sometimes not reinstating paths

Hello,

I've on several occasions seen that multipathd fails to reinstate paths=20
that has recovered.  Yesterday I had a controller meltdown on an array,=20
and several hosts ended up stuck in a all-paths-down state, which a=20
simple restart of multipathd fixed.  It's as if multipathd at some=20
point stopped to check dead paths for revival.  The hosts were running=20
0.4.7 and 0.4.5 (RHEL4/5 and Debian 4.0).

Since getting things back on line was the priority I didn't get around=20
to debugging it, unfortunately.  I've seen this before many times,=20
though, so I'm wondering if anybody else has seen this and know what=20
causes it?  Is there any known workarounds or ways to avoid it?

Any suggestions on how to debug it if I see it happen again?

Regards,
--=20
Tore Anderson

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


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
