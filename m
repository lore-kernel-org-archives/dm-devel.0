From: Markus Naeher <MNAEHER@de.ibm.com>
Subject: multipathd should interpret output from callouts like
	multipath does
Date: Tue, 10 Apr 2007 14:02:56 +0200
Message-ID: <OFA530E226.B7766DFC-ONC12572B9.0041C4BA-C12572B9.0042362A@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1807676950=="
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

This is a multipart message in MIME format.
--===============1807676950==
Content-Type: multipart/alternative;
	boundary="=_alternative 00423624C12572B9_="

This is a multipart message in MIME format.
--=_alternative 00423624C12572B9_=
Content-Type: text/plain; charset="US-ASCII"

Hi,

I have a setup with custom getuid and getprio callouts in the 
multipath.conf.
When running multipath, my dm tables are set up as expected:
All disks for which the output is an empty string are ignored.

It would be very helpful if the multipathd would also ignore these disks 
and neither
take them in it's list of monitored devices (they occur as [orphan] at the 
moment)
not add a default dm table for newly occuring devices.

I am using multipath-tools 0.4.7-34.3 on s390x (aka System Z).

Thanks and Regards,
Markus
--=_alternative 00423624C12572B9_=
Content-Type: text/html; charset="US-ASCII"


<br><font size=2 face="sans-serif">Hi,</font>
<br>
<br><font size=2 face="sans-serif">I have a setup with custom getuid and
getprio callouts in the multipath.conf.</font>
<br><font size=2 face="sans-serif">When running multipath, my dm tables
are set up as expected:</font>
<br><font size=2 face="sans-serif">All disks for which the output is an
empty string are ignored.</font>
<br>
<br><font size=2 face="sans-serif">It would be very helpful if the multipathd
would also ignore these disks and neither</font>
<br><font size=2 face="sans-serif">take them in it's list of monitored
devices (they occur as [orphan] at the moment)</font>
<br><font size=2 face="sans-serif">not add a default dm table for newly
occuring devices.</font>
<br>
<br><font size=2 face="sans-serif">I am using multipath-tools 0.4.7-34.3
on s390x (aka System Z).</font>
<br>
<br><font size=2 face="sans-serif">Thanks and Regards,</font>
<br><font size=2 face="sans-serif">Markus</font>
--=_alternative 00423624C12572B9_=--


--===============1807676950==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1807676950==--
