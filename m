From: Roberto Giordani <r.giordani@libero.it>
Subject: Multipathd on Opensuse 11.4 x64 buffer overwflow when
 starting with -D args too
Date: Tue, 05 Jul 2011 22:21:06 +0200
Message-ID: <4E137232.8030603@libero.it>
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
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,
as described on Bug 693131

the

+ARGS="-d &>/dev/null &"

workaround doesn't work for me. :-(

I've tried to build the last multipath.tools 0.4.9 on Opensuse 11.4 x64
and the build seems ok, but after run
multipathd the system hang for few seconds and than fails.

I've tried to build RPMs too, but I have received an error when try to
use library on /lib and not on /lib64.
Changing the path on the Makefile I've  receive another error.

Could someone help me, because on opensuse 11.2 and 11.3 the multipath
works fine.

Regards,
Roberto.
