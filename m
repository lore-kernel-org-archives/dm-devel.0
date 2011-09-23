From: Gmail <christophe.varoqui@gmail.com>
Subject: Re: [RESEND][PATCH] multipath: don't set
	queue_if_no_path without	multipathd
Date: Fri, 23 Sep 2011 18:01:44 +0200
Message-ID: <1316793704.5068.6.camel@Nokia-N900-42-11>
References: <20110923044158.GP24133@ether.msp.redhat.com>
	<1316757172.1850.4.camel@lapoo.opensvc.com>
	<20110923145833.GS24133@ether.msp.redhat.com>
Reply-To: Gmail <christophe.varoqui@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6324030472515909970=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110923145833.GS24133@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============6324030472515909970==
Content-Type: multipart/alternative; boundary="=-Ghseru8ycz7O6N3v6SOR"


--=-Ghseru8ycz7O6N3v6SOR
Content-Type: text/plain; charset=utf-8
Content-ID: <1316793703.5068.3.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx3-phx2.redhat.com id p8NG83Tw029214

> > May we could also reverse the -q meaning ... making multipath default
> > behaviour to not honor queueing by default when multipathd is not
> > running. As you said, multipathd starting will update the maps.
>=20
> I'm confused.=C2=A0  In the patch I sent, by default, multipath will no=
t set
> the device to queuing if multipathd isn't running.=C2=A0  If you want
> multipath to honor the configured queueing setting when multipathd is
> not running, you need to use the -q option.=C2=A0  Isn't that what you'=
re
> asking for?
>
It is. I misread the patch. Sorry.

cvaroqui

--=-Ghseru8ycz7O6N3v6SOR
Content-Type: text/html; charset=utf-8
Content-ID: <1316793703.5068.5.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="generator" content="Osso Notes">
    <title></title></head>
<body>
<p>&gt; &gt; May we could also reverse the -q meaning ... making multipath default
<br>&gt; &gt; behaviour to not honor queueing by default when multipathd is not
<br>&gt; &gt; running. As you said, multipathd starting will update the maps.
<br>&gt; 
<br>&gt; I'm confused.&nbsp; &#32;In the patch I sent, by default, multipath will not set
<br>&gt; the device to queuing if multipathd isn't running.&nbsp; &#32;If you want
<br>&gt; multipath to honor the configured queueing setting when multipathd is
<br>&gt; not running, you need to use the -q option.&nbsp; &#32;Isn't that what you're
<br>&gt; asking for?
<br>&gt;
<br>It is. I misread the patch. Sorry.
<br>
<br>cvaroqui<br></p>
</body>
</html>

--=-Ghseru8ycz7O6N3v6SOR--


--===============6324030472515909970==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============6324030472515909970==--
