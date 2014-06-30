From: Joe Thornber <thornber@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-io: Prevent the danging point of the sync
 io callback function
Date: Mon, 30 Jun 2014 09:21:44 +0100
Message-ID: <20140630082143.GA3098@debian>
References: <1403841690-4401-1-git-send-email-huangminfei@ucloud.cn>
 <20140627151105.GA30592@debian>
 <alpine.LRH.2.02.1406271432430.18515@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1406271432430.18515@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, snitzer@redhat.com, linux-kernel@vger.kernel.org, Minfei Huang <huangminfei@ucloud.cn>, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Fri, Jun 27, 2014 at 02:44:41PM -0400, Mikulas Patocka wrote:
> I suggest - split it to two patches, a minimal patch that fixes the bug by 
> changing sleeper to completion and the second patch with remaining changes 
> - so that only the first patch can be backported to stable kernels.

Agreed.  Thanks for reviewing.
