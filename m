From: Erez Zilber <erezz@voltaire.com>
Subject: Re: Re: Running open-iscsi with device mapper hangs
Date: Thu, 11 May 2006 17:55:58 +0300
Message-ID: <4463507E.8090801@voltaire.com>
References: <4460A074.6030805@voltaire.com>
	<4460C978.7090803@cs.wisc.edu>	<44619424.4090208@voltaire.com>
	<4462216D.6070907@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4462216D.6070907@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: open-iscsi@googlegroups.com, Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Mike Christie wrote:

>Erez Zilber wrote:
> =20
>
>>Mike Christie wrote:
>>
>>   =20
>>
>>>Erez Zilber wrote:
>>>=20
>>>
>>>     =20
>>>
>>>>Hi,
>>>>
>>>>I'm trying to run open-iscsi with the multipath tool. I was able to=20
>>>>create a scenario in which the initiator machine hangs:
>>>>
>>>>My initiator runs on a SLES 10 beta 8 machine. The db contains 2 targ=
ets:
>>>>iscsiadm -m node
>>>>[83347a] 192.168.10.106:3260,1 iqn.2005-12.com.voltaire.206000C0FF07C=
1D1
>>>>[030479] 192.168.10.105:3260,1 iqn.2005-12.com.voltaire.206000C0FF07C=
1D1
>>>>
>>>>  =20
>>>>
>>>>       =20
>>>>
>>>are you using the iscsi initiator in a SLES kernel, a mainline kernel =
or
>>>svn or a open-iscsi.org tarball?
>>>
>>>--
>>>dm-devel mailing list
>>>dm-devel@redhat.com
>>>https://www.redhat.com/mailman/listinfo/dm-devel
>>>=20
>>>
>>>     =20
>>>
>>I'm using the initiator that comes with the SLES kernel=20
>>(2.6.16-rc6-git1-4-smp). We applied 3 patches that are located in=20
>>https://openib.org/svn/gen2/branches/backport/sles10/:
>>iscsi-04-libiscsi.patch
>>iscsi-05-convert-tcp.patch
>>iscsi-06-transport-ep-cb.patch
>>
>>The userspace part is r560.
>>
>>Do you prefer that I try to run it with a different open-iscsi version?
>>
>>   =20
>>
>
>Maybe. Do those patches have any of the later fixes PatM found? Look at
>r543, 544, 545. Without them you can hit some lockups or oops.
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
> =20
>
I'm now running with r545 and I don't see this behavior anymore.

Hannes - do you know when will there be an update for SLES 10 with those=20
fixes ?

--=20

____________________________________________________________

Erez Zilber   |  972-9-971-7689

Software Engineer, Storage Team

Voltaire =96 _The Grid Backbone_

 __

 www.voltaire.com <http://www.voltaire.com/>

=20
