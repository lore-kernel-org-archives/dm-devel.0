From: Chris Penney <penney@msu.edu>
Subject: STK / LSI Multipath Support
Date: Thu, 12 Jan 2006 22:52:41 -0500
Message-ID: <111aefd0601121952r55594f0ahdb5ed4fa46ae145d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0290793502=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============0290793502==
Content-Type: multipart/alternative;
	boundary="----=_Part_26782_10849997.1137124361892"

------=_Part_26782_10849997.1137124361892
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

The multipath code seems to support STK D280 (active / passive) disk arrays=
,
but with one exception.  It doesn't seem to be able to query the priorities
of the luns properly.  For example, I create four luns on a D280 and assign
two luns to controller A and two to controller B.  When the system (which
has dual hbas) boots they all end up on one controller and multipathd never
switches to the primary paths even though they are available.

I am guessing this is because "prio_callout" is set to "/bin/true" so it
defaults to the first path in the list.  Is there a prio_callout that works
with lsi branded arrays?  I run SLES 9 and I see there are
mpath_prio_{emc,tpc,alua}, but none (somewhat obviously) don't work.  I was
able to write a perl script that simply took a device arguement and looked
up a priority in a table and it appears to work, but it's obviously a nasty
hack and doesn't automatically detect the proper path (which would be
necessary in the case of a manual failover).

Thanks,

   Chris Penney
   penney@msu.edu

------=_Part_26782_10849997.1137124361892
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,<br><br>The multipath code seems to support STK D280 (active / passiv=
e) disk arrays, but with one exception.&nbsp; It doesn't seem to be able to=
 query the priorities of the luns properly.&nbsp; For example, I create fou=
r luns on a D280 and assign two luns to controller A and two to controller =
B.&nbsp; When the system (which has dual hbas) boots they all end up on one=
 controller and multipathd never switches to the primary paths even though =
they are available.
<br><br>I am guessing this is because &quot;prio_callout&quot; is set to &q=
uot;/bin/true&quot; so it defaults to the first path in the list.&nbsp; Is =
there a prio_callout that works with lsi branded arrays?&nbsp; I run SLES 9=
 and I see there are mpath_prio_{emc,tpc,alua}, but none (somewhat obviousl=
y) don't work.&nbsp; I was able to write a perl script that simply took a d=
evice arguement and looked up a priority in a table and it appears to work,=
 but it's obviously a nasty hack and doesn't automatically detect the prope=
r path (which would be necessary in the case of a manual failover).
<br><br>Thanks,<br><br>&nbsp;&nbsp; Chris Penney<br>&nbsp;&nbsp; <a href=3D=
"mailto:penney@msu.edu">penney@msu.edu</a><br><br><br>

------=_Part_26782_10849997.1137124361892--


--===============0290793502==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0290793502==--
