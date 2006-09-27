From: The MoonSeeker <themoonseeker@gmail.com>
Subject: Re: Problem when creating snashots
Date: Wed, 27 Sep 2006 11:51:43 +0200
Message-ID: <A544D1D7-C0A0-4EAB-8806-1A77B8453B56@gmail.com>
References: <77299A0E-4C81-4820-97BF-FB15B1A96FD6@gmail.com>
	<20060926211407.GA2915@hasse.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060926211407.GA2915@hasse.suse.de>
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

Yes I really need it. I have to create a virtual network editor for =20
my diploma project. So I have found many virtual solutions but the =20
bestest for our project is OpenVZ. Unfortunatly, OpenVZ don't offer =20
the copy on write with his solution, after many tests, I have found a =20
solution based on LVM.

The main idea is to have a Virtual Private Server Core and lot of =20
Virtual Private Server who are a snapshot of the Virtual Server Core. =20
Now the problem is the limitation of VLM, I need more than 32 servers =20
(32 snapshots). Will this limitation incresed in futur futur released =20
of LVM? Or can we broke this limitation?

Have you a solution, it's relly urgent for me...

Thanks you


Le 26 sept. 06 =E0 23:14, Jan Blunck a =E9crit :

> On Tue, Sep 26, The MoonSeeker wrote:
>
>> I'd like to create many snaphot of an image but I've got when I
>> attemp to create the 32th snapshot :
>>
>> root@B03:/diplome# lvcreate -s -L150M -n 232 /dev/openvz/vps-core
>>   Rounding up size to full physical extent 152.00 MB
>>   device-mapper: reload ioctl failed: Ne peut allouer de la m=E9moire
>>   Failed to suspend origin vps-core
>>
>> I don't understand the error..
>
> I'm not a native french speaker (hint!) but I assume you run out of
> memory.
>
> Yes there are limitations to the number of snapshots. For every single
> snapshot we have to allocate memory for copying the chunks to the =20
> exception
> store.
>
> Do you really need that many snapshots at the same time?
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
