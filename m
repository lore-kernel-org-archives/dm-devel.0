From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-io: reserve just one structure
Date: Mon, 23 May 2011 10:05:07 +0100
Message-ID: <1306141507.3404.6.camel@ubuntu>
References: <Pine.LNX.4.64.1105191256010.17915@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1105191256010.17915@hs20-bc2-1.build.redhat.com>
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

On Thu, 2011-05-19 at 12:57 -0400, Mikulas Patocka wrote:
> One structure is enough to process the whole
> request, so it's ok. 

While this is enough to guarantee progress, it doesn't address the
question of how fast that progress is.
