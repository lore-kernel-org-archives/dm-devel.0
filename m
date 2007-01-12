From: "Wilson, Christopher J" <chris.j.wilson@verizonbusiness.com>
Subject: Re: [dm-devel] [RFC] Multiple Snapshots -
	Manageability	problem
Date: Fri, 12 Jan 2007 22:07:52 +0000
Message-ID: <500DD6DE2DFA8E40A33E5898D9471B97016D4FDE@ASHEVS006.mcilink.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2091277255=="
Return-path: <evms-devel-bounces@lists.sourceforge.net>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=evms-devel>
List-Post: <mailto:evms-devel@lists.sourceforge.net>
List-Help: <mailto:evms-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: evms-devel-bounces@lists.sourceforge.net
Errors-To: evms-devel-bounces@lists.sourceforge.net
To: device-mapper development <dm-devel@redhat.com>, evms-devel@lists.sourceforge.net, linux-lvm@redhat.com
List-Id: dm-devel.ids

--===============2091277255==
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: quoted-printable
Content-class: urn:content-classes:message

I'm=20aware=20we're=20discussing=20file=20system=20cow=20snapshots=20here,=
=203PAR=20was=20just
a=20reference=20around=20the=20virtual=20pool=20concept.=20=20

Using=20one=20pool=20per=20origin=20helps=20and=20I=20do=20see=20the=20ups=
ide=20to=20that=20and=20I
don't=20discount=20it=20altogether.=20=20A=20global=20pool=20shared=20acro=
ss=20all=20devices
could=20be=20playing=20with=20fire.

My=20concern=20with=20the=20single=20pool=20is=20we're=20now=20starting=20=
to=20crossover=20into
the=20deduplication=20space,=20or=20what=20looks=20like=20the=20beginning=20=
of=20it.=20=20The
issue=20with=20having=20all=20pointers=20looking=20at=20a=20central=20pool=
=20of=20storage=20goes
back=20to=20the=20garbage=20collection=20process.=20=20This=20is=20an=20io=
=20bound=20unit=20of
work=20and=20if=20you=20think=20you've=20got=20performance=20issues=20now=20=
try=20and=20read
from=20a=20snap=20while=20garbage=20collection=20is=20going=20on.=20=20Wri=
tes=20to=20it=20would=20be
equally=20as=20painful.=20=20As=20I=20said,=20we=20use=20the=20dedup=20tec=
hnology=20which=20uses=20a
single=20pool=20(not=203PAR,=20they're=20virtual=20primary=20disk=20and=20=
a=20damn=20good=20one)
and=20between=20backups=20and=20garbage=20collect=20and=20other=20block=20=
checking=20the
system=20is=20at=20its=20knees.=20=20

I=20would=20argue=20that=20sharing=20a=20cow=20pool=20doesn't=20make=20you=
r=20snapshots
independent,=20it=20makes=20them=20dependant.=20=20As=20with=20the=20dedup=
=20technology=20you
have=20to=20track=20which=20blocks=20are=20shared=20across=20all=20your=20=
cow=20snaps.=20=20This
means=20that=20you=20can't=20garbage=20collect=20a=20shared=20block=20unti=
l=20the=20last=20cow
is=20expired.=20=20You=20have=20a=20strong=20possibility=20that=20you'll=20=
have
defragmentation=20problems=20and=20your=20cow=20store=20may=20continue=20t=
o=20grow,=20or=20at
least=20shrink=20begrudgingly=20and=20with=20lots=20of=20human=20intervent=
ion.

I=20think=20it=20goes=20back=20to=20why=20do=20this?=20=20If=20people=20ar=
e=20keeping=20a=20weeks
worth=20of=20snaps=20then=20I=20think=20they=20need=20to=20look=20at=20the=
ir=20data=20protection
strategy=20and=20build=20a=20better=20mousetrap=20at=20that=20level.=20=20=
As=20I=20said=20on=20the
other=20thread,=20I'd=20be=20uncomfortable=20with=207=20day=20old=20cow=20=
snap=20if=20something
happened=20that=20was=20bad=20enough=20that=20I=20had=20to=20recover=20fro=
m=20them.=20=20A=207=20day
old=20block-by-block=20copy=20is=20much=20safer.=20=20With=20the=20size=20=
of=20disk=20and
current=20rate=20of=20cost=20per=20GB=20(and=20falling)=20a=20cow=20strate=
gy=20that=20did=20some
lazy=20migration=20to=20a=20clone=20based=20on=20time=20may=20be=20more=20=
useful.

-Chris

-----Original=20Message-----
From:=20dm-devel-bounces@redhat.com=20[mailto:dm-devel-bounces@redhat.com]=

On=20Behalf=20Of=20Vijai=20Babu=20Madhavan
Sent:=20Thursday,=20January=2011,=202007=2011:47=20PM
To:=20evms-devel@lists.sourceforge.net;=20device-mapper=20development;
linux-lvm@redhat.com
Subject:=20RE:=20[dm-devel]=20[RFC]=20Multiple=20Snapshots=20-=20Manageabi=
lity=20problem

Hi=20Chris,

Thanks=20for=20the=20response.=20I=20am=20trying=20to=20keep=20my=20mails=20=
short=20as=20I=20believe
the=20lack=20of=20responses=20to=20my=20mails=20are=20probably=20due=20to=20=
the=20fact=20that=20they
are=20long,=20but=20its=20kinda=20difficult=20to=20keep=20them=20small=20a=
nd=20still=20convey
the=20various=20aspects.=20:)

>>>=20On=201/12/2007=20at=203:04=20AM,=20"Wilson,=20Christopher=20J"
<chris.j.wilson@verizonbusiness.com>=20wrote:
>=20I=20haven't=20read=20through=20all=20of=20these=20options=20yet=20(but=
=20I=20will).=20=20I=20will=20
>=20say=20that=20synthesizing=20all=20your=20cow=20objects=20into=20one=20=
pool=20will=20be=20
>=20difficult.=20=20You're=20going=20to=20have=20issues=20with=20garbage=20=
collection=20of=20old

>=20copies=20and=20may=20have=20to=20build=20in=20some=20scavenge=20or=20c=
ompress=20functions=20
>=20which=20will=20take=20system=20resources.=20=20From=20my=20experience=20=
with=20disk=20based=20
>=20de-duplication=20technologies=20you're=20heading=20down=20a=20hole=20w=
hich=20can=20be=20a=20
>=20dark=20place.=20=20There=20are=20performance=20issues=20and=20maintain=
ing=20all=20those=20
>=20pointers=20is=20problematic.=20=20The=20virtual=20pool=20sounds=20good=
,=20and=20works=20very

>=20will=20for=20primary=20storage=20functions=20(3PAR)=20but=20in=20pract=
ice=20for=20backup=20
>=20applications=20with=20virtual=20pools=20for=20deduplication=20it's=20n=
ot=20been=20so
hot.

I=20completely=20agree=20that=20its=20not=20going=20to=20be=20easy.=20But,=
=20I=20guess=20some
price=20needs=20to=20be=20paid=20to=20get=20the=20benefits.=20If=20snapsho=
ts=20could=20be
implemented=20at=20the=20file=20system=20level,=20we=20do=20not=20necessar=
ily=20need=20to=20redo
lot=20of=20these,=20but=20building=20snapshot=20functionality=20into=20the=
=20file=20system
itself=20comes=20with=20the=20obvious=20drawback.=20If=20only=20we=20could=
=20build=20some
framework=20at=20the=20file=20system=20layer,=20but=20some=20thing=20that=20=
is=20not=20tied=20to
each=20file=20system=20would=20be=20good.=20I=20have=20not=20had=20a=20cha=
nce=20to=20spend=20time=20in
this=20space=20yet,=20do=20others=20have=20any=20ideas=20in=20this=20space=
?

>=20I'm=20not=20clear=20what=20the=20issue=20is=20with=20maintaining=20mul=
tiple=20cow
snapshots.
>=20Just=20exactly=20how=20many=20are=20users=20asking=20for?=20=20Keeping=
=20more=20than=20a=20few=20
>=20cow=20snaps=20online=20is=20not=20using=20the=20function=20for=20what=20=
it=20was=20meant=20for.
>=20COW=20technology=20is=20for=20immediate=20rollback=20(to=20me)=20and=20=
not=20for=20long=20term

>=20backup=20images.

>From=20what=20we=20see=20from=20the=20users/IT=20admins,=20I=20see=20two=20=
common=20uses=20of
snapshots.

a)=20Snapshots=20for=20backups
b)=20Snapshots=20as=20backups

In=20the=20first=20case,=20snapshots=20are=20obtained=20to=20avoid=20the=20=
open=20file=20errors,
etc=20and=20keeping=20few=20snapshots=20online=20is=20more=20than=20suffic=
ient.

But,=20increasingly,=20we=20see=20lot=20of=20admins=20trying=20to=20deploy=
=20D2D2T
(Disk->Disk->Tape),=20to=20avoid=20the=20many=20problems=20associated=20wi=
th=20the=20tape
backups.=20And,=20Snapshots=20are=20one=20of=20the=20very=20efficient=20wa=
y=20of=20keeping=20the
disk=20backups=20to=20protect=20against=20logical=20failures=20(of=20cours=
e=20not=20for
hardware=20failures).

Hence,=20the=20second=20case=20is=20becoming=20a=20strong=20use-case,=20as=
=20admins=20want=20to
take=203-4=20snapshots=20a=20day=20and=20recycle=20them=20after=20a=20week=
=20or=20two=20weeks.=20
Based=20on=20the=20frequency=20and=20the=20time=20a=20snapshot=20is=20kept=
=20alive,=20number=20of
snapshots=20easily=20get=20into=20double=20digit,=20in=20some=20cases,=20t=
riple=20digit.

With=20the=20current=20DM=20snapshot=20code,=20with=20couple=20of=20snapsh=
ots,=20the=20system
comes=20down=20rapidly=20(The=20throughput=20numbers=20in=20the=20earlier=20=
mail=20thread
and=20the=20complaints=20from=20users=20reported=20in=20the=20list=20indic=
ate=20this).

As=20we=20fix=20this=20multiple=20snapshots=20issue,=20it=20also=20makes=20=
sense=20to=20fix=20the
multiple=20snapshots=20management=20issue=20using=20a=20single=20cow=20dev=
ice.=20Besides,
using=20a=20single=20cow=20device=20provides=20a=20very=20compelling=20eff=
icient=20way=20to
share=20the=20blocks=20among=20snapshots.=20This=20also=20enables=20the=20=
snapshots=20to=20be
managed=20independently.

>=20Sizing=20is=20an=20issue=20that=20will=20not=20go=20away=20and=20is=20=
not=20resolvable=20in=20any=20
>=20low=20level=20OS=20code,=20this=20is=20a=20business/user=20issue.
>=20Most=20customers=20don't=20even=20know=20how=20much=20data=20they're=20=
going=20to=20have=20
>=20much=20less=20what=20their=20average=20write=20rates=20are,=20and=20I=20=
don't=20envision=20a=20
>=20cow=20pool=20as=20solving=20the=20sizing=20issue.

I=20totally=20agree.=20I=20guess=20most=20admins=20today=20are=20loading=20=
their=20servers
around=2060-70%=20utilization=20to=20avoid=20these=20space=20issues.=20Whi=
le=20this=20works
ok=20for=20primary=20servers,=20it=20is=20impractical=20to=20waste=20so=20=
much=20space=20in=20each
snapshot,=20especially=20with=20multiple=20snapshots.=20I=20think=20having=
=20a=20single
cow=20device=20for=20each=20(origin),=20preferably=20multiple=20origins=20=
sharing=20a
single=20cow=20device=20would=20help=20alleviate=20this.
=20
>=20If=20I=20had=20my=20way=20I'd=20rather=20see=20energy=20put=20into=20c=
ow=20technology=20for=20use=20
>=20as=20a=20disk=20cache=20for=20backup=20applications=20and=20tighter=20=
integration=20with=20
>=20those=20apps.=20=20Better=20still=20would=20be=20for=20interfaces=20fr=
om=20business=20level=20
>=20applications=20(Oracle,=20MySQL,=20etc)=20to=20quiece=20IO,=20flush=20=
buffers,=20and=20
>=20take=20a=20consistent=20copy=20of=20the=20application,=20state=20and=20=
all.=20=20Putting=20
>=20together=20an=20application=20level=20copy=20on=20hardware,=20being=20=
able=20to=20move=20
>=20that=20through=20a=20tighter=20workflow=20to=20backup=20media=20throug=
h=20a=20common=20API=20
>=20would=20be=20my=20preference=20instead=20of=20having=20each=20user=20c=
reate=20their=20own=20
>=20individual=20"glue"=20code.=20=20If=20you=20look=20into=20SNIA's=20SMI=
-S=20(Storage=20
>=20Management=20API)=20copy=20services=20package=20there=20may=20already=20=
be=20a=20template=20
>=20for=20this.=20=20I'd=20say=20at=20least=20that=20supporting=20SMI-S=20=
Copy=20Services=20
>=20through=20that=20API=20is=20desirable=20because=20a=20lot=20of=20the=20=
SRM=20application
today=20are=20on=20their=20way=20to
>=20leveraging=20that=20code.=20=20=20

I=20completely=20agree.=20Application=20co-ordinated=20snapshot=20facility=
=20is=20really
important=20and=20would=20really=20help=20lot=20of=20application=20develop=
ers=20and
admins.
It=20is=20going=20to=20be=20interesting=20and=20challenging=20to=20build=20=
a=20framework=20that
would=20satisfy=20diverse=20application=20needs.=20At=20Novell,=20we=20als=
o=20have=20some
interest=20in=20this=20space,=20and=20we=20are=20going=20through=20some=20=
internal=20processes
and=20I=20believe=20we=20would=20come=20out=20some=20time=20soon.

Vijai

--
dm-devel=20mailing=20list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

______________________________________________________________________
This=20e-mail=20has=20been=20scanned=20by=20Verizon=20Managed=20Email=20Co=
ntent=20Service,
using=20Skeptic(tm)=20technology=20powered=20by=20MessageLabs.=20For=20mor=
e
information=20on=20Verizon=20Managed=20Email=20Content=20Service,=20visit
http://www.verizonbusiness.com.
______________________________________________________________________


______________________________________________________________________
This=20e-mail=20has=20been=20scanned=20by=20Verizon=20Managed=20Email=20Co=
ntent=20Service,=20using=20Skeptic=99=20technology=20powered=20by=20Messag=
eLabs.=20For=20more=20information=20on=20Verizon=20Managed=20Email=20Conte=
nt=20Service,=20visit=20http://www.verizonbusiness.com.
______________________________________________________________________


--===============2091277255==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
--===============2091277255==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Evms-devel mailing list
Evms-devel@lists.sourceforge.net
To subscribe/unsubscribe, please visit:
https://lists.sourceforge.net/lists/listinfo/evms-devel

--===============2091277255==--
