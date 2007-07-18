From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: factor out bio_check_eod()
Date: Wed, 18 Jul 2007 21:34:53 +0900
Message-ID: <469E08ED.3020307@gmail.com>
References: <20070530093503.GA15559@kernel.dk> <20070718105655.GB22374@htj.dyndns.org> <20070718105946.GC22374@htj.dyndns.org> <20070718110619.GM11657@kernel.dk> <469DF700.4030806@gmail.com> <20070718113103.GO11657@kernel.dk> <469DFA75.6070205@gmail.com> <20070718113450.GP11657@kernel.dk> <469DFC61.2070301@gmail.com> <20070718114558.GR11657@kernel.dk> <20070718114955.GS11657@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070718114955.GS11657@kernel.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

Jens Axboe wrote:
>> somewhat annoying, I'll see if I can prefix it with git-daemon in the
>> future.
> 
> OK, now skip the /data/git/ stuff and just use
> 
> git://git.kernel.dk/linux-2.6-block.git

Alright, it works like a charm now.  Thanks.

-- 
tejun
