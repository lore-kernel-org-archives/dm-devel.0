From: Mike Burns <mburns-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ovirt-devel] blockdev --flushbufs required [was:
 parted issue/question
Date: Wed, 18 Jan 2012 08:58:01 -0500
Message-ID: <1326895081.27879.0.camel@beelzebub.mburnsfire.net>
References: <4F13ADB3.5070806@redhat.com> <87lip6t157.fsf@rho.meyering.net>
	<20120118003802.GA11769@agk-dp.fab.redhat.com>
	<87haztruph.fsf_-_@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <node-devel-bounces-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <87haztruph.fsf_-_-CybKA8TIZ99x3y/oJEDuiw@public.gmane.org>
List-Unsubscribe: <http://lists.ovirt.org/mailman/options/node-devel>,
	<mailto:node-devel-request-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.ovirt.org/pipermail/node-devel/>
List-Post: <mailto:node-devel-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:node-devel-request-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <http://lists.ovirt.org/mailman/listinfo/node-devel>,
	<mailto:node-devel-request-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: node-devel-bounces-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org
Errors-To: node-devel-bounces-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org
To: Jim Meyering <jim-Oxw1nKZkIVjk1uMJSBkQmQ@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, node-devel <node-devel-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org>
List-Id: dm-devel.ids

Thanks Jim

Moving to correct ovirt-node mailing list (node-devel-dEQiMlfYlSzYtjvyW6yDsg@public.gmane.org)

On Wed, 2012-01-18 at 14:44 +0100, Jim Meyering wrote:
> [Following up on this thread:
>  http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/14999]
> 
> Alasdair G Kergon wrote:
> > Try
> >   blkdev --flushbufs
> > after any cmd that writes to a dev to see if that makes any difference.
> 
> Thanks for the work-around.
> Using "blockdev --flushbufs $dev" does indeed make parted
> behave the same with dm-backed storage as with other devices.
> 
> Adjusting my small example,
> 
>   cd /tmp; truncate -s 10m g && loop=$(losetup --show -f g)
>   echo 0 100 linear $loop 0 | dmsetup create zub
>   dev=/dev/mapper/zub
>   parted -s $dev \
>     mklabel gpt \
>     mkpart efi 34s 34s \
>     mkpart root 35s 35s \
>     mkpart roo2 36s 36s \
>     u s p
>   blockdev --flushbufs $dev # FIXME: required with device-mapper-1.02.65-5
> 
>   # write random bits to p1
>   dd of=${dev}p1 if=/dev/urandom count=1
>   dd if=${dev}p1 of=p1-copy.pre count=1
>   parted -s $dev mkpart p4 37s 37s
>   blockdev --flushbufs $dev # FIXME: required with device-mapper-1.02.65-5
> 
>   dd if=${dev}p1 of=p1-copy.post count=1
>   cmp -l p1-copy.pre p1-copy.post
> 
> With that, the "cmp" show no differences.
> 
> Does this sound like a problem in device-mapper land,
> or in how parted interacts with DM?
> 
> _______________________________________________
> ovirt-devel mailing list
> ovirt-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> https://www.redhat.com/mailman/listinfo/ovirt-devel
