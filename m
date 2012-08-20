From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] reworked dm-switch target
Date: Mon, 20 Aug 2012 21:48:57 +0100
Message-ID: <20120820204857.GA29183@agk-dp.fab.redhat.com>
References: <20120816070955.GA32526@agk-dp.fab.redhat.com>
	<C3B343EE19BD2940B6AEC40C9BE99426094C0C@AUSX10MPS302.AMER.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C3B343EE19BD2940B6AEC40C9BE99426094C0C@AUSX10MPS302.AMER.DELL.COM>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jim_Ramsay@dell.com
Cc: dm-devel@redhat.com, mpatocka@redhat.com, Jason_Shamberger@dell.com, Kevin_OKelley@dell.com
List-Id: dm-devel.ids

On Fri, Aug 17, 2012 at 02:18:15PM +0000, Jim_Ramsay@dell.com wrote:
>   dmsetup message switch 0 set-table 0-0:1 1-1:0 2-2:2 3-3:1 4-4:0 5-5:2 6-6:0 7-8:1 9-15:2 16-16:1 ... (plus almost 1000000 more arguments...)

Or 0,3,16:1 1,4:0 2,5:2 6:0 -8:1 -15:2
with three short-hands:
0-0 -> 0
6:0 7-8:1  -> 6:0 -8:1  (missing start of range assumes continues from last one)
0:0 3:0 -> 0,3:0 (list)

> an additional mechanism to upload larger chunks
> of binary data all at once would be important for our use of the device. 

The message mechanism could probably be extended to accept blobs of binary data
if parsing so many numbers turns out to be too inefficient.  Now we have an
example to work with, we can check the speed.

Alasdair
