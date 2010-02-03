From: "Mey, Georg" <Georg.Mey@netapp.com>
Subject: DMMP and UDEV issue on SLES10 SP2 (64bit)
Date: Wed, 3 Feb 2010 16:59:46 -0000
Message-ID: <1CD9B7FF2BF5674E85D505154465DAF609DDF143@LDCMVEXC1-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi all,

does anybody ahev seen this issue:

When adding new disks in an envrionment with device mapper mulitpathing con=
figured =

properly, new disks do show up and multipath -ll does show the correct prio=
rity
groups. Along with all the new DM devices created in =

- /dev/disk/by-id
- /dev/disk/by-name
- /dev/disk/by-uuid
- /dev/mapper
we do expect to get entries like /dev/dm-[0-9][0-9]* - but this does not ha=
ppen.
Unfortunately some NetApp provisioning software needs these entries.

Any ideas?

The system(s) are SLES10 SP2 (no additional patches applied yet)

Kind regards

Georg

 =

___________________________________________________________________________=
____________
Georg Mey
Solutions Architect
NetApp
Wankelstrasse 3
D-70563 Stuttgart

+49 (0) 711-686880-65 Tel
+49 (0) 711-686880-99 Fax
+49 (0) 151-12055-928 Mobil
Georg.Mey@netapp.com
www.netapp.de





Diese e-Mail kann vertrauliche und/oder rechtlich gesch=FCtzte Informatione=
n enthalten. Wenn Sie nicht der richtige Adressat sind =

oder diese e-Mail irrt=FCmlich erhalten haben, informieren Sie bitte sofort=
 den Absender und vernichten Sie diese e-Mail. Das unerlaubte =

Kopieren sowie die unbefugte Weitergabe dieser e-Mail und ihrer Inhalte ist=
 nicht gestattet.
This e-mail may contain confidential and/or privileged information. If you =
are not the intended addressee or have received this e-mail
in error, please notify the sender immediately and destroy this e-mail. Any=
 unauthorized copying, disclosure or distribution of the =

material in this e-mail is strictly forbidden.
NetApp Deutschland GmbH, Bretonischer Ring 6, 85630 Grasbrunn, =

Handelsregister: AG M=FCnchen HRB113907, Gesch=E4ftsf=FChrer: Manfred Reitn=
er
 =
