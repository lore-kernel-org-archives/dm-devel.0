From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] convert dm_ulog_request data to little endian
Date: Tue, 19 Aug 2014 19:58:57 -0500
Message-ID: <589E3349-24C0-4CBD-AA99-6F537BCDAAFB@redhat.com>
References: <1407459365-697-1-git-send-email-dmzhang@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1407459365-697-1-git-send-email-dmzhang@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Dongmao Zhang <dmzhang@suse.com>
List-Id: dm-devel.ids


On Aug 7, 2014, at 7:56 PM, Dongmao Zhang wrote:

> the dm_ulog_request might be little endian or big endian depending on
> the architecture. This is not right. This patch is to convert
> dm_ulog_request to little endian.
> 
> I met a bug when running cmirrord on s390 linux

This seems odd to me.  I don't understand why you would get a bug.  Do you have a mixed-architecture cluster?  Some x86-64 and the s390?  Otherwise, all operations should be in a format that is understood (unless there is a bug).

Also, you don't really need to translate the structure just to go to userspace.  Only the process that communicates between (potentially different architectures of) machines needs to do that.  That process is cmirrord and the code that should translate for that daemon is in lvm2/daemons/cmirrord/compat.c.

There could be a bug, but unless I'm not understanding right, we shouldn't need to switch endian in the kernel.

 brassow
