From: Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH V10 03/19] block: use bio_for_each_bvec() to compute
 multi-page bvec count
Date: Fri, 16 Nov 2018 17:41:47 +0800
Message-ID: <a0105f7a-95b2-3a42-1543-3e8b999edb30@huawei.com>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-4-ming.lei@redhat.com> <20181115202028.GC9348@vader>
 <20181115210510.GA24908@redhat.com> <20181115221847.GD9348@vader>
 <20181116091956.GA17604@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181116091956.GA17604@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Omar Sandoval <osandov@osandov.com>, Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>
List-Id: dm-devel.ids


On 2018/11/16 17:19, Christoph Hellwig wrote:
> On Thu, Nov 15, 2018 at 02:18:47PM -0800, Omar Sandoval wrote:
>> My only reason to prefer unsigned int is consistency. unsigned int is
>> much more common in the kernel:
>>
>> $ ag --cc -s 'unsigned\s+int' | wc -l
>> 129632
>> $ ag --cc -s 'unsigned\s+(?!char|short|int|long)' | wc -l
>> 22435
>>
>> checkpatch also warns on plain unsigned.
> 
> Talk about chicken and egg.  unsigned is perfectly valid C, and being
> shorter often helps being more readable.  checkpath is as so often
> wrongly opinionated..
> 

sigh...I personally tend to use "unsigned" instead of "unsigned int" as well,
but checkpatch.pl also suggests erofs to use "unsigned int" :-(

Thanks,
Gao Xiang
