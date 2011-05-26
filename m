From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] Remove the spinlock protecting the pages
 allocation
Date: Thu, 26 May 2011 13:52:31 +0100
Message-ID: <1306414351.3179.2.camel@ubuntu>
References: <Pine.LNX.4.64.1105191257430.17915@hs20-bc2-1.build.redhat.com>
	<1306141147.3404.4.camel@ubuntu>
	<Pine.LNX.4.64.1105260848230.25456@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1105260848230.25456@hs20-bc2-1.build.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, 2011-05-26 at 08:50 -0400, Mikulas Patocka wrote:
> There is another spinlock, kc->job_lock, that is taken each time
> someone 
> pushes or pops some work for the worker thread.
> 
> Once we take kc->job_lock, we guarantee that any written memory is 
> visible to the other CPUs. 

Good, thanks.
