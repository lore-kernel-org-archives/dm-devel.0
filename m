From: Milan Broz <mbroz@redhat.com>
Subject: Re: bio too big device md0 (248 > 240) - lvm on top of
	raid1
Date: Mon, 07 Apr 2008 09:34:51 +0200
Message-ID: <47F9CE9B.80205@redhat.com>
References: <87ejgv27nb.fsf@thialfi.karme-net.hirschau>	<46F0DF57.7060207@redhat.com>
	<87tzier9yr.fsf@thialfi.karme-net.hirschau>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87tzier9yr.fsf@thialfi.karme-net.hirschau>
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

Jens Thiele wrote:
>>> A related thread on dm-devel about a patch that probably doesn't help:
>>> "[dm-devel] [2.6.22 PATCH 01/26] dm: merge max_hw_sector"
>>> http://www.redhat.com/archives/dm-devel/2007-May/msg00007.html
>>>
>>> Any news regarding this one?
>>> Should I file a bug on http://bugzilla.kernel.org/ ?
>>> (It seems there is no entry yet)
>> Yes,  if you can reproduce it, report it to bugzilla please.
>>
>> Please attach kernel version, "dmsetup table", syslog... etc. 
>> (you can use lvmdump command to grab all informantion and
>> attach it to the bug).
>>
>>> PS: if I have a LVM snapshot the message disappears
>> so please describe this too with informations above.
>>
>> Thanks,
>> Milan
> 
> Finally I managed to submit a bug report: #10407
> http://bugzilla.kernel.org/show_bug.cgi?id=10407

"From time to time I connect an external usb disk, that is part of the same
raid and do an incremental resync. (md1 raid with internal bitmap)."

What's probably happening see here  http://bugzilla.kernel.org/show_bug.cgi?id=9401#c3

Thanks,
Milan
--
mbroz@redhat.com
