From: Brian Bunker <brian@purestorage.com>
Subject: different LUN numbers under the same dm device
Date: Wed, 6 Jun 2012 12:27:57 -0700
Message-ID: <8DCD6D08-35CE-48CC-AC54-7436265C32CB@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset="us-ascii"
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

Our company produces a multiple port Fibre Channel storage array. We are continually plagued by this problem. We get a dm device which combines paths for different LUN's. We would like to understand why this is happening. Wouldn't this problem almost certainly lead to a data corruption?

Thanks,
Brian

3624a93700a14254d729923840001000b dm-11 PURE,FlashArray
size=500G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 1:0:0:12 sde  8:64   failed faulty running
  |- 0:0:0:12 sdd  8:48   failed faulty running
  |- 0:0:0:10 sdar 66:176 active ready  running
  `- 1:0:0:10 sdba 67:64  active ready  running

Of the 4 paths to dm-11, we can see two paths are for LUN 10 and the other two are for LUN 12. We have 24 other dm devices which have only the expected 2 paths. 

Brian Bunker
brian@purestorage.com
