From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm writecache: correct uncommitted_block when discarding
 uncommitted entry
Date: Wed, 17 Jun 2020 12:41:09 -0400
Message-ID: <20200617164108.GA12131@redhat.com>
References: <20200612155911.96528-1-yehs2007@zoho.com>
 <alpine.LRH.2.02.2006130839480.27500@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006130839480.27500@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Huaisheng Ye <yehs2007@zoho.com>, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

On Sat, Jun 13 2020 at  8:40am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Fri, 12 Jun 2020, Huaisheng Ye wrote:
> 
> > From: Huaisheng Ye <yehs1@lenovo.com>
> > 
> > When uncommitted entry has been discarded, correct wc->uncommitted_block
> > for getting the exact number.
> > 
> > Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
> 
> Acked-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> Also, add:
> Cc: stable@vger.kernel.org

I picked this up for 5.8 but I inverted the patch order because this
stable@ fix was dependent on the prior patch to skip waiting if in pmem
mode (due to locality of changes within same function).

See:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.8&id=39495b12ef1cf602e6abd350dce2ef4199906531

Mike
