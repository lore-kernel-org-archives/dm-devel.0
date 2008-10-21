From: dwu <dwu@redhat.com>
Subject: a question about multipathd and udev
Date: Tue, 21 Oct 2008 16:17:17 +0800
Message-ID: <48FD900D.2010709@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

If a block device is added, the udev will run the command multipath to 
add the path to the mp if possible.
Why multipathd also process a path addition event:
 (!strncmp(uev->action, "add", 3)) {
        r = uev_add_path(devname, vecs);
        goto out;
    }

Thanks.
