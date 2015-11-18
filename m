From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Wed, 18 Nov 2015 09:05:12 -0600
Message-ID: <20151118150512.GE134139@ubuntu-hedt>
References: <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk>
 <564B79B1.3040207@gmail.com>
 <20151117191606.GC108807@ubuntu-hedt>
 <564B941A.2070601@gmail.com>
 <20151117213255.GE108807@ubuntu-hedt>
 <564C6DD4.6090308@gmail.com>
 <20151118142238.GB134139@ubuntu-hedt>
 <20151118145818.GC22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151118145818.GC22011@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Wed, Nov 18, 2015 at 02:58:18PM +0000, Al Viro wrote:
> On Wed, Nov 18, 2015 at 08:22:38AM -0600, Seth Forshee wrote:
> 
> > But it still requires the admin set it up that way, no? And aren't
> > privileges required to set up those devices in the first place?
> > 
> > I'm not saying that it wouldn't be a good idea to lock down the backing
> > stores for those types of devices too, just that it isn't something that
> > a regular user could exploit without an admin doing something to
> > facilitate it.
> 
> Sigh...  If it boils down to "all admins within all containers must be
> trusted not to try and break out" (along with "roothole in any container
> escalates to kernel-mode code execution on host"), then what the fuck
> is the *point* of bothering with containers, userns, etc. in the first
> place?  If your model is basically "you want isolation, just use kvm",
> fine, but where's the place for userns in all that?
> 
> And if you are talking about the _host_ admin, then WTF not have him just
> mount what's needed as part of setup and to hell with mounting those
> inside the container?

Yes, the host admin. I'm not talking about trusting the admin inside the
container at all.

From my perspective the idea is essentially to allow mounting with fuse
or with ext4 using "mount -o loop ..." within a container.
