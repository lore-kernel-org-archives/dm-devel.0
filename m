From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Fri, 20 Nov 2015 11:33:29 -0600
Message-ID: <20151120173329.GA20909@mail.hallyn.com>
References: <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk>
 <20151117183444.GB108807@ubuntu-hedt>
 <CAFLxGvx1UqJOhM3wqAGqT+TrkapeP1zkmg0a1K=DjySePx4mEA@mail.gmail.com>
 <20151117192141.GD108807@ubuntu-hedt>
 <CAE1zotLNq1v_ZegT9LyFsTiHWQnOAow+KKQFFvOYKUyRWPjfGA@mail.gmail.com>
 <564B8A20.9090607@nod.at>
 <CAE1zotJRp3=G2Vdud7kVbkToKe2YsTF3gXUnLCNzKV6F0oumdg@mail.gmail.com>
 <20151119152347.GA45540@ubuntu-hedt>
 <CAE1zot+G=SohXzuV6Gs7APdCo5pu9xLwE38kZKNUuWRnSh++BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE1zot+G=SohXzuV6Gs7APdCo5pu9xLwE38kZKNUuWRnSh++BA@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Seth Forshee <seth.forshee@canonical.com>, Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, LKML <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Thu, Nov 19, 2015 at 06:19:10PM +0200, Octavian Purdila wrote:
> On Thu, Nov 19, 2015 at 5:23 PM, Seth Forshee
> > And for the second:
> >
> >  stress-ng --class filesystem --seq 0 -v -t 60
> >
> > There really wasn't anything interesting in the lklfuse output for the
> > first run, but for the second run I pasted the output here:
> > http://paste.ubuntu.com/13346993/
> 
> lklfuse allocates a fixed 100MB to the kernel and this is probably not
> enough. For the short term I can add a parameter to lklfuse that
> allows the user to specify the amount of memory to allocate to lkl. A
> better fix would probably be to dynamically adjust the memory size of
> lkl. I am thinking of using the ballon virtio driver or the memory
> hotplug infrastructure. Any other suggestions?

Hi Octavian,

Like Seth said this was very nice to install and run.  But I think I'm
doing something wrong.  I cloned the lkl/linux git tree into a 9G ext4
loopback file, both one mounted with lkl and one mounted as loopback.
The results were worse than I expected - loopback was 0m10.078s for
clone and 0m0.877s for rm -rf;  lkl was 5m5.625s for clone and 0m44.332s
for rm -rf.  I assume this has to do with the 100MB buffer and subsequent
thrashing?  How should I tune this to  make it perform better?

No crashes from this, though.

thanks,
-serge
