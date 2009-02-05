From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: Multipath setup and rdac questions
Date: Thu, 5 Feb 2009 09:52:20 -0800
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4663975FE@cosmail01.lsi.com>
References: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>
	<498B00B3.5020402@redhat.com>
	<E463DF2B2E584B4A82673F53D62C2EF4663975E3@cosmail01.lsi.com>
	<498B259B.5070703@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <498B259B.5070703@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmr@redhat.com" <bmr@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Please run  "cat /proc/scsi/scsi"

Thanks
Babu Moger=20

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On=
 Behalf Of Bryn M. Reeves
Sent: Thursday, February 05, 2009 11:45 AM
To: device-mapper development
Subject: Re: [dm-devel] Multipath setup and rdac questions

Moger, Babu wrote:
> Like Bryn said, you cannot have both MPP and device mapper together. MP=
P will be the first one to load. So it will claim all the devices.
>=20
> I have modified your multipath.conf file. Please try this one below.=20
>=20
> devices {
>   device {
>                 vendor                  "DELL"
>                 product                 "MD3000i"

Are these actually correct? The -ll output the OP posted seemed to=20
indicate his settings were being completely ignored (which usually=20
suggests a vendor/product mismatch).

It would be good to get all the correct vendor/product details for the=20
3000 models included upstream at some point so that users don't need=20
to add their own device blocks.

Regards,
Bryn.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
