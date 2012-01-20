From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin vs lvm performance
Date: Fri, 20 Jan 2012 18:07:21 +0000
Message-ID: <20120120180721.GB12920@ubuntu>
References: <1326416116.56981.YahooMailNeo@web36404.mail.mud.yahoo.com>
	<20120116124158.GA4426@ubuntu>
	<1326915054.99335.YahooMailNeo@web36407.mail.mud.yahoo.com>
	<20120120170335.GA10518@ubuntu> <20120120173333.GA12920@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120120173333.GA12920@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jagan Reddy <gjmsreddy@yahoo.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Jagan,

On Fri, Jan 20, 2012 at 05:33:34PM +0000, Joe Thornber wrote:
> Back to testing ...

Here are my aio-stress results for various devices running on top of a
ramdisk:

| Device stack           | M/s  | 
+------------------------+------+  
| raw ramdisk            | 5440 |
| linear                 | 5431 |
| 2 stacked linear       | 5304 |
| pool device            | 5351 |
| linear stacked on pool | 5243 |
| thin                   | 5375 |

I also tried the thin test after disabling the block locking in
dm-block-manager.c, and using a 128 entry cache local to the thin
device.  Neither made any difference to the 'thin' result.

Things for you to check:

i)  Are you benchmarking with a ramdisk, or your flash device?  In both
    cases I think you need to make sure the device has allocated backing
    store before you run any tests.  Remember that Discards may well
    removing this backing.

ii) You claim that io is getting deferred.  This will happen when you do
    the initial wipe of the thin device to force provisioning.  But for
    the aio-stress tests you should get nothing deferred (I instrumented
    to confirm this).


- Joe
