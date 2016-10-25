From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: how to refresh LV to apply fstrim online
Date: Tue, 25 Oct 2016 16:12:39 +0200
Message-ID: <fc98716c-2bc8-07a5-d0d3-d39a14397127@redhat.com>
References: <CAG2kNCwwDEeY0jHMvD6JxVb2WFHncY3pRM_Cy=QvAgJxaoa5MA@mail.gmail.com>
	<da58a0be-bdd9-a06d-f1a9-6b8c6e07b052@redhat.com>
	<CAG2kNCztXfyeU7xoT2KuN=YwNwhYj78J7XoriwcOPyBHimG9OQ@mail.gmail.com>
	<CAG2kNCwn57jjbsCNq+b0Mkku9fA2oZJXCw9EUSpyj=F0CABjRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAG2kNCwn57jjbsCNq+b0Mkku9fA2oZJXCw9EUSpyj=F0CABjRg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 25.10.2016 v 16:04 Gianluca Cecchi napsal(a):
>
>
> On Fri, Oct 21, 2016 at 1:32 AM, Gianluca Cecchi <gianluca.cecchi@gmail.com
> <mailto:gianluca.cecchi@gmail.com>> wrote:
>
>
>     On Thu, Oct 20, 2016 at 1:40 PM, Zdenek Kabelac <zkabelac@redhat.com
>     <mailto:zkabelac@redhat.com>> wrote:
>
>
>         Hi
>
>         Please provide listing of all your 'multipath'  leg devices - are
>         they support TRIM ?
>         Then 'check' dm device.
>
>         See  (and attach)
>
>          grep "" /sys/block/*/queue/discard_granularity
>
>
>         Also make sure you are NOT using 'ext2' filesystem which does not
>         support discard on RHEL6 and you are on latest available RHEL6 kernel.
>
>
>         Regards
>
>         Zdenek
>
>
>
>     Hello,
>     thanks for answer.
>     I'm using ext3 filesystem that supports discard.
>     Currently I'm on this kernel
>
>     [root@dbatest1 ~]# uname -r
>     2.6.32-431.29.2.el6.x86_64
>     [root@dbatest1 ~]#
>
>
>     It seems that I was myself able to find a way to online refresh the
>     logical volume and so to successfully run fstrim command against the
>     related file system, without deactivating the lv and most important
>     without generating downtime for my users.
>     Please note that what I'm doing is working on a test system where I have
>     the same situation as in production.
>     Can you certify my approach and comment about it, so that I can eventually
>     apply in production?
>
>
> [snip]
>
>
>
>     [root@dbatest1 ~]# dmsetup suspend /dev/dm-4 ; dmsetup reload /dev/dm-4
>     my_dm_table ; dmsetup resume /dev/dm-4
>     [root@dbatest1 ~]# echo $?
>     0
>     [root@dbatest1 ~]#
>
>     And now the magic:
>
>     [root@dbatest1 ~]# fstrim /ALM/rdoffline
t giving downtime, in a safe way.


Normally it's not advised  to use 'dmsetup' command for  LV.
The above sequence should be equivalent to:

lvchange --refresh  vg/lv
(or  vgchange --refresh vg  -  doing it for every active LV in VG)

It's unclear how this could help  - unless you we doing some 'pvmove'
operations (which might be worth a BZ).

You should collect all states  while it 'DOES NOT' work.
And then  run  the --refresh (which you thing it's fixing it for your)
ATM I'm clueless how you get mapping without TRIM where --refresh can fix it.


Regards

Zdenek
