From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: multipath prio_callout broke from 5.2 to 5.3
Date: Fri, 24 Apr 2009 08:31:22 -0700
Message-ID: <7bc80d500904240831y1a31beceg87b7a8795233b7fc@mail.gmail.com>
References: <1779195765.1578721239520436084.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<1239613205.6376.16.camel@jaspav.missionsit.net.missionsit.net>
	<20090413185745.GF15911@ether.msp.redhat.com>
	<1239652565.30476.41.camel@jaspav.missionsit.net.missionsit.net>
	<20090413203711.GH15911@ether.msp.redhat.com>
	<1239659354.30476.49.camel@jaspav.missionsit.net.missionsit.net>
	<49F0AEA0.9050803@nrel.colostate.edu>
	<20090424062759.GZ15911@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090424062759.GZ15911@ether.msp.redhat.com>
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

On Thu, Apr 23, 2009 at 11:27 PM, Benjamin Marzinski
<bmarzins@redhat.com> wrote:
> On Thu, Apr 23, 2009 at 12:08:32PM -0600, Ty! Boyack wrote:
>> This thread has been great information since I'm looking at the same t=
ype
>> of thing. =A0However it raises a couple of (slightly off-topic) questi=
ons for
>> me.
>> My recent upgrade to fedora 10 broke my prio_callout bash script just =
like
>> you described, but my getuid_callout (a bash script that calls udevadm=
,
>> grep, sed, and iscsi_id) runs just fine. =A0Are the two callouts handl=
ed
>> differently?
>
> Fedora 10 uses the same method as upstream, priority callouts have been
> replaced by priority modules. These are dynamic shared objects that get
> loaded by multipath. =A0Because of this, multipath doesn't use a privat=
e
> namespace, so it can use scripts without restrictions for the getuid_ca=
llout.
>
>>
>> Also, is there an easy way to know what tools are in the private names=
pace
>> already? =A0My prio_callout script calls two other binaries: /sbin/ude=
vadm
>> and grep. =A0If I go to C-code, handling grep's functions myself is no
>> problem, but I'm not confident about re-implementing what udevadm does=
.
>> Can I assume that since /sbin/udevadm is in /sbin that it will be avai=
lable
>> to call via exec()? =A0Or would I be right back where we are with the =
bash
>> scripting, as in having to include a dummy device as you described?
>
> Sorry, the C code is necessary now.
>
>> Finally, in my case I've got two redundant iscsi networks, one is 1GbE=
, and
>> the other is 10GbE. =A0In the past I've always had symetric paths, so =
I've
>> used round-robin/multibus. =A0But I want to focus traffic on the 10GbE=
 path,
>> so I was looking at using the prio callout. =A0Is this even necessary?=
 =A0Or
>> will round-robin/multibus take full advantage of both paths? =A0I can =
see
>> round-robin on that setup resulting in either around 11Gbps or 2 Gbps,
>> depending on whether the slower link becomes a limiting factor. =A0I'm=
 just
>> wondering if I am making things unnecessarily complex by trying to set
>> priorities.
>
> With round-robin, you will send half your IO to the slow path. =A0A
> priority callout makes sense here.
>
>> Thanks for all the help.

I ended up biting the bullet and writing a C program to do the
priority calculations.

m2c

cc

--=20
Chris Chen <muffaleta@gmail.com>
"I want the kind of six pack you can't drink."
-- Micah
