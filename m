From: "John Stoffel" <john@stoffel.org>
Subject: Re: getting feedback on dm-cache statistics tool
Date: Fri, 27 May 2016 17:50:45 -0400
Message-ID: <22344.49461.846828.20125@quad.stoffel.home>
References: <2055307845.66145553.1464277400592.JavaMail.zimbra@redhat.com>
	<1521667453.66151545.1464278400970.JavaMail.zimbra@redhat.com>
	<22344.25767.751922.249548@quad.stoffel.home>
	<1482645094.66517214.1464364142987.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1482645094.66517214.1464364142987.JavaMail.zimbra@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ben England <bengland@redhat.com>
Cc: dm-devel@redhat.com, John Stoffel <john@stoffel.org>
List-Id: dm-devel.ids

>>>>> "Ben" == Ben England <bengland@redhat.com> writes:

Ben> John, thanks for reply, comments inline...
Ben> ----- Original Message -----
>> From: "John Stoffel" <john@stoffel.org>
>> To: "Ben England" <bengland@redhat.com>
>> Cc: dm-devel@redhat.com
>> Sent: Friday, May 27, 2016 11:15:51 AM
>> Subject: Re: [dm-devel] getting feedback on dm-cache statistics tool
>> 
>> 
Ben> I have a git repo containing a tool I wrote to look at dm-cache
Ben> statistics, not the raw counters in "dmsetup status" but derived
Ben> values that are more directly useful to system administrators and
Ben> developers that want to see whether dm-cache is doing what they
Ben> want it to.  https://github.com/bengland2/dmcache-stat
>> 
Ben> Any feedback on this?  Anything missing?  I don't mind adding or
Ben> taking pull requests.  If some other tool can provide the same
Ben> functionality within RHEL then I'm happy to use that.
>> 
>> I'm using Debian Jessie on x86_64 running kernel 4.4.0-rc7 (self
>> compiled) and it's dying with an error:
>> 

Ben> I don't have a Debian system handy, can you do "dmsetup status"
Ben> on it and mail me the log so I know what the format difference
Ben> is?

It's mostly because I think I have bad UUIDs on my LVM volumes,
because I've basically just upgraded this system for the past six
years, without building new volumes/LVMs.

Here's the output though:

> sudo dmsetup status
[sudo] password for john:
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVLvpBly2guNYp3XUqTVCgGCHequQOBEf9"
should be mangled b.
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVkuRxXnQASgLcdsdFmK9OviYa88Q6buOU"
should be mangled b.
quad-swap_1: 0 15622144 linear
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVM32OGu9FYyW2J5u8Q1zSNh826zw6BnFX"
should be mangled b.
quad-root: 0 78118912 linear
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVabjo7c4R5l6twigsqqfc55LVN6XVag4W-cdata"
should be man.
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVIWMZ8hjG32sj1LIdQja6QWB4OWkUvUCl"
should be mangled b.
bacula-backups: 0 5857345536 linear
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVkOhak3U4uF82eWXH5JY1F3VhHzMHYV8c-cmeta"
should be man.
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVR1c11WDl2e86Ko9OmuWYRIUNXExHQnX1"
should be mangled b.
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVvdF6NWzpggiPLD202jpru363Z5LfB5Lo"
should be mangled b.
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wV40890zsM04q5zMIs0qdeCDfG9fc9FwbF"
should be mangled b.
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVrdBEgHTcrXLHDWNrbFotKPeLt2TfbRVo"
should be mangled b.
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVi37feovUsvWbysOk8PI2bbdjqokieGx2-cdata"
should be man.
quad-var: 0 39059456 linear
quad-var: 39059456 83886080 linear
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVnp1To0klyekIS85gueDeq2EsYg5Osj44"
should be mangled b.
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVas2sZsZM8mw0VXDgx03ryaq351RUEL4j-cmeta"
should be man.
bacula-incrs: 0 5662310400 linear
The UUID
"LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVbbcg3pVFZyDngdRLS4aECbc571Lyb5MI"
should be mangled b.
Command failed



>> > sudo ./dmcache_stat.py 10 0
>> volname, size(GiB), policy, mode
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVLvpBly2guNYp3XUqTVCgGCHequQOBEf9"
>> should be mangled b.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVkuRxXnQASgLcdsdFmK9OviYa88Q6buOU"
>> should be mangled b.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVM32OGu9FYyW2J5u8Q1zSNh826zw6BnFX"
>> should be mangled b.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVabjo7c4R5l6twigsqqfc55LVN6XVag4W-cdata"
>> should be man.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVIWMZ8hjG32sj1LIdQja6QWB4OWkUvUCl"
>> should be mangled b.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVkOhak3U4uF82eWXH5JY1F3VhHzMHYV8c-cmeta"
>> should be man.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVR1c11WDl2e86Ko9OmuWYRIUNXExHQnX1"
>> should be mangled b.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVvdF6NWzpggiPLD202jpru363Z5LfB5Lo"
>> should be mangled b.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wV40890zsM04q5zMIs0qdeCDfG9fc9FwbF"
>> should be mangled b.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVrdBEgHTcrXLHDWNrbFotKPeLt2TfbRVo"
>> should be mangled b.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVi37feovUsvWbysOk8PI2bbdjqokieGx2-cdata"
>> should be man.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVnp1To0klyekIS85gueDeq2EsYg5Osj44"
>> should be mangled b.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVas2sZsZM8mw0VXDgx03ryaq351RUEL4j-cmeta"
>> should be man.
>> The UUID
>> "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVbbcg3pVFZyDngdRLS4aECbc571Lyb5MI"
>> should be mangled b.
>> Command failed
>> Traceback (most recent call last):
>> File "./dmcache_stat.py", line 198, in <module>
>> s2 = poll_dmcache()
>> File "./dmcache_stat.py", line 172, in poll_dmcache
>> dmsetup_out = subprocess.check_output(['dmsetup', 'status'])
>> File "/usr/lib/python2.7/subprocess.py", line 573, in check_output
>> raise CalledProcessError(retcode, cmd, output=output)
>> subprocess.CalledProcessError: Command '['dmsetup', 'status']' returned
>> non-zero exit status 1
>> 
>> 
>> But this is partly because my UUIDs aren't being handled properly and I've
>> been loathe to follow the process for rebuilding them because I'm scared.
>> And it's my main fileserver.  Maybe this weekend if I have time.
>> 
>> 
>> The other comment is that the usage should be more like:
>> 
>> dmcache-stat <interval> [<count>]
>> 

Ben> That's quite reasonable and easily done - will get to it soon.

>> where if you don't provide the count, it defaults to going forever, like
>> iostat/vmstat, etc.
>> 
>> And now that I think of it, I'm using lvmcache, not dmcache or bcache...

Ben> I thought LVMcache was just a way of persisting dm-cache volumes
Ben> across reboots and managing them with LVM, not functionally
Ben> different underneath.

Could be, I'm vague on the details.  And thinking about it, it must be
dmcache being used by lvmcache, because I distinctly choose to NOT use
bcache due to it's lack of flexibility.

I'm really looking for some way to quantify the speedup of
lvmcache/dmcache on my setup.

This weekend it's time to fix the UUIDs though.

John
