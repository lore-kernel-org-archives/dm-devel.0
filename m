From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/2] dm: alternate solution to reloading with
	failed paths
Date: Mon, 15 Sep 2014 17:44:53 -0400
Message-ID: <20140915214453.GB19349@redhat.com>
References: <1407956023-32372-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1407956023-32372-1-git-send-email-bmarzins@redhat.com>
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
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Aug 13 2014 at  2:53pm -0400,
Benjamin Marzinski <bmarzins@redhat.com> wrote:

> This is different solution to the problem of multipath not being able to
> reload devices with failed paths than the one that Hannes first proposed.
> It adds a list of dm_devs to the mapped_device structure.  All of the table
> lists point to devices on this list. The list keeps track of how many tables
> are accessing these devices, and locks them to deal with tables being created
> and destroyed at the same time.  This avoids the issue of having tables that
> list devices for which the kernel is not holding any reference, and which
> can disappear and come back as a completely different device if userspace
> drops its reference.  This also allows these devices to be reinstated without
> another table reload.
> 
> The other patch deals with issues I discovered while tracking down why
> multipath devices with no valid paths would hang on table reload. It turns
> out that multipath_map can no longer be called after a table reload until
> queue_io is cleared, but multipath map was previously the function that
> usually cleared queue_io.

I've done a first pass review of the code changes and overlayed a
cleanup patch in this branch:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=devel

I'll do another pass of review tomorrow and perform a full regression
test as well as a targetted test of loading various multipath tables
with no devices.

If all looks good I'll get it staged for 3.18.
