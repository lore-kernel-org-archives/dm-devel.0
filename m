From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: restart multipathd automatically
Date: Tue, 29 Jan 2008 11:39:06 -0800
Message-ID: <20080129193906.GB27870@linux.vnet.ibm.com>
References: <200801211454.m0LEs2p15801@tug.org>
	<20080129100445.GD15191@percy.comedia.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080129100445.GD15191@percy.comedia.it>
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

Luca Berra <bluca@comedia.it> wrote:
> On Mon, Jan 21, 2008 at 03:54:02PM +0100, Stephen Mike wrote:
>> Hi,
>>
>> To restart multipathd automatically after it dies, is it ok to put, in
>> /etc/inittab, a line like this? 
>> # run multipathd at level 4 (restart)
>> mphd:4:respawn:/etc/rc.d/init.d/multipathd start
>>
> no, it is not.

To add a little (hopefully)...

If multipathd is dieing it is better to determine why it is dieing.

Running multipathd in foreground mode with verbosity may provide info.
"/sbin/multipathd -d -v4"

If the issue is multipathd causing a segfault you would need to build a
non-strip version and then use ulimit -c unlimited to allow creation of a
core file.

You could then use gdb post getting a segfault to run "bt full" on the
core file to hopefully determine the area of the problem.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
