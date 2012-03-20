From: =?ISO-8859-1?Q?Sz=E9kelyi?= Szabolcs <szekelyi@niif.hu>
Subject: multipath: #:#:#:# -   #:#   [failed][faulty]
Date: Tue, 20 Mar 2012 16:58:58 +0100
Message-ID: <1540766.9mAY8jDUxh@mranderson>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

when removing multipaths, I often end up with a situation like this:

# multipath -ll
3600000e00d0000000001185600010000 dm-2 ,
[size=4.3T][features=0][hwhandler=0][rw]
\_ round-robin 0 [prio=0][enabled]
 \_ #:#:#:# -   #:#   [failed][faulty]

I'm unable to remove these stale maps, neither with dmsetup nor multipathd's 
command line. Do you have any suggestions how to deal with this? It happens 
with multipath-tools 0.4.8+git0.761c66f-10 on up to date Debian, kernel 
version 2.6.32.

Thanks,
-- 
cc
