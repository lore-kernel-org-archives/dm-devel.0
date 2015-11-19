From: vaLentin chernoZemski <valentin@siteground.com>
Subject: lvremove kernel BUG at drivers/md/dm-bufio.c:1494!
Date: Thu, 19 Nov 2015 17:14:08 +0200
Message-ID: <564DE740.3040104@siteground.com>
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
To: dm-devel@redhat.com
Cc: SiteGround Operations <operations@siteground.com>
List-Id: dm-devel.ids

Hi folks,

It seems that there is a bug in the linux kernel in any release from

  - 2.6.32-573.3.1.el6.x86_64 - crash
  - 3.12.49 + msg00123 patch - crash / D state
  - 4.1.6 - lv* operations in D state after bug is hit
  - 4.1.12 + f11a82caf / b0dc3c8bc15 - lv* operations in D state after 
bug is hit
  - 4.2.5 - lv* operations in D state after bug is hit
  - 4.3.0-rc7-vanilla1

The bug is described in details and stack traces in RedHat's bugzilla 
under id 1219634:

https://bugzilla.redhat.com/show_bug.cgi?id=1219634

For some reason it is marked as private but I guess you have access to 
this one.

Issue is present in current latest RHEL version and all vanilla kernels 
I tested with multiple patches specified in the bug.

Even I can not provide you with exact reproducer it happens often enough 
on a fleet of machines we have that perform certain tasks and we can 
easily test new patches or provide you with specific information upon 
request from all crash dumps we reliably collected and still collecting 
from all kernel versions tested.

I got advised by Mike Snitzer to dm-devel so here it is.

Let us know if there is anything we can do to assist you further.

Regards,

vaLenitn
