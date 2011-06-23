From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-kcopyd: optionally zero an area
	instead	of copying
Date: Thu, 23 Jun 2011 15:34:01 +0100
Message-ID: <20110623143401.GE7497@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1106081753570.7811@hs20-bc2-1.build.redhat.com>
	<20110609100429.GE3152@ubuntu>
	<Pine.LNX.4.64.1106091136040.7642@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106091136040.7642@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com, Joe Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 09, 2011 at 11:36:44AM -0400, Mikulas Patocka wrote:
> Here it is ... but it duplicates some code in dm_kcopyd_copy..
 
Obviously I don't want the duplication:)

Presumably a wrapper function with the first patch will suffice?

Alasdair
