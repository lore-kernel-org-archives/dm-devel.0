From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [Gluster-devel] Puppet-Gluster+ThinP
Date: Sun, 20 Apr 2014 16:59:30 -0700
Message-ID: <53545F62.8060001@redhat.com>
References: <1397056420.4190.93.camel@freed>
	<1420171478.1325442.1397081884591.JavaMail.zimbra@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1420171478.1325442.1397081884591.JavaMail.zimbra@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Paul Cuzner <pcuzner@redhat.com>, James <purpleidea@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Gluster Devel <gluster-devel@nongnu.org>
List-Id: dm-devel.ids

On 04/09/2014 03:18 PM, Paul Cuzner wrote:
>
> I'm really interested in the thinp best practices too. gluster-deploy has had 
> thinp support for a while now - and I asked the question about best practices 
> a while back - but nothing came back..
>
> Hopefully - you're timing is better than mine!
>
> cc'ing Rajesh since the thinp is all about snapshot enablement.

The amount of space you set aside is very much workload dependent (rate of 
change, rate of deletion, rate of notifying the storage about the freed space).

Keep in mind with snapshots (and thinly provisioned storage, whether using a 
software target or thinly provisioned array) we need to issue the "discard" 
commands down the IO stack in order to let the storage target reclaim space.

That typically means running the fstrim command on the local file system (XFS, 
ext4, btrfs, etc) every so often. Less typically, you can mount your local file 
system with "-o discard" to do it inband (but that comes at a performance 
penalty usually).

There is also a event mechanism to help us get notified when we hit a target 
configurable watermark ("help, we are running short on real disk, add more or 
clean up!").

Definitely worth following up with the LVM/device mapper people on how to do 
this best,

Ric

>
> --------------------------------------------------------------------------------
>
>     *From: *"James" <purpleidea@gmail.com>
>     *To: *"Gluster Devel" <gluster-devel@nongnu.org>
>     *Sent: *Thursday, 10 April, 2014 3:13:40 AM
>     *Subject: *[Gluster-devel] Puppet-Gluster+ThinP
>
>     Okay,
>
>     Here's a first draft of puppet-gluster w/ thin-p. This patch includes
>     documentation updates too! (w00t!)
>
>     https://github.com/purpleidea/puppet-gluster/tree/feat/thinp
>
>     FYI: I'll probably rebase this branch.
>     FYI: Somewhat untested. Read the commit message.
>
>     Comments welcome :)
>
>     I'm most interested to hear about if everyone is pleased with the way I
>     run the thin-p lv command. I think this makes the most sense, but let me
>     know if anyone has improvements. Also I'd love to hear about what the
>     default values for the parameters should be, but that's a one line
>     patch, so no rush for me.
>
>     Cheers,
>     James
>
