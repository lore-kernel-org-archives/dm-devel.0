From: David Cramblett <david@functionalchaos.net>
Subject: Re: device mapper not finding all devices
Date: Tue, 19 Jul 2011 13:48:25 -0700
Message-ID: <CA+cRLp+MUdBg1J75Mv5BxNm1xrZRG5Cu4v4Y99hShEUONtQ0-Q@mail.gmail.com>
References: <CA+cRLpLs7CL4VeSw9YNGdTDOUG8mz=TpUuzyP=sWXpLiKywA+A@mail.gmail.com>
	<4E25D21E.8050901@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E25D21E.8050901@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Thanks for the response. I did figured out the issue a few days ago.
This was a CentOS 5.6 system, and 2.6.18 was the newest kernel I could
get for that distribution.  They did just release CentOS 6.0 and I was
trying to prepare for a migration when this issue arose.

I didn't even think I was using dmraid. Turns out that I created a
dmraid set a long time ago and then decided to replace with a spanned
logical volume.  I guess the metadata  was still on the disks and for
some reason it didn't bite me until I upgraded some software (not sure
which package it was) or made some type of change.  I deactivated
dmraid on the drives and the problem was gone.

Thanks!

David


On Tue, Jul 19, 2011 at 11:51 AM, Phillip Susi <psusi@cfl.rr.com> wrote:
> On 7/17/2011 3:03 PM, David Cramblett wrote:
>>
>> Current Software:
>> Linux 2.6.18-238.12.1.el5 #1 SMP Tue May 31 13:23:01 EDT 2011 i686
>> i686 i386 GNU/Linux
>> device-mapper-1.02.55-2.el5
>
> 2.6.18 is now 5 years old; it might be time to upgrade.
>
>> I did some research and the only info I could find was regarding dmsetup:
>>
>> #dmsetup status
>> pdc_eehgddjjp1: 0 976768002 linear
>> pdc_eehgddjj: 0 976772992 linear
>> via_cdeadaheebp1: 0 976768002 linear
>> via_cdeadaheeb: 0 1953546240 striped 2 8:0 8:16 1 AA
>>
>>
>> Looks like something is wrong with the vg0-lvol0 entry above, but I
>> can't figure out how to fix it. =A0There is also another HDD on each of
>
> You only seem to have 4 entries for two dmraid disks ( which is not well
> supported so you should not be using it unless you need to dual boot with
> windows ) and a partition on each. =A0It is also quite strange that the p=
dc
> array is using a linear mapping. =A0Could it be a degraded mirror?
>
>> the via and pdc controllers that are seen by the system, but not
>> showing up in the "status" list above. =A0There is also a disk connected
>> to PATA port "/dev/hda" that is part of the lvol.
>
> What disks are supposed to be LVM physical volumes? =A0The output of pvdi=
splay
> may prove useful. =A0An lvchange -ay might also be worthwhile.
>
>> The device-mapper device is being created for the lvol:
>>
>> =A0/dev/mapper/vg0-lvol0
>
> If it had actually been created, then it should show up in dmsetup status.
> =A0The system appears to be failing to create it.
>



-- =

David Cramblett
