From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: [PATCH RESEND v2 16/18] fuse: Support fuse
	filesystems outside of init_user_ns
Date: Wed, 9 Mar 2016 15:48:22 +0100
Message-ID: <CAJfpegv5JmB15yHpjYxVeOYdWWkoLMftr9-e_iS93Y_7m=t4Zw@mail.gmail.com>
References: <1451930639-94331-1-git-send-email-seth.forshee@canonical.com>
	<1451930639-94331-17-git-send-email-seth.forshee@canonical.com>
	<20160309112923.GF8655@tucsk> <20160309141840.GC23399@ubuntu-xps13>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160309141840.GC23399@ubuntu-xps13>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: dm-devel.ids

On Wed, Mar 9, 2016 at 3:18 PM, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> On Wed, Mar 09, 2016 at 12:29:23PM +0100, Miklos Szeredi wrote:
>> On Mon, Jan 04, 2016 at 12:03:55PM -0600, Seth Forshee wrote:

>> > -static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
>> > +static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev,
>> > +                     struct user_namespace *user_ns)
>> >  {
>> >     char *p;
>> >     memset(d, 0, sizeof(struct fuse_mount_data));
>> >     d->max_read = ~0;
>> >     d->blksize = FUSE_DEFAULT_BLKSIZE;
>> > +   d->user_id = make_kuid(user_ns, 0);
>> > +   d->group_id = make_kgid(user_ns, 0);
>>
>> It is true that if "user_id=" or "group_id" options were omitted we used the
>> zero uid/gid values.  However, this isn't actually used by anybody AFAIK, and
>> generalizing it for userns doesn't seem to make much sense.
>>
>> So I suggest we that we instead return an error if mounting from a userns AND
>> neither "allow_other" nor both "user_id" and "group_id" are specified.
>
> But those are also used for ownership of the connection files in
> fusectl. In an allow_other mount shouldn't those files by owned by
> namespace root and not global root?

Yes.

Can't we use current_cred()->uid/gid? Or fsuid/fsgid maybe?

When we have true unprivileged mounts, the user_id/group_id options
become redundant anyway and we can just use the current credentials.

Thanks,
Miklos

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
-- 
fuse-devel mailing list
To unsubscribe or subscribe, visit https://lists.sourceforge.net/lists/listinfo/fuse-devel
