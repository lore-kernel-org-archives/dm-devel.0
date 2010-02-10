From: Mikulas Patocka <mpatocka@redhat.com>
Subject: patches for 2.6.33
Date: Wed, 10 Feb 2010 12:25:02 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1002101202400.30138@hs20-bc2-1.build.redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I went through the patches in Alasdair's patchset and tried to sort them 
for seriousness. These should be sent immediatelly (before 2.6.33):

dm-raid1-fail-writes-if-errors-are-not-handled-and-log-fails.patch # 76000
- fixes a regression introduced in 2.6.33-rc1
- should be sent to Linus before 2.6.33 goes out
- doesn't need to be applied to -stable

dm-raid1-fix-null-pointer-dereference-in-suspend.patch # 72253
- fixes a serious bug (crash) that existed even in previous kernels
- should be sent before 2.6.33 goes out
- should be sent to -stable

dm-stripe-avoid-divide-by-zero-with-invalid-stripe-count.patch # 76915
dm-snapshot-persistent-annotate-work_queue-as-on-stack.patch # 75065
- minor bugs, but the patches are very simple, so that they can be sent to 
Linus now, there is minimal change of breaking something

multipath patches
- let Kiyoshi Ueda decide, I am not familiar with mpath well enough

Mikulas
