From: Ian Pilcher <arequipeno@gmail.com>
Subject: dm-cache: please check/repair metadata
Date: Wed, 7 Dec 2016 19:36:23 -0600
Message-ID: <o2adej$eaa$1@blaine.gmane.org>
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

I have a dm-cache device that throws the following error when I try to
create it:

  device-mapper: cache: 253:20: unable to switch cache to write mode 
until repaired.
  device-mapper: cache: 253:20: switching cache to read-only mode 

  device-mapper: table: 253:20: cache: Unable to get write access to 
metadata, please check/repair metadata.
  device-mapper: ioctl: error adding target to table 


How can I go about checking/repairing the metadata?

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
