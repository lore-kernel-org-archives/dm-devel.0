From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Thu, 9 Nov 2006 23:24:38 +0000
Message-ID: <20061109232438.GS30653@agk.surrey.redhat.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<200611092218.58970.rjw@sisk.pl> <20061109214159.GB2616@elf.ucw.cz>
	<200611092321.47728.rjw@sisk.pl> <20061109231146.GD2616@elf.ucw.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061109231146.GD2616@elf.ucw.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, Eric Sandeen <sandeen@redhat.com>, Nigel Cunningham <nigel@suspend2.net>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 10, 2006 at 12:11:46AM +0100, Pavel Machek wrote:
> ? Not sure if I quite understand, but if dm breaks sync... something
> is teribly wrong with dm. And we do simple sys_sync()... so I do not
> think we have a problem.
 
If you want to handle arbitrary kernel state, you might have a device-mapper
device somewhere lower down the stack of devices that is queueing any I/O
that reaches it.  So anything waiting for I/O completion will wait until 
the dm process that suspended that device has finished whatever it is doing
- and that might be a quick thing carried out by a userspace lvm tool, or
a long thing carried out by an administrator using dmsetup.

I'm guessing you need a way of detecting such state lower down the stack
then optionally either aborting the operation telling the user it can't be
done at present; waiting for however long it takes (perhaps for ever if
the admin disappeared); or more probably skipping those devices on a 
'best endeavours' basis.

I'm suggesting sysfs or something built on bd_claim might offer a mechanism 
for traversing the stack.

Alasdair
-- 
agk@redhat.com
