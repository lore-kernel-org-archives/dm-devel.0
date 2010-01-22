From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: partitioning multipath device
Date: Fri, 22 Jan 2010 20:53:26 +0100
Message-ID: <1264190006.17306.5.camel@Nokia-N900-42-11>
References: <20100122192935.GC31538@mtholyoke.edu>
Reply-To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4195529100770442948=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100122192935.GC31538@mtholyoke.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


--===============4195529100770442948==
Content-Type: multipart/alternative; boundary="=-nVy/ts4KD4Hzl9wokgiX"


--=-nVy/ts4KD4Hzl9wokgiX
Content-Type: text/plain; charset=utf-8
Content-ID: <1264190005.17306.2.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: quoted-printable

The device mapper used to eat ioctl. This is no longer the case. I'll fix t=
he faq.
Thanks for the heads-up.

----- Message d'origine -----
> The multipath-tools FAQ has the following to say about partitioning
> multipath devices.
>
> > From http://christophe.varoqui.free.fr/faq.html
>
> > 6. How do I partition my multipathed devices
> > Partition a constituant path instead. And reload the map through multip=
ath(8)
>
> I take this to mean, for example, that one should partition /dev/sdX,
> rather than the corresponding coalesced /dev/mapper/... device, correct?
>
> My question is: why?=C2=A0 Paritioning the /dev/mapper device appears to
> work.=C2=A0 Is there an operational difference?=C2=A0 I've always done th=
is
> exactly as advised, but I know someone who didn't, and we're wondering
> if it matters.
>
> TIA
>
> -Ron-
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--=-nVy/ts4KD4Hzl9wokgiX
Content-Type: text/html; charset=utf-8
Content-ID: <1264190005.17306.4.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="generator" content="Osso Notes">
    <title></title></head>
<body>
<p>The device mapper used to eat ioctl. This is no longer the case. I'll fix the faq.
<br>Thanks for the heads-up.
<br>
<br>----- Message d'origine -----
<br>&gt; The multipath-tools FAQ has the following to say about partitioning
<br>&gt; multipath devices.
<br>&gt;
<br>&gt; &gt; From <a href="http://christophe.varoqui.free.fr/faq.html">http://christophe.varoqui.free.fr/faq.html</a>
<br>&gt;
<br>&gt; &gt; 6. How do I partition my multipathed devices
<br>&gt; &gt; Partition a constituant path instead. And reload the map through multipath(8)
<br>&gt;
<br>&gt; I take this to mean, for example, that one should partition /dev/sdX,
<br>&gt; rather than the corresponding coalesced /dev/mapper/... device, correct?
<br>&gt;
<br>&gt; My question is: why?&nbsp; Paritioning the /dev/mapper device appears to
<br>&gt; work.&nbsp; Is there an operational difference?&nbsp; I've always done this
<br>&gt; exactly as advised, but I know someone who didn't, and we're wondering
<br>&gt; if it matters.
<br>&gt;
<br>&gt; TIA
<br>&gt;
<br>&gt; -Ron-
<br>&gt;
<br>&gt; --
<br>&gt; dm-devel mailing list
<br>&gt; <a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<br>&gt; <a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a>
<br><br></p>
</body>
</html>

--=-nVy/ts4KD4Hzl9wokgiX--


--===============4195529100770442948==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4195529100770442948==--
