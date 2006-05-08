From: Shyam Sundar <g.shyamsundar@yahoo.co.in>
Subject: multipath table for MSA-1000
Date: Mon, 8 May 2006 22:43:19 +0100 (BST)
Message-ID: <20060508214319.6871.qmail@web8510.mail.in.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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

I have a single port qla2342 initiator connected to a
MSA-1000 through a Switch.
The two ports of the MSA 1000 are connected to the
switch exposing 2 paths to the target LUNs.=20
When I display the topology using

multipath -ll

i get the output as follows:
3600805................
[size=3D9GB][features=3D1 queue_if_no_path][hwhandler=3D0]
\_round-robin 0 [prio=3D1][active]
 \_ 17:0:0:3 sda 8:0 [failed][faulty]
 \_ 17:0:1:3 sdi  8:128[active][ready]
3600805................
..............................
..............................


Is it normal for a MSA1000 target to have a "faulty"
and a "ready" path. If yes, what does "faulty" signify
?=20
Under what condition does the faulty path become
ready?

Thanks in advance.
Shyam
 =20


	=09
____________________________________________________=20
Yahoo! India Answers: Share what you know. Learn something new. http://in=
.answers.yahoo.com
