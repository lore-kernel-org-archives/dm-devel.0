From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: RE: /dev/dm-? and /dev/mapper/
Date: Wed, 30 Jul 2008 14:47:36 -0400
Message-ID: <1D80D4F6D179BD4D869FE807A5BF833602D8B6B0@EXCNYSM0A1AN.nysemail.nyenet>
References: <200807300844.11578.wilhelm.meier@fh-kl.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Class: urn:content-classes:message
In-Reply-To: <200807300844.11578.wilhelm.meier@fh-kl.de>
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

device-mapper creates the /dev/dm-? names, I doubt you could get rid of
them.
LVM names are persistent, maybe instead of mount-by-label you could
change to mount the persistent /dev/VGname/LVname's



--------------------------------------------------------
This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.


-----Original Message-----

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Wilhelm Meier
Sent: Wednesday, July 30, 2008 2:44 AM
To: dm-devel@redhat.com
Subject: [dm-devel] /dev/dm-? and /dev/mapper/

Hi,

I don't know if this is the right place to ask ...

I use kernel 2.6.22 and debian etch.

If I create a vg and some volumes in it I get the

/dev/dm-?

and

/dev/mapper/<vg>-<lv>

devices nodes.

If I try to mount the filesystem via label, sometimes /dev/dm-? and=20
sometimes /dev/mapper/<vg>-<lv> gets mounted.

That is the cause of some later errors in my setup.

The question is: how can I get rid of the dm-? (e.g. they should not=20
be created at all) oder how do I the mount to stick to=20
the /dev/mapper/... files?

TIA,
--=20
Wilhelm

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
