From: Milan Broz <mbroz@redhat.com>
Subject: Re: Problem when creating snashots
Date: Wed, 27 Sep 2006 12:36:21 +0200
Message-ID: <451A5425.2010704@redhat.com>
References: <77299A0E-4C81-4820-97BF-FB15B1A96FD6@gmail.com>	<20060926211407.GA2915@hasse.suse.de>
	<A544D1D7-C0A0-4EAB-8806-1A77B8453B56@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <A544D1D7-C0A0-4EAB-8806-1A77B8453B56@gmail.com>
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

The problem with limited number of snapshots is caused by the using
big common mempool in dm-io module.
(This can happen even you have a lot of free memory...)

There are new dm-io patches which introduce new dm-io interface
(using private mempools) and solving this type of snapshot limitation.

Patches are currently in review and will probably change a bit,
but I hope it will in 2.6.19 kernel.

Milan

--
mbroz@redhat.com

The MoonSeeker napsal(a):
> Yes I really need it. I have to create a virtual network editor for my
> diploma project. So I have found many virtual solutions but the bestest
> for our project is OpenVZ. Unfortunatly, OpenVZ don't offer the copy on
> write with his solution, after many tests, I have found a solution base=
d
> on LVM.
>=20
> The main idea is to have a Virtual Private Server Core and lot of
> Virtual Private Server who are a snapshot of the Virtual Server Core.
> Now the problem is the limitation of VLM, I need more than 32 servers
> (32 snapshots). Will this limitation incresed in futur futur released o=
f
> LVM? Or can we broke this limitation?
>=20
> Have you a solution, it's relly urgent for me...
>=20
> Thanks you
>=20
>=20
> Le 26 sept. 06 =E0 23:14, Jan Blunck a =E9crit :
>=20
>> On Tue, Sep 26, The MoonSeeker wrote:
>>
>>> I'd like to create many snaphot of an image but I've got when I
>>> attemp to create the 32th snapshot :
>>>
>>> root@B03:/diplome# lvcreate -s -L150M -n 232 /dev/openvz/vps-core
>>>   Rounding up size to full physical extent 152.00 MB
>>>   device-mapper: reload ioctl failed: Ne peut allouer de la m=E9moire
>>>   Failed to suspend origin vps-core
>>>
>>> I don't understand the error..
>>
>> I'm not a native french speaker (hint!) but I assume you run out of
>> memory.
>>
>> Yes there are limitations to the number of snapshots. For every single
>> snapshot we have to allocate memory for copying the chunks to the
>> exception
>> store.
>>
>> Do you really need that many snapshots at the same time?
>>
>> --=20
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
>=20
> --=20
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
