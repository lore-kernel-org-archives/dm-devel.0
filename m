From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] dm: allow error target to replace
	immutable target
Date: Thu, 29 Aug 2013 10:44:33 -0400
Message-ID: <20130829144433.GA12858@redhat.com>
References: <1377746464-2437-1-git-send-email-snitzer@redhat.com>
	<1377746464-2437-3-git-send-email-snitzer@redhat.com>
	<alpine.LRH.2.02.1308291036390.20142@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1308291036390.20142@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 29 2013 at 10:37am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> As I said - I think it would be better to remove the immutable flag than 
> to create more flags to bypass it.

Immutable was introduced to prevent dangerous scenarios that weren't
accounted for in original design, etc.  It solved your crash when you
rep;aced a thin-pool with an empty table.

immutable is staying for now.  And as it turns out allowing error target
to override an immutable target was always held to be a logical/possible
future relaxation of the immutable constraint.

Mike
