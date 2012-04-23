From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCHES]: dm lock optimization
Date: Mon, 23 Apr 2012 14:14:39 +0100
Message-ID: <20120423131438.GA32127@ubuntu>
References: <Pine.LNX.4.64.1204182249060.12984@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1204182249060.12984@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 18, 2012 at 11:03:33PM -0400, Mikulas Patocka wrote:
> Hi
> 
> I placed dm lock optimization patches here
> 
> http://people.redhat.com/mpatocka/patches/kernel/dm-lock-optimization/

Just a heads up that sparse gives some warnings with these patches:

drivers/md/dm.c:689:24: warning: context imbalance in 'dm_get_live_table_fast' - wrong count at exit
drivers/md/dm.c:695:13: warning: context imbalance in 'dm_put_live_table_fast' - unexpected unlock
drivers/md/dm.c:1789:17: warning: context imbalance in 'dm_request_fn' - unexpected unlock

- Joe
