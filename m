From: Neil Brown <neilb@suse.de>
Subject: Re: Queuing of dm-raid1 resyncs to the same underlying
	block devices
Date: Thu, 08 Oct 2015 08:42:50 +1100
Message-ID: <87fv1m8ied.fsf@notabene.neil.brown.name>
References: <20150926154902.GA2964@alpha.arachsys.com>
	<64020C6E-98B1-4139-A88C-0EC65493CCF9@redhat.com>
	<560BEB14.3060701@redhat.com>
	<87si5vk0rz.fsf@notabene.neil.brown.name>
	<560D0668.50300@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8178894731088940112=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <560D0668.50300@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8178894731088940112==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

Heinz Mauelshagen <heinzm@redhat.com> writes:

> On 10/01/2015 12:20 AM, Neil Brown wrote:
>> Heinz Mauelshagen <heinzm@redhat.com> writes:
>>> BTW:
>>> When you create a raid1/4/5/6/10 LVs _and_ never read what you have not
>>> written,
>>> "--nosync" can be used anyway in order to avoid the initial
>>> resynchronization load
>>> on the devices. Any data written in that case will update all
>>> mirrors/raid redundancy data.
>>>
>> While this is true for RAID1 and RAID10, and (I think) for the current
>> implementation of RAID6, it is definitely not true for RAID4/5.
>
> Thanks for the clarification.
>
> I find that to be really bad situation.
>
>
>>
>> For RAID4/5 a single-block write will be handled by reading
>> old-data/parity, subtracting the old data from the parity and adding the
>> new data, then writing out new data/parity.
>
> Obviously for optimization reasons.
>
>> So if the parity was wrong before, it will be wrong afterwards.
>
> So even overwriting complete stripes in raid4/5/(6)
> would not ensure correct parity, thus always requiring
> initial sync.

No, over-writing complete stripes will result in correct parity.
Even writing more than half of the data in a stripe will result in
correct parity.

So if you have a filesystem which only ever writes full stripes, then
there is no need to sync at the start.  But I don't know any filesysetms
which promise that.

If you don't sync at creation time, then you may be perfectly safe when
a device fails, but I can't promise that.  And without guarantees, RAID
is fairly pointless.

>
> We should think about a solution to avoid it in lieu
> of growing disk/array sizes.

With spinning-rust devices you need to read the entire array ("scrub")
every few weeks just to make sure the media isn't degrading.  When you
do that it is useful to check that the parity is still correct - as a
potential warning sign of problems.
If you don't sync first, then checking the parity doesn't tell you
anything.
And as you have to process the entire array occasionally anyway, you
make as well do it at creation time.

NeilBrown


>
>
> Heinz
>
>
>>
>> If the device that new data was written to then fails, the data on it is
>> lost.
>>
>> So do this for RAID1/10 if you like, but not for other levels.
>>
>> NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWFZHaAAoJEDnsnt1WYoG588sP/2lZtIPI77XLUZeDz1L5v6Hl
27wYea+JOfAbk+4Jdaw4/fUsGKvU3TBGNQwWUy746t1elkSU0pbyOk2I8PrlhbXr
9kBNaCQEuxPAJcdQkh8d4brIF0HAsrv6Ufkjc7Dq61GJUjMz6gtsRb2J9vRqJ7yO
SVYS6AmqTUaVCHrZfgzlE9MVpT4aMV4GcnLrPIt/oC5ErljeilQRXhEbeAunI3IE
zB2aPmy6IQ7pYyhqcwjcT/U9hTl7+o6iHIbRY3TOejGlfUtEBSm/XYL6PX23xQmF
ON34Cbk3lpWjl5dcWkCZcwI2GPcEhzqtL/cwLkbdK4tHV83O7NoRu4FmXcKyyfud
x+eCFpY6eGQPPi8aXTqW9SjuN40qjrN8iSL5Q64RPtc9lCQ8Y6cKZEpx8D0Fkju0
pZj62fUiKatB94PJr/Vz8gcocV+n8T/OT6z3PlJe/eb4SQMRUl0nDw4tqywceZWQ
luKKTU+/hFn/bSL+9/Xgj1huz9XOilpbhfjCcpY0XWH/SxjTX0SL4+KUXZ5m459M
KbK2eQ+lyda+BQNWoVBTkCNAy/DBXfSszkyubCqShZsoLyzY8mVw8zTqlwV3j/WU
Xrd7c2cvOsG2dJhKrVLCFVadA3yq8JZLi2L9aCO6X8Bs/SpoDJjX6nDtkMJVdBpi
S/YKFYevGQF46Zj2zOfa
=tter
-----END PGP SIGNATURE-----
--=-=-=--


--===============8178894731088940112==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8178894731088940112==--
