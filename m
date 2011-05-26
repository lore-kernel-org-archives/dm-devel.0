From: sdrb <sdrb@onet.eu>
Subject: Issue with dm snapshots 2
Date: Thu, 26 May 2011 13:29:29 +0200
Message-ID: <4DDE3999.8090005@onet.eu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Hello

About two weeks ago I sent post titled "Issue with dm snapshots" to this 
mailing list. I'd like to provide more information about the problem. 
Maybe it will help in recognizing the problem.


I tried to find out which is the last git commit after 2.6.28 which with 
this script works good. I used git bisect to do this and here is what 
I've got:


# git bisect good
fcccf502540e3d752d33b2d8e976034dee81f9f7 is first bad commit
commit fcccf502540e3d752d33b2d8e976034dee81f9f7
Author: Takashi Sato <t-sato@yk.jp.nec.com>
Date:   Fri Jan 9 16:40:59 2009 -0800

     filesystem freeze: implement generic freeze feature

     The ioctls for the generic freeze feature are below.
     o Freeze the filesystem
       int ioctl(int fd, int FIFREEZE, arg)
         fd: The file descriptor of the mountpoint
         FIFREEZE: request code for the freeze
         arg: Ignored
         Return value: 0 if the operation succeeds. Otherwise, -1

     o Unfreeze the filesystem
       int ioctl(int fd, int FITHAW, arg)
         fd: The file descriptor of the mountpoint
         FITHAW: request code for unfreeze
         arg: Ignored
         Return value: 0 if the operation succeeds. Otherwise, -1
         Error number: If the filesystem has already been unfrozen,
                       errno is set to EINVAL.

     [akpm@linux-foundation.org: fix CONFIG_BLOCK=n]
     Signed-off-by: (...)


:040000 040000 23e26d18d2b4d6be7fb25e9093531e34450e3067 
ae47c7559a4f9ff5a98dbaf812d003b9fcd5f46d M      fs
:040000 040000 1ca8e10e69d2d4c124b43f2a46c208a96e6c6c82 
21d3f4d7ca305612510eb5e3552c3751ebd75644 M      include
---------------------



Seems like the last "good" commit was 
c4be0c1dc4cdc37b175579be1460f15ac6495e9a - and the first bad is 
fcccf502540e3d752d33b2d8e976034dee81f9f7.
