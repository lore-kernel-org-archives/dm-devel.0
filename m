From: Douglas McClendon <dmc.lists@filteredperception.org>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Sun, 27 Nov 2011 19:08:31 -0600
Message-ID: <4ED2DF0F.1070108@filteredperception.org>
References: <4EABE131.8010706@googlemail.com>	<20111029204947.GU23336@agk-dp.fab.redhat.com>
	<CAEcBt+Ux+GVmm7zBeFA7k5PHOQoSKLTKcifB95ne5dBtX400dQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEcBt+Ux+GVmm7zBeFA7k5PHOQoSKLTKcifB95ne5dBtX400dQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/27/2011 04:31 PM, Frederick Grose wrote:
> On Sat, Oct 29, 2011 at 4:49 PM, Alasdair G Kergon <agk@redhat.com
> <mailto:agk@redhat.com>> wrote:
>
>     markmc did some code that shows how to read the format a few years
>     ago here:
>     http://people.gnome.org/~markmc/code/merge-dm-snapshot.c
>     <http://people.gnome.org/%7Emarkmc/code/merge-dm-snapshot.c>
>
>     Otherwise look at dm-snap-persistent.c in the kernel tree.
>
>     Alasdair
>
>
> Users can easily exhaust a LiveUSB snapshot overlay by writing
> too many changes to the OS filesystem, such as by performing
> a yum update.
>
> Would such an 'exhausted' overlay be amenable to some sort of
> data recovery or forensics?
>
> If so, how so; if not, why not?

Can you not mount the exhausted dm snapshot?  If you mean data recovery 
or forensics beyond that, please elaborate.

I know I've had issues 'read-only' mounting ext3(2?3?4?) filesystems 
before (on actually read-only block devices).  Maybe some flags that 
I've forgotten get past that, but worst case you can always fake a 
writable device with a 2nd overlay/snapshot going to a writable device, 
i.e. if you wanted to let fsck repair things.

-dmc
