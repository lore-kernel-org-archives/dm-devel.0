From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/7] lib/vsprintf: add %*pg format specifier
Date: Tue, 31 Mar 2015 10:37:14 -0700
Message-ID: <1427823434.10376.33.camel@perches.com>
References: <1427817681-4494-1-git-send-email-dmonakhov@openvz.org>
	 <1427817681-4494-2-git-send-email-dmonakhov@openvz.org>
	 <1427821576.10376.29.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427821576.10376.29.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 2015-03-31 at 10:06 -0700, Joe Perches wrote:
> On Tue, 2015-03-31 at 20:01 +0400, Dmitry Monakhov wrote:
> > This allow to directly print block_device name.
> > Currently one should use bdevname() with temporal char buf[BDEVNAME_SIZE].
> > This is very ineffective because bloat stack usage for deep IO call-traces

Perhaps it would be useful to update the disk_name/bdevname
functions to take a buffer length along with the char * so
that buffer overflows could not occur.

That would also allow this function to use bdevname directly.
