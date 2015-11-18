From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Wed, 18 Nov 2015 14:10:45 -0500
Message-ID: <20151118191045.GB3434@thunk.org>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk>
 <20151117183444.GB108807@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151117183444.GB108807@ubuntu-hedt>
Sender: linux-kernel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Nov 17, 2015 at 12:34:44PM -0600, Seth Forshee wrote:
> On Tue, Nov 17, 2015 at 05:55:06PM +0000, Al Viro wrote:
> > On Tue, Nov 17, 2015 at 11:25:51AM -0600, Seth Forshee wrote:
> > 
> > > Shortly after that I plan to follow with support for ext4. I've been
> > > fuzzing ext4 for a while now and it has held up well, and I'm currently
> > > working on hand-crafted attacks. Ted has commented privately (to others,
> > > not to me personally) that he will fix bugs for such attacks, though I
> > > haven't seen any public comments to that effect.
> > 
> > _Static_ attacks, or change-image-under-mounted-fs attacks?
> 
> Right now only static attacks, change-image-under-mounted-fs attacks
> will be next.

I will fix bugs about static attacks.  That is, it's interesting to me
that a buggy file system (no matter how it is created), not cause the
kernel to crash --- and privilege escalation attacks tend to be
strongly related to those bugs where we're not doing strong enough
checking.

Protecting against a malicious user which changes the image under the
file system is a whole other kettle of fish.  I am not at all user you
can do this without completely sacrificing performance or making the
code impossible to maintain.  So my comments do *not* extend to
protecting against a malicious user who is changing the block device
underneath the kernel.

If you want to submit patches to make the kernel more robust against
these attacks, I'm certainly willing to look at the patches.  But I'm
certainly not guaranteeing that they will go in, and I'm certainly not
promising to fix all vulnerabilities that you might find that are
caused by a malicious block device.  Sorry, that's too much buying a
pig in a poke....

						- Ted
				
