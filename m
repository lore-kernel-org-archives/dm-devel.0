From: Kevin M Lange <kevin_m_lange@raytheon.com>
Subject: Re: multipath-tools support for SGI TP9700...
Date: Thu, 26 Jun 2008 00:49:18 -0400
Message-ID: <OF677BDEF1.5E2665CA-ON86257474.0014369D-85257474.001A7D70@mck.us.ray.com>
References: <1213307328.25460.34.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1198705291=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1213307328.25460.34.camel@plop>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multipart message in MIME format.
--===============1198705291==
Content-Type: multipart/related; boundary="=_related 001A7D6E85257474_="

This is a multipart message in MIME format.
--=_related 001A7D6E85257474_=
Content-Type: multipart/alternative;
	boundary="=_alternative 001A7D6E85257474_="


--=_alternative 001A7D6E85257474_=
Content-Type: text/plain; charset="US-ASCII"

Christophe,
Unfortunately it does not appear that the TP9700 is working using the 
multipath device settings you provided. 

Our configuration is such where the host (a Sun X4600 running RHEL 5.2) is 
connected to the TP9700 using two Fibrechannel connections:



No FC switches are used, just simple direct HBA to SP connectivity with 
two HBAs and two Storage Processors.  LUNs on the RAID are distributed to 
be owned by either SPA or SPB to distribute the workload between the SPs 
and the fibrechannel connections.

The TP9700 can be configured to present the storage to a host by setting 
the "Storage Array Host Type" (Linux, SGIRDAC, SGIAVT, Windows, etc).  For 
my tests, I've been experimenting with Linux and SGIRDAC.  I have been 
unsuccessful in determining what the storage array host type "Linux"s 
failover method is, but I thought I had come across an article that said 
the Linux type is basic AVT.  I could be mistaken.

Setting the TP9700 Host Type to "Linux" , I then setup /etc/multipath.conf 
to mimic the defaults for the TP9500:

       device {
               vendor                  "SGI"
               product                 "TP9[457]00"
               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
               features                "0"
               hardware_handler        "0"
               path_grouping_policy    group_by_prio
               failback                immediate
               rr_weight               uniform
               rr_min_io               1000
               path_checker            tur
       }

This configuration ran OK for a while, then began to log multipath 
failures, and eventually I/O buffer errors.  All LUNs on one SP trespassed 
to the other SP, and I had to manually place each trespassed LUN back to 
its primary path.

Changing the TP9700 host type to SGIRDAC, then trying the configuration 
you provided me caused the host to not see the ghost path.  Effectively I 
ended up with a single path.  Disconnecting a FC connection resulted in 
the inability to see any of the LUNs assigned to the associated SP.

I modified the multipath.conf a little:
        device {
                vendor "SGI"
                product "TP9700"
                path_grouping_policy failover
                getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
                features "1 queue_if_no_path"
                path_checker rdac
                prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
                hardware_handler "1 rdac"
                prio rdac
                failback immediate
        }
This worked ok, but I see lots of scsi sense key errors:

Jun 23 12:16:42 p4dbl03 kernel: sdbk: Current: sense key: Recovered Error
Jun 23 12:16:42 p4dbl03 kernel:     <<vendor>> ASC=0x95 ASCQ=0x1ASC=0x95 
ASCQ=0x1
Jun 23 12:16:42 p4dbl03 kernel:

I see those error regardless of how I configured the RAID and 
multipath.conf, which is worrisome.
I especially see those errors if I run 'fdisk -l'. 

Disconnecting a FC cable on one HBA caused the associated volumes to 
trespass to the other SP, however, during this process, I noticed buffer 
I/O errors.  Also, I noticed that the trespassed LUNs did not failback to 
their original SP when the FC cable was reconnected.  Am I to assume that 
RDAC or other multipath software will not tell the storage to failback 
trepassed LUNs?

Your assistance is appreciated,

- Kevin




--=_alternative 001A7D6E85257474_=
Content-Type: text/html; charset="US-ASCII"


<br><font size=3 color=#000080 face="sans-serif">Christophe,</font>
<br><font size=3 color=#000080 face="sans-serif">Unfortunately it does
not appear that the TP9700 is working using the multipath device settings
you provided. &nbsp;</font>
<br>
<br><font size=3 color=#000080 face="sans-serif">Our configuration is such
where the host (a Sun X4600 running RHEL 5.2) is connected to the TP9700
using two Fibrechannel connections:</font>
<br>
<br><img src=cid:_2_0A07001C02B0A068001A7D6E85257474>
<br>
<br><font size=3 color=#000080 face="sans-serif">No FC switches are used,
just simple direct HBA to SP connectivity with two HBAs and two Storage
Processors. &nbsp;LUNs on the RAID are distributed to be owned by either
SPA or SPB to distribute the workload between the SPs and the fibrechannel
connections.</font>
<br>
<br><font size=3 color=#000080 face="sans-serif">The TP9700 can be configured
to present the storage to a host by setting the &quot;Storage Array Host
Type&quot; (Linux, SGIRDAC, SGIAVT, Windows, etc). &nbsp;For my tests,
I've been experimenting with Linux and SGIRDAC. &nbsp;I have been unsuccessful
in determining what the storage array host type &quot;Linux&quot;s failover
method is, but I thought I had come across an article that said the Linux
type is basic AVT. &nbsp;I could be mistaken.</font>
<br>
<br><font size=3 color=#000080 face="sans-serif">Setting the TP9700 Host
Type to &quot;Linux&quot; , I then setup /etc/multipath.conf to mimic the
defaults for the TP9500:</font>
<br>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp;device {</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;vendor &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;&quot;SGI&quot;</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;product &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&quot;TP9[457]00&quot;</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;getuid_callout &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;/sbin/scsi_id
-g -u -s /block/%n&quot;</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;prio_callout &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;/sbin/mpath_prio_tpc
/dev/%n&quot;</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;features &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;&quot;0&quot;</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;hardware_handler &nbsp; &nbsp; &nbsp; &nbsp;&quot;0&quot;</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;path_grouping_policy &nbsp; &nbsp;group_by_prio</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;failback &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp;immediate</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;rr_weight &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
uniform</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;rr_min_io &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
1000</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp;path_checker &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;tur</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp;}</font></tt><font size=3 color=#000080 face="sans-serif"><br>
</font><font size=2 face="sans-serif"><br>
</font><font size=3 color=#000080 face="Tahoma">This configuration ran
OK for a while, then began to log multipath failures, and eventually I/O
buffer errors. &nbsp;All LUNs on one SP trespassed to the other SP, and
I had to manually place each trespassed LUN back to its primary path.</font>
<br>
<br><font size=3 color=#000080 face="Tahoma">Changing the TP9700 host type
to SGIRDAC, then trying the configuration you provided me caused the host
to not see the ghost path. &nbsp;Effectively I ended up with a single path.
&nbsp;Disconnecting a FC connection resulted in the inability to see any
of the LUNs assigned to the associated SP.</font>
<br>
<br><font size=3 color=#000080 face="Tahoma">I modified the multipath.conf
a little:</font>
<br><font size=3 color=#000080 face="Tahoma">&nbsp;</font><tt><font size=2 color=#000080>
&nbsp; &nbsp; &nbsp; device {</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; vendor &quot;SGI&quot;</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; product &quot;TP9700&quot;</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; path_grouping_policy failover</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; getuid_callout &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;/sbin/scsi_id
-g -u -s /block/%n&quot;</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; features &quot;1 queue_if_no_path&quot;</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; path_checker rdac</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; prio_callout &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;/sbin/mpath_prio_tpc
/dev/%n&quot;</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; hardware_handler &quot;1 rdac&quot;</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; prio rdac</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; failback immediate</font></tt>
<br><tt><font size=2 color=#000080>&nbsp; &nbsp; &nbsp; &nbsp; }</font></tt>
<br><tt><font size=2 color=#000080>This worked ok, but I see lots of scsi
sense key errors:</font></tt>
<br>
<br><tt><font size=2 color=#000080>Jun 23 12:16:42 p4dbl03 kernel: sdbk:
Current: sense key: Recovered Error</font></tt>
<br><tt><font size=2 color=#000080>Jun 23 12:16:42 p4dbl03 kernel: &nbsp;
&nbsp; &lt;&lt;vendor&gt;&gt; ASC=0x95 ASCQ=0x1ASC=0x95 ASCQ=0x1</font></tt>
<br><tt><font size=2 color=#000080>Jun 23 12:16:42 p4dbl03 kernel:</font></tt>
<br>
<br><tt><font size=2 color=#000080>I see those error regardless of how
I configured the RAID and multipath.conf, which is worrisome.</font></tt>
<br><tt><font size=2 color=#000080>I especially see those errors if I run
'fdisk -l'. &nbsp;</font></tt>
<br>
<br><tt><font size=2 color=#000080>Disconnecting a FC cable on one HBA
caused the associated volumes to trespass to the other SP, however, during
this process, I noticed buffer I/O errors. &nbsp;Also, I noticed that the
trespassed LUNs did not failback to their original SP when the FC cable
was reconnected. &nbsp;Am I to assume that RDAC or other multipath software
will not tell the storage to failback trepassed LUNs?</font></tt>
<br>
<br><tt><font size=2 color=#000080>Your assistance is appreciated,</font></tt>
<br>
<br><tt><font size=2 color=#000080>- Kevin</font></tt>
<br>
<br>
<br>
<br>
--=_alternative 001A7D6E85257474_=--

--=_related 001A7D6E85257474_=
Content-Type: image/jpeg
Content-ID: <_2_0A07001C02B0A068001A7D6E85257474>
Content-Transfer-Encoding: base64

/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0a
HBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIy
MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCADoAsQDASIA
AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD0Pwx4
W0LUvD1veXulWtxczNI0ksibmc+Y3JPetf8A4Qjwx/0ArH/v0KPBX/IpWP8A20/9GNW/XmTlLmep
Zgf8IR4Y/wCgFY/9+hR/whHhj/oBWP8A36Fb9FTzS7gYH/CEeGP+gFY/9+hR/wAIR4Y/6AVj/wB+
hW/RRzS7gYH/AAhHhj/oBWP/AH6FH/CEeGP+gFY/9+hW/RRzS7gYH/CEeGP+gFY/9+hR/wAIR4Y/
6AVj/wB+hW/RRzS7gYH/AAhHhj/oBWP/AH6FH/CEeGP+gFY/9+hW/RRzS7gYH/CEeGP+gFY/9+hR
/wAIR4Y/6AVj/wB+hW/RRzS7gYH/AAhHhj/oBWP/AH6FH/CEeGP+gFY/9+hW/RRzS7gYH/CEeGP+
gFY/9+hR/wAIR4Y/6AVj/wB+hW/RRzS7gYH/AAhHhj/oBWP/AH6FH/CEeGP+gFY/9+hW/RRzS7gY
H/CEeGP+gFY/9+hR/wAIR4Y/6AVj/wB+hW/RRzS7gYH/AAhHhj/oBWP/AH6FH/CEeGP+gFY/9+hW
/RRzS7gYH/CEeGP+gFY/9+hR/wAIR4Y/6AVj/wB+hW/RRzS7gcrY6Rp+jePrOLTbOK1jm0u5aRYh
tDlZYMEjvjcfzNdhXOS/8lC03/sFXf8A6Nt66OvQoO9NEvcKKKK1EFFFFABRRRQAUUUUAFFFFABR
RRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFF
FABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAc14K/5FKx/7af8A
oxq36wPBX/IpWP8A20/9GNW/XlT+JlhRRRUjCiiigAooooAKKKKACiiigAooooAKKKKACiiigAoo
ooAKKKKACiiigAooooAwpf8AkoWm/wDYKu//AEbb10dc5L/yULTf+wVd/wDo23ro69Gh/DRD3Cii
ithBRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUU
UAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQ
AUUUUAFFFFAHNeCv+RSsf+2n/oxq36wPBX/IpWP/AG0/9GNW/XlT+JlhRRRUjCiiigAooooAKKKK
ACiiigAooqrqGoQ6dbiWUM7MwSKKMZeVz0VR3P6AAk4AJoSvohBqGoQ6dbiWUM7MwSKKMZeVz0VR
3P6AAk4AJrNGi6zej7Rc+Ir7T5H5NrYx2zRxDsN0kLMx9TnBPQDpVzTdNm+0f2lqRV79lKoinKWy
H+BPU9NzdSR2AAGtXfSoKKvLcls57/hG9S/6HLXP+/Nl/wDI9H/CN6l/0OWuf9+bL/5HroajluIY
GiWWaONpX8uMOwBdsE7R6nAJx6A1r7OHZCuYX/CN6l/0OWuf9+bL/wCR6P8AhG9S/wChy1z/AL82
X/yPWlea3pOnBjfapZWoVxGxnuETDEbgpyeuOcenNSjUrA2SXovbY2shAScSrsYk7QA2cHJOB70e
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
--=_related 001A7D6E85257474_=--


--===============1198705291==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1198705291==--
