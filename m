From: George Shuklin <george.shuklin@gmail.com>
Subject: Why all raid devices do have zero 'time in queue' value?
Date: Sun, 11 Mar 2012 02:33:34 +0400
Message-ID: <4F5BD6BE.7020405@gmail.com>
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

Good day.

I've look to stat for all MD devices I have (raid0, raid1, raid10) - all 
of them reports 0 for time_in_queue field in /sys/block/mdX/stat file.

Is any reason why all raid devices contains no information about time 
spent on requests processing?

Thanks.
