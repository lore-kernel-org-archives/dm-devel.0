From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: understanding of multipathing and speed
Date: Tue, 06 Jul 2010 09:21:51 +0200
Message-ID: <1278400911.26770.5.camel@Nokia-N900-42-11>
References: <201007052037.39362.bart.coninckx@telenet.be>
	<1278356310.30539.606.camel@localhost>
	<201007060616.55657.bart.coninckx@telenet.be>
Reply-To: Christophe Varoqui <christophe.varoqui@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5349582093554747276=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201007060616.55657.bart.coninckx@telenet.be>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Coninckx <bart.coninckx@telenet.be>, dm-devel@redhat.com, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids


--===============5349582093554747276==
Content-Type: multipart/alternative; boundary="=-H55F5b5IjHdKDU/g3EZN"


--=-H55F5b5IjHdKDU/g3EZN
Content-Type: text/plain; charset=utf-8
Content-ID: <1278400909.26770.2.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx01.colomx.prod.int.phx2.redhat.com id o667MDQh012489

(1494554000000000000000000010000000200000002000000) dm-1
> IET,VIRTUAL-DISK [size=3D40G][features=3D1 queue_if_no_path][hwhandler=3D=
0]
> \_ round-robin 0 [prio=3D-2][active]
>=C2=A0  \_ 1:0:0:2 sdf 8:80=C2=A0  [active][undef]
>=C2=A0  \_ 2:0:0:2 sdg 8:96=C2=A0  [active][undef]
>=20
> I have two Gigabit NICs in this server each running over a separate
> switch to=C2=A0  a separate gigabit NIC with a unique IP address on the
> storage IET iSCSI=C2=A0  target.
>=20
did you setup different ip networks for each independant lan ? You may wa=
nt to verify the ip routing is not sending every other packet through the=
 wrong interface ?

Bye
--=-H55F5b5IjHdKDU/g3EZN
Content-Type: text/html; charset=utf-8
Content-ID: <1278400909.26770.4.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="generator" content="Osso Notes">
    <title></title></head>
<body>
<p>(1494554000000000000000000010000000200000002000000) dm-1
<br>&gt; IET,VIRTUAL-DISK [size=40G][features=1 queue_if_no_path][hwhandler=0]
<br>&gt; \_ round-robin 0 [prio=-2][active]
<br>&gt;&nbsp; &#32;\_ 1:0:0:2 sdf 8:80&nbsp; &#32;[active][undef]
<br>&gt;&nbsp; &#32;\_ 2:0:0:2 sdg 8:96&nbsp; &#32;[active][undef]
<br>&gt; 
<br>&gt; I have two Gigabit NICs in this server each running over a separate
<br>&gt; switch to&nbsp; &#32;a separate gigabit NIC with a unique IP address on the
<br>&gt; storage IET iSCSI&nbsp; &#32;target.
<br>&gt; 
<br>did you setup different ip networks for each independant lan ? You may want to verify the ip routing is not sending every other packet through the wrong interface ?
<br>
<br>Bye</p>
</body>
</html>

--=-H55F5b5IjHdKDU/g3EZN--


--===============5349582093554747276==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============5349582093554747276==--
