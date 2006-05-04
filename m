From: Erez Zilber <erezz@voltaire.com>
Subject: Re: Setting up a multipath device
Date: Thu, 04 May 2006 18:28:08 +0300
Message-ID: <445A1D88.7030500@voltaire.com>
References: <445A0AE9.20907@voltaire.com> <20060504144915.GA2319@pundit>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060504144915.GA2319@pundit>
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

Christophe Varoqui wrote:

>On Thu, May 04, 2006 at 05:08:41PM +0300, Erez Zilber wrote:
> =20
>
>>Hi,
>>
>>I'm new to device mapper and trying to set a multipath target:
>>
>>I'm connected to the same LUN over iSCSI in 2 paths:
>>
>>Here's the output of sg_map:
>>sg_map -i -x
>>/dev/sg0 3 0 0 0 0 /dev/sda DotHill SANnet II FC 411I
>>/dev/sg1 4 0 0 0 0 /dev/sdb DotHill SANnet II FC 411I
>>
>>I ran the following command:
>>multipath 2 round-robin 1 0 /dev/sda round-robin 1 0 /dev/sdb
>>
>>   =20
>>
>Just start multipathd
>or run multipath without params
>
> =20
>
>>If I understand correctly, the 1st priority group contains /dev/sda. Th=
e=20
>>2nd priority group contains /dev/sdb. If /dev/sda fails, traffic should=
=20
>>automatically move to /dev/sdb. Is that right?
>>
>>Here's the out put of multipath -l:
>>
>>3600c0ff00000000007c1d121c397f503
>>[size=3D10 GB][features=3D0][hwhandler=3D0]
>>\_ round-robin 0 [prio=3D0][active]
>>\_ 3:0:0:0 sda 8:0 [active][undef]
>>\_ round-robin 0 [prio=3D0][enabled]
>>\_ 4:0:0:0 sdb 8:16 [active][undef]
>>
>>What does 8:0 & 8:16 mean? What is 3600c0ff00000000007c1d121c397f503?
>>
>>   =20
>>
>8:0 & 8:16 are paths major:minor numbers
>3600c0ff00000000007c1d121c397f503 is the multipath name.
>consider activating the fancy naming option in the config file.
>=20
> =20
>
>>Now, assuming that what I did so far is ok, how do I use the multipath=20
>>device? Do I use /dev/sda (or /dev/sdb)?
>>
>>   =20
>>
>You should use /dev/mapper/3600c0ff00000000007c1d121c397f503
>=20
>Regards,
>cvaroqui
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
> =20
>
Thanks. It seems to work now. Anyway, I have some more questions:

   1. Was it wrong to run 'multipath 2 round-robin 1 0 /dev/sda
      round-robin 1 0 /dev/sdb'?
   2. If I don't supply any parameters, how does the dm know which
      devices are the same physical device (that /dev/sda & /dev/sdb are
      the same physical device)?
   3. How are the priority groups defined if no parameters are supplied?
   4. What is the timeout for a device that has failed? When does the dm
      move to the next priority group?


Thanks
--=20

____________________________________________________________

Erez Zilber | 972-9-971-7689

Software Engineer, Storage Team

Voltaire =96 _The Grid Backbone_

__

www.voltaire.com <http://www.voltaire.com/>
