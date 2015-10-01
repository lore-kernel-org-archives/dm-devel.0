From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 1/5] fs: Verify access of user towards block device file when mounting
Date: Thu, 01 Oct 2015 10:55:50 -0500
Message-ID: <87wpv6a8hl.fsf@x220.int.ebiederm.org>
References: <1443644116-41366-1-git-send-email-seth.forshee@canonical.com>
	<1443644116-41366-2-git-send-email-seth.forshee@canonical.com>
	<20150930234215.GA24127@redhat.com>
	<20151001125508.GA101875@ubuntu-hedt>
	<20151001134052.GB27818@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151001134052.GB27818@redhat.com> (Mike Snitzer's message of
	"Thu, 1 Oct 2015 09:40:52 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Seth Forshee <seth.forshee@canonical.com>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

Mike Snitzer <snitzer@redhat.com> writes:

> What layer establishes access rights to historically root-only
> priviledged block devices?  Is it user namespaces?

Block devices are weird.

Mounts historically have not checked the permissions on the block
devices because a mounter has CAP_SYS_ADMIN.

Unprivileged users are allowes to read/write block devices if
someone has given them permissions on the device node in the
filesystem.

The thinking with this patchset is to start performing the normal
block device access permission checks when mounting filesystems
when the mounter does not have the global CAP_SYS_ADMIN permission.

The truth is we are not much past the point of realizing that there were
no permission checks to use the actual block device passed in to mount,
so we could still be missing something. There is a lot going on with dm,
md, and lvm.  I don't know if the model of just look at the block device
inode and perform the permission checks is good enough.

> I haven't kept up with user namespaces as it relates to stacking block
> drivers like DM.  But I'm happy to come up to speed and at the same time
> help you verify all works as expected with DM blocks devices...

We are just getting there.  But if you can help that would be great.
The primary concern with dm is what happens when unprivileged users get
ahold of the code, and what happens when evil users corrupt the on-disk
format.

In principle dm like loop should be safe to use if there are not bugs
that make it unsafe for unprivileged users to access the code.

The goal if possible is to run things like docker without needed to be
root or even more fun to run docker in a container, and in general
enable nested containers.

Eric
