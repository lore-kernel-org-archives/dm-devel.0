From: Malahal Naineni <naineni@us.ibm.com>
Subject: Re: device mapper / multipath
Date: Mon, 23 Apr 2012 12:47:37 -0500
Message-ID: <20120423174737.GB10790@us.ibm.com>
References: <OF5CA12C90.9321E971-ON652579E9.005B82AE-652579E9.005C1A4E@LocalDomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OF5CA12C90.9321E971-ON652579E9.005B82AE-652579E9.005C1A4E@LocalDomain>
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

Tarak Reddy [tarak.reddy@in.ibm.com] wrote:
>    Hello,
>    I=A0am=A0facing=A0one=A0issue=A0on=A0LVM=A0&=A0Multipath=A0setup=A0on=
=A0scsi=A0devices.=A0This=A0test=A0was=A0running=A0with=A0blast=A0and=A0bla=
st=A0got=A0hung=A0after=A0couple=A0hours=A0run.=A0At=A0this=A0particular=A0=
time=A0multipath=A0-ll=A0show=A0as=A0all=A0paths=A0are=A0faulty=A0even=A0th=
ough=A0lsscsi=A0command=A0able=A0to=A0show=A0attached=A0devices=A0and=A0cor=
responding=A0HBA=A0was=A0online.=A0This=A0test=A0was=A0running=A0with=A0scs=
i_logging_level=3D6=A0and=A0multipath=A0is=A0not=A0able=A0to=A0updates=A0hi=
s=A0paths=A0as=A0it=A0complains=A0"test=A0unit=A0ready"=A0command=A0is=A0no=
t=A0working=A0on=A0any=A0of=A0those=A0paths.

"lsscsi" command doesn't send any I/O to make sure that they are
operational. Please do "dd if=3D/dev/sdX of=3D/dev/null count=3D1
iflag=3Ddirect" to make sure they are operational.

>    I=A0have=A0collected=A0the=A0dump=A0and=A0I/O=A0got=A0blocked=A0for=A0=
device=A0mapper=A0devices=A0not=A0for=A0underlying=A0scsi=A0devices(=A0as=
=A0device=A0mapper=A0could=A0able=A0get=A0which=A0path=A0it=A0can=A0use=A0f=
rom=A0path=A0selector=A0in=A0dm-multipath).=A0Below=A0has=A0some=A0debug=A0=
logs.

>    What=A0is=A0device-mapper-multipth=A0behavior=A0on=A0IO=A0request=A0al=
ready=A0placed=A0in=A0queue=A0and=A0going=A0to=A0be=A0queued=A0when=A0no=A0=
path=A0is=A0available=A0or=A0path=A0went=A0off?=A0In=A0my=A0case=A0as=A0pat=
hs=A0were=A0not=A0available=A0in=A0b/w=A0and=A0I/O=A0seems=A0to=A0blocked=
=A0which=A0made=A0application(blast)=A0to=A0be=A0hung.

The behavior depends on your multipath configuration (queue_if_no_path
etc), but looks like your paths are all dead in your case though.

Regards, Malahal.
