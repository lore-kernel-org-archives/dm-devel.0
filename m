From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/7] multipathd: Fix race conditions related to
 thread termination
Date: Mon, 15 Aug 2016 08:24:06 -0700
Message-ID: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Christophe,

As you may already have noticed the code in multipathd for terminating 
worker threads triggers several race conditions. It would be appreciated 
if you could review and/or apply the following seven patches that fix 
these race conditions:

0001-multipathd-fix-memory-allocation-logic-error-for-pol.patch
0002-libmultipath-Remove-a-data-structure-that-has-been-c.patch
0003-libmultipath-Remove-debugging-code-from-lock.h.patch
0004-libmultipath-Convert-lock-and-unlock-into-inline-fun.patch
0005-libmultipath-Inline-mutex-in-struct-mutex_lock.patch
0006-libmultipath-Introduce-timedlock.patch
0007-multipathd-Remove-a-busy-waiting-loop.patch

Thanks,

Bart.
