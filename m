From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Thu, 19 Nov 2015 08:58:13 -0600
Message-ID: <20151119145813.GA6026@mail.hallyn.com>
References: <20151117175506.GW22011@ZenIV.linux.org.uk>
 <564B79B1.3040207@gmail.com>
 <20151117191606.GC108807@ubuntu-hedt>
 <564B941A.2070601@gmail.com>
 <20151117213255.GE108807@ubuntu-hedt>
 <564C6DD4.6090308@gmail.com>
 <20151118142238.GB134139@ubuntu-hedt>
 <20151118145818.GC22011@ZenIV.linux.org.uk>
 <20151118150512.GE134139@ubuntu-hedt>
 <20151118151335.GD22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151118151335.GD22011@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Seth Forshee <seth.forshee@canonical.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: dm-devel.ids

On Wed, Nov 18, 2015 at 03:13:35PM +0000, Al Viro wrote:
> On Wed, Nov 18, 2015 at 09:05:12AM -0600, Seth Forshee wrote:
> 
> > Yes, the host admin. I'm not talking about trusting the admin inside the
> > container at all.
> 
> Then why not have the same host admin just plain mount it when setting the
> container up and be done with that?  From the host namespace, before spawning
> the docker instance or whatever framework you are using.  IDGI...

fwiw one example use case is building a livecd or vm image from inside
container, on a system where each piece of functionality is
compartmentalized in a separate container.

For specific programs we can engineer them to call out to a helper
in the init user_ns, but that doesn't work for existing tools.

James Bottomley a year or two ago had mentioned the idea of using
seccomp to have the mount syscall in a container trap into a
init_user_ns helper, but we'd have to ptrace the whole container
for its whole lifetime to do that, or use SECCOMP_RET_TRAP with
a LD_PRELOAD that does goes through a proxy to do the remote
request (which becomes infeasible bc LD_PRELOAD won't stick).

If we did enable anything but FUSE I would hope each fs would have
a separate sysctl to enable non-init-userns mounts.  Then the admin
could enable them just as they do the automount of whatever garbage
is on a usb stick found lying on the trade floor.

-serge
