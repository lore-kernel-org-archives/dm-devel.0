From: James <purpleidea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Puppet-Gluster+ThinP
Date: Sun, 20 Apr 2014 20:11:08 -0400
Message-ID: <CADCaTgogBwyr9iYPV_oAAXFD=JKNqvm=PeJAwmqLJ_ksUn1Psw@mail.gmail.com>
References: <1397056420.4190.93.camel@freed>
	<1420171478.1325442.1397081884591.JavaMail.zimbra@redhat.com>
	<53545F62.8060001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <gluster-devel-bounces+gcfgd-gluster-devel=m.gmane.org-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
In-Reply-To: <53545F62.8060001-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/gluster-devel>,
	<mailto:gluster-devel-request-qX2TKyscuCcdnm+yROfE0A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/gluster-devel>
List-Post: <mailto:gluster-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
List-Help: <mailto:gluster-devel-request-qX2TKyscuCcdnm+yROfE0A@public.gmane.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/gluster-devel>,
	<mailto:gluster-devel-request-qX2TKyscuCcdnm+yROfE0A@public.gmane.org?subject=subscribe>
Errors-To: gluster-devel-bounces+gcfgd-gluster-devel=m.gmane.org-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
Sender: gluster-devel-bounces+gcfgd-gluster-devel=m.gmane.org-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
To: Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gluster Devel <gluster-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
List-Id: dm-devel.ids

On Sun, Apr 20, 2014 at 7:59 PM, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The amount of space you set aside is very much workload dependent (rate of
> change, rate of deletion, rate of notifying the storage about the freed
> space).

From the Puppet-Gluster perspective, this will be configurable. I
would like to set a vaguely sensible default though, which I don't
have at the moment.

>
> Keep in mind with snapshots (and thinly provisioned storage, whether using a
> software target or thinly provisioned array) we need to issue the "discard"
> commands down the IO stack in order to let the storage target reclaim space.
>
> That typically means running the fstrim command on the local file system
> (XFS, ext4, btrfs, etc) every so often. Less typically, you can mount your
> local file system with "-o discard" to do it inband (but that comes at a
> performance penalty usually).

Do you think it would make sense to have Puppet-Gluster add a cron job
to do this operation?
Exactly what command should run, and how often? (Again for having
sensible defaults.)

>
> There is also a event mechanism to help us get notified when we hit a target
> configurable watermark ("help, we are running short on real disk, add more
> or clean up!").
Can you point me to some docs about this feature?

>
> Definitely worth following up with the LVM/device mapper people on how to do
> this best,
>
> Ric

Thanks for the comments. From everyone I've talked to, it seems some
of the answers are still in progress. The good news is, that I'm ahead
of the curve for being ready for when this becomes more mainstream. I
think Paul is in the same position too.

James
