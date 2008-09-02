From: Andy <genanr@emsphone.com>
Subject: hctl from device name or major/minor
Date: Tue, 2 Sep 2008 13:13:33 -0500
Message-ID: <20080902181333.GA29085@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

	What is the best way to get the hctl from the device name or major/minor
pair?  Specificly for use in a prio_callout program for multipath?  Is there
an API interface in the device mapper of sysfs libraries I should use to get
this information or should I just scan the appropriate /sys directory? 
Currently I just have a simple shell script to give me the path priority I
need, but would like to make it a c program.

Thanks,

Andy
