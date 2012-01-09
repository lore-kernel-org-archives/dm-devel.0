From: Marcus Sorensen <marcus@acedatacenter.com>
Subject: dm thin provision, pool full
Date: Mon, 09 Jan 2012 16:36:48 -0700
Message-ID: <4F0B7A10.9030508@acedatacenter.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

You guys probably already know about this, but I was playing with kernel 
3.2.0 and the device mapper thin provisioned snapshots, and it doesn't 
seem like there is any sort of error implemented when the pool is full. 
I was running some write tests, and one of them just seemed to go into 
eternal D state. Checking iostat showed disks were idle. Running a 
'dmsetup status' returned the following:

thin: 0 41943040 thin 39832576 41943039
pool: 0 41943040 thin-pool 0 622/243968 81920/81920 -


that 81920/81920 is reporting data blocks in use/total blocks, correct?
