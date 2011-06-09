From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module	throttle
	structure
Date: Thu, 9 Jun 2011 17:27:27 +0100
Message-ID: <20110609162727.GE13427@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<20110601095106.GA3718@ubuntu>
	<Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
	<20110603110111.GA4969@ubuntu>
	<Pine.LNX.4.64.1106071321300.8279@hs20-bc2-1.build.redhat.com>
	<20110609094746.GA3152@ubuntu>
	<Pine.LNX.4.64.1106091136510.7642@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106091136510.7642@hs20-bc2-1.build.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Joe Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 09, 2011 at 12:08:08PM -0400, Mikulas Patocka wrote:
> 8 sub jobs --- 76MB/s
> 2 sub jobs --- 74MB/s

Interesting data point: In your set up, the extra 6 sub jobs bring
little benefit.

Alasdair
