From: Matt Coleman <mcoleman@dattobackup.com>
Subject: dm-loop and kernel 3.x
Date: Wed, 8 Aug 2012 10:33:37 -0400
Message-ID: <FB767254-0A6B-42BF-92C7-0527F5329F84@dattobackup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
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
Cc: breeves@redhat.com
List-Id: dm-devel.ids

Hello,

I just tried (unsuccessfully) to apply the dm-loop patches to kernel 3.2.0. dm-bio-list-helpers.patch failed to apply because dm-bio-list.h no longer exists in the kernel tree. Is this an abandoned project, or were the changes incorporated into the kernel's existing loopback support? (...as hinted at here: http://www.redhat.com/archives/dm-devel/2012-February/msg00041.html)

Thanks,
Matt
