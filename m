From: "goggin, edward" <egoggin@emc.com>
Subject: Direct syslog calls from multipathd
Date: Tue, 29 Mar 2005 16:05:48 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A882@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: 'Alasdair G Kergon' <agk@redhat.com>, 'Christophe Varoqui' <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

On Tue, 29 Mar 2005 00:48:55 +0200
christophe varoqui <christophe.varoqui@free.fr> wrote:
> A new snapshot should have poped up on the ftp (0.4.4-pre4).
> It contains an async logger thread for the daemon.
> 
> Edward, can you test if it solves the issues with direct 
> syslog call you
> spotted ?

Looks good.

After fixing my multipath.conf file device node blacklist to
specify "hdc" and "hdd" instead of just "hd", [:((]
I had three consecutive NDU test runs without hanging up on
synchronous syslog calls from multipathd.  Considering I
couldn't get one of these test runs to work before, I'd
consider the syslog deadlock problem fixed.

The bad news is that the first run hung up on the inode
deadlock involving bdget_disk() calls in the dm map
reload code path (__set_size, __lock_fs, or __unlock_fs)
one an inode which is already locked.  Also, the
multipathd died on the last of the 3 runs.  No idea what
was wrong.

I noticed you have changed multipath to allow concurrent
execution.  Was this done in order to not lose recovery
from i/o failure events in the waitevent and path test
failures in the checkerloop pthreads of multipathd?
