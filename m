From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 17/19] libmultipath: add udev and logsink
	symbols
Date: Wed, 23 Sep 2020 11:05:52 -0500
Message-ID: <20200923160552.GD11108@octiron.msp.redhat.com>
References: <20200916153718.582-1-mwilck@suse.com>
	<20200916153718.582-18-mwilck@suse.com>
	<20200921201052.GY11108@octiron.msp.redhat.com>
	<3c33e8dc3355a444d58bff8d5ccc24515931c523.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3c33e8dc3355a444d58bff8d5ccc24515931c523.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 23, 2020 at 10:16:48AM +0200, Martin Wilck wrote:
> On Mon, 2020-09-21 at 15:10 -0500, Benjamin Marzinski wrote:
> > 
> > After calling libmultipath_exit(), you can never reinitialized the
> > udev
> > device.  That seems fine, but it should probably set udev to null, so
> > that future calls to libmultipath_init() don't return success. Either
> > that or multipath_init() should use a mutex instead of pthread_once()
> > to
> > avoid races, so that you can reinitialize udev after a call to
> > libmultipath_exit().
> 
> I've been thinking about this some more. It makes a lot of sense to
> move more cleanup code into libmultipath_exit() in the future; thus
> this function will do more than just clean up "udev". I believe calling
> libmultipath_exit() will become the only supported way to clean up
> libmultipath, and basically mandatory, rather sooner than later. 
> 
> The handling of "udev" is the main cause of headache, because we don't
> know whether the application wants to continue to use the variable
> after libmultipath_exit(). In libmultipath_exit(), we can't determine
> if "udev" is the symbol from libmultipath or from some other object
> file. It's also impossible to tell by the return value of udev_unref()
> whether or not it destroyed the variable. Setting udev to NULL is
> dangerous if the uevent listener thread is still running, or if the
> application needs to use the variable further.
> 
> So this is my current idea for a "robust" design:
> 
> 1. libmultipath_init() initializes udev if it's NULL; otherwise, it
>    simply takes an additional ref. IOW, applications may (but
>    don't have to) initialize and use udev before calling
>    libmultipath_init().
> 2. libmultipath_exit() calls udev_unref(udev), without nullifying it.
>    Thus applications may continue using udev afterwards, if they own an
>    additional reference.
> 3. libmultipath_init() always fails after calling libmultipath_exit().
> 4. Other libmultipath calls after libmultipath_exit() may cause
>    undefined behavior.
> 5. Normal usage would be to call libmultipath_exit() at program exit.
> 6. Calling libmultipath_init() is currently only mandatory for
>    programs that don't initialize "udev" themselves. This may change
>    in the future.
> 7. Calling libmultipath_exit() will be mandatory for programs that
>    wish to avoid memory leaks.
> 
> The only downside that I see is that the application can't test whether
> "udev" is valid by checking if it's NULL. But that's by design of
> udev_unref(). The application needs to track its own references.
> 
> There is no rigorous reason for (3.). In principle, we could just
> handle re-initialization like (1.). But I don't think it's worth the
> effort of figuring out all possible ways in which re-initialization
> could go wrong, in particular if we want to initialize more stuff
> later.
> 
> Does this make sense? 

Yeah. After I sent off my message, I realized that there's no way to
know if you dropped the last reference, which means that NULLing out
udev doesn't make sense.

-Ben

> Martin
> 
