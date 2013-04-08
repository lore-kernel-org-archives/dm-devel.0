From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache-mq policy can't allocate memory
Date: Mon, 8 Apr 2013 11:24:34 +0100
Message-ID: <20130408102433.GA21993@debian>
References: <1365172677.2559.23.camel@berule>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1365172677.2559.23.camel@berule>
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
Cc: Pascal GALLARD <pascal.gallard@nonstop.fr>
List-Id: dm-devel.ids

On Fri, Apr 05, 2013 at 04:37:57PM +0200, =C9tienne BERSAC wrote:
> Hi,
> =

> I'm testing the experimental dm-cache target and think i encountered a
> bug.
> =

> I tested version d08d528dc1848fb369a0b27cdb0749d8f6f38063 of linus tree.
> Compiled with make -j4 deb-pkg. Config file attached.
> =

> Here is the current dmsetup configuration :
> =

> ------------------->8-----------------
> root@st-brice:~/etudes# dmsetup table
> st--brice-root: 0 151486464 linear 8:5 2048
> st--brice-swap_1: 0 4169728 linear 8:5 151488512
> -------------------8<-----------------
> =

> 8:5 is /dev/sda, a disk reserved for the system. I'm using another
> physical disk for playing. I directly use physical partitions as blocks
> backing the cache target, i'm just playing with the same physical device
> yet :
> =

> ------------>8---------------
> root@st-brice:~# fdisk -l /dev/sdb
> Disk /dev/sdb: 80.0 GB, 80000000000 bytes
> =

>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1              63     3903794     1951866   8e  Linux LVM
> /dev/sdb2         3903795    82027889    39062047+  8e  Linux LVM
> /dev/sdb3        82027890   156249999    37111055   8e  Linux LVM
> -------------8<---------------
> =

> /dev/sdb1 is zeroed before issuing this command. I setup the target
> using the following table :
> =

>         /sbin/dmsetup create dmc0 --table '0 74222110 cache /dev/sdb1 /de=
v/sdb2 /dev/sdb3 64 0 default 0'

The mq policy uses a fair bit of memory per cache entry (I'm working
on reducing this).  I suggest you bump the block size right up.  eg,
2048 rather than 64.  Tell me if this doesn't help, the only unusual
thing you're doing is using a cache device that's bigger than the
origin, it should work though.

- Joe
