From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Tue, 02 Dec 2008 01:05:00 -0500
Message-ID: <4934D00C.4030604@redhat.com>
References: <20081201110937.GA6287@rere.qmqm.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081201110937.GA6287@rere.qmqm.pl>
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

Micha=C5=82 Miros=C5=82aw wrote:
> 2008/12/1 Takahiro Yasui <tyasui@redhat.com>:
>> Phillip Susi wrote:
> [...]
>>> Right... and when recording a log on every disk in the mirror, each c=
opy
>>> of the log may not contain exactly the same information at any given
>>> time.  If you write to one disk in the mirror first, then you need to
>>> mark the region as dirty on that disk first, so that if the system
>>> crashes before you can copy the data to the other mirror, you can see
>>> that the first disk is more up to date than the second disk.
>>>
>>> In other words, knowing that a region is or is not synchronized acros=
s
>>> each disk is not enough; if they are out of sync you need to figure o=
ut
>>> which disk has the most current information so it can be replicated t=
o
>>> the others, don't you?
>>>
>>> Or do you just always write to the first disk first, and assume it ha=
s
>>> the most recent data if the region was marked as dirty in ANY of the =
logs?
>> log disks are updated in parallel and we do not know which disk has th=
e
>> latest and correct data if the system crashes during write operations
>> on log devices. But there is no problem about it.
>>
>> There are two cases we need to think about.
>>
>> 1) Some log devices contain "clean", but mirror devices are not synchr=
onized
>>
>> This case is problematic, but never happens, because data is written o=
n
>> mirror devices after marking log devices "dirty", and make it "clean"
>> after write I/Os on mirror devices completed and mirrors get synchroni=
zed.
>>
>> 2) Some log devices contain "dirty", but mirror devices are synchroniz=
ed
>>
>> This case may happen but is not problematic. Just data replication of
>> the region among mirror devices will be done when the mirror is resume=
d.
>> This case would also happen on the system with the current single log =
if
>> the system crashes after marking a log device "dirty" and before marki=
ng
>> it back to "clean".
>=20
> What happens if some log devices contain "dirty" and not all mirrors we=
re written
> yet before a crash? How do you know which mirror has the most recent da=
ta?
> Are the writes to mirrors ordered somehow?

What happens if it is a raw device rather than dm-mirror? The I/O has
not completed yet and the request has not returned to the upper layer.
If system crashed at this point, no one knows which data, new or old,
is on the device, and application such as database should be responsible
for the transaction if necessary.

In the situation on dm-mirror you asked, we do not know which mirror
has the latest data, but I think that it is not a problem.

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America) Inc.
