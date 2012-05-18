From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/13] dm: kill dm_rq_bio_destructor
Date: Fri, 18 May 2012 08:57:29 -0700
Message-ID: <20120518155729.GB19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <f07bc0f57562d98078e0f4c507cae165aa159e7c.1337308722.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f07bc0f57562d98078e0f4c507cae165aa159e7c.1337308722.git.koverstreet@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

On Thu, May 17, 2012 at 10:59:49PM -0400, koverstreet@google.com wrote:
> From: Kent Overstreet <koverstreet@google.com>
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

Please explain why this is done and how it's safe.  Alasdair / dm
folks, can you please ack this?

Thanks.

-- 
tejun
