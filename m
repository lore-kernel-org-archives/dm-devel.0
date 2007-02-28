From: Dave Wysochanski <dwysocha@redhat.com>
Subject: Re: Multipath pathcheck behavior
Date: Wed, 28 Feb 2007 14:58:51 -0500
Message-ID: <1172692731.4270.39.camel@linux-cxyg.rtp.netapp.com>
References: <1D80D4F6D179BD4D869FE807A5BF8336D34668@EXCNYSM0A1AN.nysemail.nyenet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1D80D4F6D179BD4D869FE807A5BF8336D34668@EXCNYSM0A1AN.nysemail.nyenet>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2007-02-28 at 14:31 -0500, Romanowski, John (OFT) wrote:
> Hi list,
> multipath-tools tests the LUN paths every "polling_interval" (default 5
> secs) for failover/failback purposes.
> 
> My question is: 
> Does it omit testing paths that have completed I/O's in the past 5 secs?
> or does it test paths every 5 secs regardless of recent I/O's on the
> path?

It tests regardless of I/O completion.
