From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Help ! : device-mapper: reload ioctl failed: Invalid
	argument
Date: Tue, 21 Sep 2010 16:15:37 -0400
Message-ID: <20100921201537.GA5298@redhat.com>
References: <AANLkTi=jPyz77ZSC64w6K_vHYU1JxsNjooY1PECNO_F8@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <AANLkTi=jPyz77ZSC64w6K_vHYU1JxsNjooY1PECNO_F8@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sethuraman Subbiah <ssubbia2@ncsu.edu>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 16 2010 at  7:08pm -0400,
Sethuraman Subbiah <ssubbia2@ncsu.edu> wrote:

> Hi ,
> 
> This is Sethuraman Subbiah , a student at NCState. I installed DM-IOBAND. I
> needed that for a project.
> 
> I downloaded a kernel module binary and used insmod to insert the module. It
> worked and i did modprobe.
> 
> When I gave dmsetup targets | grep ioband
> I got ioband v1.14.0
> 
> It was fine till that step.
> 
> When I try to associate /dev/sda3 with ioband1 :
> 
> echo "0 $(blockdev --getsize /dev/sda3) ioband /dev/sda3 1 0 0 none weight 0
> :40" | dmsetup create ioband1
> 
> I keep getting this error :
> device-mapper: reload ioctl failed: Invalid argument
> Command failed
> 
>
> Can someone help me out ? Thanks !

dm-ioband isn't upstream.  Best to ping original authors from valinux if
you're still interested in it.

If you have a need for bandwidth control Vivek Goyal has developed
throttling support in the block layer.  Vivek's work has been merged for
upstream inclusion in Linux 2.6.37.

See the following for documentation on throttling support:
http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=2786c4e5e54802c3

If you'd like to try it, it is available with the following:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
cd linux-2.6-block
git checkout -b my_for-next origin/for-next

Mike
