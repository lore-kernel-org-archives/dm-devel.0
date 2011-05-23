From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] Remove the spinlock protecting the pages
 allocation
Date: Mon, 23 May 2011 09:59:07 +0100
Message-ID: <1306141147.3404.4.camel@ubuntu>
References: <Pine.LNX.4.64.1105191257430.17915@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1105191257430.17915@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, 2011-05-19 at 12:58 -0400, Mikulas Patocka wrote:
> The spinlock is only taken on initialization or from single-threaded
> workqueue.
> Therefore, the spinlock is useless. 

The spinlock has memory barrier semantics as well.  How are you
guaranteeing the changes from the initialisation thread are visible in
the workqueue thread?

- Joe
