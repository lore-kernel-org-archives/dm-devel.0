From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: RFC: multipath IO multiplex
Date: Sun, 07 Nov 2010 11:30:49 +0100
Message-ID: <1289125849.2821.5.camel@Nokia-N900-42-11>
References: <20101105183946.GG25992@suse.de> <20101106053203.7e4ef435@notabene>
	<20101106115102.GF10171@agk-dp.fab.redhat.com>
	<20101106165743.GE30809@suse.de>
Reply-To: Christophe Varoqui <christophe.varoqui@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7125022416136611035=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101106165743.GE30809@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@novell.com>, Neil Brown <neilb@suse.de>
List-Id: dm-devel.ids


--===============7125022416136611035==
Content-Type: multipart/alternative; boundary="=-o3e5SdtoccKNL08qyIxm"


--=-o3e5SdtoccKNL08qyIxm
Content-Type: text/plain; charset=utf-8
Content-ID: <1289125848.2821.2.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx3-phx2.redhat.com id oA7AVOaj010522

Wouldn't it practical to bypass mpio completely on submit your io to the =
paths instead ?

Cheers,
cvaroqui

----- Message d'origine -----
> On 2010-11-06T11:51:02, Alasdair G Kergon <agk@redhat.com> wrote:
>=20
> Hi Neil, Alasdair,
>=20
> thanks for the feedback. Answering your points in reverse order -
>=20
> > > Might it make sense to configure a range of the device where writes
> > > always went down all paths?=C2=A0  That would seem to fit with your
> > > problem description and might be easiest??
> > Indeed - a persistent property of the device (even another interface
> > with a different minor number) not the I/O.
>=20
> I'm not so sure that would be required though. The equivalent of our
> "mkfs" tool wouldn't need this. Also, typically, this would be a
> partition (kpartx) on top of a regular MPIO mapping (that we want to be
> managed by multipathd).
>=20
> Handling this completely differently would complicate setup, no?
>=20
> > And what is the nature of the data being written, given that I/O to
> > one path might get delayed and arrive long after it was sent,
> > overwriting data sent later.=C2=A0  Successful stale writes will alwa=
ys be
> > recognised as such by readers - how?
>=20
> The very particular use case I am thinking of is the "poison pill" for
> node-level fencing. Nodes constantly monitor their slot (using direct
> IO, bypassing all caching, etc), and either can successfully read it or
> commit suicide (assisted by a hardware watchdog to protect against
> stalls).
>=20
> The writer knows that, once the message has been successfully written,
> the target node will either have read it (and committed suicide), or
> been self-fenced because of a timeout/read error.
>=20
> Allowing for the additional timeouts incurred by MPIO here really slows
> this mechanism down to the point of being unusable.
>=20
> Now, even if a write was delayed - which is not very likely, it's more
> likely that some of the IO will just fail if indeed one of the paths
> happens to go down, and this would not resubmit it to other paths -, th=
e
> worst that could happen would be a double fence. (If it gets written
> after the node has cycled once and cleared its message slot; that would
> imply a significant delay already, since servers take a bit to boot.)
>=20
> For the 'heartbeat' mechanism and others (if/when we get around for
> adding them), we could ignore the exact contents that have been written
> and just watch for changes; worst, the node death detection will take a
> bit longer.
>=20
> Basically, the thing we need to get around is the possible IO latency i=
n
> MPIO, for things like poison pill fencing ("storage-based death") or
> qdisk-style plugins. I'm open for other suggestions as well.
>=20
>=20
>=20
> Regards,
>=C2=A0 =C2=A0 =C2=A0 =C2=A0  Lars
>=20
> --=20
> Architect Storage/HA, OPS Engineering, Novell, Inc.
> SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
> "Experience is the name everyone gives to their mistakes." -- Oscar Wil=
de
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--=-o3e5SdtoccKNL08qyIxm
Content-Type: text/html; charset=utf-8
Content-ID: <1289125848.2821.4.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx3-phx2.redhat.com id oA7AVOaj010522

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://ww=
w.w3.org/TR/html4/loose.dtd">
<html><head>
    <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dutf=
-8">
    <meta name=3D"generator" content=3D"Osso Notes">
    <title></title></head>
<body>
<p>Wouldn't it practical to bypass mpio completely on submit your io to t=
he paths instead ?
<br>
<br>Cheers,
<br>cvaroqui
<br>
<br>----- Message d'origine -----
<br>&gt; On 2010-11-06T11:51:02, Alasdair G Kergon &lt;<a href=3D"mailto:=
agk@redhat.com">agk@redhat.com</a>&gt; wrote:
<br>&gt;=20
<br>&gt; Hi Neil, Alasdair,
<br>&gt;=20
<br>&gt; thanks for the feedback. Answering your points in reverse order =
-
<br>&gt;=20
<br>&gt; &gt; &gt; Might it make sense to configure a range of the device=
 where writes
<br>&gt; &gt; &gt; always went down all paths?&nbsp; &#32;That would seem=
 to fit with your
<br>&gt; &gt; &gt; problem description and might be easiest??
<br>&gt; &gt; Indeed - a persistent property of the device (even another =
interface
<br>&gt; &gt; with a different minor number) not the I/O.
<br>&gt;=20
<br>&gt; I'm not so sure that would be required though. The equivalent of=
 our
<br>&gt; "mkfs" tool wouldn't need this. Also, typically, this would be a
<br>&gt; partition (kpartx) on top of a regular MPIO mapping (that we wan=
t to be
<br>&gt; managed by multipathd).
<br>&gt;=20
<br>&gt; Handling this completely differently would complicate setup, no?
<br>&gt;=20
<br>&gt; &gt; And what is the nature of the data being written, given tha=
t I/O to
<br>&gt; &gt; one path might get delayed and arrive long after it was sen=
t,
<br>&gt; &gt; overwriting data sent later.&nbsp; &#32;Successful stale wr=
ites will always be
<br>&gt; &gt; recognised as such by readers - how?
<br>&gt;=20
<br>&gt; The very particular use case I am thinking of is the "poison pil=
l" for
<br>&gt; node-level fencing. Nodes constantly monitor their slot (using d=
irect
<br>&gt; IO, bypassing all caching, etc), and either can successfully rea=
d it or
<br>&gt; commit suicide (assisted by a hardware watchdog to protect again=
st
<br>&gt; stalls).
<br>&gt;=20
<br>&gt; The writer knows that, once the message has been successfully wr=
itten,
<br>&gt; the target node will either have read it (and committed suicide)=
, or
<br>&gt; been self-fenced because of a timeout/read error.
<br>&gt;=20
<br>&gt; Allowing for the additional timeouts incurred by MPIO here reall=
y slows
<br>&gt; this mechanism down to the point of being unusable.
<br>&gt;=20
<br>&gt; Now, even if a write was delayed - which is not very likely, it'=
s more
<br>&gt; likely that some of the IO will just fail if indeed one of the p=
aths
<br>&gt; happens to go down, and this would not resubmit it to other path=
s -, the
<br>&gt; worst that could happen would be a double fence. (If it gets wri=
tten
<br>&gt; after the node has cycled once and cleared its message slot; tha=
t would
<br>&gt; imply a significant delay already, since servers take a bit to b=
oot.)
<br>&gt;=20
<br>&gt; For the 'heartbeat' mechanism and others (if/when we get around =
for
<br>&gt; adding them), we could ignore the exact contents that have been =
written
<br>&gt; and just watch for changes; worst, the node death detection will=
 take a
<br>&gt; bit longer.
<br>&gt;=20
<br>&gt; Basically, the thing we need to get around is the possible IO la=
tency in
<br>&gt; MPIO, for things like poison pill fencing ("storage-based death"=
) or
<br>&gt; qdisk-style plugins. I'm open for other suggestions as well.
<br>&gt;=20
<br>&gt;=20
<br>&gt;=20
<br>&gt; Regards,
<br>&gt;&nbsp; &nbsp; &nbsp; &nbsp; &#32;Lars
<br>&gt;=20
<br>&gt; --=20
<br>&gt; Architect Storage/HA, OPS Engineering, Novell, Inc.
<br>&gt; SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=C3=BCr=
nberg)
<br>&gt; "Experience is the name everyone gives to their mistakes." -- Os=
car Wilde
<br>&gt;=20
<br>&gt; --
<br>&gt; dm-devel mailing list
<br>&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<br>&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel">htt=
ps://www.redhat.com/mailman/listinfo/dm-devel</a>
<br><br></p>
</body>
</html>

--=-o3e5SdtoccKNL08qyIxm--


--===============7125022416136611035==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============7125022416136611035==--
