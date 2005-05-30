From: Hauke Laging <mailinglisten@hauke-laging.de>
Subject: Limit on device bandwidth possible?
Date: Tue, 31 May 2005 01:35:38 +0200
Message-ID: <200505310135.38629.mailinglisten@hauke-laging.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hello,

I have not found anything about this on the web and in Usenet so I ask 
here:

Is there any way to limit the speed of a block device in software? I 
imagine this would be pretty cool for backups on a stand-alone 
workstation. Today the many disk accesses during the backups slow down my 
system too much. I have been told that the kernel cannot reduce the "I/O 
priority" of a task to handle this effect.

I think it would be a nice solution if an LVM snapshot volume was created 
with an option like "limit throughput to n MB/s (or n% of maximum)". There 
is something similar for network interfaces. It cannot be so difficult. 
Especially when using snapshot volumes you don't have to care from a data 
consistency perspective about the backup taking much longer.


Best regards,

Hauke
