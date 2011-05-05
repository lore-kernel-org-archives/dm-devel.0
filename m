From: Christian May <christian_may@de.ibm.com>
Subject: RHEL 6 I/O error messages during booting
Date: Thu, 5 May 2011 12:58:06 +0200
Message-ID: <OF01186CE2.F2A5FC34-ONC1257887.00332068-C1257887.003C3C98@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7630194456985982138=="
Return-path: <dm-devel-bounces@redhat.com>
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

This is a multipart message in MIME format.
--===============7630194456985982138==
Content-Type: multipart/alternative;
	boundary="=_alternative 003C3A82C1257887_="

This is a multipart message in MIME format.
--=_alternative 003C3A82C1257887_=
Content-Type: text/plain; charset="US-ASCII"

Hi,

I'm new to this community so maybe my question is alreayd answered/solved. 
In that case please let me know how...

I have several IBM blades running RHEL6 and RHEL 6.1 attached via FC 
switch to different FastT storage servers (prefered/non-prefered pathes).
During booting  I've noticed billions of I/O error messages which extend 
the boot process. I found that the scsi_dh_rdac
driver is build into the initramfs, so it should be available when the 
system is recognizing the SCSI LUNs. When taking a look to the messages
I found this statement "kernel: rdac: device handler registered" after the 
SCSI LUNs were recognized?!

Any ideas?

Regards,

Christian
 
--=_alternative 003C3A82C1257887_=
Content-Type: text/html; charset="US-ASCII"

<font size=2 face="sans-serif">Hi,</font>
<br>
<br><font size=2 face="sans-serif">I'm new to this community so maybe my
question is alreayd answered/solved. In that case please let me know how...</font>
<br>
<br><font size=2 face="sans-serif">I have several IBM blades running RHEL6
and RHEL 6.1 attached via FC switch to different FastT storage servers
(prefered/non-prefered pathes).</font>
<br><font size=2 face="sans-serif">During booting &nbsp;I've noticed billions
of I/O error messages which extend the boot process. I found that the scsi_dh_rdac</font>
<br><font size=2 face="sans-serif">driver is build into the initramfs,
so it should be available when the system is recognizing the SCSI LUNs.
When taking a look to the messages</font>
<br><font size=2 face="sans-serif">I found this statement &quot;kernel:
rdac: device handler registered&quot; after the SCSI LUNs were recognized?!</font>
<br>
<br><font size=2 face="sans-serif">Any ideas?</font>
<br>
<br><font size=2 face="sans-serif">Regards,</font>
<br>
<br><font size=2 face="sans-serif">Christian</font>
<p><font size=3>&nbsp;</font>
--=_alternative 003C3A82C1257887_=--

--===============7630194456985982138==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7630194456985982138==--
