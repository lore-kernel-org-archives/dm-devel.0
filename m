From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/7] dm-mpath: Fix a race condition in the blk-mq
	path
Date: Tue, 15 Nov 2016 15:31:53 -0800
Message-ID: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Mike,

The seven patches in this series is what I came up with while reviewing 
and testing the dm-mpath single queue and multiqueue code. It would be 
appreciated if these patches would be considered for inclusion in the 
upstream kernel.

Thanks,

Bart.
