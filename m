From: "shahid shaikh" <shahid.shaikh@patni.com>
Subject: lvresize
Date: Wed, 9 Mar 2005 19:51:15 +0530
Message-ID: <008901c524b3$41aa8f90$11051aac@pcp41116>
Reply-To: shahid.shaikh@patni.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1110377777-13175-40"
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Dm-Devel (E-mail)" <dm-devel@redhat.com>
Cc: "Christophe Varoqui (E-mail)" <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

This is a multi-part message in MIME format...

------------=_1110377777-13175-40
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
   I used the lvresize command. it shows the changed size in lvs, lvscan =
and
lvdisplay but mounted filesystem doesnt show any change.
Is there something else i need to do to reflect changes in filesystem siz=
e
( i checked that through df command)?

I tried to use tune2fs also but it didnt worked. actually it gives erro o=
f
lexiacl type.

i have given the following command

"tune2fs /dev/vg01/lv01"

If any can help me in this i ll be greatful.

Thanks and Regards,
Shahid Shaikh.
Software Engineer.
Patni Computer Systems Ltd.
Vashi, Navi Mumbai.
Tel. 55910849/50/51 Extn. 344
Mobile : +91-9820986513
=93 There are no shortcuts to any place worth going. =94




http://www.patni.com
World-Wide Partnerships. World-Class Solutions.
_____________________________________________________________________

This e-mail message may contain proprietary, confidential or legally
privileged information for the sole use of the person or entity to
whom this message was originally addressed. Any review, e-transmission
dissemination or other use of or taking of any action in reliance upon
this information by persons or entities other than the intended
recipient is prohibited. If you have received this e-mail in error
kindly delete  this e-mail from your records. If it appears that this
mail has been forwarded to you without proper authority, please notify
us immediately at netadmin@patni.com and delete this mail.=20
_____________________________________________________________________

------------=_1110377777-13175-40
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------------=_1110377777-13175-40--
