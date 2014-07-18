From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Fri, 18 Jul 2014 08:00:48 +0200
Message-ID: <53C8B810.2060206@suse.de>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
	<20131218140858.GC17730@redhat.com> <52B1B046.3040301@suse.de>
	<1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<20140718000411.GB337@redhat.com>
	<20140718002319.GA20071@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140718002319.GA20071@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, "Stewart, Sean" <Sean.Stewart@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>, Bryn Reeves <breeves@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 07/18/2014 02:23 AM, Mike Snitzer wrote:
> On Thu, Jul 17 2014 at  8:04pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> Revisiting this can of worms...
>>
>> As part of full due-diligence on the approach that SUSE and NetApp have
>> seemingly enjoyed "for years" I reviewed Hannes' v3 patch, fixed one
>> issue and did some cleanup.  I then converted over to using a slightly
>> different approach where-in the DM core becomes a more willing
>> co-conspirator in this hack by introducing the ability to have
>> place-holder devices (dm_dev without an opened bdev) referenced in a DM
>> table.  The work is here:
>> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=3Dt=
hrowaway-dm-mpath-placeholder-devs
>
> Here is the rolled up patch (the individual commits in the above branch
> are rather noisy given the sequencing):
>
>   drivers/md/dm-mpath.c | 51 +++++++++++++++++++++++++++++++++-----------=
-----
>   drivers/md/dm-table.c | 53 ++++++++++++++++++++++++++++++++++++++------=
-------
>   drivers/md/dm.c       |  5 ++---
>   drivers/md/dm.h       | 12 ++++++++++++
>   4 files changed, 89 insertions(+), 32 deletions(-)
>
These patches look quite okay; I'll be cross-checking with my =

version and do some testing there.

Will be sending some update once the testing is done.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
