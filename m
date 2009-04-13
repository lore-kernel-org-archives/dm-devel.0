From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: multipath prio_callout broke from 5.2 to 5.3
Date: Mon, 13 Apr 2009 15:56:05 -0400
Message-ID: <1239652565.30476.41.camel@jaspav.missionsit.net.missionsit.net>
References: <1779195765.1578721239520436084.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<1239613205.6376.16.camel@jaspav.missionsit.net.missionsit.net>
	<20090413185745.GF15911@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090413185745.GF15911@ether.msp.redhat.com>
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

On Mon, 2009-04-13 at 13:57 -0500, Benjamin Marzinski wrote:
> On Mon, Apr 13, 2009 at 05:00:05AM -0400, John A. Sullivan III wrote:
> > Thank you.  I'll detail our script and the logic behind it in a separate
> > email in case it is helpful to others.
> > 
> > In the meantime, we have a critical problem where the script which was
> > working perfectly in 5.2 is now broken in 5.3.  Is there any way to
> > deconfuse the 5.3 multipathd or any other immediate solution? - John
> 
> What christophe said is correct. In RHEL 5.3, multipath started copying
> all of the necessary callouts into it own private namespace. It scans
> through your config file, and pulls out all the binaries.  However,
> there are two problems that are affecting you.  First, it only pulls the
> command, "/bin/bash" in you case, not the arguments, which for
> you include a script to run.  Second, it's private namespace only
> consists of /sbin, /bin, /tmp, a couple of virtual filesystems, like
> /proc and /sys (well, actually there are a couple of others, like /etc,
> that multipath needs to start up, but you shouldn't rely on them being
> there all the time, since you can lose access to them if the device
> they're on goes down)
> 
> There are two ways to deal with this.  First is to rewrite the
> prioritizer in C.  I realize that this is a pain, but it will be
> necessary to run on RHEL6 and new fedora machines, which use upstream's
> prio functions instead of callout binaries.
> 
> The second, quicker way is to move your callout to /sbin and add a dummy
> device section to make sure it gets picked up.
> 
> devices {
> ...
> 	device {
> 		vendor       "dummy"
> 		product      "dummy"
> 		prio_callout "/sbin/mpath_prio_ssi"
> 	}
> }
> 
> This will cause multipathd to copy your script into the private
> namespace, and everything should work, with one exception.
> 
> bash is not a statically linked executable.  It links to libraries,
> and multipathd doesn't make its own copies of them.  Under normal
> operation this will work (/lib is also in multipathd's
> private namespace). However, if you lose access to /lib, bash won't
> work, and multipathd won't be able to restore access to your devices.
> If you aren't planning on multipathing / or /lib you might choose to
> ignore this (The exact same problem exists in 5.2).
> 
> I don't believe that there is a statically linked shell in RHEL 5.
> This is another reason to convert your callout to a C program. Or
> you can recompile bash with static linking.
> 
> -<snip>
Thanks very much for the explanation.  If I understand correctly, 5.2
also copied into a ramfs but not a separate namespace and that's why it
worked in 5.2?

In any event, we attempted to implement the less preferred method for
the sake of time right now (none of us are particularly adept at C and
are not sure how we'd feed the configuration file if it is not safe to
pull files from disk).  We moved mpath_prio_ssi to /sbin and called it
directly in multipath.conf, i.e.,
prio_callout            "/sbin/mpath_prio_ssi %n"

It still does not work but this time we get:
Apr 13 15:33:15 kvm01 multipathd: error calling out /sbin/mpath_prio_ssi
sdq
Apr 13 15:33:15 kvm01 multipathd: /sbin/mpath_prio_ssi exitted with 255

If we revert to
prio_callout            "/bin/bash /sbin/mpath_prio_ssi %n"
we return to:
Apr 13 15:34:43 kvm01 multipathd: error calling
out /bin/bash /sbin/mpath_prio_ssi sdc
Apr 13 15:34:43 kvm01 multipathd: /bin/bash exitted with 127

We thought the script might need an explicit exit code so we changed
everything to exit 0 but that did not fix the problem.  Any idea why we
are getting this 255 error? Thanks - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
