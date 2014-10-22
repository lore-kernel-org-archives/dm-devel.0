From: Joe Thornber <thornber@redhat.com>
Subject: Re: [for-3.19 PATCH v2 01/17] dm bufio: switch from a
 huge hash table to an rbtree
Date: Wed, 22 Oct 2014 10:41:09 +0100
Message-ID: <20141022094109.GA26664@debian>
References: <20141017183119.GA31854@redhat.com>
	<1413571039-31986-1-git-send-email-snitzer@redhat.com>
	<alpine.LRH.2.02.1410211842110.10775@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1410211842110.10775@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, ejt@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 21, 2014 at 06:48:00PM -0400, Mikulas Patocka wrote:
> I wonder if we need this patch if it doesn't really help performance.

I wasn't concerned with performance.  I just thought it absurd that
bufio was evicting all my metadata yet using 8m per client for a hash
table.

- Joe
