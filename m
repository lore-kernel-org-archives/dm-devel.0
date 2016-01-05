From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm ioctl: Access user-land memory through safe functions.
Date: Tue, 5 Jan 2016 16:13:10 -0500
Message-ID: <20160105211310.GC30512@redhat.com>
References: <565DE2B8.7040709@eng.utah.edu>
 <566720D0.8080509@eng.utah.edu>
 <20160105201649.GA30512@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160105201649.GA30512@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Scotty Bauer <sbauer@eng.utah.edu>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Tue, Jan 05 2016 at  3:16pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Dec 08 2015 at  1:26pm -0500,
> Scotty Bauer <sbauer@eng.utah.edu> wrote:
> 
> > Friendly ping, is anyone interested in this?
> 
> The passed @user argument is flagged via __user so it can be
> deferenced directly.  It does look like directly deferencing
> user->version is wrong.
> 
> But even if such indirect access is needed (because __user flag is only
> applicable to @user arg, not the contained version member) we could more
> easily just do something like this no?:
> 
>   uint32_t __user *versionp = (uint32_t __user *)user->version;
>   ...
>   if (copy_from_user(version, versionp, sizeof(version)))
>      return -EFAULT;
> 
> I've staged the following, thanks:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.5&id=bffc9e237a0c3176712bcd93fc6a184a61e0df26

Alasdair helped me understand that we do need your original fix.
I've staged it for 4.5 (and stable@) here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.5&id=ead3db62bf10fe143bec99e7b7ff370d7a6d23ef

Thanks again,
Mike
