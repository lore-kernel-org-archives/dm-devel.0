From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: RE: Dell MD3000i issues with dm mp
Date: Wed, 15 Apr 2009 12:33:29 -0500
Message-ID: <49E61A69.6090807@cs.wisc.edu>
References: <D192143E8D8E6749B56F630ABC78B7331CEA46C2C5@MAIL3.bgsu.edu>	<E463DF2B2E584B4A82673F53D62C2EF4669B59A6@cosmail01.lsi.com>	<D192143E8D8E6749B56F630ABC78B7331CEA46C3A5@MAIL3.bgsu.edu>	<E463DF2B2E584B4A82673F53D62C2EF4669B59E1@cosmail01.lsi.com>	<D192143E8D8E6749B56F630ABC78B7331CEA46C46E@MAIL3.bgsu.edu>	<E463DF2B2E584B4A82673F53D62C2EF4669B5A91@cosmail01.lsi.com>	<D192143E8D8E6749B56F630ABC78B7331CEA46C4F9@MAIL3.bgsu.edu>
	<E463DF2B2E584B4A82673F53D62C2EF4669B5B48@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4669B5B48@cosmail01.lsi.com>
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

Moger, Babu wrote:
> I don=92t see any apparent reason for these messages(=93rdac Dettached=94=
) by looking at the log. There are some issci session failure messages.  =
I don=92t understand those messages very well.  You may have to ask some =
iscsi experts to look at it.
>=20

The http://pastebin.com/d97ae1ad link does not work anymore. If you=20
could put the log back up, I can look at the iscsi messages.


> ________________________________
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On Behalf Of Kurt Bechstein
> Sent: Tuesday, April 14, 2009 12:44 PM
> To: device-mapper development
> Subject: [dm-devel] RE: Dell MD3000i issues with dm mp
>=20
> No devices were detached during this sequence at least not physically a=
nyways.
>=20
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On Behalf Of Moger, Babu
> Sent: Tuesday, April 14, 2009 1:38 PM
> To: device-mapper development
> Subject: [dm-devel] RE: Dell MD3000i issues with dm mp
>=20
> I am seeing few =93rdac Dettached=94 messages. There are only messages =
I am bit concerned about (unless you disconnected some devices purposeful=
ly during the test). I am not concerned about other messages.
>=20
> Thanks
> Babu Moger
> ________________________________
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On Behalf Of Kurt Bechstein
> Sent: Tuesday, April 14, 2009 12:10 PM
> To: device-mapper development
> Subject: [dm-devel] RE: Dell MD3000i issues with dm mp
>=20
> Here is a snippet of my /var/log/messages from this morning=92s boot se=
quence after iscsi started and some of the output I=92m seeing.  Seems li=
ke quite a bit to me.
>=20
> http://pastebin.com/d97ae1ad
>=20
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On Behalf Of Moger, Babu
> Sent: Tuesday, April 14, 2009 12:12 PM
> To: device-mapper development
> Subject: [dm-devel] RE: Dell MD3000i issues with dm mp
>=20
> I would think it should be pretty sparse.
>=20
> Thanks
> Babu Moger
> ________________________________
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On Behalf Of Kurt Bechstein
> Sent: Tuesday, April 14, 2009 10:57 AM
> To: device-mapper development
> Subject: [dm-devel] RE: Dell MD3000i issues with dm mp
>=20
> I actually tried doing that by doing a mkinitrd /boot/initrdfile =96pre=
load=3Dscsi_dh_rdac kernelversion and booted using the initrd and it stil=
l seemed to crank out quite a few errors.  With doing it this way, should=
 I still expect to see a good deal of I/O errors or should they pretty sp=
arse?
>=20
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On Behalf Of Moger, Babu
> Sent: Tuesday, April 14, 2009 11:38 AM
> To: device-mapper development
> Subject: [dm-devel] RE: Dell MD3000i issues with dm mp
>=20
> Yes, this could happen during the boot where the scsi_dh_rdac handler i=
s not yet loaded. You might want to try adding scsi_dh_rdac in the initrd=
.  This will help to cut short all your error messages. I don=92t see any=
 problem with your multipath.conf.
>=20
> Thanks
> Babu Moger
> ________________________________
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On Behalf Of Kurt Bechstein
> Sent: Tuesday, April 14, 2009 9:54 AM
> To: dm-devel@redhat.com
> Subject: [dm-devel] Dell MD3000i issues with dm mp
>=20
> Greetings everyone, I have a RHEL 5.3 host attached to two Dell MD3000i=
 storage arrays via iscsi.  I=92m having some interesting issues upon boo=
tup in this setup.  Between the two arrays I=92m accessing 24 luns so aft=
er my iscsi service kicks in I get tons and tons of I/O error messages go=
ing across the screen.  This can go on for 15-20 minutes or longer.  It w=
ould appear that some I/O is being sent to the passive paths and they are=
 returning errors.  It would seem the scsi layer is doing its thing to sc=
an for partitions and probably causing the I/O that is being seen.  Is th=
ere any way to suppress/avoid this scenario?  Also, I thought I would pos=
t my multipath.conf file just to have some other eyes have a look at it a=
nd make sure I=92m not missing something obvious so that is below.  Thank=
s in advance!
>=20
>=20
> devices {
>         device {
>                vendor                  "DELL"
>                product                 "MD3000i"
>                features                 "0"
>                getuid_callout          "/sbin/scsi_id -g -u -s /block/%=
n"
>                prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
>                hardware_handler        "1 rdac"
>                path_grouping_policy    group_by_prio
>                failback                immediate
>                path_checker            rdac
>                prio                     "rdac"
>=20
>        }
> }
> multipaths {
>         mulitpath {
>                 device {
>                         vendor DELL
>                         product MD3000i
>                 }
>         }
> }
>=20
>=20
>=20
> -----------------------------------------------------------------------=
-
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
