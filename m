From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Data corruption on software RAID
Date: Thu, 10 Apr 2008 10:21:01 -0400
Message-ID: <47FE224D.2020309@tmr.com>
References: <Pine.LNX.4.64.0804080033430.13352@artax.karlin.mff.cuni.cz>
	<47FD0BE8.4070105@tmr.com>
	<Pine.LNX.4.64.0804100503160.26713@artax.karlin.mff.cuni.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1478709713=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0804100503160.26713@artax.karlin.mff.cuni.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, mingo@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============1478709713==
Content-Type: multipart/alternative;
	boundary="------------030701030002070602070904"

This is a multi-part message in MIME format.
--------------030701030002070602070904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mikulas Patocka wrote:
>>> Possibilities how to fix it:
>>>
>>> 1. lock the buffers and pages while they are being written --- this would
>>> cause performance degradation (the most severe degradation would be in case
>>> when one process does repeatedly sync() and other unrelated process
>>> repeatedly writes to some file).
>>>
>>> Lock the buffers and pages only for RAID --- would create many special cases
>>> and possible bugs.
>>>
>>> 2. never turn the region dirty bit off until the filesystem is unmounted.
>>> --- this is the simplest fix. If the computer crashes after a long time, it
>>> resynchronizes the whole device. But there won't cause application-visible
>>> or filesystem-visible data corruption.
>>>
>>> 3. turn off the region bit if the region wasn't written in one pdflush
>>> period --- requires an interaction with pdflush, rather complex. The problem
>>> here is that pdflush makes its best effort to write data in
>>> dirty_writeback_centisecs interval, but it is not guaranteed to do it.
>>>
>>> 4. make more region states: Region has in-memory states CLEAN, DIRTY,
>>> MAYBE_DIRTY, CLEAN_CANDIDATE.
>>>
>>> When you start writing to the region, it is always moved to DIRTY state (and
>>> on-disk bit is turned on).
>>>
>>> When you finish all writes to the region, move it to MAYBE_DIRTY state, but
>>> leave bit on disk on. We now don't know if the region is dirty or no.
>>>
>>> Run a helper thread that does periodically:
>>> Change MAYBE_DIRTY regions to CLEAN_CANDIDATE
>>> Issue sync()
>>> Change CLEAN_CANDIDATE regions to CLEAN state and clear their on-disk bit.
>>>
>>> The rationale is that if the above write-while-modify scenario happens, the
>>> page is always dirty. Thus, sync() will write the page, kick the region back
>>> from CLEAN_CANDIDATE to MAYBE_DIRTY state and we won't mark the region as
>>> clean on disk.
>>>
>>>
>>> I'd like to know you ideas on this, before we start coding a solution.
>>>   
>>>       
>> I looked at just this problem a while ago, and came to the conclusion that
>> what was needed was a COW bit, to show that there was i/o in flight, and that
>> before modification it needed to be copied. Since you don't want to let that
>> recurse, you don't start writing the copy until the original is written and
>> freed. Ideally you wouldn't bother to finish writing the original, but that
>> doesn't seem possible. That allows at most two copies of a chunk to take up
>> memory space at once, although it's still ugly and can be a bottleneck.
>>     
>
> Copying the data would be performance overkill. You can really write 
> different data to different disks, you just must not forget to resync them 
> after a crash. The filesystem/application will recover with either old or 
> new data --- it just won't recover when it's reading old and new data from 
> the same location.
>
>   
Currently you can go for hours without ever reaching a clean state on 
active files. By not deliberately allowing the buffer to change during a 
write the chances for getting consistent data on the disk should be 
significantly improved.
> >From my point of view that trick with thread doing sync() and turning off 
> region bits looks best. I'd like to know if that solution doesn't have any 
> other flaw.
>
>   
>> For reliable operation I would want all copies (and/or CRCs) to be written on
>> an fsync, by the time I bother to fsync I really, really, want the data on the
>> disk.
>>     
>
> fsync already works this way.
>   

The point I was making is that after you change the code I would still 
want that to happen. And your comment above seems to indicate a goal of 
getting consistent data after a crash, with less concern that it be the 
most recent data written. Sorry in advance if that's a misreading of 
"you just must not forget to resync them after a crash."

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 



--------------030701030002070602070904
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Mikulas Patocka wrote:
<blockquote
 cite="midPine.LNX.4.64.0804100503160.26713@artax.karlin.mff.cuni.cz"
 type="cite">
  <blockquote type="cite">
    <blockquote type="cite">
      <pre wrap="">Possibilities how to fix it:

1. lock the buffers and pages while they are being written --- this would
cause performance degradation (the most severe degradation would be in case
when one process does repeatedly sync() and other unrelated process
repeatedly writes to some file).

Lock the buffers and pages only for RAID --- would create many special cases
and possible bugs.

2. never turn the region dirty bit off until the filesystem is unmounted.
--- this is the simplest fix. If the computer crashes after a long time, it
resynchronizes the whole device. But there won't cause application-visible
or filesystem-visible data corruption.

3. turn off the region bit if the region wasn't written in one pdflush
period --- requires an interaction with pdflush, rather complex. The problem
here is that pdflush makes its best effort to write data in
dirty_writeback_centisecs interval, but it is not guaranteed to do it.

4. make more region states: Region has in-memory states CLEAN, DIRTY,
MAYBE_DIRTY, CLEAN_CANDIDATE.

When you start writing to the region, it is always moved to DIRTY state (and
on-disk bit is turned on).

When you finish all writes to the region, move it to MAYBE_DIRTY state, but
leave bit on disk on. We now don't know if the region is dirty or no.

Run a helper thread that does periodically:
Change MAYBE_DIRTY regions to CLEAN_CANDIDATE
Issue sync()
Change CLEAN_CANDIDATE regions to CLEAN state and clear their on-disk bit.

The rationale is that if the above write-while-modify scenario happens, the
page is always dirty. Thus, sync() will write the page, kick the region back
from CLEAN_CANDIDATE to MAYBE_DIRTY state and we won't mark the region as
clean on disk.


I'd like to know you ideas on this, before we start coding a solution.
  
      </pre>
    </blockquote>
    <pre wrap="">I looked at just this problem a while ago, and came to the conclusion that
what was needed was a COW bit, to show that there was i/o in flight, and that
before modification it needed to be copied. Since you don't want to let that
recurse, you don't start writing the copy until the original is written and
freed. Ideally you wouldn't bother to finish writing the original, but that
doesn't seem possible. That allows at most two copies of a chunk to take up
memory space at once, although it's still ugly and can be a bottleneck.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Copying the data would be performance overkill. You can really write 
different data to different disks, you just must not forget to resync them 
after a crash. The filesystem/application will recover with either old or 
new data --- it just won't recover when it's reading old and new data from 
the same location.

  </pre>
</blockquote>
Currently you can go for hours without ever reaching a clean state on
active files. By not deliberately allowing the buffer to change during
a write the chances for getting consistent data on the disk should be
significantly improved.<br>
<blockquote
 cite="midPine.LNX.4.64.0804100503160.26713@artax.karlin.mff.cuni.cz"
 type="cite">
  <pre wrap="">&gt;From my point of view that trick with thread doing sync() and turning off 
region bits looks best. I'd like to know if that solution doesn't have any 
other flaw.

  </pre>
  <blockquote type="cite">
    <pre wrap="">For reliable operation I would want all copies (and/or CRCs) to be written on
an fsync, by the time I bother to fsync I really, really, want the data on the
disk.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
fsync already works this way.
  </pre>
</blockquote>
<br>
The point I was making is that after you change the code I would still
want that to happen. And your comment above seems to indicate a goal of
getting consistent data after a crash, with less concern that it be the
most recent data written. Sorry in advance if that's a misreading of
"you just must not forget to resync them after a crash."<br>
<pre class="moz-signature" cols="72">-- 
Bill Davidsen <a class="moz-txt-link-rfc2396E" href="mailto:davidsen@tmr.com">&lt;davidsen@tmr.com&gt;</a>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 

</pre>
</body>
</html>

--------------030701030002070602070904--


--===============1478709713==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1478709713==--
