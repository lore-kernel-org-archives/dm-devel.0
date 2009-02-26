From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: multipathd segfault and error calling out
Date: Thu, 26 Feb 2009 09:40:49 +0000
Message-ID: <49A663A1.5050505@redhat.com>
References: <1235614064.6568.65.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1235614064.6568.65.camel@jaspav.missionsit.net.missionsit.net>
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

John A. Sullivan III wrote:
> Hello, all.  I am running on kernel 2.6.27 on CentOS 5.2 with 
> VServer and device-mapper-multipath-0.4.7-17.el5.  I have a custom 
> mpath_prio_ssi script which takes the device name (e.g., sdaa), 
> pulls out the path from /etc/disk/by-path and then echos a priority
>  based upon a lookup table.  It works perfectly fine from the 
> command line. multipath -ll shows the priorities assigned perfectly
>  and exactly the right paths are active.
> 
> However, when I start multipathd, it all goes down the tubes.  The
>  paths disappear and /var/log/messages is filled with: Feb 25 
> 20:50:17 vd01 multipathd: error calling out 
> /usr/local/sbin/mpath_prio_ssi sdh Feb 25 20:50:17 vd01 multipathd:
>  error calling out /usr/local/sbin/mpath_prio_ssi sdi Feb 25 
> 20:50:17 vd01 multipathd: error calling out 
> /usr/local/sbin/mpath_prio_ssi sdj Feb 25 20:50:17 vd01 multipathd:
>  error calling out /usr/local/sbin/mpath_prio_ssi sdc

I think you'll need to modify the multipathd binary to achieve this.

To avoid deadlocking when file system access is interrupted due to
path failures multipathd forks into a new namespace and discards all
the device-backed file systems that are mounted.

It creates an in-memory file system (ramfs) and copies all the
binaries it will need into this. The file system is locked into memory
so that multipathd can continue to function even if the paths backing
the root file system have all failed.

For the callouts themselves (getuid and getprio binaries) the config
file processing takes care of this but this only works for stand-alone
binaries. If your script has other dependencies then you'll have to
add code to pull those into the ramfs volume.

See libmultipath/config.c:push_callout(),
libmultipath/config.c:store_hwe(),
multipathd/main.c:prepare_namespace() and other code that manipulates
the list of binaries stored in conf->binvec.

Regards,
Bryn.
