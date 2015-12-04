From: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 17/19] fuse: Support fuse filesystems outside of
 init_user_ns
Date: Fri, 4 Dec 2015 09:38:55 -0600
Message-ID: <20151204153855.GB147214@ubuntu-hedt>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com>
 <1449070821-73820-18-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449070821-73820-18-git-send-email-seth.forshee@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids

On Wed, Dec 02, 2015 at 09:40:17AM -0600, Seth Forshee wrote:
> @@ -155,11 +155,22 @@ static ino_t fuse_squash_ino(u64 ino64)
>  	return ino;
>  }
>  
> -void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
> -				   u64 attr_valid)
> +int fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
> +				  u64 attr_valid)
>  {
>  	struct fuse_conn *fc = get_fuse_conn(inode);
>  	struct fuse_inode *fi = get_fuse_inode(inode);
> +	kuid_t uid;
> +	kgid_t gid;
> +
> +	uid = make_kuid(fc->user_ns, attr->uid);
> +	gid = make_kgid(fc->user_ns, attr->gid);
> +	if (!uid_valid(uid) || !gid_valid(gid)) {
> +		make_bad_inode(inode);
> +		return -EIO;
> +	}

Eric - I had kind of forgotten about this part until just now, but
previously with these patches we had discussed how to handle ids from
the filesystem that aren't valid in s_user_ns. My intention is to set
the kuids in the inode to invalid, and in these patches I've updated the
vfs so that it should be safe to do that. But at some point I think you
had suggested marking the inodes bad, and I must have added this as a
result. I guess we need to decide which way to go. I favor using invalid
ids so that a user privileged in s_user_ns can still access the inode,
change ownership, etc., but I'm interested to hear your opinion.

Thanks,
Seth
