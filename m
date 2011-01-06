From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH v3 0/8] dm-raid (raid456) target
Date: Thu, 6 Jan 2011 08:43:35 -0600
Message-ID: <D3D5994A-7CA9-43BE-8B81-A09139220A9E@redhat.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
	<20101221141443.5aea0b12@notabene.brown>
	<20110105223628.GA13164@redhat.com>
	<20110106214645.2bd321f4@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/mixed; boundary="===============8782997546418238379=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110106214645.2bd321f4@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids


--===============8782997546418238379==
Content-Type: multipart/alternative; boundary=Apple-Mail-4-337719772


--Apple-Mail-4-337719772
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit


On Jan 6, 2011, at 4:46 AM, NeilBrown wrote:
>
> Patches 1 and 2 aren't really needed - I feel inclined not to remove  
> that
> stuff until all the dust settles..  So I'll put them at the bottom  
> of my
> queue and bring them forward in a couple of releases if that seems
> appropriate.

No problem.

> Patch 3 I'll push out through my tree shortly.

thanks

> The rest I am happy with going out through 'dm' to -next and beyond  
> whenever
> you like.
>
> However I will take this opportunity to suggest that the raid  
> parameters
> might need a bit of review before they are finalised.
>
> The possible parameters are as follows:
> <chunk_size>		Chunk size in sectors.
> [[no]sync]		Force/Prevent RAID initialization
> [rebuild <idx>]	Rebuild the drive indicated by the index
> [daemon_sleep <ms>]	Time between bitmap daemon work to clear bits
> [min_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
> [max_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
> [max_write_behind <value>]		See '-write-behind=' (man mdadm)
> [stripe_cache <sectors>]		Stripe cache size for higher RAIDs
>
>
> 'rebuild idx' only allows one device to be rebuilt at a time.  With  
> RAID6 it
> is possible that two devices can be ready for rebuild, in which case  
> we would
> want to rebuild both of them.

In which case, you can specify the parameter twice:
"... rebuild 0 rebuild 1..."
No problem there, I think.

> Also if you stop an array during a rebuild you really want to start  
> again
> where you were up to.

This is kept in the superblock (forthcoming patches).  In the case  
where metadata devices are not specified (or can't be specified, as in  
this initial set of patches), the user has two choices: 1) allow the  
array to completely resync, or 2) specify [no]sync.

> Most general solution would be to combine the rebuild information  
> with the
> list of component devices - either a sector number or something to  
> indicate
> that the rebuild it complete (which could be just a v.big sector  
> number).

Is there something more to this, or is the above comment suitable for  
this also?

> I'd much prefer 'daemon_sleep' to be in seconds, we decimals  
> supported if
> needed.

I had this in seconds originally, but device-mapper tables already  
have a precedent for specifying things in ms.  We don't want to have  
each target pick their own units.  (A similar thing can be said for  
values given in sectors.  We may have wanted kiB or B, but sectors is  
the standard.)

>
> Also:
>
> 3:	<#raid_devs> <meta_dev1> <dev1> .. <meta_devN> <devN>
>
> This doesn't allow offsets into the various devices like dm-stripe,
> dm-linear, dm-raid1 all do.

This is a conscious choice.  The offset was discarded because it is  
unneeded.

  brassow
--Apple-Mail-4-337719772
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><br><div><div>On Jan 6, 2011, =
at 4:46 AM, NeilBrown wrote:</div><blockquote type=3D"cite"><div><font =
class=3D"Apple-style-span" color=3D"#000000"><br></font>Patches 1 and 2 =
aren't really needed - I feel inclined not to remove that<br>stuff until =
all the dust settles.. &nbsp;So I'll put them at the bottom of =
my<br>queue and bring them forward in a couple of releases if that =
seems<br>appropriate.<br></div></blockquote><div><br></div><div>No =
problem.</div><br><blockquote type=3D"cite"><div>Patch 3 I'll push out =
through my tree =
shortly.<br></div></blockquote><div><br></div>thanks</div><div><br><blockq=
uote type=3D"cite"><div>The rest I am happy with going out through 'dm' =
to -next and beyond whenever<br>you like.<br><br>However I will take =
this opportunity to suggest that the raid parameters<br>might need a bit =
of review before they are finalised.<br><br>The possible parameters are =
as follows:<br> &lt;chunk_size&gt;<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>Chunk size in sectors.<br> =
[[no]sync]<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>Force/Prevent RAID initialization<br> [rebuild &lt;idx&gt;]<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>Rebuild =
the drive indicated by the index<br> [daemon_sleep &lt;ms&gt;]<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>Time =
between bitmap daemon work to clear bits<br> [min_recovery_rate =
&lt;kB/sec/disk&gt;]<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>Throttle RAID initialization<br> =
[max_recovery_rate &lt;kB/sec/disk&gt;]<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>Throttle RAID initialization<br> =
[max_write_behind &lt;value&gt;]<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>See '-write-behind=3D' (man =
mdadm)<br> [stripe_cache &lt;sectors&gt;]<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>Stripe cache size for higher =
RAIDs<br><br><br>'rebuild idx' only allows one device to be rebuilt at a =
time. &nbsp;With RAID6 it<br>is possible that two devices can be ready =
for rebuild, in which case we would<br>want to rebuild both of =
them.<br></div></blockquote><div><br></div><div>In which case, you can =
specify the parameter twice:</div><div>"... rebuild 0 rebuild =
1..."</div><div>No problem there, I think.</div><br><blockquote =
type=3D"cite"><div>Also if you stop an array during a rebuild you really =
want to start again<br>where you were up =
to.<br></div></blockquote><div><br></div><div>This is kept in the =
superblock (forthcoming patches). &nbsp;In the case where metadata =
devices are not specified (or can't be specified, as in this initial set =
of patches), the user has two choices: 1) allow the array to completely =
resync, or 2) specify [no]sync.</div><br><blockquote =
type=3D"cite"><div>Most general solution would be to combine the rebuild =
information with the<br>list of component devices - either a sector =
number or something to indicate<br>that the rebuild it complete (which =
could be just a v.big sector =
number).<br></div></blockquote><div><br></div><div>Is there something =
more to this, or is the above comment suitable for this =
also?</div><br><blockquote type=3D"cite"><div>I'd much prefer =
'daemon_sleep' to be in seconds, we decimals supported =
if<br>needed.<br></div></blockquote><div><br></div><div>I had this in =
seconds originally, but device-mapper tables already have a precedent =
for specifying things in ms. &nbsp;We don't want to have each target =
pick their own units. &nbsp;(A similar thing can be said for values =
given in sectors. &nbsp;We may have wanted kiB or B, but sectors is the =
standard.)</div><br><blockquote =
type=3D"cite"><div><br>Also:<br><br>3:<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>&lt;#raid_devs&gt; =
&lt;meta_dev1&gt; &lt;dev1&gt; .. &lt;meta_devN&gt; =
&lt;devN&gt;<br><br>This doesn't allow offsets into the various devices =
like dm-stripe,<br>dm-linear, dm-raid1 all =
do.<br></div></blockquote><div><br></div><div>This is a conscious =
choice. &nbsp;The offset was discarded because it is =
unneeded.</div><div><br></div><div>&nbsp;brassow</div></div></body></html>=

--Apple-Mail-4-337719772--


--===============8782997546418238379==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8782997546418238379==--
