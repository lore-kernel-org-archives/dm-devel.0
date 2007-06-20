From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath-tools Makefile
Date: Wed, 20 Jun 2007 08:13:28 +0200
Message-ID: <4678C588.3030606@suse.de>
References: <20070618225947.26450.qmail@sourceware.org>	<1182214679.5301.88.camel@linuxchandra>	<1182287728.20149.255.camel@localhost.localdomain>	<1182288343.5301.111.camel@linuxchandra>
	<1182288865.20149.259.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1182288865.20149.259.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Christophe Varoqui wrote:
> Le mardi 19 juin 2007 =C3=A0 14:25 -0700, Chandra Seetharaman a =C3=A9c=
rit :
>> On Tue, 2007-06-19 at 23:15 +0200, Christophe Varoqui wrote:
>>> Le lundi 18 juin 2007 =C3=A0 17:57 -0700, Chandra Seetharaman a =C3=A9=
crit :
>>>> Hi,
>>>>
>>>> Sorry about the late response. I just realized that pp_rdac has been
>>>> added to the multipath tree.
>>>>
>>>> pp_rdac is not needed to support lsi-rdac devices. pp_tpc performs
>>>> equally good. I repeated my tests with pp_tpc and they did work well=
.
>>>>
>>> rdac has superseded the tpc checker in the upstream tree.
>>>
>> (A):
>>> This checker is currently the only one usable with LSI Engenio hardwa=
re
>>> integrated by either IBM or SGI. As such I don't plan on removing it
>>> from the tree, if it's ok with you.
>>>
>> I am little confused here.
>>
>> Background info:
>> ------
>> (1) When I said we do _not_ need pp_rdac, I am referring to path
>> priority callout code(the code I submitted on May 21st). Code under th=
e
>> directory path_priority/pp_rdac.
>>
>> (2) The path checker code I submitted on March 23rd is needed to suppo=
rt
>> the LSI Engenio hardware. This code resides in libcheckers/rdac.c
>> ------
>>
>> (2) is needed and I presume you are referring to that at (A)=20
>>
>> (1) is not needed and we can achieve the same with
>> path_priority/pp_tpc/mpath_prio_tpc
>>
>=20
> The confusion was on my side, thank you for pointing it.
> I'll get back to my homework then.
>=20
Or we finally resolve this issue by renaming pp_tpc to pp_rdac.

pp_tpc is sadly a misnomer as it was originally developed against SGI
TPC arrays, of which I only had insufficient documentation.
Only later I found out that this was actually a RDAC controller.

Christophe, go.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
