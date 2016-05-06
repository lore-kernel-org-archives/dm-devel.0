From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 6/6] libmultipath: fixup dm_rename to
 complete cookie on failure
Date: Fri, 6 May 2016 17:45:54 -0500
Message-ID: <20160506224554.GX26117@octiron.msp.redhat.com>
References: <1462341450-5507-1-git-send-email-hare@suse.de>
	<1462341450-5507-7-git-send-email-hare@suse.de>
	<20160506202920.GW26117@octiron.msp.redhat.com>
	<20160506215900.GA28251@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160506215900.GA28251@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Fri, May 06, 2016 at 10:59:01PM +0100, Alasdair G Kergon wrote:
> The library functions and return states are supposed to be well-defined.
> 
> If you think you've found a cookie leak on an error path within a library
> function, we can investigate that and fix the library if need be.

In _udev_notify_sem_create(), after dm creates the semaphore and sets
it's value, it calls

semctl(gen_semid, 0, GETVAL) to get the value.  I don't know how likely
this call is to ever fail, but if it does, _udev_notify_sem_create()
sets the cookie pointer to 0, so the caller has no access to the
semaphore, and returns an error, leaving the semaphore to just sit
there.

Conversely, if setting the value fails, dm destroys the semaphore before
returning, so that everything is the same as before the call happened.

There's a similar issue in _udev_notify_sem_inc, but in this case the
cookie is returned along with the error.  However, from the caller's
perspective, the cookie is still in an indeterminate state.

I'll open a bugzilla for it.

-Ben


> 
> Alasdair
