From: TGrozev@mohegansun.com
Subject: DS4000 with multipath-tools 0.4.5
Date: Thu, 11 Jan 2007 09:28:07 -0500
Message-ID: <OFFB7A5A44.FA4CC8A7-ON85257260.004E61B6-85257260.004F7AA6@mohegansun.com>
References: <20070111083430.GD11203@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0208105825=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070111083430.GD11203@kernel.dk>
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
--===============0208105825==
Content-Type: multipart/alternative;
	boundary="=_alternative 004F7AA185257260_="

This is a multipart message in MIME format.
--=_alternative 004F7AA185257260_=
Content-Type: text/plain;
	charset="US-ASCII"

Hi, all!

I've been trying to get dm-multipath working with an IBM DS4800 
(previously IBM FAStT) for some time now, and I'm still having some 
issues. The main problem is the lack of a suitable prioritizer. I've read 
that the recommended prioritizer for DS4000 is pp_tpc, which, however, 
appears in 0.4.7. I'm kinda stuck with 0.4.5, though, since I'm using 
RHEL4 (2.6.9) with RedHat Cluster.
Is there a way to use pp_tpc with 0.4.5? I'd really like to use 
dm-multipath instead of the IBM RDAC multipath.

Thanks much,
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
--=_alternative 004F7AA185257260_=
Content-Type: text/html;
	charset="US-ASCII"


<br><font size=2 face="sans-serif">Hi, all!</font>
<br>
<br><font size=2 face="sans-serif">I've been trying to get dm-multipath
working with an IBM DS4800 (previously IBM FAStT) for some time now, and
I'm still having some issues. The main problem is the lack of a suitable
prioritizer. I've read that the recommended prioritizer for DS4000 is pp_tpc,
which, however, appears in 0.4.7. I'm kinda stuck with 0.4.5, though, since
I'm using RHEL4 (2.6.9) with RedHat Cluster.</font>
<br><font size=2 face="sans-serif">Is there a way to use pp_tpc with 0.4.5?
I'd really like to use dm-multipath instead of the IBM RDAC multipath.</font>
<br>
<br><font size=2 face="sans-serif">Thanks much,</font>
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
--=_alternative 004F7AA185257260_=--


--===============0208105825==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0208105825==--
