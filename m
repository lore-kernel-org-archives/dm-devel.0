From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Help with MPIO assigning / blacklisting
Date: Thu, 08 Oct 2009 15:50:44 -0700
Message-ID: <1255042244.10144.2.camel@chandra-ubuntu>
References: <8f3e95600910081515x1257d9fbud365667c7e55c713@mail.gmail.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8f3e95600910081515x1257d9fbud365667c7e55c713@mail.gmail.com>
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

Hi Lucas,

You can setup multipath only for block devices and not "partitions". You
will be able to setup multipathing to sdb and use the multipathed
partition corresponding to sdb1 for your purposes.

You will not be able to setup multipathing to sdb1 and not sdb2.

chandra
On Fri, 2009-10-09 at 00:15 +0200, j.Lucas wrote:
> I apologize if this is a simple question but I have tried in every
> place I can google to resolve this before posting this.  The problem I
> have (and hoping someone will help resolve) is:
>=20
> Setting up a MPIO SAS configuration it is important to me that I have
> multiple paths to a partition on each drive.. each drive has two
> partitions, but only one is of interest.  So we normal have eg sdb,
> sdb1 and sdb2.  However we only want to MPIO to sdb1.
>=20
> Manually this would maybe seem easy, but there is likely to be many
> many drives and hot-plugged in and out etc=E2=80=A6 so it seems sensibl=
e to
> use the option of black listing and exclusions from black lists so
> that DM only addresses sdx1=E2=80=A6.. but this is where my problems st=
art and
> my hair fails out.
>=20
> I have tried reading everything I can find on this, and tried all
> options I can think of=E2=80=A6 but I cannot get it work like this.  In=
 fact I
> cannot seem to get it to by default see any of the partitions (without
> having to manually run something).
>=20
> I have even tried to blacklist ALL sd[a-z]  (which seems to work) but
> exclude i.e. sdb1 which doesn=E2=80=99t seem to work.
>=20
> I really would appreciate any advice as I am sure that to someone who
> has the experience here will probably be able to resolve this in a
> couple of lines as opposed to my couple of years!
>=20
> Thank you
>=20
> --=20
> Lucas
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
