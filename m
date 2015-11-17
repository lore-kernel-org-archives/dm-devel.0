From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Tue, 17 Nov 2015 11:45:00 -0600
Message-ID: <20151117174459.GA11998@mail.hallyn.com>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151117172551.GA108807@ubuntu-hedt>
Sender: linux-bcache-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Tue, Nov 17, 2015 at 11:25:51AM -0600, Seth Forshee wrote:
> On Tue, Nov 17, 2015 at 05:05:56PM +0000, Al Viro wrote:
> > On Tue, Nov 17, 2015 at 10:39:03AM -0600, Seth Forshee wrote:
> > > Hi Eric,
> > > 
> > > Here's another update to my patches for user namespace mounts, based on
> > > your for-testing branch. These patches add safeguards necessary to allow
> > > unprivileged mounts and update SELinux and Smack to safely handle
> > > device-backed mounts from unprivileged users.
> > > 
> > > The v2 posting received very little in the way of feedback, so changes
> > > are minimal. I've made a trivial style change to the Smack changes at
> > > Casey's request, and I've added Stephen's ack for the SELinux changes.
> > 
> > Would you mind explaining which filesystem types do you plan to allow?
> > SELinux and the rest of Linux S&M bunch do fuck-all for attacks via
> > handcrafted fs image fed to the code in fs driver that does not expect
> > a given kind of inconsistencies.
> > 
> > As it is, validation of on-disk metadata is not particularly strong;
> > what's more, protection against concurrent malicious *changes* of
> > fs image (via direct writes by root) is simply inexistent.
> > 
> > So what is that about?
> 
> The first target is fuse, which won't be vulnerable to those attacks.
> 
> Shortly after that I plan to follow with support for ext4. I've been
> fuzzing ext4 for a while now and it has held up well, and I'm currently
> working on hand-crafted attacks. Ted has commented privately (to others,
> not to me personally) that he will fix bugs for such attacks, though I
> haven't seen any public comments to that effect.

Hi,

Not privately, but during the 2014 kernel summit.  The only documentation
of it I've seen is at the bottom of Paul's summary at
http://lwn.net/Articles/609376/ .
