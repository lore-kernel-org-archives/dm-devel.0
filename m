From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] fs: Verify access of user towards block device file
 when mounting
Date: Fri, 2 Oct 2015 01:07:00 +0200
Message-ID: <20151001230700.GA10087@quack.suse.cz>
References: <1443644116-41366-1-git-send-email-seth.forshee@canonical.com>
 <1443644116-41366-2-git-send-email-seth.forshee@canonical.com>
 <20150930234215.GA24127@redhat.com>
 <20151001125508.GA101875@ubuntu-hedt>
 <20151001134052.GB27818@redhat.com>
 <87wpv6a8hl.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87wpv6a8hl.fsf@x220.int.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Thu 01-10-15 10:55:50, Eric W. Biederman wrote:
> The goal if possible is to run things like docker without needed to be
> root or even more fun to run docker in a container, and in general
> enable nested containers.

Frankly at the filesystem side we are rather far from being able to safely
mount untrusted device and I don't think we'll ever be robust enough to
tolerate e.g. user changing the disk while fs is using it. So would this be
FUSE-only thing or is someone still hoping that general purpose filesystems
will be robust enough in future?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
