From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Handle error paths.
Date: Thu,  8 Jan 2009 14:25:03 -0500
Message-ID: <1231442704-19032-1-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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


On memory constrained systems, where a large amount of LUNs are
assigned (say more enough to make multipath blossom to 70% of available
memory space) forking would fail returning -ENOMEM. The kernel has enough
free pages for the new process, but when it clones the new child process
from the parent process space it accounts the parent process heap space
against the child (which counts for more pages than there are free pages).

Using vfork passes a flag to clone which will inhibit this calculation
and instead check for free pages. The danger in using vfork is that the child
could use the values from the parent, but fortunatly we don't do that and
immediately call 'execve' swipping the process space free.
