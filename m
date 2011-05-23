From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] Fix a possible dm-kcopyd deadlock -
 preallocate sub jobs
Date: Mon, 23 May 2011 10:29:06 +0100
Message-ID: <1306142946.3404.8.camel@ubuntu>
References: <Pine.LNX.4.64.1105191250440.17915@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1105191250440.17915@hs20-bc2-1.build.redhat.com>
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

Hi Mikulas,

On Thu, 2011-05-19 at 12:55 -0400, Mikulas Patocka wrote:
> Hi
> 
> Here I'm sending some patches for kcopyd. This first one fixes a 
> treoretical deadlock, the other patches are a code cleanup (removing
> some 
> "magic" numbers in mempool resrvations).
> 
> Later, I will follow with patches that rework page reservations. 

These look good.  I've merged them into my multisnap tree so they'll get
some testing.

- Joe
