From: TGrozev@mohegansun.com
Subject: Re: DS4000 with multipath-tools 0.4.5
Date: Fri, 12 Jan 2007 16:57:18 -0500
Message-ID: <OF396F7E56.FA311C77-ON85257261.00787002-85257261.00789A54@mohegansun.com>
References: <20070112210148.GA7441@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1636692862=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070112210148.GA7441@ether.msp.redhat.com>
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

This is a multipart message in MIME format.
--===============1636692862==
Content-Type: multipart/alternative;
	boundary="=_alternative 00789A5385257261_="

This is a multipart message in MIME format.
--=_alternative 00789A5385257261_=
Content-Type: text/plain;
	charset="US-ASCII"

I compiled it, and it's working good. The only thing is, when I query the 
priority of a drive, I'm getting "Auto-volume Transfer not enabled":

---
# ./mpath_prio_tpc /dev/sdc
Auto-volume Transfer not enabled6

# ./mpath_prio_tpc /dev/sdd
Auto-volume Transfer not enabled1
---

I seem to be getting 6 for my preferred path and 1 for standby, which is 
good. Is AVT required, or can I still use mpath_prio_tcp?
I have multiple nodes of a Linux Cluster accessing the LUNs, so AVT has to 
be disabled.

Tenyo
**************************************************************************************************
The information contained in this message may be privileged and confidential and 
protected from disclosure. If the reader of this message is not the intended recipient, or 
an employee or agent responsible for delivering this message to the intended recipient, 
you are hereby notified that any dissemination, distribution, or copy of this 
communication is strictly prohibited. If you have received this communication in error, 
please notify us immediately by replying to the message and deleting it from your 
computer.
**************************************************************************************************
--=_alternative 00789A5385257261_=
Content-Type: text/html;
	charset="US-ASCII"


<br><font size=2 face="sans-serif">I compiled it, and it's working good.
The only thing is, when I query the priority of a drive, I'm getting &quot;Auto-volume
Transfer not enabled&quot;:</font>
<br>
<br><font size=2 face="sans-serif">---</font>
<br><font size=2 face="sans-serif"># ./mpath_prio_tpc /dev/sdc</font>
<br><font size=2 face="sans-serif">Auto-volume Transfer not enabled6</font>
<br>
<br><font size=2 face="sans-serif"># ./mpath_prio_tpc /dev/sdd</font>
<br><font size=2 face="sans-serif">Auto-volume Transfer not enabled1</font>
<br><font size=2 face="sans-serif">---</font>
<br>
<br><font size=2 face="sans-serif">I seem to be getting 6 for my preferred
path and 1 for standby, which is good. Is AVT required, or can I still
use mpath_prio_tcp?</font>
<br><font size=2 face="sans-serif">I have multiple nodes of a Linux Cluster
accessing the LUNs, so AVT has to be disabled.</font>
<br>
<br><font size=2 face="sans-serif">Tenyo</font>
**************************************************************************************************
The information contained in this message may be privileged and confidential and 
protected from disclosure. If the reader of this message is not the intended recipient, or 
an employee or agent responsible for delivering this message to the intended recipient, 
you are hereby notified that any dissemination, distribution, or copy of this 
communication is strictly prohibited. If you have received this communication in error, 
please notify us immediately by replying to the message and deleting it from your 
computer.
**************************************************************************************************
--=_alternative 00789A5385257261_=--


--===============1636692862==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1636692862==--
