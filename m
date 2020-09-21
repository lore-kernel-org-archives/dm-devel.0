From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 10/19] libmultipath: devmapper: refactor
 libdm version determination
Date: Mon, 21 Sep 2020 10:35:34 +0200
Message-ID: <1cb705785cf5d77b89002135b9411900fb82b630.camel@suse.com>
References: <20200916153718.582-1-mwilck@suse.com>
	<20200916153718.582-11-mwilck@suse.com>
	<20200919221422.GW11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200919221422.GW11108@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Sat, 2020-09-19 at 17:14 -0500, Benjamin Marzinski wrote:
> On Wed, Sep 16, 2020 at 05:37:09PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > As one step towards bundling all possibly racy libdm init calls
> > into a single
> > function, split the code for determining and checking versions of
> > libdm and kernel components. Provide a generic helper
> > libmp_get_version() that makes sure the versions are "lazily"
> > initialized.
> > Note that retrieving the versions requires libdm calls, thus the
> > version initialization calls libdm initialization, which might call
> > version initialization recursively. But that's not an issue, as
> > the initialization is protected by pthread_once().
> 
> This is confusing me. dm_tgt_version will call
> DM_DEVICE_LIST_VERSIONS,
> but it doesn't call libmp_dm_task_create(), so I don't see the
> recursion
> possiblity. 

You are right, I was confused. 
The callstack for "lazy" initialization looks like this:

libmp_dm_task_create
  pthread_once(&dm_initialized, libmp_dm_init);
    libmp_dm_init()
=>    dm_prereq()
        init_versions
          pthread_once(&versions_initialized, _init_versions);
            _init_versions()
              init_dm_library_version()
              init_dm_drv_version()
              init_dm_mpath_version()
                dm_tgt_version
**                dm_task_create
                  libmp_task_run()
                    pthread_mutex_lock(&libmp_dm_lock);
                    dm_task_run()

(If an application called dm_prereq() explicitly, it would enter
the stack at "=>", which would be less of a problem).

I suppose I should add a comment at "**" saying that we must not call
libmp_dm_task_create() there to avoid recursion. I also notice that my
function naming I used is inconsistent; it should be
libmp_dm_task_run() rather than just libmp_task_run().

> That's good because according to the man page:
> 
> "If you specify a routine that directly or indirectly results in a
> recursive call to pthread_once(3) and that specifies the same routine
> argument, the recursive call can result in a deadlock."

Thanks for pointing this out. I had missed that indeed.

I see this paragraph only in some old DECThreads man pages on the web.
There's a slighly different "APPLICATION USAGE" statement under 
https://pubs.opengroup.org/onlinepubs/9699919799/. The pragraph is
missing in https://man7.org/linux/man-pages/man3/pthread_once.3p.html,
which is still based on POSIX.1-2008, 2013 edition - that's why I
missed it.

Anyway, it makes sense, because pthread_once() guarantees that the init
routine has _finished_ when it returns, which can't work with recursive
calls.

Anyway, I'll send a v2.

Regards
Martin
