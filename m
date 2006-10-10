From: Eli Stair <estair@ilm.com>
Subject: Re: Failover between two paths to one LU doesn't work
	onlinux-iscsi
Date: Tue, 10 Oct 2006 10:24:56 -0700
Message-ID: <452BD768.30206@ilm.com>
References: <452BD5C6.2080808@voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <452BD5C6.2080808@voltaire.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


What versions of the tools and kernel are you running?  What are your 
settings for multipath.conf?  Is multipathd running?  If you run 
multipath -v2 manually, does it fail the path?  Etc.

> 1. Are there any known problems that can cause fail-over not to happen
> in linux-iscsi?

> 2. Is there any way to get debug information in order to understand more
> in-depth what's going on?

man multipath && man multipathd
multipathd -d
multipath -v4

> 3. How can I know what the timeouts are and how to change them?

Timeouts occur at several levels.  Your HBA or iSCSI driver will have 
(at least) one.  Check the documentation for the aspects of 
software/hardware you're using (kernel module options), dm-multipath 
docs, etc.

> 4. If you need more specific information, please write what can help.

http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=Home

I've never done multipath-iscsi, so don't have direct experience.  Try 
posting some more detailed info on your setup and what errors or info 
messages are occuring.


/eli
