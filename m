From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] dm: give req_size precisely given by user
Date: Tue, 18 Dec 2018 10:45:35 -0700
Message-ID: <01a60138-63ab-6a9d-c0ba-b8fea551b14e@kernel.dk>
References: <20181218172537.12300-1-jaegeuk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181218172537.12300-1-jaegeuk@kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc: stable@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 12/18/18 10:25 AM, Jaegeuk Kim wrote:
> This patch makes dm be aware of io_pages to assign sane req_size for reads.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe
