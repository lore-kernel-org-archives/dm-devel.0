From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [RFC][mpath-tools] path info cache
Date: Sun, 24 Jul 2005 21:56:23 +0200
Message-ID: <20050724195622.GI8005@marowsky-bree.de>
References: <1121983377.19015.103.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1121983377.19015.103.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2005-07-22T00:02:57, christophe varoqui <christophe.varoqui@free.fr> wrote:

> I just merged a quite invasive patch that needs commenting.

WIFI doesn't work for me at the Ottawa airport right now, so I'm
commenting just on the basis of this mail instead of also looking at the
code ;-)

I like the way this is going, btw. Thanks for all the good work.

> The proposed solution is : "/sbin/multipath asks the path cache to
> multipathd through its unix socket" (the same used for the CLI).
> When the ademon doesn't run, multipath has to do a full rescan.

Yes. Can I try and summarize the new design doctrine to check whether I
understand where you want to go?

"The daemon is authoritive. If it is running, all the cmdline tool does
is talk to the daemon (unless explicitly instructed otherwise). If it is
not, it'll have to do a one-shoot operation, which involves basically a
full daemon startup (which includes the mentioned full rescan)."

Is that about correct? I think that direction will lead us to a much
more coherent design over time, which basically might end up with
multipath being a hard link to multipathd. I like that, it'll resolve
some confusion about what goes into the daemon and what goes into the
cmdline tool.

> What should be debated :
> ========================
> - settle on a FS socket location (currently /var/cache/multipath/uxsock)

I think sockets should go to /var/run/ somewhere according to the LSB
File System Hierarchy standard.

> - people who care about early userspace have now 2 options :
> 
> 	- No daemon in early userspace, and disable hotplug-triggered
> 	  multipath. /sbin/multipath is ran once.

... and the daemon subsequently started later.

> 	- Start the daemon in early userspace, let multipath be
> 	  hotplug-triggered

This makes sense.


Thanks,
	Lars

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
