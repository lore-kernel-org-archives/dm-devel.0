From: Ben England <bengland@redhat.com>
Subject: Re: getting feedback on dm-cache statistics tool
Date: Fri, 27 May 2016 11:49:02 -0400 (EDT)
Message-ID: <1482645094.66517214.1464364142987.JavaMail.zimbra@redhat.com>
References: <2055307845.66145553.1464277400592.JavaMail.zimbra@redhat.com>
	<1521667453.66151545.1464278400970.JavaMail.zimbra@redhat.com>
	<22344.25767.751922.249548@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <22344.25767.751922.249548@quad.stoffel.home>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Stoffel <john@stoffel.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

John, thanks for reply, comments inline...

----- Original Message -----
> From: "John Stoffel" <john@stoffel.org>
> To: "Ben England" <bengland@redhat.com>
> Cc: dm-devel@redhat.com
> Sent: Friday, May 27, 2016 11:15:51 AM
> Subject: Re: [dm-devel] getting feedback on dm-cache statistics tool
> 
> 
> Ben> I have a git repo containing a tool I wrote to look at dm-cache
> Ben> statistics, not the raw counters in "dmsetup status" but derived
> Ben> values that are more directly useful to system administrators and
> Ben> developers that want to see whether dm-cache is doing what they
> Ben> want it to.  https://github.com/bengland2/dmcache-stat
> 
> Ben> Any feedback on this?  Anything missing?  I don't mind adding or
> Ben> taking pull requests.  If some other tool can provide the same
> Ben> functionality within RHEL then I'm happy to use that.
> 
> I'm using Debian Jessie on x86_64 running kernel 4.4.0-rc7 (self
> compiled) and it's dying with an error:
> 

I don't have a Debian system handy, can you do "dmsetup status" on it and mail me the log so I know what the format difference is?


>     > sudo ./dmcache_stat.py 10 0
>     volname, size(GiB), policy, mode
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVLvpBly2guNYp3XUqTVCgGCHequQOBEf9"
>     should be mangled b.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVkuRxXnQASgLcdsdFmK9OviYa88Q6buOU"
>     should be mangled b.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVM32OGu9FYyW2J5u8Q1zSNh826zw6BnFX"
>     should be mangled b.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVabjo7c4R5l6twigsqqfc55LVN6XVag4W-cdata"
>     should be man.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVIWMZ8hjG32sj1LIdQja6QWB4OWkUvUCl"
>     should be mangled b.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVkOhak3U4uF82eWXH5JY1F3VhHzMHYV8c-cmeta"
>     should be man.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVR1c11WDl2e86Ko9OmuWYRIUNXExHQnX1"
>     should be mangled b.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVvdF6NWzpggiPLD202jpru363Z5LfB5Lo"
>     should be mangled b.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wV40890zsM04q5zMIs0qdeCDfG9fc9FwbF"
>     should be mangled b.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVrdBEgHTcrXLHDWNrbFotKPeLt2TfbRVo"
>     should be mangled b.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVi37feovUsvWbysOk8PI2bbdjqokieGx2-cdata"
>     should be man.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVnp1To0klyekIS85gueDeq2EsYg5Osj44"
>     should be mangled b.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVas2sZsZM8mw0VXDgx03ryaq351RUEL4j-cmeta"
>     should be man.
>     The UUID
>     "LVM-HWDbRMPFL85!mVbEi4wru5#G7YfWK3wVbbcg3pVFZyDngdRLS4aECbc571Lyb5MI"
>     should be mangled b.
>     Command failed
>     Traceback (most recent call last):
>       File "./dmcache_stat.py", line 198, in <module>
> 	  s2 = poll_dmcache()
>       File "./dmcache_stat.py", line 172, in poll_dmcache
> 	dmsetup_out = subprocess.check_output(['dmsetup', 'status'])
>       File "/usr/lib/python2.7/subprocess.py", line 573, in check_output
> 	raise CalledProcessError(retcode, cmd, output=output)
>       subprocess.CalledProcessError: Command '['dmsetup', 'status']' returned
>       non-zero exit status 1
> 
> 
> But this is partly because my UUIDs aren't being handled properly and I've
> been loathe to follow the process for rebuilding them because I'm scared.
> And it's my main fileserver.  Maybe this weekend if I have time.
> 
> 
> The other comment is that the usage should be more like:
> 
>     dmcache-stat <interval> [<count>]
> 

That's quite reasonable and easily done - will get to it soon.

> where if you don't provide the count, it defaults to going forever, like
> iostat/vmstat, etc.
> 
> And now that I think of it, I'm using lvmcache, not dmcache or bcache...

I thought LVMcache was just a way of persisting dm-cache volumes across reboots and managing them with LVM, not functionally different underneath.

> 
> > sudo lvs
>   LV           VG     Attr       LSize   Pool         Origin        Data%
>   Meta%  Move Log Cpy%Synct
>     backups      bacula -wi-ao----   2.73t
>     incrs        bacula -wi-ao----   2.64t
>     drupal       data   -wi-ao----  50.00g
>     home         data   Cwi-aoC--- 550.00g homecacheLV  [home_corig]
>     homecacheLV  data   Cwi---C---  50.00g
>     local        data   Cwi-aoC--- 335.00g localcacheLV [local_corig]
>     localcacheLV data   Cwi---C---  50.00g
>     minecraft    data   -wc-ao----  20.00g
>     nas          data   -wi-ao---- 600.00g
>     pete         data   -wi-a----- 800.00g
>     vm1          data   -wc-ao----  20.00g
>     winxp        data   -wi-a----- 170.00g
>     root         quad   -wi-ao----  37.25g
>     swap_1       quad   -wi-ao----   7.45g
>     var          quad   -wi-ao----  58.62g
> 
> Though looking at this list, I really should just nuke that ancient WinXP VM
> image I have.  LOL.
> 
> 
