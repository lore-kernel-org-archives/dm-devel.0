From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V2] dm-raid: fix updating of max_discard_sectors limit
Date: Wed, 11 Sep 2019 09:43:48 -0400
Message-ID: <20190911134348.GB32121@redhat.com>
References: <20190911113133.837-1-ming.lei@redhat.com>
 <20190911133523.GA32121@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190911133523.GA32121@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: dm-devel@redhat.com, stable@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Sep 11 2019 at  9:35am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> FYI, I added a "Fixes:" tag to the commit header and switched to
> shifting by SECTOR_SHIFT instead of 9, staged commit for 5.4 is here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.4&id=509818079bf1fefff4ed02d6a1b994e20efc0480

I just fixed a few typos in your patch header, so updated commit is:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.4&id=2b7aa6bde032c56e00245ed438922529251c9e13
