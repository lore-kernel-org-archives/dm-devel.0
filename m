From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm
	resume	ioctl.
Date: Fri, 19 Mar 2010 12:27:22 +0000
Message-ID: <20100319122722.GC919@agk-dp.fab.redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<4BA34722.9030306@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4BA34722.9030306@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 19, 2010 at 10:42:58AM +0100, Hannes Reinecke wrote:
> No need to fiddle around with events here. It'll
> just serve to confuse userspace.
 
Userspace is already well-confused and doing things that look silly from
a high-level viewpoint and none of the potential solutions we've
proposed to the various problems has been acceptable yet.

So we widened the scope of our thinking, and suggested if we just break
this kobject/uevent connection in the kernel, it might give us easy
solutions to several of the seemingly-intractable
userspace-processing-of-uevent problems at once.

Alasdair
