From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Possible bug in mirror target
Date: Wed, 13 Feb 2019 15:21:52 +0100
Message-ID: <64d236db-20d9-35f6-83d8-bf81cb4b8fb5@redhat.com>
References: <CAN-y+EKdQnRWck4B3Ms0ZGHqEL4+V+xPb-G3vhPy+Qe0DMO0oA@mail.gmail.com>
	<27e658d7-265f-b765-1b19-d61f52da8457@redhat.com>
	<23648.40558.660430.523285@quad.stoffel.home>
	<84219415-de11-5b28-ec2f-68ee7e74c4b0@redhat.com>
	<23651.19067.298943.820452@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <23651.19067.298943.820452@quad.stoffel.home>
Content-Language: en-US
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
Cc: dm-devel@redhat.com, Drew Hastings <dhastings@crucialwebhost.com>
List-Id: dm-devel.ids

Hi

Dne 12. 02. 19 v 23:36 John Stoffel napsal(a):
>>>>>> "Zdenek" == Zdenek Kabelac <zkabelac@redhat.com> writes:
> 
> Zdenek> Dne 10. 02. 19 v 22:58 John Stoffel napsal(a):
> 
> Zdenek> The old dm mirror works differently then new dm raid - so if
> Zdenek> you have an old one present/running (i.e. LVM mirrored volume)
> Zdenek> using this target - you need to have this target present to be
> Zdenek> able to access such volume.
> 
> Ok, I see that.  I just wonder if A) anyone still uses this target and
> B) if it should be deprecated since it doesn't provide the protections
> that the dm_raid target provides.

Well there is at least one existing user of old mirror target - and it's lvm2, 
  which is still actively  using it for pvmove operation - and there is not 
yet any new code to switch using mdraid - and it's not completely trivial
to make such change.

As said properties of each target are slightly different and number
of mdraid issue with regards of error detection needed by lvm2
have been fixed relatively recently (kernels >4.15)

> 
> Getting rid of legacy stuff isn't a bad thing... :-)
> 

Mirror target cannot be considered legacy stuff yet...

> Zdenek> You can (in lvm2) convert such mirror to use newer dm raid
> Zdenek> target - but this requires some extra space (even though very
> Zdenek> small metadata volume) which is now required per each mirrored
> Zdenek> leg.
> 
> Not a bad thing.

If you have this free space it's surely not a bad thing - but there
are many cases, you can get any free space - majority of filesystems
does not support shrinking - so the only 'free' space you can
get is by adding new storage to VG - again quite limiting factor.

> Zdenek> Both targets are still maintained and bugfixed.
> 
> Zdenek> There is also something about very high complexity of mdraid
> Zdenek> code and relative simplicity of old mirror target.
> 
> I'm thinking about the complexity of maintaing both in parallel, when
> the older one doesn't provide the protections of the newer one.

There is very little amount of work associated with maintenance of
old mirror target - as said it's relatively simple one.

I'm not sure about which missing protection you are talking about - write 
error is handled by user-space application - which has been a designed feature 
- so it's not missing - it just need to be correctly configured.

> 
> Zdenek> As for comment about *anyone* - majority of users are
> Zdenek> consuming DM targets via lvm2 - there you get this transition
> Zdenek> automatically - when you ask to create mirrored LV - lvm2 will
> Zdenek> use (if present in kernel) newer md raid variant.  If anyone
> Zdenek> is using DM directly with 'dmsetup' command - it's assumed
> Zdenek> these are skilled users familiar with kernel doc (dmsetup is
> Zdenek> low-level admins tool).  Lvm2 should be seen as
> Zdenek> 'friendly-face' of these DM targets - which otherwise do
> Zdenek> require pretty complex setup. If you do not want to use lvm2,
> Zdenek> the tool replacing lvm2 needs to reproduce this extra logic.
> 
> Right, so how many use the old version?

With lvm simplest way (with enabled monitoring - which is default):

lvcreate --type mirror -Lsize -m #MIRRORS -n LVNAME VGNAME

Regards

Zdenek
