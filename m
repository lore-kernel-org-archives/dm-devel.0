From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 11/21] libmultipath: protect racy
 libdevmapper calls with a mutex
Date: Tue, 29 Sep 2020 11:09:25 +0200
Message-ID: <04976b536a3aceecc6d50310e745ead23c129d5f.camel@suse.com>
References: <20200924133716.14120-1-mwilck@suse.com>
	<20200924133716.14120-12-mwilck@suse.com>
	<20200929055715.GR3384@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200929055715.GR3384@octiron.msp.redhat.com>
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 2020-09-29 at 00:57 -0500, Benjamin Marzinski wrote:
> On Thu, Sep 24, 2020 at 03:37:06PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > dm_udev_wait() and dm_task_run() may access global / static state
> > in libdevmapper. They need to be protected by a lock in in our
> > multithreaded library.
> > 
> 
> This breaks the dmevents unit tests. dm_task_run is no longer called
> in
> dmevents.c. Intead, its only called in devmapper.c, so this needs to
> be
> in dmevents-test_OBJDEPS

Argh, sorry. We need to figure out a way to run this test routinely.
It's the only one I don't run after every patch, simply because it
needs root. Anyway, no excuse. Sorry. I'll fix it up.

Martin
