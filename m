From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC] How to fix system stall on root volume multipath
Date: Fri, 09 Nov 2007 18:17:19 -0500 (EST)
Message-ID: <20071109.181719.115904569.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi,

If we use multipath for "/", temporal all-paths failure could lead to
system stall because multipathd depends on callout programs on "/".
I would like to hear your comments about my idea to fix it.

For example, the script below causes system stall on the following
environmnt.
  o "/" on a multipath device
  o setting 'no_path_retry = queue'
  o using priority callout (If your storage doesn't have priority
    callout, using "/bin/echo 1" should be fine for testing.)
-----------------------------------------------------------------
#!/bin/sh

# specify all paths for your root filesystem
paths="sdd sdg"

while true; do
	for dev in $paths; do
		echo offline > /sys/block/${dev}/device/state
	done

	for dev in $paths; do
		echo running > /sys/block/${dev}/device/state
	done
done
-----------------------------------------------------------------
This is because the path checker thread stalls on executing
the priority callout and revived paths aren't reinstated.


To fix it, my proposal is to build all priority callouts into
multipathd as library functions like path checkers.
(But keep the feature to use external priority callouts as an option.)

Although the proposal doesn't work if target device for down/up path
is deleted/added because getuid callouts are used for path addition,
the target device deletion can be controlled by the "dev_loss_tmo"
parameter of transport layer.
Also, source codes of getuid callouts are outside of multipath-tools.
So I think making only all priority callouts built-in is enough now.


Ideally, multipathd shouldn't do file I/Os nor get memory after started.
I think the proposal above is the first step for the ideal multipathd.
What do you think about it?

Thanks,
Kiyoshi Ueda
