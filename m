From: Tejun Heo <tj@kernel.org>
Subject: Re: [Bcache v13 03/16] Revert "rw_semaphore: remove
 up/down_read_non_owner"
Date: Tue, 15 May 2012 09:38:32 -0700
Message-ID: <20120515163832.GE17216@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <3f51ec3e69b8f471e2d1cc539f01504e2b903fed.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3f51ec3e69b8f471e2d1cc539f01504e2b903fed.1336619038.git.koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, May 09, 2012 at 11:08:49PM -0400, Kent Overstreet wrote:
> This reverts commit 11b80f459adaf91a712f95e7734a17655a36bf30.
>
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

Please cc Christoph and Al and justify why it needs to be reverted.

Thanks.

--
tejun
