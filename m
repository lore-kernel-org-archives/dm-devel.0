From: Ross Anderson <rosander@dsotm.net>
Subject: partx fails 4096 block size
Date: Mon, 15 Sep 2014 14:48:23 -0500
Message-ID: <54174287.30508@dsotm.net>
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

Greetings,

I posted a similar error a while back. This is using multipath tools 
from GIT as of today. kernel version 3.10.49.

Devices are 4k GPT partition created under windows.

They are running SFS file system (cluster multi os)

udev detects individual paths and they are fully functional.

Multipath creates primary dm-0 devices and alias links however no 
partition point is created. Error output is very limited.

I'd appreciate any help in troubleshooting this. Quiet frustrating not 
being able to use mpath on 4k blocks.

http://pastebin.com/EbTMXdvE

Thanks,
Ross
