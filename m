From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] dm-log-userspace: fix memory leak on failure path in dm_ulog_tfr_init()
Date: Thu, 2 Oct 2014 11:57:31 -0500
Message-ID: <FEE6E0C5-985D-4DF1-AC42-8F4E0849195A@redhat.com>
References: <1412197115-32593-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1412197115-32593-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: dm-devel.ids

On Oct 1, 2014, at 3:58 PM, Alexey Khoroshilov <khoroshilov@ispras.ru> wrote:

> If cn_add_callback() fails in dm_ulog_tfr_init(), it does not
> deallocate prealloced memory but calls cn_del_callback().
> It looks like a misprint.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
