From: "John Stoffel" <john@stoffel.org>
Subject: Re: Possible bug in mirror target
Date: Sun, 10 Feb 2019 16:58:06 -0500
Message-ID: <23648.40558.660430.523285@quad.stoffel.home>
References: <CAN-y+EKdQnRWck4B3Ms0ZGHqEL4+V+xPb-G3vhPy+Qe0DMO0oA@mail.gmail.com>
	<27e658d7-265f-b765-1b19-d61f52da8457@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <27e658d7-265f-b765-1b19-d61f52da8457@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com, Drew Hastings <dhastings@crucialwebhost.com>
List-Id: dm-devel.ids

>>>>> "Zdenek" =3D=3D Zdenek Kabelac <zkabelac@redhat.com> writes:

Zdenek> Dne 05. 02. 19 v 1:47 Drew Hastings napsal(a):
>> Hi,
>> =

>> I'm assuming all user space code is expected to use the handle_errors fe=
ature, =

>> so this isn't that big of a deal. I'm also using 4.19.13, which I think =
is =

>> more recent than the latest update to=A0dm-raid1.c
>> =

>> That said, there may be a bug that causes the entire mirror to crash if =
there =

>> is an error on the first leg of the mirror, but not on the 2nd leg.
>> =

>> Works fine if you do cause IO errors on the 2nd leg:
>> =

>> root@kernel-dev:~# dmsetup create zerodev --table "0 1073741824 zero"
>> root@kernel-dev:~# dmsetup create errordev --table "0 1073741824 error"
>> =

>> =

>> root@kernel-dev:~# dmsetup create mirror-table --table "0 1073741824 mir=
ror =

>> core 2 524288 nosync 2 /dev/mapper/zerodev 0 /dev/mapper/errordev 0 0"

Zdenek> There are 2 operational modes for old dm mirror target.
Zdenek> One requires to handle errors externally. Please check i.e. the fol=
lowing =

Zdenek> guide for mirror target:

Zdenek> https://wiki.gentoo.org/wiki/Device-mapper

Zdenek> Lvm2 is using 'dmeventd' to service this error handling
Zdenek> (i.e. dropping the mirror leg or allocating replacement one).

Is it time to remove the dm-mirror target then?  Or to deprecate it?
Or to just silently replace it with something that does the right
thing when errors happen?  I can't think of why *anyone* would want to
use the dm-mirror target as it now seems to work.

John
