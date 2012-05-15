From: Tejun Heo <tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Bcache v13 03/16] Revert "rw_semaphore: remove
 up/down_read_non_owner"
Date: Tue, 15 May 2012 09:37:34 -0700
Message-ID: <20120515163734.GD17216@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <3f51ec3e69b8f471e2d1cc539f01504e2b903fed.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3f51ec3e69b8f471e2d1cc539f01504e2b903fed.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, May 09, 2012 at 11:08:49PM -0400, Kent Overstreet wrote:
> This reverts commit 11b80f459adaf91a712f95e7734a17655a36bf30.
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Please cc Christoph and Al and justify why it needs to be reverted.

Thanks.

-- 
tejun
