From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 1/5] fs: Verify access of user towards block device file
 when mounting
Date: Mon, 5 Oct 2015 09:26:21 -0500
Message-ID: <20151005142621.GB21639@ubuntu-hedt>
References: <1443644116-41366-1-git-send-email-seth.forshee@canonical.com>
 <1443644116-41366-2-git-send-email-seth.forshee@canonical.com>
 <20150930234215.GA24127@redhat.com>
 <20151001125508.GA101875@ubuntu-hedt>
 <20151001134052.GB27818@redhat.com>
 <87wpv6a8hl.fsf@x220.int.ebiederm.org>
 <20151001230700.GA10087@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151001230700.GA10087@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Mike Snitzer <snitzer@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Oct 02, 2015 at 01:07:00AM +0200, Jan Kara wrote:
> On Thu 01-10-15 10:55:50, Eric W. Biederman wrote:
> > The goal if possible is to run things like docker without needed to be
> > root or even more fun to run docker in a container, and in general
> > enable nested containers.
> 
> Frankly at the filesystem side we are rather far from being able to safely
> mount untrusted device and I don't think we'll ever be robust enough to
> tolerate e.g. user changing the disk while fs is using it. So would this be
> FUSE-only thing or is someone still hoping that general purpose filesystems
> will be robust enough in future?

FUSE will almost certainly be first. I've also been working with ext4,
and I would like to see that eventually supported to some degree.

Seth
