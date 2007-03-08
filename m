From: Arnd Kleinbeck <arnd.kleinbeck@innoq.com>
Subject: server hangs up when writing to encrypted partition
Date: Thu, 8 Mar 2007 14:22:34 +0000 (UTC)
Message-ID: <loom.20070308T152003-460@post.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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


I just set up a new machine with debian sarge linux and built kernel 2.6.20.
Everything works fine until I write a big file (some GB) to an encrypted
partition. 
The curious thing is the system just hangs. No errors, no warnings, no logs.
The current shell and all open connections simply get stalled. Only the serial
console endlessly repeats 

     arcmsr0: abort device command of scsi id=0 lun=0

Seems to be the scsi controller...
For encryption I used cryptsetup 1.0.4 with LUKS support.

When I use the same partition formatted without encryption I have no 
problems at all.

Can somebody help me with that?

BR,
Arnd
