From: Joe Jin <joe.jin@oracle.com>
Subject: Re: [PATCH] dm: allow error target to replace either bio-based and
 request-based targets
Date: Fri, 23 Aug 2013 09:06:00 +0800
Message-ID: <5216B578.5050506@oracle.com>
References: <5214CC25.1070307@oracle.com> <alpine.LRH.2.02.1308211041180.10797@file01.intranet.prod.int.rdu2.redhat.com> <52157C6E.6080406@oracle.com> <20130822201900.GB22556@redhat.com> <20130823001750.GA29366@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130823001750.GA29366@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 08/23/13 08:17, Mike Snitzer wrote:
> Here is a patch that should work for your needs (I tested it to work
> with 'dmsetup wipe_table' on both request-based and bio-based devices):

This really what I looking for, thanks!

> 
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Thu, 22 Aug 2013 18:21:38 -0400
> Subject: [PATCH] dm: allow error target to replace either bio-based and request-based targets
> 
> In may be useful to switch a request-based table to the "error" target.
> Enhance the DM core to allow a single hybrid target to be capable of
> handling either bios or requests.
> 
> Add a request-based (.map_rq) member to the error target_type and train
> dm_table_set_type() to prefer the md's established type (request-based
> or bio-based).  If the md doesn't have an established type default to
> making the hybrid target bio-based.

Signed-off-by: Joe Jin <joe.jin@oracle.com>

Thanks,
Joe
